from pathlib import Path
import hashlib,json,shutil
from datetime import datetime

root=Path(__file__).resolve().parents[1]
old=root/'development/player_spectrum_resource_fit'
new=root/'development/player_spectrum_resource_80'
assert not new.exists()
snap=[]
for folder in ('src','scripts','sim'):
    for p in (old/folder).rglob('*'):
        if p.is_file() and p.suffix.lower() not in ('.db','.vvp','.dmp','.pyc'):
            snap.append({'path':p.relative_to(old).as_posix(),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
    shutil.copytree(old/folder,new/folder,ignore=shutil.ignore_patterns('*.db','*.vvp','*.dmp','__pycache__','work','*_Runs'))
for folder in ('scripts','sim'):
    for p in (new/folder).rglob('*'):
        if p.is_file() and p.suffix in ('.py','.ps1','.tcl'):
            p.write_text(p.read_text(encoding='utf-8-sig').replace('player_spectrum_resource_fit','player_spectrum_resource_80'),encoding='utf-8')
p=new/'src/td_project/AC201_tf_hdmi.al'
p.write_text(p.read_text(encoding='utf-8-sig').replace('player_spectrum_resource_fit','player_spectrum_resource_80'),encoding='utf-8')
for name in ('top_tf_hdmi_audio.v','player_status_monitor.v'):
    p=new/'src/user_source/hdl_source'/name
    p.write_text(p.read_text(encoding='utf-8-sig').replace("24'hC11313","24'hC11314"),encoding='utf-8')
for name in ('gate.qor','place.qor','route.qor','final_timing.rpt','top_inst.bid'):
    p=new/'src/td_project'/name
    if p.exists():p.unlink()
out=new/'build/baseline';out.mkdir(parents=True)
(out/'C11313_source_sha256.json').write_text(json.dumps(snap,indent=2),encoding='utf-8')
for name in ('AC201_tf_hdmi_gate.area','AC201_tf_hdmi_phy.area','AC201_tf_hdmi_phy.ts','AC201_tf_hdmi_pr.timing'):
    shutil.copy2(old/'build/manual'/name,out/name)
shutil.copy2(old/'src/td_project/route.qor',out/'route.qor')
work=root/'development/resource80_work';work.mkdir()
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录/专题记录/资源优化/C11314_20261020');docs.mkdir()
feedback={'created':datetime.now().astimezone().isoformat(),'source':'用户本轮明确反馈','text':'目前的功能一切正常，包括频谱图也正常运转。继续压缩slice到80%以下','associated_version':'C11313','association':'按本对话上一轮交付版本关联；用户未另读出Build ID或SHA','bit_sha256':hashlib.sha256((root/'download/spectrum_resource_fit.bit').read_bytes()).hexdigest(),'validation':'USER_REPORTED_FUNCTION_AND_SPECTRUM_PASS','next_target_max_slice':7839}
(docs/'board_feedback_and_baseline.json').write_text(json.dumps(feedback,ensure_ascii=False,indent=2),encoding='utf-8')
meta=root/'download/spectrum_resource_fit.info.json'
info=json.loads(meta.read_text(encoding='utf-8-sig'));info['hardware_status']='USER_REPORTED_FUNCTION_AND_SPECTRUM_PASS';info['board_feedback']=feedback
meta.write_text(json.dumps(info,ensure_ascii=False,indent=2),encoding='utf-8')
print(new)
