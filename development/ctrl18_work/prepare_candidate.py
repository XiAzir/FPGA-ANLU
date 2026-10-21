from pathlib import Path
import hashlib,json,shutil
from datetime import datetime
R=Path(__file__).resolve().parents[2];W=Path(__file__).parent
P=R/'development/player_spectrum_arch17';C=R/'development/player_spectrum_ctrl18'
assert not C.exists(),C
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def adapt(s):
 return s.replace('player_spectrum_arch17','player_spectrum_ctrl18').replace('spectrum_arch17.bit','spectrum_ctrl18.bit').replace('C11317_arch17_20261021_offline','C11318_ctrl18_20261021_offline').replace('C11317','C11318').replace('arch17_work','ctrl18_work')
snapshot=[]
for folder in ('src','scripts','sim'):
 for p in (P/folder).rglob('*'):
  if p.is_file() and p.suffix.lower() not in ('.db','.vvp','.dmp','.pyc'):
   snapshot.append({'path':p.relative_to(P).as_posix(),'sha256':sha(p)})
 shutil.copytree(P/folder,C/folder,ignore=shutil.ignore_patterns('*.db','*.vvp','*.dmp','__pycache__','work','*_Runs'))
for folder in ('scripts','sim'):
 for p in (C/folder).rglob('*'):
  if p.is_file() and p.suffix in ('.py','.ps1','.tcl'):p.write_text(adapt(p.read_text(encoding='utf-8-sig')),encoding='utf-8')
for name in ('src/td_project/AC201_tf_hdmi.al','src/user_source/hdl_source/top_tf_hdmi_audio.v','src/user_source/hdl_source/player_status_monitor.v'):
 p=C/name;p.write_text(adapt(p.read_text(encoding='utf-8-sig')),encoding='utf-8')
for name in ('gate.qor','place.qor','route.qor','final_timing.rpt','top_inst.bid','beforeGateOpt.aig'):
 p=C/'src/td_project'/name
 if p.exists():p.unlink()
B=C/'build';(B/'baseline').mkdir(parents=True)
(B/'baseline/C11317_source_sha256.json').write_text(json.dumps(snapshot,indent=2))
for name in ('AC201_tf_hdmi_gate.area','AC201_tf_hdmi_phy.area','AC201_tf_hdmi_phy.ts','AC201_tf_hdmi_pr.timing'):
 shutil.copy2(P/'build/manual'/name,B/'baseline'/name)
for source,destination in [('src/td_project/route.qor','baseline/route.qor'),('build/strategy.json','strategy.json'),('build/final_binding.json','baseline/final_binding.json')]:shutil.copy2(P/source,B/destination)
for folder in ('audit','gate_verify'):
 (B/folder).mkdir()
 for p in (P/'build'/folder).iterdir():
  if p.is_file() and (p.suffix in ('.py','.ps1','.tcl','.md') or p.name=='tb_fft_cone.v'):
   (B/folder/p.name).write_text(adapt(p.read_text(encoding='utf-8-sig')),encoding='utf-8')
for name in ('run_system_candidate.py','mapper_caller_contract.vh','bmp_header_contract.vh','spi_performance_monitor.vh','fifo_hold_contract.vh','bind_simulation_copies.py','archive_attempt.py','freeze_resource_candidate.py'):
 s=adapt((R/'development/arch17_work'/name).read_text(encoding='utf-8-sig'))
 if name=='run_system_candidate.py':
  s=s.replace("candidate=ROOT/'development/player_spectrum_opt16'","candidate=ROOT/'development/player_spectrum_arch17'")
  s=s.replace("'sd_card_sec_read_write.v','rgb888_word_codec.v')","'sd_card_sec_read_write.v','rgb888_word_codec.v','player_adjust_control.v','status_hex595.v')")
 (W/name).write_text(s,encoding='utf-8')
receipt={'created':datetime.now().astimezone().isoformat(),'parent':'C11317','candidate':'C11318','parent_bit_sha256':sha(R/'download/spectrum_arch17.bit'),'parent_manifest_sha256':sha(P/'checkpoints/C11317_arch17_20261021_offline/manifest.json'),'source_snapshot_files':len(snapshot),'hardware_status':'BOARD_NOT_TESTED'}
(B/'baseline/receipt.json').write_text(json.dumps(receipt,indent=2))
(B/'selected_changes.json').write_text('{}\n')
print(json.dumps(receipt))
