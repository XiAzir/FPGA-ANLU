from pathlib import Path
import shutil,json,hashlib
R=Path(__file__).resolve().parents[2];C=R/'development/player_spectrum_arch17';B=C/'build'
T=B/'attempts/A00_buildid_only';T.mkdir(parents=True,exist_ok=False)
for p in (B/'manual').rglob('*'):
 if p.is_file() and p.suffix.lower() not in ('.db','.dmp'):
  q=T/'manual'/p.relative_to(B/'manual');q.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,q)
for name in ('fat32_file_sector.v','top_tf_hdmi_audio.v','player_status_monitor.v'):
 shutil.copy2(C/'src/user_source/hdl_source'/name,T/name)
shutil.copy2(C/'src/td_project/AC201_tf_hdmi.al',T/'AC201_tf_hdmi.al')
result={'status':'CONTROL_COMPLETE','synthesis_run_id':json.loads((B/'manual/stage_evidence/latest_synthesis.json').read_text(encoding='utf-8-sig'))['runId'],'delta':'C11316 to C11317 Build ID constants and project location only; all algorithm RTL bytes remain C11316','A00':{'lut':12929,'ff':7708,'dsp':9,'generic_lut':8787},'files':[{'path':str(p.relative_to(T)),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in T.rglob('*') if p.is_file()]}
(T/'result.json').write_text(json.dumps(result,indent=2));print('A00 archived',result['synthesis_run_id'])
