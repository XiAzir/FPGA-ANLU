from pathlib import Path
import json,hashlib,shutil,sys
R=Path(__file__).resolve().parents[2];C=R/'development/player_spectrum_ctrl18'
T=C/'build/attempts'/sys.argv[1];M=C/'build/manual';A=T/'build/manual'
r=json.loads((T/'result.json').read_text());sr=json.loads((A/'stage_evidence/latest_synthesis.json').read_text(encoding='utf-8-sig'))
assert sr['status']=='success' and sr['runId']==r['synthesis_run_id']
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
for e in r['files']+r.get('database_files',[]):assert sha(T/e['path'])==e['sha256'],e['path']
for name in ('scripts/build_candidate.ps1','scripts/build_evidence.ps1','scripts/build_manual_syn.tcl','scripts/build_manual_phy.tcl','scripts/fix_hold.tcl','scripts/generate_bit.tcl'):
 assert sha(T/name)==sha(C/name),name
for name in ('AC201_tf_hdmi_gate.db','AC201_tf_hdmi_rtl.db','AC201_tf_hdmi_elaborate.db','AC201_tf_hdmi_gate.v','AC201_tf_hdmi_gate.area','AC201_tf_hdmi_gate.ts','AC201_tf_hdmi_gate.timing','synthesis_console.log','strategy_actual.rtl.log','strategy_actual.gate.log','build_source_scope.json'):
 shutil.copy2(A/name,M/name)
for name in ('latest_synthesis.json',sr['record']):shutil.copy2(A/'stage_evidence'/name,M/'stage_evidence'/name)
for e in json.loads((M/'build_source_scope.json').read_text(encoding='utf-8-sig')):
 assert sha(C/'src'/e['path'])==e['sha256'].lower(),e['path']
print('RESTORED_CERTIFIED_SYNTHESIS',sr['runId'])
