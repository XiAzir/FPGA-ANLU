from pathlib import Path
import json,hashlib,shutil,sys
C=Path(__file__).resolve().parents[2]/'development/player_spectrum_ctrl18';T=C/'build/attempts'/sys.argv[1];M=C/'build/manual';D=T/'physical'
r=json.loads((T/'result.json').read_text());assert r['status']=='SYNTHESIS_PHYSICAL_COMPLETE'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
for e in r['files']+r.get('database_files',[]):assert sha(T/e['path'])==e['sha256'],e['path']
for e in json.loads((D/'build_source_scope.json').read_text(encoding='utf-8-sig')):
 assert sha(C/'src'/e['path'])==e['sha256'].lower(),e['path']
for f in D.rglob('*'):
 if f.is_file():
  q=M/f.relative_to(D);q.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(f,q)
shutil.copy2(T/'route.qor',C/'src/td_project/route.qor')
for stage in ('synthesis','physical'):
 sp=json.loads((M/'stage_evidence'/('latest_'+stage+'.json')).read_text(encoding='utf-8-sig'))
 assert sp['status']=='success' and sp['runId']==r[stage+'_run_id']
print('RESTORED_CERTIFIED_PHYSICAL',r['slices'],r['physical_run_id'])
