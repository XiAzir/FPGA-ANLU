from pathlib import Path
import re,json,hashlib,shutil
R=Path(__file__).resolve().parents[2];C=R/'development/player_spectrum_arch17';W=Path(__file__).parent;B=C/'build'
T=B/'attempts/A03_compile_order_rejected';T.mkdir(parents=True,exist_ok=False)
p=C/'src/td_project/AC201_tf_hdmi.al';q=W/'integration/AC201_tf_hdmi.al'
a=q.read_text(encoding='utf-8-sig');b=p.read_text(encoding='utf-8-sig')
expected=re.sub(r'(<Attr Name="CompileOrder" Val=")(\d+)("/>)',lambda m:m[1]+str(int(m[2])-1 if int(m[2])>=39 else int(m[2]))+m[3],a)
assert b==expected,'TD changed more than source-list compile order'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
old_sha=sha(q);new_sha=sha(p)
for x in (B/'manual').rglob('*'):
 if x.is_file() and x.suffix.lower() not in ('.db','.dmp'):
  y=T/'manual'/x.relative_to(B/'manual');y.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(x,y)
shutil.copy2(q,T/'project_before.al');shutil.copy2(p,T/'project_after.al')
receipt={'status':'TOOL_SYNTHESIS_COMPLETE_EVIDENCE_REJECTED','reason':'TD source-list CompileOrder normalized after retiring old arbiter file; context hash changed. No certification override. Fix normalized metadata and rebuild.','old_project_sha256':old_sha,'new_project_sha256':new_sha,'gate_metrics_uncertified':{'lut':12605,'ff':7369},'stage_run_id':'cbd66311-f543-461c-8e74-f8a2636bc77d','files':[{'path':str(x.relative_to(T)),'sha256':sha(x)} for x in T.rglob('*') if x.is_file()]}
(T/'result.json').write_text(json.dumps(receipt,indent=2))
q.write_bytes(p.read_bytes())
selected=json.loads((B/'selected_changes.json').read_text(encoding='utf-8-sig'))
selected['td_project/AC201_tf_hdmi.al']['sha256']=new_sha
(B/'selected_changes.json').write_text(json.dumps(selected,indent=2))
print('Normalized shared project compile order; RTL, constraints, Tcl unchanged')
