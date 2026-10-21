from pathlib import Path
import hashlib,json,re,shutil,sys
C=Path(__file__).resolve().parents[2]/'development/player_spectrum_ctrl18';T=C/'build/attempts'/sys.argv[1];M=C/'build/manual'
p=T/'result.json';r=json.loads(p.read_text());pp=json.loads((M/'stage_evidence/latest_physical.json').read_text(encoding='utf-8-sig'))
pr=json.loads((M/'stage_evidence'/pp['record']).read_text(encoding='utf-8-sig'))
assert pp['status']=='success' and pr['synthesisRunId']==r['synthesis_run_id']
D=T/'physical';D.mkdir(exist_ok=False)
for f in M.rglob('*'):
 if f.is_file():
  q=D/f.relative_to(M);q.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(f,q)
shutil.copy2(C/'src/td_project/route.qor',T/'route.qor')
r.update(status='SYNTHESIS_PHYSICAL_COMPLETE',slices=int(re.search(r'#slices\s*\|\s*(\d+)',(T/'route.qor').read_text())[1]),physical_run_id=pp['runId'],timing=(M/'AC201_tf_hdmi_phy.ts').read_text().strip())
files=[f for f in sorted(T.rglob('*')) if f.is_file() and f!=p]
r['files']=[{'path':f.relative_to(T).as_posix(),'sha256':hashlib.sha256(f.read_bytes()).hexdigest()} for f in files if f.suffix!='.db']
r['database_files']=[{'path':f.relative_to(T).as_posix(),'sha256':hashlib.sha256(f.read_bytes()).hexdigest()} for f in files if f.suffix=='.db']
p.write_text(json.dumps(r,indent=2)+'\n');print(sys.argv[1],r['slices'],r['timing'])
