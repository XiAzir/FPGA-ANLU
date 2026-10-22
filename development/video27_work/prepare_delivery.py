from pathlib import Path
import datetime
import hashlib
import json
import re
import shutil
import zipfile

ROOT = Path(__file__).resolve().parents[2]
p = ROOT / 'development/player_video27_command_boundary'
sha = lambda f: hashlib.sha256(f.read_bytes()).hexdigest()
read = lambda f: json.loads(f.read_text(encoding='utf-8-sig'))

def save(f, value):
    f.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

binding = read(p / 'verification/final_stage_binding.json')
tests = read(p / 'verification/offline_tests.json')
export = read(p / 'verification/routed_export_binding.json')
assert binding['status'] == tests['status'] == export['status'] == 'PASS'
assert export['database_sha256'].lower() == sha(p / 'build/manual/AC201_tf_hdmi_pr.db')
assert export['final_routed_sha256'].lower() == sha(p / 'verification/final_routed.v')
for row in tests['inputs']:
    assert sha(p / 'src/user_source' / row['path']) == row['candidate_sha256']
    assert sha(ROOT / 'development/player_video26_runtime_diag/src/user_source' / row['path']) == row['base_sha256']
for run in tests['system_runs']:
    folder = Path(run['directory'])
    for filename, key in [('summary.json', 'summary_sha256'), ('source_receipt.json', 'source_receipt_sha256'),
                          ('console.log', 'console_sha256'), ('tb_video_system.v', 'testbench_sha256')]:
        assert sha(folder / filename) == run[key]
timing = (p / 'build/manual/AC201_tf_hdmi_phy.ts').read_text()
m = re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.', timing)
assert m and all(float(x) >= 0 for x in m.groups())
net = (p / 'verification/final_routed.v').read_text(encoding='utf-8-sig')
counts = {kind: len(re.findall(r'^\s*' + kind + r'\s*#', net, re.M))
          for kind in ['EG_PHY_MSLICE', 'EG_PHY_LSLICE']}
slices = sum(counts.values())
assert 0 < slices <= 9800
bit = p / 'build/manual/AC201_player_video27_command_boundary.bit'
assert sha(bit) == binding['bit_sha256'].lower()
package = ROOT / 'deliverables/video27_command_boundary_c11327_20261022'
package.mkdir(exist_ok=True)
validation = {
    'status': 'COMMAND_BOUNDARY_OFFLINE_PASS_BOARD_PENDING',
    'build_id': '00C11327', 'base': 'C11326 runtime diagnostic candidate',
    'purpose': 'Finish six command bytes before interpreting R1; sample response-phase bytes only',
    'bit_sha256': sha(bit), 'changed_files': tests['changed'],
    'unchanged_user_source_count': tests['unchanged_user_source_count'],
    'timing_ns': dict(zip(['setup_wns', 'setup_tns', 'hold_wns', 'hold_tns'], map(float, m.groups()))),
    'routed_slices': counts, 'slice_used': slices, 'slice_percent': slices / 98,
    'offline_tests': tests, 'offline_tests_sha256': sha(p / 'verification/offline_tests.json'),
    'final_stage_binding_sha256': sha(p / 'verification/final_stage_binding.json'),
    'final_routed_sha256': sha(p / 'verification/final_routed.v'),
    'routed_export_binding_sha256': sha(p / 'verification/routed_export_binding.json'),
    'board_result': 'Pending',
    'outstanding': ['C26 image corruption and silence', 'C22 audio noise', 'Hardware CMD8 causal verification'],
    'created_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
}
save(p / 'verification/final_binding.json', validation)
save(package / 'validation.json', validation)
for target in [ROOT / 'download/video27_command_boundary.bit', package / 'video27_command_boundary.bit']:
    shutil.copy2(bit, target)
for name in ['canonical_crc_period_1875.csv', 'crc_period_metadata.json']:
    shutil.copy2(ROOT / 'deliverables/video22_audio_diag_c11322_20261022' / name, package / name)
manual = '''C11327 SD命令发送/响应边界修正版

位流video27_command_boundary.bit；版本页00C11327。
基于C26，仅修正sd_card_cmd六字节命令发完后才检查R1，版本页同步更新。
D页最后采样字节限定在响应阶段。SPI工作态12.5MHz；TF文件沿用当前版本。
无新增重试、超时或回退分支。C22保留可播放对照，原位流保持。

建议实板顺序：
1. 加载后等待10秒，核对00C11327、图片轮切、原声和内置音阶。
2. 进入视频，确认画面/声音，然后短KEY0从头播放，连续试3次。
3. 图片→视频→图片往返，包含视频仅播1～2秒就返回。
4. 若再次仅UI，录完整一轮数码管；重点ID、2开头状态、CRC、B/C/D。
   同时保留图片绿点、IMG0/4和声音状态，便于与C26原反馈对照。

离线验证：命令边界候选168项通过，原版72项提前解析失败被检出，8项错误R1控制通过；
完整冷启视频/PCM及6次模式/重播整机回归结果见validation.json。
使用名义PLL与SDRAM应用模型；实板CMD8停住的因果、图片异常和无声继续等待现场验证。

B页：bit27 video_mode，bit26/25 raw key1/key2（1=松开）；bit24:9为adjust debug；
bit8:5 mode事件计数，bit4 media_reset，bit3冷reset，bit2 card_init_done，bit1/0两PLL lock。
C页：bit27:23 SD controller，bit22:18 command，bit17:15 SPI state；
bit14/13/12 cmd_req/ack/error，bit11 init，bit10/9/8 shared_read/end/valid；
bit7/6/5/4 CS/SCLK/MOSI/MISO，bit3/2 media/cold reset，bit1/0两PLL lock。
D页：bit27:22命令号，bit21:14预期R1，bit13:6响应阶段最后采样字节，低6位0。
响应等待期间FF等高位为1的字节也会显示；实际响应判定沿用原驱动规则。
'''
(package / '操作说明.txt').write_text(manual, encoding='utf-8')
info = {'build_id': '00C11327', 'sha256': sha(bit), 'status': validation['status'],
        'purpose': validation['purpose'], 'validation': str(package / 'validation.json')}
save(package / 'video27_command_boundary.info.json', info)
save(ROOT / 'download/video27_command_boundary.info.json', info)
files = [{'name': q.name, 'bytes': q.stat().st_size, 'sha256': sha(q)}
         for q in sorted(package.iterdir()) if q.is_file() and q.name != 'receipt.json']
save(package / 'receipt.json', {'build_id': '00C11327', 'files': files})
zpath = package.with_suffix('.zip')
with zipfile.ZipFile(zpath, 'w', zipfile.ZIP_DEFLATED) as z:
    for q in sorted(package.iterdir()):
        if q.is_file():
            z.write(q, q.name)
with zipfile.ZipFile(zpath) as z:
    assert z.testzip() is None
    for row in files:
        assert hashlib.sha256(z.read(row['name'])).hexdigest() == row['sha256']
assert len({sha(bit), sha(ROOT / 'download/video27_command_boundary.bit'), sha(package / 'video27_command_boundary.bit')}) == 1
record = {'status': 'PASS_OFFLINE_DELIVERY_BOARD_PENDING', 'bit_sha256': sha(bit),
          'zip_sha256': sha(zpath), 'zip_bytes': zpath.stat().st_size,
          'payloads': len(files) + 1, 'slice_used': slices,
          'slice_percent': slices / 98, 'timing_ns': validation['timing_ns']}
save(p / 'verification/delivery_receipt.json', record)
print(json.dumps(record, ensure_ascii=False, indent=2))
