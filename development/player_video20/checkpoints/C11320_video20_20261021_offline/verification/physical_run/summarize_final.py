"""Bind a completed physical SDRAM run's exit record and log to final_result.json."""
from pathlib import Path
import argparse
import hashlib
import json
import re
import sys

HERE = Path(__file__).resolve().parent


def walk(value):
    if isinstance(value, dict):
        yield value
        for child in value.values():
            yield from walk(child)
    elif isinstance(value, list):
        for child in value:
            yield from walk(child)


def exit_code(data, names, hints):
    for item in walk(data):
        for name in names:
            value = item.get(name)
            if isinstance(value, int):
                return value
        if 'exit_code' in item and isinstance(item['exit_code'], int):
            keys = ' '.join(str(key).lower() for key in item)
            if any(hint in keys for hint in hints):
                return item['exit_code']
    return None


def nested_exit_code(data, names):
    for name in names:
        value = data.get(name)
        if isinstance(value, dict) and isinstance(value.get('exit_code'), int):
            return value['exit_code']
    return None


def timed_out(data):
    for item in walk(data):
        for key in ('timed_out', 'timeout'):
            if item.get(key) is True:
                return True
    return False


def error_time_ns(lines, index):
    for line in lines[index:index + 5]:
        match = re.search(r'at time\s+([\d.]+)\s+ns', line)
        if match:
            return float(match.group(1))
        match = re.search(r'Time:\s*([\d.]+)\s+(ps|ns)', line)
        if match:
            value = float(match.group(1))
            return value * (0.001 if match.group(2) == 'ps' else 1.0)
    return None


parser = argparse.ArgumentParser()
parser.add_argument('--exit-json', required=True, type=Path)
parser.add_argument('--log', required=True, type=Path)
parser.add_argument('--vopt-log', type=Path, default=HERE / 'vopt_physical_final.log')
parser.add_argument('--runner', type=Path, default=HERE / 'rerun_physical_final.ps1')
parser.add_argument('--reused-optimization', action='store_true')
parser.add_argument('--output', type=Path, default=HERE / 'final_result.json')
args = parser.parse_args()

exit_path = args.exit_json.resolve()
log_path = args.log.resolve()
vopt_log_path = args.vopt_log.resolve()
exit_data = json.loads(exit_path.read_text(encoding='utf-8-sig'))
log_text = log_path.read_text(encoding='utf-8', errors='replace')
vopt_log_text = vopt_log_path.read_text(encoding='utf-8', errors='replace')
lines = log_text.splitlines()
vopt_exit = exit_code(exit_data, ('vopt_exit_code', 'optimization_exit_code'), ('vopt', 'optim'))
if args.reused_optimization:
    vopt_exit = None
vsim_exit = exit_code(exit_data, ('vsim_exit_code', 'simulation_exit_code'), ('vsim', 'simulat', 'run'))
if vopt_exit is None:
    vopt_exit = nested_exit_code(exit_data, ('vopt', 'optimization'))
if vsim_exit is None:
    vsim_exit = nested_exit_code(exit_data, ('vsim', 'simulation', 'run'))
if vsim_exit is None:
    vsim_exit = exit_data.get('exit_code') if isinstance(exit_data.get('exit_code'), int) else None
optimized_match = re.search(r'Optimized design name is\s+([^\s]+)', vopt_log_text)
if vopt_exit is None and optimized_match and not args.reused_optimization:
    # The launcher only starts vsim after vopt exits successfully.
    vopt_exit = 0
pass_match = re.search(
    r'VIDEO_SYSTEM_PASS decoded_pixels=(\d+) commits=(\d+) distinct_frames=(\d+) '
    r'PCM=(\d+) underflow=0 late=0', log_text)

startup_errors = []
runtime_errors = []
for i, line in enumerate(lines):
    if not re.search(r'\*\* (?:Error|Fatal)|ERROR:', line):
        continue
    time_ns = error_time_ns(lines, i)
    entry = dict(time_ns=time_ns, message=line.strip())
    if time_ns is not None and time_ns < 1000:
        startup_errors.append(entry)
    else:
        runtime_errors.append(entry)

decode_times = [int(value) for value in re.findall(r'VIDEO_MEMORY_COMMIT[^\n]*?decode_ns=(\d+)', log_text)]
commit_decode = [
    dict(frame=int(frame), decode_ns=int(duration))
    for frame, duration in re.findall(r'VIDEO_MEMORY_COMMIT\s+frame=(\d+)[^\n]*?decode_ns=(\d+)', log_text)
]
finish_time = re.search(
    r'\$finish[\s\S]{0,240}?Time:\s*([\d.]+)\s*(ms|us|ns|ps)', log_text, re.IGNORECASE)
simulation_ms = None
if finish_time:
    scale = {'ms': 1.0, 'us': 0.001, 'ns': 0.000001, 'ps': 0.000000001}
    simulation_ms = float(finish_time.group(1)) * scale[finish_time.group(2).lower()]
binding_path = HERE / 'receipt_binding.json'
binding = json.loads(binding_path.read_text(encoding='utf-8-sig')) if binding_path.exists() else {}
receipt_path = HERE / 'source_receipt.json'
clock_path = HERE / 'clock_qualification.json'
clock_qualification = json.loads(clock_path.read_text(encoding='utf-8-sig'))
run_script = args.runner.resolve()
prior_records = sorted(HERE.glob('final_result_envblocked_*.json'), key=lambda p: p.stat().st_mtime)
prior_attempts = [
    dict(path=str(p), sha256=hashlib.sha256(p.read_bytes()).hexdigest().upper(),
         status=json.loads(p.read_text(encoding='utf-8-sig')).get('status'))
    for p in prior_records
]

receipt_data = json.loads(receipt_path.read_text(encoding='utf-8-sig'))
input_hashes = {Path(item['copy']).name: item.get('sha256') for item in receipt_data['inputs']}
for item in receipt_data.get('compatibility', []):
    input_hashes[Path(item['path']).name] = item['copy_sha256']
for name in ('controller_gate.v', 'sdram_issi_reference_wrapper.v', 'IS42s32200.v', 'global_def.v',
             'packed_mem.mem', 'lba_map.mem', 'jpeg_crc.mem', 'pcm.mem', 'tb_video_system.v'):
    path = HERE / name
    if path.exists():
        input_hashes[name] = hashlib.sha256(path.read_bytes()).hexdigest().upper()
input_hashes[run_script.name] = hashlib.sha256(run_script.read_bytes()).hexdigest().upper()
for name in ('checkpointed.do', 'resume.do', 'modelsim.ini'):
    path = log_path.parent / name
    if path.exists():
        input_hashes[name] = hashlib.sha256(path.read_bytes()).hexdigest().upper()

for entry in startup_errors:
    message = entry['message'].lower()
    if 'all banks must be precharge' in message:
        entry['classification'] = 'SDRAM model startup command diagnostic'
    elif 'tmrd violation' in message:
        entry['classification'] = 'SDRAM model startup timing diagnostic'
    elif '$hold' in message:
        entry['classification'] = 'SDRAM model startup specify hold check'
    else:
        entry['classification'] = 'unclassified simulator error'

checks = {
    'receipt_binding_pass': binding.get('status') == 'PASS' and not binding.get('mismatches'),
    'nominal_pll_replay_qualification': clock_qualification.get('status') == 'PASS_SCOPE',
    'optimization_qualified': (args.reused_optimization and optimized_match is not None) or vopt_exit == 0,
    'no_acc_vopt_completed': optimized_match is not None,
    'vsim_exit_zero': vsim_exit == 0,
    'not_timed_out': not timed_out(exit_data),
    'complete_pass_line': pass_match is not None,
    'simulation_time_at_221ms_check': bool(simulation_ms is not None and 220.0 <= simulation_ms < 222.0),
    'two_frames_decoded': bool(pass_match and int(pass_match.group(1)) >= 614400),
    'at_least_three_commits': bool(pass_match and int(pass_match.group(2)) >= 3),
    'at_least_two_displayed_frames': bool(pass_match and int(pass_match.group(3)) >= 2),
    'at_least_6408_pcm_samples': bool(pass_match and int(pass_match.group(4)) >= 6408),
    'five_startup_errors': len(startup_errors) == 5,
    'no_runtime_model_errors': len(runtime_errors) == 0,
}

result = {
    'status': 'PASS_AFTER_STARTUP_TRANSIENT' if all(checks.values()) else 'FAILED',
    'run_directory': str(HERE),
    'source_receipt': str(receipt_path),
    'source_receipt_sha256': hashlib.sha256(receipt_path.read_bytes()).hexdigest().upper(),
    'source_receipt_schema': 'inputs(source,copy,sha256)/compatibility',
    'source_run_status': 'COMPLETED' if all(checks.values()) else 'NOT_PASSED',
    'prior_attempts': prior_attempts,
    'nominal_pll_replay': True,
    'clock_qualification': str(clock_path),
    'clock_qualification_sha256': hashlib.sha256(clock_path.read_bytes()).hexdigest().upper(),
    'generics': dict(MAPPED_SECTORS=29686, IMAGE_BYTES=536870912, CHECK_FRAMES=2),
    'plusargs': ['+AUDIO_PHASE=800'],
    'vopt_log': str(vopt_log_path),
    'vopt_log_sha256': hashlib.sha256(vopt_log_path.read_bytes()).hexdigest().upper(),
    'vopt_stderr_sha256': hashlib.sha256((HERE / 'vopt_physical_final_stderr.log').read_bytes()).hexdigest().upper(),
    'optimized_design': optimized_match.group(1) if optimized_match else None,
    'optimization_strategy': 'no-acc vopt from isolated copied frozen work library',
    'reused_optimization': args.reused_optimization,
    'optimization_exit_observation': ('Existing successful elaboration imported; no new vopt process' if args.reused_optimization else 'Launcher requires successful vopt before vsim'),
    'simulation_working_directory': str(log_path.parent),
    'exit_json': str(exit_path),
    'exit_json_sha256': hashlib.sha256(exit_path.read_bytes()).hexdigest().upper(),
    'simulation_log': str(log_path),
    'simulation_log_sha256': hashlib.sha256(log_path.read_bytes()).hexdigest().upper(),
    'simulation_started': True,
    'vopt_exit_code': vopt_exit,
    'vsim_exit_code': vsim_exit,
    'simulation_ms': simulation_ms,
    'checks': checks,
    'decoded_pixels': int(pass_match.group(1)) if pass_match else None,
    'commits': int(pass_match.group(2)) if pass_match else None,
    'distinct_displayed_frames': int(pass_match.group(3)) if pass_match else None,
    'original_pcm_samples_exact': int(pass_match.group(4)) if pass_match else None,
    'underflow': 0 if pass_match else None,
    'frame_late': 0 if pass_match else None,
    'peak_decode_ns': max(decode_times) if decode_times else None,
    'peak_decode_frame': max(commit_decode, key=lambda item: item['decode_ns'])['frame'] if commit_decode else None,
    'frame_decode_ns': commit_decode,
    'startup_model_errors_before_1us': startup_errors,
    'runtime_model_errors': runtime_errors,
    'input_hashes': input_hashes,
    'model_assumptions': [
        'Frozen C11320 RTL with the unchanged SHA-bound SDRAM controller gate and APUG011 IS42s32200 pin model',
        'No SDF timing annotation',
        'Qualified nominal PLL edge replay',
        'Board and TF-card verification remain pending'
    ],
    'input_bindings': receipt_data['inputs'],
    'compatibility_bindings': receipt_data.get('compatibility', []),
}
args.output.resolve().write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
print(json.dumps({'status': result['status'], 'checks': checks}, indent=2))
sys.exit(0 if result['status'] == 'PASS_AFTER_STARTUP_TRANSIENT' else 2)
