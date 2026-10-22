from pathlib import Path
import json,re,hashlib,shutil,zipfile,datetime
ROOT=Path(__file__).resolve().parents[2]
player=ROOT/'development/player_video23_mode_switch'
work=ROOT/'development/video23_work'
package=ROOT/'deliverables/video23_mode_switch_c11323_20261022'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))
save=lambda p,o:p.write_text(json.dumps(o,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
assert read(player/'verification/final_stage_binding.json')['status']=='PASS'
sims=[]
for dirname,kind in [('video_system_20261022_133206','cold_video'),('video_system_20261022_134045','mode_roundtrip')]:
 directory=player/'build'/dirname
 result=read(directory/'summary.json');assert result['status']=='PASS'
 receipt=read(directory/'source_receipt.json')
 compat={c['path']:c['copy_sha256'].lower() for c in receipt['compatibility']}
 checks=[]
 for row in receipt['inputs']:
  source=Path(row['source']);copy=Path(row['copy']);original_sha=row['sha256'].lower()
  assert sha(source)==original_sha,source
  assert sha(copy)==compat.get(str(copy),original_sha),copy
  checks.append({'source':str(source),'sha256':original_sha,'compiled_copy_sha256':sha(copy)})
 for name in ['player_media_restart.v','player_mode_quiesce.v','top_tf_hdmi_audio.v','SD/sd_card_top.v','SD/sd_card_sec_read_write.v']:
  assert str(player/'src/user_source/hdl_source'/name) in [x['source'] for x in checks],name
 log=(directory/'console.log').read_text(encoding='utf-8-sig',errors='replace')
 assert 'VIDEO_SYSTEM_PASS' in log
 if kind=='mode_roundtrip':
  assert len(re.findall(r'MODE_PASS transition=',log))==4
  assert 'CMD0=1' in log and 'CRC=' in log
 sims.append({'kind':kind,'directory':str(directory),'result':result,'input_checks':checks,'log_sha256':sha(directory/'console.log')})
unitfiles=['mode_analysis/c23_mode_restart.log','mode_analysis/sd_quiesce_c23_actual.log','audio_analysis/simulation.log']
for f,marker in zip(unitfiles,['PASS C23 restart control','PASS negative control: injected one payload bit','ACR_TEST_PASS']):
 assert marker in (work/f).read_text(encoding='utf-8-sig'),f
net=player/'verification/final_routed.v'
t=net.read_text(encoding='utf-8-sig')
slices={kind:len(re.findall(r'^\s*'+kind+r'\s*#',t,re.M)) for kind in ['EG_PHY_MSLICE','EG_PHY_LSLICE']}
used=sum(slices.values());assert 0<used<=9800
rpt=(player/'build/manual/AC201_tf_hdmi_phy.ts').read_text()
m=re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.',rpt)
assert m and all(float(s)>=0 for s in m.groups())
area_text=(player/'build/manual/AC201_tf_hdmi_phy.area').read_text()
area={name:int(re.search(r'^#'+name+r'\s+(\d+)',area_text,re.M)[1]) for name in ['lut','reg','bram','dsp','pll','gclk']}
oldbits={
 'video19.bit':'2cc753d6cc2d241cc06e8ecb1e7b5bc86bc08eb99a6f074cba5ca5bf0791e430',
 'video20.bit':'2c97c1152d69a1a7a9b7681d543f3834c2a4fdd4a0f15ec0982bc90579310e6d',
 'video21_diag.bit':'9834b3070ffe42958d8f527a6a64d1c9a328112b87bacb1c385253078c89dc9a',
 'video22_audio_diag.bit':'489e1d92558404d67d10467b4a78979a017ea4e1816527446706419c5c43f87e'}
for n,v in oldbits.items(): assert sha(ROOT/'download'/n)==v,n
parent=read(player/'verification/parent_c22_inputs.json')
for row in parent:assert sha(ROOT/'development/player_video22_audio_diag/src'/row['path'])==row['sha256']
binding=read(player/'verification/final_stage_binding.json')
bit=player/'build/manual/AC201_player_video23_mode_switch.bit';assert sha(bit)==binding['bit_sha256']
validation={'status':'OFFLINE_VERIFIED_BOARD_PENDING','build_id':'00C11323','created_local':datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).isoformat(),'bit_sha256':sha(bit),'timing_ns':dict(zip(['setup_wns','setup_tns','hold_wns','hold_tns'],map(float,m.groups()))),'physical':area,'routed_slice_primitives':slices,'slice_used':used,'slice_total':9800,'slice_percent':used/98,'diagnostic_resource_note':'Contains retained C22 audio diagnostics; C20 production 88.13% optimization baseline retained.','source_delta':read(player/'verification/source_delta.json'),'system_tests':sims,'unit_evidence':[{'path':f,'sha256':sha(work/f)} for f in unitfiles],'stage_binding_sha256':sha(player/'verification/final_stage_binding.json'),'old_bits_preserved':oldbits,'board_pending':['Repeated real TF-card photo/video switching','Physical SD SPI/SDRAM/HDMI and reset release behavior','Continuous audio noise: original PCM CRC matched two blocks; HDMI source/sink boundary still under investigation'],'test_scope':['Nominal PLL replay and application-interface SDRAM model; no SDF','Mode test uses 16x16 BMP expanded by production scaler to640x480; video and WAV are unchanged delivered media','Cold video test uses original640x480 BMP directory fixture and Q90 video with original PCM','No full20second simulation or real-board claim']}
# Save the complete identity checks in engineering evidence; keep user metadata compact.
save(player/'verification/final_binding.json',validation)
compact={k:v for k,v in validation.items() if k not in ['source_delta','system_tests']}
compact['system_tests']=[{'kind':x['kind'],'directory':x['directory'],'status':x['result']['status'],'input_checks':len(x['input_checks'])} for x in sims]
shutil.copy2(bit,ROOT/'download/video23_mode_switch.bit')
shutil.copy2(bit,package/'video23_mode_switch.bit')
for n in ['canonical_crc_period_1875.csv','crc_period_metadata.json']:
 shutil.copy2(ROOT/'deliverables/video22_audio_diag_c11322_20261022'/n,package/n)
manual=package/'操作说明.txt'
manual.write_text(manual.read_text(encoding='utf-8-sig').replace('待离线验证完成后随bit正式交付','离线验证通过，待实板复测'),encoding='utf-8')
save(package/'validation.json',compact)
info={'build_id':'00C11323','sha256':sha(bit),'bit':str(ROOT/'download/video23_mode_switch.bit'),'scope':'Sector-boundary media restart with persistent SD/card catalog; C22 diagnostics retained','audio_noise_status':'Unresolved; no audio algorithm modification','validation':str(package/'validation.json')}
save(package/'video23_mode_switch.info.json',info);save(ROOT/'download/video23_mode_switch.info.json',info)
manifest=[{'name':p.name,'bytes':p.stat().st_size,'sha256':sha(p)} for p in sorted(package.iterdir()) if p.is_file() and p.name!='receipt.json']
save(package/'receipt.json',{'build_id':'00C11323','files':manifest})
archive=package.with_suffix('.zip')
with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED) as z:
 for p in sorted(package.iterdir()):
  if p.is_file():z.write(p,p.name)
with zipfile.ZipFile(archive) as z:
 assert z.testzip() is None
 for row in manifest:assert hashlib.sha256(z.read(row['name'])).hexdigest()==row['sha256']
assert len({sha(bit),sha(ROOT/'download/video23_mode_switch.bit'),sha(package/'video23_mode_switch.bit')})==1
save(player/'verification/delivery_receipt.json',{'status':'PASS','bit_sha256':sha(bit),'zip':str(archive),'zip_sha256':sha(archive),'bytes':archive.stat().st_size,'payload_files':len(manifest)+1,'slice':used,'slice_percent':used/98,'timing':validation['timing_ns']})
print(json.dumps(read(player/'verification/delivery_receipt.json'),ensure_ascii=False,indent=2))
