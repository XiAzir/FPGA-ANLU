"""Package the timing-clean OSD candidate and the verified fallback, without TF writes."""
from pathlib import Path
import hashlib
import json
import shutil
import zipfile

ROOT = Path(__file__).resolve().parents[3]
TASK = ROOT / 'development' / 'player_osd'
info = json.loads((TASK / 'build/manual/AC201_player_osd.info.json').read_text(encoding='utf-8-sig'))
bit = Path(info['bitstream'])
fallback = ROOT / 'development/player_fat32_packet_diag/build/manual/AC201_player_fat32_packet_diag.bit'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest().upper()
assert sha(bit) == info['sha256']
assert sha(fallback) == info['baseline_bit_sha256']
assert all(value >= 0 for value in info['timing'].values())

delivery = ROOT / 'deliverables/osd_20261009'
archive = delivery.with_suffix('.zip')
download = ROOT / 'download/osd.bit'
if delivery.exists() or archive.exists() or download.exists():
    raise RuntimeError('Do not overwrite an existing delivery or download bitstream')
delivery.mkdir()
(delivery / 'firmware').mkdir()
shutil.copy2(bit, delivery / 'firmware/osd.bit')
shutil.copy2(fallback, delivery / 'firmware/packet_diag.bit')
download.parent.mkdir(exist_ok=True)
shutil.copy2(bit, download)
assert sha(download) == info['sha256']

readme = '''OSD 第一版上板测试（2026-10-09）

本包包含：firmware/osd.bit 新候选；firmware/packet_diag.bit 已验证回退版。
新候选已通过逐像素/状态模型、TD综合与布局布线、原约束setup/hold检查；尚未上板验证。
无需修改TF卡，继续使用原根目录四张BMP和TEST.WAV。不格式化，不写Flash。
解压到纯英文路径（例如 C:/fpga_test），不要在ZIP内部直接选择bit，避免中文路径打开失败。

下载：BitWriter Add 添加 firmware/osd.bit，使用现有 AL-LINK/JTAG、PROGRAM_SRAM，
等待 Downloading succeeded!。本机也有 E:/VSCODE-project/FPGA-ANLU/download/osd.bit。

预期：原图/音乐正常，左上白字黑底 IMG 1/4 MANUAL（数量按实际扫描结果显示）。
KEY0点按切图，编号应随实际显示图片更新并循环回1。
KEY1短按开/关自动轮播，状态在AUTO与MANUAL之间切换，声音保持正常。
长按KEY1约2秒切内部音阶，松开至少1.5秒后可再长按切回WAV；
沿用基线行为：长按也会触发一次轮播开关，AUTO文字可能同时改变。
继续确认音乐返回开头正常，并检查切图过程中没有杂音/花屏。
数码管继续保留原诊断页；正常首轮不必专门录数码管。

如出现异常：保留新位流和现象，保持卡/接线/音量，回载firmware/packet_diag.bit对照。
PROGRAM_SRAM掉电丢失；重新上电需再下载所选位流。

OSD文字无需从卡上读取；本次为图片序号和轮播状态，并非滚动字幕/歌词功能。
基线音频/SDRAM/IP/PLL/引脚/时序约束源码未改，但新布局仍需实板回归。
'''
(delivery / 'README.txt').write_text(readme, encoding='utf-8-sig')
info['package_hardware_status'] = 'not tested; user board feedback required'
(delivery / 'BUILD_INFO.json').write_text(json.dumps(info, ensure_ascii=False, indent=2), encoding='utf-8')
files = sorted(p for p in delivery.rglob('*') if p.is_file())
checksums = '\n'.join(f'{sha(p)}  {p.relative_to(delivery).as_posix()}' for p in files) + '\n'
(delivery / 'CHECKSUMS.sha256').write_text(checksums, encoding='ascii')
with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
    for p in sorted(delivery.rglob('*')):
        if p.is_file():
            z.write(p, p.relative_to(delivery).as_posix())
with zipfile.ZipFile(archive) as z:
    assert z.testzip() is None
    for p in sorted(delivery.rglob('*')):
        if p.is_file():
            assert hashlib.sha256(z.read(p.relative_to(delivery).as_posix())).hexdigest().upper() == sha(p)
audit = dict(zip=str(archive), zip_bytes=archive.stat().st_size, zip_sha256=sha(archive),
             download=str(download), download_sha256=sha(download),
             candidate_sha256=info['sha256'], fallback_sha256=sha(fallback),
             archive_crc_and_all_file_sha256='PASS', tf_card_or_flash_operations='none',
             hardware_test='pending')
(ROOT / 'deliverables/osd_20261009.package_audit.json').write_text(
    json.dumps(audit, ensure_ascii=False, indent=2), encoding='utf-8')
print(json.dumps(audit, ensure_ascii=False, indent=2))
