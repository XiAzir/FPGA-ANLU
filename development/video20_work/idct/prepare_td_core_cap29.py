from pathlib import Path
import hashlib,json,shutil
root=Path(__file__).resolve().parent
base=Path(r'E:\VSCODE-project\FPGA-ANLU\development\video19_work\color_width\parent\src_v')
variants={
 'baseline':{},
 'B_scale181':{'jpeg_idct_x.v':root/'jpeg_idct_x_b.v','jpeg_idct_y.v':root/'jpeg_idct_y_b.v'},
 'AB_both':{'jpeg_idct_x.v':root/'jpeg_idct_x_ab.v','jpeg_idct_y.v':root/'jpeg_idct_y_ab.v'},
}
for name,repls in variants.items():
 run=root/'td_core_cap29'/name; src=run/'src_v'; proj=run/'td_project'; reports=run/'reports'
 src.mkdir(parents=True,exist_ok=True); proj.mkdir(parents=True,exist_ok=True); reports.mkdir(parents=True,exist_ok=True)
 for p in base.glob('*.v'):
  textfile=repls.get(p.name,p)
  data=textfile.read_bytes()
  if p.name in ('jpeg_idct_x.v','jpeg_idct_y.v') and textfile.name.endswith('_b.v'):
   axis=p.stem[-1].lower() # x/y
   data=data.replace(f'module jpeg_idct_{axis}_b'.encode(),f'module jpeg_idct_{axis}'.encode(),1)
  elif p.name in ('jpeg_idct_x.v','jpeg_idct_y.v') and textfile.name.endswith('_ab.v'):
   axis=p.stem[-1].lower()
   data=data.replace(f'module jpeg_idct_{axis}_ab'.encode(),f'module jpeg_idct_{axis}'.encode(),1)
  (src/p.name).write_bytes(data)
 files=sorted(src.glob('*.v')); entries=[]
 for i,p in enumerate(files,1): entries.append(f'<File Path="../src_v/{p.name}"><FileInfo><Attr Name="UsedInSyn" Val="true"/><Attr Name="UsedInP&amp;R" Val="true"/><Attr Name="BelongTo" Val="design_1"/><Attr Name="CompileOrder" Val="{i}"/></FileInfo></File>')
 al=f'<?xml version="1.0" encoding="UTF-8"?>\n<Project Version="3" Minor="2" Path="{proj.as_posix()}"><Project_Created_Time></Project_Created_Time><TD_Version>6.2.178840</TD_Version><Name>jpeg_core</Name><HardWare><Family>EG4</Family><Device>EG4S20BG256</Device><Speed></Speed></HardWare><Source_Files><Verilog>'+''.join(entries)+'</Verilog></Source_Files><FileSets><FileSet Name="design_1" Type="DesignFiles"></FileSet><FileSet Name="constraint_1" Type="ConstrainFiles"></FileSet></FileSets><TOP_MODULE><LABEL>jpeg_core</LABEL><MODULE>jpeg_core</MODULE><CREATEINDEX>user</CREATEINDEX></TOP_MODULE><Property></Property><Device_Settings></Device_Settings><Configurations></Configurations><Runs><Run Name="syn_1" Type="Synthesis" ConstraintSet="constraint_1" Description="" Active="true"><Strategy Name="Default_Synthesis_Strategy"></Strategy><UserParams></UserParams></Run></Runs><Project_Settings></Project_Settings></Project>'
 (proj/'jpeg_core.al').write_text(al,encoding='utf-8')
 (run/'jpeg_core.sdc').write_text('create_clock -name clk_i -period 20 -waveform {0 10} [get_ports {clk_i}]\n',encoding='ascii')
 area=(reports/'gate.area').as_posix(); rtl=(reports/'actualparams.rtl.log').as_posix(); gate=(reports/'actualparams.gate.log').as_posix(); after=(reports/'actualparams.gate.after.log').as_posix()
 tcl=f'''set run_root [file normalize [file join [file dirname [info script]] .]]
set project_dir [file join $run_root td_project]
cd $project_dir
if {{[catch {{
  import_device eagle_s20.db -package EG4S20BG256
  open_project jpeg_core.al -single_run
  load_run_param -run syn_1
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate max_dsp 29
  report_param -stage rtl -detail -all -file {{{rtl}}}
  report_param -stage gate -detail -all -file {{{gate}}}
  report_param -stage gate -detail -all -file {{{after}}}
  elaborate -top jpeg_core
  read_sdc ../jpeg_core.sdc
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
 (run/'source_manifest.json').write_text(json.dumps({'variant':name,'top':'jpeg_core','settings':'TD 6.2.1 SP1; EG4S20BG256; AreaHigh; max_dsp=29','files':[{'name':p.name,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in files]},indent=2)+'\n',encoding='utf-8')
print(json.dumps({'prepared':list(variants)}))
