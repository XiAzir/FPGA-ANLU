from pathlib import Path
import hashlib,json,datetime,re,shutil,zipfile
root=Path('E:/VSCODE-project/FPGA-ANLU'); p=root/'development/player_pcm_waveform_keyfreeze'
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录'); topic=docs/'专题记录/三扩展集成/C11204验收_20261012'; topic.mkdir(parents=True,exist_ok=True)
now=datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
def sha(f): return hashlib.sha256(Path(f).read_bytes()).hexdigest().upper()
def load(f): return json.loads(Path(f).read_text(encoding='utf-8-sig'))
def save(f,v): Path(f).write_text(json.dumps(v,ensure_ascii=False,indent=2),encoding='utf-8')
receipt=load(p/'build/delivery_verified.json'); parent=p/'checkpoints/waveform_keyfreeze_20261012_candidate'; cp=p/'checkpoints/waveform_keyfreeze_20261012_verified'
assert not cp.exists()
assert sha(parent/'manifest.json')==receipt['manifestSha256']
manifest=load(parent/'manifest.json')
for e in manifest: assert sha(parent/e['path'])==e['sha256']
assert sha(Path(receipt['zip']))==receipt['zipSha256']
bh=receipt['bitSha256']; assert sha(root/'download/waveform_keyfreeze.bit')==bh
feedback={'recordedBeijing':now,'version':'C11204','bitSha256':bh,'source':'User report, no agent hardware operation',
 'question':'请在当前waveform_keyfreeze.bit上补一轮组合确认：音乐播放时切图、开自动轮播、冻结/恢复波形；再调亮度和对比度、双键长按恢复默认；最后长按KEY1切内部音阶，并冻结/恢复。图片、两种音源、字幕及这些操作是否都正常？动态双线按已知问题保留，不算本轮失败。',
 'answer':'已补测，以上都正常',
 'reportedPassed':['Image display andKEY0 switching','KEY1automatic slideshow','Brightness/contrast edit andchord default restore','Static/dynamic text','Music andinternal tone','Waveform freeze/resume during combined operations'],
 'knownIssues':['Live waveform double trace; HOLD removes it; unique root cause unconfirmed and user deferred','128x4 horizontal bins and57 vertical levels; display quality improvement deferred'],
 'notValidated':['Timed long run','Coldstart repeat/newdownload matrix','Alternate files/cards andfragmentation regression','Flash persistence','Actual capture of HDMI pixels or screen response'],
 'boardStatus':'PASS_REPORTED_INTEGRATED_FUNCTIONS_WITH_KNOWN_WAVEFORM_ISSUES','T24':'Control map andoperation card complete','T25':'Combined user-reported function regression andverified snapshot complete; known issues/longrun limits retained'}
folder=p/'build/board_feedback_20261012'; save(folder/'integrated_functions_feedback.json',feedback); save(topic/'feedback.json',feedback)
info=load(p/'build/manual/AC201_player_pcm_waveform_keyfreeze.info.json')
info.update({'boardStatus':feedback['boardStatus'],'previousSuccessfulBaseline':'C11201 image_adjust.bit','successfulBaseline':'C11204 waveform_keyfreeze.bit (reported integrated functions; known waveform issues retained)',
 'lastBoardFeedback':str(folder/'integrated_functions_feedback.json'),'lastBoardFeedbackBeijing':now,'knownIssues':feedback['knownIssues'],'verifiedCheckpoint':str(cp),'unverifiedAfterFeedback':feedback['notValidated']})
info['evidenceLimit']='Integrated functions passed by user report; live double trace and low waveform resolution explicitly deferred. No unique monitor/root cause or long-run/coldstart/Flash proof. Frozen candidate/ZIP retain historical pending metadata.'
save(p/'build/manual/AC201_player_pcm_waveform_keyfreeze.info.json',info);save(root/'download/waveform_keyfreeze.info.json',info)
card='''# C11204 集成播放器操作卡

同一位流包含图片/音乐、静态状态栏与动态字幕、亮度/对比度调节、真实PCM波形和按键冻结。
版本 C11204；位流 waveform_keyfreeze.bit；数码管D页DFC11204。
TF沿用640×480 bottom-up24位BMP根目录最多4张和48kHzPCM16mono TEST.WAV。无需重写卡。
BitWriter PROGRAM_SRAM /5MHz；断电后需重新下载。Flash未固化。

| 操作 | PLAY | BRI亮度 / CON对比度 |
| --- | --- | --- |
| KEY0短按后松开 | 下一张图片 | 当前参数减一档 |
| KEY1短按后松开 | AUTO开关 | 当前参数加一档 |
| KEY0长按约2秒 | 循环 PLAY→BRI→CON→PLAY | 同左 |
| KEY1长按约2秒 | WAV /内部音阶切换，解除波形冻结 | 不切音源 |
| 双键同时短按0.2～0.5秒后全松 | 波形冻结/恢复，不暂停音乐 | 无操作 |
| 双键同时长按约2秒 | B+00、C1.00，回PLAY | 同左 |

模式/参数看参数栏。短操作在消抖松开后生效；双短须稳定按下重叠，双长复默认不触发波形切换。
波形动态标题PCM WAV/TONE X4，冻结后HOLD WAV/TONE X4。冻结锁住当前完整front；恢复先采完整新窗再换图。音源切换解除HOLD。
双键长恢复默认不主动解除已有波形冻结；需要动态显示时PLAY双短或换源。

本轮用户报告组合功能全部正常，动态双线/HOLD消失与低清晰度作为已知显示问题保留，根因未唯一确认。不是无缺陷或长稳证明。
应急回退image_adjust.bit（C11201）；不必回退或重新下载来完成下一阶段资料工作。
'''
(topic/'操作卡.md').write_text(card+'\n位流SHA256 '+bh+'\n',encoding='utf-8')
summary='''# C11204 T24/T25验收与封存

记录：'''+now+'''（北京时间）。

用户对当前位流组合操作清单回复“已补测，以上都正常”。据此记录图片/两源音频/字幕/调节默认/波形冻结恢复功能通过。前序模型和正式构建/时序保持，不重复构建或扩大测试。新成功开发基线C11204（带已知波形显示问题），C11201继续回退。

动态波形双线与低分辨率由用户明确留后；同bit动态/HOLD对照支持动态因素，不是屏幕唯一根因已确认。完整计时长稳、冷启动矩阵、换文件碎片、Flash未完成；本轮未代理操作硬件。

T24操作映射与操作卡收尾，T25三项扩展同位流用户组合回归及verified封存完成（上述边界）。原154文件candidate/ZIP保留历史pending，不覆盖。新verified为原冻结产物加实板反馈与操作卡，源码/位流完全一致。

下一步T26实际BUF0/BUF1所有权与读请求边界审计，再T27一种连续擦除候选。转场尚未实现/构建/上板，TF不改；先保持成功基线可回退。波形优化256/512组/线条和纵向留显示优化阶段。
'''
(topic/'README.md').write_text(summary,encoding='utf-8')
readme=p/'README.md'; readme.write_text(readme.read_text(encoding='utf-8')+'\n\n## '+now+' 用户组合功能通过\n\n'+summary+'\n',encoding='utf-8')
cp.mkdir(parents=True)
for e in manifest:
    rel=Path(e['path']); dst=cp/rel; dst.parent.mkdir(parents=True,exist_ok=True); shutil.copy2(parent/rel,dst)
for src,rel in [(readme,'README.md'),(p/'build/manual/AC201_player_pcm_waveform_keyfreeze.info.json','build/manual/AC201_player_pcm_waveform_keyfreeze.info.json'),(folder/'integrated_functions_feedback.json','build/board_feedback_20261012/integrated_functions_feedback.json'),(topic/'操作卡.md','build/acceptance/operation_card.md'),(topic/'README.md','build/acceptance/acceptance_summary.md'),(Path(__file__),'build/seal_reported_functions.py')]:
    dst=cp/rel; dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,dst)
assert sha(cp/'build/manual/AC201_player_pcm_waveform_keyfreeze.bit')==bh
for f in (p/'src/user_source').rglob('*'):
    if f.is_file(): assert sha(f)==sha(cp/f.relative_to(p))
newmanifest=[{'path':f.relative_to(cp).as_posix(),'bytes':f.stat().st_size,'sha256':sha(f)} for f in sorted(cp.rglob('*')) if f.is_file()]
save(cp/'manifest.json',newmanifest)
for e in newmanifest: assert sha(cp/e['path'])==e['sha256']
vr={'createdBeijing':now,'version':'C11204','bitSha256':bh,'verifiedCheckpoint':str(cp),'manifestFiles':len(newmanifest),'manifestSha256':sha(cp/'manifest.json'),'parentCandidateManifestSha256':receipt['manifestSha256'],'originalZipSha256':receipt['zipSha256'],'boardStatus':feedback['boardStatus'],'sourceAndBitUnchanged':True}
save(p/'build/acceptance_verified.json',vr);save(topic/'verified_receipt.json',vr)
message=f'{now} 用户对C11204组合补测回复“已补测，以上都正常”：切图/AUTO、B/C与复默认、字幕、WAV/内部tone、波形冻结恢复功能通过（用户反馈）。T24操作卡/T25同位流三扩展功能收尾，成功开发基线更新C11204 waveform_keyfreeze.bit SHA {bh}，带已知动态双线和低清晰度，C11201继续回退。新{len(newmanifest)}文件verified，manifest {vr["manifestSha256"]}，源/bit及原154文件candidate/ZIP保持。无重复构建/代理JTAG/TF/Flash；时长/冷启动/换文件碎片/固化未验证。T26转场所有权审计启动，T27位流尚未实现。'
state=docs/'当前状态.md'; text=state.read_text(encoding='utf-8');text=re.sub(r'^更新：.*$',f'更新：{now}（北京时间；XiAzir；C11204组合功能通过/封存，T26审计中）。',text,count=1,flags=re.M)
text=text.replace('## 当前阶段','## 当前阶段\n\n**'+message+' [验收与操作卡](专题记录/三扩展集成/C11204验收_20261012/README.md)。**',1);state.write_text(text,encoding='utf-8')
log=docs/'工作日志/2026-10-12.md';log.write_text(log.read_text(encoding='utf-8')+'\n### '+now+'｜T24/T25 C11204集成收尾｜用户功能反馈通过/verified完成\n\n- '+message+'\n- 用户原问题和反馈、已知问题/边界、操作卡/verified凭据保存在[验收专题](../专题记录/三扩展集成/C11204验收_20261012/README.md)。\n- 下一步实际tf_bmp_file_player/OSD mailbox/整帧SDRAM读请求所有权审计；不能只凭存在双帧地址认定可转场，先规格/模型后新候选。\n',encoding='utf-8')
print(json.dumps(vr,ensure_ascii=True,indent=2))
