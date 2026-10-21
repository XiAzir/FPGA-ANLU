from pathlib import Path
import json, hashlib, shutil, sys, re
R=Path(__file__).resolve().parents[2]
C=R/'development/player_spectrum_ctrl18'; B=C/'build'
T=B/'attempts'/sys.argv[1];T.mkdir(parents=True,exist_ok=False)
for p in (B/'manual').rglob('*'):
 if p.is_file() and p.suffix.lower() not in ('.db','.dmp'):
  q=T/'manual'/p.relative_to(B/'manual');q.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,q)
for p in (C/'src').rglob('*'):
 if p.is_file():
  q=T/'src'/p.relative_to(C/'src');q.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,q)
shutil.copy2(B/'selected_changes.json',T/'selected_changes.json')
area=(B/'manual/AC201_tf_hdmi_gate.area').read_text()
metrics={k:int(re.search(r'^#'+k+r'\s+(\d+)',area,re.M)[1]) for k in ('lut','reg','dsp','Total_luts')}
result={'status':'SYNTHESIS_COMPLETE','synthesis_run_id':json.loads((B/'manual/stage_evidence/latest_synthesis.json').read_text(encoding='utf-8-sig'))['runId'],'metrics':metrics,'files':[{'path':str(p.relative_to(T)),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in T.rglob('*') if p.is_file()]}
(T/'result.json').write_text(json.dumps(result,indent=2));print(json.dumps({k:v for k,v in result.items() if k!='files'}))
