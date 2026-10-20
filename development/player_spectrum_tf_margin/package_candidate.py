from pathlib import Path
from datetime import datetime,timezone,timedelta
import hashlib,json,re,shutil,zipfile

p=Path(__file__).resolve().parent
root=p.parents[1];old=root/'development/player_spectrum_observed'
manual=p/'build/manual';hdl=p/'src/user_source/hdl_source'
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest().upper()
def readj(f):return json.loads(f.read_text(encoding='utf-8-sig'))
stamp=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
bit=manual/'AC201_player_spectrum_tf_margin.bit'
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
changed=[];inherited=[]
for f in (p/'src/user_source').rglob('*'):
    if not f.is_file():continue
    rel=f.relative_to(p/'src/user_source').as_posix();base=old/'src/user_source'/rel
    assert base.is_file(),rel
    (inherited if sha(f)==sha(base) else changed).append(rel)
allowed={'hdl_source/top_tf_hdmi_audio.v','hdl_source/player_status_monitor.v',
 'hdl_source/tf_bmp_file_player.v','hdl_source/bmp_scale_engine.v',
 'hdl_source/SD/sd_card_cmd.v','hdl_source/SD/sd_card_top.v'}
assert set(changed)==allowed,changed
assert '<eram_init>on</eram_init>' not in (p/'src/td_project/AC201_tf_hdmi.al').read_text(encoding='utf-8-sig')
assert 'SPI_HIGH_SPEED_DIV(2)' in (hdl/'top_tf_hdmi_audio.v').read_text(encoding='utf-8-sig')
assert sha(root/'download/bmp_scale.bit')=='C60464C0D4396D316DB7622E4CB0B70B5DE12C25148AFE234AC7C795C818625D'
assert sha(root/'download/spectrum_observed.bit')=='8CFD873C1B9727A18C8A3731233943B6C43D56DD56677623CDAEC0962B7A2AF4'
assert sha(root/'deliverables/music_spectrum_observed_20261013.zip')=='F96C748747BD008A18461D5728247A7430C0AF1FF0BB4E87A6FBC8B5A5E9D626'
parent_snapshot=old/'checkpoints/music_spectrum_observed_20261013_candidate'
rows=readj(parent_snapshot/'manifest.json')
for row in rows:
    f=parent_snapshot/row['path'];assert f.stat().st_size==row['bytes'] and sha(f)==row['sha256'].upper()
assert len(rows)==281
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
area=(manual/'AC201_tf_hdmi_phy.area').read_text(encoding='utf-8-sig')
resource={k:int(re.search(r'^\s*#'+q+r'\s+(\d+)',area,re.M).group(1)) for k,q in [('LUT','lut'),('reg','reg'),('LE','le'),('BRAM9K','bram9k'),('DSP','dsp'),('GCLK','gclk')]}
assert resource['LUT']<=19600 and resource['LE']<=19600 and resource['BRAM9K']<=64
info={'version':'C11308','createdBeijing':stamp,'boardStatus':'PENDING_BOARD_VALIDATION',
 'parent':'C11307 partial progress; no BMP and WAV noise; tone/spectrum user-reported normal',
 'successfulBaseline':'C11206 bmp_scale.bit','bitSha256':sha(bit),'bitBytes':bit.stat().st_size,
 'changes':changed,'inheritedFiles':len(inherited),'timing':timing,'resource':resource,
 'stageRunIds':{k:v['runId'] for k,v in stages.items()},
 'changesScope':'TF SPI divisor0->2; passive raw512-byte SD CRC counters and sticky BMP failure detail; status E/F0/F1. Existing FFT/PHY/PLL/SDC inherited byte-for-byte.',
 'limits':'Clock margin is an isolation experiment, not confirmed physical root cause. CRC counters do not prevent corrupted sectors or retry. Binary counter CDC diagnostic may briefly show a transitional count. Digital/STA evidence does not prove physical A/V.',
 'modelEvidence':'build/model source-bound tests plus structurally inherited C11307 full FFT/serializer evidence; no protected vendor BRAM dynamic simulation',
 'operation':'PROGRAM_SRAM/JTAG5MHz; DFC11308; default before longKEY1, then tone; segment full cycle26s plus optional initial4s selftest; observe E/F0/F1 if failure.'}
source_diff={'parent':'C11307','changed':changed,'inherited':inherited}
(p/'build/source_diff_final.json').write_text(json.dumps(source_diff,indent=2)+'\n',encoding='utf-8')
test_binding=[{'path':f.relative_to(p).as_posix(),'sha256':sha(f)} for base in (p/'sim',hdl) for f in sorted(base.rglob('*')) if f.is_file() and f.suffix in ('.v','.ps1','.mem','.vh')]
(p/'build/model/current_source_binding.json').write_text(json.dumps({'createdBeijing':stamp,'inputs':test_binding,'scope':'Current C11308 diagnostic/SPI tests; full FFT/renderer evidence is inherited only where production HDL bytes are unchanged.'},indent=2)+'\n',encoding='utf-8')
delivery=p/'build/delivery';delivery.mkdir(exist_ok=False)
readme='''# C11308：TF读余量与图片失败定位（实板待验证）

C11307用户反馈两音源频谱正常、内置音阶干净；BMP加载失败、天ノ弱有杂音。该候选仅将TF SPI时钟从名义12.5MHz降低到6.25MHz，尝试增加外部采样余量；增加被动扇区CRC和图片首错诊断。不能声称确定根因或实板修复。图片加载可能变慢。频谱、HDMI发送、PLL和引脚/SDC继承C11307。

使用 BitWriter PROGRAM_SRAM / JTAG 5MHz，文件 spectrum_tf_margin.bit；D页为 DFC11308。启动前4秒为数码管自检，随后一轮26秒。先默认WAV检查图片、杂音/频谱，再长KEY1检查内置音阶/频谱/图片；无需重新装卡或修改素材。若异常，请分别记录数码管至少28秒包含E/F0/F1，并说明现象。原成功回退bmp_scale.bit=C11206仍随包保留；未执行JTAG、TF写入或Flash。

- E页格式 E{图片目录数}{原因两位}{细节四位}。E4020001表示目录4张、头检查失败且BM签名不正确；E4000000表示目录4张且尚无锁存错误（不能单独证明图片完成）。01=头扇区字节数异常（细节为数量）；02=头部校验（mask bit0 BM、1 DIB、2像素偏移、3 planes、4位深、5压缩、6宽、7高、8文件数据范围、9声明数据范围、10声明文件长度）；03=缩放器失败，细节低字节：01mapper、02尺寸、03文件范围、04行地址溢出、05像素地址范围、06扇区过长、07扇区不足、08状态异常；04=mapper故障；05=等待超时；06=状态异常。04/05/06细节低位为失败时loader状态（2 HEADER、4 WRITE_WAIT、7 COMMIT）。首次错误锁存至复位。
- F0页后三字节低16位为坏CRC扇区数；F1页为检查扇区数。正常读取时F1应增长，F0通常0；任何增长表明本次接收扇区内容与卡发送的CRC不符，不能直接指定线缆/卡/电源为根因。计数FFFF饱和。CRC观察不干预原播放链路、不自动重试。双级同步活计数可能在变化瞬间显示过渡值，请看稳定值/趋势。
- B/C仍为FFT帧数/阶段状态与幅值；6/7/8页F485是当前素材跳过65536样本后检查32768样本窗口，A页8000是捕获数量，不能当作文件data offset或整曲校验。首个启动阶段尚未完成时这些数值可能无效。

本地：BMP21项外部接口模型、SD读CRC故障模型、SPI人工延迟余量、诊断页、频谱遥测，以及TD综合/布线/保持修复/位流和ROM系数/控制静态核验。人工延迟模型不构成实物故障证明；protected BRAM实际动态读、实际TF/HDMI电气和整曲声音未验证。详细依据见info及工程build证据。
'''
txt=json.dumps(info,ensure_ascii=False,indent=2)+'\n'
for folder in ('download','deliverables'):shutil.copyfile(bit,root/folder/'spectrum_tf_margin.bit')
(root/'download/spectrum_tf_margin.info.json').write_text(txt,encoding='utf-8')
(manual/'AC201_player_spectrum_tf_margin.info.json').write_text(txt,encoding='utf-8')
shutil.copyfile(bit,delivery/'spectrum_tf_margin.bit');shutil.copyfile(root/'download/bmp_scale.bit',delivery/'bmp_scale.bit')
(delivery/'info.json').write_text(txt,encoding='utf-8');(delivery/'README.md').write_text(readme,encoding='utf-8')
(delivery/'checksums.sha256').write_text(''.join(f'{sha(f)}  {f.name}\n' for f in sorted(delivery.iterdir()) if f.name!='checksums.sha256'),encoding='ascii')
out=root/'deliverables/music_spectrum_tf_margin_20261014.zip';assert not out.exists()
with zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED) as z:
    for f in sorted(delivery.iterdir()):z.write(f,f.name)
with zipfile.ZipFile(out) as z:
    assert z.testzip() is None
    for f in delivery.iterdir():assert z.read(f.name)==f.read_bytes()
checkpoint=p/'checkpoints/music_spectrum_tf_margin_20261014_candidate';assert not checkpoint.exists()
for name in ('src','scripts','sim','build/manual','build/prehold','build/model','build/audit','build/delivery'):
    shutil.copytree(p/name,checkpoint/name,ignore=shutil.ignore_patterns('__pycache__','AC201_tf_hdmi_Runs'))
shutil.copyfile(p/'package_candidate.py',checkpoint/'package_candidate.py')
shutil.copyfile(p/'build/source_diff_final.json',checkpoint/'build/source_diff_final.json')
manifest=[{'path':f.relative_to(checkpoint).as_posix(),'bytes':f.stat().st_size,'sha256':sha(f)} for f in sorted(checkpoint.rglob('*')) if f.is_file()]
(checkpoint/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
for row in manifest:
    f=checkpoint/row['path'];assert f.stat().st_size==row['bytes'] and sha(f)==row['sha256']
receipt={'createdBeijing':stamp,'status':'LOCAL_CANDIDATE_DELIVERED_BOARD_PENDING','zip':str(out),'zipSha256':sha(out),'bitSha256':sha(bit),
 'checkpoint':str(checkpoint),'files':len(manifest),'manifestSha256':sha(checkpoint/'manifest.json'),'timing':timing,'resource':resource,'parentFrozenFilesVerified':281}
(p/'build/delivery_verified.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps(receipt,indent=2))
