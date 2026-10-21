from pathlib import Path
import hashlib,json,shutil
from datetime import datetime
R=Path(__file__).resolve().parents[2];W=Path(__file__).parent
P=R/'development/player_spectrum_opt16';C=R/'development/player_spectrum_arch17'
assert not C.exists(),C
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
snapshot=[]
for folder in ('src','scripts','sim'):
 for p in (P/folder).rglob('*'):
  if p.is_file() and p.suffix.lower() not in ('.db','.vvp','.dmp','.pyc'):
   snapshot.append({'path':p.relative_to(P).as_posix(),'sha256':sha(p)})
 shutil.copytree(P/folder,C/folder,ignore=shutil.ignore_patterns('*.db','*.vvp','*.dmp','__pycache__','work','*_Runs'))
def adapt(s):return s.replace('player_spectrum_opt16','player_spectrum_arch17').replace('spectrum_opt16.bit','spectrum_arch17.bit').replace('C11316_opt16_20261021_offline','C11317_arch17_20261021_offline').replace('C11316','C11317').replace('c11316','c11317')
for folder in ('scripts','sim'):
 for p in (C/folder).rglob('*'):
  if p.is_file() and p.suffix in ('.py','.ps1','.tcl'):p.write_text(adapt(p.read_text(encoding='utf-8-sig')),encoding='utf-8')
for name in ('src/td_project/AC201_tf_hdmi.al','src/user_source/hdl_source/top_tf_hdmi_audio.v','src/user_source/hdl_source/player_status_monitor.v'):
 p=C/name;p.write_text(adapt(p.read_text(encoding='utf-8-sig')),encoding='utf-8')
for name in ('gate.qor','place.qor','route.qor','final_timing.rpt','top_inst.bid','beforeGateOpt.aig'):
 p=C/'src/td_project'/name
 if p.exists():p.unlink()
B=C/'build';(B/'baseline').mkdir(parents=True)
(B/'baseline/C11316_source_sha256.json').write_text(json.dumps(snapshot,indent=2))
for name in ('AC201_tf_hdmi_gate.area','AC201_tf_hdmi_phy.area','AC201_tf_hdmi_phy.ts','AC201_tf_hdmi_pr.timing'):
 shutil.copy2(P/'build/manual'/name,B/'baseline'/name)
for source,destination in [('src/td_project/route.qor','baseline/route.qor'),('build/strategy.json','strategy.json'),('build/final_binding.json','baseline/final_binding.json')]:shutil.copy2(P/source,B/destination)
for folder in ('audit','gate_verify'):
 (B/folder).mkdir()
 for p in (P/'build'/folder).iterdir():
  if p.is_file() and (p.suffix in ('.py','.ps1','.tcl','.md') or p.name=='tb_fft_cone.v'):
   (B/folder/adapt(p.name)).write_text(adapt(p.read_text(encoding='utf-8-sig')),encoding='utf-8')
for name in ('run_system_candidate.py','bmp_header_contract.vh','spi_performance_monitor.vh','mapper_contract_monitor.vh','freeze_resource_candidate.py','verify_final_binding.py'):
 s=adapt((R/'development/opt16_work'/name).read_text(encoding='utf-8-sig'))
 if name=='run_system_candidate.py':s=s.replace("candidate=ROOT/'development/player_spectrum_spi12p5'","candidate=ROOT/'development/player_spectrum_opt16'")
 (W/name).write_text(s,encoding='utf-8')
receipt={'created':datetime.now().astimezone().isoformat(),'parent':'C11316','candidate':'C11317','parent_bit_sha256':sha(R/'download/spectrum_opt16.bit'),'parent_manifest_sha256':sha(P/'checkpoints/C11316_opt16_20261021_offline/manifest.json'),'source_snapshot_files':len(snapshot),'hardware_status':'BOARD_NOT_TESTED'}
(B/'baseline/receipt.json').write_text(json.dumps(receipt,indent=2));print(json.dumps(receipt))
