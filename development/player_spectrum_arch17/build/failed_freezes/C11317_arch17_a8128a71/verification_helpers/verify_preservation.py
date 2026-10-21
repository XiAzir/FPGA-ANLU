from pathlib import Path
import hashlib,json,difflib
R=next(p for p in Path(__file__).resolve().parents if (p/'scripts/anlu_tools.ps1').is_file() and (p/'download').is_dir())
P=R/'development/player_spectrum_opt16';C=R/'development/player_spectrum_arch17'
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
snapshot=read(C/'build/baseline/C11316_source_sha256.json')
assert all(sha(P/e['path'])==e['sha256'] for e in snapshot)
manifest=P/'checkpoints/C11316_opt16_20261021_offline/manifest.json'
assert sha(manifest)=='cb4730c01a5eb5ccc4503d7df4c0e847e538b1db846f926bce2eb66bd1dc3fb1'
entries=read(manifest)['files']
assert all(sha(manifest.parent/e['path'])==e['sha256'] for e in entries)
bits=dict(read(P/'build/preservation.json')['protected_bits'])
bits['spectrum_opt16.bit']='1de561dda1428c86c2f3127cf55b4b391cae8598c51111394ef9bde0ee971afa'
assert all(sha(R/'download'/name)==expected for name,expected in bits.items())
selected=read(C/'build/selected_changes.json');changed=[];patch=[]
parent_scope=read(P/'build/manual/build_source_scope.json')
scope={e['path'].replace('\\','/') for e in parent_scope}
for path in sorted(scope|set(selected)):
 p=P/'src'/path;q=C/'src'/path
 if path in selected and selected[path].get('action')=='remove':
  assert p.is_file() and not q.exists() and sha(p)==selected[path]['parent_sha256'],path
  changed.append(path)
  patch.extend(difflib.unified_diff(p.read_text(encoding='utf-8-sig').splitlines(True),[],fromfile='C11316/'+path,tofile='C11317/'+path))
  continue
 if p.is_file() and sha(q)==sha(p):continue
 a=p.read_text(encoding='utf-8-sig') if p.is_file() else '';b=q.read_text(encoding='utf-8-sig')
 if path in selected:
  assert sha(q)==selected[path]['sha256'] and sha(Path(selected[path]['source']))==sha(q),path
 elif path.endswith('AC201_tf_hdmi.al'):
  assert b==a.replace('player_spectrum_opt16','player_spectrum_arch17')
 elif path.endswith(('top_tf_hdmi_audio.v','player_status_monitor.v')):
  assert b==a.replace("24'hC11316","24'hC11317")
 else: raise AssertionError(path)
 changed.append(path)
 patch.extend(difflib.unified_diff(a.splitlines(True),b.splitlines(True),fromfile='C11316/'+path,tofile='C11317/'+path))
assert set(selected)<=set(changed)
result={'status':'PASS','parent_source_files':len(snapshot),'parent_frozen_files':len(entries),'parent_manifest_sha256':sha(manifest),'protected_bits':bits,'changed_candidate_scope':changed,'selected_algorithm_changes':selected,'hardware_status':'BOARD_NOT_TESTED'}
(C/'build/preservation.json').write_text(json.dumps(result,indent=2)+'\n')
(C/'build/source_delta.patch').write_text(''.join(patch))
print('PRESERVATION PASS',len(snapshot),len(entries),len(bits),'selected',len(selected))
