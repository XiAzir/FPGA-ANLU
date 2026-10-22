"""Bind selected C11319 build and frozen simulation inputs to the live files."""
from pathlib import Path
import argparse
import hashlib
import json

ROOT = Path(__file__).resolve().parents[2]
PLAYER = ROOT / 'development/player_video19'
MANUAL = PLAYER / 'build/manual'


def read(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


parser = argparse.ArgumentParser()
parser.add_argument('--receipt', action='append', type=Path, default=[])
parser.add_argument('--pin-run', type=Path)
parser.add_argument('--output', type=Path, required=True)
args = parser.parse_args()
checks = []


def check(path, expected, scope):
    actual = sha(path)
    checks.append(dict(path=str(path.resolve()), scope=scope,
                       expected=expected.lower(), sha256=actual,
                       passed=actual == expected.lower()))


scope = read(MANUAL / 'build_source_scope.json')
for entry in scope:
    check(PLAYER / 'src' / entry['path'], entry['sha256'], 'synthesized source scope')

stages = {}
for stage in ('synthesis', 'physical', 'hold', 'bitstream'):
    marker = read(MANUAL / 'stage_evidence' / f'latest_{stage}.json')
    record_path = MANUAL / 'stage_evidence' / marker['record']
    record = read(record_path)
    assert marker['status'] == record['status'] == 'success'
    assert marker['runId'] == record['runId']
    stages[stage] = dict(record=record, record_sha256=sha(record_path))
syn = stages['synthesis']['record']
for stage in ('physical', 'hold', 'bitstream'):
    r = stages[stage]['record']
    assert r['synthesisRunId'] == syn['runId']
    assert (r['scopeHash'], r['scriptHash'], r['gateDbHash']) == (
        syn['scopeHash'], syn['scriptHash'], syn['gateDbHash'])
for script in syn['scripts']:
    check(PLAYER / 'scripts' / script['path'], script['sha256'], 'build script')
check(MANUAL / 'AC201_tf_hdmi_gate.db', syn['gateDbHash'], 'selected gate database')
for name, value in stages['hold']['record']['artifacts'].items():
    check(MANUAL / name, value, 'final post-hold routed artifact')
check(MANUAL / 'AC201_player_video19.bit', stages['bitstream']['record']['bitHash'],
      'generated bitstream')

receipts = []
for receipt_path in args.receipt:
    data = read(receipt_path)
    changes = data.get('compatibility', []) + data.get('compatibility_copies', [])
    compat = {e['path']: e['copy_sha256'] for e in changes}
    n = 0
    for entry in data['inputs']:
        source = Path(entry['source'])
        copy = Path(entry['copy'])
        expected = entry.get('source_sha256', entry.get('sha256'))
        check(source, expected, 'simulation original input')
        copy_expected = entry.get('compat_copy_sha256',
                                  compat.get(str(copy), entry.get('copy_sha256', expected)))
        check(copy, copy_expected, 'compiled frozen input / recorded compatibility')
        n += 1
    receipts.append(dict(path=str(receipt_path.resolve()), sha256=sha(receipt_path), inputs=n))

if args.pin_run:
    pin = args.pin_run.resolve()
    receipt_path = pin / 'pin_source_receipt.json'
    data = read(receipt_path)
    parent = Path(data['parent_run'])
    reference = Path(data['reference_run'])
    check(parent / 'summary.json', data['parent_summary_sha256'], 'HDMI parent result')
    check(parent / 'source_receipt.json', data['parent_source_receipt_sha256'], 'HDMI parent source binding')
    check(reference / 'reference_receipt.json', data['reference_receipt_sha256'], 'independent JPEG reference')
    check(pin / 'tb_video_system.v', data['testbench_sha256'], 'HDMI pin testbench')
    check(pin / 'system_pin_scoreboard_video.vh', data['scoreboard_sha256'], 'HDMI pin scoreboard')
    for entry in data['inputs']:
        check(pin / entry['path'], entry['sha256'], 'HDMI frozen input')
    receipts.append(dict(path=str(receipt_path), sha256=sha(receipt_path), inputs=len(data['inputs'])))

result = dict(status='PASS' if all(e['passed'] for e in checks) else 'FAIL',
              scope='File identity, build-stage linkage, and recorded simulation compatibility only',
              stages=stages, receipts=receipts, checks=checks,
              checks_count=len(checks), mismatches=[e for e in checks if not e['passed']])
args.output.parent.mkdir(parents=True, exist_ok=True)
args.output.write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps({k: result[k] for k in ('status', 'checks_count', 'mismatches')}, indent=2))
raise SystemExit(0 if result['status'] == 'PASS' else 2)
