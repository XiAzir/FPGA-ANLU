from pathlib import Path
import hashlib,json,re,shutil,sys
R=Path(__file__).resolve().parents[2];C=R/'development/player_spectrum_ctrl18';B=C/'build'
label=sys.argv[1];T=B/'attempts'/label
T.mkdir(parents=True,exist_ok=False)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
for f in ('src','scripts','build/manual'):
 for p in (C/f).rglob('*'):
  if not p.is_file() or p.suffix.lower() in ('.vvp','.pyc','.dmp'):continue
  q=T/p.relative_to(C);q.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,q)
for f in ('selected_changes.json','preservation.json','source_delta.patch'):
 if (B/f).exists():shutil.copy2(B/f,T/f)
area=(B/'manual/AC201_tf_hdmi_gate.area').read_text()
metrics={k:int(re.search(r'^\s*#'+k+r'\s+(\d+)',area,re.M)[1]) for k in ('lut','reg','bram9k','dsp','Total_luts')}
sp=B/'manual/stage_evidence/latest_synthesis.json';sr=json.loads(sp.read_text(encoding='utf-8-sig'));assert sr['status']=='success'
result={'status':'SYNTHESIS_COMPLETE','label':label,'synthesis_run_id':sr['runId'],'gate_area':metrics,'files':[{'path':p.relative_to(T).as_posix(),'sha256':sha(p)} for p in sorted(T.rglob('*')) if p.is_file() and p.suffix!='.db'],'database_files':[{'path':p.relative_to(T).as_posix(),'sha256':sha(p)} for p in sorted(T.rglob('*.db')) if p.is_file()]}
(T/'result.json').write_text(json.dumps(result,indent=2)+'\n');print(label,metrics)
