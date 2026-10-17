from pathlib import Path
from datetime import datetime,timezone,timedelta
import hashlib,json,re,shutil,zipfile

p=Path(__file__).resolve().parent
root=p.parents[1];old=root/'development/player_spectrum_tf_margin'
manual=p/'build/manual';hdl=p/'src/user_source/hdl_source'
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest().upper()
def readj(f):return json.loads(f.read_text(encoding='utf-8-sig'))
stamp=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
bit=manual/'AC201_player_spectrum_clock_route.bit'
assert bit.exists()
timing_text=(manual/'AC201_tf_hdmi_phy.ts').read_text(encoding='utf-8-sig')
m=re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.',timing_text)
assert m
timing=dict(zip(('SWNSns','STNSns','HWNSns','HTNSns'),map(float,m.groups())))
assert all(x>=0 for x in timing.values())
stages={}
for stage in ('synthesis','physical','hold','bitstream'):
    latest=readj(manual/f'stage_evidence/latest_{stage}.json')
    e=readj(manual/'stage_evidence'/latest['record']);assert e['status']=='success'
    stages[stage]=e
assert len({e['scopeHash'] for e in stages.values()})==1
assert len({e['scriptHash'] for e in stages.values()})==1
assert sha(bit)==stages['bitstream']['bitHash'].upper()
for row in readj(manual/'build_source_scope.json'):
    assert sha(p/'src'/row['path'])==row['sha256'].upper()
changed=[];inherited=[];added=[]
for f in (p/'src/user_source').rglob('*'):
    if not f.is_file():continue
    rel=f.relative_to(p/'src/user_source').as_posix();base=old/'src/user_source'/rel
    if not base.is_file():added.append(rel);continue
    (inherited if sha(f)==sha(base) else changed).append(rel)
allowed={'hdl_source/top_tf_hdmi_audio.v','hdl_source/player_status_monitor.v','hdl_source/tf_bmp_file_player.v'}
assert set(changed)==allowed,changed
assert set(added)=={'hdl_source/player_status_mailbox.v'}
assert '<eram_init>on</eram_init>' not in (p/'src/td_project/AC201_tf_hdmi.al').read_text(encoding='utf-8-sig')
assert 'SPI_HIGH_SPEED_DIV(2)' in (hdl/'top_tf_hdmi_audio.v').read_text(encoding='utf-8-sig')
assert sha(root/'download/bmp_scale.bit')=='C60464C0D4396D316DB7622E4CB0B70B5DE12C25148AFE234AC7C795C818625D'
assert sha(root/'download/spectrum_tf_margin.bit')=='AD3C0ED07482FF88B9F252AFC3862311DE752216A511FE7164782D56E4B8C895'
assert sha(root/'deliverables/music_spectrum_tf_margin_20261014.zip')=='0A1E83ECAB5B826E3F7480223D8BB511619337A460887D6500B7DC763F54A4ED'
parent_snapshot=old/'checkpoints/music_spectrum_tf_margin_20261014_candidate'
rows=readj(parent_snapshot/'manifest.json')
for row in rows:
    f=parent_snapshot/row['path'];assert f.stat().st_size==row['bytes'] and sha(f)==row['sha256'].upper()
assert len(rows)==230
for kind in ('gate','routed'):
    audit=readj(p/f'build/audit/{kind}_rom_init.json');assert audit['all_match']
    control=readj(p/f'build/audit/{kind}_rom_control.json');assert control['status']=='PASS'
    v=manual/'AC201_tf_hdmi_gate.v' if kind=='gate' else p/'build/audit/routed_implementation.v'
    assert sha(v)==control['netlist_sha256'].upper()==audit['gate_sha256'].upper()
for log,marker in [('sd_read_crc.log','PASS tb_sd_read_crc'),('media_pages.log','PASS media_status_pages'),
                   ('spectrum_diag_run.log','PASS spectrum_diag')]:
    assert marker in (p/'build/model'/log).read_text(encoding='utf-8-sig'),log
bmp_results=sorted((p/'build/model').glob('bmp_failure_detail_result_*.json'))
assert bmp_results
bmp=readj(bmp_results[-1]);assert bmp['status']=='PASS'
for name,value in bmp['source_sha256'].items():
    f=hdl/name if name in ('tf_bmp_file_player.v','bmp_scale_engine.v') else p/'sim'/name
    assert sha(f)==value.upper()
assert 'BMP_FAILURE_DETAIL PASS cases=21' in Path(bmp['simulation_log']).read_text(encoding='utf-8-sig')
assert any('PASS' in f.read_text(encoding='utf-8-sig') for f in (p/'build/model').glob('*spi*log'))
for kind in ('gate','routed'):
    clock_audit=readj(p/f'build/audit/{kind}_clock_route.json')
    assert clock_audit['status']=='PASS'
    v=manual/'AC201_tf_hdmi_gate.v' if kind=='gate' else p/'build/audit/routed_implementation.v'
    assert sha(v)==clock_audit['netlist_sha256'].upper()
    assert sha(manual/'AC201_tf_hdmi_pr.timing')==clock_audit['timing']['sha256'].upper()
control=readj(p/'build/audit/bmp_control_process_audit.json');assert control['status']=='PASS'
assert sha(hdl/'tf_bmp_file_player.v')==control['newSha256'].upper()
status_model=readj(p/'build/model/status_clock_route_binding.json')
assert status_model['result']=='PASS'
for row in status_model['files']:assert sha(Path(row['path']))==row['sha256'].upper()
assert 'PASS status clock route' in (p/'build/model/status_clock_route_run.log').read_text(encoding='utf-8-sig')

area=(manual/'AC201_tf_hdmi_phy.area').read_text(encoding='utf-8-sig')
resource={k:int(re.search(r'^\s*#'+q+r'\s+(\d+)',area,re.M).group(1)) for k,q in [('LUT','lut'),('reg','reg'),('LE','le'),('BRAM9K','bram9k'),('DSP','dsp'),('GCLK','gclk')]}
assert resource['LUT']<=19600 and resource['LE']<=19600 and resource['BRAM9K']<=64
info={'version':'C11309','createdBeijing':stamp,'boardStatus':'PENDING_BOARD_VALIDATION',
 'parent':'C11308 failed board validation: images/controls work, green bands across all overlays, both audio sources silent, fixed left8 on595',
 'successfulBaseline':'C11206 bmp_scale.bit','bitSha256':sha(bit),'bitBytes':bit.stat().st_size,
 'changes':changed,'added':added,'inheritedFiles':len(inherited),'timing':timing,'resource':resource,
 'stageRunIds':{k:v['runId'] for k,v in stages.items()},
 'changesScope':'Explicit EG_LOGIC_BUFG for125MHz serial clock; 595 scanning on50MHz system-clock BUFG with atomic requestACK snapshot; passive BMP diagnostic geometry pipelined to remove slow observer CE path; rst_all declared before use. Original BMP control process matches C11206 after whitespace/comment normalization; TF divisor2, FFT, lane/PHY, PLL parameters and SDC inherited byte-for-byte.',
 'limits':'Clock routing is an isolation candidate, not proven physical root cause. Existing missing external output delay/electrical measurements remain; protected BRAM dynamic behavior not simulated. Status scanning/mailbox tests prove digital logic only, not physical595. SD CRC counters do not prevent corrupted sectors or retry.',
 'modelEvidence':'C11309 actual595 serial pin-level decoding/mailbox, status pages and21 BMP observer cases; SD/SPI diagnostic model results inherited with identical production RTL hashes from C11308; FFT/serializer evidence inherited from unchanged C11307 source; no vendor protected BRAM simulation',
 'operation':'PROGRAM_SRAM/JTAG5MHz; DFC11309; default before longKEY1, then tone; segment full cycle26s plus optional initial4s selftest; observe E/F0/F1 if failure.'}
source_diff={'parent':'C11308','changed':changed,'added':added,'inherited':inherited}
(p/'build/source_diff_final.json').write_text(json.dumps(source_diff,indent=2)+'\n',encoding='utf-8')
test_binding=[{'path':f.relative_to(p).as_posix(),'sha256':sha(f)} for base in (p/'sim',hdl) for f in sorted(base.rglob('*')) if f.is_file() and f.suffix in ('.v','.ps1','.mem','.vh')]
(p/'build/model/current_source_binding.json').write_text(json.dumps({'createdBeijing':stamp,'inputs':test_binding,'scope':'C11309 status595/mailbox/page models; unchanged SD/BMP/SPI and FFT/renderer evidence inherited with source hashes.'},indent=2)+'\n',encoding='utf-8')
delivery=p/'build/delivery';delivery.mkdir(exist_ok=False)
readme='# C11309：HDMI串行全局时钟与独立数码管扫描（实板待验证）\n\nC11308用户反馈图片/切图/轮播/参数调节正常，但绿色条带覆盖图片/字幕/频谱，两音源无声且数码管左8持续固定，拨码未改变。当前候选给125MHz HDMI串行时钟增加显式全局缓冲，四路PAD与串行逻辑共享该时钟；数码管扫描改到既有50MHz系统全局时钟，显示值用完整32位请求/应答快照从pixel域传递。没有改变PLL频率/相位参数、HDMI序列化RTL、TF6.25MHz设置或频谱算法。不是已确认的根因修复；电气和完整实板效果待验证。\n\nBitWriter PROGRAM_SRAM / JTAG5MHz，加载 spectrum_clock_route.bit，D页应为DFC11309。数码管启动前4秒为自检，之后完整轮转26秒。先看数码管能否轮转，再默认WAV检查画面/绿带/声音/频谱，长KEY1检查内置音阶。保持现有接线/拨码；若异常录至少28秒数码管并描述两音源，若仍左8则直接记录持续固定。该包不要求重新装TF素材。成功回退bmp_scale.bit=C11206仍随包保留。\n\n- E页格式 E{图片目录数}{原因两位}{细节四位}。E4020001表示目录4张、头检查失败且BM签名不正确；E4000000表示目录4张且尚无锁存错误（不能单独证明图片完成）。01=头扇区字节数异常（细节为数量）；02=头部校验（mask bit0 BM、1 DIB、2像素偏移、3 planes、4位深、5压缩、6宽、7高、8文件数据范围、9声明数据范围、10声明文件长度）；03=缩放器失败，细节低字节：01mapper、02尺寸、03文件范围、04行地址溢出、05像素地址范围、06扇区过长、07扇区不足、08状态异常；04=mapper故障；05=等待超时；06=状态异常。04/05/06细节低位为失败时loader状态（2 HEADER、4 WRITE_WAIT、7 COMMIT）。首次错误锁存至复位。\n- F0页后三字节低16位为坏CRC扇区数；F1页为检查扇区数。正常读取时F1应增长，F0通常0；任何增长表明本次接收扇区内容与卡发送的CRC不符，不能直接指定线缆/卡/电源为根因。计数FFFF饱和。CRC观察不干预原播放链路、不自动重试。双级同步活计数可能在变化瞬间显示过渡值，请看稳定值/趋势。\n- B/C仍为FFT帧数/阶段状态与幅值；6/7/8页F485是当前素材跳过65536样本后检查32768样本窗口，A页8000是捕获数量，不能当作文件data offset或整曲校验。首个启动阶段尚未完成时这些数值可能无效。\n\n\n本地：新增实际595引脚解码/跨时钟快照模型、当前状态页；父版SD/BMP/SPI模型仅在相同生产源SHA绑定下继承。完整TD综合/布线/nativehold/位流同源生成；gate及routed均核验显式第三GCLK、PLL→GCLK→四PAD及串行逻辑时钟连线、595三个PAD系统时钟连线、ROM系数/控制。新串行路由偏斜以审计JSON为准，不夸称改善数值。静态时序和数字模型不证明板上HDMI/595电气效果、整曲音频或唯一故障原因。未执行JTAG/TF写入/Flash。\n'
txt=json.dumps(info,ensure_ascii=False,indent=2)+'\n'
readme+='\n为清除本轮布线发现的观测路径违例，BMP诊断几何计算增加流水寄存器；首次失败含义保持，原图片控制过程与成功C11206逐token一致。该诊断不参与播放控制。新的21项BMP诊断模型已重新通过；旧失败布局证据保留build/rejected_setup。\n'
for folder in ('download','deliverables'):shutil.copyfile(bit,root/folder/'spectrum_clock_route.bit')
(root/'download/spectrum_clock_route.info.json').write_text(txt,encoding='utf-8')
(manual/'AC201_player_spectrum_clock_route.info.json').write_text(txt,encoding='utf-8')
shutil.copyfile(bit,delivery/'spectrum_clock_route.bit');shutil.copyfile(root/'download/bmp_scale.bit',delivery/'bmp_scale.bit')
(delivery/'info.json').write_text(txt,encoding='utf-8');(delivery/'README.md').write_text(readme,encoding='utf-8')
(delivery/'checksums.sha256').write_text(''.join(f'{sha(f)}  {f.name}\n' for f in sorted(delivery.iterdir()) if f.name!='checksums.sha256'),encoding='ascii')
out=root/'deliverables/music_spectrum_clock_route_20261014.zip';assert not out.exists()
with zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED) as z:
    for f in sorted(delivery.iterdir()):z.write(f,f.name)
with zipfile.ZipFile(out) as z:
    assert z.testzip() is None
    for f in delivery.iterdir():assert z.read(f.name)==f.read_bytes()
checkpoint=p/'checkpoints/music_spectrum_clock_route_20261014_candidate';assert not checkpoint.exists()
for name in ('src','scripts','sim','build/manual','build/prehold','build/rejected_setup','build/model','build/audit','build/delivery'):
    shutil.copytree(p/name,checkpoint/name,ignore=shutil.ignore_patterns('__pycache__','AC201_tf_hdmi_Runs'))
shutil.copyfile(p/'package_candidate.py',checkpoint/'package_candidate.py')
shutil.copyfile(p/'build/source_diff_final.json',checkpoint/'build/source_diff_final.json')
manifest=[{'path':f.relative_to(checkpoint).as_posix(),'bytes':f.stat().st_size,'sha256':sha(f)} for f in sorted(checkpoint.rglob('*')) if f.is_file()]
(checkpoint/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
for row in manifest:
    f=checkpoint/row['path'];assert f.stat().st_size==row['bytes'] and sha(f)==row['sha256']
receipt={'createdBeijing':stamp,'status':'LOCAL_CANDIDATE_DELIVERED_BOARD_PENDING','zip':str(out),'zipSha256':sha(out),'bitSha256':sha(bit),
 'checkpoint':str(checkpoint),'files':len(manifest),'manifestSha256':sha(checkpoint/'manifest.json'),'timing':timing,'resource':resource,'parentFrozenFilesVerified':230}
(p/'build/delivery_verified.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps(receipt,indent=2))
