from pathlib import Path
from datetime import datetime,timezone,timedelta
import hashlib,json,re,shutil,zipfile
p=Path(__file__).resolve().parents[1];root=p.parents[1]
out=p/'build/manual';model=p/'build/model'
parent=root/'development/player_waveform_fine/checkpoints/waveform_fine_20261013_candidate'
base=root/'development/player_bmp_scale/checkpoints/bmp_scale_20261012_verified'
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
topic=docs/'专题记录/音频可视化/波形清晰度优化_20261013/C11302包络试验'
cp=p/'checkpoints/music_envelope_20261013_candidate';zp=root/'deliverables/music_envelope_20261013.zip'
delivery=p/'build/delivery'
now=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
def sha(f):return hashlib.sha256(Path(f).read_bytes()).hexdigest().upper()
def load(f):return json.loads(Path(f).read_text(encoding='utf-8-sig'))
def save(f,v):Path(f).write_text(json.dumps(v,ensure_ascii=False,indent=2),encoding='utf-8')
assert not cp.exists() and not zp.exists() and not delivery.exists()
assert not (root/'download/music_envelope.bit').exists()
def protect():
    for folder,h,count in [(parent,'F6F5DA1F9228DF3231EB46CC0113E81894D3E99B412C528F3684BBED8F0EA0EE',175),(base,'71F87A4B82F974092F63102E0D7522B6C5577BD367B6789C6AD0DDDA37A76FB7',268)]:
        assert sha(folder/'manifest.json')==h
        entries=load(folder/'manifest.json');assert len(entries)==count
        for e in entries:assert sha(folder/e['path'])==e['sha256'],e['path']
    assert sha(root/'deliverables/waveform_fine_20261013.zip')=='AB54BB8B8501787EA557E6FFED6934C0C5D3784A95D5CAE0D49DEA19BD48C2C2'
    assert sha(root/'deliverables/bmp_scale_20261012.zip')=='9371A293616AAF37FD72E2DFD9466616FADD7BCB583E06FC84357146B2D380D5'
    assert sha(root/'download/bmp_scale.bit')=='C60464C0D4396D316DB7622E4CB0B70B5DE12C25148AFE234AC7C795C818625D'
    assert sha(root/'download/waveform_fine.bit')=='30C45D0A9B82B9C4F78C5A14A81CEFA13C704AF9C91C34EB4C625974FDAA4B96'
protect()
stages={}
for name in ['synthesis','physical','hold','bitstream']:
    ptrfile=out/'stage_evidence'/('latest_'+name+'.json')
    if name=='hold' and not ptrfile.exists():continue
    pointer=load(ptrfile);ev=load(ptrfile.parent/pointer['record'])
    assert pointer['status']==ev['status']=='success' and pointer['runId']==ev['runId']
    stages[name]=ev
syn=stages['synthesis'];bs=stages['bitstream'];route=stages[bs['routeStage']]
assert sha(out/'AC201_tf_hdmi_gate.db')==syn['gateDbHash'].upper()
for name,ev in stages.items():
    assert ev['scopeHash']==syn['scopeHash'] and ev['scriptHash']==syn['scriptHash']
    if name!='synthesis':assert ev['synthesisRunId']==syn['runId'] and ev['gateDbHash']==syn['gateDbHash']
for n,h in route['artifacts'].items():assert sha(out/n)==h.upper()
for e in bs['scripts']:assert sha(p/'scripts'/e['path'])==e['sha256'].upper()
for e in load(out/'build_source_scope.json'):assert sha(p/'src'/e['path'])==e['sha256'].upper()
bit=out/'AC201_player_music_envelope.bit';assert bit.stat().st_size==629624 and sha(bit)==bs['bitHash'].upper()
timing=[float(v) for v in re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.',(out/'AC201_tf_hdmi_phy.ts').read_text()).groups()]
assert min(timing)>=0
coverage=float(re.search(r'STA coverage\s*:\s*([\d.]+)%',(out/'AC201_tf_hdmi_pr.timing').read_text()).group(1))
area=(out/'AC201_tf_hdmi_phy.area').read_text()
resources={k:int(re.search(r'^\s*#'+field+r'\s+(\d+)',area,re.M).group(1)) for k,field in [('LUT','lut'),('reg','reg'),('LE','le'),('BRAM9K','bram9k'),('DSP','dsp'),('GCLK','gclk')]}
assert resources['BRAM9K']<=32 and resources['DSP']==8
source=p/'src/user_source/hdl_source/player_pcm_waveform.v';sourcehash=sha(source)
assert sourcehash=='8BBD61AD22ADCA31581A8C99E5B57641BCD2C09F22DEEA4FF3A162919E398B30'
prod=model/'envelope_binding_20261013_182739.json';gold=load(prod)
assert gold['status']=='PASS' and gold['compile_exit']==gold['run_exit']==0
assert (gold['avg_samples_per_event'],gold['clk_freq_hz'],gold['valid_rate_hz'],gold['frame_cycles'])==(256,25000000,48000,420000)
for k,e in gold['files'].items():assert sha(e['path'])==e['sha256'],k
raw=(model/'envelope_20261013_182739_model_report.txt').read_text(encoding='utf-8-sig')
for marker in ['status=PASS','frames=128','scanned_graph_pixels=58596','env_errors=0','pixel_errors=0','control_checks=10','control_errors=0']:assert marker in raw
integration=load(model/'integration_receipt.json');assert integration['status']=='PASS'
for n,h in integration['modelHashes'].items():assert sha(model/n)==h
for n,h in integration['sourceHashes'].items():assert sha(p/'src/user_source/hdl_source'/n)==h
assert 'INTEGRATION PASS raster_clocks=1260000 graph_pixels=87552' in (model/'integration.log').read_text(encoding='utf-8-sig')
audit={'unchanged':[],'changed':[],'new':[],'sourceHashes':{}}
for sub in ['user_source','td_project/al_ip']:
    for f in sorted((p/'src'/sub).rglob('*')):
        if not f.is_file():continue
        rel=f.relative_to(p/'src').as_posix();old=parent/'src'/rel
        audit['sourceHashes'][rel]=sha(f)
        audit['new' if not old.exists() else 'unchanged' if sha(f)==sha(old) else 'changed'].append(rel)
assert audit['new']==[] and len(audit['unchanged'])==85
assert set(audit['changed'])=={'user_source/hdl_source/player_pcm_waveform.v','user_source/hdl_source/player_status_monitor.v','user_source/hdl_source/top_tf_hdmi_audio.v'}
for n in ['player_status_monitor.v','top_tf_hdmi_audio.v']:
    rel='user_source/hdl_source/'+n
    assert (p/'src'/rel).read_text(encoding='utf-8-sig')==(parent/'src'/rel).read_text(encoding='utf-8-sig').replace('C11301','C11302')
save(p/'build/audit/source_diff.json',audit)
gate=(out/'AC201_tf_hdmi_gate.v').read_text(encoding='utf-8-sig')
blocks=[gate[m.start():gate.find(');',m.start())+2] for m in re.finditer(r'EG_PHY_BRAM #\(',gate)]
wave=[s for s in blocks if '\\u_pcm_waveform/ramread1_syn_' in s]
pcm=[s for s in blocks if '\\u_wav_player/ramread1_syn_' in s]
assert len(wave)==2 and len(pcm)==4
(p/'build/audit/bram_mapping_excerpt.txt').write_text('gateSHA '+sha(out/'AC201_tf_hdmi_gate.v')+'\nTrace2 PCM4; history is registered-output LUT RAM\n\n'+'\n\n'.join(wave+pcm),encoding='utf-8')
assert sourcehash in (p/'build/audit/final_build_audit.md').read_text(encoding='utf-8-sig').upper()
info={'version':'C11302','kind':'MUSIC_LEVEL_ENVELOPE_CUBIC_Q4_AA','boardStatus':'PENDING_BOARD_VALIDATION','createdBeijing':now,
      'parentVersion':'C11301 visual candidate','successfulBaseline':'C11206 bmp_scale.bit','sourceProject':str(p),
      'canonicalBit':str(bit),'bitBytes':bit.stat().st_size,'bitSha256':sha(bit),'deliveryBitName':'music_envelope.bit',
      'rollbackBitName':'bmp_scale.bit','rollbackSha256':sha(root/'download/bmp_scale.bit'),'comparisonBitName':'waveform_fine.bit','comparisonSha256':sha(root/'download/waveform_fine.bit'),
      'scopeHash':bs['scopeHash'],'scriptHash':bs['scriptHash'],'stageRunIds':{k:v['runId'] for k,v in stages.items()},
      'timing':dict(zip(['SWNSns','STNSns','HWNSns','HTNSns'],timing)),'timingCoveragePercent':coverage,'resource':resources,
      'holdFixPerformed':bs['routeStage']=='hold','productionModelReceipt':str(prod),'productionModelReceiptSha256':sha(prod),
      'integrationReceiptSha256':sha(model/'integration_receipt.json'),'sourceDiffSha256':sha(p/'build/audit/source_diff.json'),
      'display':{'frame':[640,480],'columns':512,'physicalRows':57,'subpixelSteps':16,'historyNodes':128,'nominalHistorySeconds':2.1504,
                 'averageSamples':256,'attackTimeApproxMs':83,'releaseTimeApproxMs':339,'constantAmplitudeToneExpected':'Approximately steady level envelope, not square-wave carrier'},
      'memoryMapping':{'history':'128x16 LUT_RAM with16 clocked read registers; deviation from planned BRAM target','traceBRAM9K':2,'pcmBRAM9K':4,'extraInterpolationDSP':0},
      'models':{'productionFrames':128,'effectiveAudioSamples':103615,'averageWindows':404,'pixelChecks':58596,'controlChecks':10,'integrationRasterClocks':1260000,'integrationGraphPixels':87552,'integrationFrames':3,'musicSnippetSamples':1024,'musicSnippetRepeats':True},
      'knownLimits':['Fixed480p physical grid; smoothing and subpixel coverage do not increase panel pixel count','Old dynamic double trace cause remains unconfirmed; C11302 reception/visual behavior pending','No full FFT spectrum; mean absolute amplitude visualisation','No C11302 board long-run/repeated startup/Flash verification'],
      'evidenceLimits':'Logical models, static/mapping audit and original-constraint TD STA. Does not replace physical TF, encrypted SDRAM/HDMI transport, receiver, actual sound or visual acceptance.',
      'hardwareActions':'No local JTAG, TF write or Flash operation','checkpoint':str(cp)}
save(out/'AC201_player_music_envelope.info.json',info)
readme='''# C11302 音乐强弱包络候选（实板待验证）

曲线显示最近约2.15秒的音乐强弱，响声较快抬升、弱声缓慢回落；128节点插值到512列，16档边缘亮度和低亮光晕减轻锯齿。输出仍640×480。这是音量包络，因此等幅音阶的曲线大致平稳；音调变化不要求出现方波。

## 下载

TF保持现有SCALE1..4.BMP与TEST.WAV，不用换文件或格式化。压缩包解压到连接板卡的实验室电脑纯英文目录，例如E:/anlu/bit/envelope/。

BitWriter Add music_envelope.bit → PROGRAM_SRAM /5MHz → Run。确认Downloading succeeded；D页build ID应为DFC11302。等图片加载和约2秒可视历史填满，再观察。无需写Flash。

## 本轮观察

1. 默认音乐应清晰，四尺寸图片与字幕应正确。观察强弱曲线是否比C11301稳定、线条是否更柔和，是否仍有双线或闪烁。
2. PLAY下双键短按并都松开进入HOLD：曲线停住，音乐继续；再次双键短按恢复。可拍一张HOLD和一张动态照片，便于比较。
3. 长按KEY1约2秒切内部音阶：声音应清晰，曲线表示其稳定音量而不是方波；再次长按回音乐。切源自动解除HOLD，新历史重新填入。
4. 顺带确认KEY0切图/上下擦除、KEY1 AUTO、亮度/对比度以及双键长按默认恢复正常。控制操作与前版相同。

反馈默认音乐/音阶音质、HOLD恢复、曲线速度和锯齿、其余显示按键现象。线条观感尚未实板评估，本包不是已验证版。

异常时在相同TF/供电/HDMI/音量下回载同包bmp_scale.bit（C11206成功整机基线）。waveform_fine.bit是C11301原PCM波形视觉对照，其整机本轮未获完整回归确认。三份bit都支持当前多尺寸素材，回退无需改卡。

envelope_offline_preview.png是主机按真实音乐计算的离线像素参考，不是板上照片，也不证明实际流动/音质。
'''
delivery.mkdir(parents=True)
(delivery/'README.md').write_text(readme,encoding='utf-8')
for src,dst in [(bit,delivery/'music_envelope.bit'),(out/'AC201_player_music_envelope.info.json',delivery/'music_envelope.info.json'),(root/'download/bmp_scale.bit',delivery/'bmp_scale.bit'),(root/'download/waveform_fine.bit',delivery/'waveform_fine.bit'),(model/'envelope_offline_preview.png',delivery/'envelope_offline_preview.png'),(bit,root/'download/music_envelope.bit'),(out/'AC201_player_music_envelope.info.json',root/'download/music_envelope.info.json')]:
    assert not dst.exists();shutil.copy2(src,dst);assert sha(src)==sha(dst)
names=sorted(f.name for f in delivery.iterdir() if f.is_file())
(delivery/'checksums.sha256').write_text(''.join(sha(delivery/n)+'  '+n+'\n' for n in names),encoding='ascii');names.append('checksums.sha256')
(p/'README.md').write_text('# C11302 音乐强弱包络候选\n\n'+readme+'\n\n本地production gold、真实音乐/字幕/参数三帧叠加与源审查通过。最终原约束时序'+str(info['timing'])+'，资源'+str(resources)+'。历史实际为LUT_RAM同步寄存输出，trace2BRAM/PCM4BRAM；插值无额外DSP，规划BRAM历史目标偏差详见build/audit/final_build_audit.md。当前实板pending，成功回退C11206。\n',encoding='utf-8')
cp.mkdir(parents=True)
files=[p/'README.md']+list((p/'build').glob('*.py'))+[p/'build/envelope_spec.md',p/'build/parent_receipt.json']
files += [f for f in (p/'src/user_source').rglob('*') if f.is_file()]+[p/'src/td_project/AC201_tf_hdmi.al']
files += [f for f in (p/'src/td_project/al_ip').rglob('*') if f.is_file()]+[f for f in (p/'scripts').rglob('*') if f.is_file()]
files += [f for f in (p/'build/audit').rglob('*') if f.is_file()]
files += [f for f in model.iterdir() if f.is_file() and f.suffix in ['.v','.ps1','.py','.hex','.json','.log','.txt','.png']]
files += [f for f in out.rglob('*') if f.is_file() and f.suffix in ['.log','.ts','.timing','.area','.json','.bit','.v']]
for sub in ['prehold','initial_dsp_mapping']:
    if (p/'build'/sub).exists():files += [f for f in (p/'build'/sub).rglob('*') if f.is_file() and f.suffix in ['.log','.ts','.timing','.area','.json','.v']]
files += list(delivery.iterdir());manifest=[]
for f in sorted(set(files)):
    rel=f.relative_to(p);target=cp/rel;target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(f,target)
    assert sha(f)==sha(target);manifest.append({'path':rel.as_posix(),'bytes':target.stat().st_size,'sha256':sha(target)})
save(cp/'manifest.json',manifest)
for e in manifest:assert sha(cp/e['path'])==e['sha256']
with zipfile.ZipFile(zp,'w',zipfile.ZIP_DEFLATED) as z:
    for n in sorted(names):z.write(delivery/n,n)
with zipfile.ZipFile(zp) as z:
    assert z.testzip() is None and set(z.namelist())==set(names)
    for n in names:assert hashlib.sha256(z.read(n)).hexdigest().upper()==sha(delivery/n)
protect()
receipt={'status':'PASS','createdBeijing':now,'boardStatus':info['boardStatus'],'bitSha256':sha(bit),'checkpointFiles':len(manifest),
         'manifestSha256':sha(cp/'manifest.json'),'zip':str(zp),'zipBytes':zp.stat().st_size,'zipSha256':sha(zp),
         'parentC11301SnapshotAndZipAndC11206BaselineUnchanged':True,'unchangedSources':85,'changedSources':3}
save(p/'build/delivery_verified.json',receipt);save(topic/'build_info.json',info);save(topic/'delivery_receipt.json',receipt)
shutil.copy2(delivery/'README.md',topic/'操作卡.md')
message=f'C11302音乐强弱包络候选本地完成、实板待验证。当前8BBD61AD源码production128帧/103615有效样本/404平均窗/58596像素/10控制零差异，真实音乐短片循环3帧叠加1260000周期/87552图形像素模型通过。原约束setup{timing[0]:+.3f}ns/hold{timing[2]:+.3f}ns/TNS0 coverage{coverage}%，最终资源{resources}；holdFix={info["holdFixPerformed"]}。旧DSP18及prehold负裕量报告保留；最终DSP8、trace2BRAM/PCM4BRAM，历史LUT_RAM同步读为规划BRAM目标偏差。85源字节不变、3源变化，父C11301与成功C11206及ZIP逐项不变。bitSHA{sha(bit)}，ZIP{zp.name} {zp.stat().st_size}bytes SHA{sha(zp)}，candidate{len(manifest)}项 manifestSHA{sha(cp/"manifest.json")}。无本机JTAG/TF/Flash。观感/音质/真实卡/接收端/长期仍待用户确认，旧动态双线根因未证实。'
with (topic/'README.md').open('a',encoding='utf-8') as f:f.write('\n### '+now+'｜候选交付，实板待验证\n\n'+message+'\n\n[交付ZIP](E:/VSCODE-project/FPGA-ANLU/deliverables/music_envelope_20261013.zip)；按[操作卡](操作卡.md)下载，现卡素材不改。初始失败/中断模型与旧阶段记录保留时间边界。\n')
with (docs/'工作日志/2026-10-13.md').open('a',encoding='utf-8') as f:f.write('\n### '+now+'｜C11302｜本地候选交付，实板待验证\n\n- '+message+'\n- 下一步：用户按[操作卡](../专题记录/音频可视化/波形清晰度优化_20261013/C11302包络试验/操作卡.md)下载新候选，确认两音源/HOLD/曲线速度清晰度及其余功能。\n')
state=docs/'当前状态.md';s=state.read_text(encoding='utf-8-sig')
s=re.sub(r'^更新：.*$',f'更新：{now}（北京时间；C11302候选本地交付，实板pending，成功基线C11206）。',s,count=1,flags=re.M)
s=re.sub(r'^- \*\*C11302已恢复完整候选开发\*\*.*$', '- **C11302音乐包络候选已本地交付、实板待验证**：约2.15秒强弱历史、缓升缓落、Catmull插值512列及16档背景合成边缘。Production128帧/58596像素/10控制和真实音乐字幕参数3帧叠加模型通过；最终setup'+f'{timing[0]:+.3f}ns/hold{timing[2]:+.3f}ns/TNS0，DSP8/BRAM{resources["BRAM9K"]}；候选封存及ZIP核验完成，父基线不变。详细构建与下载见[专题](专题记录/音频可视化/波形清晰度优化_20261013/C11302包络试验/README.md)。TF素材不改，实际音画/观感/双线/长期待用户反馈。',s,count=1,flags=re.M)
s=s.replace('完整验证/构建进行中','本地验证/构建及候选封存完成、实板pending')
state.write_text(s,encoding='utf-8')
print(json.dumps(receipt,ensure_ascii=False,indent=2))
