"""Seal C29 only after the four certified stages and exact offline inputs agree."""
import datetime
import hashlib
import json
import re
import shutil
import zipfile
from pathlib import Path

ROOT=Path(__file__).resolve().parents[3]
CAND=ROOT/'development/player_video29_media_flow'
WORK=ROOT/'development/video29_work'
VERIFY=CAND/'verification'
MANUAL=CAND/'build/manual'
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def read(path):return json.loads(path.read_text(encoding='utf-8-sig'))
def write(path,value):path.write_text(json.dumps(value,ensure_ascii=False,indent=2),encoding='utf-8')

stages=read(VERIFY/'final_stage_binding.json')
offline=read(VERIFY/'offline_tests.json')
assert stages['status']==offline['status']=='PASS'
for entry in offline['source_inputs']:
    assert sha(CAND/'src/user_source'/entry['path'])==entry['candidate_sha256']
for entry in offline['evidence']:
    assert sha(ROOT/entry['path'])==entry['sha256'],entry['path']
bit=MANUAL/'AC201_player_video29_media_flow.bit'
assert sha(bit)==stages['bit_sha256']
m=re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns',
            (MANUAL/'AC201_tf_hdmi_phy.ts').read_text(encoding='utf-8'))
assert m
slack=[float(v) for v in m.groups()]
assert min(slack)>=0
timing=dict(zip(('setup_wns','setup_tns','hold_wns','hold_tns'),slack))
netlist=(VERIFY/'final_routed.v').read_text(encoding='utf-8')
counts={name:len(re.findall(r'^\s*'+name+r'\s*#\(',netlist,re.M))
        for name in ('EG_PHY_MSLICE','EG_PHY_LSLICE')}
assert min(counts.values())>0
slices=sum(counts.values())
assert slices<=9800
area_text=(MANUAL/'AC201_tf_hdmi_phy.area').read_text(encoding='utf-8')
area={key:int(re.search(r'^#'+key+r'\s+(\d+)',area_text,re.M).group(1))
      for key in ('lut','reg','le','bram','dsp','pll','gclk')}
assert area['bram']==62 and area['dsp']==26
export=read(VERIFY/'routed_export_binding.json')
assert sha(MANUAL/'AC201_tf_hdmi_pr.db')==export['database_sha256']
assert sha(VERIFY/'final_routed.v')==export['final_routed_sha256']
assert sha(MANUAL/'AC201_tf_hdmi_pr.db')==stages['stages']['hold']['artifacts']['AC201_tf_hdmi_pr.db']
binding={
 'status':'PASSIVE_DIAGNOSTIC_OFFLINE_PASS_BOARD_PENDING','build_id':'00C11329',
 'created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'base':'C11327 media control; C11328 diagnostic branch',
 'purpose':'Frame-memory/pixel flow and HDMI post-core audio packet observation',
 'bit_sha256':sha(bit),'timing_ns':timing,'slice_used':slices,
 'slice_percent':100*slices/9800,'routed_slices':counts,'physical_resources':area,
 'offline_tests_sha256':sha(VERIFY/'offline_tests.json'),
 'final_stage_binding_sha256':sha(VERIFY/'final_stage_binding.json'),
 'final_routed_sha256':sha(VERIFY/'final_routed.v'),
 'routed_export_binding_sha256':sha(VERIFY/'routed_export_binding.json'),
 'production_delta':offline['production_delta'],'parent_c27_preserved':True,
 'observations':{'3':'ACR N20/BCH8 saturated','5':'completed read-session flags8/return words19/0',
  '6':'existing memory status16/reader state4/pixel flags8',
  'E':'packet flags4/valid stereo sample pairs16 per sec/bad TERC8 saturated',
  'F':'ACR CTS20/tone bad sample pairs8 saturated'},
 'outstanding':offline['outstanding'],'board_result':'PENDING',
 'board_supply_to_keep':'external5V USB adapter, USB-A to USB-C'
}
write(VERIFY/'final_binding.json',binding)
download=ROOT/'download/video29_media_flow.bit'
shutil.copy2(bit,download)
assert sha(download)==sha(bit)
write(download.with_suffix('.info.json'),binding)
package=ROOT/'deliverables/video29_media_flow_c11329_20261023'
package.mkdir(exist_ok=False)
payload={
 'video29_media_flow.bit':download,'上板说明.md':WORK/'板测说明.md',
 'decode_pages.py':WORK/'decode_pages.py',
 'final_binding.json':VERIFY/'final_binding.json','offline_tests.json':VERIFY/'offline_tests.json',
 'final_stage_binding.json':VERIFY/'final_stage_binding.json',
 'final_timing_status.txt':MANUAL/'AC201_tf_hdmi_phy.ts','final_area.txt':MANUAL/'AC201_tf_hdmi_phy.area',
 'control_ablation.json':WORK/'verification/passive_delta.json',
 'memory_probe_unit.log':WORK/'memory_monitor/iverilog_pass.log',
 'packet_monitor_unit.log':WORK/'packet_monitor/results/simulation.log',
}
manifest=[]
for name,source in payload.items():
    target=package/name
    shutil.copy2(source,target)
    assert sha(source)==sha(target)
    manifest.append({'path':name,'bytes':target.stat().st_size,'sha256':sha(target)})
write(package/'MANIFEST.json',{'build_id':'00C11329','files':manifest})
zip_path=package.with_suffix('.zip')
assert not zip_path.exists()
with zipfile.ZipFile(zip_path,'w',compression=zipfile.ZIP_DEFLATED) as z:
    for path in sorted(package.iterdir()):z.write(path,path.name)
with zipfile.ZipFile(zip_path) as z:
    assert z.testzip() is None
    assert len(z.infolist())==len(manifest)+1
    for entry in manifest:assert hashlib.sha256(z.read(entry['path'])).hexdigest()==entry['sha256']
receipt={'status':'PASS','build_id':'00C11329','package':zip_path.relative_to(ROOT).as_posix(),
 'package_bytes':zip_path.stat().st_size,'package_sha256':sha(zip_path),
 'payload_count':len(manifest),'bit_sha256':sha(bit),'timing_ns':timing,
 'slice_used':slices,'slice_percent':binding['slice_percent'],
 'binding_sha256':sha(VERIFY/'final_binding.json'),'files':manifest}
write(VERIFY/'delivery_receipt.json',receipt)
print(json.dumps({k:receipt[k] for k in ('status','package','package_sha256','bit_sha256',
                                     'timing_ns','slice_used','slice_percent')},indent=2))
