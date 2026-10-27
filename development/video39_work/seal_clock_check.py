from pathlib import Path
from datetime import datetime
import hashlib
import json
import re
import shutil
import zipfile

ROOT=Path(__file__).resolve().parents[2]
WORK=ROOT/'development/video39_work'
CANDIDATE=ROOT/'development/player_video39_native1080p30'
MANUAL=CANDIDATE/'build/manual'
NAME='AC201_video39_native1080p30'

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

stages={stage:json.loads(sorted(MANUAL.glob(f'{stage}_*.json'))[-1].read_text(encoding='utf-8-sig'))
        for stage in ('synthesis','physical','bitstream')}
for stage,receipt in stages.items():
    assert receipt['exit_code']==0 and receipt['completion_token_found'],stage
    for relative,digest in receipt['source_binding'].items():
        assert sha(CANDIDATE/relative).upper()==digest,(stage,relative)
    assert sha(Path(receipt['artifact'])).upper()==receipt['artifact_sha256']
    log=Path(receipt['log']).read_text(encoding='utf-8-sig')
    assert not any(token in log for token in ('USR-8157','USR-8159'))
assert stages['bitstream']['input_database']['sha256']==sha(MANUAL/f'{NAME}_pr.db').upper()
timing={name:float(value) for name,value in re.findall(r'(SWNS|STNS|HWNS|HTNS):\s*(-?[\d.]+)ns',
        (MANUAL/f'{NAME}_phy.ts').read_text(encoding='utf-8'))}
assert timing['SWNS']>=0 and timing['HWNS']>=0 and timing['STNS']==timing['HTNS']==0
report=(MANUAL/f'{NAME}_pr.timing').read_text(encoding='utf-8')
assert re.search(r'Path Group\s*:\s*pixel_clk -> hdmi_5x_clk',report)
assert all(name in report for name in ('74.289','371.471','pixel_clk','hdmi_5x_clk'))
check=(MANUAL/f'{NAME}_chk.timing').read_text(encoding='utf-8')
assert 'There are 0 clock pins that have no clock constraints.' in check
frame=json.loads((WORK/'simulation/frame_result.json').read_text(encoding='utf-8-sig'))
assert frame['completed'] and frame['exit_code']==0
for entry in frame['source_sha256']:
    assert sha(Path(entry['path'])).upper()==entry['sha256']
pin=json.loads((WORK/'pin_c39/analysis.json').read_text(encoding='utf-8'))
binding=json.loads((WORK/'pin_c39/source_binding.json').read_text(encoding='utf-8-sig'))
assert pin['status']=='PIN_PROTOCOL_WINDOW_PASS'
assert binding['only_top_renamed'] and binding['mapped_sha256']==sha(MANUAL/f'{NAME}_gate.v').upper()
assert pin['stream_sha256']==sha(WORK/'pin_c39/words.txt')
negative=json.loads((WORK/'pin_c39/negative_rgb.json').read_text(encoding='utf-8'))
assert negative['status']=='PIN_PROTOCOL_WINDOW_FAIL' and negative['stream_sha256']==pin['stream_sha256']

filename='video39_native_clock_check.bit'
bit=MANUAL/f'{NAME}.bit'
package=ROOT/'deliverables/video39_native_clock_check_20261027'
package.mkdir(parents=True,exist_ok=True)
shutil.copy2(bit,package/filename)
shutil.copy2(bit,ROOT/'download'/filename)
rollback=ROOT/'download/video38_open_tx_1080p15.bit'
assert sha(rollback)=='80ea48146f802cb7016ba673a1149ef6387a76ccd5d76ea7ab4334d69afc3c66'
shutil.copy2(rollback,package/'video38_open_tx_1080p15_rollback.bit')
info={
    'state':'NATIVE_TX_OFFLINE_VERIFIED_CLOCK_BOARD_PENDING_ADAPTER_PENDING',
    'version':'00C11339','filename':filename,'bit_sha256':sha(bit),'bit_bytes':bit.stat().st_size,
    'purpose':'验证芯片对74.285714/371.428571MHz PLL配置的真实锁定与栅格计数；原生P4输出转接尚待电气方案。',
    'pixel_hz':50e6*104/7/10,'serial_hz':50e6*104/7/2,'total':[2200,1125],'active':[1920,1080],
    'refresh_hz':50e6*104/7/10/(2200*1125),'content_target_fps':15,'AVI_VIC':34,
    'timing_ns':timing,'STA_coverage_percent':97.64,'resources':{'LUT':698,'REG':258,'BRAM':0},
    'clock_constraints':'Explicit related generated clocks from the 50MHz input, ratios 104/70 and 104/14; no false paths, exclusive groups or multicycles.',
    'known_checks':['check_timing retains 371.500MHz vs PLL371.428571MHz frequency warning; report periods show 1ps quantization.',
                    'PHY-5014 tied-low no-compensation feedback input routing warning retained.',
                    'Input/output external delays and physical receiver SI/electrical behavior remain uncharacterized.'],
    'physical_ports':{'HDMI_CLK_P':['K11','J11','P4.23','P4.25'],
                      'HDMI_D0_P':['L14','M14','P4.33','P4.34'],
                      'HDMI_D1_P':['K15','M15','P4.35','P4.36'],
                      'HDMI_D2_P':['H13','J13','P4.21','P4.22']},
    'current_connection_expectation':'Outputs are on P4 native pairs; the existing J4 HDMI socket will have no signal during this clock-only board observation.',
    'simulation':{'full_frame':frame['stdout'],'pin_window':pin,'model_por_ns':200,'startup_wait_accelerated':True},
    'source_binding':stages['bitstream']['source_binding'],
    'stages':{stage:receipt['log'] for stage,receipt in stages.items()},
    'gate_sha256':sha(MANUAL/f'{NAME}_gate.v'),'routed_database_sha256':sha(MANUAL/f'{NAME}_pr.db'),
    'expected_LED':'D3/D1/D0 on, D2 toggles about 3.75Hz; D0 is actual PLL extlock indication.'
}
for folder in (package,ROOT/'download'):
    (folder/'video39_native_clock_check.info.json').write_text(json.dumps(info,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(ROOT/'download/video39_native_clock_check.board_feedback.json').write_text(json.dumps({
    'state':'PENDING','version':'00C11339','bit_sha256':sha(bit),'observations':[]},indent=2)+'\n',encoding='utf-8')
(package/'00_时钟验证指南.md').write_text('''# C39原生输出时钟验证

本轮验证芯片是否实际锁定新的74.285714/371.428571MHz PLL配置。C39完整1080p30彩条已通过离线帧/包/引脚流与片内时序核验。

**C39的显示信号已改从右侧空闲P4原生差分对输出。显示器保持接在原HDMI母座时将显示无信号。** 本次观察数码管和LED，接线保持原样，P4保持空闲；转接板电气方案另行评估。

1. PROGRAM_SRAM加载 `video39_native_clock_check.bit`，等待10秒。
2. 记下数码管版本，预期 `00C11339`。
3. 记录D3、D2、D1、D0亮灭/闪烁。预期D3/D1/D0常亮，D2约3.75Hz闪烁（比C38约快一倍）。D0表示真实PLL锁定；灯的闪烁仅作栅格活动观察，实际频率仍需测量。
4. 测试后加载 `video38_open_tx_1080p15_rollback.bit`，恢复此前带“输入不支持”提示的1080p15彩条。

反馈例：`00C11339，D3亮、D2闪、D1亮、D0亮；回C38恢复`。若难描述，约10秒数码管和LED录像即可。

TF卡沿用，音视频播放器待后续集成。当前实验只用PROGRAM_SRAM，Flash保持。
''',encoding='utf-8')
manifest={file.relative_to(package).as_posix():sha(file) for file in sorted(package.rglob('*'))
          if file.is_file() and file.name!='manifest.json'}
(package/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
archive=package.with_suffix('.zip')
with zipfile.ZipFile(archive,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=9) as saved:
    for file in sorted(package.rglob('*')):
        if file.is_file():saved.write(file,file.relative_to(package).as_posix())
with zipfile.ZipFile(archive) as saved:
    for name,digest in manifest.items():assert hashlib.sha256(saved.read(name)).hexdigest()==digest
receipt={
    'time':datetime.now().astimezone().isoformat(timespec='seconds'),
    'state':info['state'],'bit_sha256':sha(bit),'archive':archive.as_posix(),
    'archive_bytes':archive.stat().st_size,'archive_sha256':sha(archive),'payloads':len(manifest),
    'scope':'Clock-lock board check only; adapter electrical design and 1080p30 receiver board test pending.'
}
(WORK/'delivery_receipt.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(WORK/'full_tx_preparation.json').write_text(json.dumps({'state':info['state'],
    'source_binding':info['source_binding'],'bit_sha256':sha(bit),'delivery_receipt':'development/video39_work/delivery_receipt.json'},indent=2)+'\n',encoding='utf-8')
print(json.dumps(receipt,ensure_ascii=False,indent=2))
