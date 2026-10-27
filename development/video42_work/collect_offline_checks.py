"""Collect the completed C42 checks, preserving each check's actual scope."""
from datetime import datetime, timezone
import csv
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[2]
WORK = ROOT / 'development/video42_work'
PROJECT = ROOT / 'development/player_video42_sdram100'
VERIFY = PROJECT / 'verification'
SOURCE = PROJECT / 'src/user_source/hdl_source'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))


def refs(paths):
    return [{'path': p.relative_to(ROOT).as_posix(), 'sha256': sha(p)} for p in paths]


def contains(path, *markers):
    text = path.read_text(encoding='utf-8-sig', errors='replace')
    for marker in markers:
        assert marker in text, (str(path), marker)
    return text


binding = load(VERIFY / 'final_stage_binding.json')
assert binding['status'] == 'PASS'
gate = VERIFY / 'final_routed.v'
gate_sha = sha(gate)
route_sha = sha(PROJECT / 'build/manual/AC201_tf_hdmi_pr.db')
assert route_sha == binding['stages']['hold']['artifacts']['AC201_tf_hdmi_pr.db']
checks, ablations = [], []


def add(name, scope, inputs, evidence, *, negative=False, routed=False, **details):
    entry = dict(name=name, status='EXPECTED_FAILURE' if negative else 'PASS',
                 scope=scope, inputs=refs(inputs), evidence=refs(evidence), **details)
    if routed:
        entry.update(source_kind='final_routed_gate',
                     final_routed_netlist_sha256=gate_sha,
                     final_routed_db_sha256=route_sha)
    (ablations if negative else checks).append(entry)


for run, name, words, refreshes in [
    ('run_C42_20261027_221201', 'routed_memory_data', 4352, 6),
    ('run_C42_20261027_221527', 'routed_memory_short_bursts', 460, 3),
]:
    folder = WORK / 'memory_bench' / run
    result = load(folder / 'result.json')
    manifest = load(folder / 'source_binding.json')
    assert result['overall_pass'] and result['model_timing_error_count'] == 0
    assert manifest['original_gate_sha256'] == gate_sha
    assert manifest['routed_netlist'] and manifest['mem_period_ns'] == 10
    assert manifest['shifted_clock_ns'] == 8 and manifest['capture_mode'] == 2
    assert not manifest['inject_read_bit_error']
    assert manifest['simulation_ack_stage0_edge_override'] == 0
    for filename, key in [('tb_memory_gate.sv', 'bench_sha256'),
                          ('eg_phy_sdram_model.v', 'device_shell_sha256'),
                          ('IS42s32200.v', 'device_model_sha256'),
                          ('runner.ps1', 'runner_sha256')]:
        assert sha(folder / filename) == manifest[key].lower(), (run, filename)
    text = contains(folder / 'run.log', 'INIT_SEQUENCE_PASS pre=1 mrs=1 aref=2',
             f'DATA_SCOREBOARD_PASS writes={words} reads={words} returns={words}',
             f'req_rises={refreshes} ack_rises={refreshes} aref_commands={refreshes}')
    assert not re.search(r'ERROR:|\*\*\s+(?:Fatal|Error)', text, re.I), run
    with (folder/'command_trace.csv').open(encoding='utf-8-sig', newline='') as stream:
        command_rows = list(csv.DictReader(stream))
    write_addresses = {int(row['wraddr'], 16) for row in command_rows if row['wr'] == '1'}
    read_addresses = {int(row['rdaddr'], 16) for row in command_rows if row['rd'] == '1'}
    assert write_addresses == read_addresses == set(range(words)), run
    add(name,
        'Complete final routed netlist with vendor PAD and APUG IS42 bus model using EM638325 timing values; forced application/clock/reset, accelerated power counter, no SDF. Controller/SDRAM data interface only.',
        [gate, folder/'tb_memory_gate.sv', folder/'eg_phy_sdram_model.v', folder/'IS42s32200.v', folder/'runner.ps1'],
        [folder/'source_binding.json', folder/'result.json', folder/'run.log', folder/'command_trace.csv'],
        routed=True, writes=words, reads=words, returns=words,
        application_burst_words=manifest['burst_words'], periodic_aref_commands=refreshes,
        unique_application_addresses=words, application_address_min=0, application_address_max=words-1)

for run, name, marker in [
    ('run_C42_20261027_222536', 'single_sample_bit_flip', 'strict production capture scoreboard mismatch'),
    ('run_C42_20261027_222654', 'previous_word_alignment', 'strict raw-previous scoreboard mismatch'),
]:
    folder = WORK / 'memory_bench' / run
    result, manifest = load(folder/'result.json'), load(folder/'source_binding.json')
    assert manifest['original_gate_sha256'] == gate_sha
    assert result['init_status'] == 'PASS' and result['model_timing_error_count'] == 0
    assert not result['overall_pass']
    text = contains(folder/'run.log', marker)
    if name == 'single_sample_bit_flip':
        assert result['negative_control_detected'] and result['single_sample_corruption_verified']
        assert 'raw_current=768 raw_previous=0 production_capture=767 total=768 mode=2' in text
        scope = 'Scoreboard sensitivity: flip one bit in one observed sample; production gate and physical DQ remain unchanged.'
    else:
        assert 'raw_current=768 raw_previous=0 production_capture=768 total=768 mode=1' in text
        scope = 'Alignment counterfactual: compare previous-cycle raw data at the real valid edge. Current-cycle data matches 768/768; previous-cycle matches 0/768. Gate unchanged.'
    add(name, scope, [gate, folder/'tb_memory_gate.sv', folder/'runner.ps1'],
        [folder/'source_binding.json', folder/'result.json', folder/'run.log'], negative=True, routed=True)

pll = WORK / 'units_20261027_222447'
summary = load(pll/'summary.json')
assert summary['status'] == 'PASS'
record = next(x for x in summary['records'] if x['case'] == 'C42_PLL')
assert record['source_sha256'] == sha(SOURCE/'IP/sys_pll.v')
contains(pll/'C42_PLL/run.log', 'PLL_CLOCK_PASS')
add('final_pll', 'Official functional PLL model, 200ns test reset; 100MHz memory and 8ns phase checked. No measured board frequency or jitter.',
    [SOURCE/'IP/sys_pll.v', WORK/'tb_sys_pll.sv', WORK/'run_initial_units.py'],
    [pll/'summary.json', pll/'C42_PLL/run.log'])
contains(pll/'negative_unchanged_PLL/run.log', 'PLL high width')
add('old_pll', 'C41 50MHz PLL tested against the requested C42 100MHz clock contract.',
    [ROOT/'development/player_video41_refresh/src/user_source/hdl_source/IP/sys_pll.v', WORK/'tb_sys_pll.sv'],
    [pll/'summary.json', pll/'negative_unchanged_PLL/run.log'], negative=True)

refresh = WORK / 'units_20261027_200951'
record = next(x for x in load(refresh/'summary.json')['records'] if x['case'] == 'C42_refresh')
assert record['macro_sha256'] == sha(SOURCE/'include/global_def.v')
assert (refresh/'C42_refresh/global_def.v').read_bytes() == (SOURCE/'include/global_def.v').read_bytes()
contains(refresh/'C42_refresh/run.log', 'pulses=4097 gap=1562 window_ns=63979520')
add('refresh_interval', 'Public refresh producer prefix with natural startup, 4097 requests; 4096 intervals total 63.97952ms.',
    [SOURCE/'include/global_def.v', SOURCE/'include/sdr_init_ref.enc.v', refresh/'C42_refresh/prefix.v', refresh/'C42_refresh/bench.v'],
    [refresh/'summary.json', refresh/'C42_refresh/run.log'])
contains(refresh/'negative_old_period_macro/run.log', 'request gap 781 expected 1562')
add('old_refresh_count', 'Old 50MHz cycle count violates the new 100MHz interval contract.',
    [refresh/'negative_old_period_macro/global_def.v', refresh/'negative_old_period_macro/bench.v'],
    [refresh/'negative_old_period_macro/run.log'], negative=True)

fifo = WORK/'fifo_timing'
candidate = (fifo/'frame_fifo_write_candidate.v').read_text(encoding='utf-8-sig')
production = (SOURCE/'SD/frame_fifo_write.v').read_text(encoding='utf-8-sig')
assert candidate.replace('module frame_fifo_write_candidate', 'module frame_fifo_write', 1) == production
contains(fifo/'production256_20261027_203423.log', 'outputs match, cycles=4782', 'MISMATCH cycle=170')
add('remaining_words_equivalence', 'Production write-scheduler RTL compared against C41 at 256-word bursts, photo/JPEG traffic, reset and read contention; 4782 sampled cycles.',
    [SOURCE/'SD/frame_fifo_write.v', fifo/'frame_fifo_write_original.v', fifo/'frame_fifo_write_candidate.v', fifo/'tb_equiv.v', fifo/'jpeg420_word_address.v'],
    [fifo/'applied.json', fifo/'production256_20261027_203423.log'])
add('early_burst_admission', 'One-word-early admission variant detected at cycle170.',
    [fifo/'frame_fifo_write_negative.v', fifo/'tb_equiv.v'],
    [fifo/'production256_20261027_203423.log'], negative=True)
contains(fifo/'write_fifo_ready_positive.log', 'edges=31 epochs=4')
contains(fifo/'write_fifo_ready_negative.log', 'EARLY_ACCEPT')
add('fifo_ready_reset', 'Extracted reset/ready logic model; 31 edges and four reset epochs. Physical reset aperture remains a hardware timing dependency.',
    [SOURCE/'SD/frame_read_write.v', fifo/'tb_write_fifo_ready.v'],
    [fifo/'write_fifo_ready_positive.log', fifo/'write_fifo_ready_analysis.md'])
add('missing_release_synchronizer', 'Extracted-logic negative control removing the existing two-stage release qualification.',
    [fifo/'tb_write_fifo_ready.v'], [fifo/'write_fifo_ready_negative.log'], negative=True)
contains(WORK/'startup_unit/run.log', 'TB_STARTUP_REFRESH_GATE_PASS')
add('startup_refresh_gate', 'Actual sdram.v wrapper with stub raw events; exclude initialization falling edge, wait two refresh completions and restart after reset.',
    [SOURCE/'SD/sdram.v', WORK/'spec_review/tb_startup_refresh_gate.sv'],
    [WORK/'startup_unit/compile.log', WORK/'startup_unit/run.log'])

initial = WORK/'initial_100mhz_4ns'
snapshot = load(initial/'manifest.json')
assert snapshot['status'] == 'ROUTED_TIMING_FAIL_NO_BITSTREAM'
assert snapshot['setup_wns_ns'] == -4.428
for rel, digest in snapshot['files'].items():
    assert sha(initial/rel) == digest.lower(), rel
add('minimal_100mhz_4ns', 'Archived initial five-source-change implementation: setup -4.428ns; route failure preserved as the initial frequency-change control.',
    [initial/'manifest.json'], [initial/'build/AC201_tf_hdmi_phy.ts'], negative=True)

add('final_stage_binding', 'Final source/script/synthesis/hold-route/bit hashes verified by check_final_stages.ps1.',
    [VERIFY/'check_final_stages.ps1', PROJECT/'scripts/build_evidence.ps1'],
    [VERIFY/'final_stage_binding.json', VERIFY/'source_audit.json', VERIFY/'final_route.qor',
     PROJECT/'build/manual/AC201_tf_hdmi_phy.ts', PROJECT/'build/manual/AC201_tf_hdmi_exception.timing'])

audit = load(WORK/'spec_review/phase8_final_audit.json')
assert audit['result']['offline_artifact_eligible']
assert audit['external_delay_basis']['actual_behavior_model_tac_ns'] == 5.4
for relative, digest in audit['evidence_sha256'].items():
    assert sha(PROJECT/relative) == digest.lower(), relative
add('independent_timing_audit', 'Read-only audit of final route; checks DQ setup/hold edge pairing, I/O delay assumptions, coverage and 0.4ns tAC budget adjustment.',
    [PROJECT/'build/manual/AC201_tf_hdmi_pr.timing', PROJECT/'build/manual/AC201_tf_hdmi_exception.timing',
     PROJECT/'build/manual/AC201_tf_hdmi_chk.timing'],
    [WORK/'spec_review/phase8_final_audit.json', WORK/'spec_review/phase8_final_audit.md'])

result = dict(status='PASS', created_utc=datetime.now(timezone.utc).isoformat(),
              source_scope_hash=binding['scopeHash'], final_routed_netlist_sha256=gate_sha,
              final_routed_db_sha256=route_sha, final_bit_sha256=binding['bit_sha256'],
              checks=checks, ablations=ablations,
              outstanding=['C42 board media playback and mode switching', 'Cold starts and long runs',
                           'Board I/O skew, signal integrity, clock jitter and full external timing characterization'],
              coverage_notes=['Memory functional replay has no SDF, uses forced application/clock/reset and accelerated startup.',
                              'Application controller data path and separately tested arbitration are covered; whole TF/media/HDMI replay is outside these new tests.',
                              'Long run covers application addresses 0..4351, short run 0..459. Full-capacity/multi-bank retention coverage is not claimed.',
                              'SDRAM TD max input delay is 5ns; EM638325 model uses 5.4ns. See final timing audit for resulting 0.4ns budget adjustment.',
                              'Earlier C41/C42 failures and harness calibration logs remain preserved.'])
(VERIFY/'offline_checks.json').write_text(json.dumps(result, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
print(json.dumps({'status': result['status'], 'checks': len(checks), 'ablations': len(ablations),
                  'bit_sha256': result['final_bit_sha256']}, indent=2))
