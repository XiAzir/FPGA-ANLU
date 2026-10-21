from pathlib import Path
import hashlib
root=Path(__file__).resolve().parent
folder=root/'td_area_high'/'clean_combined'; project=folder/'td_project'; reports=folder/'reports'
project.mkdir(parents=True,exist_ok=True); reports.mkdir(exist_ok=True)
source=root/'fat32_catalog_candidate_fixed_flags.v'; rtl=folder/'fat32_catalog.v'; rtl.write_bytes(source.read_bytes())
(project/'catalog_clean.al').write_text(
'<?xml version="1.0" encoding="UTF-8"?>\n'
f'<Project Version="3" Minor="2" Path="{project.as_posix()}">\n'
'<Project_Created_Time></Project_Created_Time><TD_Version>6.2.178840</TD_Version><Name>catalog_clean</Name>\n'
'<HardWare><Family>EG4</Family><Device>EG4S20BG256</Device><Speed></Speed></HardWare>\n'
'<Source_Files><Verilog><File Path="../fat32_catalog.v"><FileInfo><Attr Name="UsedInSyn" Val="true"/><Attr Name="UsedInP&amp;R" Val="true"/><Attr Name="BelongTo" Val="design_1"/><Attr Name="CompileOrder" Val="1"/></FileInfo></File></Verilog></Source_Files>\n'
'<FileSets><FileSet Name="design_1" Type="DesignFiles"></FileSet><FileSet Name="constraint_1" Type="ConstrainFiles"></FileSet></FileSets>\n'
'<TOP_MODULE><LABEL>fat32_catalog</LABEL><MODULE>fat32_catalog</MODULE><CREATEINDEX>user</CREATEINDEX></TOP_MODULE>\n'
'<Property></Property><Device_Settings></Device_Settings><Configurations></Configurations>\n'
'<Runs><Run Name="syn_1" Type="Synthesis" ConstraintSet="constraint_1" Description="" Active="true"><Strategy Name="Default_Synthesis_Strategy"></Strategy><UserParams></UserParams></Run></Runs>\n'
'<Project_Settings></Project_Settings></Project>\n',encoding='utf-8')
(folder/'mapper.sdc').write_text('create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]\n',encoding='ascii')
area=(reports/'gate.area').as_posix(); rtlp=(reports/'actualparams.rtl.log').as_posix(); gatep=(reports/'actualparams.gate.log').as_posix()
tcl='\n'.join([
'set run_root [file normalize [file join [file dirname [info script]] .]]',
'set project_dir [file join $run_root td_project]','cd $project_dir','if {[catch {',
'import_device eagle_s20.db -package EG4S20BG256','open_project catalog_clean.al -single_run','load_run_param -run syn_1',
'set_param rtl min_ripple_len 18','set_param gate mapper_lut_delay 1600','set_param gate add_map_lut_struct high',
'set_param gate map_mode area_prior','set_param gate multi_thread_mapping partition','set_param rtl resource_sharing auto',
'set_param rtl shifter_style shifter_reg',f'report_param -stage rtl -detail -all -file {{{rtlp}}}',
f'report_param -stage gate -detail -all -file {{{gatep}}}','elaborate -top fat32_catalog','read_sdc ../mapper.sdc',
'commit_param -step rtl','optimize_rtl','commit_param -step gate',f'puts "AREA_OUTPUT={{{area}}}"',
f'optimize_gate -packarea {{{area}}}','close_project','} message]} { puts "BUILD_ERROR: $message"; exit 1 }',
'puts SYNTHESIS_COMPLETE','exit'])+'\n'
(folder/'run_syn.tcl').write_text(tcl,encoding='ascii')
print({'source_sha256':hashlib.sha256(rtl.read_bytes()).hexdigest(),'folder':str(folder),'area':str(reports/'gate.area')})

