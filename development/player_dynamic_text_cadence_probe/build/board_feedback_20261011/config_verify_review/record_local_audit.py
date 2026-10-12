from pathlib import Path
from datetime import datetime, timezone, timedelta
import shutil
import json

repo = Path('E:/VSCODE-project/FPGA-ANLU')
work = Path(__file__).parent
docs = Path('E:/QQ CACHE/Download/安路资料/开发记录')
topic = docs / '专题记录/OSD状态显示/节奏诊断实板失败_20261011'
model = work.parent / 'mapped_status_model'
stamp = datetime.now(timezone(timedelta(hours=8)))
assert 'selector=0 no-audio bit-17 mux truth' in (model / 'report.txt').read_text(encoding='utf-8')
assert json.loads((work / 'check_page17_luts.json').read_text())['checks'] == 64
for src, dst in [(model / 'report.txt', 'bit17局部映射审计.txt'), (model / 'sourcehashes.txt', 'bit17局部映射源哈希.txt')]:
    shutil.copyfile(src, topic / dst)

note = '''

## bit17 局部映射核查结果（同日）

1. 对最终 routed 网表中两颗实际 LUT 的 INIT 做穷举，各16种输入与工具列出的逻辑式一致；无音频时selector为0的8种输入组合、保存选择器8种组合均符合保持count17的关系，未发现这两级固定引入1。count17与mailbox17所在实际片的端口、CE/SR仅静态核对；没有顺序逻辑仿真。报告见 [bit17局部映射审计.txt](bit17局部映射审计.txt)，源哈希同时保留。工程脚本和完整输出位于 `build/board_feedback_20261011/mapped_status_model/`。
2. 主代理另从同一网表动态抽取5级页面选择前缀的INIT，page=1（显示页3）下穷举64种输入，`frame_value_b[17]_syn_9 == ~received[17]`成立；该关系只到自检门控/最终显示寄存器之前，不能直接等同最终hex_value或实物数码管。结果见 [check_page17_luts.json](check_page17_luts.json)，工程脚本 `config_verify_review/check_page17_luts.py`。
3. 官方 `sim_release/eg4/eg_phy_mslice.v`、`eg_phy_lslice.v` 的实际行为块为保护加密。当前Icarus无法直接执行，删除加密块会丢失行为，故没有把空壳编译或自写RTL当成primitive仿真。原计划的reset/CE/hold动态测试未完成；当前结果属于局部网表查表参数验证，不是完整网表等价/时序或实板证明。

结论：本轮没有找出旧页3偏差和HDMI无信号的唯一根因，也没有新修复位流。SRAM校验工具成功与局部LUT检查结果不能替代实际寄存器/串行输出取证。已询问用户可用示波器/逻辑分析仪条件（可选，不要求购买），用于选择下一轮实际信号验证方式；目前无需重复此前下载/视频。现有失败候选和成功基线均保持原位流。
'''
with (topic / '实板读数与下一步.md').open('a', encoding='utf-8') as f:
    f.write(note)

path = docs / '当前状态.md'
state = path.read_text(encoding='utf-8')
state = state.replace('当前先验证旧页3 bit17实际映射逻辑，再取证串行输出；', '已完成旧页3 bit17局部INIT真值表和5级页面选择前缀64组合检查，未发现局部固定置1；官方primitive行为加密，未完成顺序仿真。下一步依据可用仪器条件选择运行态/串行输出取证；', 1)
state = state.replace('先做旧页3 bit17的映射网表局部验证，再决定板级输出测量；', 'bit17局部LUT和页面前缀检查已完成但未定位根因，顺序primitive仿真因加密模型未完成；已询问可用示波器/逻辑分析仪条件，据此决定下一轮板级输出测量；', 1)
path.write_text(state, encoding='utf-8')

entry = f'''

### {stamp:%H:%M}｜bit17 局部实际网表核查｜有界检查完成，完整primitive仿真未完成

- 证据：最终网表SHA fd07de05dcc1541af6089d3ec597867daa738a65290e93d95b1866cd88f3f0d0；实际INIT真值表16+16项、无audio边界8+8项一致，page3选择前缀64组合通过，未发现局部固定置1。具体脚本/源哈希/报告见节奏诊断失败专题最新节和工程build/board_feedback_20261011。
- 限制：官方EG4 slice行为加密，不能以Icarus完成官方primitive顺序仿真，reset/CE/hold仅静态核查；不声称完整数据链等价、实物正常或已修复。未生成新bit，代理无硬件操作。
- 下一步：按用户可用仪器条件（已发简短询问，未获得回答）选择运行态/串行输出观测；无需重复同一下载/视频。候选FAIL，成功基线仍osd_phy_fix；唯一根因未确认。
'''
with (docs / '工作日志/2026-10-11.md').open('a', encoding='utf-8') as f:
    f.write(entry)
print('Recorded bounded LUT audit and remaining sequential/board verification limits.')
