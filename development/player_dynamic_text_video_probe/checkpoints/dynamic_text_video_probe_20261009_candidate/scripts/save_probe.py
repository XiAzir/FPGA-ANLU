"""Preserve a hardware-pending runtime source probe; refuse stale inputs or overwrite."""
from pathlib import Path
from datetime import datetime, timezone, timedelta
import hashlib, json, re, shutil, zipfile

project=Path(__file__).resolve().parent.parent
root=project.parent.parent
manual=project/'build/manual'
bit=manual/'AC201_player_dynamic_text_video_probe.bit'
short=root/'download/dynamic_text_video_probe.bit'
checkpoint=project/'checkpoints/dynamic_text_video_probe_20261009_candidate'
package=root/'deliverables/dynamic_text_video_probe_20261009.zip'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest().upper()
load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))
def write(p,d):
    p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
assert not short.exists() and not checkpoint.exists() and not package.exists()
for stage,marker in [('synthesis','SYNTHESIS_COMPLETE_WITH_GATE_DATABASE'),('physical','PLACE_ROUTE_COMPLETE_WITH_REPORTS'),('hold','POST_ROUTE_HOLD_FIX_COMPLETE'),('bitstream','BITSTREAM_GENERATED')]:
    assert marker in (manual/(stage+'_console.log')).read_text(encoding='utf-8-sig',errors='replace')
for e in load(manual/'build_source_scope.json'):
    assert sha(project/'src'/e['path'])==e['sha256'],e['path']
prior=root/'development/player_dynamic_text_fit/src/user_source'
user=project/'src/user_source'
changed=[];added=[];same=[]
for p in sorted(user.rglob('*')):
    if not p.is_file():continue
    rel=p.relative_to(user)
    if not (prior/rel).is_file():added.append(rel.as_posix())
    elif sha(p)!=sha(prior/rel):changed.append(rel.as_posix())
    else:same.append(rel.as_posix())
assert changed==['hdl_source/player_dynamic_text.v','hdl_source/top_tf_hdmi_audio.v'],changed
assert added==['hdl_source/player_video_source_probe.v'],added
assert len(same)==73
assert {p.relative_to(prior).as_posix() for p in prior.rglob('*') if p.is_file()} <= {p.relative_to(user).as_posix() for p in user.rglob('*') if p.is_file()}
models=load(project/'build/model_results.json')
assert len(models['tests'])==3, 'No complete model evidence'
for path,expected in models['source_sha256'].items():
    assert sha(Path(path))==expected, 'Modeled source changed'
for e in models['tests']:
    p=Path(e['path'])
    text=p.read_text(encoding='utf-8-sig',errors='replace')
    assert e['marker'] in text and not re.search(r'FAIL|FATAL',text),str(p)
    assert sha(p)==e['sha256'].upper()
    assert sha(Path(e['testbench']))==e['testbench_sha256']
assert (project/'build/probe_review/report.md').is_file(), 'Missing independent review'
timing_text=(manual/'AC201_tf_hdmi_phy.ts').read_text()
m=re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.',timing_text)
assert m and all(float(x)>=0 for x in m.groups()), 'Timing must close on original constraints'
timing=dict(zip(['SWNS_ns','STNS_ns','HWNS_ns','HTNS_ns'],map(float,m.groups())))
area=(manual/'AC201_tf_hdmi_phy.area').read_text()
resources={k:int(re.search(rf'^\s*#{k}\s+(\d+)',area,re.M).group(1)) for k in ['lut','reg','le','bram9k','dsp','gclk']}
coverage=float(re.search(r'STA coverage\s*:\s*([\d.]+)%',(manual/'AC201_tf_hdmi_pr.timing').read_text()).group(1))
fallback=root/'download/osd_phy_fix.bit'
assert sha(fallback)=='9E893B0B6C86BF6FBEE19E74B5FB58933C1BEA6AA07F203786CCE96F3B60AE6F'
guards={}
for name in ['player_osd_phy_fix/checkpoints/osd_phy_fix_20261009_candidate','player_dynamic_text/checkpoints/dynamic_text_20261009_candidate','player_dynamic_text_fit/checkpoints/dynamic_text_fit_20261009_candidate']:
    frozen=root/'development'/name
    for e in load(frozen/'manifest.json'):
        p=frozen/e['path'];assert p.stat().st_size==e['bytes'] and sha(p)==e['sha256']
    guards[name]=len(load(frozen/'manifest.json'))
assert bit.stat().st_size==629624
now=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
info={'created_beijing':now,'status':'Runtime video-source isolation probe; local checks passed; hardware NOT TESTED; not a confirmed fix','hardware_result':'NOT_TESTED','root_cause':'NOT_CONFIRMED','source_changed_vs_fit':changed,'source_added':added,'source_unchanged':len(same),'bitstream':str(bit),'sha256':sha(bit),'bytes':bit.stat().st_size,'routed_db_sha256':sha(manual/'AC201_tf_hdmi_pr.db'),'timing':timing,'sta_coverage_percent':coverage,'resources':resources,'models':models,'frozen_guards':guards,'fallback_sha256':sha(fallback),'agent_card_or_flash_operations':'NONE','limitations':['Rebuild changes layout; normal BMP unexpectedly clean would not prove the old root cause.','Internal constant/BMP runtime comparison narrows the path but does not measure PHY or SDRAM electrical margins.','Existing common TLAST defect retained; external timing budgets and encrypted IP boundaries not repaired.']}
write(manual/'AC201_player_dynamic_text_video_probe.info.json',info)
prep=load(project/'build/preparation.json');prep.update(build_status='LOCAL_MODELS_AND_STA_PASS_HARDWARE_PENDING',hardware_result='NOT_TESTED',source_changed=changed,source_added=added,source_unchanged=len(same));write(project/'build/preparation.json',prep)
checkpoint.mkdir(parents=True)
for name in ['src','scripts','sim']:
    shutil.copytree(project/name,checkpoint/name)
for name in ['manual','prehold','probe_model','probe_review','initial_project_normalization']:
    if (project/'build'/name).exists():shutil.copytree(project/'build'/name,checkpoint/'build'/name)
for name in ['preparation.json','model_results.json']:
    shutil.copy2(project/'build'/name,checkpoint/'build'/name)
manifest=[{'path':p.relative_to(checkpoint).as_posix(),'bytes':p.stat().st_size,'sha256':sha(p)} for p in sorted(checkpoint.rglob('*')) if p.is_file()]
write(checkpoint/'manifest.json',manifest)
for e in manifest:
    p=checkpoint/e['path'];assert p.stat().st_size==e['bytes'] and sha(p)==e['sha256']
shutil.copy2(bit,short);assert sha(short)==sha(bit)
readme='''动态字幕底图/内部纯色诊断版，2026-10-09。实板未测；不是已确认修复。
BitWriter PROGRAM_SRAM 下载 firmware/dynamic_text_video_probe.bit，英文路径。TF素材、供电、HDMI、显示器设置均不改。
先观察正常BMP模式：右上RUN，是否仍有浅灰竖线；音乐、切图/自动仍应工作。
切纯色：先按住KEY0，再按住KEY1，两键都保持约2秒，看到RUN变REF后一起松开；松开至少1.5秒重装长按。
先按KEY0可能切一次图；双键同时按住时屏蔽手动/自动按压，双键长按切视频源，不切音源。
REF模式短按KEY0，按左上图号测试：1/4纯白，2/4中灰，3/4纯红，4/4纯绿。OSD/字幕仍显示，音乐继续。若已AUTO，短按KEY1切回MANUAL。
观察纯色是否仍有相同竖线；同样双键长按切回RUN/BMP，确认竖线是否返回。
KEY1单独长按仍切内部音阶；短按仍切AUTO。两种音源及音量、接线保持比较条件。
若新诊断版BMP本身已经干净，请如实反馈，不能把它推成旧故障原因已证。
若新版本黑屏/无声，回载 firmware/osd_phy_fix.bit 成功基线，并反馈。掉电需重下载；未写Flash。
'''
members={'firmware/dynamic_text_video_probe.bit':bit.read_bytes(),'firmware/osd_phy_fix.bit':fallback.read_bytes(),'README.txt':readme.encode('utf-8-sig'),'build_info.json':json.dumps(info,ensure_ascii=False,indent=2).encode('utf-8')}
members['checksums.json']=json.dumps({k:{'bytes':len(v),'sha256':hashlib.sha256(v).hexdigest().upper()} for k,v in members.items()},indent=2).encode('utf-8')
with zipfile.ZipFile(package,'x',compression=zipfile.ZIP_DEFLATED) as z:
    for k,v in members.items():z.writestr(k,v)
with zipfile.ZipFile(package) as z:
    assert z.testzip() is None
    for k,v in members.items():assert z.read(k)==v
audit={'created_beijing':now,'checkpoint':str(checkpoint),'frozen_files':len(manifest),'bit':str(short),'bytes':bit.stat().st_size,'sha256':sha(short),'timing':timing,'resources':resources,'coverage':coverage,'zip':str(package),'zip_bytes':package.stat().st_size,'zip_sha256':sha(package),'hardware_result':'NOT_TESTED','old_frozen_checks':'PASS','zip_crc_member_checks':'PASS'}
write(root/'deliverables/dynamic_text_video_probe_20261009.package_audit.json',audit)
print(json.dumps(audit))
