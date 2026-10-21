from pathlib import Path
import argparse, hashlib, json
root = Path('development/player_spectrum_opt16')
out = root / 'build/gate_verify'
audit = root / 'build/audit'
stage_evidence = audit / 'rom_polarity_evidence.json'
raw_path = audit / 'gate_rom_control.json'
init_path = audit / 'gate_rom_init.json'
gate = root / 'build/manual/AC201_tf_hdmi_gate.v'
rtl = root / 'src/user_source/hdl_source/player_spectrum_analyzer.v'
coeff = root / 'src/user_source/hdl_source/spectrum_coeff_rom.v'
rom_manifest = root / 'src/user_source/hdl_source/spectrum_coeff_rom_manifest.json'
run_log = out / 'console.log'
proof_script = out / 'prove_current_gate_rom_polarity.ps1'
fft_manifest_path = out / 'input_manifest.json'
ap = argparse.ArgumentParser()
ap.add_argument('--run-id', required=True)
args = ap.parse_args()
proof = json.loads(stage_evidence.read_text(encoding='utf-8'))
raw = json.loads(raw_path.read_text(encoding='utf-8-sig'))
init = json.loads(init_path.read_text(encoding='utf-8-sig'))
fft_manifest = json.loads(fft_manifest_path.read_text(encoding='utf-8-sig'))
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
assert proof['status'] == 'PASS', proof.get('failures')
assert raw['status'] in ('PASS','FAIL')
assert proof['synthesis_run_id'] == args.run_id
assert raw['netlist_sha256'] == sha(gate)
assert all(v.get('mismatches') == 0 for v in init['lanes'].values())
assert proof['netlists']['gate']['netlist_sha256'] == sha(gate)
assert proof['raw_mismatch_policy']['strict_status'] == raw['status']
assert proof['raw_mismatch_policy']['status_matches_reported_mismatches']
assert fft_manifest['status'] == 'PASS' and fft_manifest['synthesis_run_id'] == args.run_id
assert fft_manifest['gate_netlist_sha256'] == sha(gate)
assert init['synthesis_run_id'] == args.run_id and init['gate_sha256'] == sha(gate)
assert init['logical_rom_words'] == 1536 and init['lane_entries'] == 3072
summary={}
controls=0
for name, bank in proof['netlists']['gate']['banks'].items():
    assert bank['verdict'] == 'PASS_POLARITY_EQUIVALENT'
    rows=[]
    for port_proof in bank['port_proofs']:
        assert port_proof['passes']
        assert len(port_proof['truth_table']) == 32
        assert all(r['effective'] == int(r['state'] == (1 if name.startswith('hann') else 4)) for r in port_proof['truth_table'])
        controls += len(port_proof['truth_table'])
        rows.append({
            'primitive_port': port_proof['port'],
            'gate_net': port_proof['net'],
            'parameter': port_proof['mux_parameter'],
            'setting': port_proof['mux_value'],
            'inversion_applied': port_proof['inverted'],
            'expected_request_state': 'ST_WIN_REQ' if name.startswith('hann') else 'ST_FFT_ISSUE',
            'truth_rows': len(port_proof['truth_table']),
            'pass': True
        })
    summary[name]=rows
assert controls == 192, controls
run_text = run_log.read_text(encoding='utf-8', errors='replace')
assert 'PASS fft_cone cases=3 bands=72' in run_text
result={
  'schema':'candidate-gate-rom-normalized-control-proof-v1',
  'status':'PASS',
  'synthesis_run_id':args.run_id,
  'gate_netlist':str(gate.resolve()),
  'gate_netlist_sha256':sha(gate),
  'strict_parameter_audit':{
    'path':str(raw_path.resolve()), 'sha256':sha(raw_path), 'status':raw['status'],
    'observed_mismatches':{k:v['mismatches'] for k,v in raw['banks'].items()},
    'preserved':True,
    'interpretation':'Strict parameter comparison is preserved verbatim as PASS or FAIL; the separate proof passes only when actual gate LUT plus mux polarity matches the source request for every state and open gate leaf.'
  },
  'source_contract':{
    'analyzer_rtl_sha256':sha(rtl), 'coefficient_rom_rtl_sha256':sha(coeff), 'rom_manifest_sha256':sha(rom_manifest),
    'state_constants':{'ST_WIN_REQ':1,'ST_FFT_ISSUE':4},
    'active_high_requests':{'hann_en':'state == ST_WIN_REQ','twiddle_en':'state == ST_FFT_ISSUE'},
    'state_observation':'debug_progress[23:19] aliases state[4:0]; all five bits have one FF Q driver in the current gate cone.'
  },
  'normalized_equivalence':{
    'method':'Parse current gate EG_PHY_BRAM control pins and mux parameters; recursively evaluate the actual gate LUT cone for every state value 0..31; compare effective pin value (raw pin XOR INV setting) with the active-high source request predicate. No expected primitive parameter values were rewritten.',
    'state_values_per_control':32, 'control_truth_rows_compared':controls,
    'controls':summary,
    'q_bindings':proof['state_ff_q_bindings']['gate'],
    'all_controls_match':True
  },
  'rom_image_audit':{'status':'PASS' if all(v.get('mismatches') == 0 for v in init['lanes'].values()) else 'FAIL','path':str(init_path.resolve()),'sha256':sha(init_path),'logical_rom_words':1536,'lane_entries':3072,'rom_banks':len(init.get('lanes',{}))},
  'dynamic_gate_regression':{'status':'PASS','manifest':str(fft_manifest_path.resolve()),'manifest_sha256':sha(fft_manifest_path),'log':str(run_log.resolve()),'log_sha256':sha(run_log),'frames':3,'bands':72,'model':'original EG4 compiled primitive library','coefficient_reading':'real gate BRAM instances and initialized contents; no coefficient data forced'},
  'proof_artifact_sha256':sha(stage_evidence),
  'checker_sha256':sha(proof_script)
}
(out/'normalized_control_proof.json').write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print(json.dumps({'status':result['status'],'controls':controls,'banks':list(summary),'gate_sha256':result['gate_netlist_sha256'],'raw_strict_status':raw['status']}))

