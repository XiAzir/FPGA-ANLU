from pathlib import Path
import datetime
import hashlib
import json
import re
import shutil
import zipfile

ROOT = Path(__file__).resolve().parents[2]
p = ROOT / 'development/player_video26_runtime_diag'
base = ROOT / 'development/player_video22_audio_diag'
sha = lambda f: hashlib.sha256(f.read_bytes()).hexdigest()
read = lambda f: json.loads(f.read_text(encoding='utf-8-sig'))


def save(f, value):
    f.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


binding = read(p / 'verification/final_stage_binding.json')
checks = read(p / 'verification/passive_source_checks.json')
tests = read(p / 'verification/runtime_diag_tests.json')
assert binding['status'] == checks['status'] == tests['status'] == 'PASS'
for row in checks['inputs']:
    assert sha(p / 'src/user_source' / row['path']) == row['candidate_sha256']
    assert sha(base / 'src/user_source' / row['path']) == row['base_sha256']
for row in tests['inputs']:
    assert sha(Path(row['path'])) == row['sha256']
old = {q.relative_to(base / 'src/user_source').as_posix(): sha(q)
       for q in (base / 'src/user_source').rglob('*') if q.is_file()}
new = {q.relative_to(p / 'src/user_source').as_posix(): sha(q)
       for q in (p / 'src/user_source').rglob('*') if q.is_file()}
assert old.keys() == new.keys()
changed = sorted(k for k in old if old[k] != new[k])
assert changed == sorted(['hdl_source/SD/sd_card_cmd.v', 'hdl_source/SD/sd_card_sec_read_write.v',
                          'hdl_source/SD/sd_card_top.v', 'hdl_source/SD/spi_master.v',
                          'hdl_source/player_adjust_control.v',
                          'hdl_source/player_compact_status_pages.v',
                          'hdl_source/top_tf_hdmi_audio.v'])
timing = (p / 'build/manual/AC201_tf_hdmi_phy.ts').read_text()
m = re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.', timing)
assert m and all(float(x) >= 0 for x in m.groups())
net = (p / 'verification/final_routed.v').read_text(encoding='utf-8-sig')
counts = {kind: len(re.findall(r'^\s*' + kind + r'\s*#', net, re.M))
          for kind in ['EG_PHY_MSLICE', 'EG_PHY_LSLICE']}
slices = sum(counts.values())
assert 0 < slices <= 9800
bit = p / 'build/manual/AC201_player_video26_runtime_diag.bit'
assert sha(bit) == binding['bit_sha256'].lower()
package = ROOT / 'deliverables/video26_runtime_diag_c11326_20261022'
package.mkdir(exist_ok=True)
validation = {
    'status': 'PASSIVE_DIAGNOSTIC_OFFLINE_PASS_BOARD_PENDING',
    'build_id': '00C11326', 'base': 'C11322 user-confirmed playable',
    'purpose': 'Observe chord recognition/mode event and SD controller/command/SPI stalls',
    'bit_sha256': sha(bit), 'changed_files': changed,
    'unchanged_user_source_count': len(old) - len(changed),
    'timing_ns': dict(zip(['setup_wns', 'setup_tns', 'hold_wns', 'hold_tns'], map(float, m.groups()))),
    'routed_slices': counts, 'slice_used': slices, 'slice_percent': slices / 98,
    'source_checks': checks,
    'source_checks_sha256': sha(p / 'verification/passive_source_checks.json'),
    'runtime_tests': tests,
    'runtime_tests_sha256': sha(p / 'verification/runtime_diag_tests.json'),
    'final_stage_binding_sha256': sha(p / 'verification/final_stage_binding.json'),
    'board_result': 'Pending', 'functional_changes': 'Passive observation only; C22 control retained',
    'created_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
}
save(p / 'verification/final_binding.json', validation)
save(package / 'validation.json', validation)
for target in [ROOT / 'download/video26_runtime_diag.bit', package / 'video26_runtime_diag.bit']:
    shutil.copy2(bit, target)
for name in ['canonical_crc_period_1875.csv', 'crc_period_metadata.json']:
    shutil.copy2(ROOT / 'deliverables/video22_audio_diag_c11322_20261022' / name, package / name)
manual = '''C11326 按键与SD运行状态观测版

位流video26_runtime_diag.bit；版本页00C11326。
基底为可播放的C11322。TF文件沿用；播放、模式、初始化、音频和PHY控制保持C22。
新增被动状态输出与模式事件计数，复用B/C/D三页；诊断页不参与控制。

测试顺序：
1. 同一卡与接线加载后，先确认图片/原声启动，记录ID、2开头状态、其后一页CRC。
2. 切到视频正常播放后，拍一段完整数码管循环。
3. 若双键长按仍无反应，请录约40秒：先两键共同按住约20秒，再全部松开并继续录20秒。
   这样能覆盖按住期间及松开后的完整数码管循环，直接看到B页按键识别及事件计数。
4. 若短KEY0重播后停在UI，记录当时B/C/D页及版本/2开头状态/CRC；录像一轮即可。

B页hex解码：高4位固定B，bit27 video_mode；bit26/25为raw key1/key2（1=松开）；
bit24:9为adjust debug：bit15/14消抖key0/key1（1=按下）、bit13 chord_active、bit12 chord_long_done、
bit11:4为chord_hold_count的高8位、bit3:2调节mode、bit1/0为next/auto mailbox busy。
页B bit8:5是video_mode_press累计次数（4位回绕，跨媒体重启保持）；bit4 media_reset，
bit3冷启动reset，bit2 card_init_done，bit1 sys_pll_lock，bit0 video_pll_lock。

C页：高4位固定C；bit27:23 SD controller state（完整5位），bit22:18 command state，bit17:15 SPI state；
bit14 cmd_req、bit13 cmd_req_ack、bit12 cmd_req_error；
bit11 card_init_done、bit10 shared_read、bit9 shared_end、bit8 shared_valid；
bit7 CS、bit6 SCLK、bit5 MOSI、bit4 MISO；bit3 media_reset、bit2冷启动reset、bit1/0两PLL lock。

D页：高4位固定D；bit27:22为当前SD命令号，bit21:14为预期R1，bit13:6为最后收到的R1，
bit5:0填零。R1只在命令响应采样时更新，复位值FF。

其余诊断页沿用C22。B/C/D旧的首次字节等待/FIFO水位/PCM样本计数显示由新观测替代。
该版用于定位已有故障；杂音和偶发媒体失败的修复结论等待现场结果。
'''
(package / '操作说明.txt').write_text(manual, encoding='utf-8')
info = {'build_id': '00C11326', 'sha256': sha(bit), 'status': validation['status'],
        'purpose': validation['purpose'], 'validation': str(package / 'validation.json')}
save(package / 'video26_runtime_diag.info.json', info)
save(ROOT / 'download/video26_runtime_diag.info.json', info)
files = [{'name': q.name, 'bytes': q.stat().st_size, 'sha256': sha(q)}
         for q in sorted(package.iterdir()) if q.is_file() and q.name != 'receipt.json']
save(package / 'receipt.json', {'build_id': '00C11326', 'files': files})
zpath = package.with_suffix('.zip')
with zipfile.ZipFile(zpath, 'w', zipfile.ZIP_DEFLATED) as z:
    for q in sorted(package.iterdir()):
        if q.is_file():
            z.write(q, q.name)
with zipfile.ZipFile(zpath) as z:
    assert z.testzip() is None
    for row in files:
        assert hashlib.sha256(z.read(row['name'])).hexdigest() == row['sha256']
assert len({sha(bit), sha(ROOT / 'download/video26_runtime_diag.bit'), sha(package / 'video26_runtime_diag.bit')}) == 1
record = {'status': 'PASS_DIAGNOSTIC_DELIVERY', 'bit_sha256': sha(bit),
          'zip_sha256': sha(zpath), 'zip_bytes': zpath.stat().st_size,
          'payloads': len(files) + 1, 'slice_used': slices,
          'slice_percent': slices / 98, 'timing_ns': validation['timing_ns']}
save(p / 'verification/delivery_receipt.json', record)
print(json.dumps(record, ensure_ascii=False, indent=2))
