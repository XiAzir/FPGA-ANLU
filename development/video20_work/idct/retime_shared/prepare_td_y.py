from pathlib import Path
import hashlib,json,shutil
root=Path(__file__).resolve().parent
source_map={
 'baseline':root/'baseline/jpeg_idct_y_reference.v',
 'retime':root/'retime/jpeg_idct_y_retimed.v',
 'dsp_only':root/'dsp_only/jpeg_idct_y_dsp.v',
 'retime_dsp':root/'retime_dsp/jpeg_idct_y_retimed_dsp.v',
}
for name,source in source_map.items():
 run=root/'td'/name;src=run/'src_v';project=run/'td_project';reports=run/'reports'
 src.mkdir(parents=True,exist_ok=True);project.mkdir(parents=True,exist_ok=True);reports.mkdir(parents=True,exist_ok=True)
 data=source.read_bytes().replace(b'module jpeg_idct_y_reference',b'module jpeg_idct_y',1).replace(b'module jpeg_idct_y_retimed_dsp',b'module jpeg_idct_y',1).replace(b'module jpeg_idct_y_retimed',b'module jpeg_idct_y',1).replace(b'module jpeg_idct_y_dsp',b'module jpeg_idct_y',1)
 (src/'jpeg_idct_y.v').write_bytes(data);shutil.copy2(root/'idct_y_area_top.v',src/'idct_y_area_top.v')
 files=sorted(src.glob('*.v'));entries=[]
 for i,p in enumerate(files,1):entries.append(f'<File Path="../src_v/{p.name}"><FileInfo><Attr Name="UsedInSyn" Val="true"/><Attr Name="UsedInP&amp;R" Val="true"/><Attr Name="BelongTo" Val="design_1"/><Attr Name="CompileOrder" Val="{i}"/></FileInfo></File>')
 al=f'<?xml version="1.0" encoding="UTF-8"?>\n<Project Version="3" Minor="2" Path="{project.as_posix()}"><Project_Created_Time></Project_Created_Time><TD_Version>6.2.178840</TD_Version><Name>idct_y_area</Name><HardWare><Family>EG4</Family><Device>EG4S20BG256</Device><Speed></Speed></HardWare><Source_Files><Verilog>'+''.join(entries)+'</Verilog></Source_Files><FileSets><FileSet Name="design_1" Type="DesignFiles"></FileSet><FileSet Name="constraint_1" Type="ConstrainFiles"></FileSet></FileSets><TOP_MODULE><LABEL>idct_y_area_top</LABEL><MODULE>idct_y_area_top</MODULE><CREATEINDEX>user</CREATEINDEX></TOP_MODULE><Property></Property><Device_Settings></Device_Settings><Configurations></Configurations><Runs><Run Name="syn_1" Type="Synthesis" ConstraintSet="constraint_1" Description="" Active="true"><Strategy Name="Default_Synthesis_Strategy"></Strategy><UserParams></UserParams></Run></Runs><Project_Settings></Project_Settings></Project>'
 (project/'idct_y_area.al').write_text(al,encoding='utf-8');(run/'idct_y_area.sdc').write_text('create_clock -name clk_i -period 20 -waveform {0 10} [get_ports {clk_i}]\n',encoding='ascii')
 area=(reports/'gate.area').as_posix();status=(reports/'timing.status').as_posix();timing=(reports/'timing.summary').as_posix();rtl=(reports/'actualparams.rtl.log').as_posix();gate=(reports/'actualparams.gate.log').as_posix()
 tcl=f'''set run_root [file normalize [file join [file dirname [info script]] .]]
set project_dir [file join $run_root td_project]
set output_dir [file join $run_root reports]
cd $project_dir
if {{[catch {{
  import_device eagle_s20.db -package EG4S20BG256
  open_project idct_y_area.al -single_run
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
  elaborate -top idct_y_area_top
  read_sdc ../idct_y_area.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  optimize_gate -packarea {{{area}}}
  legalize_phy_inst
  update_timing
  report_timing_status -file {{{status}}}
  report_timing_summary -file {{{timing}}}
}} message]}} {{ puts "BUILD_ERROR: $message"; exit 1 }}
puts SYNTHESIS_COMPLETE
close_project
exit
'''
 (run/'run_syn.tcl').write_text(tcl,encoding='ascii')
 (run/'source_manifest.json').write_text(json.dumps({'variant':name,'top':'idct_y_area_top','period_ns':20,'max_dsp':29,'files':[{'name':p.name,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in files]},indent=2)+'\n',encoding='utf-8')
print(json.dumps({'prepared':list(source_map)}))
