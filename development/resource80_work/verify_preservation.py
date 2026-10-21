"""Recheck original handoff and the user-validated C11313 without changing them."""
from pathlib import Path
import json, hashlib, subprocess
ROOT=next(p for p in Path(__file__).resolve().parents if (p/'scripts/anlu_tools.ps1').is_file() and (p/'download').is_dir())
C=ROOT/'development/player_spectrum_resource_80'
P=ROOT/'development/player_spectrum_resource_fit'
def read(p): return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def check(scope, base):
    changes=[r['path'] for r in scope if sha(base/r['path'])!=r['sha256'].lower()]
    assert not changes, changes
    return {'files':len(scope),'changes':changes}
parent=check(read(C/'build/baseline/C11313_source_sha256.json'),P)
configuration=[]
for entry in read(C/'build/baseline/C11313_source_sha256.json'):
    path=entry['path'].replace('\\','/')
    if '/constraints_source/' in path or '/al_ip/' in path:
        assert sha(C/path)==entry['sha256'].lower(),path
        configuration.append(path)
original=check(read(P/'build/baseline/source_sha256.json'),ROOT/'development/player_spectrum_trace')
expected={
 'bmp_scale.bit':'c60464c0d4396d316db7622e4cb0b70b5de12c25148afe234ac7c795c818625d',
 'spectrum_trace.bit':'60ae6b971ce1f9ed09d76bec14cf88dfc25cdfe7cbbebe5dd9fc070115b812ce',
 'spectrum_resource_fit.bit':'3d85e5cdda40f1a91697ddf3c0275c52cf7bcee76d31af20503293b5a7428ca1'}
for name,h in expected.items(): assert sha(ROOT/'download'/name)==h,name
blobs=read(P/'build/preservation.json')['external_handoff_blob_comparison']
for entry in blobs:
    actual=subprocess.check_output(['git','hash-object',entry['path']],cwd=ROOT,text=True).strip()
    assert actual==entry['external_main_blob'],entry['path']
checkpoint=P/'checkpoints/C11313_resource_fit_20261020_offline'
manifest=read(checkpoint/'manifest.json')
for entry in manifest['files']:
    assert sha(checkpoint/entry['path'])==entry['sha256'],entry['path']
assert sha(checkpoint/'manifest.json')=='f4096189b2e417a6816a3f024101b0f0bc1fc4655dd5b7d1fd7dc5c8dac3b46a'
result={'status':'PASS','C11313_parent_scope':parent,'C11312_original_scope':original,
 'protected_bits':expected,'external_blob_matches':len(blobs),
 'C11313_frozen_files':len(manifest['files']),'C11313_frozen_manifest_sha256':sha(checkpoint/'manifest.json'),
 'candidate_unchanged_constraints_and_ip':configuration}
(C/'build/preservation.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps(result))
