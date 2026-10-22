from pathlib import Path
import subprocess,json,hashlib,shutil
root=Path('development/video19_work/address_compact').resolve()
pattern=Path('development/video19_work/area_rebalance/A08_base/td_project/jpeg_core.al').read_text()
for name in ['baseline','compact']:
 out=root/name;out.mkdir(exist_ok=True)
 src=root/('baseline.v' if name=='baseline' else 'jpeg420_word_address.v')
 shutil.copy2(src,out/'jpeg420_word_address.v')
 (out/'top.v').write_text('module address_top(input clk,rst,start,input [20:0] frame_base,input word_take,output [20:0] word_address);jpeg420_word_address #(.RGB565(1)) u(.clk(clk),.rst(rst),.start(start),.frame_base(frame_base),.word_take(word_take),.word_address(word_address));endmodule\n')
 import re
 al=re.sub(r'<Verilog>.*?</Verilog>', '<Verilog>'+''.join('<File Path="'+p+'"><FileInfo><Attr Name="UsedInSyn" Val="true"/><Attr Name="UsedInP&amp;R" Val="true"/><Attr Name="BelongTo" Val="design_1"/><Attr Name="CompileOrder" Val="'+str(i)+'"/></FileInfo></File>' for i,p in enumerate(['jpeg420_word_address.v','top.v'],1))+'</Verilog>', pattern,flags=re.S)
 al=al.replace('jpeg_core','address_top');(out/'address_top.al').write_text(al)
 (out/'run.tcl').write_text('''import_device eagle_s20.db -package EG4S20BG256
open_project address_top.al -single_run
load_run_param -run syn_1
set_param gate add_map_lut_struct high
set_param gate map_mode area_prior
set_param rtl min_ripple_len 18
set_param gate mapper_lut_delay 1600
elaborate -top address_top
create_clock -name clk -period 20 [get_ports clk]
commit_param -step rtl
optimize_rtl
commit_param -step gate
optimize_gate -packarea area.rpt
close_project
exit
''')
 (out/'sources.json').write_text(json.dumps({p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in out.glob('*.v')},indent=2))
 with (out/'td.log').open('w') as log:
  run=subprocess.run(['C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/bin/td_commands_prompt.exe',(out/'run.tcl').as_posix()],cwd=out,stdout=log,stderr=subprocess.STDOUT)
 print(name,run.returncode,flush=True)
 print((out/'area.rpt').read_text()[:1000] if (out/'area.rpt').exists() else (out/'td.log').read_text()[-1000:])

