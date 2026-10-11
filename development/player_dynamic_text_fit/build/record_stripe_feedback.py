from pathlib import Path
from datetime import datetime, timezone, timedelta
import hashlib, json, shutil

root = Path('E:/VSCODE-project/FPGA-ANLU')
docs = Path('E:/QQ CACHE/Download/安路资料/开发记录')
project = root / 'development/player_dynamic_text_fit'
photo = Path('C:/Users/PENGYU~1/AppData/Local/Temp/codex-clipboard-79f4e140-7976-41a2-84dc-54271140171c.jpg')
now = datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest().upper()
bit = root / 'download/dynamic_text_fit.bit'
assert sha(bit) == '028D9D9A742A2CD980ECBEA48FFBE824D89DA34CF6B2B3E66EA0AA42B6D6456D'
evidence = docs / '专题记录/OSD状态显示/动态字幕资源版竖线_20261009'
evidence.mkdir(parents=True, exist_ok=True)
target = evidence / 'image_1.jpg'
if target.exists():
    assert sha(target) == sha(photo)
else:
    shutil.copy2(photo, target)
feedback = {
    'recorded_beijing': now, 'source': 'user hardware feedback and supplied photo',
    'candidate_inferred_from_last_delivery': str(bit), 'sha256': sha(bit),
    'result': 'PARTIAL_PASS_VIDEO_STRIPES_FAIL',
    'passed_user_report': ['default music', 'long KEY1 internal tone', 'KEY0 manual switching', 'short KEY1 automatic switching'],
    'failed_user_report': 'regular faint vertical grey lines on background BMP only; user distinguishes them from curved camera moire; absent on OSD and scrolling bar',
    'photo': str(target), 'photo_sha256': sha(target),
    'same_condition_rollback': {'bit': str(root/'download/osd_phy_fix.bit'), 'sha256': sha(root/'download/osd_phy_fix.bit'), 'user_report': 'vertical lines disappear'},
    'runtime_and_long_duration': 'NOT_MEASURED', 'root_cause': 'NOT_CONFIRMED',
    'agent_card_or_flash_operations': 'NONE'
}
for path in [project/'build/board_feedback_20261009.json', evidence/'feedback.json']:
    path.write_text(json.dumps(feedback, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
info_path = project/'build/manual/AC201_player_dynamic_text_fit.info.json'
info = json.loads(info_path.read_text(encoding='utf-8-sig'))
info.update(status='Hardware partial pass: audio/keys normal; background BMP vertical stripes FAIL; same-condition fallback clears stripes', hardware_result='PARTIAL_PASS_VIDEO_STRIPES_FAIL', board_feedback=str(project/'build/board_feedback_20261009.json'))
info_path.write_text(json.dumps(info, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
state_path = docs/'当前状态.md'
state = state_path.read_text(encoding='utf-8')
start = state.index('**动态字幕资源候选本地完成')
end = state.index('\n\n', start)
state = state[:start] + '**'+now+'动态字幕资源版实板部分通过、底图竖线失败（用户反馈）：dynamic_text_fit.bit/SHA256 028D9D9A742A2CD980ECBEA48FFBE824D89DA34CF6B2B3E66EA0AA42B6D6456D，音乐/长按内部音阶/KEY0手动/KEY1自动正常，但BMP有规则浅灰竖线，OSD/滚动字幕背景没有同样竖线。同TF/供电/HDMI/显示器设置回载osd_phy_fix后竖线消失。当前成功基线仍osd_phy_fix，动态fit不能记为全功能通过；正在检查叠加前像素/帧缓存链路，根因未确认。原148文件检查点/ZIP保留构建时pending历史快照；照片与反馈见[竖线证据](专题记录/OSD状态显示/动态字幕资源版竖线_20261009/feedback.json)。**' + state[end:]
state_path.write_text(state, encoding='utf-8')
log = docs/'工作日志/2026-10-09.md'
with log.open('a', encoding='utf-8') as f:
    f.write('\n### '+now.split(' ')[1]+'｜动态字幕资源版底图竖线｜实板部分通过/显示失败，排查进行中\n\n- 动作/证据：保存用户照片与反馈；dynamic_text_fit哈希匹配上次交付，live元数据改PARTIAL_PASS_VIDEO_STRIPES_FAIL，148文件冻结检查点和ZIP不改。\n- 用户反馈：默认音乐、长按KEY1内部音阶、KEY0手动切图、短按KEY1自动轮切正常；BMP背景有规则浅灰竖线，OSD/滚动字幕覆盖区无同样线；同条件回载osd_phy_fix竖线消失。照片中弯曲纹按用户说明为相机摩尔纹，不用来判定板上缺陷。\n- 判断/边界：故障随位流，优先检查覆盖前底图链；尚未测量像素周期、SDRAM数据或实际IO时序，不把共有TLAST bug或资源密度直接当根因。未操作板卡/TF/Flash；运行时长未实测。\n- 下一步：底图RTL与SDRAM时序并行只读审计，必要时独立最小候选、相关模型和原约束STA后再交付。\n')
print(json.dumps({'feedback': str(evidence/'feedback.json'), 'photo_sha256': sha(target), 'time': now}))
