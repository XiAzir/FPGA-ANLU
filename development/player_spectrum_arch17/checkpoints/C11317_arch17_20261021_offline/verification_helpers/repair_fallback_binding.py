from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[2];C=R/'development/player_spectrum_arch17';T=C/'build/attempts/A02_verified_offline'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
p=T/'build/gate_verify/prove_current_gate_rom_polarity.ps1'
data=p.read_bytes().replace(b'(?P<inst>\\\\[^\\r\\n]+?|[A-Za-z_$][A-Za-z0-9_$]*)',b'(?P<inst>\\\\[^\\r\\n]+?)')
expected='96cda6810e5b27196fffbdbf46cfc2d2fbcd2c94e4baaa2f09c50d9bbb73cc06'
assert hashlib.sha256(data).hexdigest()==expected
p.write_bytes(data)
for name in ('rom_polarity_evidence.json','routed_rom_control_proof.json'):
 proof=json.loads((T/'build/audit'/name).read_text(encoding='utf-8-sig'));assert proof['status']=='PASS'
 for e in proof['bound_files']:
  q=T/Path(e['path']).relative_to(C);assert sha(q)==e['sha256'],q
result=json.loads((T/'result.json').read_text(encoding='utf-8-sig'))
for e in result['files']:
 if Path(e['path'])==p.relative_to(T):e['sha256']=sha(p)
result['proof_script_note']='Gate proof retains its exact as-run parser SHA. Routed proof uses the corrected parser supporting bare and escaped instance names. Failed routed pre-parser output retained in main audit attempts.'
(T/'result.json').write_text(json.dumps(result,indent=2));print('A02 fallback proof file bindings PASS')
