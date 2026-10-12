from pathlib import Path
import datetime,hashlib,json,re
root=Path('E:/VSCODE-project/FPGA-ANLU'); p=root/'development/player_pcm_waveform_keyfreeze'
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录'); topic=docs/'专题记录/音频可视化/真实PCM波形首版_20261012'
now=datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
def sha(f): return hashlib.sha256(f.read_bytes()).hexdigest().upper()
def load(f): return json.loads(f.read_text(encoding='utf-8-sig'))
def save(f,v): f.write_text(json.dumps(v,ensure_ascii=False,indent=2),encoding='utf-8')
receipt=load(p/'build/delivery_verified.json'); cp=p/'checkpoints/waveform_keyfreeze_20261012_candidate'
assert sha(cp/'manifest.json')==receipt['manifestSha256']
for e in load(cp/'manifest.json'): assert sha(cp/e['path'])==e['sha256']
assert sha(Path(receipt['zip']))==receipt['zipSha256']
assert sha(root/'download/waveform_keyfreeze.bit')==receipt['bitSha256']
feedback={'recordedBeijing':now,'version':'C11204','deliveredBitSha256':receipt['bitSha256'],'source':'User report, not direct agent measurement',
 'userReport':'确实没有出现双线的情况，我判断是跟屏幕的硬件条件有关，你觉得呢',
 'clarificationQuestion':'当前按键冻结版中，再次双键短按恢复动态后，双线会重新出现吗？',
 'clarificationAnswer':'动态时有双线，HOLD后消失',
 'observed':{'liveDynamic':'Two separated curves reported','heldStatic':'Double curve disappears reported'},
 'notEstablished':['WAV and TONE separately','Exact hold duration','Both-source audio quality','Complete original controls regression','Monitor model/response time/processing configuration','Actual FPGA dynamic pixel stream or HDMI capture'],
 'assessment':'Same-bit dynamic/HOLD contrast supports a temporal or dynamic-update dependent phenomenon. Display response/processing or visual integration are plausible; static duplicate trace is less likely. Does not uniquely prove monitor hardware or rule out dynamic bank/read/update behaviour.',
 'reference':'https://www.eizo.com/library/basics/response_time_figures/',
 'referenceLimit':'General LCD motion blur/ghosting mechanism; does not measure this display.',
 'boardStatus':'PARTIAL_PASS_REPORTED_STATIC_TRACE_DYNAMIC_GHOSTING','successfulBaselineUnchanged':'C11201 image_adjust.bit',
 'next':'Continue mainline after appropriate original-feature/audio regression; retain keyfreeze tool. Compare unchanged bit/settings on another already available display later if useful; no new instrument purchase or repeated old video needed.',
 'hardwareActions':'No local JTAG/TF/Flash; no RTL rebuild', 'frozenCandidateAndZipUnchanged':True}
folder=p/'build/board_feedback_20261012'; folder.mkdir(exist_ok=True)
save(folder/'keyfreeze_feedback.json',feedback); save(topic/'keyfreeze_board_feedback.json',feedback)
for f in [p/'build/manual/AC201_player_pcm_waveform_keyfreeze.info.json',root/'download/waveform_keyfreeze.info.json']:
    info=load(f); info['boardStatus']=feedback['boardStatus']; info['lastBoardFeedback']=str(folder/'keyfreeze_feedback.json'); info['lastBoardFeedbackBeijing']=now; save(f,info)
message=f'{now} C11204用户确认同一按键冻结版“动态时有双线，HOLD后消失”。这是动态/HOLD对照的用户反馈，支持时间叠影或动态更新相关因素，静态固定双轨迹假设降优先；屏幕响应/处理与视觉暂留是候选，尚不能唯一归因屏幕硬件或完全排除动态读/换bank链路。live info标PARTIAL_PASS_REPORTED_STATIC_TRACE_DYNAMIC_GHOSTING，成功基线仍C11201。无新增照片/视频/实测像素流，WAV/TONE分别、音质和原功能未逐项反馈。源码/位流不改，154文件候选/ZIP逐项哈希保持；未JTAG/TF/Flash。'
(topic/'README.md').write_text((topic/'README.md').read_text(encoding='utf-8')+'\n\n## '+now+'｜按键冻结同位流动态/静态对照反馈\n\n'+message+'\n\n静态停止刷新时消影、动态恢复有双线，符合动态因素。EIZO官方解释LCD响应慢可造成运动模糊/拖影（https://www.eizo.com/library/basics/response_time_figures/），仅为机制参考，不能代替此显示器测量。当前可避免继续盲改静态绘制或升级分辨率来“修复双线”；保留冻结作为诊断/查看功能。后续有现成另一显示器时，同一bit同接线/设置对照更能判断屏幕相关性，非本轮必须操作。主线继续前新候选原功能/两音源仍需明确反馈，不升级成功基线。\n',encoding='utf-8')
state=docs/'当前状态.md'; text=state.read_text(encoding='utf-8'); text=re.sub(r'^更新：.*$',f'更新：{now}（北京时间；XiAzir；C11204动态双线/HOLD单线用户反馈；成功基线C11201）。',text,count=1,flags=re.M)
text=text.replace('## 当前阶段','## 当前阶段\n\n**'+message+' 记录见[冻结对照反馈](专题记录/音频可视化/真实PCM波形首版_20261012/keyfreeze_board_feedback.json)。**',1);state.write_text(text,encoding='utf-8')
log=docs/'工作日志/2026-10-12.md';log.write_text(log.read_text(encoding='utf-8')+'\n### '+now+'｜C11204冻结实板对照解释｜反馈留档完成、唯一原因未确认\n\n- '+message+'\n- 参考EIZO官方LCD响应/运动拖影机制，非此屏幕实测。下一步原功能/两音源回归后推进主线；有现成另一显示器可后续同bit对照，无需购买仪器或重录旧视频。[专题](../专题记录/音频可视化/真实PCM波形首版_20261012/README.md)。\n',encoding='utf-8')
print(json.dumps({'feedbackTime':now,'boardStatus':feedback['boardStatus'],'snapshotZipUnchanged':True},ensure_ascii=False))
