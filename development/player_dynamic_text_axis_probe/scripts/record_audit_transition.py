from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[3] / 'scripts'))
from anlu_paths import REPOSITORY_ROOT, DOCS_ROOT, recorded_path, require_file
import json, datetime

root=REPOSITORY_ROOT
docs=(DOCS_ROOT / '开发记录')
topic=docs/'专题记录/OSD状态显示/动态字幕资源版竖线_20261009'
old=root/'development/player_dynamic_text_axis_last_fix'
now=datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
prep_path=old/'build/preparation.json'
prep=json.loads(prep_path.read_text(encoding='utf-8-sig'))
prep.update(td_build='SYNTHESIS_PHYSICAL_HOLD_PASS_BITGEN_INTENTIONALLY_NOT_RUN',status='NOT_RELEASED: no effective routed-netlist difference versus failed video probe', updated_beijing=now,
            final_timing={'SWNS_ns':0.505,'STNS_ns':0.0,'HWNS_ns':0.024,'HTNS_ns':0.0},
            normalized_route_sha256='8E894B5FC25B745A658FCED4F98AB332C5C76B2B472C7D4DD3CCDF93F5C33AD6',
            route_diff_lines=0,bitstream_generated=False,hardware_result='NOT_TESTED_NOT_RELEASED',
            independent_audit=str(old/'build/independent_audit/final_review.md'),
            next_candidate=str(root/'development/player_dynamic_text_axis_probe'))
prep_path.write_text(json.dumps(prep,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
report_path=topic/'视频源诊断无信号.md'
report=report_path.read_text(encoding='utf-8-sig')
first='原视频源诊断版实板失败；新单项修正候选正在布局布线，尚未生成/测试新位流。'
assert first in report
report=report.replace(first,'原视频源诊断版实板失败；TLAST单项修正模型/综合/布局布线/原约束hold通过，但最终网表没有硬件差分，已停止位流生成和交付。新的输入统计观察候选正在验证，尚未板测。',1)
report=report.replace('更新：2026-10-09 15:20:00','更新：'+now,1)
report+=f'''\n## {now}：TLAST对照无有效实现差分，停止交付

单项候选综合、布局布线完成；初始hold -0.052/-0.092ns报告与DB保存prehold，原约束fix_hold后SWNS0.505/HWNS0.024ns、TNS0、coverage99.97%。当前80项source scope逐hash通过，确认638生产源已登记且综合日志分析了该模块。

独立审计从新最终DB只读write_verilog导出；与旧probe的210258行导出逐行比较，只去掉生成时间一行，其余逻辑/位置/路由元数据完全相同（0 diff），双方归一SHA256 **8E894B5FC25B745A658FCED4F98AB332C5C76B2B472C7D4DD3CCDF93F5C33AD6**。这一结果与TLAST被综合裁剪/没有可观察作用一致，但不解密或断言加密核内部如何消费接口；完整可复核方法在[最终审计](../../../../../FPGA-ANLU/development/player_dynamic_text_axis_last_fix/build/independent_audit/final_review.md)。

因此不把它当可用实板对照，**未运行bitgen、未生成下载bit/ZIP、未让用户再测试**。源码错误及模型修正证据保留；不能把模型PASS写成无信号已修复。原174/136/148/140共598文件冻结检查点及旧四份download bit逐项hash守卫通过，视频JSON及关键帧复制到本目录nosignal_evidence。

新目录 `development/player_dynamic_text_axis_probe` 从未修正probe隔离复制：74旧源不变，top替换被动输出包监视器为被动输入接口监视器，status页B/C载荷改24位，新添一观察模块。原converter639保持，不混入TLAST修正；HDMI核、PLL/SDC/pin、卡/图片/音频/OSD/控制源保持。页6..C现在读行宽/行数、帧周期、帧像素、坏行/坏帧、行消隐/ready-low、last总数、异常USER/帧起始次数。实际源三帧观察器模型通过，状态页模型/独立集成审核进行中，TD尚未运行、实板未测。该变化会改输入fanout/资源/物理布局，若候选恢复正常不等于已找出旧物理根因。
'''
report_path.write_text(report,encoding='utf-8')
state_path=docs/'当前状态.md'
state=state_path.read_text(encoding='utf-8-sig')
state=state.replace('更新：2026-10-09 15:20:00','更新：'+now,1)
start=state.index('**2026-10-09 15:20:00视频源probe')
end=state.index('\n\n',start)
replacement=f'**{now}probe冷热启动实板HDMI无信号，成功基线仍osd_phy_fix。冷tone输入48000/名义秒、卡ready、核未锁、包样本0。TLAST单项模型及原约束STA通过，但最终210258行路由导出除时间外与旧probe完全相同，未形成硬件差分，已停止bitgen/交付（未板测）。现独立player_dynamic_text_axis_probe用输入统计替换包观察器，74源不变/2改/1新，三帧模型通过，集成/状态页验证进行中、TD/板测未完成。根因和竖线仍未解决；详见[无信号取证](专题记录/OSD状态显示/动态字幕资源版竖线_20261009/视频源诊断无信号.md)。**'
state=state[:start]+replacement+state[end:]
state=state.replace('当前优先：完成单项TLAST修正对照候选的原约束STA/位流，再做冷启动实板对照；probe无信号，原BMP/REF诊断尚未完成。', '当前优先：完成被动视频输入统计candidate的集成模型/原约束STA和实板对照；TLAST源修改最终网表相同，停止交付；probe无信号，原BMP/REF诊断尚未完成。')
state_path.write_text(state,encoding='utf-8')
with (docs/'工作日志/2026-10-09.md').open('a',encoding='utf-8') as f:
    f.write(f'''\n### {now[11:]}｜TLAST候选最终网表无差分，转视频输入统计｜已完成审核/新候选进行中

- 单项638修正原约束STA通过（SWNS0.505/HWNS0.024ns/TNS0、coverage99.97%）；初始hold失败DB/报告保留prehold。80项scope与源全匹配，确认实际编译638。
- 独立只读导出与未修正probe最终网表比较：210258行，只跳过生成时间，其余逻辑及位置/路由元数据0 diff，归一SHA8E894B5FC25B745A658FCED4F98AB332C5C76B2B472C7D4DD3CCDF93F5C33AD6；与综合裁剪/无可观察作用一致，不断言加密核内部语义。故停止bitgen/交付，未生成bit/ZIP，不要求无效板测。实际源模型修复仍保留，根因未确认。
- 原174/136/148/140共598冻结文件及4旧download bit哈希核对保持；视频JSON/关键帧已复制专题。详见[取证](../专题记录/OSD状态显示/动态字幕资源版竖线_20261009/视频源诊断无信号.md)。
- 新player_dynamic_text_axis_probe只替换被动监視器：74旧源不变、top/status两改、一新增，原converter639及核/PLL/SDC/pin/卡/音频/按键源不改；实际三帧模型PASS，状态页/集成复核进行中，TD与板测尚未做。候选改变fanout/布局，恢复不能唯一证明旧原因。
- 下一步：确认观察器与数码管页绑定后，原约束构建/封存，冷启动同条件输入时序对照。成功基线仍osd_phy_fix，TF/Flash未操作。
''')
print(json.dumps({'recorded_beijing':now,'axis_last_fix':'NOT_RELEASED_NO_ROUTED_DIFF','next_candidate':'player_dynamic_text_axis_probe'},ensure_ascii=False))
