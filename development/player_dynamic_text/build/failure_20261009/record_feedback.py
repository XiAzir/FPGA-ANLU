import hashlib
import json
import re
import shutil
from datetime import datetime, timezone, timedelta
from pathlib import Path

root = Path('E:/VSCODE-project/FPGA-ANLU')
docs = Path('E:/QQ CACHE/Download/安路资料/开发记录')
project = root / 'development/player_dynamic_text'
now = datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
evidence = docs / '专题记录/OSD状态显示/动态字幕首版失败_20261009'
evidence.mkdir(parents=True, exist_ok=True)
shutil.copy2(Path('C:/Users/PENGYU~1/AppData/Local/Temp/codex-clipboard-cc83825e-1a2b-4744-8410-7e8a47f7cadb.jpg'), evidence / 'image_1.jpg')
def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest().upper()
feedback = dict(recorded_beijing=now, source='用户现场反馈及照片，非代理实测',
    candidate=str(root / 'download/dynamic_text.bit'), candidate_sha256=sha(root / 'download/dynamic_text.bit'),
    result='FAIL', observations=['无BMP画面及默认音频', 'KEY0无可见切图，IMG持续0/4',
    '短KEY1可切MANUAL/AUTO但无图', '长KEY1播放内部音阶，严重失真，用户描述类似人的嘶吼',
    '照片可见RUN00:52及FPGA MEDIA PLAYER'],
    fallback=str(root / 'download/osd_phy_fix.bit'), fallback_sha256=sha(root / 'download/osd_phy_fix.bit'),
    fallback_request_checks=['四图', '音乐', 'KEY0切图', '长KEY1内部音阶'], fallback_user_answer='恢复',
    conditions='要求保持TF卡、供电、HDMI和音量不变；用户回载后确认恢复',
    photo_sha256=sha(evidence / 'image_1.jpg'), cause='未证实，进行源/时钟复位/约束/物理实现审计',
    card_or_flash_writes='none')
data = json.dumps(feedback, ensure_ascii=False, indent=2) + '\n'
(evidence / 'feedback.json').write_text(data, encoding='utf-8')
(project / 'build/board_feedback_20261009.json').write_text(data, encoding='utf-8')
info_path = project / 'build/manual/AC201_player_dynamic_text.info.json'
info = json.loads(info_path.read_text(encoding='utf-8-sig'))
info.update(status='Local models/build passed; hardware regression FAILED; use osd_phy_fix fallback',
    hardware_result='FAIL from user feedback: IMG0/4, no BMP/WAV, distorted internal tone; same-condition osd_phy_fix restores requested functions',
    board_feedback='build/board_feedback_20261009.json')
info_path.write_text(json.dumps(info, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
state_path = docs / '当前状态.md'
state = state_path.read_text(encoding='utf-8-sig')
notice = '**2026-10-09动态字幕首版实板回归失败（用户反馈）：字幕/计时可见，KEY1 MANUAL/AUTO有响应；IMG停在0/4、无BMP/默认WAV、长KEY1内部音阶严重失真。同条件回载download/osd_phy_fix.bit用户确认恢复。原136文件checkpoint及ZIP保留，live info标FAIL，成功基线仍osd_phy_fix。暂停新功能，源/时钟复位/约束/物理实现审计进行中，具体根因未证实。证据见[首版失败反馈](专题记录/OSD状态显示/动态字幕首版失败_20261009/feedback.json)。**'
state = state.replace('## 当前阶段\n\n', '## 当前阶段\n\n' + notice + '\n\n', 1)
state = re.sub(r'更新：[^。]+（北京时间）', '更新：' + now + '（北京时间）', state, count=1)
state = state.replace('3. dynamic_text最小候选已完成本地开发与136文件封存，实板pending。',
    '3. dynamic_text首版实板失败并同条件回退恢复；先完成有限排查/修复，原136文件封存保留。此前板测指引（历史）：')
state = state.replace('动态字幕开发位于development/player_dynamic_text，本地候选已封存待板测',
    '动态字幕开发位于development/player_dynamic_text，本地首版已封存但实板失败，正在排查')
state_path.write_text(state, encoding='utf-8')
with (docs / '工作日志/2026-10-09.md').open('a', encoding='utf-8') as f:
    f.write(f'\n### {now[11:]}｜动态字幕首版实板失败｜进行中（隔离排查）\n\n'
        '- 用户反馈无BMP/默认WAV，IMG0/4，KEY0无可见切图，KEY1模式可切，内部音阶严重失真；照片字幕/计时可见。失败位流SHA256 '+feedback['candidate_sha256']+'。\n'
        '- 要求同卡/供电/HDMI/音量回退osd_phy_fix，用户回答“恢复”；成功基线SHA256 '+feedback['fallback_sha256']+'保持。照片/反馈保存在专题OSD状态显示/动态字幕首版失败_20261009，live info改FAIL；136文件checkpoint和ZIP不改。\n'
        '- 已启动三项只读审计：源与顶层、SD/音频时钟IO、物理实现/时序覆盖。新功能暂停；根因未证实，未写卡/Flash/操作板卡。\n'
        '- 下一步：据审计确定有限修复，建模与原约束验证后保存独立候选。\n')
print(json.dumps(feedback, ensure_ascii=False, indent=2))
