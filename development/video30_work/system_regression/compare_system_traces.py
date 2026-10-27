from pathlib import Path
import argparse, json, re, sys

p = argparse.ArgumentParser(description='Compare stable C29/C30 system-regression traces')
p.add_argument('baseline', type=Path, help='C29 run output directory')
p.add_argument('candidate', type=Path, help='C30 run output directory')
a = p.parse_args()
patterns = {
    'jpeg_frames': re.compile(r'^\s*#?\s*VIDEO_JPEG_FRAME session=(\d+) frame=(\d+) bytes=(\d+) crc32=([0-9a-fA-F]+)'),
    'rgb_frames': re.compile(r'^\s*#?\s*VIDEO_RGB_FRAME session=(\d+) frame=(\d+) pixels=(\d+) crc32=([0-9a-fA-F]+)'),
    'sessions': re.compile(r'^\s*#?\s*RESTART_SESSION_PASS transition=(\d+) video=(\d+) frames=(\d+) pixels=(\d+) PCM=(\d+) total=(\d+) reads=(\d+) commands=(\d+) CMD0=(\d+)'),
    'pass': re.compile(r'^\s*#?\s*VIDEO_SYSTEM_PASS restart_roundtrip transitions=(\d+) PCM=(\d+) CMD0=(\d+) reads=(\d+) commands=(\d+) gate=(\d+)/(\d+)'),
}
def extract(folder):
    log = folder / 'console.log'
    if not log.is_file():
        raise FileNotFoundError(log)
    result = {}
    for name, pattern in patterns.items():
        result[name] = [tuple(m.groups()) for line in log.read_text(errors='replace').splitlines()
                        if (m := pattern.search(line))]
    return result
base, cand = extract(a.baseline), extract(a.candidate)
comparison = {
    'status': 'PASS' if base == cand and base['pass'] else 'TRACE_DIFFERENCE',
    'baseline': str(a.baseline.resolve()),
    'candidate': str(a.candidate.resolve()),
    'baseline_trace': base,
    'candidate_trace': cand,
    'compared_fields': list(patterns),
    'timing': 'ignored',
}
print(json.dumps(comparison, ensure_ascii=False, indent=2))
sys.exit(0 if comparison['status'] == 'PASS' else 2)
