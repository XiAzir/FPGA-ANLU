from pathlib import Path
import ast,json,hashlib
R=Path(__file__).resolve().parents[2];W=Path(__file__).parent/'scaler'
source=R/'development/resource80_work/bmp/prepare_synthesis.py'
tree=ast.parse(source.read_text());ns={}
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef)],type_ignores=[]),str(source),'exec'),ns)
for name,source in [('base',R/'development/player_spectrum_spi12p5/src/user_source/hdl_source/bmp_scale_engine.v'),('shared',W/'bmp_scale_engine.v')]:
 D=W/'td'/name;(D/'hdl_source').mkdir(parents=True,exist_ok=True);(D/'td_project').mkdir(exist_ok=True)
 (D/'hdl_source/bmp_scale_engine.v').write_bytes(source.read_bytes())
 al=D/'td_project/bmp.al'
 template=(R/'development/resource_opt_work/bmp_synthesis/runs/width32/td_project/bmp_width32.al').read_text(encoding='utf-8-sig')
 template=template.replace('resource_opt_work/bmp_synthesis/runs/width32/td_project',f'opt16_work/scaler/td/{name}/td_project').replace('bmp_width32','bmp')
 al.write_text(template,encoding='utf-8')
 s=ns['tcl']('bmp_scale_engine').replace(' elaborate -top', ''' set_param gate add_map_lut_struct high
 set_param gate map_mode area_prior
 set_param rtl min_ripple_len 18
 set_param gate mapper_lut_delay 1600
 report_param -stage rtl -detail -all -file [file join $report_dir actualparams.rtl.log]
 report_param -stage gate -detail -all -file [file join $report_dir actualparams.gate.log]
 elaborate -top''')
 s=s.replace('[file join $report_dir actualparams.rtl.log]',(D/'reports/actualparams.rtl.log').as_posix()).replace('[file join $report_dir actualparams.gate.log]',(D/'reports/actualparams.gate.log').as_posix()).replace('[file join $report_dir gate.area]',(D/'reports/gate.area').as_posix())
 (D/'run_syn.tcl').write_text(s);(D/'standalone.sdc').write_text('create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]\n')
print(W/'td')
