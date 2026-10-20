from pathlib import Path
from datetime import datetime,timezone,timedelta
import json,hashlib,re,shutil,zipfile

repo=Path(__file__).resolve().parents[1]
p=repo/'development/player_spectrum_trace'
manual=p/'build/manual';audit=p/'build/audit';model=p/'build/model'
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest()
def read(f):return json.loads(f.read_text(encoding='utf-8-sig'))
stages={}
for stage in ('synthesis','physical','hold','bitstream'):
    pointer=read(manual/f'stage_evidence/latest_{stage}.json')
    record=read(manual/'stage_evidence'/pointer['record'])
    assert pointer['status']==record['status']=='success'
    assert pointer['runId']==record['runId']
    stages[stage]=record
assert len({v['scopeHash'] for v in stages.values()})==1
assert len({v['scriptHash'] for v in stages.values()})==1
for stage,record in stages.items():
    for s in record['scripts']:assert sha(p/'scripts'/s['path'])==s['sha256']
for s in read(manual/'build_source_scope.json'):assert sha(p/'src'/s['path'])==s['sha256'].lower()
for name,digest in stages['hold']['artifacts'].items():assert sha(manual/name)==digest
bit=manual/'AC201_player_spectrum_trace.bit'
assert sha(bit)==stages['bitstream']['bitHash']
assert stages['bitstream']['routeStage']=='hold'
timing=(manual/'AC201_tf_hdmi_phy.ts').read_text()
assert 'SWNS: 0.060ns' in timing and 'HWNS: 0.024ns' in timing and 'HTNS: 0.000ns' in timing
assert read(audit/'routed_clock_route.json')['status']=='PASS'
assert read(audit/'rom_polarity_verified.json')['status']=='PASS'
for name in ('gate_rom_init.json','routed_rom_init.json'):assert read(audit/name)['all_match']
assert read(audit/'passive_source_scope.json')['status']=='PASS'
tests={
    'fault_snapshot/run.log':'PASS fault_snapshot',
    'snapshot_fft/run.log':'PASS snapshot_fft_integration',
    'snapshot_display/run.log':'PASS snapshot_display',
    'full_top_snapshot_gate/console.log':'PASS full_top_snapshot',
    'full_top_snapshot_routed/console.log':'PASS full_top_snapshot',
}
for name,marker in tests.items():
    text=(model/name).read_text(errors='replace')
    assert marker in text and '# FAIL' not in text and 'FATAL:' not in text,name
    if 'full_top' in name:assert 'Loading work.top' in text and 'display_mailbox_words=7' in text
rollback=repo/'download/bmp_scale.bit'
assert sha(rollback)=='c60464c0d4396d316db7622e4cb0b70b5de12c25148afe234ac7c795c818625d'
for name,digest in {'spectrum_clock_route.bit':'9171f813bddec5b81b7f3577bf7c7804a3f5a24138f7763b253d7d5fb8040b3f','spectrum_fft_recover.bit':'9a076c4170deb9ba84526b61e9f086a12ef59399db7721eafb5f7a80186bfa0c'}.items():assert sha(repo/'download'/name)==digest
now=datetime.now(timezone(timedelta(hours=8))).isoformat()
meta={'build_id':'C11312','status':'DIAGNOSTIC_CANDIDATE_PENDING_BOARD','created':now,
      'bitstream_sha256':sha(bit),'bitstream_bytes':bit.stat().st_size,'root_cause_confirmed':False,
      'purpose':'Passive atomic snapshots of the preceding/current FFT counters and reset/source/timeout controls, frozen on a fault; rearm on audio source change.',
      'changes':'4 existing HDL files plus 1 new passive module; analyzer/render arithmetic and control token comparison unchanged after removing observation ports/declaration ordering; display pages 6..C repurposed.',
      'timing':{'setup_wns_ns':0.060,'hold_wns_ns':0.024,'setup_tns_ns':0,'hold_tns_ns':0,'coverage':'99.98%'},
      'resources':{'lut':16934,'register':10061,'LE':18481,'BRAM9K':44,'DSP':12,'GCLK':3},
      'tests':{k:{'marker':v,'sha256':sha(model/k)} for k,v in tests.items()},
      'stages':{k:{n:v[n] for n in ('runId','scopeHash','scriptHash')} for k,v in stages.items()},
      'limits':'No board/JTAG/TF/Flash operation. No full SDF or electrical verification. Earlier C11310 FFT gate/routed cones and video-control gate tests passed under controlled stimuli but did not reproduce the board failure. This is a diagnostic build, not a proven repair.',
      'rollback':{'file':'bmp_scale.bit','build_id':'C11206','sha256':sha(rollback)}}
(manual/'AC201_player_spectrum_trace.info.json').write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
prep=read(p/'build/preparation.json');prep.update(status=meta['status'],bitstream_sha256=sha(bit),last_update=now)
(p/'build/preparation.json').write_text(json.dumps(prep,ensure_ascii=False,indent=2),encoding='utf-8')
delivery=p/'build/delivery/C11312'
delivery.mkdir(parents=True,exist_ok=False)
shutil.copy2(bit,delivery/'spectrum_trace.bit');shutil.copy2(rollback,delivery/'bmp_scale.bit')
shutil.copy2(manual/'AC201_player_spectrum_trace.info.json',delivery/'spectrum_trace.info.json')
shutil.copy2(p/'sim/decode_snapshot.py',delivery/'decode_snapshot.py')
readme='''C11312：冻结故障现场的诊断版本（尚未实板验证，不是已确认修复版）

用途：判断实板上采样计数、接受计数、局部复位/切源/超时与HDMI锁定状态之间的关系。
快照在同一个25MHz时钟域记录相邻两拍，并在故障后保持；切换音源会重新捕获。

首次只需这一项新取证：
1. 在连接板卡的电脑上把本包解压到英文路径，保持现有TF卡、供电和HDMI连接。
2. 用BitWriter的PROGRAM_SRAM、JTAG 5MHz下载 spectrum_trace.bit。数码管D页应显示 DFC11312。
3. 暂不长按KEY1，默认音乐模式下录制数码管40秒，提供视频路径，并说明HDMI/声音/频谱是否正常。
   视频要能读清6、7、8、9、A、B、C七页以及D页的完整八位字符。数码管初始自检01234567和88888888共4秒，随后16页各2秒。
   无论画面是否恢复，都先保留这段诊断；不必反复换线、改卡或重复此前回载对照。
4. 收集后如需恢复使用，可用同包 bmp_scale.bit 回载完整稳定基线C11206。

快照页（本诊断版6..C页已改用途）：
6：高4位标签6；第二位是捕获原因，1=音画内核和FFT已工作的参考，2=第四个视频帧起点仍未HDMI锁定，3=4096个输入有效样本间没有FFT完成，4=前后两拍计数关系异常。
7/8：异常前一拍/当前拍的FFT状态、采样计数与加窗索引。
9/A：异常前一拍/当前拍的24位接受样本计数。
B：捕获时已完成FFT帧数。C：捕获时局部恢复和切源计数。
7..C的第二位8表示快照有效。原因1的参考快照可被后续故障覆盖；原因2/3/4保持到切换音源或重新配置。
F2/F3/F4仍是实时诊断页，不能把不同实时页当成同一拍。

离线解码（七个参数为录像中的6..C页完整八位值）：
python decode_snapshot.py 64A10100 78000000 88000200 98000000 A8000000 B8000000 C8000001
以上只是仿真故障注入示例，不是实板实测值。

本地检查：原子快照77检查、真实FFT与观察器集成48频段定点值、176显示页采样，以及完整gate/routed网表故障注入后七字显示邮箱传输均通过。
最终setup +0.060ns/hold +0.024ns，TNS均0。两版系数1536字核对、ROM控制32态逻辑等价及45项时钟映射核查通过。
未修改原媒体/按键控制过程、PLL、引脚或SDC；新增观察会改变布局布线，所以诊断版恢复也不单独证明原故障根因。
未操作Flash/TF/JTAG；不需要将本诊断版固化到Flash。
'''
(delivery/'README_zh.txt').write_text(readme,encoding='utf-8-sig')
(delivery/'SHA256SUMS.txt').write_text('\n'.join(f'{sha(f)}  {f.name}' for f in sorted(delivery.iterdir()) if f.is_file())+'\n',encoding='ascii')
for name in ('spectrum_trace.bit','spectrum_trace.info.json'):
    target=repo/'download'/name
    assert not target.exists(),target
    shutil.copy2(delivery/name,target)
checkpoint=p/'checkpoints/music_spectrum_trace_20261015_candidate'
checkpoint.mkdir(parents=True,exist_ok=False)
for folder in ('src','scripts','sim'):
    shutil.copytree(p/folder,checkpoint/folder,ignore=shutil.ignore_patterns('*_Runs','__pycache__','*.db','*.vvp','work'))
for folder in ('audit','model'):
    shutil.copytree(p/'build'/folder,checkpoint/'build'/folder,ignore=shutil.ignore_patterns('work','cone_work','*.db','*.vvp','*.wlf','__pycache__'))
(checkpoint/'build/manual').mkdir(parents=True)
for f in manual.iterdir():
    if f.is_file() and f.suffix in ('.bit','.json','.log','.timing','.ts','.area','.v'):shutil.copy2(f,checkpoint/'build/manual'/f.name)
shutil.copytree(manual/'stage_evidence',checkpoint/'build/manual/stage_evidence')
files=[{'path':str(f.relative_to(checkpoint)).replace('\\','/'),'sha256':sha(f),'bytes':f.stat().st_size} for f in sorted(checkpoint.rglob('*')) if f.is_file()]
manifest={'build_id':'C11312','created':now,'status':'FROZEN_DIAGNOSTIC_PENDING_BOARD','files':files}
(checkpoint/'manifest.json').write_text(json.dumps(manifest,indent=2),encoding='utf-8')
for item in files:assert sha(checkpoint/item['path'])==item['sha256']
zip_path=repo/'deliverables/music_spectrum_trace_20261015.zip'
assert not zip_path.exists()
with zipfile.ZipFile(zip_path,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as z:
    for f in delivery.iterdir():z.write(f,f.name)
with zipfile.ZipFile(zip_path) as z:
    for f in delivery.iterdir():assert hashlib.sha256(z.read(f.name)).hexdigest()==sha(f)
receipt={'build_id':'C11312','status':meta['status'],'time':now,'checkpoint':str(checkpoint),'frozen_file_count':len(files),'manifest_sha256':sha(checkpoint/'manifest.json'),'zip':str(zip_path),'zip_sha256':sha(zip_path),'bit_sha256':sha(bit),'delivery_hashes_verified':True}
(p/'build/delivery_receipt.json').write_text(json.dumps(receipt,indent=2),encoding='utf-8')
print(json.dumps(receipt,indent=2))
