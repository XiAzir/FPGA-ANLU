from pathlib import Path
import json
root=Path(__file__).resolve().parent
p=root/'RESULTS.md'; s=p.read_text(encoding='utf-8')
s=s.replace('最终候选的单独TD复测待批次退出后执行，报告路径 `td_area_high/clean_combined/`。',
'''最终候选在独立fresh TD进程重新综合，clean报告 `td_area_high/clean_combined/reports/gate.area` 与实际参数日志均保留；此轮无重复时钟告警，参数与批次一致，面积相同。完整参数/控制台在 `td_area_high/clean_combined/`。批次完整消融汇总为 `td_area_high/area_summary.csv`、`area_summary.json`。''')
rows=json.loads((root/'td_area_high'/'area_summary.json').read_text(encoding='utf-8'))
lines=['','### 全部单项与组合面积','',
       'device LUT/REG来自`gate.area`中的`#lut/#reg`；generic LUT来自`#Total_luts`。baseline与最终组合使用无重复时钟的有效报告；中间消融行使用同一批次相同20ns时钟状态。']
lines += ['', '| 字段压缩 | device LUT | device REG | generic LUT | 相对基线（LUT/REG） |','| --- | ---: | ---: | ---: | ---: |']
base=next(x for x in rows if x['mask']==0)
for x in rows:
 name='基线' if x['mask']==0 else ('全部四项' if x['mask']==15 else x['variant'])
 lines.append(f"| {name} | {x['device_lut']} | {x['device_reg']} | {x['generic_lut']} | {x['device_lut']-base['device_lut']:+d} / {x['device_reg']-base['device_reg']:+d} |")
lines += ['', '四个单项中fat16-size压缩的standalone device LUT收益最大（-42）；组合优化后为-47 LUT/-63 REG。RTL按原始寄存位数计算是64位改为4个标志位，理论减少60个寄存位；综合净减63 REG另有工具优化贡献，记录为实现后统计，不能全部归因于字段寄存器删除。', '']
s=s.rstrip()+"\n"+"\n".join(lines)
p.write_text(s,encoding='utf-8',newline='\n')
