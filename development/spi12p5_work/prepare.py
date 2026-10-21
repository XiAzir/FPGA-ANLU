from pathlib import Path
import hashlib,json,shutil
from datetime import datetime
R=Path(__file__).resolve().parents[2]
P=R/'development/player_spectrum_resource_80'
C=R/'development/player_spectrum_spi12p5'
W=Path(__file__).parent
assert not C.exists(),C
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
snapshot=[]
for folder in ('src','scripts','sim'):
 for p in (P/folder).rglob('*'):
  if p.is_file() and p.suffix.lower() not in ('.db','.vvp','.dmp','.pyc'):
   snapshot.append({'path':p.relative_to(P).as_posix(),'sha256':sha(p)})
 shutil.copytree(P/folder,C/folder,ignore=shutil.ignore_patterns('*.db','*.vvp','*.dmp','__pycache__','work','*_Runs'))
for folder in ('scripts','sim'):
 for p in (C/folder).rglob('*'):
  if p.is_file() and p.suffix in ('.py','.ps1','.tcl'):
   p.write_text(p.read_text(encoding='utf-8-sig').replace('player_spectrum_resource_80','player_spectrum_spi12p5'),encoding='utf-8')
p=C/'src/td_project/AC201_tf_hdmi.al'
p.write_text(p.read_text(encoding='utf-8-sig').replace('player_spectrum_resource_80','player_spectrum_spi12p5'),encoding='utf-8')
for name in ('top_tf_hdmi_audio.v','player_status_monitor.v'):
 p=C/'src/user_source/hdl_source'/name
 text=p.read_text(encoding='utf-8-sig')
 assert "24'hC11314" in text
 text=text.replace("24'hC11314","24'hC11315")
 if name=='top_tf_hdmi_audio.v':
  assert text.count('.SPI_HIGH_SPEED_DIV(2)')==1
  text=text.replace('.SPI_HIGH_SPEED_DIV(2)','.SPI_HIGH_SPEED_DIV(0)')
 p.write_text(text,encoding='utf-8')
for name in ('gate.qor','place.qor','route.qor','final_timing.rpt','top_inst.bid','beforeGateOpt.aig'):
 p=C/'src/td_project'/name
 if p.exists():p.unlink()
B=C/'build';(B/'baseline').mkdir(parents=True)
(B/'baseline/C11314_source_sha256.json').write_text(json.dumps(snapshot,indent=2),encoding='utf-8')
for name in ('AC201_tf_hdmi_gate.area','AC201_tf_hdmi_phy.area','AC201_tf_hdmi_phy.ts','AC201_tf_hdmi_pr.timing'):
 shutil.copy2(P/'build/manual'/name,B/'baseline'/name)
shutil.copy2(P/'src/td_project/route.qor',B/'baseline/route.qor')
shutil.copy2(P/'build/strategy.json',B/'strategy.json')
shutil.copy2(P/'build/final_binding.json',B/'baseline/final_binding.json')
# Bring checker code only. Each proof is regenerated from the new selected run.
for folder in ('audit','gate_verify'):
 (B/folder).mkdir()
 for p in (P/'build'/folder).iterdir():
  if p.is_file() and p.suffix in ('.py','.ps1','.tcl','.md'):
   name=p.name.replace('c11314','c11315')
   text=p.read_text(encoding='utf-8-sig').replace('player_spectrum_resource_80','player_spectrum_spi12p5').replace('C11314','C11315').replace('c11314','c11315')
   (B/folder/name).write_text(text,encoding='utf-8')
for name in ('run_system_candidate.py','mapper_contract_monitor.vh','freeze_resource_candidate.py','verify_final_binding.py'):
 text=(R/'development/resource80_work'/name).read_text(encoding='utf-8-sig')
 text=text.replace('player_spectrum_resource_80','player_spectrum_spi12p5').replace('spectrum_resource_80.bit','spectrum_spi12p5.bit')
 text=text.replace('C11314_resource80_20261021_offline','C11315_spi12p5_20261021_offline').replace('C11314-resource-fit','C11315-spi12p5')
 (W/name).write_text(text,encoding='utf-8')
receipt={'created':datetime.now().astimezone().isoformat(),'parent':'C11314','candidate':'C11315',
 'parent_bit_sha256':sha(R/'download/spectrum_resource_80.bit'),
 'parent_manifest_sha256':sha(P/'checkpoints/C11314_resource80_20261021_offline/manifest.json'),
 'functional_delta':'SPI_HIGH_SPEED_DIV 2 -> 0; Build ID C11314 -> C11315',
 'source_snapshot_files':len(snapshot),'hardware_status':'BOARD_NOT_TESTED'}
(B/'baseline/receipt.json').write_text(json.dumps(receipt,indent=2),encoding='utf-8')
print(json.dumps(receipt))
