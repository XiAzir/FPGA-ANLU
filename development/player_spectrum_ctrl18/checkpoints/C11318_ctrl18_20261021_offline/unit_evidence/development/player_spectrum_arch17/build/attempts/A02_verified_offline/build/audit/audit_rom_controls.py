from pathlib import Path
import argparse,hashlib,json,re
p=Path(__file__).resolve().parents[2]
ap=argparse.ArgumentParser(description='Strict, source-manifest-bound BRAM control parameter comparison for C11317.')
ap.add_argument('--run-id',required=True)
ap.add_argument('--kind',choices=('gate','routed'),default='gate')
ap.add_argument('--netlist',type=Path,required=True)
ap.add_argument('--output',type=Path,required=True)
a=ap.parse_args()
manual=p/'build/manual'; evidence=manual/'stage_evidence'
marker_path=evidence/'latest_synthesis.json'; marker=json.loads(marker_path.read_text(encoding='utf-8-sig'))
if marker.get('stage')!='synthesis' or marker.get('status')!='success' or marker.get('runId')!=a.run_id:
    raise SystemExit(f'latest successful synthesis pointer does not match {a.run_id}')
record_path=evidence/marker['record']; record=json.loads(record_path.read_text(encoding='utf-8-sig'))
if record.get('stage')!='synthesis' or record.get('status')!='success' or record.get('runId')!=a.run_id:
    raise SystemExit(f'synthesis record does not match requested run: {record_path}')
gate_db=manual/'AC201_tf_hdmi_gate.db'
if not gate_db.is_file() or hashlib.sha256(gate_db.read_bytes()).hexdigest()!=record.get('gateDbHash'):
    raise SystemExit('gate database hash mismatch against synthesis record')
physical_pointer_path=evidence/'latest_physical.json'; physical_pointer={}; physical_record={}; physical_record_path=None; route_db=None
if a.kind=='gate':
    expected_netlist=manual/'AC201_tf_hdmi_gate.v'
else:
    if not physical_pointer_path.is_file(): raise SystemExit('latest physical pointer is missing')
    physical_pointer=json.loads(physical_pointer_path.read_text(encoding='utf-8-sig'))
    if physical_pointer.get('status')!='success': raise SystemExit(f'latest physical stage is not successful: {physical_pointer}')
    physical_record_path=evidence/physical_pointer['record']; physical_record=json.loads(physical_record_path.read_text(encoding='utf-8-sig'))
    if (physical_record.get('synthesisRunId')!=a.run_id or physical_record.get('gateDbHash')!=record.get('gateDbHash') or physical_record.get('scopeHash')!=record.get('scopeHash')):
        raise SystemExit('physical record is not linked to the requested synthesis run')
    expected_netlist=p/'build/audit/routed_implementation.v'
    route_db=p/'build/manual/AC201_tf_hdmi_pr.db'
    if not route_db.is_file() or hashlib.sha256(route_db.read_bytes()).hexdigest()!=physical_record.get('artifacts',{}).get('AC201_tf_hdmi_pr.db'):
        raise SystemExit('current routed database SHA differs from the successful physical record')
    if expected_netlist.stat().st_mtime < __import__('datetime').datetime.fromisoformat(physical_record['completedUtc'].replace('Z','+00:00')).timestamp():
        raise SystemExit('exported routed netlist predates successful physical completion')
if a.netlist.resolve()!=expected_netlist.resolve():
    raise SystemExit(f'{a.kind} netlist path is not the stage-bound path: {expected_netlist}')
if a.kind=='gate' and a.netlist.stat().st_mtime < __import__('datetime').datetime.fromisoformat(record['startedUtc'].replace('Z','+00:00')).timestamp():
    raise SystemExit('gate netlist predates requested successful synthesis run')
manifest=json.loads((p/'src/user_source/hdl_source/spectrum_coeff_rom_manifest.json').read_text(encoding='utf-8-sig'))
mapping=manifest['inferred_read_control_mapping']
text=a.netlist.read_text(encoding='utf-8',errors='replace')
common={'READBACK':'OFF','REGMODE_A':'NOREG','REGMODE_B':'NOREG','WRITEMODE_A':'NORMAL','WRITEMODE_B':'NORMAL','GSR':'ENABLE','RESETMODE':'ASYNC','ASYNC_RESET_RELEASE':'SYNC'}
found={}
for m in re.finditer(r'EG_PHY_BRAM\s*#\((.*?)\)\s+\\(\S+)\s*\(',text,re.S):
    name=re.search(r'(?:^|/)u_(hann_low|hann_high|twiddle_low|twiddle_high)$',m.group(2))
    if not name: continue
    key=name.group(1); kind='hann' if key.startswith('hann') else 'twiddle'
    actual=dict(re.findall(r'\.([A-Z0-9_]+)\s*\(\s*"([^"]+)"\s*\)',m.group(1)))
    expected={**common,**mapping[kind]['control_parameters'],'MODE':mapping[kind]['mode'],'DATA_WIDTH_A':str(mapping[kind]['data_width_a_b']),'DATA_WIDTH_B':str(mapping[kind]['data_width_a_b'])}
    mismatch={k:{'expected':v,'actual':actual.get(k)} for k,v in expected.items() if actual.get(k)!=v}
    found[key]={'compared_parameters':len(expected),'mismatches':mismatch,'actual':{k:actual.get(k) for k in expected}}
expected_banks={'hann_low','hann_high','twiddle_low','twiddle_high'}
if set(found)!=expected_banks: raise SystemExit(f'expected all four coefficient BRAM banks, found {sorted(found)}')
status='PASS' if all(not x['mismatches'] for x in found.values()) else 'FAIL'
result={'schema':'c11317-strict-rom-control-parameters-v1','status':status,'stage':a.kind,'synthesis_run_id':a.run_id,
 'synthesis_marker':str(marker_path.resolve()),'synthesis_marker_sha256':hashlib.sha256(marker_path.read_bytes()).hexdigest(),
 'synthesis_record':str(record_path.resolve()),'synthesis_record_sha256':hashlib.sha256(record_path.read_bytes()).hexdigest(),
 'gate_database_sha256':hashlib.sha256(gate_db.read_bytes()).hexdigest(),
 'physical_pointer_sha256':hashlib.sha256(physical_pointer_path.read_bytes()).hexdigest() if a.kind=='routed' else None,
 'physical_record_sha256':hashlib.sha256(physical_record_path.read_bytes()).hexdigest() if physical_record_path else None,
 'route_database_sha256':hashlib.sha256(route_db.read_bytes()).hexdigest() if route_db else None,
 'physical_run_id':physical_record.get('runId') if physical_record else None,
 'netlist':str(a.netlist.resolve()),'netlist_sha256':hashlib.sha256(a.netlist.read_bytes()).hexdigest(),
 'coefficient_manifest_sha256':hashlib.sha256((p/'src/user_source/hdl_source/spectrum_coeff_rom_manifest.json').read_bytes()).hexdigest(),
 'banks':found,'scope':'Strict parameter comparison against the coefficient ROM source manifest; the report records actual SIG/INV settings and differences without normalizing them.'}
a.output.parent.mkdir(parents=True,exist_ok=True)
a.output.write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print(json.dumps({'status':status,'kind':a.kind,'run_id':a.run_id,'netlist_sha256':result['netlist_sha256'],'banks':{k:v['mismatches'] for k,v in found.items()}},ensure_ascii=False))
# Strict mismatch remains visible in the JSON status. Exit 0 indicates the audit completed and bound all four cells.
raise SystemExit(0)
