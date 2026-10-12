from pathlib import Path
import sys

for _anlu_root in Path(__file__).resolve().parents:
    if (_anlu_root / 'scripts' / 'anlu_paths.py').is_file():
        sys.path.insert(0, str(_anlu_root / 'scripts'))
        break
from anlu_paths import DOCS_ROOT, REPOSITORY_ROOT, recorded_path

from datetime import datetime
from zoneinfo import ZoneInfo
import re
docs=DOCS_ROOT / '开发记录'
topic=docs/'专题记录/图片缩放/多尺寸最近邻首版_20261012'
now=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M:%S')
message=f'''{now} C11206首次真实loader六帧1843200像素gold与四种真实错误输入通过，绑定engine9846713515DDADFC9D5F9B758F76E68CE7B3E80B0A08A247965016399974358C、loader9CDDACB2F20A36D2E066EB74BF8FE55C5D675115281CE73B7D64EDAD3B8F93DF，first_pass receipt保留。修复了首轮黑边X（黑边行未抑制row读取）、portrait错误offy及底黑边进入首content的相位；奇数黑边/正负高度/padding/背压等已逐像素覆盖。首次TD综合17897LUT/25BRAM/8DSP，scale仅sector1BRAM，row映射分布式存储；place返回BUILD_ERROR空文本，未取得可交付最终时序/位流，不能唯一确定place失败机制。旧gate/DB/报告/日志保留build/initial_ram_mapping/manual。新engine增加ram_style="bram"、独立无reset同步write与10bit行RAM索引，SHA A6C607738DB921E02C3D717F9C6CC9044CC3DDBC4FA02DD90B253FB541EF2C4D；smoke/elaboration再次通过，新全量gold/综合正在运行。无JTAG/TF/Flash操作，成功基线仍C11205。下一步正式BRAM映射、原约束setup/hold与最终hash封存候选，板测未完成。'''
with (topic/'README.md').open('a',encoding='utf-8') as f:f.write('\n## RAM映射迭代\n\n'+message+'\n')
with (docs/'工作日志/2026-10-12.md').open('a',encoding='utf-8') as f:f.write('\n### '+now+'｜C11206功能模型通过与RAM迭代｜进行中\n\n- '+message+'\n')
state=docs/'当前状态.md';s=state.read_text(encoding='utf-8');s=re.sub(r'^更新：.*$',f'更新：{now}（北京时间；XiAzir；C11206 RAM映射迭代/新gold与综合进行中，成功基线C11205）。',s,count=1,flags=re.M);s=s.replace('## 当前阶段','## 当前阶段\n\n**'+message+' [缩放专题](专题记录/图片缩放/多尺寸最近邻首版_20261012/README.md)。**',1);state.write_text(s,encoding='utf-8')
print(now,'RAM iteration recorded')
