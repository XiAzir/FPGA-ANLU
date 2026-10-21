from pathlib import Path
import hashlib,json,difflib
R=next(p for p in Path(__file__).resolve().parents if (p/'scripts/anlu_tools.ps1').is_file() and (p/'download').is_dir())
P=R/'development/player_spectrum_spi12p5';C=R/'development/player_spectrum_opt16'
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
snapshot=read(C/'build/baseline/C11315_source_sha256.json')
assert all(sha(P/e['path'])==e['sha256'] for e in snapshot)
manifest=P/'checkpoints/C11315_spi12p5_20261021_offline/manifest.json'
assert sha(manifest)=='b9671c4acbc9dbbaca12ddbbc0150b7fc50a246574126f22d3df8cf2f2b3338d'
entries=read(manifest)['files']
assert all(sha(manifest.parent/e['path'])==e['sha256'] for e in entries)
bits=dict(read(P/'build/preservation.json')['protected_bits'])
bits['spectrum_spi12p5.bit']='a9de55c166cd730db1203fc9d1d882eee885237cec68fd389dad26d0d972e22f'
assert all(sha(R/'download'/name)==expected for name,expected in bits.items())
selected=read(C/'build/selected_changes.json')
changed=[];patch=[]
for e in read(P/'build/manual/build_source_scope.json'):
 path=e['path'].replace('\\','/')
 p=P/'src'/path;q=C/'src'/path
 if sha(q)==e['sha256'].lower():continue
 a=p.read_text(encoding='utf-8-sig');b=q.read_text(encoding='utf-8-sig')
 if path.endswith('AC201_tf_hdmi.al'):
  assert b==a.replace('player_spectrum_spi12p5','player_spectrum_opt16')
 elif path.endswith(('top_tf_hdmi_audio.v','player_status_monitor.v')):
  assert b==a.replace("24'hC11315","24'hC11316")
 else:
  assert path in selected,path
  assert sha(q)==selected[path]['sha256'],path
  assert sha(Path(selected[path]['source']))==sha(q),path
 changed.append(path)
 patch.extend(difflib.unified_diff(a.splitlines(True),b.splitlines(True),fromfile='C11315/'+path,tofile='C11316/'+path))
assert set(selected)==set(changed)-{'td_project/AC201_tf_hdmi.al','user_source/hdl_source/top_tf_hdmi_audio.v','user_source/hdl_source/player_status_monitor.v'}
result={'status':'PASS','parent_source_files':len(snapshot),'parent_frozen_files':len(entries),'parent_manifest_sha256':sha(manifest),'protected_bits':bits,'changed_candidate_scope':changed,'selected_algorithm_changes':selected,'hardware_status':'BOARD_NOT_TESTED'}
(C/'build/preservation.json').write_text(json.dumps(result,indent=2)+'\n')
(C/'build/source_delta.patch').write_text(''.join(patch))
print(json.dumps(result))
