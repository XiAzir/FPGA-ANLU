"""Seal a built FAT candidate and its source/report evidence (board pending)."""
import hashlib
import json
import shutil
from datetime import datetime, timezone, timedelta
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[3] / 'scripts'))
from anlu_paths import REPOSITORY_ROOT, DOCS_ROOT, recorded_path, require_file

root = Path(__file__).resolve().parent.parent
manual = root / 'build/manual'
checkpoint = root / 'checkpoints/fat32_candidate_v1'
bit = manual / 'AC201_player_fat32_candidate.bit'
sha = lambda p: hashlib.sha256(require_file(p).read_bytes()).hexdigest().upper()
assert bit.is_file(), 'Bitstream missing'
assert not checkpoint.exists(), 'Use a new checkpoint name instead of overwriting'
status = (manual / 'AC201_tf_hdmi_phy.ts').read_text()
assert 'STNS: 0.000ns' in status and 'HTNS: 0.000ns' in status, status
assert 'PLACE_ROUTE_COMPLETE_WITH_REPORTS' in (manual / 'physical_console.log').read_text()
audit = json.loads((root / 'build/fat_source_audit.json').read_text(encoding='utf-8'))
for relative, expected in audit['source_sha256'].items():
    assert sha(root / 'src' / relative) == expected, f'Source changed since build: {relative}'
cases = {
    'catalog.log': 'PASS fat32_catalog cases=15',
    'mapper_sim.log': 'PASS: mapper',
    'wav_file_player.log': 'PASS: all WAV file player self-checks passed',
    'fat_arbiter.log': 'PASS fat_arbiter',
    'integration_small.log': 'PASS fat_file_integration 16x64',
    'integration_480p.log': 'PASS fat_file_integration 640x480',
    'integration_spi12m5.log': 'PASS fat_file_integration 16x64',
}
for name, marker in cases.items():
    assert marker in (root / 'build/fat_sim' / name).read_text(), f'No PASS in {name}'
assert 'PASS tb_bmp_file_negative' in (root / 'build/bmp_sim/bmp_file_negative.log').read_text()
info = {
    'created_beijing': datetime.now(timezone(timedelta(hours=8))).isoformat(),
    'device': 'EG4S20BG256', 'td': '6.2.178840',
    'bitstream': bit.name, 'bytes': bit.stat().st_size, 'sha256': sha(bit),
    'timing_status_routed': status.strip(),
    'simulation_cases': list(cases) + ['../bmp_sim/bmp_file_negative.log'],
    'source_audit': 'fat_source_audit.json',
    'board_verification': 'pending; candidate has not been downloaded by the agent',
    'card_writes': 'none',
    'limitations': 'root FAT32/8.3; up to four 640x480 BI_RGB24 BMPs; '
                   'TEST.WAV PCM16 mono48k; max4096 file clusters and256 root clusters',
}
info_path = bit.with_suffix('.info.json')
info_path.write_text(json.dumps(info, ensure_ascii=False, indent=2), encoding='utf-8')
checkpoint.mkdir(parents=True)
for name in ('src', 'scripts', 'sim'):
    shutil.copytree(root / name, checkpoint / name)
shutil.copy2(root / 'spec.md', checkpoint / 'spec.md')
shutil.copy2(root / 'build/fat_source_audit.json', checkpoint / 'fat_source_audit.json')
shutil.copytree(manual, checkpoint / 'build/manual')
shutil.copytree(root / 'build/fat_sim', checkpoint / 'build/fat_sim',
                ignore=shutil.ignore_patterns('*.vvp'))
shutil.copytree(root / 'build/bmp_sim', checkpoint / 'build/bmp_sim',
                ignore=shutil.ignore_patterns('*.vvp'))
manifest = {'board_verification': 'pending', 'files': [
    {'path': p.relative_to(checkpoint).as_posix(), 'bytes': p.stat().st_size, 'sha256': sha(p)}
    for p in sorted(checkpoint.rglob('*')) if p.is_file()
]}
(checkpoint / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding='utf-8')
for item in manifest['files']:
    assert sha(checkpoint / item['path']) == item['sha256']
print(f"SEALED candidate: {bit.stat().st_size} bytes, SHA256 {sha(bit)}; {len(manifest['files'])} files verified")
