from __future__ import annotations
import argparse, hashlib, importlib.util, json, sys
from pathlib import Path

here = Path(__file__).resolve()
project = here.parents[4]
candidate = project / 'development/player_spectrum_resource_80'
trace = project / 'development/player_spectrum_trace'
module_path = trace / 'build/audit/audit_private_rom_init.py'
spec = importlib.util.spec_from_file_location('private_rom_audit', module_path)
mod = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = mod
spec.loader.exec_module(mod)
ap = argparse.ArgumentParser()
ap.add_argument('--run-id', required=True)
ap.add_argument('--physical-run-id', required=True)
ap.add_argument('--netlist', type=Path, required=True)
ap.add_argument('--output', type=Path, default=candidate / 'build/audit/routed_rom_init.json')
args = ap.parse_args()
manual = candidate / 'build/manual'
marker_path = manual / 'stage_evidence/latest_synthesis.json'
marker = json.loads(marker_path.read_text(encoding='utf-8-sig'))
if marker.get('stage') != 'synthesis' or marker.get('status') != 'success' or marker.get('runId') != args.run_id:
    raise SystemExit(f'latest synthesis marker does not match requested success run: {marker}')
record_path = marker_path.parent / marker['record']
record = json.loads(record_path.read_text(encoding='utf-8-sig'))
if record.get('status') != 'success' or record.get('runId') != args.run_id or record.get('stage') != 'synthesis':
    raise SystemExit(f'synthesis record does not match requested run: {record_path}')
physical_marker_path = manual / 'stage_evidence/latest_physical.json'
physical_marker = json.loads(physical_marker_path.read_text(encoding='utf-8-sig'))
if physical_marker.get('stage') != 'physical' or physical_marker.get('status') != 'success' or physical_marker.get('runId') != args.physical_run_id:
    raise SystemExit(f'latest physical marker does not match requested successful physical run: {physical_marker}')
physical_record_path = physical_marker_path.parent / physical_marker['record']
physical_record = json.loads(physical_record_path.read_text(encoding='utf-8-sig'))
if physical_record.get('stage') != 'physical' or physical_record.get('status') != 'success' or physical_record.get('runId') != args.physical_run_id or physical_record.get('synthesisRunId') != args.run_id:
    raise SystemExit(f'physical record is not linked to selected synthesis/physical runs: {physical_record_path}')
if physical_record.get('scopeHash') != record.get('scopeHash') or physical_record.get('gateDbHash') != record.get('gateDbHash'):
    raise SystemExit('physical scope or gate database hash differs from selected synthesis record')
route_db = manual / 'AC201_tf_hdmi_pr.db'
if not route_db.is_file() or hashlib.sha256(route_db.read_bytes()).hexdigest() != physical_record.get('artifacts', {}).get('AC201_tf_hdmi_pr.db'):
    raise SystemExit('current physical database SHA differs from selected physical record')
log_path = manual / 'synthesis_console.log'
log = log_path.read_text(encoding='utf-8', errors='replace')
if 'SYNTHESIS_COMPLETE_WITH_GATE_DATABASE' not in log:
    raise SystemExit('current synthesis log lacks successful gate-database completion marker')
routed = args.netlist.resolve()
if routed != (candidate / 'build/audit/routed_implementation.v').resolve():
    raise SystemExit('routed netlist path is not the current candidate export path')
if routed.stat().st_mtime < __import__('datetime').datetime.fromisoformat(physical_record['completedUtc'].replace('Z','+00:00')).timestamp():
    raise SystemExit('routed netlist predates the selected successful physical run')

gate_db = manual / 'AC201_tf_hdmi_gate.db'
if not gate_db.is_file() or hashlib.sha256(gate_db.read_bytes()).hexdigest() != record.get('gateDbHash'):
    raise SystemExit('current gate database is missing or differs from the successful synthesis record')
routed_text = routed.read_text(encoding='utf-8', errors='replace')
blocks = mod.extract_blocks(routed_text)
expected_banks = {'hann_low','hann_high','twiddle_low','twiddle_high'}
if set(blocks) != expected_banks:
    raise SystemExit(f'expected four coefficient BRAMs; found {sorted(blocks)}')
manifest_path = candidate / 'src/user_source/hdl_source/spectrum_coeff_rom_manifest.json'
manifest = json.loads(manifest_path.read_text(encoding='utf-8'))
hann_path = candidate / 'src/user_source/hdl_source/spectrum_hann.mem'
twiddle_path = candidate / 'src/user_source/hdl_source/spectrum_twiddle.mem'
hann, twiddle = mod.read_words(hann_path), mod.read_words(twiddle_path)
if len(hann) != 1024 or len(twiddle) != 512:
    raise SystemExit('source ROM dimensions are not 1024 Hann and 512 twiddle words')
source_hashes = {k: hashlib.sha256(p.read_bytes()).hexdigest() for k,p in [('hann',hann_path),('twiddle',twiddle_path)]}
if source_hashes != manifest['source_sha256']:
    raise SystemExit(f'source ROM hashes differ from coefficient manifest: {source_hashes}')
lanes = {
 'hann_low': (hann,1024,9,lambda w:w & 0x1ff),
 'hann_high':(hann,1024,9,lambda w:(w>>9)&0x7f),
 'twiddle_low':(twiddle,512,18,lambda w:w & 0x3ffff),
 'twiddle_high':(twiddle,512,18,lambda w:(w>>18)&0x3fff),
}
reconstructed={}; lane_result={}
for name,(source,depth,width,select) in lanes.items():
    actual=mod.decode(blocks[name],depth,width)
    if len(actual)!=depth: raise SystemExit(f'{name} decoded unexpected depth {len(actual)}')
    mismatches=[i for i,(a,e) in enumerate(zip(actual,(select(w) for w in source))) if a!=e]
    reconstructed[name]=actual
    lane_result[name]={'depth':depth,'width':width,'nonzero_words':sum(bool(v) for v in actual),'mismatches':len(mismatches),'first_mismatch_addresses':mismatches[:8],'sha256':hashlib.sha256(b''.join(v.to_bytes(4,'big') for v in actual)).hexdigest()}
combined={
 'hann':[reconstructed['hann_low'][i] | reconstructed['hann_high'][i]<<9 for i in range(1024)],
 'twiddle':[reconstructed['twiddle_low'][i] | reconstructed['twiddle_high'][i]<<18 for i in range(512)],
}
combined_result={}
for name,actual,expected in [('hann',combined['hann'],hann),('twiddle',combined['twiddle'],twiddle)]:
    mismatches=sum(a!=e for a,e in zip(actual,expected))
    combined_result[name]={'words':len(actual),'nonzero_words':sum(bool(v) for v in actual),'mismatches':mismatches,'sha256':hashlib.sha256(b''.join(v.to_bytes(4,'big') for v in actual)).hexdigest()}
lane_entries=sum(depth for _,depth,_,_ in lanes.values())
if lane_entries != 3072 or sum(x['words'] for x in combined_result.values()) != 1536:
    raise SystemExit(f'unexpected ROM dimensions: lanes={lane_entries}, logical={sum(x["words"] for x in combined_result.values())}')
result={
 'schema':'c11314-current-success-routed-rom-init-audit-v1','status':'PASS' if all(x['mismatches']==0 for x in lane_result.values()) and all(x['mismatches']==0 for x in combined_result.values()) else 'FAIL',
 'synthesis_run_id':args.run_id,'physical_run_id':args.physical_run_id,'physical_marker':str(physical_marker_path.resolve()),'physical_marker_sha256':hashlib.sha256(physical_marker_path.read_bytes()).hexdigest(),'physical_record':str(physical_record_path.resolve()),'physical_record_sha256':hashlib.sha256(physical_record_path.read_bytes()).hexdigest(),'route_database_sha256':hashlib.sha256(route_db.read_bytes()).hexdigest(),'synthesis_marker':str(marker_path.resolve()),'synthesis_marker_sha256':hashlib.sha256(marker_path.read_bytes()).hexdigest(),
 'synthesis_record':str(record_path.resolve()),'synthesis_record_sha256':hashlib.sha256(record_path.read_bytes()).hexdigest(),
 'synthesis_log':str(log_path.resolve()),'synthesis_log_sha256':hashlib.sha256(log_path.read_bytes()).hexdigest(),
 'routed_netlist':str(routed.resolve()),'routed_netlist_sha256':hashlib.sha256(routed.read_bytes()).hexdigest(),
 'manifest_sha256':hashlib.sha256(manifest_path.read_bytes()).hexdigest(),'source_rom_sha256':source_hashes,
 'checker_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'decoder_sha256':hashlib.sha256(module_path.read_bytes()).hexdigest(),
 'source_rom_paths':{'hann':str(hann_path.resolve()),'twiddle':str(twiddle_path.resolve())},
 'logical_rom_words':1536,'lane_entries':lane_entries,'lanes':lane_result,'combined_roms':combined_result,'all_match':all(x['mismatches']==0 for x in lane_result.values()) and all(x['mismatches']==0 for x in combined_result.values()),
 'method':'Reused the reference INIT/INITP extraction and decode functions. Bound to the selected successful C11314 synthesis and physical marker/record, verified synthesis linkage, physical completion freshness, current gate database and synthesis log; checked every routed bank-lane entry against current source ROM images and manifest hashes.'}
args.output.parent.mkdir(parents=True,exist_ok=True)
args.output.write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print(json.dumps({'status':result['status'],'run_id':args.run_id,'routed_netlist_sha256':result['routed_netlist_sha256'],'logical_rom_words':result['logical_rom_words'],'lane_entries':result['lane_entries'],'mismatches':{**{k:v['mismatches'] for k,v in lane_result.items()},**{k:v['mismatches'] for k,v in combined_result.items()}}},ensure_ascii=False))
raise SystemExit(0 if result['status']=='PASS' else 1)
