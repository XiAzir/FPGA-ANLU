from pathlib import Path
import hashlib,json,datetime,re,shutil,zipfile
root=Path('E:/VSCODE-project/FPGA-ANLU');p=root/'development/player_transition_wipe'
out=p/'build/manual';model=p/'build/model'
parent=root/'development/player_pcm_waveform_keyfreeze/checkpoints/waveform_keyfreeze_20261012_verified'
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录');topic=docs/'专题记录/图片转场/上下擦除首版_20261012'
now=datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
def sha(f): return hashlib.sha256(Path(f).read_bytes()).hexdigest().upper()
def load(f): return json.loads(Path(f).read_text(encoding='utf-8-sig'))
def save(f,v): Path(f).write_text(json.dumps(v,ensure_ascii=False,indent=2),encoding='utf-8')
cp=p/'checkpoints/transition_wipe_20261012_candidate';zp=root/'deliverables/transition_wipe_20261012.zip'
assert not cp.exists() and not zp.exists() and not (root/'download/transition_wipe.bit').exists()
bit=out/'AC201_player_transition_wipe.bit';assert bit.stat().st_size==629624
bh=sha(bit);rollback=root/'download/waveform_keyfreeze.bit'
assert sha(rollback)=='A16326B8266ED6CB52CE27E163B89DC1C2B37551B393AE5F1116BA16C6F54790'
assert sha(parent/'manifest.json')=='384BCED087F68A0DE5380816F1B0700E6194C8B22D1219FB318DE511D2B1BC36'
pm=load(parent/'manifest.json');assert len(pm)==158
for e in pm: assert sha(parent/e['path'])==e['sha256']
oldcp=root/'development/player_pcm_waveform_keyfreeze/checkpoints/waveform_keyfreeze_20261012_candidate'
assert sha(oldcp/'manifest.json')=='3F1C818A7B23D509BEE072430A20F65BA8F7E70548541D79B28E6AFB2CB7A420'
for e in load(oldcp/'manifest.json'):assert sha(oldcp/e['path'])==e['sha256']
assert sha(root/'deliverables/waveform_keyfreeze_20261012.zip')=='4A297394A026851C2D6C74F03602D950C679DD3FAD6C2B43E194827108FA3C5D'
audit=load(model/'parent_source_audit.json');assert len(audit['unchangedInheritedSources'])==78
for rel in audit['unchangedInheritedSources']:assert sha(p/'src'/rel)==sha(parent/'src'/rel)
assert len(audit['changedSources'])==5 and len(audit['newSources'])==1
# Review was read-only and is bound to the five source hashes it analyzed.
review=(p/'build/audit/integration_review.md').read_text(encoding='utf-8-sig')
for name in ['player_wipe_address.v','frame_buffer_rgb888.v','top_tf_hdmi_audio.v','player_osd_state.v','tf_bmp_file_player.v']:
    assert sha(p/'src/user_source/hdl_source'/name) in review
stages={}
for name in ['synthesis','physical','bitstream']:
    ptr=load(out/'stage_evidence'/('latest_'+name+'.json'));ev=load(out/'stage_evidence'/ptr['record'])
    assert ptr['status']==ev['status']=='success' and ptr['runId']==ev['runId'];stages[name]=ev
if (out/'stage_evidence/latest_hold.json').exists():
    ptr=load(out/'stage_evidence/latest_hold.json');ev=load(out/'stage_evidence'/ptr['record'])
    assert ptr['status']==ev['status']=='success' and ptr['runId']==ev['runId'];stages['hold']=ev
syn=stages['synthesis'];bs=stages['bitstream'];route=stages[bs['routeStage']]
assert bs['bitHash'].upper()==bh and sha(out/'AC201_tf_hdmi_gate.db')==syn['gateDbHash'].upper()
for name,e in stages.items():
    assert e['scopeHash']==syn['scopeHash'] and e['scriptHash']==syn['scriptHash']
    if name!='synthesis':assert e['synthesisRunId']==syn['runId'] and e['gateDbHash']==syn['gateDbHash']
for name,h in route['artifacts'].items():assert sha(out/name)==h.upper()
for e in bs['scripts']:assert sha(p/'scripts'/e['path'])==e['sha256'].upper()
for e in load(out/'build_source_scope.json'):assert sha(p/'src'/e['path'])==e['sha256'].upper()
timing=[float(v) for v in re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.',(out/'AC201_tf_hdmi_phy.ts').read_text()).groups()]
assert min(timing)>=0
coverage=float(re.search(r'STA coverage\s*:\s*([\d.]+)%',(out/'AC201_tf_hdmi_pr.timing').read_text()).group(1))
area=(out/'AC201_tf_hdmi_phy.area').read_text()
resources={k:int(re.search(r'^\s*#'+f+r'\s+(\d+)',area,re.M).group(1)) for k,f in [('LUT','lut'),('reg','reg'),('LE','le'),('BRAM9K','bram9k'),('DSP','dsp'),('GCLK','gclk')]}
logs=['wipe_address.log','wipe_rgb888.log','tb_display_ownership.log','wipe_backend.log']
markers={'wipe_address.log':'WIPE_ADDRESS PASS','wipe_rgb888.log':'WIPE_RGB888 PASS','tb_display_ownership.log':'PASS tb_display_ownership','wipe_backend.log':'WIPE_BACKEND PASS'}
for name in logs:
    t=(model/name).read_text(encoding='utf-8-sig');assert markers[name] in t and 'FAIL' not in t and 'FATAL' not in t
assert 'pixels=1228800' in (model/'wipe_rgb888.log').read_text()
backend=(model/'wipe_backend.log').read_text(encoding='utf-8-sig')
assert 'production_frames=121' in backend and 'direction_changes=2' in backend and 'release_toggles=3' in backend
assert 'PENDING_BURST PASS' in backend and (model/'wipe_backend_review.md').is_file()
gate=(out/'AC201_tf_hdmi_gate.v').read_text(encoding='utf-8-sig');wb=[];pb=[]
for m in re.finditer(r'EG_PHY_BRAM #\(',gate):
    b=gate[m.start():gate.find(');',m.start())+2]
    if '\\u_pcm_waveform/ramread0_syn_' in b:wb.append(b)
    if '\\u_wav_player/ramread1_syn_' in b:pb.append(b)
assert len(wb)==1 and len(pb)==4 and 'PDPW8K' in wb[0]
(model/'bram_mapping_excerpt.txt').write_text('Gate SHA256 '+sha(out/'AC201_tf_hdmi_gate.v')+'\nWave1 PDPW8K, PCM FIFO4 DP8K.\n\n'+'\n\n'.join(wb+pb),encoding='utf-8')
info={'version':'C11205','kind':'TOP_DOWN_EIGHT_ROW_WIPE','boardStatus':'PENDING_BOARD_VALIDATION','createdBeijing':now,
 'sourceProject':str(p),'parentVersion':'C11204','successfulBaseline':'C11204 waveform_keyfreeze.bit with known waveform display issues',
 'canonicalBit':str(bit),'deliveryBitName':'transition_wipe.bit','bitBytes':bit.stat().st_size,'bitSha256':bh,
 'rollbackBitName':rollback.name,'rollbackSha256':sha(rollback),'scopeHash':bs['scopeHash'],'scriptHash':bs['scriptHash'],
 'stageRunIds':{s:e['runId'] for s,e in stages.items()},'timing':dict(zip(['SWNSns','STNSns','HWNSns','HTNSns'],timing)),
 'timingCoveragePercent':coverage,'resource':resources,'holdFixPerformed':bs['routeStage']=='hold',
 'models':{n:sha(model/n) for n in logs},'inheritedSourceAudit':sha(model/'parent_source_audit.json'),
 'wipe':{'width':640,'height':480,'rowsPerFrame':8,'frameEdges':60,'wordStride':480,'wordsPerFrame':230400,'burstsPerFrame':900,'burstWords':256},
 'ownership':'Loader waits after full target write; releases old buffer only after final full-new-frame request-accept ACK, after previous burst drain. ACK is not full-frame read completion.',
 'busyInput':'One next request retained/coalesced; AUTO state may toggle; WAIT_DISPLAY pauses AUTO interval.',
 'firstImage':'Direct full image, no wipe','error':'Original HALT, no failed target publication, old image stays',
 'knownIssues':['Dynamic waveform double trace disappears under HOLD; unique cause unconfirmed','Low waveform display resolution; optimization deferred'],
 'hardwareActions':'No local JTAG, TF write or Flash programming; original TF media unchanged',
 'checkpoint':str(cp),'evidenceLimit':'New behavior models and static integration audit plus original-constraint TD timing; encrypted SDRAM, actual BRAM/HDMI PHY and board unverified. Parent feature evidence inherited only for unchanged source files.'}
save(out/'AC201_player_transition_wipe.info.json',info)
delivery=p/'build/delivery';delivery.mkdir(parents=True)
readme='''# C11205 上下擦除转场候选

本地模型和正式TD时序通过，实板待验证。TF素材不改；无需插读卡器，不写Flash。
英文路径解压，BitWriter Add transition_wipe.bit，PROGRAM_SRAM / 5MHz，Run，确认 Downloading succeeded。数码管D页DFC11205。

1. 首图直接完整显示。默认天之弱应清晰，原字幕、状态栏和波形保持。
2. PLAY短按KEY0，新BMP完整加载后，应从上往下连续擦除换图，约1秒（60个显示帧边界，未实测）。确认不是硬切、颜色正常，无撕裂/乱码/灰竖条；音乐应持续清晰。四张各切一次。
3. 短KEY1开AUTO，观察至少两轮：每张都有完整擦除，不混入第三张，编号在擦除结束后更新。动画中再点KEY0会保留/合并一次下一图请求，不要求每次点按都排队。
4. 长KEY1切内部音阶，也应清晰；两音源下切图、AUTO各检查一次。
5. PLAY双键短按并全松冻结/恢复波形；KEY0长切BRI/CON做调节，双长复默认。音画/字幕和参数保持正常。动态波形双线及低清晰度仍为原已知项，不算转场新增失败。

若无信号/花屏/杂音/按键异常，同供电、TF、HDMI与音量回载同包waveform_keyfreeze.bit（C11204已反馈组合功能正常的基线），反馈新旧差异。先不要改TF/Flash。
无需再录旧数码管页；转场有异常时拍一段包含按键、完整屏幕的短视频更有用。
'''
(delivery/'README.md').write_text(readme,encoding='utf-8')
for src,dst in [(bit,root/'download/transition_wipe.bit'),(out/'AC201_player_transition_wipe.info.json',root/'download/transition_wipe.info.json'),(bit,delivery/'transition_wipe.bit'),(out/'AC201_player_transition_wipe.info.json',delivery/'transition_wipe.info.json'),(rollback,delivery/rollback.name)]:
    assert not dst.exists();shutil.copy2(src,dst);assert sha(src)==sha(dst)
names=['README.md','transition_wipe.bit','transition_wipe.info.json',rollback.name]
(delivery/'checksums.sha256').write_text(''.join(sha(delivery/n)+'  '+n+'\n' for n in sorted(names)),encoding='ascii');names.append('checksums.sha256')
cp.mkdir(parents=True)
files=[p/'README.md',p/'build/init_project.py',p/'build/prepare_evidence.py',p/'build/record_stage.py',Path(__file__),delivery/'README.md']
files += [f for f in (p/'src/user_source').rglob('*') if f.is_file()]+[p/'src/td_project/AC201_tf_hdmi.al']
files += [f for f in (p/'src/td_project/al_ip').rglob('*') if f.is_file()]+[f for f in (p/'scripts').rglob('*') if f.is_file()]
files += [f for f in (p/'build/audit').rglob('*') if f.is_file()]
files += [f for f in model.rglob('*') if f.is_file() and f.suffix!='.vvp']
files += [f for f in out.rglob('*') if f.is_file() and f.suffix in ['.log','.ts','.timing','.area','.json','.bit']]
if (p/'build/prehold').exists():files += [f for f in (p/'build/prehold').rglob('*') if f.is_file() and f.suffix!='.db']
manifest=[]
for src in sorted(set(files)):
    rel=src.relative_to(p);dst=cp/rel;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,dst)
    assert sha(src)==sha(dst);manifest.append({'path':rel.as_posix(),'bytes':dst.stat().st_size,'sha256':sha(dst)})
save(cp/'manifest.json',manifest)
for e in manifest:assert sha(cp/e['path'])==e['sha256']
with zipfile.ZipFile(zp,'w',zipfile.ZIP_DEFLATED) as z:
    for n in sorted(names):z.write(delivery/n,n)
with zipfile.ZipFile(zp) as z:
    assert z.testzip() is None and set(z.namelist())==set(names)
    for n in names:assert hashlib.sha256(z.read(n)).hexdigest().upper()==sha(delivery/n)
receipt={'createdBeijing':now,'bitSha256':bh,'checkpointFiles':len(manifest),'manifestSha256':sha(cp/'manifest.json'),'zip':str(zp),'zipBytes':zp.stat().st_size,'zipSha256':sha(zp),'boardStatus':info['boardStatus'],'parentVerifiedAndCandidateAndZipUnchanged':True}
save(p/'build/delivery_verified.json',receipt);save(topic/'build_info.json',info);save(topic/'delivery_receipt.json',receipt)
message=f'{now} C11205上下擦除候选本地完成，实板待验证。地址922360检查/RGB888四帧1228800像素/ownership/实际backend握手模型通过，静态审查无阻塞；TD原约束时序 {info["timing"]} coverage{coverage}% holdFix={info["holdFixPerformed"]}，源/脚本/DB/报告/bit绑定与ZIP逐项SHA通过。资源{resources}，download/transition_wipe.bit SHA {bh}；ZIP {zp} {receipt["zipBytes"]}bytes SHA {receipt["zipSha256"]}；{len(manifest)}文件checkpoint manifest {receipt["manifestSha256"]}。78源保持、5改、1新，640×480/每帧8行/60帧边界/900批次，最终全新帧请求ACK后释放旧buffer。成功基线仍C11204，原动态波形双线/低清晰度保留；未JTAG/TF/Flash，加密SDRAM和实际音画待用户验证。'
(topic/'README.md').write_text((topic/'README.md').read_text(encoding='utf-8')+'\n## '+now+'｜本地候选交付，板测待验证\n\n'+message+'\n\n模型范围与TB边界见工程build/model/verification_scope.md；ownership COMMIT注入不是完整BMP文件测试。下一步下载新候选，检查四图从上往下完整擦除、AUTO两轮、两音源/字幕/参数/冻结恢复；异常同条件回载同包C11204。[板测操作卡](操作卡.md)。\n',encoding='utf-8')
shutil.copy2(delivery/'README.md',topic/'操作卡.md')
state=docs/'当前状态.md';s=state.read_text(encoding='utf-8');s=re.sub(r'^更新：.*$',f'更新：{now}（北京时间；XiAzir；C11205候选交付/实板待验证，成功基线C11204）。',s,count=1,flags=re.M);s=s.replace('## 当前阶段','## 当前阶段\n\n**'+message+' [转场专题](专题记录/图片转场/上下擦除首版_20261012/README.md)。**',1);state.write_text(s,encoding='utf-8')
log=docs/'工作日志/2026-10-12.md';log.write_text(log.read_text(encoding='utf-8')+'\n### '+now+'｜C11205上下擦除｜本地交付、实板待验证\n\n- '+message+'\n- 下一步用户远控上板新候选，TF素材不改；失败回载C11204。[操作卡](../专题记录/图片转场/上下擦除首版_20261012/操作卡.md)。\n',encoding='utf-8')
print(json.dumps(receipt,ensure_ascii=True,indent=2))
