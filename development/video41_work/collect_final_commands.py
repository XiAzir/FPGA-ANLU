"""Bind the final synthesized and routed command checks used for C41 delivery."""
import csv
import hashlib
import json
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[2]
WORK=Path(__file__).resolve().parent
PROJECT=ROOT/'development/player_video41_refresh'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
gate_hash=sha(PROJECT/'build/manual/AC201_tf_hdmi_gate.v')
routed_hash=sha(PROJECT/'verification/final_routed.v')
records=[]
selected={}
for run in sorted((WORK/'gate_refresh').glob('run_C41_*')):
    if not (run/'result.json').is_file(): continue
    b=json.loads((run/'source_binding.json').read_text(encoding='utf-8-sig'))
    r=json.loads((run/'result.json').read_text(encoding='utf-8-sig'))
    source=b['original_gate_sha256']
    if source not in (gate_hash,routed_hash) or b.get('simulation_ack_stage0_edge_override',0): continue
    if not r['complete'] or r['exit_code']!=0: continue
    if source==gate_hash and b['traffic']==1 and b.get('burst_words',4)==4: selected['synthesized_short_burst']=run
    if source==routed_hash and b['traffic']==1 and b.get('burst_words',4)==256: selected['routed_long_burst']=run
    if source==routed_hash and b['traffic']==0: selected['routed_idle']=run
assert set(selected)=={'synthesized_short_burst','routed_long_burst','routed_idle'},selected
for tag,run in selected.items():
    binding=run/'source_binding.json'
    log_path=run/'run.log'
    log=log_path.read_text(encoding='utf-8-sig')
    assert 'Fatal:' not in log and '** Error:' not in log
    summary=re.search(r'GATE_REFRESH_SUMMARY[^\r\n]*',log)[0]
    metrics={k:int(v) for k,v in re.findall(r'(\w+)=(\d+)',summary)}
    rows=list(csv.DictReader((run/'command_trace.csv').open()))
    commands=[int(row['cycle']) for row in rows if row['cmd']=='001']
    requests=[int(row['cycle']) for row in rows if row['req']=='1']
    gaps=[b-a for a,b in zip(commands,commands[1:])]
    assert len(commands)==metrics['aref_commands']==metrics['req_rises']
    assert len(requests)==len(commands)
    assert min(gaps)>=4
    delays=[b-a for a,b in zip(requests,commands)]
    assert min(delays)>=0
    if tag=='routed_idle': assert set(gaps)=={781}
    records.append({'name':tag,'status':'PASS',
      'binding_path':binding.relative_to(ROOT).as_posix(),'binding_sha256':sha(binding),
      'log_path':log_path.relative_to(ROOT).as_posix(),'log_sha256':sha(log_path),
      'trace_sha256':sha(run/'command_trace.csv'),'summary':summary,
      'AREF_gaps_mem_clocks':gaps,'request_to_AREF_mem_clocks':delays,
      'maximum_observed_request_service_delay_ns':max(delays)*20,
      'source_kind':'routed' if tag.startswith('routed') else 'synthesized',
      'source_sha256':routed_hash if tag.startswith('routed') else gate_hash})
record={'status':'PASS','final_gate_sha256':gate_hash,'final_routed_sha256':routed_hash,
  'checks':records,'scope':'Full original mapped netlists with only top rename; actual command pins, forced app inputs/clocks/reset and accelerated startup; inert device command observer; no SDF, storage contents or board capture.',
  'source_logic_ack_override':False,'routed_reset_fanout_aliases':'Explicit per-run list bound in source_binding; all use the same test reset.'}
(WORK/'final_gate_commands.json').write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(record,ensure_ascii=False,indent=2))
