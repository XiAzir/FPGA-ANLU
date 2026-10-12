from pathlib import Path
import sys

for _anlu_root in Path(__file__).resolve().parents:
    if (_anlu_root / 'scripts' / 'anlu_paths.py').is_file():
        sys.path.insert(0, str(_anlu_root / 'scripts'))
        break
from anlu_paths import DOCS_ROOT, REPOSITORY_ROOT, recorded_path

import hashlib,json,datetime,re,shutil,zipfile
root=REPOSITORY_ROOT
p=root/'development/player_pcm_waveform_keyfreeze'; out=p/'build/manual'; model=p/'build/model'
parent=root/'development/player_pcm_waveform_freeze/checkpoints/waveform_freeze_20261012_candidate'
docs=DOCS_ROOT / '开发记录'; topic=docs/'专题记录/音频可视化/真实PCM波形首版_20261012'
now=datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
def sha(f): return hashlib.sha256(Path(f).read_bytes()).hexdigest().upper()
def load(f): return json.loads(Path(f).read_text(encoding='utf-8-sig'))
def save(f,v): Path(f).write_text(json.dumps(v,ensure_ascii=False,indent=2),encoding='utf-8')
cp=p/'checkpoints/waveform_keyfreeze_20261012_candidate'; zp=root/'deliverables/waveform_keyfreeze_20261012.zip'
assert not cp.exists() and not zp.exists() and not (root/'download/waveform_keyfreeze.bit').exists()
bit=out/'AC201_player_pcm_waveform_keyfreeze.bit'; assert bit.stat().st_size==629624
bh=sha(bit); rollback=root/'download/image_adjust.bit'; dynamic=root/'download/pcm_waveform.bit'
assert sha(rollback)=='5482E8E2D2AE912E47D9EA21F93892559F39AF77C907D025EBDA46AE9994C2FA'
assert sha(dynamic)=='D753D6893AA6C1EB98323C189FC7889A7FBCB96D3C12ECA5966AF515AE397D49'
assert sha(parent/'manifest.json')=='FB9BE10F216026114DB434CEDFAC99545054CF871B1B5BC6C6F8212AC951861B'
for e in load(parent/'manifest.json'): assert sha(parent/e['path'])==e['sha256']
assert sha(root/'deliverables/waveform_freeze_20261012.zip')=='9366E59195283150863B23EEFB91DD304E9F5E3174F38EBE9C06DAABAA96BB8F'
audit=load(model/'parent_source_audit.json')
for rel in audit['unchangedInheritedSources']: assert sha(p/'src'/rel)==sha(parent/'src'/rel)
stages={}
for name in ['synthesis','physical','bitstream']:
    ptr=load(out/'stage_evidence'/('latest_'+name+'.json')); ev=load(out/'stage_evidence'/ptr['record'])
    assert ptr['status']==ev['status']=='success' and ptr['runId']==ev['runId']; stages[name]=ev
if (out/'stage_evidence/latest_hold.json').exists():
    ptr=load(out/'stage_evidence/latest_hold.json'); ev=load(out/'stage_evidence'/ptr['record'])
    assert ptr['status']==ev['status']=='success' and ptr['runId']==ev['runId']; stages['hold']=ev
syn=stages['synthesis']; bs=stages['bitstream']; route=stages[bs['routeStage']]
assert bs['bitHash'].upper()==bh and sha(out/'AC201_tf_hdmi_gate.db')==syn['gateDbHash'].upper()
for name,e in stages.items():
    assert e['scopeHash']==syn['scopeHash'] and e['scriptHash']==syn['scriptHash']
    if name!='synthesis': assert e['synthesisRunId']==syn['runId'] and e['gateDbHash']==syn['gateDbHash']
for name,h in route['artifacts'].items(): assert sha(out/name)==h.upper()
for e in bs['scripts']: assert sha(p/'scripts'/e['path'])==e['sha256'].upper()
for e in load(out/'build_source_scope.json'): assert sha(p/'src'/e['path'])==e['sha256'].upper()
timing=[float(v) for v in re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.',(out/'AC201_tf_hdmi_phy.ts').read_text()).groups()]
assert min(timing)>=0
coverage=float(re.search(r'STA coverage\s*:\s*([\d.]+)%',(out/'AC201_tf_hdmi_pr.timing').read_text()).group(1))
area=(out/'AC201_tf_hdmi_phy.area').read_text()
resources={k:int(re.search(r'^\s*#'+f+r'\s+(\d+)',area,re.M).group(1)) for k,f in [('LUT','lut'),('reg','reg'),('LE','le'),('BRAM9K','bram9k'),('DSP','dsp'),('GCLK','gclk')]}
logs=['player_pcm_waveform_model.log','integration.log','keyfreeze_music.log','keyfreeze_wave.log','tb_player_adjust_control.log','tb_waveform_chord_control.log']
for name in logs:
    t=(model/name).read_text(encoding='utf-8-sig'); assert 'PASS' in t and 'FAIL' not in t and 'FATAL' not in t
gate=(out/'AC201_tf_hdmi_gate.v').read_text(encoding='utf-8-sig'); wb=[]; pb=[]
for m in re.finditer(r'EG_PHY_BRAM #\(',gate):
    b=gate[m.start():gate.find(');',m.start())+2]
    if '\\u_pcm_waveform/ramread0_syn_' in b: wb.append(b)
    if '\\u_wav_player/ramread1_syn_' in b: pb.append(b)
assert len(wb)==1 and len(pb)==4 and 'PDPW8K' in wb[0]
(model/'bram_mapping_excerpt.txt').write_text('Gate SHA256 '+sha(out/'AC201_tf_hdmi_gate.v')+'\nWave1 PDPW8K, audioFIFO4 DP8K.\n\n'+'\n\n'.join(wb+pb),encoding='utf-8')
info={'version':'C11204','kind':'KEY_CONTROLLED_FREEZE_DIAGNOSTIC','boardStatus':'PENDING_DIAGNOSTIC_BOARD_VALIDATION','createdBeijing':now,
 'sourceProject':str(p),'parentVersion':'C11203','successfulBaseline':'C11201 image_adjust.bit','canonicalBit':str(bit),'deliveryBitName':'waveform_keyfreeze.bit','bitBytes':bit.stat().st_size,'bitSha256':bh,
 'rollbackBitName':rollback.name,'rollbackSha256':sha(rollback),'dynamicComparisonBit':dynamic.name,'dynamicComparisonSha256':sha(dynamic),
 'scopeHash':bs['scopeHash'],'scriptHash':bs['scriptHash'],'stageRunIds':{s:e['runId'] for s,e in stages.items()},'timing':dict(zip(['SWNSns','STNSns','HWNSns','HTNSns'],timing)),
 'timingCoveragePercent':coverage,'resource':resources,'holdFixPerformed':bs['routeStage']=='hold','models':{n:sha(model/n) for n in logs},'inheritedSourceAudit':sha(model/'parent_source_audit.json'),
 'freezeGesture':'PLAY: short overlapping KEY0+KEY1 chord, release both; toggles desired freeze state. Chord long restores B/C without toggle; edit modes ignore short chord.',
 'freezeCommit':'VS preserves currently visible front even when a newer back is ready; if no front, first complete capture commits and freezes. Coincident toggle/VS reads old request.',
 'resume':'VS discards partial back and rearms; old front remains until next full capture commits; source change/reset cancels hold/request.',
 'autoFreeze':False,'title':'PCM WAV/TONE X4 while live; HOLD WAV/TONE X4 only after VS frozen_front',
 'observerInput':'Passive same HDMI audio_valid/audio_left_data; no audio feedback/control added','format':'Existing640x480BMP/48kmonoPCM16TEST.WAV; noTFchange',
 'hardwareActions':'No local JTAG, TF writes or Flash programming','checkpoint':str(cp),
 'evidenceLimit':'Diagnostic, not confirmed ghosting fix. RTL models exclude vendor BRAM/HDMI PHY/monitor; compilation changes physical placement. Board validation pending.'}
save(out/'AC201_player_pcm_waveform_keyfreeze.info.json',info)
delivery=p/'build/delivery'; delivery.mkdir(parents=True)
readme='''# C11204 按键冻结波形诊断

新诊断候选，本地模型/正式TD时序通过，实板待验证；非重影修复版。TF不改。
英文路径解压，BitWriter Add waveform_keyfreeze.bit，PROGRAM_SRAM / 5MHz，确认 Downloading succeeded。数码管D页DFC11204。

1. 默认音乐和波形持续动态，不再自动冻结。等出现你要观察的波形/重影。
2. PLAY模式同时短按KEY0+KEY1约0.2~0.5秒，松开两键。标题变为HOLD WAV X4，当前波形固定；声音应照常播放。长按两键约2秒是原恢复B/C默认，不是冻结。
3. HOLD后等5秒，观察有无两条分离青色完整曲线。再同时短按并松开两键，标题回PCM WAV X4、恢复刷新。冻结/恢复可以反复使用。灰色中心线不算第二条曲线。
4. PLAY长按KEY1约2秒切内部音阶，同时解除冻结。等方波显示后，再用双键短按冻结，出现HOLD TONE X4后等5秒观察；再次双短恢复。音乐/音阶均应清晰连续。
5. KEY0切图、KEY1轮播、KEY0长切PLAY/BRI/CON与原参数调节保持。冻结双短只在PLAY生效；参数栏若BRI/CON，长KEY0循环回PLAY后再按双键。不要将两键依次单按（没有稳定重叠）当组合键。

反馈动态与HOLD WAV/TONE各单双线、HOLD是否确实静止、恢复是否刷新、两音源是否清晰；冻结后双线仍在时拍一张带HOLD标题的照片。
静态干净只支持动态因素，不能唯一证明显示器原因；实物RAM/绘制/输出或物理布局仍需按证据判断。

image_adjust.bit=C11201已反馈全功能正常的成功回退，音画异常同条件回载。pcm_waveform.bit=C11202原动态比较（已报告肉眼重影），不是成功回退。本包不写Flash。
'''
(delivery/'README.md').write_text(readme,encoding='utf-8')
(p/'README.md').write_text((p/'README.md').read_text(encoding='utf-8')+'\n最终本地模型/TD时序通过，实板待验证。'+json.dumps(info['timing'])+' coverage'+str(coverage)+'%；资源'+json.dumps(resources)+'；SHA '+bh+'。\n',encoding='utf-8')
for src,dst in [(bit,root/'download/waveform_keyfreeze.bit'),(out/'AC201_player_pcm_waveform_keyfreeze.info.json',root/'download/waveform_keyfreeze.info.json'),(bit,delivery/'waveform_keyfreeze.bit'),(out/'AC201_player_pcm_waveform_keyfreeze.info.json',delivery/'waveform_keyfreeze.info.json'),(rollback,delivery/rollback.name),(dynamic,delivery/dynamic.name)]:
    assert not dst.exists(); shutil.copy2(src,dst); assert sha(src)==sha(dst)
names=['README.md','waveform_keyfreeze.bit','waveform_keyfreeze.info.json',rollback.name,dynamic.name]
(delivery/'checksums.sha256').write_text(''.join(sha(delivery/n)+'  '+n+'\n' for n in sorted(names)),encoding='ascii'); names.append('checksums.sha256')
cp.mkdir(parents=True)
files=[p/'README.md',p/'build/init_project.py',p/'build/prepare_evidence.py',Path(__file__),delivery/'README.md']
files+=[f for f in (p/'src/user_source').rglob('*') if f.is_file()]+[p/'src/td_project/AC201_tf_hdmi.al']
files+=[f for f in (p/'src/td_project/al_ip').rglob('*') if f.is_file()]+[f for f in (p/'scripts').rglob('*') if f.is_file()]
files+=[f for f in model.rglob('*') if f.is_file() and f.suffix!='.vvp']
files+=[f for f in out.rglob('*') if f.is_file() and f.suffix in ['.log','.ts','.timing','.area','.json','.bit']]
if (p/'build/prehold').exists(): files+=[f for f in (p/'build/prehold').rglob('*') if f.is_file() and f.suffix!='.db']
manifest=[]
for src in sorted(set(files)):
    rel=src.relative_to(p); dst=cp/rel; dst.parent.mkdir(parents=True,exist_ok=True); shutil.copy2(src,dst)
    assert sha(src)==sha(dst); manifest.append({'path':rel.as_posix(),'bytes':dst.stat().st_size,'sha256':sha(dst)})
save(cp/'manifest.json',manifest)
for e in manifest: assert sha(cp/e['path'])==e['sha256']
with zipfile.ZipFile(zp,'w',zipfile.ZIP_DEFLATED) as z:
    for n in sorted(names): z.write(delivery/n,n)
with zipfile.ZipFile(zp) as z:
    assert z.testzip() is None and set(z.namelist())==set(names)
    for n in names: assert hashlib.sha256(z.read(n)).hexdigest().upper()==sha(delivery/n)
receipt={'createdBeijing':now,'bitSha256':bh,'checkpointFiles':len(manifest),'manifestSha256':sha(cp/'manifest.json'),'zip':str(zp),'zipBytes':zp.stat().st_size,'zipSha256':sha(zp),'boardStatus':info['boardStatus'],'parentCandidateAndZipUnchanged':True}
save(p/'build/delivery_verified.json',receipt); save(topic/'keyfreeze_build_info.json',info); save(topic/'keyfreeze_receipt.json',receipt)
message=f'{now} C11204按键冻结诊断本地完成、实板待验证。PLAY双键短按松开冻结/恢复当前front，VS提交；取消自动三秒冻结，长双键复B/C默认、长KEY1换源解除冻结。模型unit303、control38+chord11、wave819及动态/冻结真实音乐全512列两帧通过，根代理重跑；TD三阶段/原约束时序 {info["timing"]}，coverage{coverage}%，holdFix={info["holdFixPerformed"]}，源/脚本/DB/报告/bit绑定与ZIP校验通过。download/waveform_keyfreeze.bit SHA {bh}。ZIP {zp} / {receipt["zipBytes"]}bytes / SHA {receipt["zipSha256"]}，{len(manifest)}文件checkpoint manifest {receipt["manifestSha256"]}。父143文件/ZIP不改，成功基线C11201，非重影修复。未JTAG/TF/Flash。'
(topic/'README.md').write_text((topic/'README.md').read_text(encoding='utf-8')+'\n\n## '+now+'｜C11204按键冻结诊断交付，实板待验证\n\n'+message+'\n\n79源不变，改变wave手动请求/VS保持与controls短组合脉冲和topwire/BUILD_ID、状态BUILD_ID；音频/FIFO/FAT/SDRAM/PHY/PLL/约束不改，实际重布局。波形1PDPW8K、PCM4DP8K。专项wave用缩放SAMPLES1/stale，另默认144000密集事件无自动冻结；真实音乐集成用SAMPLES8/520-521间隔1024输入、两帧全图冻结保持与其它OSD/亮度/滚动像素核验，冻结后密集极值pressure不是实板48k测量。\n\n下一步用户下载waveform_keyfreeze.bit，出现重影时PLAY双短冻结看HOLD等5秒、再双短恢复，并长KEY1换tone后同样冻结/恢复；反馈单双线/是否静止/两源音质。音画异常同条件image_adjust回退。静态干净不能唯一证明显示器，根因仍待确认。详见新工程build/delivery/README.md及build/model两份review。\n',encoding='utf-8')
state=docs/'当前状态.md'; text=state.read_text(encoding='utf-8'); text=re.sub(r'^更新：.*$',f'更新：{now}（北京时间；XiAzir；C11204按键冻结交付、实板待验证；成功基线C11201）。',text,count=1,flags=re.M)
text=text.replace('## 当前阶段','## 当前阶段\n\n**'+message+' 下一步用户双键短按抓取重影HOLD WAV/TONE各等5秒，检查恢复刷新与音质；根因未确认。[专题与操作](专题记录/音频可视化/真实PCM波形首版_20261012/README.md)。**',1); state.write_text(text,encoding='utf-8')
log=docs/'工作日志/2026-10-12.md'; log.write_text(log.read_text(encoding='utf-8')+'\n### '+now+'｜C11204按键冻结交付｜本地完成、实板待验证\n\n- '+message+'\n- 资源 '+json.dumps(resources)+'，1wave/4PCM BRAM。模型不含实际BRAM/HDMI核/PHY/显示器；静态结果不能唯一判断根因。\n- 下一步用户双短HOLD WAV/TONE等5秒看单双线，双短恢复，原按键/参数与音质回归；失败回载image_adjust，TF不改。[证据](../专题记录/音频可视化/真实PCM波形首版_20261012/README.md)。\n',encoding='utf-8')
print(json.dumps(receipt,ensure_ascii=True,indent=2))
