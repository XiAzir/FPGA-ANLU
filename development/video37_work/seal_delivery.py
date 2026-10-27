from pathlib import Path
from datetime import datetime
import hashlib
import json
import re
import shutil
import zipfile

ROOT = Path(__file__).resolve().parents[2]
WORK = ROOT/'development/video37_work'
PACKAGE = ROOT/'deliverables/video37_38_open_tx_20261027'
PACKAGE.mkdir(parents=True,exist_ok=True)
DOWNLOAD = ROOT/'download'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def latest(folder, stage):
    path = sorted(folder.glob(f'{stage}_*.json'))[-1]
    result = json.loads(path.read_text(encoding='utf-8-sig'))
    assert result['exit_code'] == 0 and result['completion_token_found']
    return path,result


records = []
for version, filename, active, total in (
    (37,'video37_open_tx_640x480.bit',[640,480],[1000,550]),
    (38,'video38_open_tx_1080p15.bit',[1920,1080],[2000,1100]),
):
    candidate = ROOT/f'development/player_video{version}_open_tx'
    baseline = ROOT/'development/video33_work/candidates/C11335_640x480_60hz_33_165_bufg'
    for relative in ('hdl_source/IP/video_pll.v','hdl_source/IP/video_pll.ipc','hdl_source/hdmi_phy_warpper.v',
                     'hdl_source/lane_lvds_10_1.v','hdl_source/status_hex595.v',
                     'constraints_source/pin.adc','constraints_source/timing.sdc'):
        assert sha(candidate/'src/user_source'/relative) == sha(baseline/'src/user_source'/relative)
    manual = candidate/'build/manual'
    project = f'AC201_video{version}_open_tx'
    stages = {stage:latest(manual,stage) for stage in ('synthesis','physical','bitstream')}
    for stage,(path,receipt) in stages.items():
        for name,digest in receipt['source_binding'].items():
            assert sha(candidate/name).upper() == digest, (version,stage,name,'changed since build')
        assert sha(Path(receipt['artifact'])).upper() == receipt['artifact_sha256']
    gate_db = manual/f'{project}_gate.db'
    routed_db = manual/f'{project}_pr.db'
    assert stages['bitstream'][1]['input_database']['sha256'] == sha(routed_db).upper()
    phy_log = Path(stages['physical'][1]['log']).read_text(encoding='utf-8-sig')
    assert f'import_db {gate_db.as_posix()}' in phy_log
    timing_text = (manual/f'{project}_phy.ts').read_text(encoding='utf-8')
    timing = {name:float(value) for name,value in re.findall(r'(SWNS|STNS|HWNS|HTNS):\s*(-?[\d.]+)ns',timing_text)}
    assert len(timing) == 4 and timing['SWNS'] >= 0 and timing['HWNS'] >= 0
    assert timing['STNS'] == timing['HTNS'] == 0
    pin = json.loads((WORK/f'pin_c{version}/analysis.json').read_text(encoding='utf-8'))
    assert pin['status'] == 'PIN_PROTOCOL_WINDOW_PASS'
    assert pin['stream_sha256'] == sha(WORK/f'pin_c{version}/words.txt')
    pin_binding = json.loads((WORK/f'pin_c{version}/source_binding.json').read_text(encoding='utf-8-sig'))
    assert pin_binding['only_top_renamed']
    assert pin_binding['mapped_sha256'] == sha(manual/f'{project}_gate.v').upper()
    assert pin_binding['bench_sha256'] == sha(WORK/'tb_gate_pins.sv').upper()
    for name in ('tmds_channel.v','video_only_tmds_tx.v','packet_assembler_compat.v','auxiliary_video_information_info_frame.v'):
        assert sha(candidate/'src/user_source/hdl_source/open_tx'/name) == sha(WORK/'td_compat'/name)
    bit = manual/f'{project}.bit'
    shutil.copy2(bit,DOWNLOAD/filename)
    shutil.copy2(bit,PACKAGE/filename)
    source_binding = {name:digest.lower() for name,digest in stages['bitstream'][1]['source_binding'].items()}
    record = {
        'state':'DIAGNOSTIC_BOARD_PENDING',
        'version':f'00C113{version}',
        'filename':filename,
        'purpose':'新开放单包HDMI发射核固定彩条接收对照',
        'bit_sha256':sha(bit),
        'bit_bytes':bit.stat().st_size,
        'source_root':candidate.as_posix(),
        'geometry':{'active':active,'total':total,'pixel_hz':33000000,'serial_ddr_hz':165000000,
                    'refresh_hz':33000000/(total[0]*total[1]),'hsync':'negative','vsync':'negative'},
        'timing_ns':timing,
        'stage_receipts':{name:path.as_posix() for name,(path,_) in stages.items()},
        'source_binding':source_binding,
        'gate_db_sha256':sha(gate_db),'routed_db_sha256':sha(routed_db),
        'mapped_pin_verification':pin,
        'verification_scope':'完整几何RTL仿真、独立VS契约检查、实际映射网表短窗口串行引脚解码、原约束routed STA；实板与SDF待验证。',
        'simulation_initialization':pin_binding['simulation_initialization'],
        'media_scope':'固定彩条，视频与音频播放器后续集成。',
    }
    info_name = Path(filename).with_suffix('.info.json').name
    for folder in (DOWNLOAD,PACKAGE):
        (folder/info_name).write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    feedback = DOWNLOAD/Path(filename).with_suffix('.board_feedback.json').name
    if not feedback.exists():
        feedback.write_text(json.dumps({'state':'PENDING','version':record['version'],'bit_sha256':sha(bit),
            'observations':[]},ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    records.append(record)

rollback = DOWNLOAD/'video32_read_return.bit'
assert sha(rollback) == 'a0c8a7b53ac7c12f2e7315f0a51423407eccc7b9844f2e6d8bc08ca565481809'
shutil.copy2(rollback,PACKAGE/'video32_read_return_rollback.bit')

guide = '''# C37 / C38 彩条实测指南

日期：2026-10-27。目标：核对新开放HDMI发射核能否让当前显示器显示1080p15。

## 文件和顺序

| 顺序 | 文件 | 数码管版本 | 输出 |
|---|---|---|---|
| 1 | video37_open_tx_640x480.bit | 00C11337 | 640×480 / 60Hz，1000×550，总像素33MHz |
| 2 | video38_open_tx_1080p15.bit | 00C11338 | 1920×1080 / 15Hz，2000×1100，总像素33MHz |
| 回退 | video32_read_return_rollback.bit | 00C11332 | 此前已确认正常的图片/视频播放器 |

两版C37/C38均显示白、黄、青、绿、紫、红、蓝、黑八条竖向色带，音视频播放器待输出链通过后集成。当前TF卡沿用，卡内文件保持。

## 操作

1. 沿用已稳定工作的外接5V USB适配器、USB-A转USB-C供电线和HDMI线。AL-LINK连接沿用。
2. 在BitWriter选择 **PROGRAM_SRAM**，加载 `video37_open_tx_640x480.bit`。等10秒，核对数码管 `00C11337`，观察八色竖条是否完整稳定、是否有屏幕提示。
3. 同样加载 `video38_open_tx_1080p15.bit`，等10秒，核对 `00C11338`。观察八色竖条、屏上“输入不支持”提示，以及有无闪烁或间歇无信号。
4. 测试后可加载 `video32_read_return_rollback.bit` 恢复当前播放器。

本轮关键观察是C37和C38各自的彩条接收结果；按键无需操作。

## LED定义

| LED | 含义 | 预计稳定状态 |
|---|---|---|
| D3 | PLL锁定后启动等待结束 | 亮 |
| D2 | 帧边界计数bit2 | 闪；C37约7.5Hz，C38约1.875Hz |
| D1 | 栅格计数已经过帧边界 | 亮 |
| D0 | PLL锁定 | 亮 |

## 反馈

复制填写即可：

```text
C37：版本____；彩条完整/局部/无信号____；提示文字____；D3 D2 D1 D0____
C38：版本____；彩条完整/局部/无信号____；提示文字____；D3 D2 D1 D0____
稳定性：是否闪烁或间歇失去信号____
```

如果出现异常，一张完整屏幕照片和约10秒板上LED/数码管录像即可，保留正在加载的版本号。

## 已完成的离线验证

- 旧核消融：80像素行消隐时数据岛被截断；160像素时完整。新核固定每行一个32符号包。
- 完整640×480和1920×1080帧的RTL像素/包结构验证，以及独立H/V同步契约核验通过。
- 两版实际映射网表各恢复30,000个串行字，C37检查30行19,200像素、C38检查15行28,800像素，RGB/数据岛/校验/保护带通过；单比特翻转负控检出。
- 两版原约束routed setup/hold为正，详见对应info.json。引脚仿真用官方PLL/ODDR模型，记录了模型专用200ns PLL复位与启动计数加速；物理显示器结果由本次实测补齐。

电脑此前在相同1080p15扫描下桌面完整更新并持续显示“输入不支持”；请把彩条和提示两项分别记录。
'''
(PACKAGE/'00_上板指南.md').write_text(guide,encoding='utf-8')

for version in (37,38):
    evidence = PACKAGE/f'evidence/C{version}'
    evidence.mkdir(parents=True,exist_ok=True)
    for name in ('analysis.json','source_binding.json','capture.json'):
        shutil.copy2(WORK/f'pin_c{version}'/name,evidence/name)
    manual = ROOT/f'development/player_video{version}_open_tx/build/manual'
    for name in (f'AC201_video{version}_open_tx_phy.ts',f'AC201_video{version}_open_tx_phy.area'):
        shutil.copy2(manual/name,evidence/name)
for name in ('results.json','source-provenance.json'):
    destination = PACKAGE/'evidence/td_compat'/name
    destination.parent.mkdir(parents=True,exist_ok=True)
    shutil.copy2(WORK/'td_compat'/name,destination)

manifest = {path.relative_to(PACKAGE).as_posix():sha(path) for path in sorted(PACKAGE.rglob('*'))
            if path.is_file() and path.name != 'manifest.json'}
(PACKAGE/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
archive = PACKAGE.with_suffix('.zip')
with zipfile.ZipFile(archive,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=9) as output:
    for path in sorted(PACKAGE.rglob('*')):
        if path.is_file():
            output.write(path,path.relative_to(PACKAGE).as_posix())
with zipfile.ZipFile(archive) as saved:
    for name,digest in manifest.items():
        assert hashlib.sha256(saved.read(name)).hexdigest() == digest
receipt = {
    'time':datetime.now().astimezone().isoformat(timespec='seconds'),
    'state':'TWO_DIAGNOSTICS_DELIVERED_BOARD_PENDING',
    'archive':archive.as_posix(),'archive_bytes':archive.stat().st_size,'archive_sha256':sha(archive),
    'payload_files':len(manifest),'zip_payload_hashes_verified':True,
    'candidates':[{key:item[key] for key in ('version','filename','bit_sha256','geometry','timing_ns')} for item in records]
}
(WORK/'delivery_receipt.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(WORK/'baseline_binding.json').write_text(json.dumps({
    'state':'BUILT_AND_PIN_VERIFIED_BOARD_PENDING',
    'baseline':(ROOT/'development/video33_work/candidates/C11335_640x480_60hz_33_165_bufg').as_posix(),
    'candidate':(ROOT/'development/player_video37_open_tx').as_posix(),
    'unchanged_baseline_files':['hdl_source/IP/video_pll.v','hdl_source/IP/video_pll.ipc','hdl_source/hdmi_phy_warpper.v',
        'hdl_source/lane_lvds_10_1.v','hdl_source/status_hex595.v','constraints_source/pin.adc','constraints_source/timing.sdc'],
    'delivery_receipt':'development/video37_work/delivery_receipt.json'
},indent=2)+'\n',encoding='utf-8')
print(json.dumps(receipt,ensure_ascii=False,indent=2))
