from pathlib import Path
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[2]
P = ROOT / 'development/player_video27_command_boundary'
BASE = ROOT / 'development/player_video26_runtime_diag'
MATRIX = ROOT / 'development/video26_work/cmd_boundary_review'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_text(encoding='utf-8-sig'))

old = {f.relative_to(BASE / 'src/user_source').as_posix(): sha(f)
       for f in (BASE / 'src/user_source').rglob('*') if f.is_file()}
new = {f.relative_to(P / 'src/user_source').as_posix(): sha(f)
       for f in (P / 'src/user_source').rglob('*') if f.is_file()}
assert old.keys() == new.keys()
changed = sorted(k for k in old if old[k] != new[k])
assert changed == ['hdl_source/SD/sd_card_cmd.v', 'hdl_source/player_compact_status_pages.v']
status = 'hdl_source/player_compact_status_pages.v'
assert (BASE / 'src/user_source' / status).read_text(encoding='utf-8-sig').replace('00C11326', '00C11327') == (P / 'src/user_source' / status).read_text(encoding='utf-8-sig')
m = read(MATRIX / 'matrix_summary.json')
assert m['status'] == 'PASS' and m['cases'] == 336
assert m['candidate_sha256'].lower() == new['hdl_source/SD/sd_card_cmd.v']
assert m['baseline_sha256'].lower() == old['hdl_source/SD/sd_card_cmd.v']
assert m['tb_sha256'].lower() == sha(MATRIX / 'tb_command_boundary.v')
assert len(m['rows']) == 336
assert len([r for r in m['rows'] if r['version'] == 'candidate' and r['pass']]) == 168
assert len([r for r in m['rows'] if r['version'] == 'baseline' and not r['pass']]) == 72
for r in m['rows']:
    log = MATRIX / f"{r['version']}_cmd{r['cmd']}_slot{r['slot']}_noise{r['noise']}.log"
    assert sha(log) == r['log_sha256'].lower()
    assert r['pass'] == r['expected_pass']
    assert ('BOUNDARY_PASS' in log.read_text()) == r['pass']
r1_logs = []
for version in ['baseline', 'candidate']:
    for command in [0, 8, 17, 55]:
        f = MATRIX / f'{version}_cmd{command}_r1error.log'
        assert 'BOUNDARY_PASS' in f.read_text()
        r1_logs.append({'path': str(f), 'sha256': sha(f)})

runs = []
for name, marker in [('video_system_20261022_171144', 'VIDEO_SYSTEM_PASS decoded_pixels='),
                     ('video_system_20261022_171832', 'VIDEO_SYSTEM_PASS restart_roundtrip')]:
    folder = P / 'build' / name
    summary = read(folder / 'summary.json')
    assert summary['status'] == 'PASS'
    assert summary['compile']['exit_code'] == summary['simulation']['exit_code'] == 0
    assert not summary['runtime_model_errors']
    log = (folder / 'console.log').read_text()
    assert marker in log and not re.search(r'\*\* (Error|Fatal)|FATAL:', log)
    receipt = read(folder / 'source_receipt.json')
    copies = {r['path']: r['copy_sha256'] for r in receipt['compatibility']}
    for row in receipt['inputs']:
        assert sha(Path(row['source'])) == row['sha256'].lower()
        assert sha(Path(row['copy'])) == copies.get(row['copy'], row['sha256']).lower()
    runs.append({'directory': str(folder), 'summary_sha256': sha(folder / 'summary.json'),
                 'source_receipt_sha256': sha(folder / 'source_receipt.json'),
                 'console_sha256': sha(folder / 'console.log'),
                 'testbench_sha256': sha(folder / 'tb_video_system.v'),
                 'result': next(line for line in log.splitlines() if marker in line),
                 'assumptions': summary['assumptions']})

result = {'status': 'PASS', 'base': 'C11326', 'changed': changed,
          'unchanged_user_source_count': len(old) - len(changed),
          'inputs': [{'path': k, 'base_sha256': old[k], 'candidate_sha256': new[k]} for k in sorted(new)],
          'command_matrix_sha256': sha(MATRIX / 'matrix_summary.json'),
          'command_testbench_sha256': sha(MATRIX / 'tb_command_boundary.v'),
          'candidate_cases_pass': 168, 'baseline_failures_detected': 72,
          'r1_error_controls': r1_logs, 'system_runs': runs,
          'limitations': ['Nominal PLL edge replay and SDRAM application model; no SDF',
                          'Mode and restart events injected at classifier outputs',
                          '16x16 BMP fixtures are scaled to 640x480; video and PCM use delivered media',
                          'SPI card model aborts its queued response on CS deassertion',
                          'On-board CMD8 causality, image corruption and silence remain pending']}
(P / 'verification/offline_tests.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps({k: result[k] for k in ['status', 'changed', 'unchanged_user_source_count', 'candidate_cases_pass', 'baseline_failures_detected', 'system_runs']}, ensure_ascii=False, indent=2))
