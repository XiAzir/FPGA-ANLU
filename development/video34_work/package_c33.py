from pathlib import Path
import hashlib,json,shutil,zipfile,xml.etree.ElementTree as ET

ROOT=Path(__file__).resolve().parents[2]
C33=ROOT/'development/player_video33_1080p_output'
BIT=C33/'build/manual/AC201_video33_1080p15_diag.bit'
ROLLBACK=ROOT/'download/video32_read_return.bit'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(BIT)=='da3403c8390c27fe6579e7b0cfb060144464b6afcc3a44a21d08885431ceb44d'
assert sha(ROLLBACK)=='a0c8a7b53ac7c12f2e7315f0a51423407eccc7b9844f2e6d8bc08ca565481809'
ET.parse(C33/'src/td_project/AC201_video33_1080p15_diag.al')
FINAL_TIMING=(C33/'build/manual/AC201_video33_1080p15_phy.ts').read_text()
assert 'SWNS: 1.606ns, STNS: 0.000ns.' in FINAL_TIMING
assert 'HWNS: 0.022ns, HTNS: 0.000ns.' in FINAL_TIMING
DEST=ROOT/'deliverables/video33_1080p15_diag_c11333_20261027'
DEST.mkdir()
download=ROOT/'download/video33_1080p15_diag.bit'
shutil.copy2(BIT,download)
shutil.copy2(BIT,DEST/download.name)
shutil.copy2(ROLLBACK,DEST/'video32_read_return_rollback.bit')
guide='''# C33：1080p15显示兼容性测试

用途：在现有板卡、接线和显示器上显示固定8色彩条，确认1920×1080、15Hz自定义扫描兼容性。视频播放器主线在C34继续开发。

## 加载

1. 使用当前外接5V电源、HDMI线和显示器，TF卡可保持原样。
2. 通过BitWriter的PROGRAM_SRAM加载 `video33_1080p15_diag.bit`，JTAG沿用5MHz。
3. 等待约10秒，版本页应固定为 **00C11333**。
4. 观察是否显示完整横向8色彩条；记录“正常彩条 / 有背光无彩条 / 无信号”。

## LED

LED为低电平点亮。D0=PLL锁定，D1=板内HDMI核输入锁定，D2=帧活动周期闪烁，D3=启动等待结束。D1表示板内状态，显示器是否接受以实际画面为准。

若无画面，请记录D3、D2、D1、D0亮灭/闪烁及显示器提示；可拍10秒显示器与数码管。数码管无版本页时也记录。

## 回退

加载包内 `video32_read_return_rollback.bit`，版本00C11332，沿用当前TF卡即可恢复此前正常播放器。

## 本版证据与用途

- 33MHz像素时钟、165MHz串行时钟；总时序2000×1100，1920×1080有效区，每秒15帧。该模式需显示器实际兼容。
- 最终FPGA内STA：setup +1.606ns、hold +0.022ns，TNS均0，覆盖率99.62%。板外显示器、电气接收与线缆未表征。
- 像素模型逐帧检查通过；厂商PLL模型测频符合33/165MHz，模型lock输出仍0（C32参考模型同样如此），实际lock看D0。
- HDMI加密核小仿真因protected region兼容错误未运行；本次实测用于确认真实接收结果。
- 本版输出固定彩条；视频文件播放、原声、图片切换在播放器C34继续集成。
'''
(DEST/'上板说明.md').write_text(guide,encoding='utf-8')
for filename in ['AC201_video33_1080p15_phy.ts','AC201_video33_1080p15_phy.area','AC201_video33_1080p15_pr.timing']:
    shutil.copy2(C33/'build/manual'/filename,DEST/filename)
inputs={str(p.relative_to(C33)):sha(p) for p in sorted((C33/'src/user_source').rglob('*')) if p.is_file()}
receipt={'state':'DIAGNOSTIC_BOARD_PENDING','purpose':'1920x1080 15Hz fixed colorbars; full player C34 is in development',
         'version':'00C11333','bit_sha256':sha(BIT),'rollback_version':'00C11332','rollback_sha256':sha(ROLLBACK),
         'source_snapshot_after_build':inputs,'source_binding_note':'Snapshot after build; verify critical PLL/timing against exported gate and routed reports. No before-stage source receipt existed for this small diagnostic build.',
         'files':{p.name:sha(p) for p in sorted(DEST.iterdir()) if p.is_file()},
         'hardware_test':'not performed','encrypted_hdmi_core_sim':'blocked by protected-region compatibility'}
(DEST/'receipt.json').write_text(json.dumps(receipt,indent=2),encoding='utf-8')
(ROOT/'download/video33_1080p15_diag.info.json').write_text(json.dumps(receipt,indent=2),encoding='utf-8')
archive=DEST.with_suffix('.zip')
with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED) as z:
    for p in sorted(DEST.iterdir()):z.write(p,p.name)
with zipfile.ZipFile(archive) as z:
    assert z.testzip() is None
    for p in DEST.iterdir():assert hashlib.sha256(z.read(p.name)).hexdigest()==sha(p)
print(json.dumps({'bit':str(download),'bit_sha256':sha(download),'archive':str(archive),'archive_sha256':sha(archive),'files':len(list(DEST.iterdir()))}))
