"""Seal C32 with exact protocol, pixel-integration and certified build evidence."""
from pathlib import Path
import datetime
import hashlib
import json
import re
import shutil
import zipfile

ROOT=Path(__file__).resolve().parents[2]
WORK=Path(__file__).resolve().parent
CAND=ROOT/'development/player_video32_read_return'
BASE=ROOT/'development/player_video31_audio_ablation'
VERIFY=CAND/'verification'
BUILD=CAND/'build/manual'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p): return json.loads(p.read_text(encoding='utf-8-sig'))
def write(p,obj): p.write_text(json.dumps(obj,ensure_ascii=False,indent=2),encoding='utf-8')

prep=read(VERIFY/'preparation.json')
for name,digest in prep['source_inputs'].items():
    assert sha(CAND/'src/user_source'/name)==digest,name
for name,digest in prep['baseline_source_inputs'].items():
    assert sha(BASE/'src/user_source'/name)==digest,name
protocol=read(WORK/'pressure_test/source_binding.json')
assert protocol['status']=='PASS'
assert sha(CAND/'src/user_source/hdl_source/SD/frame_fifo_read.v')==protocol['source_sha256']
assert sha(WORK/'pressure_test/frame_fifo_read_c32_candidate.v')==protocol['copy_sha256']
log=(WORK/'return_drain_test.log').read_text(encoding='utf-8-sig')
for expected in ('baseline_early=1 candidate_early=0 baseline_reset_pending=1 candidate_reset_pending=0',
                 'first JPEG BL4 write overlapped pending returns baseline=213, candidate=0',
                 'first FIFO clear snapshots baseline pending=207, candidate pending=0'):
    assert expected in log,expected
assert 'FATAL' not in log
integration=read(WORK/'frame_integration/summary.json')
assert integration['status']=='PASS' and len(integration['cases'])==4
for item in integration['inputs']: assert sha(ROOT/item['path'])==item['sha256']
for case in integration['cases']:
    assert case['status']=='PASS'
    assert 'PASS tb_compact_frame_buffer' in (WORK/'frame_integration'/case['log']).read_text(encoding='utf-8-sig')
stages=read(VERIFY/'final_stage_binding.json')
assert stages['status']=='PASS'
for item in stages['inputs']: assert sha(CAND/item['path'])==item['sha256']
assert sha(BUILD/'AC201_tf_hdmi_pr.db')==stages['stages']['hold']['artifacts']['AC201_tf_hdmi_pr.db']
bit=BUILD/'AC201_player_video32_read_return.bit'
assert sha(bit)==stages['bit_sha256']
text=(BUILD/'AC201_tf_hdmi_phy.ts').read_text(encoding='utf-8-sig')
m=re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns',text)
assert m and min(map(float,m.groups()))>=0
timing=dict(zip(('setup_wns','setup_tns','hold_wns','hold_tns'),map(float,m.groups())))
net=(VERIFY/'final_routed.v').read_text(encoding='utf-8-sig')
slices=sum(len(re.findall(r'^\s*'+name+r'\s*#\(',net,re.M)) for name in ('EG_PHY_MSLICE','EG_PHY_LSLICE'))
assert 0<slices<=9800 and 'returned_words' in net
assert 'frame_fifo_read_m0/rd_delay' not in net
area_text=(BUILD/'AC201_tf_hdmi_phy.area').read_text(encoding='utf-8-sig')
area={key:int(re.search(r'^#'+key+r'\s+(\d+)',area_text,re.M).group(1)) for key in ('lut','reg','le','bram','dsp','pll','gclk')}
assert area['bram']==62 and area['dsp']==26
rollback=ROOT/'download/video29_media_flow.bit'
parent=read(ROOT/'development/player_video29_media_flow/verification/final_binding.json')
assert sha(rollback)==parent['bit_sha256']
evidence=[WORK/'return_drain_test.log', WORK/'pressure_test/source_binding.json',
    WORK/'pressure_test/tb_frame_fifo_return_drain_rw.v',WORK/'pressure_test/run_return_drain_test.ps1',
    WORK/'frame_integration/summary.json',WORK/'run_frame_integration.py',
    WORK/'real_sdram_test/compile_permissive.log']
evidence += sorted((WORK/'frame_integration').glob('*_run.log'))
binding={'status':'OFFLINE_VERIFIED_BOARD_PENDING','build_id':'00C11332',
    'created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'purpose':'Hold read-burst ownership until every requested SDRAM word has actually returned',
    'board_result':'PENDING','board_artifact_root_cause':'UNDETERMINED',
    'bit_sha256':sha(bit),'slice_used':slices,'slice_percent':slices/98,
    'C31_slice_used':8681,'C29_slice_used':parent['slice_used'],
    'slice_saved_vs_C29':parent['slice_used']-slices,'timing_ns':timing,'physical_resources':area,
    'production_delta':prep['changed'],'source_inputs':prep['source_inputs'],
    'baseline_bit_sha256':sha(ROOT/'download/video31_audio_ablation.bit'),
    'rollback_bit_sha256':sha(rollback),'audio_rtl_identical_to_C31':True,
    'protocol_test':{'baseline_pending_at_first_burst_finish':112,
        'baseline_pending_at_write_start':213,'baseline_pending_at_fifo_clear':207,
        'candidate_pending_at_ownership_transfers':0,
        'scope':'Explicit application-interface service model, delayed/paused returns; actual read/write arbiter RTL'},
    'pixel_tests':integration,
    'evidence':[{'path':p.relative_to(ROOT).as_posix(),'sha256':sha(p)} for p in evidence],
    'final_stage_binding_sha256':sha(VERIFY/'final_stage_binding.json'),
    'final_routed_sha256':sha(VERIFY/'final_routed.v'),
    'routed_database_sha256':sha(BUILD/'AC201_tf_hdmi_pr.db'),
    'outstanding':['C32 board test for horizontal bands, audio and mode/restart behavior',
        'Full real SDRAM controller/device simulation blocked by ModelSim 10.1c unsized-concatenation error in protected init module',
        'No C32 full-system/SDF/pin-level simulation; nominal pixel cases use explicit app-level memory model'],
    'ui':'fixed 00C11332; C31/C29 audio observation LEDs retained'}
write(VERIFY/'final_binding.json',binding)
download=ROOT/'download/video32_read_return.bit'
assert not download.exists()
shutil.copy2(bit,download)
write(download.with_suffix('.info.json'),binding)
package=ROOT/'deliverables/video32_read_return_c11332_20261023'
package.mkdir(exist_ok=False)
payload={'video32_read_return.bit':download,'video29_media_flow_rollback.bit':rollback,
    '上板说明.md':WORK/'板测说明.md','final_binding.json':VERIFY/'final_binding.json',
    'final_stage_binding.json':VERIFY/'final_stage_binding.json',
    'return_drain_test.log':WORK/'return_drain_test.log',
    'pixel_integration_summary.json':WORK/'frame_integration/summary.json',
    'final_timing_status.txt':BUILD/'AC201_tf_hdmi_phy.ts',
    'final_area.txt':BUILD/'AC201_tf_hdmi_phy.area'}
manifest=[]
for name,path in payload.items():
    shutil.copy2(path,package/name)
    manifest.append({'path':name,'bytes':(package/name).stat().st_size,'sha256':sha(package/name)})
write(package/'MANIFEST.json',{'build_id':'00C11332','files':manifest})
zpath=package.with_suffix('.zip');assert not zpath.exists()
with zipfile.ZipFile(zpath,'w',zipfile.ZIP_DEFLATED) as z:
    for path in sorted(package.iterdir()):z.write(path,path.name)
with zipfile.ZipFile(zpath) as z:
    assert z.testzip() is None
    for item in manifest:assert hashlib.sha256(z.read(item['path'])).hexdigest()==item['sha256']
receipt={'status':'PASS','package':zpath.relative_to(ROOT).as_posix(),'package_sha256':sha(zpath),
    'package_bytes':zpath.stat().st_size,'bit_sha256':sha(bit),'slice_used':slices,
    'slice_percent':slices/98,'slice_saved_vs_C29':parent['slice_used']-slices,'timing_ns':timing}
write(VERIFY/'delivery_receipt.json',receipt)
print(json.dumps(receipt,ensure_ascii=False,indent=2))
