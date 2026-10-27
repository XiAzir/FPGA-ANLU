"""Seal the existing C40 routed implementation and board-test package."""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import shutil
import zipfile

ROOT = Path(__file__).resolve().parents[2]
PROJECT = ROOT / 'development/player_video40_spi25'
WORK = ROOT / 'development/video40_work'
VERIFY = PROJECT / 'verification'
BUILD = PROJECT / 'build/manual'
PACKAGE = ROOT / 'deliverables/video40_spi25_20261027'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_json(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))


def write_json(path, data):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


binding = read_json(VERIFY / 'final_stage_binding.json')
assert binding['status'] == 'PASS'
bit = BUILD / 'AC201_player_video40_spi25.bit'
assert sha(bit) == binding['bit_sha256']
for item in binding['inputs']:
    assert sha(PROJECT / item['path']) == item['sha256'], item['path']
for name, digest in binding['stages']['physical']['artifacts'].items():
    assert sha(BUILD / name) == digest, name
audit = read_json(VERIFY / 'source_audit.json')
for name, digest in audit['candidate_sources'].items():
    assert sha(PROJECT / 'src/user_source' / name) == digest, name
card = read_json(WORK / 'card/summary.json')
assert card['state'] == 'PASS'
for name, digest in card['source_sha256'].items():
    assert sha(ROOT / name) == digest, name
byte = read_json(WORK / 'spi_candidate/results_production.json')
assert byte['result'] == 'PASS'
assert byte['production_candidate_sha256'].lower() == audit['SPI_production_sha256']
baseline = ROOT / 'download/video32_read_return.bit'
assert sha(baseline) == audit['baseline_bit_sha256']
raw_review = WORK / 'timing_review/final_io_review/c40_miso_io_review.json'
assert raw_review.is_file()
route_qor = (PROJECT / 'src/td_project/route.qor').read_text(encoding='utf-8-sig')
slices = int(re.search(r'#slices\s*\|\s*(\d+)', route_qor)[1])
assert slices == 8818
timestamp = datetime.now(timezone.utc).isoformat()
info = {
    'status': 'OFFLINE_VERIFIED_SPI_BOARD_PENDING',
    'build_id': '00C11340', 'created_utc': timestamp,
    'filename': 'video40_spi25.bit', 'bit_sha256': sha(bit), 'bit_bytes': bit.stat().st_size,
    'purpose': '以已板测C32为基线，单独验证TF数据SPI25MHz。原HDMI、480p播放器、SDRAM50MHz。',
    'board_result': 'PENDING',
    'clocks_hz': {'sd_logic': 50000000, 'spi_initialization': 100000, 'spi_data': 25000000, 'sdram': 50000000},
    'slice_used': slices, 'slice_percent': slices / 9800 * 100,
    'C32_slice_used': 8778, 'slice_delta_vs_C32': slices - 8778,
    'physical_resources': {'lut': 16851, 'reg': 8753, 'le': 16894, 'bram': 62, 'dsp': 26, 'pll': 2, 'gclk': 3},
    'timing_ns': {'setup_wns': 1.531, 'setup_tns': 0.0, 'hold_wns': 0.011, 'hold_tns': 0.0},
    'STA_coverage_percent': 99.99,
    'timing_scope': 'Production constrained internal paths. External card/PCB min/max IO delays remain uncharacterized.',
    'model_throughput_Bps': {'C32_mode': 1353351.660, 'C40_mode': 2434385.698},
    'throughput_scope': '32 sectors, identical 50MHz SDHC pin model/commands; not real-card throughput.',
    'external_setup_estimate_ns': 11.734,
    'external_setup_scope': 'Remaining card tOD plus PCB SCK/MISO round-trip allowance from routed SCK/MISO paths, artificial pressure constraints. Not measured margin.',
    'runtime_pages': {'00C11340': '版本', 'C000xxxx': '已校验512字节扇区数，十六进制，16位饱和', 'E000xxxx': 'CRC16不一致扇区数，十六进制，16位饱和'},
    'observation_policy': '被动CRC观察，仅计数；无重试、自动降速或控制流反馈。',
    'existing_baseline_issue': {
        'name': 'SDRAM periodic refresh request macro',
        'source_macro_value': 0,
        'evidence': 'C32/C40 macro/public-prefix tests and gate Sdr_ref_req tied to zero.',
        'state': 'Inherited unchanged for isolated TF comparison; separate repair candidate pending.',
        'board_fault_causality': 'UNDETERMINED',
    },
    'source_delta': audit['changed'], 'unchanged_user_sources': audit['unchanged_user_sources'],
    'baseline_bit_sha256': sha(baseline),
    'source_audit_sha256': sha(VERIFY / 'source_audit.json'),
    'final_stage_binding_sha256': sha(VERIFY / 'final_stage_binding.json'),
    'routed_database_sha256': sha(BUILD / 'AC201_tf_hdmi_pr.db'),
    'final_routed_netlist_sha256': sha(VERIFY / 'final_routed.v'),
    'outstanding': ['TF25 real-card CRC and media board test', 'Card/PCB external minimum/maximum timing measurement', 'Independent SDRAM periodic refresh repair and validation', 'SDRAM100 and HD player integration'],
}
write_json(VERIFY / 'delivery_info.json', info)
shutil.copy2(bit, ROOT / 'download/video40_spi25.bit')
write_json(ROOT / 'download/video40_spi25.info.json', info)
PACKAGE.mkdir(exist_ok=False)
payloads = {
    'video40_spi25.bit': ROOT / 'download/video40_spi25.bit',
    'video40_spi25.info.json': ROOT / 'download/video40_spi25.info.json',
    'rollback/video32_read_return.bit': baseline,
    'rollback/video32_read_return.info.json': ROOT / 'download/video32_read_return.info.json',
    'evidence/final_stage_binding.json': VERIFY / 'final_stage_binding.json',
    'evidence/source_audit.json': VERIFY / 'source_audit.json',
    'evidence/card_summary.json': WORK / 'card/summary.json',
    'evidence/byte_results_production.json': WORK / 'spi_candidate/results_production.json',
    'evidence/final_timing.rpt': PROJECT / 'src/td_project/final_timing.rpt',
    'evidence/route.qor': PROJECT / 'src/td_project/route.qor',
    'evidence/routed_external_io_review.md': WORK / 'timing_review/final_io_review/c40_miso_io_review.md',
    'evidence/routed_external_io_review.json': raw_review,
    'evidence/SDRAM_refresh_macro_audit.md': WORK / 'timing_review/refresh_macro/README.md',
}
for name, source in payloads.items():
    target = PACKAGE / name
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, target)

guide = '''# C40：TF SPI 25MHz 单项上板验证

## 版本与接线

- 使用 `video40_spi25.bit`，数码管版本 `00C11340`。
- 使用原 HDMI 母座、现有外接 5V 供电、原 TF 卡和原卡内文件。
- 本版以正常 C32 的 640×480 播放器为基线，视频内容仍为原来的15fps。SDRAM继续50MHz；本版测试TF数据25MHz。
- SD初始化保持100kHz，初始化完成后的数据传输使用25MHz。

## 加载与观察

1. BitWriter 选择 EG4S20BG256、PROGRAM_SRAM、原5MHz JTAG下载配置，加载 `video40_spi25.bit`。
2. 等10秒，确认版本页为 `00C11340`。数码管每秒轮换一页，共三页。
3. `C000xxxx`：512字节扇区CRC校验次数。xxxx为十六进制；读取过程中增加，到FFFF后饱和。
4. `E000xxxx`：CRC不一致的扇区数，期望一直为 `E0000000`。
5. 先看图片和原声、切图动画；再双键共同长按至少1.5秒并松开，进入视频，观察原声/频谱与图像。
6. 视频持续播放至少3分钟，做5次图片→视频→图片往返，包括播放1～2秒后返回；结束时记录C页和E页。
7. 用同一配置做3次冷启动。每次记下能否自动进入图片播放、E页数值；保持卡内文件和供电条件一致。

## 反馈内容

记录版本、首次出图/出声、图片/切图、视频、切换重启结果，以及开头/结尾C与E页。出现异常时录屏幕和三页数码管，注明当前模式和触发动作。E页增加可直接提供TF读传输出错证据；C页为0且E页为0表示尚未取得已校验扇区，需结合启动状态分析。

## 对照与回退

用 `rollback/video32_read_return.bit` 回载C32，保持同卡同线同供电复测，记录 `00C11332`。C32回退文件与之前正常位流SHA256相同。两份bit均为SRAM加载，当前测试包无需更换TF素材。

## 已有证据与待测项

- 字节引脚模型、32扇区实际SD控制器/独立卡模型、CRC与单bit注错消融通过。
- 相同负载模型有效吞吐1.353→2.434MB/s，约增加79.9%；实卡吞吐待测。
- 最终受约束片内setup/hold为+1.531/+0.011ns，TNS为0；Slice8818/9800，89.98%。
- 从路由路径估算留给卡tOD和PCB往返的setup预算约11.734ns，卡/PCB真实min/max尚待测量。14/18ns RTL扫描采用理想FPGA引脚。
- 独立审计发现C32/C40沿用的SDRAM周期刷新宏展开为0，gate周期请求也为0。此次TF对照保持该源一致，下一步单独修复并验证。该缺陷与过去现场故障的因果关系待A/B验证。

`manifest.json`列出包内文件SHA256；详尽离线证据在evidence目录。
'''
(PACKAGE / '00_START_HERE.md').write_text(guide, encoding='utf-8')
(PACKAGE / '反馈模板.txt').write_text('版本：\n供电/卡/接线变化：\n冷启动1/2/3：\n图片/原声/音阶/切图：\n视频/原声/频谱：\n5次模式往返/从头播放：\n起始C页/E页：\n结束C页/E页：\n异常触发动作与录像路径：\nC32同条件对照：\n', encoding='utf-8')
manifest = {p.relative_to(PACKAGE).as_posix(): {'sha256': sha(p), 'bytes': p.stat().st_size}
            for p in sorted(PACKAGE.rglob('*')) if p.is_file()}
write_json(PACKAGE / 'manifest.json', {'created_utc': timestamp, 'files': manifest})
zip_path = PACKAGE.with_suffix('.zip')
with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
    for path in sorted(PACKAGE.rglob('*')):
        if path.is_file():
            archive.write(path, path.relative_to(PACKAGE).as_posix())
with zipfile.ZipFile(zip_path) as archive:
    assert archive.testzip() is None
    for name, entry in manifest.items():
        assert hashlib.sha256(archive.read(name)).hexdigest() == entry['sha256'], name
    assert archive.read('video40_spi25.bit') == bit.read_bytes()
    assert archive.read('rollback/video32_read_return.bit') == baseline.read_bytes()
receipt = {'status': 'PACKAGE_HASH_VERIFIED_BOARD_PENDING', 'created_utc': timestamp,
           'zip': zip_path.relative_to(ROOT).as_posix(), 'zip_sha256': sha(zip_path),
           'zip_bytes': zip_path.stat().st_size, 'payload_files_checked': len(manifest),
           'bit_sha256': sha(bit), 'baseline_bit_sha256': sha(baseline),
           'source_binding_sha256': sha(VERIFY / 'final_stage_binding.json'),
           'manifest_sha256': sha(PACKAGE / 'manifest.json')}
write_json(VERIFY / 'delivery_receipt.json', receipt)
print(json.dumps(receipt, ensure_ascii=False, indent=2))
