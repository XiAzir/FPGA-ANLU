from pathlib import Path
from datetime import datetime,timezone,timedelta
import json,re
p=Path(__file__).resolve().parent
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
stamp=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
phase='模型与TD物理通过，ROM控制有效逻辑核对中；未交付/上板'
line='C11310独立FFT局部恢复候选：默认4096看门狗/521clk真实节奏恢复测试、312合成+48真实WAV+72集成段零定点误差、650像素/遥测/16诊断页及595引脚模型PASS；保留五位binary/default。TD同源syn/phy/nativehold成功，SWNS+0.236/HWNS+0.027ns/TNS0，17001LUT/10085reg/18508LE/44BRAM/12DSP/3GCLK。gate/routed各45时钟检查与1536系数INIT通过；逐字ROM控制审计发现Hann CEAMUX及twiddle CSA2/CSB2 SIG→INV，原始FAIL保留，正在验证动态控制锥/有效极性，尚未放行bit/ZIP。现有音画生产源继承C11309，只改FFT/analyzer wrapper/top诊断/status共4源。真实板上FFT停滞原因仍未证实；加速模型timeout0不能替代单独生产4096测试；未protected BRAM行为仿真/JTAG/TF/Flash。'
status=docs/'当前状态.md'
s=status.read_text(encoding='utf-8-sig')
s=re.sub(r'^更新：.*$',f'更新：{stamp}（北京时间；C11309音画正常、频谱空；C11310{phase}）。',s,count=1,flags=re.M)
s=re.sub(r'^- \*\*C11310 FFT局部恢复候选.*$',f'- **C11310 {phase}**：{line}',s,count=1,flags=re.M)
status.write_text(s,encoding='utf-8')
with (docs/'工作日志/2026-10-14.md').open('a',encoding='utf-8') as f:
 f.write(f'\n### {stamp[11:16]}｜C11310物理与ROM控制核对｜进行中\n\n- {line}\n- 下一步：按实际五位状态及组合控制锥核对所有32种状态下BRAM有效enable；不能以参数变化本身判定故障，也不能忽略原始FAIL。有效连接通过才生成并封存下载候选，稳定C11309/C11206回退保留。\n')
print('Current local stage recorded')

