from pathlib import Path
import hashlib,json
root=Path(__file__).resolve().parent
repo=root.parents[4]
expected=json.loads((root/'source_hashes.json').read_text())
actual={}
for key,value in expected.items():
 path=repo/'development/video20_work/shared_idct' if key.startswith('shared/') else repo/'development/video20_work/idct/retime_shared/td/retime_dsp/src_v'
 name=key.split('/')[-1]
 p=path/name
 if key.startswith('reference/'):
  p=repo/'development/player_video19/src/user_source/hdl_source/jpeg'/name
 actual[key]={'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'matches_pre_review':hashlib.sha256(p.read_bytes()).hexdigest()==value}
if not all(v['matches_pre_review'] for v in actual.values()): raise SystemExit('source hash changed during review')
(root/'source_integrity_after.json').write_text(json.dumps(actual,indent=2)+'\n',encoding='utf-8')
