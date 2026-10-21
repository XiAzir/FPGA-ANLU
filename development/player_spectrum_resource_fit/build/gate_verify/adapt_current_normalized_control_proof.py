from __future__ import annotations
import argparse, hashlib, json
from pathlib import Path

here=Path(__file__).resolve()
project=here.parents[4]
candidate=project/'development/player_spectrum_resource_fit'
verify=candidate/'build/gate_verify'
source=verify/'build_normalized_control_proof.py'
marker_path=candidate/'build/manual/stage_evidence/latest_synthesis.json'
ap=argparse.ArgumentParser()
ap.add_argument('--run-id',required=True)
args=ap.parse_args()
marker=json.loads(marker_path.read_text(encoding='utf-8-sig'))
if marker.get('stage')!='synthesis' or marker.get('status')!='success' or marker.get('runId')!=args.run_id:
    raise SystemExit(f'latest synthesis marker mismatch: {marker}')
record_path=marker_path.parent/marker['record']
record=json.loads(record_path.read_text(encoding='utf-8-sig'))
if record.get('stage')!='synthesis' or record.get('status')!='success' or record.get('runId')!=args.run_id:
    raise SystemExit(f'synthesis record mismatch: {record_path}')
code=source.read_text(encoding='utf-8')
old="'synthesis_run_id':'8cc1efb7-2c4a-41db-b788-2eb62ca373d7'"
new=f"'synthesis_run_id':'{args.run_id}'"
if code.count(old)!=1: raise SystemExit('expected exactly one historical runId binding in reference checker')
code=code.replace(old,new)
exec(compile(code,str(source),'exec'),{'__name__':'__main__','__file__':str(source)})
out=json.loads((verify/'normalized_control_proof.json').read_text(encoding='utf-8'))
expected_gate=hashlib.sha256((candidate/'build/manual/AC201_tf_hdmi_gate.v').read_bytes()).hexdigest()
if out.get('status')!='PASS' or out.get('synthesis_run_id')!=args.run_id or out.get('gate_netlist_sha256')!=expected_gate:
    raise SystemExit('normalized proof output failed current runId/status/gate SHA binding')
if out['dynamic_gate_regression']['status']!='PASS' or out['rom_image_audit']['status']!='PASS':
    raise SystemExit('normalized proof omitted successful current gate FFT/ROM initialization audits')
print(json.dumps({'status':out['status'],'run_id':out['synthesis_run_id'],'gate_sha256':out['gate_netlist_sha256'],'controls':out['normalized_equivalence']['control_truth_rows_compared'],'strict_raw_status':out['strict_parameter_audit']['status'],'init':out['rom_image_audit']['status'],'fft':out['dynamic_gate_regression']['status']},ensure_ascii=False))
