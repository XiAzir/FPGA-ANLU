from pathlib import Path
import datetime,hashlib,json,re,shutil
root=Path('E:/VSCODE-project/FPGA-ANLU');p=root/'development/player_transition_wipe'
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录');topic=docs/'专题记录/图片转场/上下擦除首版_20261012'
now=datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
def sha(f):return hashlib.sha256(Path(f).read_bytes()).hexdigest().upper()
def load(f):return json.loads(Path(f).read_text(encoding='utf-8-sig'))
def save(f,v):Path(f).write_text(json.dumps(v,ensure_ascii=False,indent=2),encoding='utf-8')
receipt=load(p/'build/delivery_verified.json');parent=p/'checkpoints/transition_wipe_20261012_candidate';cp=p/'checkpoints/transition_wipe_20261012_verified'
assert not cp.exists()
assert sha(parent/'manifest.json')==receipt['manifestSha256']=='55BDA6F491CCF5B7B15E70BD0E12B6F6F225EB4964B67ACAA7801ECE0824A82F'
manifest=load(parent/'manifest.json');assert len(manifest)==165
for e in manifest:assert sha(parent/e['path'])==e['sha256']
assert sha(Path(receipt['zip']))==receipt['zipSha256']=='B9F6B9F7142B058424AD7BB84BCCC45E73B1DA8EA034AFC4AF90B2DD55581C76'
bh=receipt['bitSha256'];assert bh=='748E0AF0F9BF0656410C09735E371F655BEDD330C259E43858B614B1D95AE8F9'
for f in [root/'download/transition_wipe.bit',p/'build/manual/AC201_player_transition_wipe.bit']:assert sha(f)==bh
for sub in ['src/user_source','scripts','src/td_project/al_ip']:
    for f in (p/sub).rglob('*'):
        if f.is_file():assert sha(f)==sha(parent/f.relative_to(p))
assert sha(p/'src/td_project/AC201_tf_hdmi.al')==sha(parent/'src/td_project/AC201_tf_hdmi.al')
folder=p/'build/board_feedback_20261012';folder.mkdir(parents=True,exist_ok=True)
feedback={'recordedBeijing':now,'version':'C11205','bitSha256':bh,'source':'User report; no agent hardware operation or direct measurement',
 'testRequest':'上一轮要求：KEY0四图完整上下擦除；KEY1 AUTO至少两轮；音乐与内部音阶下切图/轮播；字幕、亮度/对比度、波形冻结/恢复。动态波形双线与低清晰度保留。',
 'answer':'都没问题','reportedPassed':['Four images with top-down wipe and correct display','Automatic slideshow and complete transitions','Music and internal tone during switching/slideshow','Text overlays','Brightness/contrast and waveform freeze/resume'],
 'boardStatus':'PASS_REPORTED_WIPE_AND_INTEGRATED_FUNCTIONS_WITH_KNOWN_WAVEFORM_ISSUES',
 'knownIssues':['Dynamic waveform double trace disappears under HOLD; unique cause unconfirmed, deferred','Low waveform display resolution; optimization deferred'],
 'notValidated':['Measured transition duration or captured HDMI pixels','Timed long run','Repeated coldstart/download matrix','Alternate media/card and fragmentation regression','Flash persistence'],
 'taskScope':'T26 ownership audit and T27 one continuous top-down wipe locally verified and user-reported board functions passed; not all transition types or unrestricted media.'}
save(folder/'functions_feedback.json',feedback);save(topic/'board_feedback.json',feedback)
info=load(p/'build/manual/AC201_player_transition_wipe.info.json')
info.update({'boardStatus':feedback['boardStatus'],'previousSuccessfulBaseline':'C11204 waveform_keyfreeze.bit',
 'successfulBaseline':'C11205 transition_wipe.bit (user-reported functions passed, known waveform issues retained)',
 'lastBoardFeedbackBeijing':now,'lastBoardFeedback':str(folder/'functions_feedback.json'),'verifiedCheckpoint':str(cp),'unverifiedAfterFeedback':feedback['notValidated']})
info['evidenceLimit']='User reported the requested wipe and integrated function tests all passed. Original local model/TD evidence unchanged. Known waveform issues retained; no measured duration, unique ghosting cause, long-run/coldstart/Flash claim. Candidate checkpoint and ZIP preserve historical pending metadata.'
save(p/'build/manual/AC201_player_transition_wipe.info.json',info);save(root/'download/transition_wipe.info.json',info)
summary=f'''# C11205 上下擦除实板反馈与封存

记录：{now}（北京时间，反馈记录时间，非实测起止时间）。

用户对上一轮完整测试清单回复“都没问题”。因此将四图上下擦除、AUTO、两音源及字幕/参数/冻结恢复记为所要求功能通过（用户反馈）；代理未下载板卡、操作TF/Flash或直接测量。成功开发基线更新为C11205 transition_wipe.bit，C11204继续直接回退。

位流SHA256：{bh}。生产640×480、每显示帧8行；未实测时长，不能把代码推算约1秒写成测量结果。

T26所有权审计和T27一种连续转场完成上述范围验收。已知动态波形双线/HOLD消失、低清晰度继续保留；无唯一屏幕根因结论。计时长稳、冷启动矩阵、新文件/卡与碎片、Flash未验证。原165文件candidate与ZIP保持历史pending，新verified只增加本轮反馈/验收记录和更新info，源与bit保持原字节。

下一开发项按执行规划为T29多尺寸BMP测试基准及T30 FPGA最近邻缩放：不同受支持尺寸由FPGA适配到640×480画面，先规格/资源/行padding及方向模型，再独立候选集成；尚未启动RTL或上板。不以720p60为前置，波形清晰度优化留后。
'''
(topic/'验收记录.md').write_text(summary,encoding='utf-8')
card=(p/'build/delivery/README.md').read_text(encoding='utf-8-sig')
card=card.replace('候选','已反馈功能通过版',1).replace('本地模型和正式TD时序通过，实板待验证。','本地模型和正式TD时序通过；用户对本轮测试清单回复“都没问题”，所要求功能通过。已知波形显示问题保留，非长稳证明。',1)
(topic/'已验证操作卡.md').write_text(card+'\n位流SHA256 '+bh+'\n',encoding='utf-8')
cp.mkdir(parents=True)
for e in manifest:
    rel=Path(e['path']);dst=cp/rel;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(parent/rel,dst)
extras=[(p/'build/manual/AC201_player_transition_wipe.info.json','build/manual/AC201_player_transition_wipe.info.json'),(folder/'functions_feedback.json','build/board_feedback_20261012/functions_feedback.json'),(topic/'验收记录.md','build/acceptance/acceptance_summary.md'),(topic/'已验证操作卡.md','build/acceptance/operation_card.md'),(Path(__file__),'build/seal_reported_functions.py')]
for src,rel in extras:
    dst=cp/rel;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,dst)
assert sha(cp/'build/manual/AC201_player_transition_wipe.bit')==bh
nm=[{'path':f.relative_to(cp).as_posix(),'bytes':f.stat().st_size,'sha256':sha(f)} for f in sorted(cp.rglob('*')) if f.is_file() and f.name!='manifest.json']
save(cp/'manifest.json',nm)
for e in nm:assert sha(cp/e['path'])==e['sha256']
assert sha(parent/'manifest.json')==receipt['manifestSha256'] and sha(Path(receipt['zip']))==receipt['zipSha256']
vr={'createdBeijing':now,'version':'C11205','bitSha256':bh,'verifiedCheckpoint':str(cp),'manifestFiles':len(nm),'manifestSha256':sha(cp/'manifest.json'),'parentCandidateManifestSha256':receipt['manifestSha256'],'originalZipSha256':receipt['zipSha256'],'boardStatus':feedback['boardStatus'],'sourceAndBitUnchanged':True}
save(p/'build/acceptance_verified.json',vr);save(topic/'verified_receipt.json',vr)
(topic/'README.md').write_text((topic/'README.md').read_text(encoding='utf-8')+'\n## '+now+'｜用户测试通过，新成功基线C11205\n\n'+summary+'\n[已验证操作卡](已验证操作卡.md)；[封存凭据](verified_receipt.json)。\n',encoding='utf-8')
message=f'{now} 用户对C11205转场测试清单回复“都没问题”，记四图上下擦除/AUTO、音乐与内部音阶、字幕/亮度对比度/波形冻结恢复所要求功能通过（用户反馈）。成功基线更新download/transition_wipe.bit SHA {bh}，C11204继续回退；已知动态波形双线/低清晰度保留。新{len(nm)}文件verified，manifest {vr["manifestSha256"]}，源/bit与原165文件candidate/ZIP保持。T26/T27一种转场收尾；无重构建或代理JTAG/TF/Flash。未实测时长/长稳/冷启动/换文件碎片/Flash。下一项T29/T30多尺寸BMP与FPGA最近邻缩放，尚未开发。'
state=docs/'当前状态.md';s=state.read_text(encoding='utf-8');s=re.sub(r'^更新：.*$',f'更新：{now}（北京时间；XiAzir；C11205用户功能反馈通过/verified封存，成功基线C11205）。',s,count=1,flags=re.M);s=s.replace('## 当前阶段','## 当前阶段\n\n**'+message+' [验收](专题记录/图片转场/上下擦除首版_20261012/验收记录.md)。**',1);state.write_text(s,encoding='utf-8')
log=docs/'工作日志/2026-10-12.md';log.write_text(log.read_text(encoding='utf-8')+'\n### '+now+'｜C11205上下擦除｜用户功能反馈通过/verified封存完成\n\n- '+message+'\n- 反馈未提供新录像/计时，按上一轮清单解释“都没问题”，不扩展为无缺陷/长稳证明。下一步按[执行规划](E:/VSCODE-project/FPGA-ANLU/planning/20261007/执行规划.md)规格化多尺寸BMP/最近邻缩放。[验收证据](../专题记录/图片转场/上下擦除首版_20261012/验收记录.md)。\n',encoding='utf-8')
print(json.dumps(vr,ensure_ascii=True,indent=2))
