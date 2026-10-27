"""Seal C41 refresh repair after final source, command and route checks."""
from datetime import datetime,timezone
import hashlib
import json
from pathlib import Path
import re
import shutil
import zipfile

ROOT=Path(__file__).resolve().parents[2]
WORK=Path(__file__).resolve().parent
PROJECT=ROOT/'development/player_video41_refresh'
VERIFY=PROJECT/'verification'
BUILD=PROJECT/'build/manual'
PACKAGE=ROOT/'deliverables/video41_refresh_20261027'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))
def save(path,data): path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

binding=load(VERIFY/'final_stage_binding.json')
assert binding['status']=='PASS'
bit=BUILD/'AC201_player_video41_refresh.bit'
assert sha(bit)==binding['bit_sha256']
for item in binding['inputs']:
    assert sha(PROJECT/item['path'])==item['sha256'],item['path']
for name,digest in binding['stages']['physical']['artifacts'].items():
    assert sha(BUILD/name)==digest,name
audit=load(VERIFY/'source_audit.json')
assert audit['status']=='PASS'
for name,digest in audit['candidate_sources'].items():
    assert sha(PROJECT/'src/user_source'/name)==digest,name
ack_change=load(VERIFY/'ack_edge_change.json')
assert ack_change['protected_suffix_sha256_before']==ack_change['protected_suffix_sha256_after']
assert ack_change['updated_full_sha256']==sha(PROJECT/'src/user_source/hdl_source/include/sdr_init_ref.enc.v')
models=load(WORK/'refresh_model_ackfinal/summary.json')
assert models['status']=='PASS'
for name,digest in models['inputs'].items(): assert sha(ROOT/name)==digest,name
ack_model=load(WORK/'ack_model/summary.json')
assert ack_model['status']=='PASS'
commands=load(WORK/'final_gate_commands.json')
assert commands['status']=='PASS'
assert commands['final_gate_sha256']==sha(BUILD/'AC201_tf_hdmi_gate.v')
for check in commands['checks']:
    assert check['status']=='PASS'
    assert sha(ROOT/check['binding_path'])==check['binding_sha256']
    assert sha(ROOT/check['log_path'])==check['log_sha256']
baseline=ROOT/'download/video40_spi25.bit'
assert sha(baseline)==audit['baseline_bit_sha256']
timing=(BUILD/'AC201_tf_hdmi_phy.ts').read_text()
m=re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.',timing)
assert m
wns=list(map(float,m.groups()))
assert min(wns)>=0
qor=(PROJECT/'src/td_project/route.qor').read_text()
slices=int(re.search(r'#slices\s*\|\s*(\d+)',qor)[1])
area=(BUILD/'AC201_tf_hdmi_phy.area').read_text()
resources={name:int(re.search(r'^#'+name+r'\s+(\d+)',area,re.M)[1]) for name in ['lut','reg','le','bram','dsp','pll','gclk']}
report=(PROJECT/'src/td_project/final_timing.rpt').read_text()
coverage=float(re.search(r'STA coverage\s*:\s*([\d.]+)%',report)[1])
timestamp=datetime.now(timezone.utc).isoformat()
info={
 'status':'OFFLINE_VERIFIED_REFRESH_BOARD_PENDING','build_id':'00C11341','created_utc':timestamp,
 'filename':'video41_refresh.bit','bit_sha256':sha(bit),'bit_bytes':bit.stat().st_size,
 'purpose':'基于用户正常C40，恢复EM638325周期刷新，并修复合并ACK连续电平引发重复AREF的移位入口。',
 'board_result':'PENDING','clocks_hz':{'spi_initialization':100000,'spi_data':25000000,'sdram':50000000},
 'slice_used':slices,'slice_percent':slices/9800*100,'C40_slice_used':8818,'slice_delta_vs_C40':slices-8818,
 'physical_resources':resources,
 'timing_ns':dict(zip(['setup_wns','setup_tns','hold_wns','hold_tns'],wns)),
 'STA_coverage_percent':coverage,
 'timing_scope':'Production constrained internal paths; external card/PCB delays and real SDRAM data retention require board evidence.',
 'refresh':{'device':'EM638325','specification_commands_per_64ms':4096,'terminal':780,
    'request_interval_mem_clocks':781,'request_interval_ns':15620,'window_4096_intervals_ns':63979520,
    'ack_shift_input':'rising-edge event; raw scheduler ACK interface preserved',
    'protected_suffix_identical':True,'gate_commands':commands},
 'source_delta':audit['changed'],'unchanged_user_sources':audit['unchanged_user_sources'],
 'runtime_pages':{'00C11341':'版本','C000xxxx':'TF已校验扇区计数，16位十六进制饱和','E000xxxx':'TF CRC不一致扇区计数'},
 'baseline_bit_sha256':sha(baseline),
 'source_audit_sha256':sha(VERIFY/'source_audit.json'),
 'final_stage_binding_sha256':sha(VERIFY/'final_stage_binding.json'),
 'routed_database_sha256':sha(BUILD/'AC201_tf_hdmi_pr.db'),
 'final_routed_netlist_sha256':sha(VERIFY/'final_routed.v'),
 'external_spi_path_estimate':load(WORK/'raw_io_budget.json'),
 'outstanding':['C41 board media/cold-start/long-running validation','Physical timing and data retention','SDRAM100 and HD integration'],
 'historical_fault_causality':'Periodic refresh and ACK command defects have digital evidence; previous board black-screen/audio faults remain unassigned.'
}
save(VERIFY/'delivery_info.json',info)
shutil.copy2(bit,ROOT/'download/video41_refresh.bit')
save(ROOT/'download/video41_refresh.info.json',info)
PACKAGE.mkdir(exist_ok=False)
payloads={
 'video41_refresh.bit':ROOT/'download/video41_refresh.bit',
 'video41_refresh.info.json':ROOT/'download/video41_refresh.info.json',
 'rollback/video40_spi25.bit':baseline,
 'rollback/video40_spi25.info.json':ROOT/'download/video40_spi25.info.json',
 'rollback/video40_spi25.board_feedback.json':ROOT/'download/video40_spi25.board_feedback.json',
 'evidence/final_stage_binding.json':VERIFY/'final_stage_binding.json',
 'evidence/source_audit.json':VERIFY/'source_audit.json',
 'evidence/ack_edge_change.json':VERIFY/'ack_edge_change.json',
 'evidence/public_refresh_summary.json':WORK/'refresh_model_ackfinal/summary.json',
 'evidence/ack_width_ablation.json':WORK/'ack_model/summary.json',
 'evidence/gate_commands.json':WORK/'final_gate_commands.json',
 'evidence/final_timing.rpt':PROJECT/'src/td_project/final_timing.rpt',
 'evidence/route.qor':PROJECT/'src/td_project/route.qor',
 'evidence/external_spi_path_estimate.json':WORK/'raw_io_budget.json',
}
for name,source in payloads.items():
    target=PACKAGE/name
    target.parent.mkdir(parents=True,exist_ok=True)
    shutil.copy2(source,target)
guide='''# C41：周期刷新与ACK事件修复

用 BitWriter 的 PROGRAM_SRAM 加载 `video41_refresh.bit`，确认版本 `00C11341`。沿用当前TF卡文件、外接5V和原HDMI。

本版视频内容仍为640×480/15fps，TF数据25MHz、SDRAM50MHz。主要修复是恢复周期刷新，并把连续ACK电平在命令移位入口转为一次事件。

1. 加载后等10秒，检查图片、原声、频谱和切图动画。
2. 图片静置5分钟，再切换数张图片，观察画面/颜色和声音。
3. 视频连续播放3分钟；做5次图片→视频→图片往返，含视频只播1～2秒便返回；检查暂停与从头播放。
4. 数码管每秒换页：`00C11341`版本、`C000xxxx`已校验扇区数、`E000xxxx`CRC错误数。E页期望为0，C页读取增加到FFFF饱和。
5. 做3次冷启动，记录首次出图和出声。异常时保留屏幕与三页数码管录像、触发动作。

回退：加载 `rollback/video40_spi25.bit`，确认 `00C11340`，同卡同线同供电比较。C40字节与刚才用户确认正常版本一致。

离线验证包含公开逻辑自然启动/周期、ACK宽度与注错消融、生产映射控制器实际命令、最终路由/源与位流绑定。门级使用显式应用输入及无存储行为器件观察器；物理时序、数据保持和整机长时运行由本次上板补验。
'''
(PACKAGE/'00_START_HERE.md').write_text(guide,encoding='utf-8')
(PACKAGE/'反馈模板.txt').write_text('版本：\n供电/接线/卡有无变化：\n图片静置5分钟/切图：\n原声/内置音阶：\n视频3分钟/暂停/从头：\n模式往返5次：\n3次冷启动：\nC页/E页：\n异常动作与录像路径：\nC40同条件回退结果：\n',encoding='utf-8')
manifest={p.relative_to(PACKAGE).as_posix():{'sha256':sha(p),'bytes':p.stat().st_size}
          for p in sorted(PACKAGE.rglob('*')) if p.is_file()}
save(PACKAGE/'manifest.json',{'created_utc':timestamp,'files':manifest})
zip_path=PACKAGE.with_suffix('.zip')
with zipfile.ZipFile(zip_path,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as z:
    for p in sorted(PACKAGE.rglob('*')):
        if p.is_file(): z.write(p,p.relative_to(PACKAGE).as_posix())
with zipfile.ZipFile(zip_path) as z:
    assert z.testzip() is None
    for name,item in manifest.items(): assert hashlib.sha256(z.read(name)).hexdigest()==item['sha256'],name
    assert z.read('video41_refresh.bit')==bit.read_bytes()
    assert z.read('rollback/video40_spi25.bit')==baseline.read_bytes()
receipt={'status':'PACKAGE_HASH_VERIFIED_BOARD_PENDING','created_utc':timestamp,
  'zip':zip_path.relative_to(ROOT).as_posix(),'zip_sha256':sha(zip_path),'zip_bytes':zip_path.stat().st_size,
  'payload_files_checked':len(manifest),'bit_sha256':sha(bit),'baseline_bit_sha256':sha(baseline),
  'source_binding_sha256':sha(VERIFY/'final_stage_binding.json'),'manifest_sha256':sha(PACKAGE/'manifest.json')}
save(VERIFY/'delivery_receipt.json',receipt)
print(json.dumps(receipt,indent=2))
