from __future__ import annotations
import hashlib,json
from pathlib import Path
root=Path(__file__).resolve().parent
out=root/'td_area_high'; out.mkdir(exist_ok=True)
items=[{'tag':'baseline','source':root/'fat32_catalog_baseline.v','mask':0}]
variants=json.loads((root/'variants'/'manifest.json').read_text(encoding='utf-8'))
items += [{'tag':x['tag'],'source':root/'variants'/x['file'],'mask':x['mask']} for x in variants]
# Run the baseline and combined candidate first so the full-top decision can
# proceed while the remaining ablation rows finish in the same TD process.
items=[items[0],next(x for x in items if x['mask']==15)]+[x for x in items[1:] if x['mask']!=15]
rows=[]
for item in items:
 tag=item['tag']; folder=out/tag; project=folder/'td_project'; reports=folder/'reports'
 project.mkdir(parents=True,exist_ok=True); reports.mkdir(exist_ok=True)
 rtl=folder/'fat32_catalog.v'; rtl.write_bytes(item['source'].read_bytes())
 (folder/'mapper.sdc').write_text('create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]\n',encoding='ascii')
 project_file=f'catalog_{len(rows):02d}.al'
 project_path=project.as_posix()
 (project/project_file).write_text(
  '<?xml version="1.0" encoding="UTF-8"?>\n'
  f'<Project Version="3" Minor="2" Path="{project_path}">\n'
  f'<Project_Created_Time></Project_Created_Time><TD_Version>6.2.178840</TD_Version><Name>catalog_{len(rows):02d}</Name>\n'
  '<HardWare><Family>EG4</Family><Device>EG4S20BG256</Device><Speed></Speed></HardWare>\n'
  '<Source_Files><Verilog><File Path="../fat32_catalog.v"><FileInfo><Attr Name="UsedInSyn" Val="true"/><Attr Name="UsedInP&amp;R" Val="true"/><Attr Name="BelongTo" Val="design_1"/><Attr Name="CompileOrder" Val="1"/></FileInfo></File></Verilog></Source_Files>\n'
  '<FileSets><FileSet Name="design_1" Type="DesignFiles"></FileSet><FileSet Name="constraint_1" Type="ConstrainFiles"></FileSet></FileSets>\n'
  '<TOP_MODULE><LABEL>fat32_catalog</LABEL><MODULE>fat32_catalog</MODULE><CREATEINDEX>user</CREATEINDEX></TOP_MODULE>\n'
  '<Property></Property><Device_Settings></Device_Settings><Configurations></Configurations>\n'
  '<Runs><Run Name="syn_1" Type="Synthesis" ConstraintSet="constraint_1" Description="" Active="true"><Strategy Name="Default_Synthesis_Strategy"></Strategy><UserParams></UserParams></Run></Runs>\n'
  '<Project_Settings></Project_Settings></Project>\n',encoding='utf-8')
 rows.append({'tag':tag,'mask':item['mask'],'project_dir':project.as_posix(),'project_file':project_file,
              'source_sha256':hashlib.sha256(rtl.read_bytes()).hexdigest(),'source_path':str(item['source']),
              'report_dir':reports.as_posix()})
(out/'batch_manifest.json').write_text(json.dumps(rows,indent=2)+'\n',encoding='utf-8')
lines=['# One TD process; same standalone device and parameter recipe for each project.']
for x in rows:
 p=x['project_dir']; q=x['report_dir']; project=x['project_file']
 lines += [f'puts "AREA_BEGIN {x["tag"]}"', f'cd {{{p}}}', 'if {[catch {',
  '  import_device eagle_s20.db -package EG4S20BG256', f'  open_project {project} -single_run',
  '  load_run_param -run syn_1', '  set_param rtl min_ripple_len 18', '  set_param gate mapper_lut_delay 1600',
  '  set_param gate add_map_lut_struct high', '  set_param gate map_mode area_prior',
  '  set_param gate multi_thread_mapping partition', '  set_param rtl resource_sharing auto',
  '  set_param rtl shifter_style shifter_reg',
  f'  report_param -stage rtl -detail -all -file {{{q}/actualparams.rtl.log}}',
  f'  report_param -stage gate -detail -all -file {{{q}/actualparams.gate.log}}',
  '  elaborate -top fat32_catalog', '  read_sdc ../mapper.sdc', '  commit_param -step rtl', '  optimize_rtl',
  '  commit_param -step gate', f'  puts "AREA_OUTPUT={{{q}/gate.area}}"',
  f'  optimize_gate -packarea {{{q}/gate.area}}', '  close_project',
  '} message]} { puts "AREA_ERROR '+x['tag']+': $message"; exit 1 }',
  f'puts "AREA_DONE {x["tag"]}"']
lines+=['puts SYNTHESIS_COMPLETE','exit']
(out/'run_batch.tcl').write_text('\n'.join(lines)+'\n',encoding='ascii')
print(json.dumps({'variants':len(rows),'first':rows[0]['tag'],'second':rows[1]['tag'],'tcl':str(out/'run_batch.tcl')},indent=2))
