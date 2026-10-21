from pathlib import Path
import json,hashlib,subprocess
ROOT=Path(__file__).resolve().parents[2]
CANDIDATE=ROOT/'development/player_spectrum_resource_fit'
SOURCE=ROOT/'development/player_spectrum_trace'
DOCS=Path('E:/QQ CACHE/Download/安路资料')
records=json.loads((CANDIDATE/'build/baseline/source_sha256.json').read_text(encoding='utf-8'))
changed=[r['path'] for r in records if hashlib.sha256((SOURCE/r['path']).read_bytes()).hexdigest()!=r['sha256']]
assert not changed,changed
bits={}
for filename,expected in [('bmp_scale.bit','C60464C0D4396D316DB7622E4CB0B70B5DE12C25148AFE234AC7C795C818625D'),('spectrum_trace.bit','60AE6B971CE1F9ED09D76BEC14CF88DFC25CDFE7CBBEBE5DD9FC070115B812CE')]:
    actual=hashlib.sha256((ROOT/'download'/filename).read_bytes()).hexdigest().upper()
    assert actual==expected,(filename,actual)
    bits[filename]=actual
provenance=json.loads((DOCS/'开发记录/专题记录/资源优化/C11313_20261020/交接摘录/02_data/source_provenance.json').read_text(encoding='utf-8'))
blobs=[]
for entry in provenance['source_files']:
    if 'git_blob_sha' in entry:
        actual=subprocess.check_output(['git','hash-object',entry['path']],cwd=ROOT,text=True).strip()
        blobs.append(dict(path=entry['path'],external_main_blob=entry['git_blob_sha'],local_blob=actual,match=actual==entry['git_blob_sha']))
result=dict(status='PASS',original_scope_files=len(records),changed_original_files=changed,protected_bits=bits,external_handoff_blob_comparison=blobs)
(CANDIDATE/'build/preservation.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
print(json.dumps(dict(status=result['status'],original_scope_files=len(records),protected_bits=len(bits),external_blob_matches=sum(x['match'] for x in blobs),external_blob_total=len(blobs)),indent=2))
