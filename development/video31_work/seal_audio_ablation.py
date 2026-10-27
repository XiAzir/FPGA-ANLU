"""Bind the controlled C31 board experiment to sources, tests and certified build."""
from pathlib import Path
import datetime
import hashlib
import json
import re
import shutil
import zipfile

ROOT = Path(__file__).resolve().parents[2]
WORK = Path(__file__).resolve().parent
CAND = ROOT / 'development/player_video31_audio_ablation'
C30 = ROOT / 'development/player_video30_probe_prune'
C29 = ROOT / 'development/player_video29_media_flow'
VERIFY = CAND / 'verification'
BUILD = CAND / 'build/manual'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p): return json.loads(p.read_text(encoding='utf-8-sig'))
def write(p, obj): p.write_text(json.dumps(obj, ensure_ascii=False, indent=2), encoding='utf-8')

prep = read(VERIFY / 'preparation.json')
for name, digest in prep['source_inputs'].items():
    assert sha(CAND / 'src/user_source' / name) == digest, name
stages = read(VERIFY / 'final_stage_binding.json')
assert stages['status'] == 'PASS'
for entry in stages['inputs']:
    assert sha(CAND / entry['path']) == entry['sha256']
bit = BUILD / 'AC201_player_video31_audio_ablation.bit'
assert sha(bit) == stages['bit_sha256']
assert sha(BUILD / 'AC201_tf_hdmi_pr.db') == stages['stages']['hold']['artifacts']['AC201_tf_hdmi_pr.db']
text = (BUILD / 'AC201_tf_hdmi_phy.ts').read_text(encoding='utf-8-sig')
m = re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns', text)
assert m and min(map(float, m.groups())) >= 0
timing = dict(zip(('setup_wns', 'setup_tns', 'hold_wns', 'hold_tns'), map(float, m.groups())))
net = (VERIFY / 'final_routed.v').read_text(encoding='utf-8-sig')
slices = sum(len(re.findall(r'^\s*' + name + r'\s*#\(', net, re.M)) for name in ('EG_PHY_MSLICE', 'EG_PHY_LSLICE'))
assert 0 < slices <= 9800
for restored in ('wav_varied_seen', 'fifo_nonzero_seen', 'tone_acr_seen'):
    assert restored in net, restored
for removed in ('u_packet_monitor', 'u_memory_runtime_probe', 'u_pcm_crc_probe', 'read_crc16'):
    assert removed not in net, removed
area_text = (BUILD / 'AC201_tf_hdmi_phy.area').read_text(encoding='utf-8-sig')
area = {key: int(re.search(r'^#' + key + r'\s+(\d+)', area_text, re.M).group(1)) for key in ('lut', 'reg', 'le', 'bram', 'dsp', 'pll', 'gclk')}
assert area['bram'] == 62 and area['dsp'] == 26
test_log = (WORK / 'audio_run.log').read_text(encoding='utf-8-sig')
assert 'PASS AUDIO_OBSERVER_ABLATION cycles=300000 samples=565 acr=11 corruption_detected=565' in test_log
assert not (WORK / 'audio_compile.log').read_text(encoding='utf-8-sig').strip()
test_inputs = [WORK / 'tb_audio_observer_ablation.v', WORK / 'run_audio_ablation.ps1', WORK / 'audio_compile.log', WORK / 'audio_run.log']
test_inputs += [C30 / 'src/user_source/hdl_source/player_audio_output.v']
test_inputs += [CAND / 'src/user_source/hdl_source' / n for n in ('player_audio_probe.v', 'wav_pcm_bridge.v', 'hdmi_audio_tone_pcm_scale.v', 'audio_arc_calculate.v')]
assert sha(CAND / 'src/user_source/hdl_source/player_audio_probe.v') == sha(C29 / 'src/user_source/hdl_source/player_audio_probe.v')
parent = read(C29 / 'verification/final_binding.json')
rollback = ROOT / 'download/video29_media_flow.bit'
assert sha(rollback) == parent['bit_sha256']
binding = {
    'status': 'OFFLINE_VERIFIED_CONTROLLED_ABLATION_BOARD_PENDING', 'build_id': '00C11331',
    'created_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'purpose': 'C30 audio regression: restore only C29 audio observer group and its LED outputs',
    'root_cause': 'UNDETERMINED', 'board_result': 'PENDING',
    'bit_sha256': sha(bit), 'slice_used': slices, 'slice_percent': slices / 98,
    'slice_saved_vs_C29': parent['slice_used'] - slices, 'C29_slice_used': parent['slice_used'],
    'timing_ns': timing, 'physical_resources': area,
    'production_delta': {k: prep[k] for k in ('changed', 'removed', 'added')},
    'source_inputs': prep['source_inputs'],
    'tests': {'audio_ablation': '300000 cycles, 565 samples, 11 ACR; 565 PCM bit-flip negative detections',
              'full_C31_system_simulation': 'NOT_RUN',
              'C30_prior_regression': 'Historical reference only; C30 board audio failed'},
    'test_evidence': [{'path': p.relative_to(ROOT).as_posix(), 'sha256': sha(p)} for p in test_inputs],
    'final_stage_binding_sha256': sha(VERIFY / 'final_stage_binding.json'),
    'final_routed_sha256': sha(VERIFY / 'final_routed.v'),
    'routed_database_sha256': sha(BUILD / 'AC201_tf_hdmi_pr.db'),
    'ui_changes': 'Digits fixed 00C11331; LEDs use original C29 audio observations',
    'rollback_bit_sha256': sha(rollback),
    'outstanding': ['Board test for music and internal tone; no proven fix or root cause yet',
                    'No SDF simulation or physical HDMI capture in this experiment']
}
write(VERIFY / 'final_binding.json', binding)
download = ROOT / 'download/video31_audio_ablation.bit'
assert not download.exists()
shutil.copy2(bit, download)
write(download.with_suffix('.info.json'), binding)
package = ROOT / 'deliverables/video31_audio_ablation_c11331_20261023'
package.mkdir(exist_ok=False)
payload = {'video31_audio_ablation.bit': download, 'video29_media_flow_rollback.bit': rollback,
           '上板说明.md': WORK / '板测说明.md', 'final_binding.json': VERIFY / 'final_binding.json',
           'final_stage_binding.json': VERIFY / 'final_stage_binding.json',
           'audio_run.log': WORK / 'audio_run.log',
           'final_timing_status.txt': BUILD / 'AC201_tf_hdmi_phy.ts',
           'final_area.txt': BUILD / 'AC201_tf_hdmi_phy.area'}
manifest = []
for name, path in payload.items():
    shutil.copy2(path, package / name)
    manifest.append({'path': name, 'sha256': sha(package / name), 'bytes': (package / name).stat().st_size})
write(package / 'MANIFEST.json', {'build_id': '00C11331', 'files': manifest})
zpath = package.with_suffix('.zip')
assert not zpath.exists()
with zipfile.ZipFile(zpath, 'w', zipfile.ZIP_DEFLATED) as z:
    for path in sorted(package.iterdir()): z.write(path, path.name)
with zipfile.ZipFile(zpath) as z:
    assert z.testzip() is None
    for item in manifest: assert hashlib.sha256(z.read(item['path'])).hexdigest() == item['sha256']
receipt = {'status': 'PASS', 'package': zpath.relative_to(ROOT).as_posix(), 'package_sha256': sha(zpath),
           'package_bytes': zpath.stat().st_size, 'bit_sha256': sha(bit), 'slice_used': slices,
           'slice_percent': binding['slice_percent'], 'slice_saved_vs_C29': binding['slice_saved_vs_C29'], 'timing_ns': timing}
write(VERIFY / 'delivery_receipt.json', receipt)
print(json.dumps(receipt, ensure_ascii=False, indent=2))
