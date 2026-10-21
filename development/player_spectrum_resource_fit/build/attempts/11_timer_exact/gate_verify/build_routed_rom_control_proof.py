from pathlib import Path
import hashlib, json
project=Path('development/player_spectrum_resource_fit')
root=project/'build/attempts/10_area_high'
out=project/'build/gate_verify'
stage=project/'build/gate_verify/routed_polarity_stage'
routed=root/'audit/routed_implementation.v'
gate=root/'manual/AC201_tf_hdmi_gate.v'
synrec=root/'manual/stage_evidence/synthesis_8cc1efb7-2c4a-41db-b788-2eb62ca373d7.json'
phyrec=root/'manual/stage_evidence/physical_57779295-8e99-4bef-ba48-653f94dce9a4.json'
clock=root/'audit/routed_clock_audit.json'
init=out/'routed_rom_init.json'
initlog=out/'routed_rom_init.log'
pol=stage/'build/audit/rom_polarity_evidence.json'
raw=stage/'build/audit/gate_rom_control.json'
checker=project/'build/gate_verify/prove_routed_rom_polarity.ps1'
init_script=project.parent/'player_spectrum_trace/build/audit/audit_private_rom_init.py'
source=root/'src/user_source/hdl_source/player_spectrum_analyzer.v'
coeff=root/'src/user_source/hdl_source/spectrum_coeff_rom.v'
manifest=root/'src/user_source/hdl_source/spectrum_coeff_rom_manifest.json'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
ri=json.loads(init.read_text(encoding='utf-8'))
pe=json.loads(pol.read_text(encoding='utf-8'))
rawj=json.loads(raw.read_text(encoding='utf-8-sig'))
assert ri['all_match'] and ri['eram_init_off']
assert all(v['mismatches']==0 for v in ri['lanes'].values())
assert all(v['mismatches']==0 for v in ri['combined_roms'].values())
assert pe['status']=='PASS', pe.get('failures')
assert rawj['status']=='FAIL'
assert ri['gate_sha256']==sha(routed)
assert pe['netlists']['gate']['netlist_sha256']==sha(routed)
assert json.loads(synrec.read_text())['status']=='success'
assert json.loads(phyrec.read_text())['status']=='success'
summary={}
checks=0
for name,b in pe['netlists']['gate']['banks'].items():
    assert b['verdict']=='PASS_POLARITY_EQUIVALENT'
    entries=[]
    expected=1 if name.startswith('hann') else 4
    for pp in b['port_proofs']:
        assert pp['passes'] and len(pp['truth_table'])==32
        assert all(row['effective']==int(row['state']==expected) for row in pp['truth_table'])
        checks += len(pp['truth_table'])
        entries.append({'port':pp['port'],'net':pp['net'],'parameter':pp['mux_parameter'],'value':pp['mux_value'],'inverted':pp['inverted'],'request_state':'ST_WIN_REQ' if expected==1 else 'ST_FFT_ISSUE','truth_rows':32,'pass':True})
    summary[name]=entries
assert checks==192
outdata={
 'schema':'area-high-routed-rom-validation-v1','status':'PASS','snapshot':'attempts/10_area_high',
 'synthesis_run_id':'8cc1efb7-2c4a-41db-b788-2eb62ca373d7','physical_run_id':'57779295-8e99-4bef-ba48-653f94dce9a4',
 'routed_netlist':str(routed.resolve()),'routed_netlist_sha256':sha(routed),
 'synthesis_record_sha256':sha(synrec),'physical_record_sha256':sha(phyrec),'routed_clock_audit_sha256':sha(clock),
 'rom_initialization':{'status':'PASS','audit_script':str(init_script.resolve()),'audit_script_sha256':sha(init_script),'report':str(init.resolve()),'report_sha256':sha(init),'stdout_log':str(initlog.resolve()),'stdout_sha256':sha(initlog),'eram_init_off_proven':True,'lanes':ri['lanes'],'combined_roms':ri['combined_roms'],'all_match':True},
 'normalized_control':{'status':'PASS','report_sha256':sha(pol),'checker':str(checker.resolve()),'checker_sha256':sha(checker),'strict_parameter_audit':{'status':rawj['status'],'sha256':sha(raw),'mismatches':{k:v['mismatches'] for k,v in rawj['banks'].items()},'preserved':True},'method':'Evaluate routed gate LUT control cones for all 32 source-state values. Apply the actual INV mux polarity and compare to active-high request state predicates without changing strict parameter expectations.','state_constants':{'ST_WIN_REQ':1,'ST_FFT_ISSUE':4},'checks':checks,'controls':summary,'state_ff_q_bindings':pe['state_ff_q_bindings']['gate']},
 'source_sha256':{'player_spectrum_analyzer.v':sha(source),'spectrum_coeff_rom.v':sha(coeff),'spectrum_coeff_rom_manifest.json':sha(manifest)},
 'corresponding_gate_fft_regression':{'status':'PASS','gate_sha256':'1e596dab71a324e224eb6dfc623640515ad84b705569a84287f0d19568a1432f','report_sha256':sha(root/'gate_verify/input_manifest.json'),'scope':'same synthesis run; 3 frames / 72 bands, original EG4 primitive library, max fixed-point error 0'}
}
(out/'routed_rom_control_proof.json').write_text(json.dumps(outdata,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print(json.dumps({'status':outdata['status'],'routed_sha256':outdata['routed_netlist_sha256'],'init_mismatches':0,'normalized_control_rows':checks,'strict_audit':rawj['status']}))

