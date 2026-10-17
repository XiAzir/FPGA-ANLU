from pathlib import Path
from datetime import datetime, timezone, timedelta
import json, re
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
topic=docs/'专题记录/音频可视化/波形清晰度优化_20261013'
now=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
state=docs/'当前状态.md'
s=state.read_text(encoding='utf-8-sig')
s=s.replace('后续，再做稳定性/异常回归','后续做稳定性/异常回归')
s=s.replace('等待相关实板确认，动态双线按用户选择暂保留；优化版须保留C11206 verified回退，先规格/资源预算，再独立模型、正式构建及相关回归。','等待用户按操作卡下载并确认音画、HOLD/恢复和清晰度；规格/预算、模型、综合/时序及封存已完成，动态双线按用户选择暂保留，C11206 verified继续作回退。')
# Current entry stays concise; detail and hashes are already in topic receipts.
s=re.sub(r'^- C11301本地候选已封存、实板待验证。.*$', '- **C11301波形清晰度候选已本地交付、实板待验证**：512列/Q2边缘/连通，1024样本窗口及57物理行/增益保持；独立gold、冻结及音乐/参数字幕叠加模型通过。原约束SWNS+0.615ns/HWNS+0.019ns/TNS0/coverage99.97%，最终14910LUT/8791reg/29BRAM9K/8DSP；85源字节不变、3源变化。candidate175及ZIP已逐项SHA核验，C11206回退/快照/原ZIP不变。音画与清晰度待用户实测，动态双线成因未确认；未操作JTAG/TF/Flash。[专题与下载](专题记录/音频可视化/波形清晰度优化_20261013/README.md)。',s,count=1,flags=re.M)
state.write_text(s,encoding='utf-8')
note='交付复核中更正live工程README资源口径：14621LUT/8677reg属于综合阶段，最终物理为14910LUT/8791reg（29BRAM9K/8DSP）。原info/phy.area及资料交付记录已正确。冻结candidate175原README保留初版统计误标，正式值以其info/phy.area为准，源/bit/ZIP/清单未更改。'
with (topic/'README.md').open('a',encoding='utf-8') as f:f.write('\n## 统计口径更正\n\n'+now+'：'+note+'\n')
with (docs/'工作日志/2026-10-13.md').open('a',encoding='utf-8') as f:f.write('\n### '+now+'｜交付文字复核｜已完成\n\n- '+note+'\n- 实板状态仍待验证；下一步按C11301操作卡下载。\n')
print('CURRENT_ENTRY_AND_RESOURCE_LABEL_CORRECTION_RECORDED')
