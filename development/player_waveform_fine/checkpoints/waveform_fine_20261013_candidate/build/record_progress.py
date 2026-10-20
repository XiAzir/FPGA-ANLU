from pathlib import Path
from datetime import datetime, timezone, timedelta
import re
import sys

docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
topic=docs/'专题记录/音频可视化/波形清晰度优化_20261013'
topic.mkdir(parents=True,exist_ok=True)
now=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
phase=sys.argv[1] if len(sys.argv)>1 else 'model_and_synthesis'
if phase == 'model_and_synthesis':
    message='C11301隔离开发已开始：C11206 verified268逐项SHA通过后复制有效源码与构建入口，未复制旧TD数据库。512列×2样本保持1024样本窗口，Q2幅值/四档边缘与相邻连通，物理波形仍57行。独立gold30229检查/29184图形像素通过；继承冻结回归3123检查和144000密集音频事件通过；真实音乐/参数/字幕/空白两帧叠加768000周期、58368图形像素通过。正式TD综合成功，波形为两个同步BRAM9K（1024×16裁零位），PCM缓冲四BRAM保留，整机29BRAM9K/14621LUT/8677reg。布局布线进行中，最终时序/位流/封存/实板未完成，成功基线仍C11206；动态双线原因未证实，未做硬件操作。'
    (topic/'README.md').write_text('''# C11301 波形清晰度优化

基线：[C11206五扩展总表](../../整机集成/C11206五扩展验收_20261012/README.md)。用户2026-10-13授权“下一步开始”，按后续清单推进可选质量优化。

## 目标与证据

原128组×4横向像素改512列×1像素，各列保留2样本极值，1024样本窗口与增益保持。幅值使用四分之一像素定位、四档青色边缘、相邻中点连通。输出仍640×480、图形仍57物理行；不宣称屏幕分辨率增加。冻结/换源/字幕/参数/缩放/转场保留；动态双线按既有已知项记录。

隔离工程：[player_waveform_fine](E:/VSCODE-project/FPGA-ANLU/development/player_waveform_fine/README.md)。[规格与预算](E:/VSCODE-project/FPGA-ANLU/development/player_waveform_fine/build/waveform_spec.md)、[父268项核验](E:/VSCODE-project/FPGA-ANLU/development/player_waveform_fine/build/parent_receipt.json)、[独立gold报告](E:/VSCODE-project/FPGA-ANLU/development/player_waveform_fine/build/model/wave_fine_report.txt)、[冻结回归](E:/VSCODE-project/FPGA-ANLU/development/player_waveform_fine/build/model/keyfreeze_wave.log)、[整机叠加模型](E:/VSCODE-project/FPGA-ANLU/development/player_waveform_fine/build/model/integration.log)。旧继承但未运行的模型不计本轮通过。

## 阶段记录

'''+now+'：'+message+'\n\n下一步完成原约束setup/hold检查、生成新候选、封存并交付用户相关板测。清晰度、音质、实际显示均待用户反馈；模型和STA不能替代板测。\n',encoding='utf-8')
else:
    raise ValueError('unsupported phase')
state=docs/'当前状态.md'
s=state.read_text(encoding='utf-8-sig')
s=re.sub(r'^更新：.*$',f'更新：{now}（北京时间；C11301波形清晰度本地开发/构建进行中，成功基线C11206）。',s,count=1,flags=re.M)
s=s.replace('## 当前阶段','## 当前阶段\n\n- '+message+' [本轮专题](专题记录/音频可视化/波形清晰度优化_20261013/README.md)。',1)
s=s.replace('下一步计划波形清晰度优化','波形清晰度优化已在C11301隔离工程启动，后续')
s=s.replace('波形清晰度质量优化（尚未开始，可跳过）','波形清晰度质量优化（C11301进行中，可跳过）')
s=s.replace('下一开发建议：单独推进波形分辨率/线条清晰度质量优化（尚未开始，可跳过）','当前开发：C11301隔离推进波形分辨率/线条清晰度质量优化')
state.write_text(s,encoding='utf-8')
log=docs/'工作日志/2026-10-13.md'
if not log.exists():log.write_text('# 2026-10-13 工作日志\n',encoding='utf-8')
with log.open('a',encoding='utf-8') as f:f.write('\n### '+now+'｜C11301波形清晰度｜模型/综合完成，布局布线进行中\n\n- 动作/证据：'+message+'\n- 详细规格/证据：[本轮专题](../专题记录/音频可视化/波形清晰度优化_20261013/README.md)。\n- 下一步：正式原约束setup/hold通过后才生成新候选，封存并交付用户板测。\n')
print(now,phase,'RECORDED')
