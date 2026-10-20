from pathlib import Path
from datetime import datetime, timezone, timedelta
import hashlib, json, re, shutil, zipfile

p=Path(__file__).resolve().parents[1]
root=p.parents[1]
out=p/'build/manual';model=p/'build/model'
parent=root/'development/player_bmp_scale/checkpoints/bmp_scale_20261012_verified'
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
topic=docs/'专题记录/音频可视化/波形清晰度优化_20261013'
cp=p/'checkpoints/waveform_fine_20261013_candidate'
zp=root/'deliverables/waveform_fine_20261013.zip'
delivery=p/'build/delivery'
now=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
def sha(f):return hashlib.sha256(Path(f).read_bytes()).hexdigest().upper()
def load(f):return json.loads(Path(f).read_text(encoding='utf-8-sig'))
def save(f,v):Path(f).write_text(json.dumps(v,ensure_ascii=False,indent=2),encoding='utf-8')
assert not cp.exists() and not zp.exists() and not delivery.exists()
assert not (root/'download/waveform_fine.bit').exists()
def check_parent():
    assert sha(parent/'manifest.json')=='71F87A4B82F974092F63102E0D7522B6C5577BD367B6789C6AD0DDDA37A76FB7'
    entries=load(parent/'manifest.json');assert len(entries)==268
    for e in entries:assert sha(parent/e['path'])==e['sha256'],e['path']
    old=root/'development/player_bmp_scale/checkpoints/bmp_scale_20261012_candidate'
    assert sha(old/'manifest.json')=='6082AB5E2A40CE8DD6FD73265CF59CECB35B35B883DD6466BB839CE68A1B1A9D'
    for e in load(old/'manifest.json'):assert sha(old/e['path'])==e['sha256']
    assert sha(root/'deliverables/bmp_scale_20261012.zip')=='9371A293616AAF37FD72E2DFD9466616FADD7BCB583E06FC84357146B2D380D5'
    assert sha(root/'download/bmp_scale.bit')=='C60464C0D4396D316DB7622E4CB0B70B5DE12C25148AFE234AC7C795C818625D'
check_parent()
stages={}
for name in ['synthesis','physical','bitstream']:
    pointer=load(out/'stage_evidence'/('latest_'+name+'.json'))
    ev=load(out/'stage_evidence'/pointer['record'])
    assert pointer['status']==ev['status']=='success' and pointer['runId']==ev['runId']
    stages[name]=ev
syn=stages['synthesis'];bs=stages['bitstream'];route=stages[bs['routeStage']]
assert sha(out/'AC201_tf_hdmi_gate.db')==syn['gateDbHash'].upper()
for name,ev in stages.items():
    assert ev['scopeHash']==syn['scopeHash'] and ev['scriptHash']==syn['scriptHash']
    if name!='synthesis':assert ev['synthesisRunId']==syn['runId'] and ev['gateDbHash']==syn['gateDbHash']
for name,h in route['artifacts'].items():assert sha(out/name)==h.upper()
for e in bs['scripts']:assert sha(p/'scripts'/e['path'])==e['sha256'].upper()
for e in load(out/'build_source_scope.json'):assert sha(p/'src'/e['path'])==e['sha256'].upper()
bit=out/'AC201_player_waveform_fine.bit'
assert bit.stat().st_size==629624 and sha(bit)==bs['bitHash'].upper()
timing=[float(v) for v in re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.',(out/'AC201_tf_hdmi_phy.ts').read_text()).groups()]
assert min(timing)>=0
coverage=float(re.search(r'STA coverage\s*:\s*([\d.]+)%',(out/'AC201_tf_hdmi_pr.timing').read_text()).group(1))
area=(out/'AC201_tf_hdmi_phy.area').read_text()
resources={k:int(re.search(r'^\s*#'+field+r'\s+(\d+)',area,re.M).group(1)) for k,field in [('LUT','lut'),('reg','reg'),('LE','le'),('BRAM9K','bram9k'),('DSP','dsp'),('GCLK','gclk')]}
assert resources['BRAM9K']<=32 and resources['DSP']==8
gate=(out/'AC201_tf_hdmi_gate.v').read_text(encoding='utf-8-sig')
blocks=[gate[m.start():gate.find(');',m.start())+2] for m in re.finditer(r'EG_PHY_BRAM #\(',gate)]
wave=[s for s in blocks if '\\u_pcm_waveform/ramread0_syn_' in s]
pcm=[s for s in blocks if '\\u_wav_player/ramread1_syn_' in s]
assert len(wave)==2 and len(pcm)==4
(p/'build/audit/bram_mapping_excerpt.txt').write_text('Gate SHA256 '+sha(out/'AC201_tf_hdmi_gate.v')+'\nWave2 PCM4\n\n'+'\n\n'.join(wave+pcm),encoding='utf-8')
audit={'unchanged':[],'changed':[],'new':[],'sourceHashes':{}}
for sub in ['user_source','td_project/al_ip']:
    for f in sorted((p/'src'/sub).rglob('*')):
        if not f.is_file():continue
        rel=f.relative_to(p/'src').as_posix();old=parent/'src'/rel
        audit['sourceHashes'][rel]=sha(f)
        audit['new' if not old.exists() else 'unchanged' if sha(f)==sha(old) else 'changed'].append(rel)
assert audit['new']==[]
assert set(audit['changed'])=={'user_source/hdl_source/player_pcm_waveform.v','user_source/hdl_source/player_status_monitor.v','user_source/hdl_source/top_tf_hdmi_audio.v'}
for name in ['player_status_monitor.v','top_tf_hdmi_audio.v']:
    rel='user_source/hdl_source/'+name
    a=(parent/'src'/rel).read_text(encoding='utf-8-sig').replace('C11206','C11301')
    assert (p/'src'/rel).read_text(encoding='utf-8-sig')==a
save(p/'build/audit/source_diff.json',audit)
fine=load(model/'wave_fine_sources.json')
assert fine['result']=='PASS'
assert sha(root/fine['rtl_path'])==fine['rtl_sha256'].upper()
assert sha(root/fine['testbench_path'])==fine['testbench_sha256'].upper()
logs={'wave_fine_sim.log':'MODEL PASS checks=30229 samples=1024','keyfreeze_wave.log':'KEYFREEZE PASS checks=3123','integration.log':'PASS full integration:'}
for n,mark in logs.items():
    txt=(model/n).read_text(encoding='utf-8-sig');assert mark in txt and 'FAIL' not in txt and 'FATAL' not in txt
review=p/'build/audit/waveform_fine_review.md'
assert sha(p/'src/user_source/hdl_source/player_pcm_waveform.v') in review.read_text(encoding='utf-8-sig').upper()
models={n:sha(model/n) for n in logs}
info={'version':'C11301','kind':'PCM_WAVEFORM_512_COLUMNS_Q2_EDGES','boardStatus':'PENDING_BOARD_VALIDATION','createdBeijing':now,
      'parentVersion':'C11206','successfulBaseline':'C11206 bmp_scale.bit','sourceProject':str(p),'canonicalBit':str(bit),
      'deliveryBitName':'waveform_fine.bit','bitSha256':sha(bit),'bitBytes':bit.stat().st_size,
      'rollbackBitName':'bmp_scale.bit','rollbackSha256':sha(root/'download/bmp_scale.bit'),
      'scopeHash':bs['scopeHash'],'scriptHash':bs['scriptHash'],'stageRunIds':{k:v['runId'] for k,v in stages.items()},
      'timing':dict(zip(['SWNSns','STNSns','HWNSns','HTNSns'],timing)),'timingCoveragePercent':coverage,'resource':resources,
      'holdFixPerformed':False,'waveform':{'columns':512,'samplesPerColumn':2,'windowSamples':1024,'physicalRows':57,'amplitudeSubpixels':4,'unchangedDisplayGain':True,'waveBRAM9K':len(wave),'pcmBRAM9K':len(pcm)},
      'modelLogs':models,'sourceDiff':str(p/'build/audit/source_diff.json'),'unchangedSourceCount':len(audit['unchanged']),
      'changedSources':audit['changed'],'reviewSha256':sha(review),'checkpoint':str(cp),
      'knownIssues':['Dynamic double trace vanishes under HOLD; unique root cause not confirmed','Same 57 physical waveform rows; subpixel edge brightness is a rendering enhancement','Large signal steps draw a vertical joining segment in one pixel column'],
      'limitations':'RTL gold/static audit/original-constraint TD evidence only; encrypted HDMI/SDRAM, physical TF, reception, visual clarity, sound and long-run board behavior pending. Default 2.5M-edge stale threshold tested via shortened parametric instance.',
      'hardwareActions':'No local JTAG, TF or Flash operations. Existing C11206 BMP and TEST.WAV remain the test media.'}
save(out/'AC201_player_waveform_fine.info.json',info)
readme='''# C11301 波形清晰度候选（实板待验证）

新版横向512列（原128组×4像素），加入相邻连线和四档边缘亮度。采样窗口仍1024样本，显示增益、640×480输出及57行图形范围保持；冻结/恢复按键保持。动态双线成因尚未确认，本包不预先宣称修复。

## 下载

TF卡使用现有SCALE1..4.BMP和TEST.WAV，无需修改素材。把压缩包解压到连接板卡的实验室电脑的纯英文路径，例如E:/anlu/bit/wave_fine/。

BitWriter：Add waveform_fine.bit → PROGRAM_SRAM，5MHz → Run。确认Downloading succeeded，等待图片加载。数码管D页应为DFC11301。位流哈希见checksums.sha256和info。

## 本轮观察

1. 默认天之弱音乐应清晰、四尺寸图片应正确。观察波形是否比原版更细密，是否仍有动态双线。
2. PLAY模式下双键短按并全部松开，显示HOLD。比较静止波形的方块感与边缘；再次双键短按恢复，音频应始终继续。
3. 長按KEY1约2秒后松开，内部音阶应清晰，波形应为方波；重复HOLD/恢复，音源切换应解除HOLD。
4. 顺带确认KEY0切图/上下擦除、KEY1 AUTO、字幕，以及亮度/对比度和双键长按恢复默认正常。

反馈图片、音乐/音阶、冻结/恢复和波形外观；可优先拍一张HOLD图与一张动态照片。无需重录历史数码管视频。普通短按动作在消抖后松开时触发；长按约2秒再松开；组合两键要形成按下重叠。

若出现无信号、异常颜色或杂音，在相同接线/供电/音量下回载同包bmp_scale.bit；当前多尺寸素材可以继续使用。回退数码管D页为DFC11206。保留首次异常现象及下载文件名。

所有板卡操作由用户在相连电脑执行；本包仅SRAM候选，不写Flash。
'''
delivery.mkdir(parents=True)
(delivery/'README.md').write_text(readme,encoding='utf-8')
for src,dst in [(bit,delivery/'waveform_fine.bit'),(out/'AC201_player_waveform_fine.info.json',delivery/'waveform_fine.info.json'),(root/'download/bmp_scale.bit',delivery/'bmp_scale.bit'),(bit,root/'download/waveform_fine.bit'),(out/'AC201_player_waveform_fine.info.json',root/'download/waveform_fine.info.json')]:
    assert not dst.exists();shutil.copy2(src,dst);assert sha(src)==sha(dst)
names=sorted(f.name for f in delivery.iterdir() if f.is_file())
(delivery/'checksums.sha256').write_text(''.join(sha(delivery/n)+'  '+n+'\n' for n in names),encoding='ascii')
names.append('checksums.sha256')
cp.mkdir(parents=True)
files=[p/'README.md']+list((p/'build').glob('*.py'))+[p/'build/waveform_spec.md',p/'build/parent_receipt.json']
files += [f for f in (p/'src/user_source').rglob('*') if f.is_file()]+[p/'src/td_project/AC201_tf_hdmi.al']
files += [f for f in (p/'src/td_project/al_ip').rglob('*') if f.is_file()]+[f for f in (p/'scripts').rglob('*') if f.is_file()]
files += [f for f in (p/'build/audit').rglob('*') if f.is_file()]
files += [f for f in model.iterdir() if f.is_file() and f.suffix in ['.v','.ps1','.py','.hex','.json','.log','.txt']]
files += [f for f in out.rglob('*') if f.is_file() and f.suffix in ['.log','.ts','.timing','.area','.json','.bit','.v']]
files += list(delivery.iterdir())
manifest=[]
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
check_parent()
receipt={'status':'PASS','createdBeijing':now,'boardStatus':info['boardStatus'],'bitSha256':sha(bit),'checkpointFiles':len(manifest),
         'manifestSha256':sha(cp/'manifest.json'),'zip':str(zp),'zipBytes':zp.stat().st_size,'zipSha256':sha(zp),
         'parentVerified268AndCandidate260AndZipUnchanged':True,'unchangedSources':len(audit['unchanged']),'changedSources':len(audit['changed'])}
save(p/'build/delivery_verified.json',receipt)
save(topic/'build_info.json',info);save(topic/'delivery_receipt.json',receipt)
shutil.copy2(delivery/'README.md',topic/'操作卡.md')
message=f'C11301本地候选已封存、实板待验证。512列/Q2边缘/连通，窗口1024样本与物理57行/增益保持；独立gold30229项（29184图形像素）、冻结3123项/144000密集音频事件、音乐与参数字幕两帧768000周期/58368图形像素通过，静态审查完成。原约束setup{timing[0]:+.3f}ns/hold{timing[2]:+.3f}ns/TNS0、coverage{coverage}%；资源{resources}。波形BRAM2/PCM4，{len(audit["unchanged"])}源字节不变、3源变化（waveform及top/status版本ID），无新源。位流SHA{sha(bit)}；ZIP{zp.name} SHA{sha(zp)}；candidate{len(manifest)}项manifestSHA{sha(cp/"manifest.json")}。C11206 verified268/candidate260/ZIP/回退bit逐项不变。动态双线仍已知、物理清晰度/音质/真实卡/长期未验证；未代理JTAG/TF/Flash。'
with (topic/'README.md').open('a',encoding='utf-8') as f:f.write('\n## 本地交付（实板待验证）\n\n'+now+'：'+message+'\n\n下载：[候选与C11206回退压缩包](E:/VSCODE-project/FPGA-ANLU/deliverables/waveform_fine_20261013.zip)。下一步用户按[操作卡](操作卡.md)在实验室电脑下载，TF素材无需变更，确认音画/冻结/清晰度及相关五扩展功能。所有历史模型/构建阶段记录保持时间边界。\n')
state=docs/'当前状态.md';s=state.read_text(encoding='utf-8-sig')
s=re.sub(r'^更新：.*$',f'更新：{now}（北京时间；C11301波形清晰度候选已交付/板测待验证，成功基线C11206）。',s,count=1,flags=re.M)
s=re.sub(r'^- C11301隔离开发已开始：.*$', '- '+message+' [本轮专题](专题记录/音频可视化/波形清晰度优化_20261013/README.md)。',s,count=1,flags=re.M)
s=s.replace('波形清晰度优化已在C11301隔离工程启动，后续','波形清晰度C11301本地候选已交付、实板待验证，后续')
s=s.replace('当前开发：C11301隔离推进波形分辨率/线条清晰度质量优化','当前开发：C11301波形清晰度候选已封存并交付，等待相关实板确认')
state.write_text(s,encoding='utf-8')
with (docs/'工作日志/2026-10-13.md').open('a',encoding='utf-8') as f:f.write('\n### '+now+'｜C11301波形清晰度｜本地候选交付，实板待验证\n\n- 动作/证据：'+message+'\n- 限制：默认stale门限用5周期参数实例核控制，完整2.5M周期本轮未等待；模型不能替代实体音画。\n- 下一步：用户按[操作卡](../专题记录/音频可视化/波形清晰度优化_20261013/操作卡.md)下载候选，当前TF不改，回退为同包bmp_scale.bit。\n')
print(json.dumps(receipt,ensure_ascii=False,indent=2))
