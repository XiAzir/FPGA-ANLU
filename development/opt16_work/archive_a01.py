from pathlib import Path
import shutil,json,hashlib
R=Path(__file__).resolve().parents[2];C=R/'development/player_spectrum_opt16';B=C/'build'
T=B/'attempts/A01_shared_multiplier';T.mkdir(parents=True,exist_ok=False)
for p in (B/'manual').rglob('*'):
 if p.is_file() and p.suffix.lower() not in ('.db','.dmp'):
  q=T/'manual'/p.relative_to(B/'manual');q.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,q)
for name in ('bmp_scale_engine.v','top_tf_hdmi_audio.v','player_status_monitor.v'):
 shutil.copy2(C/'src/user_source/hdl_source'/name,T/name)
shutil.copy2(C/'src/td_project/AC201_tf_hdmi.al',T/'AC201_tf_hdmi.al')
result={'status':'REJECTED_FOR_LUT_COST','synthesis_run_id':json.loads((B/'manual/stage_evidence/latest_synthesis.json').read_text(encoding='utf-8-sig'))['runId'],'baseline_C11315':{'lut':13054,'ff':7791,'dsp':10},'A01':{'lut':13359,'ff':7790,'dsp':9},'delta':{'lut':305,'ff':-1,'dsp':-1},'standalone':{'baseline_lut':1062,'shared_lut':1047,'ff':352,'baseline_dsp':5,'shared_dsp':4},'selection':'do not adopt; proceed with validated caller-domain elimination separately','files':[{'path':str(p.relative_to(T)),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in T.rglob('*') if p.is_file()]}
(T/'result.json').write_text(json.dumps(result,indent=2))
print('archived',len(result['files']),result['synthesis_run_id'])
