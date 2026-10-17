"""Bind archived delivered bits to their recorded final implementation DBs.

Read-only export from copies of existing routed DBs. No synthesis/P&R/bitgen.
Does not claim equivalence between Verilog export and encoded bit contents.
"""
from pathlib import Path
from datetime import datetime
import sys,json,shutil,re
sys.path.insert(0,str(Path(__file__).resolve().parent/'integration'))
from common import ROOT,BASE,sha,execute
out=BASE/('implementation_binding_'+datetime.now().strftime('%Y%m%d_%H%M%S'));out.mkdir()
definitions=[('C11206','player_bmp_scale','bmp_scale'),('C11309','player_spectrum_clock_route','spectrum_clock_route'),('C11310','player_spectrum_fft_recover','spectrum_fft_recover')]
results=[]
for version,project,delivery in definitions:
 original=ROOT/'development'/project/'build/manual';evidence=original/'stage_evidence'
 metadata=json.loads((ROOT/'download'/(delivery+'.info.json')).read_text(encoding='utf-8-sig'))
 runid=metadata['stageRunIds']['bitstream']
 bit_record_path=evidence/('bitstream_'+runid+'.json');bit_record=json.loads(bit_record_path.read_text(encoding='utf-8-sig'))
 route_stage=bit_record['routeStage'];routeid=metadata['stageRunIds'][route_stage]
 route_record_path=evidence/(route_stage+'_'+routeid+'.json');route_record=json.loads(route_record_path.read_text(encoding='utf-8-sig'))
 bit=ROOT/'download'/(delivery+'.bit');db=original/'AC201_tf_hdmi_pr.db'
 if sha(bit).lower()!=bit_record['bitHash'].lower():raise ValueError(version+' delivered bit mismatch')
 if sha(db).lower()!=route_record['artifacts'][db.name].lower():raise ValueError(version+' routed DB mismatch')
 for key in ['synthesisRunId','scopeHash','scriptHash','gateDbHash']:
  if bit_record[key]!=route_record[key]:raise ValueError(version+' stage chain mismatch: '+key)
 if bit_record['status']!='success' or route_record['status']!='success':raise ValueError('Unsuccessful recorded build')
 for name,digest in route_record['artifacts'].items():
  if sha(original/name).lower()!=digest.lower():raise ValueError(version+' recorded artifact changed: '+name)
 case=out/version;case.mkdir();copy=case/db.name;shutil.copy2(db,copy)
 for path in [bit_record_path,route_record_path]:shutil.copy2(path,case/path.name)
 script=case/'export.tcl'
 script.write_text('''cd {%s}
if {[catch {
 import_device eagle_s20.db -package EG4S20BG256
 import_db {%s}
 write_verilog {%s}
} message]} {puts "EXPORT_ERROR: $message";exit 1}
puts "FINAL_IMPLEMENTATION_EXPORT_ONLY_COMPLETE"
exit
'''%(case.as_posix(),copy.as_posix(),(case/'routed.v').as_posix()),encoding='ascii')
 call=execute(['C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/bin/td_commands_prompt.exe',script.as_posix()],case,'export.log',180)
 if call['exit_code'] or 'FINAL_IMPLEMENTATION_EXPORT_ONLY_COMPLETE' not in (case/'export.log').read_text(errors='replace'):raise ValueError('Read-only export failed: '+str(case))
 if sha(copy)!=sha(db):raise ValueError('DB changed during export')
 results.append(dict(version=version,delivery_bit=str(bit),bit_sha256=sha(bit),route_stage=route_stage,route_run_id=routeid,
  final_database=str(db),database_sha256=sha(db),exported_netlist=str(case/'routed.v'),export_sha256=sha(case/'routed.v'),
  bit_record_sha256=sha(bit_record_path),route_record_sha256=sha(route_record_path),export=call))
 print(version,'recorded bit / final DB / stage chain verified; routed export ready',flush=True)
report=dict(status='RECORDED_IMPLEMENTATION_BINDING_PASS',results=results,
 limitations=['Recorded build provenance, not bitstream decoding or independent bit-to-netlist equivalence proof',
 'No full routed whole-top simulation or SDF qualification in this audit',
 'Field HDMI/FFT fault remains unreproduced; no new bitstream'])
(out/'summary.json').write_text(json.dumps(report,indent=2));(BASE/'implementation_binding_latest.json').write_text(json.dumps(dict(directory=str(out),summary_sha256=sha(out/'summary.json')),indent=2))
print(out,flush=True)
