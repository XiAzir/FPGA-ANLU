from pathlib import Path
from datetime import datetime, timezone, timedelta
import json

root=Path('E:/VSCODE-project/FPGA-ANLU')
project=root/'development/player_dynamic_text_video_probe'
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))
info=load(project/'build/manual/AC201_player_dynamic_text_video_probe.info.json')
audit=load(root/'deliverables/dynamic_text_video_probe_20261009.package_audit.json')
assert info['hardware_result']=='NOT_TESTED'
now=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
topic=docs/'专题记录/OSD状态显示/动态字幕资源版竖线_20261009/排查与诊断.md'
assert not topic.exists(), 'Do not duplicate records'
t=info['timing']; r=info['resources']
text=f'''# 动态字幕资源版底图竖线：运行时分层诊断

更新：{now}（北京时间）。诊断版本地完成，实板未测试；竖线尚未修复，原因尚未确认。

## 当前实板反馈

用户测试 `download/dynamic_text_fit.bit`（SHA256 028D9D9A742A2CD980ECBEA48FFBE824D89DA34CF6B2B3E66EA0AA42B6D6456D）：音乐、长按KEY1内部音阶、KEY0手动切图和KEY1自动轮播正常，但底图有规则浅灰竖线，OSD与滚动字幕覆盖区无同样线。用户区分弯曲相机摩尔纹与实物规则线，不把相机纹判为逻辑缺陷。同卡、供电、HDMI、显示器设置回载osd_phy_fix后竖线消失（用户反馈）。照片/反馈已保存 [feedback.json](feedback.json)；运行时长未实测。

## 静态结论与边界

候选与成功osd_phy_fix的BMP解码、RGB888 pack/unpack、帧缓存/FIFO、SDRAM封装、PLL、SDC/引脚源相同。动态模块在框外透传RGB，没有找到可在RTL复现的候选特有周期列错误。固定DQ路径两版setup 1.706ns/hold 12.301ns相同；这是hard-IP/PAD路由模型，不是实测波形。不能从sd_miso/HDMI IO delay缺项推出SDRAM DQ未约束；SDRAM藏在EG_PHY封装中，需单独核查其模型。综合undriven警告与共有TLAST off-by-one都存在于成功版，不能直接归因本次差分。

源审计：[stripe_readonly_audit](E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_fit/build/stripe_readonly_audit/audit.md)；时序审计：[stripe_timing_audit](E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_fit/build/stripe_timing_audit/report.md)。当前A/B证明故障随位流，但布局变化、输入字流、组合路径和输出电气的具体责任未定。

## 独立运行时诊断实现

新工程 `development/player_dynamic_text_video_probe` 从fit独立复制，未覆盖任何原成功/失败源码、bit或冻结检查点。76个user源中73个逐哈希相同；只改top和dynamic_text，新增小型player_video_source_probe并登记.al。复用原长KEY1事件，KEY0双触发器同步分流：单独长KEY1继续切音源，按住KEY0时长KEY1请求视频源切换；用pending奇偶及VS上升沿锁存处理同拍请求，不半帧切换。双键同低时屏蔽原BMP按键事件，KEY0先行按压可能切一次图，这是诊断操作允许的行为；同步判定边界附近松KEY0按当前同步值分流，未声称任意按键抖动鲁棒。

BMP读取/SDRAM/音频/PLL仍运行，不复位、不改采样相位、不改数据valid拍数。原OSD之前选择底图或内部常量：编号1/4白FFFFFF、2/4灰808080、3/4红FF0000、4/4绿00FF00。右上时间标题BMP为RUN，纯色为REF；时间和滚动/文字覆盖保持。该位流可在运行中比较底图与纯色，避免每种源重编译产生不同布局；整个诊断位流与旧fit相比仍有重新布局，若默认BMP已经干净不能声称找到旧原因。

## 本地验证

三个新Icarus模型通过：实际key_press_debounce缩阈值测试短KEY0/KEY1、单键长按tone一次、双键屏蔽、同步输入前后边界、释放重装、VS锁存及pending+新请求同拍奇偶、reset/BMP有效/4个24位常量；并行RUN/REF独立oracle核对1843200个像素，含透传/blank/滚动/VS；计时12000周期回归通过。模型是独立模块验证，不包含真实卡、加密HDMI/SDRAM及完整top。源码、testbench、日志SHA绑定见 [model_results](E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_video_probe/build/model_results.json)；[独立复核](E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_video_probe/build/probe_review/report.md)。

TD6.2.178840四阶段通过。首次综合自动规范新模块CompileOrder导致.al哈希变化，physical source guard拒绝继续；初次产物保存build/initial_project_normalization。只改变工程登记、HDL/IP/约束未变，重新综合绑定规范化.al后源快照守卫通过，没有绕过守卫。初始路由报告保存在build/prehold；原约束fix_hold后SWNS {t['SWNS_ns']}ns、HWNS {t['HWNS_ns']}ns，两TNS0、coverage {info['sta_coverage_percent']}%。未新增false path/exclusive。最终资源{r['lut']}LUT/{r['reg']}reg/{r['le']}LE/{r['bram9k']}BRAM9K。

## 产物

- 位流：[dynamic_text_video_probe.bit](E:/VSCODE-project/FPGA-ANLU/download/dynamic_text_video_probe.bit)，{info['bytes']}字节；SHA256 `{info['sha256']}`。
- 包：[dynamic_text_video_probe_20261009.zip](E:/VSCODE-project/FPGA-ANLU/deliverables/dynamic_text_video_probe_20261009.zip)，{audit['zip_bytes']}字节，SHA256 `{audit['zip_sha256']}`；含诊断bit、osd_phy_fix回退、操作说明与checksum，ZIP CRC/成员核验通过。
- 冻结检查点：`{audit['checkpoint']}`，{audit['frozen_files']}文件manifest逐字核验；旧174/136/148文件检查点全部哈希复核保持。新info/检查点状态为硬件NOT_TESTED。

## 实板下一步

用PROGRAM_SRAM下载英文路径新bit，现有TF素材/供电/HDMI/显示器不改。先记录RUN/BMP模式是否有同样线；先按住KEY0，再按住KEY1，保持两者约2秒，到REF后一起松开至少1.5秒；短KEY0逐个看四种参考色，AUTO时短KEY1回MANUAL。再双键长按回RUN，记录线是否返回，以及音乐是否持续。

同一bit中纯色干净而BMP仍有线，支持优先沿底图生成/缓存读流取证，但不能唯一证明哪一级。纯色同样有线，继续检查源mux后RGB/HDMI链和输出。默认BMP也已经干净，记录为诊断实现变化后故障未复现，不能代替对旧bit机制取证。若出现新的黑屏/无声，回载osd_phy_fix。当前成功基线仍osd_phy_fix；代理未操作板卡、TF或Flash。
'''
topic.write_text(text,encoding='utf-8')
statepath=docs/'当前状态.md'
state=statepath.read_text(encoding='utf-8')
state=state.replace('更新：2026-10-09 13:56:06（北京时间）。','更新：'+now+'（北京时间）。',1)
needle='## 当前阶段\n\n'
stage=f'**{now}竖线分层诊断版本地完成、实板待测：download/dynamic_text_video_probe.bit/SHA256 {info["sha256"]}。同一位流运行时BMP(RUN)/内部白灰红绿(REF)切换，不停卡/SDRAM/音频；三个模型通过，原约束SWNS {t["SWNS_ns"]}/HWNS {t["HWNS_ns"]}ns/TNS0，coverage {info["sta_coverage_percent"]}%。{audit["frozen_files"]}文件新检查点与ZIP校验通过，旧成功/失败174/136/148冻结保持。当前竖线未修复、根因未确认，成功基线仍osd_phy_fix；下一步保持条件下载诊断bit，比较RUN与REF是否有相同线，操作与边界见[排查与诊断](专题记录/OSD状态显示/动态字幕资源版竖线_20261009/排查与诊断.md)。**\n\n'
assert needle in state
state=state.replace(needle,needle+stage,1)
state=state.replace('单项FAT mapper位宽资源候选本地已完成，实板待测（见下）','单项FAT mapper位宽资源候选实板音频/按键正常但底图竖线失败，已准备运行时分层诊断（见上）')
nextneedle='## 下一步\n\n'
assert nextneedle in state
state=state.replace(nextneedle,nextneedle+'当前优先：按上述竖线诊断步骤测试dynamic_text_video_probe；底图和纯色同一位流对照，回报条纹和音乐。该测试前不推进新显示功能。以下长期/扩展安排继续保留为待执行计划。\n\n',1)
statepath.write_text(state,encoding='utf-8')
with (docs/'工作日志/2026-10-09.md').open('a',encoding='utf-8') as f:
    f.write(f'\n### {now.split()[1]}｜底图竖线运行时分层诊断｜本地完成，实板待测\n\n- 动作：只读源/SDRAM模型审计未找到候选特有像素错误；独立player_dynamic_text_video_probe，73原源相同、2改动、1新增，RUN底图/REF四参考色在原OSD前切换，卡/SDRAM/音频继续运行。双键长按切视频源，单KEY1长按仍切tone。\n- 证据：真实debounce缩阈值控制模型、1843200像素RUN/REF oracle、12000周期timer均通过；TD四阶段通过。首次.al规范化触发source guard，初次产物保留后重综合绑定，不绕过guard；原约束fix_hold后SWNS {t["SWNS_ns"]}/HWNS {t["HWNS_ns"]}ns/TNS0、coverage{info["sta_coverage_percent"]}%，{r["lut"]}LUT/{r["reg"]}reg/{r["le"]}LE/19BRAM。\n- 产物：download/dynamic_text_video_probe.bit {info["bytes"]}bytes/SHA{info["sha256"]}；{audit["frozen_files"]}文件checkpoint及ZIP成员CRC/hash验证完成，旧174/136/148文件manifest保持。\n- 未完成：实板未测、竖线未修复、根因未确认；单模块模型/STA不证明电气波形。新布局可能令BMP故障不再复现，不能据此称旧原因已证。未操作板卡/TF/Flash。\n- 下一步：同条件测试RUN/BMP、REF白灰红绿、回RUN与音乐，失败回载osd_phy_fix；详细操作/审计/包哈希见[专题](../专题记录/OSD状态显示/动态字幕资源版竖线_20261009/排查与诊断.md)。\n')
print(str(topic))
