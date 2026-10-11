"""Gate, freeze and package a dynamic-text candidate. Never replace checkpoints."""
from pathlib import Path
from datetime import datetime, timezone, timedelta
import hashlib
import json
import re
import shutil
import zipfile

PROJECT = Path(__file__).resolve().parent.parent
ROOT = PROJECT.parent.parent
MANUAL = PROJECT / 'build/manual'
CHECKPOINT = PROJECT / 'checkpoints/dynamic_text_20261009_candidate'
PACKAGE = ROOT / 'deliverables/dynamic_text_20261009.zip'
BIT = MANUAL / 'AC201_player_dynamic_text.bit'
FALLBACK = ROOT / 'download/osd_phy_fix.bit'
FALLBACK_SHA = '9E893B0B6C86BF6FBEE19E74B5FB58933C1BEA6AA07F203786CCE96F3B60AE6F'

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest().upper()

def read_json(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))

def write_json(path, value):
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

def check_log(path, marker):
    value = path.read_text(encoding='utf-8-sig', errors='replace')
    if marker not in value:
        raise RuntimeError(f'Expected marker {marker} in {path}')
    return value

if CHECKPOINT.exists() or PACKAGE.exists():
    raise RuntimeError('Never overwrite a frozen checkpoint or delivered package')

for name, marker in [
    ('synthesis', 'SYNTHESIS_COMPLETE_WITH_GATE_DATABASE'),
    ('physical', 'PLACE_ROUTE_COMPLETE_WITH_REPORTS'),
    ('hold', 'POST_ROUTE_HOLD_FIX_COMPLETE'),
    ('bitstream', 'BITSTREAM_GENERATED'),
]:
    check_log(MANUAL / f'{name}_console.log', marker)

scope = read_json(MANUAL / 'build_source_scope.json')
for entry in scope:
    path = PROJECT / 'src' / entry['path'].replace('\\', '/')
    assert sha(path) == entry['sha256'], f'Synthesis source changed: {path}'

baseline = read_json(PROJECT / 'build/baseline.json')
old_root = Path(baseline['baseline']) / 'src/user_source'
new_root = PROJECT / 'src/user_source'
new_files = sorted(p for p in new_root.rglob('*') if p.is_file())
assert len(new_files) == 75 and len([p for p in old_root.rglob('*') if p.is_file()]) == 74
changed, added, same = [], [], 0
for path in new_files:
    relative = path.relative_to(new_root)
    previous = old_root / relative
    if not previous.exists():
        added.append(relative.as_posix())
    elif sha(path) != sha(previous):
        changed.append(relative.as_posix())
    else:
        same += 1
assert changed == ['hdl_source/top_tf_hdmi_audio.v']
assert added == ['hdl_source/player_dynamic_text.v'] and same == 73
assert sha(FALLBACK) == FALLBACK_SHA

tests = {}
for name, relative in [
    ('dynamic_pixels', 'build/dynamic_sim/pixels_run.log'),
    ('dynamic_timer', 'build/dynamic_sim/timer_run.log'),
    ('original_osd', 'build/osd_sim/run.log'),
    ('state_mailbox', 'build/state_sim/run.log'),
]:
    log_path = PROJECT / relative
    text = check_log(log_path, 'PASS')
    assert not re.search(r'FAIL|FATAL', text), f'Test failure: {log_path}'
    tests[name] = {'log': relative, 'sha256': sha(log_path),
                   'result': next(line for line in text.splitlines() if line.startswith('PASS'))}
assert 'pixels=1843200' in tests['dynamic_pixels']['result']
assert '12000-cycle' in tests['dynamic_timer']['result']
write_json(PROJECT / 'build/model_results.json', {'status': 'PASS', 'hardware_proof': False, 'tests': tests})

timing_text = (MANUAL / 'AC201_tf_hdmi_phy.ts').read_text()
match = re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.', timing_text)
assert match, 'Missing final timing result'
timing = dict(zip(['SWNS_ns', 'STNS_ns', 'HWNS_ns', 'HTNS_ns'], map(float, match.groups())))
assert all(value >= 0 for value in timing.values()), 'Negative final timing; refuse candidate'
area = (MANUAL / 'AC201_tf_hdmi_phy.area').read_text()
resources = {}
for name in ['lut', 'reg', 'le', 'bram9k', 'dsp', 'gclk']:
    match = re.search(rf'^\s*#{name}\s+(\d+)', area, re.M)
    assert match, f'Missing resource {name}'
    resources[name] = int(match.group(1))
coverage = re.search(r'STA coverage\s*:\s*([\d.]+)%', (MANUAL / 'AC201_tf_hdmi_pr.timing').read_text())
assert coverage
assert BIT.is_file() and BIT.stat().st_size == 629624

info = {
    'created_beijing': datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S'),
    'status': 'Dynamic text candidate: local models, build and original-constraint timing passed; hardware pending',
    'device': 'EG4S20BG256', 'td': '6.2.178840', 'baseline': baseline,
    'source_delta': {'changed': changed, 'added': added, 'unchanged': same, 'source_files': 75},
    'behavior': {'runtime': 'RUN MM:SS; reset release to 99:59, wraps to 00:00; nominal 25MHz pixel clock',
                 'time_panel': [448, 16, 624, 48],
                 'scroll_panel': [16, 432, 624, 464],
                 'text': 'FPGA MEDIA PLAYER', 'scroll': '1 pixel per VS rising edge; 880-frame period',
                 'keys': 'existing manual/auto/internal-tone mapping unchanged',
                 'overlay': 'black background, white text; no added RGB/VS/DE pipeline delay; no adjustable opacity'},
    'bitstream': str(BIT), 'bytes': BIT.stat().st_size, 'sha256': sha(BIT),
    'routed_db_sha256': sha(MANUAL / 'AC201_tf_hdmi_pr.db'),
    'timing': timing, 'sta_coverage_percent': float(coverage.group(1)), 'resources': resources,
    'models': tests, 'hardware_result': 'not tested',
    'physical_flow': 'documented high-effort timing placement + routability route + original-constraint fix_hold',
    'assistant_board_operations': 'none', 'card_or_flash_writes': 'none',
    'limits': ['Models do not prove actual electrical/CDC/PLL/receiver correctness',
               '25MHz and timer nominal; physical frequency not measured',
               'Whole physical implementation changes; historical fault root cause remains unmeasured',
               'Long run, cold reload and changed/fragmented-card hardware regression pending',
               'Fixed text and colors; no lyric file, Chinese glyphs or adjustable transparency'],
}
write_json(MANUAL / 'AC201_player_dynamic_text.info.json', info)

CHECKPOINT.mkdir(parents=True)
for name in ['src', 'scripts', 'sim']:
    shutil.copytree(PROJECT / name, CHECKPOINT / name)
for name in ['manual', 'prehold', 'osd_sim', 'state_sim', 'dynamic_sim']:
    shutil.copytree(PROJECT / 'build' / name, CHECKPOINT / 'build' / name)
for name in ['baseline.json', 'source_delta.json', 'model_results.json']:
    shutil.copy2(PROJECT / 'build' / name, CHECKPOINT / 'build' / name)
manifest = [{'path': path.relative_to(CHECKPOINT).as_posix(), 'bytes': path.stat().st_size,
             'sha256': sha(path)} for path in sorted(CHECKPOINT.rglob('*')) if path.is_file()]
write_json(CHECKPOINT / 'manifest.json', manifest)
for item in manifest:
    path = CHECKPOINT / item['path']
    assert path.stat().st_size == item['bytes'] and sha(path) == item['sha256']

short_path = ROOT / 'download/dynamic_text.bit'
if short_path.exists():
    assert sha(short_path) == sha(BIT), 'Existing short candidate differs'
else:
    shutil.copy2(BIT, short_path)

readme = '''动态字幕候选（2026-10-09），实板待验证。
BitWriter添加英文路径firmware/dynamic_text.bit，PROGRAM_SRAM。
保持已有TF卡/供电/HDMI/音量，不需要复制任何新素材到卡。
预期：原左上IMG/MANUAL/AUTO，右上RUN MM:SS每秒递增，底部FPGA MEDIA PLAYER从右向左滚动。
底条初始文字位于右边界外，约5秒可看全；一轮约15秒。计时为播放器复位后的运行时间，不是系统时钟/歌曲进度。
KEY0点按手动切图；KEY1短按开关自动轮播；长按约2秒切内部音阶（松开至少1.5秒可再次长按）。
请测试切图/轮播时字幕继续运行，图片颜色/音乐无异常；长按后的内部音阶也应正常。
有问题保持条件回载firmware/osd_phy_fix.bit（已验证成功版），保存异常现象。
全部为SRAM临时配置；本包不写Flash，断电后需重新下载。
支持/限制与本地验证见build_info.json；本版固定配色，不支持外部歌词文件或可调透明度。
'''
members = {
    'firmware/dynamic_text.bit': BIT.read_bytes(),
    'firmware/osd_phy_fix.bit': FALLBACK.read_bytes(),
    'README.txt': readme.encode('utf-8-sig'),
    'build_info.json': json.dumps(info, ensure_ascii=False, indent=2).encode('utf-8'),
}
checksums = {name: {'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest().upper()}
             for name, data in members.items()}
members['checksums.json'] = json.dumps(checksums, indent=2).encode('utf-8')
with zipfile.ZipFile(PACKAGE, 'x', compression=zipfile.ZIP_DEFLATED) as archive:
    for name, data in members.items():
        archive.writestr(name, data)
with zipfile.ZipFile(PACKAGE) as archive:
    assert archive.testzip() is None
    assert set(archive.namelist()) == set(members)
    for name, data in members.items():
        assert archive.read(name) == data
result = {'checkpoint': str(CHECKPOINT), 'checkpoint_files': len(manifest),
          'bitstream': str(short_path), 'bytes': info['bytes'], 'sha256': info['sha256'],
          'timing': timing, 'resources': resources, 'coverage_percent': info['sta_coverage_percent'],
          'package': str(PACKAGE), 'package_bytes': PACKAGE.stat().st_size,
          'package_sha256': sha(PACKAGE), 'zip_crc_and_members': 'PASS', 'hardware_result': 'pending'}
write_json(ROOT / 'deliverables/dynamic_text_20261009.package_audit.json', result)
print(json.dumps(result))
