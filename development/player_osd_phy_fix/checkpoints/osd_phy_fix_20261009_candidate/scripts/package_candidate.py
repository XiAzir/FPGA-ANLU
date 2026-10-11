"""Package a built candidate and the verified fallback; do not touch the card."""
from pathlib import Path
import hashlib
import json
import zipfile

ROOT = Path('E:/VSCODE-project/FPGA-ANLU')
TASK = ROOT / 'development/player_osd_phy_fix'
info = json.loads((TASK / 'build/manual/AC201_player_osd_phy_fix.info.json').read_text(encoding='utf-8-sig'))
candidate = TASK / 'build/manual/AC201_player_osd_phy_fix.bit'
fallback = ROOT / 'download/packet_diag.bit'
zip_path = ROOT / 'deliverables/osd_phy_fix_20261009.zip'


def sha(data):
    return hashlib.sha256(data).hexdigest().upper()


candidate_data = candidate.read_bytes()
fallback_data = fallback.read_bytes()
assert sha(candidate_data) == info['sha256']
assert sha(fallback_data) == 'C2B3DEAFB78355C124CE8958015EED31CEBA38CD4B0B41D9179A7190E4200818'
assert info['hardware_result'] == 'not tested'
assert all(v >= 0 for v in info['timing'].values())
if zip_path.exists():
    raise RuntimeError('Do not overwrite an existing delivery package')

readme = '''OSD串行采样修复候选（2026-10-09）

这是待上板验证的新候选，已完成模型、编译及原约束时序检查。
旧OSD首版实板花屏/静音，同条件回载packet_diag已恢复。

保持现有TF卡、供电、HDMI和音量，卡内四图和TEST.WAV无需修改。
解压到英文路径；在BitWriter选择PROGRAM_SRAM，添加
firmware/osd_phy_fix.bit，下载后等待 Downloading succeeded!。
本机短路径：E:/VSCODE-project/FPGA-ANLU/download/osd_phy_fix.bit。

验证：
1. 四张图颜色正常，无密集噪点、条纹或黑块；左上状态栏黑底白字。
2. 默认天之弱音乐正常；运行两次60秒循环。
3. KEY0短按切图且IMG编号一致；KEY1短按切MANUAL/AUTO并自动轮播。
4. KEY1长按约2秒切内部音阶，D3闪烁，音阶清楚且图像正常。
   长按也会切换一次轮播状态。松开至少1.5秒后再次长按可回WAV。

如果图像或声音仍异常，保存现象并回载firmware/packet_diag.bit。
旧osd.bit不是修正版。当前只临时写FPGA SRAM，掉电会重载Flash原例程。

本次修改仅在每个HDMI串行器中提前一个125MHz周期暂存10位数据字；
移位/ODDR发送时刻保持原样。图片、音频文件通路、OSD、PLL、引脚、
时序约束源码不变；物理实现优化及最终数值见build_info.json。
延迟模型可复现混字并由候选消除；真实板上的具体原因尚未实测证实。
'''
entries = {
    'firmware/osd_phy_fix.bit': candidate_data,
    'firmware/packet_diag.bit': fallback_data,
    'README.txt': readme.encode('utf-8'),
    'build_info.json': json.dumps(info, ensure_ascii=False, indent=2).encode('utf-8'),
}
checksums = {name: {'bytes': len(data), 'sha256': sha(data)} for name, data in entries.items()}
entries['checksums.json'] = json.dumps(checksums, ensure_ascii=False, indent=2).encode('utf-8')
zip_path.parent.mkdir(exist_ok=True)
with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
    for name, data in entries.items():
        archive.writestr(name, data)
with zipfile.ZipFile(zip_path) as archive:
    assert archive.testzip() is None
    for name, data in entries.items():
        assert archive.read(name) == data
audit = {'path': str(zip_path), 'bytes': zip_path.stat().st_size, 'sha256': sha(zip_path.read_bytes()),
         'zip_crc': 'PASS', 'all_member_bytes_and_sha256': 'PASS', 'members': checksums}
zip_path.with_suffix('.package_audit.json').write_text(json.dumps(audit, ensure_ascii=False, indent=2), encoding='utf-8')
print(json.dumps({k: audit[k] for k in ('path', 'bytes', 'sha256', 'zip_crc')}, ensure_ascii=False))
