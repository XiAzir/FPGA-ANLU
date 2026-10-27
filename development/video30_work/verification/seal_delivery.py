"""Seal the C30 observer-pruned candidate after certified build/timing checks."""
from pathlib import Path
import datetime
import hashlib
import json
import re
import shutil
import zipfile

ROOT=Path(__file__).resolve().parents[3]
CAND=ROOT/'development/player_video30_probe_prune'
WORK=ROOT/'development/video30_work'
VERIFY=CAND/'verification'
BUILD=CAND/'build/manual'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def write(p,v):p.write_text(json.dumps(v,ensure_ascii=False,indent=2),encoding='utf-8')

stages=read(VERIFY/'final_stage_binding.json')
offline=read(VERIFY/'offline_tests.json')
ablation=read(WORK/'verification/resource_ablation.json')
assert stages['status']==offline['status']==ablation['status']=='PASS'
for e in offline['source_inputs']:
    assert sha(CAND/'src/user_source'/e['path'])==e['candidate_sha256']
for e in offline['evidence']:assert sha(ROOT/e['path'])==e['sha256'],e['path']
bit=BUILD/'AC201_player_video30_probe_prune.bit'
assert sha(bit)==stages['bit_sha256']
timing_text=(BUILD/'AC201_tf_hdmi_phy.ts').read_text(encoding='utf-8')
m=re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns',timing_text)
assert m
slacks=[float(x) for x in m.groups()]
assert min(slacks)>=0
timing=dict(zip(('setup_wns','setup_tns','hold_wns','hold_tns'),slacks))
netlist=(VERIFY/'final_routed.v').read_text(encoding='utf-8')
counts={n:len(re.findall(r'^\s*'+n+r'\s*#\(',netlist,re.M)) for n in ('EG_PHY_MSLICE','EG_PHY_LSLICE')}
assert min(counts.values())>0
slices=sum(counts.values())
assert slices<=9800
for dead in ('u_packet_monitor','u_memory_runtime_probe','u_pcm_crc_probe','video_mode_press_count',
             'wav_first_wait_cycles','read_crc_checked','read_crc_bad','read_crc16',
             'wav_varied_seen','tone_acr_seen','fifo_nonzero_seen'):
    assert dead not in netlist,dead
area_text=(BUILD/'AC201_tf_hdmi_phy.area').read_text(encoding='utf-8')
area={key:int(re.search(r'^#'+key+r'\s+(\d+)',area_text,re.M).group(1))
      for key in ('lut','reg','le','bram','dsp','pll','gclk')}
assert area['bram']==62 and area['dsp']==26
export=read(VERIFY/'routed_export_binding.json')
assert sha(BUILD/'AC201_tf_hdmi_pr.db')==export['database_sha256']==stages['stages']['hold']['artifacts']['AC201_tf_hdmi_pr.db']
assert sha(VERIFY/'final_routed.v')==export['final_routed_sha256']
parent=read(ROOT/'development/player_video29_media_flow/verification/final_binding.json')
rollback=ROOT/'download/video29_media_flow.bit'
assert sha(rollback)==parent['bit_sha256']
binding={
 'status':'OFFLINE_VERIFIED_BOARD_PENDING','build_id':'00C11330',
 'created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'base':'C11329 board-tested rollback','purpose':'Remove runtime diagnostic observers and their statistic fanout',
 'bit_sha256':sha(bit),'timing_ns':timing,'slice_used':slices,'slice_percent':100*slices/9800,
 'routed_slices':counts,'physical_resources':area,
 'C29_slice_used':parent['slice_used'],'slice_saved_vs_C29':parent['slice_used']-slices,
 'resource_ablation_sha256':sha(WORK/'verification/resource_ablation.json'),
 'offline_tests_sha256':sha(VERIFY/'offline_tests.json'),
 'final_stage_binding_sha256':sha(VERIFY/'final_stage_binding.json'),
 'final_routed_sha256':sha(VERIFY/'final_routed.v'),
 'routed_export_binding_sha256':sha(VERIFY/'routed_export_binding.json'),
 'production_delta':offline['production_delta'],'ui_changes':offline['ui_changes'],
 'outstanding':offline['outstanding'],'board_result':'PENDING','C29_bit_sha256':sha(rollback)
}
write(VERIFY/'final_binding.json',binding)
download=ROOT/'download/video30_probe_prune.bit'
shutil.copy2(bit,download)
assert sha(download)==sha(bit)
write(download.with_suffix('.info.json'),binding)
package=ROOT/'deliverables/video30_probe_prune_c11330_20261023'
package.mkdir(exist_ok=False)
run=ROOT/offline['system_regression']['path']
payload={
 'video30_probe_prune.bit':download,'video29_media_flow_rollback.bit':rollback,
 '上板说明.md':WORK/'板测说明.md','final_binding.json':VERIFY/'final_binding.json',
 'offline_tests.json':VERIFY/'offline_tests.json','final_stage_binding.json':VERIFY/'final_stage_binding.json',
 'final_timing_status.txt':BUILD/'AC201_tf_hdmi_phy.ts','final_area.txt':BUILD/'AC201_tf_hdmi_phy.area',
 'resource_ablation.json':WORK/'verification/resource_ablation.json',
 'source_ablation_summary.json':WORK/'verification/unit_ablation/source_ablation_summary.json',
 'system_coverage.json':run/'coverage_report.json'
}
manifest=[]
for name,source in payload.items():
    target=package/name;shutil.copy2(source,target)
    assert sha(target)==sha(source)
    manifest.append({'path':name,'bytes':target.stat().st_size,'sha256':sha(target)})
write(package/'MANIFEST.json',{'build_id':'00C11330','files':manifest})
zpath=package.with_suffix('.zip')
assert not zpath.exists()
with zipfile.ZipFile(zpath,'w',compression=zipfile.ZIP_DEFLATED) as z:
    for p in sorted(package.iterdir()):z.write(p,p.name)
with zipfile.ZipFile(zpath) as z:
    assert z.testzip() is None and len(z.infolist())==len(manifest)+1
    for e in manifest:assert hashlib.sha256(z.read(e['path'])).hexdigest()==e['sha256']
receipt={'status':'PASS','build_id':'00C11330','package':zpath.relative_to(ROOT).as_posix(),
 'package_bytes':zpath.stat().st_size,'package_sha256':sha(zpath),'payload_count':len(manifest),
 'bit_sha256':sha(bit),'slice_used':slices,'slice_percent':binding['slice_percent'],
 'slice_saved_vs_C29':binding['slice_saved_vs_C29'],'timing_ns':timing,'files':manifest}
write(VERIFY/'delivery_receipt.json',receipt)
print(json.dumps({k:receipt[k] for k in ('status','package','package_bytes','package_sha256','bit_sha256',
                                    'slice_used','slice_percent','slice_saved_vs_C29','timing_ns')},indent=2))
