from pathlib import Path
import argparse,hashlib,json,shutil,zipfile

ROOT=Path(__file__).resolve().parents[2]
parser=argparse.ArgumentParser()
parser.add_argument('version',type=int,choices=[35,36])
args=parser.parse_args()
version=args.version
if version==36:
    name='1080p15_serial_bufg';project='AC201_C11336_1080p15_serial_bufg'
    expected='ca1b412a5d9cb601562282aa33b77b4e018de9db2a52b722c6458892cba2b628'
    purpose='保持C33的1920×1080/15Hz扫描，恢复与C32一致的串行全局时钟缓冲。'
else:
    name='640x480_60hz_33_165_bufg';project='AC201_C11335_640x480_60hz_33_165_bufg'
    expected=None
    purpose='使用相同33/165MHz高频输出链，显示640×480/60Hz彩条，区分高频输出链与1080p15接收兼容性。'
candidate=ROOT/f'development/video33_work/candidates/C113{version}_{name}'
manual=candidate/'build/manual'
bit=manual/f'{project}.bit'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
if expected: assert sha(bit)==expected
assert sha(ROOT/'download/video32_read_return.bit')=='a0c8a7b53ac7c12f2e7315f0a51423407eccc7b9844f2e6d8bc08ca565481809'
timing=(manual/f'{project}_phy.ts').read_text()
assert 'STNS: 0.000ns.' in timing and 'HTNS: 0.000ns.' in timing
dest=ROOT/f'deliverables/video{version}_{name}_c113{version}_20261027'
dest.mkdir()
download=ROOT/f'download/video{version}_{name}.bit'
shutil.copy2(bit,download)
shutil.copy2(bit,dest/download.name)
shutil.copy2(ROOT/'download/video32_read_return.bit',dest/'video32_read_return_rollback.bit')
guide=f'''# C{version}：受控显示链对照

用途：{purpose}

通过BitWriter PROGRAM_SRAM加载 `{download.name}`，JTAG沿用5MHz，供电/HDMI接线/显示器保持现场条件。等待10秒，数码管应固定 **00C113{version}**，观察“完整彩条 / 有背光无彩条 / 无信号”。

D0=PLL锁定，D1=板内HDMI核输入锁定，D2=帧活动周期闪烁，D3=启动等待完成。记录D3～D0与屏幕结果即可。位流输出固定彩条，1080p视频播放器在C34继续集成。

回退：加载包内 `video32_read_return_rollback.bit`，版本00C11332，TF素材保持即可。

最终FPGA内STA：

```
{timing.strip()}
```

外部显示器、线缆和电气接收尚待实测。彩条/PLL/串行字恢复模型及TD报告分别保留，硬件结果以本次反馈记录。
'''
(dest/'上板说明.md').write_text(guide,encoding='utf-8')
for suffix in ['_phy.ts','_phy.area','_pr.timing']:
    shutil.copy2(manual/f'{project}{suffix}',dest/f'{project}{suffix}')
receipt={'state':'DIAGNOSTIC_BOARD_PENDING','version':f'00C113{version}',
         'purpose':purpose,'bit_sha256':sha(bit),'source_root':str(candidate/'src'),
         'source_snapshot_after_build':{str(p.relative_to(candidate)):sha(p) for p in sorted((candidate/'src/user_source').rglob('*')) if p.is_file()},
         'timing_status':timing.strip(),'files':{p.name:sha(p) for p in sorted(dest.iterdir()) if p.is_file()}}
(dest/'receipt.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2),encoding='utf-8')
download.with_suffix('.info.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2),encoding='utf-8')
archive=dest.with_suffix('.zip')
with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED) as z:
    for p in sorted(dest.iterdir()):z.write(p,p.name)
with zipfile.ZipFile(archive) as z:
    assert z.testzip() is None
    for p in dest.iterdir():assert hashlib.sha256(z.read(p.name)).hexdigest()==sha(p)
print(json.dumps({'bit':str(download),'bit_sha256':sha(download),'archive':str(archive),'archive_sha256':sha(archive)}))
