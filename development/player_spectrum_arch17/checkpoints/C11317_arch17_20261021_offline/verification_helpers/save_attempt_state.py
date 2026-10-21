from pathlib import Path
import json,hashlib,shutil,sys,re
R=Path(__file__).resolve().parents[2];C=R/'development/player_spectrum_arch17'
T=C/'build/attempts'/sys.argv[1];T.mkdir(parents=True,exist_ok=False)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
for folder in ('src','scripts','build/manual'):
 for p in (C/folder).rglob('*'):
  if not p.is_file() or p.suffix.lower() in ('.vvp','.pyc','.dmp'):continue
  q=T/p.relative_to(C);q.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,q)
shutil.copy2(C/'build/selected_changes.json',T/'selected_changes.json')
area=(T/'build/manual/AC201_tf_hdmi_gate.area').read_text()
metrics={k:int(re.search(r'^#'+k+r'\s+(\d+)',area,re.M)[1]) for k in ('lut','reg','dsp','Total_luts')}
pointers={s:json.loads((T/'build/manual/stage_evidence'/('latest_'+s+'.json')).read_text(encoding='utf-8-sig')) for s in ('synthesis','physical')}
assert pointers['synthesis']['status']=='success'
result={'status':'SYNTHESIS_COMPLETE','synthesis_run_id':pointers['synthesis']['runId'],'metrics':metrics,'physical':None,'files':[],'database_files':[]}
record=json.loads((T/'build/manual/stage_evidence'/pointers['physical']['record']).read_text(encoding='utf-8-sig'))
if pointers['physical']['status']=='success' and record['synthesisRunId']==pointers['synthesis']['runId']:
 result['physical']={'run_id':pointers['physical']['runId'],'slices':int(re.search(r'#slices\s*\|\s*(\d+)',(T/'src/td_project/route.qor').read_text())[1]),'timing':(T/'build/manual/AC201_tf_hdmi_phy.ts').read_text().strip()}
for p in sorted(T.rglob('*')):
 if p.is_file():result['database_files' if p.suffix=='.db' else 'files'].append({'path':str(p.relative_to(T)),'sha256':sha(p)})
(T/'result.json').write_text(json.dumps(result,indent=2));print(json.dumps({k:v for k,v in result.items() if k not in ('files','database_files')}))
