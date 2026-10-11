"""Validate, preserve and package one bounded resource candidate; never overwrite."""
import hashlib
import json
import re
import shutil
import zipfile
from datetime import datetime, timezone, timedelta
from pathlib import Path

project = Path(__file__).resolve().parent.parent
root = project.parent.parent
manual = project / 'build/manual'
original = root / 'development/player_dynamic_text'
experiment = project / 'sim/mapper_width_experiment'
checkpoint = project / 'checkpoints/dynamic_text_fit_20261009_candidate'
package = root / 'deliverables/dynamic_text_fit_20261009.zip'
short_bit = root / 'download/dynamic_text_fit.bit'
bit = manual / 'AC201_player_dynamic_text_fit.bit'
fallback = root / 'download/osd_phy_fix.bit'
fallback_sha = '9E893B0B6C86BF6FBEE19E74B5FB58933C1BEA6AA07F203786CCE96F3B60AE6F'

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest().upper()

def read_json(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))

def write_json(path, data):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

def successful_log(path, marker):
    text = path.read_text(encoding='utf-8-sig', errors='replace')
    assert marker in text, f'Missing {marker}: {path}'
    return text

assert not checkpoint.exists() and not package.exists() and not short_bit.exists(), 'Never overwrite artifacts'
for stage, marker in [('synthesis', 'SYNTHESIS_COMPLETE_WITH_GATE_DATABASE'),
                      ('physical', 'PLACE_ROUTE_COMPLETE_WITH_REPORTS'),
                      ('hold', 'POST_ROUTE_HOLD_FIX_COMPLETE'), ('bitstream', 'BITSTREAM_GENERATED')]:
    successful_log(manual / (stage + '_console.log'), marker)
for entry in read_json(manual / 'build_source_scope.json'):
    assert sha(project / 'src' / entry['path'].replace('\\', '/')) == entry['sha256'], 'Synthesis inputs changed'

old_user = original / 'src/user_source'
new_user = project / 'src/user_source'
files = sorted(p for p in new_user.rglob('*') if p.is_file())
assert len(files) == 75
changed = [p.relative_to(new_user).as_posix() for p in files if sha(p) != sha(old_user / p.relative_to(new_user))]
assert changed == ['hdl_source/fat32_file_sector.v'], changed
test_mapper = (experiment / 'fat32_file_sector_narrow.v').read_text(encoding='utf-8-sig')
assert (new_user / 'hdl_source/fat32_file_sector.v').read_text(encoding='utf-8-sig') == test_mapper.replace('module fat32_file_sector_narrow', 'module fat32_file_sector', 1), 'Test/candidate mapper binding differs'
test_old = (experiment / 'fat32_file_sector_original.v').read_text(encoding='utf-8-sig')
assert (old_user / 'hdl_source/fat32_file_sector.v').read_text(encoding='utf-8-sig') == test_old.replace('module fat32_file_sector_original', 'module fat32_file_sector', 1), 'Test reference binding differs'
assert sha(fallback) == fallback_sha

frozen_counts = {}
for frozen in [root / 'development/player_osd_phy_fix/checkpoints/osd_phy_fix_20261009_candidate',
               original / 'checkpoints/dynamic_text_20261009_candidate']:
    manifest = read_json(frozen / 'manifest.json')
    for entry in manifest:
        path = frozen / entry['path']
        assert path.stat().st_size == entry['bytes'] and sha(path) == entry['sha256'], f'Frozen artifact changed: {path}'
    frozen_counts[str(frozen)] = len(manifest)

models = {}
for name, path, marker in [
    ('mapper_original_bytegap', experiment / 'tb_fat32_file_sector_existing_run.log', 'PASS:'),
    ('mapper_narrow_bytegap', experiment / 'tb_fat32_file_sector_narrow_existing_run.log', 'PASS:'),
    ('mapper_cycle_equivalence', experiment / 'tb_mapper_width_equiv_run.log', 'PASS: cycle-equivalent'),
    ('dynamic_pixels_same_source', original / 'build/dynamic_sim/pixels_run.log', 'PASS pixels=1843200'),
    ('dynamic_timer_same_source', original / 'build/dynamic_sim/timer_run.log', '12000-cycle wrap path'),
    ('osd_same_source', original / 'build/osd_sim/run.log', 'PASS:'),
    ('state_same_source', original / 'build/state_sim/run.log', 'PASS coherent'),
]:
    value = successful_log(path, marker)
    assert not re.search(r'FAIL|FATAL', value), f'Failed model: {path}'
    models[name] = {'path': str(path), 'sha256': sha(path),
                    'result': [line for line in value.splitlines() if line.startswith('PASS')],
                    'same_source_evidence_reused': name.endswith('same_source')}

match = re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.', (manual / 'AC201_tf_hdmi_phy.ts').read_text())
assert match, 'Missing routed timing'
timing = dict(zip(['SWNS_ns', 'STNS_ns', 'HWNS_ns', 'HTNS_ns'], map(float, match.groups())))
assert all(x >= 0 for x in timing.values()), 'Timing violation remains'
area = (manual / 'AC201_tf_hdmi_phy.area').read_text()
resources = {name: int(re.search(rf'^\s*#{name}\s+(\d+)', area, re.M).group(1)) for name in ['lut', 'reg', 'le', 'bram9k', 'dsp', 'gclk']}
coverage = float(re.search(r'STA coverage\s*:\s*([\d.]+)%', (manual / 'AC201_tf_hdmi_pr.timing').read_text()).group(1))
assert bit.is_file() and bit.stat().st_size == 629624
info = {'created_beijing': datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S'),
        'status': 'Resource candidate: local models and original-constraint STA passed; hardware NOT TESTED',
        'device': 'EG4S20BG256', 'td': '6.2.178840',
        'source_change': {'versus': str(original), 'changed': changed, 'unchanged': 74, 'files': 75,
            'detail': 'Brent anchor stays 32 bits; power/cache_power 14 bits; length/cache_length 13 bits. Existing 4096-cluster/hop limits, algorithm and interfaces unchanged.',
            'renderer': 'Original dynamic-text renderer retained; shared-font experiment rejected after PHY-9009.'},
        'bitstream': str(bit), 'bytes': bit.stat().st_size, 'sha256': sha(bit),
        'routed_db_sha256': sha(manual / 'AC201_tf_hdmi_pr.db'),
        'timing': timing, 'sta_coverage_percent': coverage, 'resources': resources,
        'models': models, 'frozen_guards': frozen_counts, 'fallback_sha256': fallback_sha,
        'hardware_result': 'NOT_TESTED', 'root_cause': 'NOT_CONFIRMED',
        'card_or_flash_writes': 'NONE',
        'limitations': ['STA lacks characterized SPI input and HDMI receiver output budgets.',
            'Simulation equivalence covers tested cases; it is not a complete formal proof.',
            'Resource optimization and new placement do not uniquely prove the historical physical fault.',
            'Runtime and scroll use nominal 25MHz/VS; frequency and long-duration operation not measured.']}
write_json(manual / 'AC201_player_dynamic_text_fit.info.json', info)
write_json(project / 'build/model_results.json', models)

checkpoint.mkdir(parents=True)
for name in ['src', 'scripts', 'sim']:
    shutil.copytree(project / name, checkpoint / name)
for name in ['manual', 'prehold', 'reused_models', 'axis_readonly_audit']:
    if (project / 'build' / name).exists():
        shutil.copytree(project / 'build' / name, checkpoint / 'build' / name)
for name in ['preparation.json', 'model_results.json', 'package_review.md']:
    shutil.copy2(project / 'build' / name, checkpoint / 'build' / name)
manifest = [{'path': p.relative_to(checkpoint).as_posix(), 'bytes': p.stat().st_size, 'sha256': sha(p)}
            for p in sorted(checkpoint.rglob('*')) if p.is_file()]
write_json(checkpoint / 'manifest.json', manifest)
for item in manifest:
    path = checkpoint / item['path']
    assert path.stat().st_size == item['bytes'] and sha(path) == item['sha256']
shutil.copy2(bit, short_bit)
assert sha(short_bit) == info['sha256']

readme = '''动态字幕资源优化候选，2026-10-09；实板待测，根因未确认。
解压到英文路径，BitWriter添加firmware/dynamic_text_fit.bit，用PROGRAM_SRAM下载。
TF卡素材不改，保持供电/HDMI/音量和成功版测试条件不变。
预期：四张图片及原IMG/MANUAL/AUTO状态栏；右上RUN MM:SS每秒递增；底部FPGA MEDIA PLAYER由右向左滚动，约15秒一轮。
KEY0点按切图；KEY1短按开/关自动轮播；KEY1长按约2秒切内部音阶，松开至少1.5秒可再长按切回。
验证图片颜色、天之弱音乐、切图/轮播、内部音阶、计时和字幕是否全正常；观察约1分钟是否中断。
如异常，保持条件回载firmware/osd_phy_fix.bit成功基线，反馈异常现象。
本包不含新素材、不写TF/Flash；SRAM下载掉电后需重新下载。
本候选仅缩小FAT循环检测计数器的存储位数；现有4096簇限制和功能不变，不能据此宣称历史故障原因已证。
'''
members = {'firmware/dynamic_text_fit.bit': bit.read_bytes(), 'firmware/osd_phy_fix.bit': fallback.read_bytes(),
           'README.txt': readme.encode('utf-8-sig'), 'build_info.json': json.dumps(info, ensure_ascii=False, indent=2).encode('utf-8')}
members['checksums.json'] = json.dumps({n: {'bytes': len(b), 'sha256': hashlib.sha256(b).hexdigest().upper()} for n, b in members.items()}, indent=2).encode('utf-8')
with zipfile.ZipFile(package, 'x', compression=zipfile.ZIP_DEFLATED) as archive:
    for name, data in members.items():
        archive.writestr(name, data)
with zipfile.ZipFile(package) as archive:
    assert archive.testzip() is None and set(archive.namelist()) == set(members)
    for name, data in members.items():
        assert archive.read(name) == data
result = {'checkpoint': str(checkpoint), 'files': len(manifest), 'bitstream': str(short_bit),
          'sha256': info['sha256'], 'timing': timing, 'resources': resources,
          'coverage': coverage, 'package': str(package), 'package_bytes': package.stat().st_size,
          'package_sha256': sha(package), 'hardware': 'NOT_TESTED', 'zip_check': 'PASS'}
write_json(root / 'deliverables/dynamic_text_fit_20261009.package_audit.json', result)
print(json.dumps(result))
