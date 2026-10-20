from pathlib import Path
from datetime import datetime, timezone, timedelta
import hashlib, json, re, shutil, zipfile
p=Path(__file__).resolve().parent
root=p.parents[1]
parent=p.parent/'player_spectrum_clock_route'
manual=p/'build/manual'
hdl=p/'src/user_source/hdl_source'
def sha(f): return hashlib.sha256(f.read_bytes()).hexdigest().upper()
def readj(f): return json.loads(f.read_text(encoding='utf-8-sig'))
def bound(path, digest): assert sha(path)==digest.upper(), str(path)
stamp=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
bit=manual/'AC201_player_spectrum_fft_recover.bit'
stages={}
for stage in ('synthesis','physical','hold','bitstream'):
    latest=readj(manual/f'stage_evidence/latest_{stage}.json')
    e=readj(manual/'stage_evidence'/latest['record'])
    assert e['status']=='success'
    stages[stage]=e
assert len({x['scopeHash'] for x in stages.values()})==1
assert len({x['scriptHash'] for x in stages.values()})==1
bound(bit,stages['bitstream']['bitHash'])
for row in stages['bitstream']['scripts']: bound(p/'scripts'/row['path'],row['sha256'])
for name,digest in stages['hold']['artifacts'].items(): bound(manual/name,digest)
bound(manual/'AC201_tf_hdmi_gate.db',stages['synthesis']['gateDbHash'])
for x in readj(manual/'build_source_scope.json'): bound(p/'src'/x['path'],x['sha256'])
t=(manual/'AC201_tf_hdmi_phy.ts').read_text(encoding='utf-8-sig')
m=re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.',t)
assert m
timing=dict(zip(('SWNSns','STNSns','HWNSns','HTNSns'),map(float,m.groups())))
assert all(x>=0 for x in timing.values())
area=(manual/'AC201_tf_hdmi_phy.area').read_text(encoding='utf-8-sig')
resource={k:int(re.search(r'^\s*#'+q+r'\s+(\d+)',area,re.M).group(1)) for k,q in [('LUT','lut'),('reg','reg'),('LE','le'),('BRAM9K','bram9k'),('DSP','dsp'),('GCLK','gclk')]}
assert resource['LE']<=19600 and resource['BRAM9K']<=64 and resource['GCLK']==3
changed=[]; inherited=[]; added=[]
for f in sorted((p/'src/user_source').rglob('*')):
    if not f.is_file(): continue
    rel=f.relative_to(p/'src/user_source').as_posix()
    base=parent/'src/user_source'/rel
    if not base.is_file(): added.append(rel)
    else: (inherited if sha(f)==sha(base) else changed).append(rel)
assert set(changed)=={'hdl_source/player_spectrum_analyzer.v','hdl_source/player_pcm_waveform.v','hdl_source/top_tf_hdmi_audio.v','hdl_source/player_status_monitor.v'}
assert not added
bound(root/'download/bmp_scale.bit','C60464C0D4396D316DB7622E4CB0B70B5DE12C25148AFE234AC7C795C818625D')
bound(root/'download/spectrum_clock_route.bit','9171F813BDDEC5B81B7F3577BF7C7804A3F5A24138F7763B253D7D5FB8040B3F')
bound(root/'deliverables/music_spectrum_clock_route_20261014.zip','04D844F7736D4069F3CD7B6E66D32C49CC1EA9DFD75EB154FF7AF12AE0B56A38')
oldcp=parent/'checkpoints/music_spectrum_clock_route_20261014_candidate'
bound(oldcp/'manifest.json','E638D0FA259E12A584A9E31CEC4BABF97F1E261EB59474C338CC8295C503F0EA')
oldrows=readj(oldcp/'manifest.json')
assert len(oldrows)==240
for row in oldrows:
    f=oldcp/row['path']
    assert f.stat().st_size==row['bytes']
    bound(f,row['sha256'])
for kind in ('gate','routed'):
    net=manual/'AC201_tf_hdmi_gate.v' if kind=='gate' else p/'build/audit/routed_implementation.v'
    init=readj(p/f'build/audit/{kind}_rom_init.json')
    assert init['all_match']
    bound(net,init['gate_sha256'])
    clk=readj(p/f'build/audit/{kind}_clock_route.json')
    assert clk['status']=='PASS'
    bound(net,clk['netlist_sha256'])
    bound(manual/'AC201_tf_hdmi_pr.timing',clk['timing']['sha256'])
# Exact raw parameter differences are preserved. Semantic enable verification
# must prove every difference against the production state conditions.
polarity=readj(p/'build/audit/rom_polarity_evidence.json')
assert polarity['status']=='PASS'
# The proof schema is checked in its own executable verifier and receipt.
receipt=readj(p/'build/audit/rom_polarity_verified.json')
assert receipt['status']=='PASS'
bound(p/'build/audit/rom_polarity_evidence.json',receipt['evidence_sha256'])
for row in receipt['bound_files']: bound(Path(row['path']),row['sha256'])
bmp=readj(p/'build/audit/bmp_control_process_audit.json')
assert bmp['status']=='PASS'
bound(hdl/'tf_bmp_file_player.v',bmp['newSha256'])
model=readj(p/'build/model/model_result.json')
assert model['status']=='PASS'
for row in model['bound_sources'].values(): bound(root/row['path'],row['sha256'])
for result in model['results'].values():
    assert result['status']=='PASS'
    for key,path in result['evidence'].items():
        f=root/path
        assert f.is_file()
        if key=='run': assert 'PASS' in f.read_text(encoding='utf-8-sig')
assert model['results']['fft_recovery']['production_timeout_samples']==4096
assert model['results']['analyzer']['fixed_model_max_abs_error']==0
assert model['results']['real_music']['fixed_model_max_abs_error']==0
assert 'PASS media_status_pages' in (p/'build/model/media_pages.log').read_text(encoding='utf-8-sig')
page_binding=readj(p/'build/model/media_pages_binding.json')
assert page_binding['status']=='PASS'
for row in page_binding['bound_files']: bound(Path(row['path']),row['sha256'])
status=readj(p/'build/model/status_clock_route_binding.json')
assert status['result']=='PASS'
for row in status['files']: bound(Path(row['path']),row['sha256'])
diff={'parent':'C11309','changed':changed,'added':added,'inherited':inherited}
(p/'build/source_diff_final.json').write_text(json.dumps(diff,indent=2)+'\n',encoding='utf-8')
info={'version':'C11310','createdBeijing':stamp,'boardStatus':'PENDING_BOARD_VALIDATION',
 'parent':'C11309 user reports normal image/audio/non-spectrum functions; both sources have empty spectrum, B7000000/C7840000',
 'successfulBaseline':'C11206 bmp_scale.bit','stableMediaRollback':'C11309 spectrum_clock_route.bit',
 'bitSha256':sha(bit),'bitBytes':bit.stat().st_size,'timing':timing,'resource':resource,
 'changes':changed,'inheritedFiles':len(inherited),'stageRunIds':{k:v['runId'] for k,v in stages.items()},
 'scope':'FFT-local asynchronous assertion/synchronized release; retained 5-bit state/default recovery; 4096 incoming-sample no-frame watchdog; passive F2/F3/F4 telemetry. No watchdog feedback into global reset, PCM playback, HDMI or TF.',
 'modelEvidence':'Current-source 312 synthetic,48 real-WAV,72 integrated band values (fixed-point error0),650 pixel samples,telemetry; production4096 watchdog at521clock input cadence with testbench-only illegal-state/stall injection. Accelerated fixtures explicitly disable watchdog.',
 'limits':'Physical root of C11309 FFT stall not proven. Protected vendor BRAM behavior not simulated. Gate/routed INIT and effective enable logic checked separately; STA does not prove HDMI external electrical behavior or board functionality.',
 'operation':'PROGRAM_SRAM JTAG5MHz; DFC11310; default WAV then longKEY1 tone; initial4sec selftest +32sec pages; if still empty record B/C/F2/F3/F4 twice.'}
readme="""# C11310：FFT局部复位与停滞恢复候选（实板待验证）

C11309 已获用户音画及非频谱功能正常反馈，但默认音乐、内置音阶均没有频谱，视频显示 B7000000 / C7840000：FFT完成帧数为0。C11310对FFT内部复位增加两拍同步释放，保留五位状态编码及异常状态恢复，并在4096个输入采样脉冲仍无完整帧时只重启FFT。具体板上停滞原因尚未证实。

## 下载与观察

BitWriter使用 PROGRAM_SRAM、JTAG 5MHz，加载 spectrum_fft_recover.bit。D页应为 DFC11310。保留当前TF卡、接线和拨码，无需重新装素材。先看默认音乐频谱，再长按KEY1看内置音阶频谱；同时确认声音和图片仍正常。包内 spectrum_clock_route.bit 为已获音画正常反馈的C11309回退（频谱空），bmp_scale.bit 为C11206完整成功基线。

数码管启动4秒自检，之后每页2秒、完整轮转32秒。如频谱仍为空，分别在两音源录至少36秒数码管，覆盖B/C/F2/F3/F4；尽可能录两轮看变化，直接提供视频路径。

- B页：原采样校验flags + FFT完成帧数（后六位十六进制）；应持续增长。
- C页：原频谱阶段flags/最大幅值；前台空commit不代表FFT帧完成。
- F2页：后六位为 {state5位,捕获计数10位,窗索引低9位}，由程序解码即可；0捕获，1..3加窗，4..10/14..16蝶形，11..12扫描，13发送，17..31异常值。
- F3页：F3 00 RR SS，RR为局部超时恢复次数，SS为音源变化脉冲数；各8位FF饱和。默认稳定播放时SS不应连续增长，切换音源会增长。
- F4页：后六位为FFT实际接受的采样累计数，24位饱和；切换音源清零，局部超时不清累计数。

## 本地验证范围

312个合成频段、48个真实WAV频段、72个集成频段对独立定点模型零误差，650个独立RGB采样及遥测/状态页通过。单独恢复模型保留生产4096阈值与521clk采样节奏，覆盖非对齐复位释放、所有非法状态、停滞注入后恢复及计数饱和。快速数学/渲染/集成夹具关闭看门狗，只用于加速；不充当生产看门狗证明。

同源TD综合、布线、nativehold和位流生成；时钟及ROM INIT审计绑定最终网表。原参数逐字审计发现SIG/INV不同并保留原始FAIL，另以控制网真值穷举证明有效启用逻辑一致。模型使用行为ROM，未仿真厂商受保护BRAM或测量板上电气。原HDMI时钟、PLL参数、TF/BMP/音频生产链路字节继承C11309。尚未下载板卡、写TF或固化Flash，实板结果待验证。
"""
delivery=p/'build/delivery'
delivery.mkdir(exist_ok=False)
for folder in ('download','deliverables'):
    target=root/folder/'spectrum_fft_recover.bit'
    assert not target.exists()
    shutil.copyfile(bit,target)
txt=json.dumps(info,ensure_ascii=False,indent=2)+'\n'
(root/'download/spectrum_fft_recover.info.json').write_text(txt,encoding='utf-8')
(manual/'AC201_player_spectrum_fft_recover.info.json').write_text(txt,encoding='utf-8')
for name in ('spectrum_fft_recover.bit','spectrum_clock_route.bit','bmp_scale.bit'):
    shutil.copyfile(root/'download'/name,delivery/name)
(delivery/'info.json').write_text(txt,encoding='utf-8')
(delivery/'README.md').write_text(readme,encoding='utf-8')
(delivery/'checksums.sha256').write_text(''.join(f'{sha(f)}  {f.name}\n' for f in sorted(delivery.iterdir()) if f.name!='checksums.sha256'),encoding='ascii')
out=root/'deliverables/music_spectrum_fft_recover_20261014.zip'
assert not out.exists()
with zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED) as z:
    for f in sorted(delivery.iterdir()): z.write(f,f.name)
with zipfile.ZipFile(out) as z:
    assert z.testzip() is None
    for f in delivery.iterdir(): assert z.read(f.name)==f.read_bytes()
cp=p/'checkpoints/music_spectrum_fft_recover_20261014_candidate'
assert not cp.exists()
for name in ('src','scripts','sim','build/manual','build/prehold','build/model','build/audit','build/delivery'):
    shutil.copytree(p/name,cp/name,ignore=shutil.ignore_patterns('__pycache__','AC201_tf_hdmi_Runs'))
shutil.copyfile(p/'package_candidate.py',cp/'package_candidate.py')
shutil.copyfile(p/'build/source_diff_final.json',cp/'build/source_diff_final.json')
manifest=[{'path':f.relative_to(cp).as_posix(),'bytes':f.stat().st_size,'sha256':sha(f)} for f in sorted(cp.rglob('*')) if f.is_file()]
(cp/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
for row in manifest:
    f=cp/row['path']
    assert f.stat().st_size==row['bytes']
    bound(f,row['sha256'])
receipt={'createdBeijing':stamp,'status':'LOCAL_CANDIDATE_DELIVERED_BOARD_PENDING','zip':str(out),'zipSha256':sha(out),'bitSha256':sha(bit),'bitBytes':bit.stat().st_size,'checkpoint':str(cp),'files':len(manifest),'manifestSha256':sha(cp/'manifest.json'),'timing':timing,'resource':resource,'parentFrozenFilesVerified':240}
(p/'build/delivery_verified.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps(receipt,indent=2))

