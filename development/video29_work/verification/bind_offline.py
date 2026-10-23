"""Bind exact C29 passive-source checks and observer tests to their inputs."""
from pathlib import Path
import hashlib
import json

root=Path(__file__).resolve().parents[3]
work=root/'development/video29_work'
cand=root/'development/player_video29_media_flow'
base=root/'development/player_video27_command_boundary'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))

delta=read(work/'verification/passive_delta.json')
assert delta['status']=='PASS'
for entry in delta['inputs']:
    assert sha(base/'src/user_source'/entry['path'])==entry['baseline_sha256']
    assert sha(cand/'src/user_source'/entry['path'])==entry['candidate_sha256']
parent=read(base/'verification/final_binding.json')
assert sha(root/'download/video27_command_boundary.bit')==parent['bit_sha256']
for entry in parent['offline_tests']['inputs']:
    assert sha(base/'src/user_source'/entry['path'])==entry['candidate_sha256']

packet=work/'packet_monitor'
mem=work/'memory_monitor'
assert sha(cand/'src/user_source/hdl_source/hdmi_packet_monitor.v')==sha(packet/'hdmi_packet_monitor.v')
assert sha(cand/'src/user_source/hdl_source/player_memory_runtime_probe.v')==sha(mem/'player_memory_runtime_probe.v')
packet_log=(packet/'results/simulation.log').read_text(encoding='utf-8-sig')
assert 'PACKET_MONITOR_PASS cases=8 window=80' in packet_log
mem_log=(mem/'iverilog_pass.log').read_text(encoding='utf-8-sig')
assert 'PASS sessions and negative control page5=5c400004 page6_tail=a47' in mem_log
assert 'PASS asynchronous reset page5=50000000 page6_tail=000' in mem_log
assert 'FATAL' not in packet_log+mem_log
evidence=[p for directory in (packet,mem,work/'verification',work/'integration_review')
          for p in directory.rglob('*') if p.is_file() and p.suffix not in ('.vvp','.pyc')
          and p.name!='offline_tests.json']
result={
 'status':'PASS','build_id':'00C11329',
 'purpose':'Passive frame-memory/pixel flow and HDMI post-core audio packet diagnostics',
 'production_delta':{k:delta[k] for k in ('changed','added','removed','byte_identical_count')},
 'parent_c27_preserved':True,
 'parent_final_binding_sha256':sha(base/'verification/final_binding.json'),
 'parent_bit_sha256':parent['bit_sha256'],
 'source_inputs':delta['inputs']+[
    {'path':'hdl_source/player_memory_runtime_probe.v',
     'candidate_sha256':sha(cand/'src/user_source/hdl_source/player_memory_runtime_probe.v')}],
 'tests':{
  'control_ablation':'C27/C29 explicit observer stripping: identical media/control tokens; control mutation negative check detected',
  'packet_unit':'8 independent TMDS encoder cases: +/-1e6, consecutive packets, valid-BCH wrong tone, BCH/TERC flips, ACR, empty/rollover windows',
  'memory_unit':'phase-offset clocks, session equal/mismatch/count flags, per-session writes, zero/nonzero data, gate leakage negative control, live FSM, reset',
  'integration':'read-only clock/width/fanout review of exact candidate tap connections',
  'inherited_system':'C27 completed cold-start and four switches/two restarts; source control preserved by declared ablation scope'},
 'evidence':[{'path':p.relative_to(root).as_posix(),'sha256':sha(p)} for p in sorted(evidence)],
 'outstanding':['C29 whole-system/SDF simulation not performed',
  'C29 physical implementation and board tests are separate validation stages',
  'C28 black content and audio noise root causes remain unresolved',
  'Post-core parallel TMDS monitoring precedes PHY, cable and display receiver',
  'Live multi-bit diagnostic states may briefly show mixed transitions']
}
(cand/'verification/offline_tests.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print('OFFLINE_BINDING_PASS')
