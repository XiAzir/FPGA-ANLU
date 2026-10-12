from pathlib import Path
from datetime import datetime,timezone,timedelta
import json
records=Path('E:/QQ CACHE/Download/安路资料/开发记录')
now=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
p=records/'当前状态.md'
s=p.read_bytes().decode('utf-8-sig')
s=s.replace('更新：2026-10-11 13:41:55（北京时间；双分支发布后本机已切回 XiAzir，原实板开发状态未变）。','更新：'+now+'（北京时间；本机继续 XiAzir，cadence_probe 实板失败已取证）。',1)
start=s.index('**2026-10-10 cadence_probe')
end=s.index('**',start+2)+2
replacement='**2026-10-11 cadence_probe 冷启动实板仍无信号（用户反馈），两段视频已完成全部9页解码。1D400800 指向 FAT32 扇区读取超时08；默认四灯全灭、新观察器未见音频事件。内部音阶间隔520/521、每帧806、帧周期420000、窗口半速12500000、窗口样本48000，串行前clock word=01F且未计错误。旧页3为33020000/3B02BB80，较独立计数0/48000多固定bit17=0x020000；静态源码/最终网表未找到固定置1，实际产生级未定位。当前优先对相同位流尝试BitWriter Verify SRAM配置回读校验并看完整日志；工具文档列有此功能，器件支持/运行影响未确认，不能预判配置错误。成功基线仍osd_phy_fix，无新位流、未写TF/Flash。原124文件checkpoint与ZIP保留，live info改FAIL。见[本轮读数与下一步](专题记录/OSD状态显示/节奏诊断实板失败_20261011/实板读数与下一步.md)。**'
s=s[:start]+replacement+s[end:]
old='当前优先：cadence_probe 已生成并封存，等待本候选实板读数。按[本轮说明](专题记录/OSD状态显示/动态字幕资源版竖线_20261009/节奏诊断候选_20261010.md)冷启动重新 PROGRAM_SRAM 下载 download/cadence_probe.bit，等待 10 秒，默认和单独长 KEY1 切内部音阶后各录约 25 秒数码管；报告显示器/声音现象。此前 axis_probe 两视频足够，无需重录旧页。新候选实板未测，成功基线仍 osd_phy_fix，动态字幕/底图竖线/无信号唯一根因未完成。'
new='当前优先：cadence_probe 两视频已覆盖全部页，冷启动仍失败，勿再索要相同视频。先尝试用当前候选相同文件做 Verify SRAM，取完整日志区分配置匹配/比对失败/禁止或不支持；见[本轮说明](专题记录/OSD状态显示/节奏诊断实板失败_20261011/实板读数与下一步.md)。随后依证据处理配置问题或向串行/TMDS实际输出取证。成功基线仍 osd_phy_fix；动态字幕、底图竖线、无信号及旧统计偏差的唯一根因未确认。'
assert old in s
s=s.replace(old,new,1)
p.write_bytes(s.encode('utf-8'))
p=records/'专题记录/OSD状态显示/动态字幕资源版竖线_20261009/节奏诊断候选_20261010.md'
s=p.read_bytes().decode('utf-8-sig')
s=s.replace('2026-10-10。状态：本地 RTL 模型、最终时序与位流生成通过，实板待测；这是诊断候选，无信号和底图竖线的根因尚未确认。当前实板功能回归通过基线仍为 `osd_phy_fix.bit`。','2026-10-11 更新：本候选冷启动实板仍无信号，视频显示文件读取超时08及旧统计页固定bit17偏差；内部音阶新节奏计数正常。最新证据见[实板读数与下一步](../节奏诊断实板失败_20261011/实板读数与下一步.md)。下文保留2026-10-10构建时说明与当时板测步骤；不用重复录制。当前成功基线仍为 `osd_phy_fix.bit`。',1)
s=s.replace('下一步依赖本候选实板读数。结果未返回前，不把该候选记为修复成功。','实板读数已于2026-10-11返回，见文首链接；候选仍失败，不记为修复成功。')
p.write_bytes(s.encode('utf-8'))
entry=f'''

### {now[11:16]}｜cadence_probe 冷启动失败视频取证｜解码完成，根因排查继续

- 用户反馈：长KEY1前后显示器仍无信号，之前四灯全灭；明确已断电再上电下载。视频前25.567056秒、后18.068544秒均已归档并SHA校验，fps2提帧及18个代表全帧保存，两视频足够覆盖全部页，不需补录。
- 读数：两模式1D400800=文件系统扇区超时08；默认新观察器无音频事件，内部tone 6F208209/7F000326/8FBEBC20/9F0668A0/AF00BB80/BF00001F/CFC10902，分别支持520/521、806/帧、25M窗口48000、串行前clock word01F。旧页3 33020000/3B02BB80 与新计数差固定0x020000。B为顶部a段熄灭的小写b字形，已与自检6及B页首位比对。
- 动作/证据：81项当前源与构建清单匹配，download/build位流SHA均8C56A7D24F2D719835369720D7403DE3F55150E07C454CBA3182EE47D230E17C，ID C10902；不等于板内配置逐位校验。只读查源码及routed bit17 count/mailbox/received/mux连接，没有发现固定置1；未跑新仿真、重新构建或操作板卡。live info改BOARD_FAIL，冻结124文件及原ZIP保留。
- 记录：[本轮读数与下一步](../专题记录/OSD状态显示/节奏诊断实板失败_20261011/实板读数与下一步.md)、同目录feedback.json及原视频；工程build/board_feedback_20261011含提帧脚本/原帧/手册审计。
- 未完成：不能定位超时具体事务、旧诊断bit17产生级、实际串行/TMDS电气输出或唯一根因。内部tone节奏正常不证明PCM/包/显示端正常；本版未重现上版471xx，不把两版证据混用。用户冷启动已确认，不再单归因热下载残留。
- 下一步：本机SWUG110列有Verify SRAM配置回读校验（不含用户ERAM）；优先用户以同一候选做该校验并给完整日志，若菜单不支持则记录，不替换成Flash动作。器件适用/运行影响未从手册确认，不能预判下载错误；根据匹配或错误结果再定位输出。成功基线仍osd_phy_fix，TF/Flash未操作。
'''
with (records/'工作日志/2026-10-11.md').open('a',encoding='utf-8') as f:f.write(entry)
print('Updated current status, topic history and daily log.')
