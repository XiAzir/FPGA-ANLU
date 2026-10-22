"""Summarize the completed explicit-vopt C04 SDRAM device-model replay."""
from pathlib import Path
import hashlib
import json
import re
from datetime import datetime

HERE = Path(__file__).resolve().parent
BASE = HERE / 'runs/video_system_C04_20261021_200556'
RUN = HERE / 'vopt_try_20261021'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


log = (RUN / 'run_opt_35998_console.log').read_text(errors='replace')
pass_line = '# VIDEO_SYSTEM_PASS decoded_pixels=921600 commits=3 distinct_frames=2 PCM=6408 underflow=0 late=0'
assert pass_line in log
assert 'Time: 221 ms' in log
assert 'loading 35998 mapped sectors' in log
assert 'geometry 536870912 bytes' in log
assert '** Fatal:' not in log
errors = []
for line in log.splitlines():
    if 'ERROR:' not in line and '** Error:' not in line:
        continue
    m = re.search(r'(?:at time\s+|Clk:)([\d.]+)\s+(ns|ps)', line)
    assert m, line
    ns = float(m[1]) * (0.001 if m[2] == 'ps' else 1)
    errors.append({'time_ns': ns, 'message': line})
assert len(errors) == 5
assert all(e['time_ns'] < 1000 for e in errors)
files = [RUN / name for name in (
    'run_opt_35998_console.log', 'run_opt_35998.log', 'vopt_35998.log',
    'run.do', 'modelsim.ini', 'packed_mem.mem', 'lba_map.mem', 'jpeg_crc.mem', 'pcm.mem')]
files += [BASE / name for name in (
    'source_receipt.json', 'sources.f', 'plain.f', 'compile.log',
    'controller_gate.v', 'sdram_issi_reference_wrapper.v', 'IS42s32200.v',
    'tb_video_system.v', 'pll_clock_replay.v', 'clock_qualification.json')]
receipt = {
    'status': 'PASS_AFTER_STARTUP_TRANSIENT',
    'recorded_local': datetime.now().isoformat(),
    'scope': 'C04 actual SDRAM controller gate + APUG011 IS42s32200 pin model, original Q95 prefix, nominal PLL replay; no SDF or board test',
    'base_frozen_run': str(BASE), 'optimized_replay': str(RUN),
    'optimized_design': 'work.tb_video_system_opt_35998',
    'effective_parameters': {'MAPPED_SECTORS': 35998, 'IMAGE_BYTES': 536870912, 'CHECK_FRAMES': 2},
    'completion_evidence': pass_line,
    'process_exit_code': None,
    'process_exit_note': 'Launcher exit code was not captured for the explicit-vopt replay; final transcript records VIDEO_SYSTEM_PASS and normal testbench $finish at 221 ms.',
    'simulation_ms': 221, 'decoded_pixels': 921600, 'commits': 3,
    'distinct_displayed_frames': 2, 'original_pcm_samples_exact': 6408,
    'underflow': 0, 'frame_late': 0,
    'startup_model_errors_before_1us': errors, 'runtime_model_errors': [],
    'prior_attempts': 'Original novopt FAILED summary and earlier vopt parameter-range attempts retained unchanged; this result describes only run_opt_35998.',
    'files': [{'path': str(p), 'bytes': p.stat().st_size, 'sha256': sha(p)} for p in files],
}
(HERE / 'final_result.json').write_text(json.dumps(receipt, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps({k: receipt[k] for k in ('status', 'simulation_ms', 'decoded_pixels', 'commits', 'original_pcm_samples_exact')}))
