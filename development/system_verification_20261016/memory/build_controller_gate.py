"""Isolated TD synthesis of the unchanged production SDRAM wrapper/controller.

No placement, route or bit generation. Used to bypass old ModelSim's encrypted
RTL parser, not to modify the production controller or replace it behaviorally.
"""
from pathlib import Path
from datetime import datetime
import sys,json,re,shutil
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'integration'))
from common import BASE,ROOT,execute,sha
cp=ROOT/'development/player_spectrum_fft_recover/checkpoints/music_spectrum_fft_recover_20261014_candidate'
out=BASE/'memory'/('controller_gate_'+datetime.now().strftime('%Y%m%d_%H%M%S'));out.mkdir()
manifest=json.loads((cp/'manifest.json').read_text(encoding='utf-8-sig'))
entries={e['path'].lower():e['sha256'].lower() for e in manifest}
names=['SD/sdram.v','include/sdr_as_ram.enc.v','include/sdr_init_ref.enc.v','include/sdr_wrrd.enc.v','include/global_def.v']
records=[]
for name in names:
 source=cp/'src/user_source/hdl_source'/name
 if sha(source).lower()!=entries[source.relative_to(cp).as_posix().lower()]:raise ValueError('Frozen SDRAM source mismatch')
 target=out/'src/user_source/hdl_source'/name;target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(source,target)
 records.append(dict(source=str(source),copy=str(target),sha256=sha(source)))
al_source=cp/'src/td_project/AC201_tf_hdmi.al'
if sha(al_source).lower()!=entries[al_source.relative_to(cp).as_posix().lower()]:raise ValueError('Frozen .al mismatch')
project=out/'src/td_project';project.mkdir(parents=True)
text=al_source.read_text(encoding='utf-8-sig')
files=''.join(f'<File Path="../user_source/hdl_source/{name}"><FileInfo><Attr Name="UsedInSyn" Val="true"/><Attr Name="BelongTo" Val="design_1"/><Attr Name="CompileOrder" Val="{i+1}"/></FileInfo></File>' for i,name in enumerate(names[:-1]))
text=re.sub(r'<Source_Files>.*?</Source_Files>','<Source_Files><Verilog>'+files+'</Verilog></Source_Files>',text,flags=re.S)
text=re.sub(r'(<Project[^>]* Path=")[^"]*',lambda m:m[1]+project.as_posix(),text)
text=text.replace('<LABEL>top</LABEL>','<LABEL>sdram</LABEL>').replace('<MODULE>top</MODULE>','<MODULE>sdram</MODULE>')
(project/'AC201_tf_hdmi.al').write_text(text,encoding='utf-8')
build=out/'build';build.mkdir()
tcl='''set project_dir {%s}
set output_dir {%s}
cd $project_dir
if {[catch {
 import_device eagle_s20.db -package EG4S20BG256
 open_project AC201_tf_hdmi.al -single_run
 load_run_param -run syn_1
 set_param -run syn_1 gate eram_init off
 elaborate -top sdram
 commit_param -step rtl
 optimize_rtl
 commit_param -step gate
 optimize_gate -packarea $output_dir/controller_gate.area
 legalize_phy_inst
 write_verilog $output_dir/controller_gate.v
 export_db $output_dir/controller_gate.db
} message]} {
 puts "CONTROLLER_BUILD_ERROR: $message"
 exit 1
}
puts "CONTROLLER_SYNTHESIS_ONLY_COMPLETE_NO_BIT"
close_project
exit
'''%(project.as_posix(),build.as_posix())
script=out/'synthesize.tcl';script.write_text(tcl,encoding='ascii')
(out/'source_receipt.json').write_text(json.dumps(dict(checkpoint=str(cp),inputs=records,project_source=str(al_source),project_source_sha256=sha(al_source),scope='Isolated controller synthesis only; no implementation or bitstream'),indent=2))
print(out,flush=True)
result=execute([Path('C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/bin/td_commands_prompt.exe'),script.as_posix()],out,'synthesis.log',300)
log=(out/'synthesis.log').read_text(errors='replace')
ok=result['exit_code']==0 and 'CONTROLLER_SYNTHESIS_ONLY_COMPLETE_NO_BIT' in log and (build/'controller_gate.v').exists()
summary=dict(status='SYNTHESIS_ONLY_GATE_AVAILABLE' if ok else 'NOT_BUILT',execution=result,gate_sha256=sha(build/'controller_gate.v') if ok else None)
(out/'summary.json').write_text(json.dumps(summary,indent=2));print(log[-3000:],flush=True)
if ok:(BASE/'memory/controller_gate_latest.json').write_text(json.dumps(dict(directory=str(out),gate_sha256=summary['gate_sha256']),indent=2))
raise SystemExit(0 if ok else 2)
