"""Bind C30 observer ablation and completed media regression to frozen inputs."""
from pathlib import Path
import hashlib
import json
import re

ROOT=Path(__file__).resolve().parents[3]
WORK=ROOT/'development/video30_work'
CAND=ROOT/'development/player_video30_probe_prune'
BASE=ROOT/'development/player_video29_media_flow'
UNIT=WORK/'verification/unit_ablation'

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))

audit=read(UNIT/'source_ablation_summary.json')
assert audit['status']=='PASS'
manifest=read(UNIT/'source_hash_manifest.json')
for kind,directory in [('baseline',BASE),('candidate',CAND)]:
    for item in manifest['all_files'][kind]:
        assert sha(directory/'src/user_source/hdl_source'/item['path'])==item['sha256']
unit_log=(UNIT/'vvp_run.log').read_text(encoding='utf-8-sig')
assert 'cycles=260, negative-control mismatches=259' in unit_log
audit_log=(UNIT/'source_audit_run.log').read_text(encoding='utf-8-sig')
assert 'PASS' in audit_log

baseline={p.relative_to(BASE/'src/user_source').as_posix():p
          for p in (BASE/'src/user_source').rglob('*') if p.is_file()}
candidate={p.relative_to(CAND/'src/user_source').as_posix():p
           for p in (CAND/'src/user_source').rglob('*') if p.is_file()}
source_inputs=[]
for name,p in sorted(candidate.items()):
    item={'path':name,'candidate_sha256':sha(p)}
    if name in baseline:item.update(baseline_sha256=sha(baseline[name]),byte_identical=sha(p)==sha(baseline[name]))
    source_inputs.append(item)
for name,p in baseline.items():
    if not name.startswith('hdl_source/'):
        assert name in candidate and sha(p)==sha(candidate[name])

systems=sorted((WORK/'system_regression/build').glob('player_video30_probe_prune_system_*/summary.json'))
assert systems,'No completed C30 system regression'
system_path=systems[-1]
system=read(system_path)
assert system['status']=='PASS',system['status']
run=system_path.parent
log=(run/'console.log').read_text(encoding='utf-8-sig')
assert 'VIDEO_SYSTEM_PASS' in log
assert 'Fatal' not in log and '** Error' not in log
sessions=re.findall(r'RESTART_SESSION_PASS transition=(\d+) video=(\d+)',log)
assert sessions==[(str(i),str(v)) for i,v in enumerate([0,1,1,1,0,1,0])],sessions
frames=re.findall(r'VIDEO_RGB_FRAME session=(\d+) frame=(\d+) pixels=(\d+) crc32=([0-9a-f]+)',log)
assert len(frames)==4 and all(int(f[2])==307200 for f in frames),frames
assert len(re.findall('VIDEO_JPEG_FRAME',log))>=4
receipt=read(run/'source_receipt.json')
for entry in receipt['inputs']:
    p=Path(entry['source'])
    if p.is_relative_to(CAND):assert sha(p)==entry['sha256'].lower(),str(p)
    else:assert sha(Path(entry['copy']))==entry['sha256'].lower(),entry['copy']
for entry in receipt['compatibility']:
    assert sha(Path(entry['path']))==entry['copy_sha256'].lower()
assets=read(run/'fixture_receipt.json')
for item in assets['assets']:assert sha(run/item['path'])==item['sha256'].lower()
assert sha(run/'tb_video_system.v')==assets['testbench_sha256'].lower()
coverage=read(run/'coverage_report.json')
assert coverage['status']=='PASS'
scope=coverage['simulation_scope']
assert scope['events']['transitions']==6
assert scope['pcm']['samplewise_gold_checks']==10875 and not scope['pcm']['underflow_seen']
assert scope['rgb']['complete_frames']==4 and scope['rgb']['pixels_per_frame']==307200
assert scope['external_spi_model']['protocol_errors']==0

parent=read(BASE/'verification/final_binding.json')
assert sha(ROOT/'download/video29_media_flow.bit')==parent['bit_sha256']
evidence=[p for p in (WORK/'verification').rglob('*') if p.is_file() and p.suffix not in ('.vvp','.pyc')]
evidence += [run/n for n in ('summary.json','coverage_report.json','source_receipt.json','fixture_receipt.json','console.log','compile.log','tb_video_system.v')]
result={
 'status':'PASS','build_id':'00C11330','purpose':'Remove pure runtime diagnostic observers while preserving playback',
 'baseline_build':'00C11329','baseline_bit_sha256':parent['bit_sha256'],
 'production_delta':{k:audit[k] for k in ('added_files','deleted_files','changed_files')},
 'all_user_source_counts':{'baseline':len(baseline),'candidate':len(candidate)},
 'source_inputs':source_inputs,
 'control_ablation':'Exact observer stripping, retained core hashes/instances, SD command/R1 and memory-token equivalence; audio reset/toggle predicates checked; control-selector mutation negative detected',
 'source_gate_unit':'260 matched cycles; 259 mismatches under inverted-valid negative control',
 'system_regression':{'path':run.relative_to(ROOT).as_posix(),'status':system['status'],
    'sessions':sessions,'complete_video_frames':frames,
    'assumptions':system['assumptions'],'simulation':system['simulation'],
    'coverage':scope},
 'evidence':[{'path':p.relative_to(ROOT).as_posix(),'sha256':sha(p)} for p in sorted(set(evidence))],
 'ui_changes':{'digits':'fixed00C11330','LED_active_low':['D3 video','D2 tone','D1 display_valid','D0 mounted']},
 'outstanding':['C30 board validation pending','Nominal PLL/application SDRAM simulation, no SDF',
   'Media events injected at classifier outputs; physical buttons and HDMI receiver checked on board',
   'C29 remains the board-tested rollback; removal changes physical placement']
}
(CAND/'verification/offline_tests.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print('C30_OFFLINE_BINDING_PASS')
