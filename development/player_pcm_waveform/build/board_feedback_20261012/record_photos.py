from pathlib import Path
import datetime, hashlib, json, re, shutil

root = Path('E:/VSCODE-project/FPGA-ANLU')
project = root / 'development/player_pcm_waveform'
docs = Path('E:/QQ CACHE/Download/安路资料/开发记录')
topic = docs / '专题记录/音频可视化/真实PCM波形首版_20261012'
now = datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
photo_ids = ['6ca08271-3942-42ae-a667-60915b66dad4', 'b28964fa-bcd8-4976-9db1-9525a0457c32', 'eafd7200-56e0-4aaa-9d64-d7ec7e6ec6ef']
archive = topic / '波形重影照片'
archive.mkdir(exist_ok=True)
photos = []
for i, photo_id in enumerate(photo_ids, 1):
    source = Path('C:/Users/PENGYU~1/AppData/Local/Temp') / ('codex-clipboard-' + photo_id + '.jpg')
    target = archive / ('waveform_' + str(i) + '.jpg')
    data = source.read_bytes()
    if target.exists():
        assert target.read_bytes() == data
    else:
        shutil.copy2(source, target)
    assert target.read_bytes() == data
    photos.append({'order': i, 'source': str(source), 'archived': str(target), 'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest().upper()})
finding = {
    'recordedBeijing': now, 'version': 'C11202', 'source': 'USER_PHOTOS_AND_DIRECT_OBSERVATION',
    'boardStatus': 'WAVEFORM_GHOSTING_REPORTED_PENDING_DIAGNOSIS', 'photos': photos,
    'observed': 'Photo2 has two separated cyan waveform traces with black gaps between them; photo3 has one bright trace and a fainter second trace. These are distinct from a filled min/max vertical span.',
    'userDirectObservation': '直接看显示器，不通过手机相机，也会同时看到两条分离的完整青色曲线吗？答：肉眼也明显有。',
    'correction': 'The previous min/max explanation covers thick/stair-step single traces, but cannot explain the separate full curves in these photos. Naked-eye observation rules out a solely phone-camera-generated effect.',
    'codeEvidence': 'bar_pixel uses y>=412-max AND y<=412-min. With stable display-bank/read data each x has one filled interval; there is no intentional old-trace overlay. Display bank switches only at VS. Code/model intent does not prove board memory/read/physical behavior.',
    'hypothesesNotProven': ['Display temporal response or perception of successive moving frames', 'Actual waveform update/read or other physical implementation behavior'],
    'pending': 'Distinguish static rendering from dynamic update/display response; retain all previous unconfirmed original-function/audio regression items.',
    'nextProposedNotExecuted': 'Isolated freeze-front diagnostic: hold one complete displayed waveform while audio continues. If separated curves remain after settling, investigate static pixel/read chain; if they disappear, investigate dynamic update and display temporal response. Freeze outcome alone cannot uniquely prove display or FPGA cause.',
    'actions': 'Archived three original photos without editing; read RTL; no new RTL, model run, bitstream, JTAG, TF or Flash actions. Successful baseline remains C11201.'
}
record = Path(__file__).parent / 'photo_findings.json'
record.write_text(json.dumps(finding, ensure_ascii=False, indent=2), encoding='utf-8')
(topic / 'photo_findings.json').write_text(record.read_text(encoding='utf-8'), encoding='utf-8')
for path in [project / 'build/manual/AC201_player_pcm_waveform.info.json', root / 'download/pcm_waveform.info.json']:
    info = json.loads(path.read_text(encoding='utf-8-sig'))
    info.update(boardStatus=finding['boardStatus'], photoFeedbackBeijing=now, photoFeedbackPath=str(record), unresolvedWaveformIssue='Separated full waveform traces also seen with naked eye; cause unconfirmed')
    path.write_text(json.dumps(info, ensure_ascii=False, indent=2), encoding='utf-8')
paragraph = '''\n\n## ''' + now + '''｜新增照片与肉眼重影反馈：修正前一解释

用户提供三张原始照片，已按字节归档于波形重影照片/，SHA见photo_findings.json。第二张存在中间有黑色间隔的两条独立青色轨迹，第三张可见亮轨迹旁的暗轨迹。用户进一步明确“肉眼也明显有”，因此不能只归因于手机跨帧曝光；上一条min/max区间解释适用于粗线/阶梯，不足以解释分离完整曲线。

RTL bar_pixel为连续上下界区间，未主动保留/叠加旧曲线，display_bank只在VS变化；源码和模型意图不能替代实体链路。新旧波形的显示时间响应/视觉残留或实际换帧读链路均为未证实假设，尚无单帧直接捕获。低空间分辨率和约30Hz推算可解释粗糙/更新感，不能直接当作此重影的已证根因。

live info改WAVEFORM_GHOSTING_REPORTED_PENDING_DIAGNOSIS；音乐关联/静音及音阶形状反馈保留，T23不得整体标通过，成功基线仍C11201。下一步建议独立冻结front一完整窗且音乐照播的诊断；静态保留重影则查静态绘制/读取，静态干净则再分辨动态换帧与显示残留。该诊断尚未开发/构建/上板，也不能单凭冻结消失唯一证明显示器原因。原功能回归待补，不因照片认为音质/按键已通过。没有改RTL/重构建/JTAG/TF/Flash；candidate/ZIP冻结未修改。
'''
readme = topic / 'README.md'
readme.write_text(readme.read_text(encoding='utf-8') + paragraph, encoding='utf-8')
state = docs / '当前状态.md'
text = state.read_text(encoding='utf-8')
text = re.sub(r'^更新：.*$', '更新：' + now + '（北京时间；XiAzir；T23肉眼波形重影待排查；成功基线C11201）。', text, count=1, flags=re.M)
text = text.replace('## 当前阶段', '## 当前阶段\n\n**' + now + ' C11202三照片显示分离的完整双轨迹，用户确认肉眼也明显有；不能只归因拍摄，也不足以用min/max填满区间解释。live info WAVEFORM_GHOSTING_REPORTED_PENDING_DIAGNOSIS，根因未确认，成功基线仍C11201。原照片/SHA及解释修正已保存；未改RTL/构建/硬件。下一步建议冻结front静态对照（尚未实现），再区分动态换帧/显示残留或静态读链路，不直接以更高分辨率为修复。见[照片与修正](专题记录/音频可视化/真实PCM波形首版_20261012/README.md)。**', 1)
text = text.replace('2. T23 C11202波形部分板测通过、原功能回归待补；交付入口：用户下载', '2. T23 C11202音乐关联/静音/音阶形状已有用户正常反馈，但肉眼双轨迹重影未解决。优先冻结front对照诊断（尚未开发），原功能/音质回归仍待补；现候选交付入口：用户下载', 1)
state.write_text(text, encoding='utf-8')
log = docs / '工作日志/2026-10-12.md'
log.write_text(log.read_text(encoding='utf-8') + '\n### ' + now + '｜T23照片及肉眼重影｜显示问题待排查\n\n- 已阅读用户三图：图2分离完整双轨迹、图3暗轨迹；归档原始字节/SHA。用户确认肉眼也有，不能只归因拍摄；修正上一条min/max解释的适用范围。\n- RTL每列连续区间/VS换bank，无主动旧轨迹叠加；不证明实板链路。动态换帧与显示残留/实际读链路根因未区分。\n- live info WAVEFORM_GHOSTING_REPORTED_PENDING_DIAGNOSIS；T23未整体通过，成功基线仍C11201，原功能/两源音质反馈待补。未改RTL/新构建/JTAG/TF/Flash或冻结产物。\n- 下一步建议冻结front、音频继续的独立诊断，尚未实现；静态/动态分层后再决策优化，不能声称提高刷新率/分辨率已解决。详见[照片与解释修正](../专题记录/音频可视化/真实PCM波形首版_20261012/README.md)。\n', encoding='utf-8')
print(json.dumps({'status': finding['boardStatus'], 'recordedBeijing': now, 'photosArchived': len(photos)}, ensure_ascii=True))
