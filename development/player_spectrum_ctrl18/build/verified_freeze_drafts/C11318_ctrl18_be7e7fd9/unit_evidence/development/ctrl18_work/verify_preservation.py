from pathlib import Path
import json,hashlib,difflib
R=Path(__file__).resolve().parents[2];P=R/'development/player_spectrum_arch17';C=R/'development/player_spectrum_ctrl18'
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
snapshot=read(C/'build/baseline/C11317_source_sha256.json')
for e in snapshot:assert sha(P/e['path'])==e['sha256'],e['path']
mf=P/'checkpoints/C11317_arch17_20261021_offline/manifest.json'
assert sha(mf)==read(C/'build/baseline/receipt.json')['parent_manifest_sha256']
for e in read(mf)['files']:assert sha(mf.parent/e['path'])==e['sha256'],e['path']
bits=dict(read(P/'build/preservation.json')['protected_bits']);bits['spectrum_arch17.bit']=read(C/'build/baseline/receipt.json')['parent_bit_sha256']
for n,d in bits.items():assert sha(R/'download'/n)==d,n
selected=read(C/'build/selected_changes.json');delta=[];patch=[]
scope={e['path'].replace('\\','/') for e in read(P/'build/manual/build_source_scope.json')}
for path in sorted(scope|set(selected)):
 p=P/'src'/path;q=C/'src'/path
 if path in selected and selected[path].get('action')=='remove':
  assert p.is_file() and not q.exists() and sha(p)==selected[path]['parent_sha256']
  a=p.read_text(encoding='utf-8-sig');b=''
 elif p.is_file() and q.is_file() and sha(p)==sha(q):continue
 else:
  a=p.read_text(encoding='utf-8-sig') if p.exists() else '';b=q.read_text(encoding='utf-8-sig')
  if path in selected:
   assert sha(q)==selected[path]['sha256'] and sha(Path(selected[path]['source']))==sha(q),path
  elif path.endswith('AC201_tf_hdmi.al'):
   assert b==a.replace('player_spectrum_arch17','player_spectrum_ctrl18'),path
  elif path.endswith(('top_tf_hdmi_audio.v','player_status_monitor.v')):
   assert b==a.replace("24'hC11317","24'hC11318"),path
  else:raise AssertionError(path)
 delta.append(path);patch.extend(difflib.unified_diff(a.splitlines(True),b.splitlines(True),fromfile='C11317/'+path,tofile='C11318/'+path))
result={'status':'PASS','parent_source_files':len(snapshot),'parent_frozen_files':len(read(mf)['files']),'parent_manifest_sha256':sha(mf),'protected_bits':bits,'changed_candidate_scope':delta,'selected_algorithm_changes':selected,'hardware_status':'BOARD_NOT_TESTED'}
(C/'build/preservation.json').write_text(json.dumps(result,indent=2)+'\n');(C/'build/source_delta.patch').write_text(''.join(patch))
print('PRESERVATION PASS',len(snapshot),len(read(mf)['files']),len(bits),'selected',len(selected))
