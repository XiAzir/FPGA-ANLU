from pathlib import Path
import hashlib,json,re,shutil,zipfile
from datetime import datetime,timezone,timedelta

p=Path(__file__).resolve().parent
root=p.parents[1]
manual=p/'build/manual'
parent=root/'development/player_music_envelope_phy'
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest().upper()
def readj(f):return json.loads(f.read_text(encoding='utf-8-sig'))
stamp=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
model=readj(p/'build/model/model_result.json')
assert model['status']=='PASS'
for bound in model['bound_sources'].values():
    model_file=root/bound['path']
    if not model_file.exists():model_file=p/bound['path']
    assert sha(model_file)==bound['sha256'].upper(),f"Stale model input: {bound['path']}"
rom_audit=readj(p/'build/audit/spectrum_rom_init_audit.json')
assert rom_audit['all_match'] and all(r['mismatches']==0 for r in rom_audit['coefficient_roms'])
assert sha(manual/'AC201_tf_hdmi_gate.v')==rom_audit['gate_verilog_sha256'].upper()
stages={}
for stage in ('synthesis','physical','hold','bitstream'):
    ptr=readj(manual/f'stage_evidence/latest_{stage}.json')
    e=readj(manual/'stage_evidence'/ptr['record'])
    assert e['status']=='success' and e['runId']==ptr['runId']
    stages[stage]=e
for s in ('physical','hold','bitstream'):
    assert stages[s]['synthesisRunId']==stages['synthesis']['runId']
    assert stages[s]['scopeHash']==stages['synthesis']['scopeHash']
    assert stages[s]['scriptHash']==stages['synthesis']['scriptHash']
for name,expected in stages['hold']['artifacts'].items():
    assert sha(manual/name)==expected.upper(),f'Final route changed: {name}'
log=(manual/'synthesis_console.log').read_text(encoding='utf-8',errors='replace')
assert not re.search(r'HDL-5105|SYN-6562',log),'Bad coefficient ROM initialization or ignored BRAM initialization'
timing=re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.',(manual/'AC201_tf_hdmi_phy.ts').read_text())
assert timing
values=[float(x) for x in timing.groups()]
assert min(values)>=0
area=(manual/'AC201_tf_hdmi_phy.area').read_text()
resource={k:int(re.search(r'^#'+label+r'\s+(\d+)',area,re.M).group(1)) for k,label in [('LUT','lut'),('reg','reg'),('LE','le'),('BRAM9K','bram'),('DSP','dsp'),('GCLK','gclk')]}
assert resource['LUT']<=19600 and resource['LE']<=19600 and resource['BRAM9K']<=64 and 1<=resource['DSP']<=29
bit=manual/'AC201_player_spectrum.bit'
assert sha(bit)==stages['bitstream']['bitHash'].upper()
rollback=root/'download/bmp_scale.bit'
assert sha(rollback)=='C60464C0D4396D316DB7622E4CB0B70B5DE12C25148AFE234AC7C795C818625D'
assert sha(root/'download/music_envelope_phy.bit')=='1D0BD4198379E924EA59D8F62E940612AA3DFE0034C858C219F0ED77F6FE803F'
assert sha(root/'deliverables/music_envelope_phy_20261013.zip')=='3F5CEC3DADECD4680111941F7F8A8E4D041BB3C5B1D6F58071CD199458CACABA'
diff=[];inherited=[];added=[]
for f in (p/'src/user_source').rglob('*'):
    if f.is_file():
        rel=f.relative_to(p/'src');pf=parent/'src'/rel
        item={'path':rel.as_posix(),'sha256':sha(f),'parentSha256':sha(pf) if pf.exists() else None}
        if not pf.exists():added.append(item)
        elif item['sha256']==item['parentSha256']:inherited.append(item)
        else:diff.append(item)
assert {d['path'] for d in diff}=={'user_source/hdl_source/player_pcm_waveform.v','user_source/hdl_source/top_tf_hdmi_audio.v','user_source/hdl_source/player_status_monitor.v'}
for name in ('hdmi_phy_warpper.v','lane_lvds_10_1.v'):
    assert sha(p/'src/user_source/hdl_source'/name)==sha(parent/'src/user_source/hdl_source'/name)
for f in (parent/'src/td_project/al_ip').rglob('*'):
    if f.is_file():assert sha(f)==sha(p/'src/td_project/al_ip'/f.relative_to(parent/'src/td_project/al_ip'))
info={'version':'C11304','kind':'PCM_1024_HANN_FFT_24_BAND_SPECTRUM','createdBeijing':stamp,
      'boardStatus':'PENDING_BOARD_VALIDATION','parent':'C11303 PHY candidate; not certified as full board baseline',
      'successfulBaseline':'C11206 bmp_scale.bit','bitSha256':sha(bit),'bitBytes':bit.stat().st_size,
      'resource':resource,'timing':dict(zip(['SWNSns','STNSns','HWNSns','HTNSns'],values)),
      'stageRunIds':{k:v['runId'] for k,v in stages.items()},'scopeHash':stages['synthesis']['scopeHash'],
      'scriptHash':stages['synthesis']['scriptHash'],'modelResult':model,
      'gateInitialization':'eram_init on; all Hann and twiddle gate INIT words verified',
      'overlay':{'panel':[16,304,624,432],'plot':[128,330,512,415],'bands':24,'pitch':16,'bodyWidth':12,
                 'heightRows':84,'peakHoldFrames':10,'updateCycles':49,'targets':'64x7 ping-pong BRAM'},
      'changed':diff,'added':added,'inheritedUserFiles':len(inherited),'gateRomAudit':rom_audit,
      'algorithm':{'samples':1024,'sampleRateHz':48000,'binHz':46.875,'window':'symmetric Hann Q15',
                   'proxy':'max per band of max(abs(real),abs(imag)); not power/PSD',
                   'binEdges':[1,2,3,4,5,6,7,9,11,14,18,23,29,37,47,60,76,97,124,158,201,256,326,415,513]},
      'limits':['No local JTAG/TF/Flash or board test','HDMI external output delay and receiver eye are not measured',
                'Frequency magnitudes are approximate; per-stage FFT quantization and peak aggregation',
                'Capture/analysis alternate in observer branch; audio playback is not backpressured',
                'Visual timing is initial tuning and awaits music/tone board feedback','Long-term/repeated startup pending']}
txt=json.dumps(info,ensure_ascii=False,indent=2)+'\n'
readme=f'''# C11304 真实音乐频谱柱候选（实板待验证）

从实际播放PCM计算1024点Hann窗FFT，显示24频段幅值柱。深色底/青色柱、快速抬升/缓慢回落、顶部峰值保持；频谱从左低频到右高频。柱高采用对数映射，非功率谱。显示扩大为128行面板；图片主体、现有字幕和参数功能继续集成。

解压到连接板卡电脑的纯英文目录。BitWriter Add spectrum.bit → PROGRAM_SRAM /5MHz → Run，确认下载成功；D页须显示 DFC11304。维持现有TF卡、供电、HDMI和音量。

1. 默认WAV音乐：画面/字幕应清楚、声音连续；观察鼓点和旋律对应频谱变化及峰值回落。
2. 长按KEY1约2秒：切内部音阶，柱峰应随音调改变位置；再次长按回音乐。切源时频谱清空后重建。
3. 双键短按并松开测试HOLD/恢复：HOLD冻结柱和峰值，声音继续播放；恢复后显示最新音频。
4. 顺手核对图片切换/轮播、亮度对比度、OSD和多尺寸图片。异常用包内bmp_scale.bit(C11206)回退。

本地独立算法/像素/控制模型和最终原约束时序通过；setup {values[0]:+.3f}ns、hold {values[2]:+.3f}ns，TNS0。实板声音、显示、观感与长期稳定性仍待确认。

位流SHA256：{sha(bit)}
回退SHA256：{sha(rollback)}
'''
delivery=p/'build/delivery';delivery.mkdir(exist_ok=True)
for folder in ('download','deliverables'):shutil.copyfile(bit,root/folder/'spectrum.bit')
(root/'download/spectrum.info.json').write_text(txt,encoding='utf-8')
(manual/'AC201_player_spectrum.info.json').write_text(txt,encoding='utf-8')
shutil.copyfile(bit,delivery/'spectrum.bit');shutil.copyfile(rollback,delivery/'bmp_scale.bit')
(delivery/'spectrum.info.json').write_text(txt,encoding='utf-8')
(delivery/'README.md').write_text(readme,encoding='utf-8')
shutil.copyfile(p/'build/model/model_result.json',delivery/'model_result.json')
(delivery/'checksums.sha256').write_text(''.join(f'{sha(f)}  {f.name}\n' for f in sorted(delivery.iterdir()) if f.name!='checksums.sha256'),encoding='ascii')
out=root/'deliverables/music_spectrum_20261013.zip'
assert not out.exists(),'Do not replace a published ZIP'
with zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED) as z:
    for f in sorted(delivery.iterdir()):z.write(f,f.name)
with zipfile.ZipFile(out) as z:
    assert z.testzip() is None
    for f in delivery.iterdir():assert z.read(f.name)==f.read_bytes()
(p/'build/source_diff_final.json').write_text(json.dumps({'parent':'C11303','changed':diff,'added':added,'inherited':inherited},indent=2)+'\n',encoding='utf-8')
checkpoint=p/'checkpoints/music_spectrum_20261013_candidate'
assert not checkpoint.exists()
for name in ('src','scripts','sim','build/manual','build/prehold','build/model','build/audit','build/delivery'):
    shutil.copytree(p/name,checkpoint/name,ignore=shutil.ignore_patterns('__pycache__'))
shutil.copyfile(p/'package_candidate.py',checkpoint/'package_candidate.py')
shutil.copyfile(p/'build/source_diff_final.json',checkpoint/'build/source_diff_final.json')
manifest=[{'path':f.relative_to(checkpoint).as_posix(),'bytes':f.stat().st_size,'sha256':sha(f)} for f in sorted(checkpoint.rglob('*')) if f.is_file()]
(checkpoint/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
for item in manifest:
    f=checkpoint/item['path'];assert f.stat().st_size==item['bytes'] and sha(f)==item['sha256']
receipt={'createdBeijing':stamp,'status':'LOCAL_DELIVERY_VERIFIED_BOARD_PENDING','zip':str(out),'zipSha256':sha(out),
         'bitSha256':sha(bit),'checkpoint':str(checkpoint),'checkpointFiles':len(manifest),
         'manifestSha256':sha(checkpoint/'manifest.json'),'resource':resource,'timing':info['timing']}
(p/'build/delivery_verified.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps(receipt,indent=2))
