from __future__ import annotations
import argparse, hashlib, json, subprocess, sys
from pathlib import Path

project=Path(__file__).resolve().parents[4]
candidate=project/'development/player_spectrum_spi12p5'
gate_verify=candidate/'build/gate_verify'
marker_path=candidate/'build/manual/stage_evidence/latest_synthesis.json'
ap=argparse.ArgumentParser(description='Bind the current C11315 FFT/ROM/control audits to one successful synthesis run.')
ap.add_argument('--run-id',required=True)
args=ap.parse_args()
marker=json.loads(marker_path.read_text(encoding='utf-8-sig'))
if marker.get('stage')!='synthesis' or marker.get('status')!='success' or marker.get('runId')!=args.run_id:
    raise SystemExit(f'latest synthesis marker mismatch: {marker}')
record_path=marker_path.parent/marker['record']
record=json.loads(record_path.read_text(encoding='utf-8-sig'))
if record.get('stage')!='synthesis' or record.get('status')!='success' or record.get('runId')!=args.run_id:
    raise SystemExit(f'synthesis record mismatch: {record_path}')
checker=gate_verify/'build_normalized_control_proof.py'
run=subprocess.run([sys.executable,str(checker),'--run-id',args.run_id],cwd=project,check=False)
if run.returncode:
    raise SystemExit(f'normalized proof builder failed with exit={run.returncode}')
proof_path=gate_verify/'normalized_control_proof.json'
out=json.loads(proof_path.read_text(encoding='utf-8-sig'))
gate=candidate/'build/manual/AC201_tf_hdmi_gate.v'
expected_gate=hashlib.sha256(gate.read_bytes()).hexdigest()
if out.get('status')!='PASS' or out.get('synthesis_run_id')!=args.run_id or out.get('gate_netlist_sha256')!=expected_gate:
    raise SystemExit('normalized proof output failed current runId/status/gate SHA binding')
if out.get('normalized_equivalence',{}).get('control_truth_rows_compared')!=192:
    raise SystemExit('proof must contain all 192 state/control truth rows')
if out.get('normalized_equivalence',{}).get('all_controls_match') is not True:
    raise SystemExit('one or more effective gate control truth tables do not match source requests')
if out.get('rom_image_audit',{}).get('status')!='PASS' or out['rom_image_audit'].get('logical_rom_words')!=1536 or out['rom_image_audit'].get('lane_entries')!=3072:
    raise SystemExit('ROM init proof is incomplete or has unexpected word counts')
if out.get('dynamic_gate_regression',{}).get('status')!='PASS':
    raise SystemExit('gate FFT regression is not PASS')
print(json.dumps({'status':out['status'],'run_id':out['synthesis_run_id'],'gate_sha256':out['gate_netlist_sha256'],'controls':out['normalized_equivalence']['control_truth_rows_compared'],'raw_strict_status':out['strict_parameter_audit']['status'],'logical_rom_words':out['rom_image_audit']['logical_rom_words'],'lane_entries':out['rom_image_audit']['lane_entries'],'fft':out['dynamic_gate_regression']['status']}))
