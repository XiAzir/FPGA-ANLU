from pathlib import Path
import datetime, hashlib, json, re

root = Path('E:/VSCODE-project/FPGA-ANLU')
project = root / 'development/player_pcm_waveform'
docs = Path('E:/QQ CACHE/Download/安路资料/开发记录')
topic = docs / '专题记录/音频可视化/真实PCM波形首版_20261012'
now = datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')

def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest().upper()

def save(path, obj):
    Path(path).write_text(json.dumps(obj, ensure_ascii=False, indent=2), encoding='utf-8')

candidate = project / 'checkpoints/pcm_waveform_20261012_candidate'
assert sha(candidate / 'manifest.json') == 'C5B58E2F7FE26E8E88638F62E0FCD888ECE7BBB73C667DECFFE567BE07519E72'
for entry in json.loads((candidate / 'manifest.json').read_text(encoding='utf-8-sig')):
    assert sha(candidate / entry['path']) == entry['sha256']
assert sha(root / 'deliverables/pcm_waveform_20261012.zip') == 'EA0C3899B22DA7DABF829F564C9B02BDF936849267223F0C5553907AA496DA73'
assert sha(root / 'download/pcm_waveform.bit') == 'D753D6893AA6C1EB98323C189FC7889A7FBCB96D3C12ECA5966AF515AE397D49'
feedback_path = Path(__file__).parent / 'feedback.json'
feedback = {
    'recordedBeijing': now, 'version': 'C11202', 'source': 'USER_REPORTED',
    'boardStatus': 'PARTIAL_PASS_REPORTED_WAVEFORM',
    'userStatement': '波形显示正常，确实如你所说，会显示波形，弱音/静音时接近平线，播放音阶时则是方波。但是刷新率问题吗？会导致同一个x轴坐标有两个y轴的值，而且分辨率很低导致波形是锯齿状的。这些是否是未来优化的方向？接下来做什么？',
    'confirmed': ['WAV waveform visibly present', 'Weak/silent segments near flat', 'Internal tone visibly square'],
    'reportedVisualConcerns': ['Multiple y values at same x', 'Low visual resolution and jagged shape'],
    'pending': ['Explicit current-version audio clarity for both sources', 'KEY0 image change', 'KEY1 AUTO', 'Brightness/contrast and reset', 'Original status/RUN/scroll regression', 'Long-term and cold-start regression'],
    'interpretation': 'Code renders each 8-sample min/max interval as a filled vertical span, replicated across 4 pixels. This explains multiple y values per x for a span, but without a picture/video it does not prove the observed phenomenon is not separate curves/ghosting. 128 bins across512 pixels; graph57 vertical positions. Tone source RTL generates square waves.',
    'refreshInference': 'Under continuous48kHz events:1024 samples=21.333ms, capture resumes afterVS bank swap. Nominal25MHz/(800*525)=59.524 video frames/s; complete window requires two16.8ms frames, yielding about29.762 waveform updates/s. Code-derived estimate, not a measured display/board refresh rate.',
    'proposedOptimizationsNotImplemented': ['256/512 horizontal bins and per-pixel connected trace', 'Larger graph height and selectable visual gain', 'Trigger alignment for tone', 'Shorter window or rolling capture to permit one update each frame'],
    'next': 'Finish previous annotated current-version regression; then seal verified T23 and complete T24/T25 controls/integrated acceptance, followed by T26/T27 frame ownership and one transition. Keep waveform appearance improvements as separate follow-up; no new RTL authorized by this question.',
    'noNewEvidence': 'No new video, numeric pages or board instrument measurements supplied; no local JTAG/TF/Flash, RTL edit or rebuild.',
    'successfulBaseline': 'C11201 image_adjust.bit', 'frozenCandidateAndZipReverified': True
}
save(feedback_path, feedback)
save(topic / 'board_feedback.json', feedback)
for path in [project / 'build/manual/AC201_player_pcm_waveform.info.json', root / 'download/pcm_waveform.info.json']:
    obj = json.loads(path.read_text(encoding='utf-8-sig'))
    obj.update(boardStatus=feedback['boardStatus'], boardFeedbackBeijing=now, boardFeedbackPath=str(feedback_path), boardFeedbackScope=feedback['confirmed'], pendingBoardRegression=feedback['pending'])
    save(path, obj)
(topic / 'README.md').write_text((topic / 'README.md').read_text(encoding='utf-8') + '\n\n## ' + now + '｜波形板测反馈与显示解释\n\n用户反馈音乐波形/弱静音平线/音阶方波正常，记波形相关部分通过；音阶模块实际生成方波，因此不是误画正弦。用户提出同x多y、低分辨率锯齿：源码每8样本min/max竖条复制4像素、128组/512px、纵向57档，可解释区间画法及粗糙阶梯；没有新图/视频，未直接证实是否有另一个独立残影。按名义连续48kHz/25MHz/800×525时序推导约29.76次波形更新每秒，非实测；刷新率影响动态流畅，不是min/max竖条的根因。\n\n原功能回归及两音源音质尚未逐项明确反馈，live info标PARTIAL_PASS_REPORTED_WAVEFORM，成功基线仍C11201，未创建verified/改RTL/重构建。原133文件candidate和ZIP原SHA重新核验保持。优化候选为更多横向bin、折线/插值、纵向高度/增益、音阶触发对齐、更短窗或滚动捕获；均尚未实施，可在480p优化。下一步补齐上一条圈出的回归，完整通过后封存T23并推进T24/T25操作卡与集成验收，再T26/T27一种连续转场。详细反馈见board_feedback.json。\n', encoding='utf-8')
state = docs / '当前状态.md'
text = state.read_text(encoding='utf-8')
text = re.sub(r'^更新：.*$', '更新：' + now + '（北京时间；XiAzir；T23波形部分板测通过、原功能回归待补；成功基线C11201）。', text, count=1, flags=re.M)
text = text.replace('## 当前阶段', '## 当前阶段\n\n**' + now + ' C11202用户反馈音乐波形、弱静音平线、音阶方波正常；波形相关板测部分通过。live info PARTIAL_PASS_REPORTED_WAVEFORM，原功能和两音源音质未明确逐项反馈，不升级成功基线。已解释128组min/max竖条×4px、57纵向档及代码推导约30Hz更新，未新图/实测，显示优化尚未实施。原candidate/ZIP逐项SHA保持，未改RTL/新构建/JTAG/TF/Flash。下一步补齐原功能回归后封存并T24/T25集成验收，再T26/T27转场。见[反馈与解释](专题记录/音频可视化/真实PCM波形首版_20261012/README.md)。**', 1)
text = text.replace('TF不改、未本机JTAG/TF/Flash。见[首版开发与交付]', 'TF不改、未本机JTAG/TF/Flash。该条为交付时历史状态，最新板测见上。见[首版开发与交付]', 1)
text = text.replace('T23 C11202已完成本地候选交付：用户下载', 'T23 C11202波形部分板测通过、原功能回归待补；交付入口：用户下载', 1)
text = text.replace('无需新TF素材；未上板，异常同条件回载同包', '无需新TF素材；已板测波形，原功能/两源音质待补，异常同条件回载同包', 1)
state.write_text(text, encoding='utf-8')
log = docs / '工作日志/2026-10-12.md'
log.write_text(log.read_text(encoding='utf-8') + '\n### ' + now + '｜T23波形反馈及优化方向｜波形部分板测通过，整版回归未完成\n\n- 用户反馈波形随音乐/静音变化、音阶方波正确；提出同x多y/锯齿。只记用户反馈，未收到新图/视频/页值，音质和原功能不得推定已验收。\n- 源码核查：128bin每组8样本min/max填满竖线并复制4px，纵向57位置；内部tone RTL输出方波。名义1024/48k=21.333ms采样窗超过16.8ms视频帧，按现有VS交换/恢复采样推导约29.76Hz波形更新，非实测。区间画法/空间分辨率和刷新率分别影响竖条/阶梯与流畅；未新图不能确认是否有单独残影。\n- 更新live info为PARTIAL_PASS_REPORTED_WAVEFORM及专题反馈，成功基线仍C11201。133文件candidate及ZIP原SHA重验不改；没有新RTL/构建/JTAG/TF/Flash。\n- 下一步补用户圈出的原切图/AUTO/B/C/恢复/字幕及两源音质，完整通过后封存T23、T24/T25整合验收，再T26/T27连续转场。更多bin/连线/高度/增益/触发/刷新优化只是候选，未实施。详见[反馈与解释](../专题记录/音频可视化/真实PCM波形首版_20261012/README.md)。\n', encoding='utf-8')
print(json.dumps({'status': feedback['boardStatus'], 'recordedBeijing': now, 'candidateAndZipUnchanged': True}, ensure_ascii=True))
