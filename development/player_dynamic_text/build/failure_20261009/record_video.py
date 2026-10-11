import hashlib
import json
import shutil
from datetime import datetime, timezone, timedelta
from pathlib import Path

root = Path('E:/VSCODE-project/FPGA-ANLU')
records = Path('E:/QQ CACHE/Download/安路资料/开发记录')
evidence = records / '专题记录/OSD状态显示/动态字幕首版失败_20261009'
local = root / 'development/player_dynamic_text/build/failure_20261009'
video = Path('E:/QQ CACHE/LiaoTianJiLu/Tencent Files/1791081637/nt_qq/nt_data/Video/2026-10/Ori/36a515ca7584d3232f0b781a3429140f.mp4')
now = datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest().upper()
evidence.mkdir(parents=True, exist_ok=True)
archived = evidence / 'board_video.mp4'
shutil.copy2(video, archived)
assert sha(video) == sha(archived)
for filename in ('contact.jpg', 'frame_18.jpg', 'frame_24.jpg', 'video_audit.md'):
    shutil.copy2(local / 'board_video' / filename, evidence / filename)

pages = [
    {'frame': 7, 'value': '8D006615', 'meaning': 'bad_bch', 'count': 26133},
    {'frame': 9, 'value': '9D000056', 'meaning': 'bad_terc', 'count': 86},
    {'frame': 11, 'value': 'AD000000', 'meaning': 'tone_bad among accepted good packets', 'count': 0},
    {'frame': 18, 'value': '3B00BB80', 'meaning': 'input audio_valid samples', 'count': 48000,
     'flags': {'tone_mode': 1, 'underflow': 0, 'hdmi_locked': 1, 'frame_seen': 1}},
    {'frame': 22, 'value': '7D006603', 'meaning': 'accepted audio packets', 'count': 26115},
    {'frame': 24, 'value': '8D0066ED', 'meaning': 'bad_bch', 'count': 26349},
    {'frame': 26, 'value': '9D000057', 'meaning': 'bad_terc', 'count': 87},
]
for path in (root / 'development/player_dynamic_text/build/board_feedback_20261009.json', evidence / 'feedback.json'):
    data = json.loads(path.read_text(encoding='utf-8-sig'))
    data['video'] = {'recorded_beijing': now, 'source': str(video), 'archived': str(archived),
        'sha256': sha(video), 'duration_seconds': 30.046211, 'bytes': video.stat().st_size,
        'method': 'ffmpeg fps=1 extraction and visual seven-segment glyph review; no audio listening',
        'pages': pages, 'packet_flags_D': {'island_seen': 1, 'audio_seen': 1, 'acr_seen': 0, 'format_error_seen': 1},
        'cts_n_visible': [0, 0],
        'bounds': ['Counts use separate nominal 25MHz one-second windows; pages are not simultaneous.',
                   'Probe is before PHY; core, probe implementation, clocks and resets not uniquely separated.',
                   'tone_bad=0 considers only accepted good audio packets.',
                   'Frame18 initial agent misread corrected to B/BB80; no PLL-loss/underflow inference.']}
    data['additional_user_feedback'] = '长按KEY1后不仅声音变形，画面间歇缺失；OSD/滚动字幕消失时音频也停止。视频只拍板卡，显示器现象及听感来自用户反馈。'
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

topic = evidence / '排查进展.md'
topic.write_text(f'''# 动态字幕首版失败排查

更新：{now}（北京时间），状态：进行中，根因未证实。

失败位流 `download/dynamic_text.bit` SHA256 D0559A203C0A775B2C70F7A1EA3E7F90BB7743F7ED463AF11409855D54CBF28F。同卡/供电/HDMI/音量回载成功基线 `download/osd_phy_fix.bit`（9E893B0B6C86BF6FBEE19E74B5FB58933C1BEA6AA07F203786CCE96F3B60AE6F）用户确认恢复。

用户读数 `1D950007` 表明卡初始化和FAT挂载完成、BMP错误/未提交、WAV mapper判为请求文件扇区范围内提前EOC。卡上真实FAT四字节和失败目标簇/扇区尚未捕获，不能把此状态直接归因为卡损坏、SPI位错或复位。

原视频已保存为 [board_video.mp4](board_video.mp4)，SHA256 {sha(video)}；抽帧计数与字形复核见 [video_audit.md](video_audit.md)。内部tone输入样本 `3B00BB80`=48,000/名义秒，状态B表示tone开启、无underflow、HDMI locked、曾见frame。包计数约26k、BCH错误约26k、TERC错误约86，flags D/CTS0/N0说明观察器未识别到正确ACR。各页不是同一窗口；tone_bad0不能证明坏包中的样本正确。初次代理把frame18读成D/6680已纠正，无依据推断PLL掉锁。

音频包观察器在PHY之前，源码和成功基线一致。该计数使排查范围包含HDMI core/观察器/时钟复位及物理实现，不能只归因串行输出。用户另报画面/OSD/字幕间歇消失且声音停止；视频未拍显示器，代理未听音频，以上明确作为用户反馈保留。

原失败版136文件检查点/压缩包、成功基线174文件检查点不改。源码审计只有top增加覆盖级和一个动态字幕模块，73旧源/音频/TF/PLL/引脚/SDC不改；当前约束没有exclusive。SPI输入延迟仍未建模，内部STA通过不替代外部信号验证。高slice占用98.76%是实现线索，不是已证根因。

精简字幕对照只合并两个互斥区域的字模组合逻辑，保留时序/像素功能，不改音频/TF/复位/约束。独立模型通过1843200像素及12000计时周期；日志在项目 `development/player_dynamic_text/build/failure_20261009/compact_renderer`。独立工程准备和编译继续进行，尚无新位流/实板结论。
''', encoding='utf-8')

state_path = records / '当前状态.md'
state = state_path.read_text(encoding='utf-8-sig')
lines = state.splitlines()
for i, line in enumerate(lines):
    if line.startswith('更新：'):
        lines[i] = '更新：' + now + '（北京时间）。' + line.split('。', 1)[1]
    if line.startswith('**2026-10-09动态字幕首版实板回归失败'):
        lines[i] = '**2026-10-09动态字幕首版实板回归失败（用户反馈），当前成功基线仍download/osd_phy_fix.bit。IMG0/4/无BMP或WAV、内部tone失真，同条件回载成功版恢复。数码管1D950007表明已挂载、BMP错误、WAV mapper提前EOC(07)；新视频3B00BB80显示内部tone输入48000/名义秒，但HDMI并行包观察器有大量BCH/少量TERC错误、未识别到正确ACR。用户另报画面/字幕消失时音频停止。原失败/成功检查点保留，源/时钟/物理审计未证实唯一根因；精简同功能字幕独立模型已通过，独立工程编译准备中。详见[失败排查进展](专题记录/OSD状态显示/动态字幕首版失败_20261009/排查进展.md)。**'
    if line.startswith('**2026-10-09动态字幕最小候选已完成本地模型'):
        lines[i] = '**历史构建结果（该候选现已实板FAIL，勿用作成功基线）：** ' + line.strip('*').replace('实板待验证。', '随后实板失败。').replace('待用户下载回归文字/图音/按键。', '失败反馈和排查进展见上。')
state_path.write_text('\n'.join(lines) + '\n', encoding='utf-8')
with (records / '工作日志/2026-10-09.md').open('a', encoding='utf-8') as log:
    log.write(f'''\n### {now[11:]}｜动态字幕失败视频与精简对照｜进行中

- 视频已原样存入专题首版失败目录并校验SHA256；抽帧字形复核frame18=3B00BB80，输入48000/名义秒、无underflow、HDMI locked。包/BCH约26k，TERC约86，未识别正确ACR；各页非同窗口，观察点在PHY前，不足以唯一归因。初次agent误读frame18已纠正，不作为掉锁证据。
- 用户补充OSD/滚动字幕间歇消失且声音停止；视频只拍板卡，显示器现象和听感记为用户反馈，代理未听音频。
- 独立精简renderer模型通过1843200像素/12000计时周期，仅共享字模通路、不改音频/TF/复位。独立工程准备中，尚未生成或交付新位流；成功/失败冻结产物不改。
- 下一步：新工程综合/布局布线、审查实际资源与原约束setup-hold；HDMI时钟路径只读复核继续。详细证据见专题[排查进展](../专题记录/OSD状态显示/动态字幕首版失败_20261009/排查进展.md)。
''')
print('Video archived and hashes checked; feedback, topic, status and log updated.')
