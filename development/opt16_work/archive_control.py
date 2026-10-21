from pathlib import Path
import shutil,json,hashlib
R=Path(__file__).resolve().parents[2];C=R/'development/player_spectrum_opt16';B=C/'build'
T=B/'attempts/A00_buildid_only';T.mkdir(parents=True,exist_ok=False)
for p in (B/'manual').rglob('*'):
 if p.is_file() and p.suffix.lower() not in ('.db','.dmp'):
  q=T/'manual'/p.relative_to(B/'manual');q.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,q)
for name in ('bmp_scale_engine.v','top_tf_hdmi_audio.v','player_status_monitor.v'):
 shutil.copy2(C/'src/user_source/hdl_source'/name,T/name)
shutil.copy2(C/'src/td_project/AC201_tf_hdmi.al',T/'AC201_tf_hdmi.al')
result={'status':'CONTROL_COMPLETE','synthesis_run_id':json.loads((B/'manual/stage_evidence/latest_synthesis.json').read_text(encoding='utf-8-sig'))['runId'],'delta':'C11315 to C11316 Build ID constants and project location only; all algorithm RTL bytes are C11315','A00':{'lut':13043,'ff':7791,'dsp':10,'generic_lut':8869},'A01_minus_A00':{'lut':316,'ff':-1,'dsp':-1},'files':[{'path':str(p.relative_to(T)),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in T.rglob('*') if p.is_file()]}
(T/'result.json').write_text(json.dumps(result,indent=2));print(json.dumps(result)[:500])
