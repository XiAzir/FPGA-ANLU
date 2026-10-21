from pathlib import Path
import json,hashlib,shutil
R=Path(__file__).resolve().parents[2];C=R/'development/player_spectrum_arch17'
T=C/'build/attempts/A02_verified_offline';assert not (T/'result.json').exists();T.mkdir(parents=True,exist_ok=True)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
for folder in ('src','scripts','sim','build/manual','build/audit','build/gate_verify'):
 for p in (C/folder).rglob('*'):
  if not p.is_file():continue
  if any(x in ('cone_work','work','__pycache__','attempts') for x in p.relative_to(C/folder).parts):continue
  if p.suffix.lower() in ('.vvp','.pyc','.dmp'):continue
  q=T/p.relative_to(C);q.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,q)
for name in ('selected_changes.json','preservation.json','source_delta.patch','strategy.json'):
 shutil.copy2(C/'build'/name,T/name)
for name in ('normalized_control_proof.json',):assert json.loads((T/'build/gate_verify'/name).read_text(encoding='utf-8-sig'))['status']=='PASS'
for name in ('routed_rom_control_proof.json','routed_clock_audit.json'):assert json.loads((T/'build/audit'/name).read_text(encoding='utf-8-sig'))['status']=='PASS'
result={'status':'OFFLINE_VERIFIED_FALLBACK','slices':7383,'synthesis_run_id':'aba70119-fd9b-434c-9993-bc0034907adf','physical_run_id':'d1d7b595-442c-4427-be31-f7fbfd7c49a9','setup_ns':0.614,'hold_ns':0.004,'system':'build/system_fast_20261021_121648','hardware_status':'BOARD_NOT_TESTED','files':[],'database_files':[]}
for p in sorted(T.rglob('*')):
 if not p.is_file():continue
 result['database_files' if p.suffix=='.db' else 'files'].append({'path':str(p.relative_to(T)),'sha256':sha(p)})
(T/'result.json').write_text(json.dumps(result,indent=2));print('Saved fallback',len(result['files']),len(result['database_files']),sha(T/'build/manual/AC201_player_spectrum_arch17.bit'))
