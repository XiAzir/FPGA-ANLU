from pathlib import Path
import datetime, json

project = Path(r'E:\VSCODE-project\FPGA-ANLU')
docs = Path(r'E:\QQ CACHE\Download\安路资料\开发记录')
candidate = project/'development/player_dynamic_text_axis_last_fix'
probe = project/'development/player_dynamic_text_video_probe'
now = datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
topic = docs/'专题记录/OSD状态显示/动态字幕资源版竖线_20261009'
topic.mkdir(parents=True, exist_ok=True)

feedback = {
    'recorded_beijing': now, 'hardware_result': 'FAIL_HDMI_NO_SIGNAL_WARM_AND_COLD',
    'source': 'User board feedback plus manually decoded local video frames; no agent board operations',
    'bitstream': str(project/'download/dynamic_text_video_probe.bit'),
    'sha256': '1EFEB04BD50035789E4EBD1430B3CB8736B0F48D93DAF24FD4013AB8130F30DF',
    'warm_run': {
        'user_report': 'HDMI no signal; D3/D2/D1/D0 all off; BitWriter succeeded; same-condition osd_phy_fix rollback normal',
        'video': r'E:\QQ CACHE\LiaoTianJiLu\Tencent Files\1791081637\nt_qq\nt_data\Video\2026-10\Ori\614ca6d63c9bf6ac23731e3645134634.mp4',
        'video_sha256': '78F5D8C603C0F1DFAD996CC1A9C88A99513B71F7E965E725A49514DBCD74055F',
        'decoded': {'12.20': '1C000000', '14.20': '31000000', '16.20': '69000000', '4.20': '9900423E', '5.35': '990045F8'},
        'meaning': 'Both PLL lock bits high, global reset low; card init incomplete. Frame start seen but HDMI core input video unlocked, input audio count 0; monitor accepted audio samples 0, TERC errors observed.',
        'evidence': str(project/'build/board_video_20261009_nosignal/summary.json')
    },
    'cold_tone_run': {
        'user_report': '5-second power cycle and same bit redownload: all LEDs on, still HDMI no signal; 1DA80000; long KEY1 makes D3 blink, others remain on, still no signal',
        'video': r'E:\QQ CACHE\LiaoTianJiLu\Tencent Files\1791081637\nt_qq\nt_data\Video\2026-10\Ori\3c9f7f88035a4f6e280bd5f928e3c91c.mp4',
        'video_sha256': '459A8AE89C0FB0506172DCA3E588E711DFBD33C7CC70916A33F36BEFA14DDD4C',
        'decoded': {'0.20': '1DA80000', '2.20/2.70/3.20/3.70': '3900BB80', '4.20': '69000000', '6.20': '79000000', '8.20': '89000000', '10.20': '99003232', '11.20': '9900368F', '12.20': 'A9000000', '14.20': 'B9000000', '16.20': 'C9000000'},
        'meaning': 'Card initialized, fs_ready/display_valid/wav_primed high and captured error fields zero. Internal tone input 48000 per nominal second; frame start seen, core video lock 0. Monitor accepted audio samples/packets and CTS/N 0; TERC errors observed.',
        'glyph_note': 'BB80, not 6680: B uses lower-case b-shaped seven-segment glyph with top segment off; checked multiple raw frames and status_hex595 RTL.',
        'evidence': str(probe/'build/board_video_20261009_cold_tone')
    },
    'limits': ['The two videos are different runs and are not combined into a simultaneous ratio.', 'PLL/core/status bits and packet observer are internal RTL observations, not electrical HDMI carrier measurements.', 'Zero BCH/tone_bad is not evidence of correct encoding when no audio packet is accepted.', 'Audio metadata was read; the agent did not listen to these recordings.', 'LEDs record events and cannot establish receiver audio/video correctness.'],
    'root_cause': 'NOT_CONFIRMED', 'agent_card_or_flash_operations': 'NONE'
}
for path in (probe/'build/board_feedback_20261009_nosignal.json', topic/'video_probe_feedback.json'):
    path.write_text(json.dumps(feedback, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
info_path = probe/'build/manual/AC201_player_dynamic_text_video_probe.info.json'
info = json.loads(info_path.read_text(encoding='utf-8-sig'))
info.update(hardware_result=feedback['hardware_result'], status='Board FAIL: warm and cold HDMI no signal; stable osd_phy_fix rollback normal; root cause not confirmed', updated_beijing=now, board_feedback=str(probe/'build/board_feedback_20261009_nosignal.json'))
info_path.write_text(json.dumps(info, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
prep_path = candidate/'build/preparation.json'
prep = json.loads(prep_path.read_text(encoding='utf-8-sig'))
prep.update(candidate_model='PASS: actual candidate source; 2 frames/960 lines/614400 pixels, 960 TLAST versus old 0; SOF/data/valid alignment retained', td_build='SYNTHESIS_PASS_PHYSICAL_RUNNING', updated_beijing=now)
prep_path.write_text(json.dumps(prep, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')

report = f'''# 视频源诊断版无信号：取证与行结束标记对照

更新：{now}（北京时间）。原视频源诊断版实板失败；新单项修正候选正在布局布线，尚未生成/测试新位流。成功基线仍为 `download/osd_phy_fix.bit`。

## 两次运行必须分开判断

用户确认 probe 的 BitWriter 下载成功；同卡、供电、HDMI 条件回载 osd_phy_fix 恢复正常。首次视频 `614ca6d...mp4`：12.20秒 `1C000000`（两PLL锁定位高、全局reset低、卡未初始化），14.20秒 `31000000`（帧起始曾到达、HDMI核输入视频未锁定、音频样本0），16.20秒 `69000000`（包内音频样本0）。4.20/5.35秒TERC计数为0x423E/0x45F8。四灯全灭来自用户反馈，不直接等于reset或PLL异常。

断电5秒、再下载同一probe后，用户反馈四灯全亮，但仍无信号；以1开头页 `1DA80000`。长KEY1后D3闪烁，另三灯常亮，仍无信号。新视频 `3c9f7f...mp4` 0.20秒仍 `1DA80000`：卡已初始化，文件系统ready、底图valid、WAV primed高，当前捕获的文件错误字段0。2.20至3.70秒多帧为 **3900BB80**：内部tone模式、无underflow、HDMI核输入未锁、帧起始曾到达，输入48000样本/名义秒。B为小写b形，顶段不亮，不能读成6。4.20秒 `69000000`、6.20秒 `79000000`：观察器接受的音频样本及包数均0；10.20/11.20秒 `99003232`/`9900368F`；BCH、tone_bad、CTS及N捕获值均0。所有包页flags9表示曾识别island、未识别有效audio/ACR且曾有format error。无被接受音频包时BCH/tone_bad为0不能证明编码正常。

两视频属于不同启动，不能拼成同一窗口的统计；每秒为25MHz参数定义的名义窗口，未测实际频率。HDMI核locked是输入视频时序/相位锁定，不是PLL锁定，也不是外部差分载波测量。代理只查看帧和音轨元数据，没有直接听音或测量板上引脚。具体字符串/时间/哈希见 [反馈JSON](video_probe_feedback.json)；原帧与各报告保留在工程路径。

## 已排除和未证实

源快照80项和原封存保持一致；只读最终路由审计未发现新增PLL/reset/SD/HDMI引脚断接。卡未初始化可以解释首次无BMP/WAV，但冷启动卡已ready仍无信号，不能把整个故障归因卡。此前提出CMD0/8失败后cmd_req高会锁死的推测已由实际两模块错误R1注入排除：S_END无条件回S_WAIT，四场景通过；SPI stub不等于实物PHY验证。

路由导出中成功/probe均没有保留可识别TLAST名字，不能由文本搜索区分加密核未使用、常量折叠或重命名。模型和时序通过均不代替板测。竖线问题仍未修复；原RUN/REF诊断由于无信号未完成。

## 单项候选及确定缺陷

新目录 `development/player_dynamic_text_axis_last_fix` 从probe隔离复制，76个user源中75个逐哈希不变，只把 `video_rgb_to_axis_640x480.v` 比较值639改638。非阻塞赋值读取旧计数值：一行第1像素将计数设0，到第640像素进入时旧值是638；原比较639不会发TLAST。未改变接口、像素/valid一拍延迟、SOF、PLL、引脚、SDC、卡/音频/OSD逻辑。原有成功版也有该缺陷，故它是确定接口错误，但不是已证实的本次差分根因；重构建本身会改变物理布局。

实际候选源的模型已执行通过：实际color_bar/video_timing_data/video_delay连续两帧960行614400像素，旧TLAST0、新TLAST960、SOF2，数据/valid一拍对齐；另测试639像素短行、随后完整行、300像素中断复位、VS边沿重新arm。实际timing模块启动一拍X，模型额外保持转换器复位40拍后检测完整帧；不覆盖完整top启动、真实卡、加密HDMI、SDRAM电气或输出串行波形。 [模型日志](E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_axis_last_fix/build/axis_model/run.log)及source_bindings绑定实际源。综合成功；原约束布局布线进行中，板测未执行。

## 接续

保持原成功/失败检查点及ZIP历史快照；live probe info已改为实板FAIL，原包中的NOT_TESTED仅代表当时封存状态。完成新候选原约束setup/hold、位流守卫和独立复核后，再用相同TF/接线/音量做冷启动对照。无需改TF文件，不操作Flash。
'''
(topic/'视频源诊断无信号.md').write_text(report, encoding='utf-8')
entry = f'**{now}视频源probe实板FAIL（热下载/冷启动均HDMI无信号），同条件osd_phy_fix回退正常。冷启动1DA80000表明卡/文件/BMP/WAV状态ready；内部tone视频3900BB80=48000样本/名义秒、HDMI核输入未锁、包内样本0、TERC错误。只读审计与SD失败注入未确认唯一根因。已隔离单项TLAST比较639→638候选player_dynamic_text_axis_last_fix，实际源两帧模型及综合通过，布局布线进行中、未生成/板测。成功基线仍osd_phy_fix；详见[无信号取证](专题记录/OSD状态显示/动态字幕资源版竖线_20261009/视频源诊断无信号.md)。**'
state_path = docs/'当前状态.md'
state = state_path.read_text(encoding='utf-8-sig')
state = state.replace('更新：2026-10-09 14:37:11', '更新：'+now, 1)
start = state.index('**2026-10-09 14:37:11竖线分层诊断')
end = state.index('\n\n', start)
state = state[:start]+entry+state[end:]
old_priority = '当前优先：按上述竖线诊断步骤测试dynamic_text_video_probe；底图和纯色同一位流对照，回报条纹和音乐。该测试前不推进新显示功能。以下长期/扩展安排继续保留为待执行计划。'
new_priority = '当前优先：完成单项TLAST修正对照候选的原约束STA/位流，再做冷启动实板对照；probe无信号，原BMP/REF诊断尚未完成。成功基线仍osd_phy_fix，动态字幕/竖线/唯一根因均未完成，不推进新显示功能。以下长期/扩展安排保留为待执行计划。'
assert old_priority in state
state_path.write_text(state.replace(old_priority,new_priority), encoding='utf-8')
old_topic = topic/'排查与诊断.md'
text = old_topic.read_text(encoding='utf-8-sig')
text = text.replace('更新：2026-10-09 14:37:11（北京时间）。诊断版本地完成，实板未测试；竖线尚未修复，原因尚未确认。', f'更新：{now}（北京时间）。诊断版已实板FAIL：热下载/冷启动均HDMI无信号，RUN/REF对照未完成；竖线/根因尚未解决。新单项TLAST候选正在构建，见[无信号取证](视频源诊断无信号.md)。')
text = text.replace('新info/检查点状态为硬件NOT_TESTED。', '原检查点/ZIP的NOT_TESTED是构建时历史快照；live info已更新为实板FAIL。')
old_topic.write_text(text,encoding='utf-8')
with (docs/'工作日志/2026-10-09.md').open('a',encoding='utf-8') as f:
    f.write(f'''\n### {now[11:]}｜probe冷热启动无信号取证与TLAST单项候选｜进行中（模型/综合通过）

- 用户同条件osd_phy_fix回退正常，probe下载succeeded。首视频1C000000/31000000为卡未初始化、帧曾到达但核输入未锁、音频输入0；冷启动用户1DA80000/四灯亮仍无信号，新视频3900BB80为内部tone输入48000/名义秒、核未锁，包样本0、TERC错误。B小写字形已多帧与RTL比对，不能误读6。两个运行分开记录。
- 已将probe live info改实板FAIL并写[反馈与取证](../专题记录/OSD状态显示/动态字幕资源版竖线_20261009/视频源诊断无信号.md)；原140文件检查点/ZIP不覆盖。源/物理只读审计未确认新断接，SD错误R1重试模型排除此前deadlock推测，未覆盖实际PHY。
- 确定共有TLAST off-by-one：639旧比较在640有效行不产生last。独立player_dynamic_text_axis_last_fix仅比较639→638，75/76原源不变；实际源两帧614400像素/960行测试旧last0新last960，SOF/data/valid对齐及短行/复位测试通过；综合完成，布局布线进行中。启动X用模型额外40拍复位隔离，不计整机启动验证。
- 未完成：新位流尚未生成/板测，TLAST错误亦存在成功版，不能称本次唯一根因。成功基线仍osd_phy_fix，竖线RUN/REF测试未完成；未写TF/Flash或直接操作板卡。
- 下一步：完成原约束setup/hold与守卫/独立审核后交付单项对照bit，再让用户同条件冷启动验证。
''')
print(json.dumps({'recorded_beijing':now,'probe_live_result':info['hardware_result'],'candidate':prep['td_build'],'docs_updated':True},ensure_ascii=False))
