from pathlib import Path
import hashlib,json,shutil
root=Path(__file__).resolve().parent
base=Path(r'E:\VSCODE-project\FPGA-ANLU\development\video19_work\color_width\parent\src_v')
repl={
 'x_base':{'top':'jpeg_idct_x','changes':{}},
 'x_candidate':{'top':'jpeg_idct_x','changes':{'jpeg_idct_x.v':root/'jpeg_idct_x.v'}},
 'y_base':{'top':'jpeg_idct_y','changes':{}},
 'y_candidate':{'top':'jpeg_idct_y','changes':{'jpeg_idct_y.v':root/'jpeg_idct_y.v'}},
 'xy_base':{'top':'idct_xy_area_top','changes':{'idct_xy_area_top.v':root/'idct_xy_area_top.v'}},
 'xy_candidate':{'top':'idct_xy_area_top','changes':{'jpeg_idct_x.v':root/'jpeg_idct_x.v','jpeg_idct_y.v':root/'jpeg_idct_y.v','idct_xy_area_top.v':root/'idct_xy_area_top.v'}},
}
for name,spec in repl.items():
 run=root/'td_isolated'/name; src=run/'src_v'; proj=run/'td_project'; reports=run/'reports'
 src.mkdir(parents=True,exist_ok=True); proj.mkdir(parents=True,exist_ok=True); reports.mkdir(parents=True,exist_ok=True)
 for p in base.glob('*.v'):
  shutil.copy2(spec['changes'].get(p.name,p),src/p.name)
 for p in spec['changes']:
  if p not in {q.name for q in base.glob('*.v')}: shutil.copy2(spec['changes'][p],src/p)
 files=sorted(src.glob('*.v')); entries=[]
 for i,p in enumerate(files,1): entries.append(f'<File Path="../src_v/{p.name}"><FileInfo><Attr Name="UsedInSyn" Val="true"/><Attr Name="UsedInP&amp;R" Val="true"/><Attr Name="BelongTo" Val="design_1"/><Attr Name="CompileOrder" Val="{i}"/></FileInfo></File>')
 al=f'<?xml version="1.0" encoding="UTF-8"?>\n<Project Version="3" Minor="2" Path="{proj.as_posix()}"><Project_Created_Time></Project_Created_Time><TD_Version>6.2.178840</TD_Version><Name>idct_area</Name><HardWare><Family>EG4</Family><Device>EG4S20BG256</Device><Speed></Speed></HardWare><Source_Files><Verilog>'+''.join(entries)+f'</Verilog></Source_Files><FileSets><FileSet Name="design_1" Type="DesignFiles"></FileSet><FileSet Name="constraint_1" Type="ConstrainFiles"></FileSet></FileSets><TOP_MODULE><LABEL>{spec["top"]}</LABEL><MODULE>{spec["top"]}</MODULE><CREATEINDEX>user</CREATEINDEX></TOP_MODULE><Property></Property><Device_Settings></Device_Settings><Configurations></Configurations><Runs><Run Name="syn_1" Type="Synthesis" ConstraintSet="constraint_1" Description="" Active="true"><Strategy Name="Default_Synthesis_Strategy"></Strategy><UserParams></UserParams></Run></Runs><Project_Settings></Project_Settings></Project>'
 (proj/'idct_area.al').write_text(al,encoding='utf-8')
 (run/'idct_area.sdc').write_text('create_clock -name clk_i -period 20 -waveform {0 10} [get_ports {clk_i}]\n',encoding='ascii')
 area=(reports/'gate.area').as_posix(); rtl=(reports/'actualparams.rtl.log').as_posix(); gate=(reports/'actualparams.gate.log').as_posix(); after=(reports/'actualparams.gate.after.log').as_posix()
 tcl=f'''set run_root [file normalize [file join [file dirname [info script]] .]]
set project_dir [file join $run_root td_project]
cd $project_dir
if {{[catch {{
  import_device eagle_s20.db -package EG4S20BG256
  open_project idct_area.al -single_run
  load_run_param -run syn_1
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate max_dsp 17
  report_param -stage rtl -detail -all -file {{{rtl}}}
  report_param -stage gate -detail -all -file {{{gate}}}
  report_param -stage gate -detail -all -file {{{after}}}
  elaborate -top {spec['top']}
  read_sdc ../idct_area.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={{{area}}}"
  optimize_gate -packarea {{{area}}}
}} message]}} {{ puts "BUILD_ERROR: $message"; exit 1 }}
puts SYNTHESIS_COMPLETE
close_project
exit
'''
 (run/'run_syn.tcl').write_text(tcl,encoding='ascii')
 (run/'source_manifest.json').write_text(json.dumps({'variant':name,'top':spec['top'],'settings':'TD 6.2.1 SP1; EG4S20BG256; AreaHigh; max_dsp=17','files':[{'name':p.name,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in files]},indent=2)+'\n',encoding='utf-8')
print(json.dumps({'prepared':list(repl)}))
