from pathlib import Path
import sys,re
source=Path(sys.argv[1]).read_text()
lines=[f'force dut.\\u_status_monitor/cw_count_data [{i}] = page_sel[{i-5}];' for i in range(5,9)]
copies=re.findall(r'^  wire\s+(\\u_status_monitor/cw_count_data\[([5-8])\]_dup_\d+)\s*;',source,re.M)
lines += [f'force dut.{name} = page_sel[{int(bit)-5}];' for name,bit in copies]
Path(sys.argv[2]).write_text('\n'.join(lines)+'\n')
print('Page selector duplicated Q nodes:',len(copies))
