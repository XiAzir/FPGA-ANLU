from pathlib import Path
import hashlib,json,shutil
from datetime import datetime
R=Path(__file__).resolve().parents[2];W=Path(__file__).parent
P=R/'development/player_spectrum_spi12p5';C=R/'development/player_spectrum_opt16'
assert not C.exists(),C
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
snapshot=[]
for folder in ('src','scripts','sim'):
 for p in (P/folder).rglob('*'):
  if p.is_file() and p.suffix.lower() not in ('.db','.vvp','.dmp','.pyc'):
   snapshot.append({'path':p.relative_to(P).as_posix(),'sha256':sha(p)})
 shutil.copytree(P/folder,C/folder,ignore=shutil.ignore_patterns('*.db','*.vvp','*.dmp','__pycache__','work','*_Runs'))
def adapt(s):return s.replace('player_spectrum_spi12p5','player_spectrum_opt16').replace('spectrum_spi12p5.bit','spectrum_opt16.bit').replace('C11315_spi12p5_20261021_offline','C11316_opt16_20261021_offline').replace('C11315','C11316').replace('c11315','c11316')
for folder in ('scripts','sim'):
 for p in (C/folder).rglob('*'):
  if p.is_file() and p.suffix in ('.py','.ps1','.tcl'):p.write_text(adapt(p.read_text(encoding='utf-8-sig')),encoding='utf-8')
for name in ('src/td_project/AC201_tf_hdmi.al','src/user_source/hdl_source/top_tf_hdmi_audio.v','src/user_source/hdl_source/player_status_monitor.v'):
 p=C/name;p.write_text(adapt(p.read_text(encoding='utf-8-sig')),encoding='utf-8')
for name in ('gate.qor','place.qor','route.qor','final_timing.rpt','top_inst.bid','beforeGateOpt.aig'):
 p=C/'src/td_project'/name
 if p.exists():p.unlink()
B=C/'build';(B/'baseline').mkdir(parents=True)
(B/'baseline/C11315_source_sha256.json').write_text(json.dumps(snapshot,indent=2))
for name in ('AC201_tf_hdmi_gate.area','AC201_tf_hdmi_phy.area','AC201_tf_hdmi_phy.ts','AC201_tf_hdmi_pr.timing'):
 shutil.copy2(P/'build/manual'/name,B/'baseline'/name)
shutil.copy2(P/'src/td_project/route.qor',B/'baseline/route.qor')
shutil.copy2(P/'build/strategy.json',B/'strategy.json')
shutil.copy2(P/'build/final_binding.json',B/'baseline/final_binding.json')
for folder in ('audit','gate_verify'):
 (B/folder).mkdir()
 for p in (P/'build'/folder).iterdir():
  if p.is_file() and p.suffix in ('.py','.ps1','.tcl','.md','.v') and p.name!='routed_implementation.v':
   (B/folder/adapt(p.name)).write_text(adapt(p.read_text(encoding='utf-8-sig')),encoding='utf-8')
for name in ('run_system_candidate.py','mapper_contract_monitor.vh','spi_performance_monitor.vh','freeze_resource_candidate.py','verify_final_binding.py','collect_ablation.py'):
 s=adapt((R/'development/spi12p5_work'/name).read_text(encoding='utf-8-sig'))
 if name=='run_system_candidate.py':s=s.replace("candidate=ROOT/'development/player_spectrum_resource_80'","candidate=ROOT/'development/player_spectrum_spi12p5'")
 (W/name).write_text(s,encoding='utf-8')
receipt={'created':datetime.now().astimezone().isoformat(),'parent':'C11315','candidate':'C11316','parent_bit_sha256':sha(R/'download/spectrum_spi12p5.bit'),'parent_manifest_sha256':sha(P/'checkpoints/C11315_spi12p5_20261021_offline/manifest.json'),'source_snapshot_files':len(snapshot),'hardware_status':'BOARD_NOT_TESTED'}
(B/'baseline/receipt.json').write_text(json.dumps(receipt,indent=2))
print(json.dumps(receipt))
