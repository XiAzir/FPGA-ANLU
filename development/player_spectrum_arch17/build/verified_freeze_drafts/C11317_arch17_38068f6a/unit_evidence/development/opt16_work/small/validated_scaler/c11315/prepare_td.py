from pathlib import Path
import hashlib,json,re
root=Path(__file__).resolve().parents[5]
out=Path(__file__).resolve().parent
source=root/'development/player_spectrum_spi12p5/src/user_source/hdl_source'
engine=out/'bmp_scale_engine.v'
loader_base=source/'tf_bmp_file_player.v'
loader_validated=loader_base.read_text(encoding='utf-8-sig')
loader_validated=loader_validated.replace('bmp_scale_engine #(','bmp_scale_engine #(.HEADER_VALIDATED(1),',1)
debtext=(source/'SD/sd_card_bmp.v').read_text(encoding='utf-8-sig')
m=re.search(r'(?ms)^module key_press_debounce\s*#\(.*?^endmodule',debtext)
assert m
variants={'A1_base':(loader_base.read_text(encoding='utf-8-sig'),'tf_bmp_file_player'),
          'A2_validated':(loader_validated,'tf_bmp_file_player')}
manifest={}
for name,(loader,top) in variants.items():
    d=out/'td'/name; hdl=d/'hdl_source'; prj=d/'td_project'; reports=d/'reports'
    hdl.mkdir(parents=True,exist_ok=True); prj.mkdir(parents=True,exist_ok=True); reports.mkdir(parents=True,exist_ok=True)
    (hdl/'bmp_scale_engine.v').write_bytes(engine.read_bytes())
    (hdl/'tf_bmp_file_player.v').write_text(loader,encoding='ascii')
    (hdl/'key_press_debounce.v').write_text(m.group(0)+'\n',encoding='utf-8')
    (prj/f'{name}.al').write_text(f'''<?xml version="1.0" encoding="UTF-8"?>
<Project Version="3" Minor="2" Path="{prj.as_posix()}">
<TD_Version>6.2.178840</TD_Version><Name>{name}</Name>
<HardWare><Family>EG4</Family><Device>EG4S20BG256</Device><Speed></Speed></HardWare>
<Source_Files><Verilog>
<File Path="../hdl_source/bmp_scale_engine.v"><FileInfo><Attr Name="UsedInSyn" Val="true"/><Attr Name="UsedInP&amp;R" Val="true"/><Attr Name="BelongTo" Val="design_1"/><Attr Name="CompileOrder" Val="1"/></FileInfo></File>
<File Path="../hdl_source/key_press_debounce.v"><FileInfo><Attr Name="UsedInSyn" Val="true"/><Attr Name="UsedInP&amp;R" Val="true"/><Attr Name="BelongTo" Val="design_1"/><Attr Name="CompileOrder" Val="2"/></FileInfo></File>
<File Path="../hdl_source/tf_bmp_file_player.v"><FileInfo><Attr Name="UsedInSyn" Val="true"/><Attr Name="UsedInP&amp;R" Val="true"/><Attr Name="BelongTo" Val="design_1"/><Attr Name="CompileOrder" Val="3"/></File>
</Verilog></Source_Files>
<FileSets><FileSet Name="design_1" Type="DesignFiles"/><FileSet Name="constraint_1" Type="ConstrainFiles"/></FileSets>
<TOP_MODULE><LABEL>{top}</LABEL><MODULE>{top}</MODULE><CREATEINDEX>user</CREATEINDEX></TOP_MODULE>
<Runs><Run Name="syn_1" Type="Synthesis" ConstraintSet="constraint_1" Description="" Active="true"><Strategy Name="Default_Synthesis_Strategy"/><UserParams/></Run></Runs>
</Project>
''',encoding='ascii')
    (d/'standalone.sdc').write_text('create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]\n',encoding='ascii')
    area=(reports/'gate.area').as_posix(); rtl=(reports/'actualparams.rtl.log').as_posix(); gate=(reports/'actualparams.gate.log').as_posix()
    (d/'run_syn.tcl').write_text(f'''set variant_root [file normalize [file join [file dirname [info script]] .]]
set project_dir [file join $variant_root td_project]
set report_dir [file join $variant_root reports]
cd $project_dir
if {{[catch {{
 import_device eagle_s20.db -package EG4S20BG256
 open_project {name}.al -single_run
 load_run_param -run syn_1
 set_param gate add_map_lut_struct high
 set_param gate map_mode area_prior
 set_param gate multi_thread_mapping partition
 set_param rtl resource_sharing auto
 set_param rtl shifter_style shifter_reg
 set_param rtl min_ripple_len 18
 set_param gate mapper_lut_delay 1600
 report_param -stage rtl -detail -all -file {rtl}
 report_param -stage gate -detail -all -file {gate}
 elaborate -top {top}
 read_sdc ../standalone.sdc
 commit_param -step rtl
 optimize_rtl
 commit_param -step gate
 puts "AREA_OUTPUT={area}"
 optimize_gate -packarea {area}
}} message]}} {{puts "BUILD_ERROR: $message"; exit 1}}
puts SYNTHESIS_COMPLETE
close_project
exit
''',encoding='ascii')
    manifest[name]={'top':top,'loader_sha256':hashlib.sha256((hdl/'tf_bmp_file_player.v').read_bytes()).hexdigest(),
      'engine_sha256':hashlib.sha256((hdl/'bmp_scale_engine.v').read_bytes()).hexdigest(),
      'debounce_sha256':hashlib.sha256((hdl/'key_press_debounce.v').read_bytes()).hexdigest(),
      'project':str((prj/f'{name}.al').resolve()),'settings':'AreaHigh + min_ripple_len=18 + mapper_lut_delay=1600'}
(out/'td_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
print(json.dumps(manifest,indent=2))
