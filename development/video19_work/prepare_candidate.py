from pathlib import Path
import hashlib,json,shutil
from datetime import datetime
R=Path(__file__).resolve().parents[2]
P=R/'development/player_spectrum_ctrl18'
C=R/'development/player_video19'
assert not C.exists()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
snapshot=[]
for folder in ['src','scripts','sim']:
    for p in (P/folder).rglob('*'):
        if p.is_file() and p.suffix.lower() not in ['.db','.vvp','.dmp','.pyc']:
            snapshot.append({'path':p.relative_to(P).as_posix(),'sha256':sha(p)})
    shutil.copytree(P/folder,C/folder,ignore=shutil.ignore_patterns('*.db','*.vvp','*.dmp','__pycache__','work','*_Runs'))
def adapt(s):
    return s.replace('player_spectrum_ctrl18','player_video19').replace('spectrum_ctrl18','video19').replace('C11318','C11319').replace('ctrl18_work','video19_work')
for folder in ['scripts','sim']:
    for p in (C/folder).rglob('*'):
        if p.is_file() and p.suffix in ['.py','.ps1','.tcl']:
            p.write_text(adapt(p.read_text(encoding='utf-8-sig')),encoding='utf-8')
for name in ['src/td_project/AC201_tf_hdmi.al','src/user_source/hdl_source/top_tf_hdmi_audio.v','src/user_source/hdl_source/player_status_monitor.v']:
    p=C/name;p.write_text(adapt(p.read_text(encoding='utf-8-sig')),encoding='utf-8')
for name in ['gate.qor','place.qor','route.qor','final_timing.rpt','top_inst.bid','beforeGateOpt.aig']:
    p=C/'src/td_project'/name
    if p.exists():p.unlink()
B=C/'build';(B/'baseline').mkdir(parents=True)
(B/'baseline/C11318_source_sha256.json').write_text(json.dumps(snapshot,indent=2),encoding='utf-8')
for name in ['AC201_tf_hdmi_gate.area','AC201_tf_hdmi_phy.area','AC201_tf_hdmi_phy.ts','AC201_tf_hdmi_pr.timing']:
    shutil.copy2(P/'build/manual'/name,B/'baseline'/name)
for source,destination in [('src/td_project/route.qor','baseline/route.qor'),('build/strategy.json','strategy.json'),('build/final_binding.json','baseline/final_binding.json')]:
    shutil.copy2(P/source,B/destination)
receipt={'created':datetime.now().astimezone().isoformat(),'parent':'C11318','candidate':'C11319',
         'parent_bit_sha256':sha(R/'download/spectrum_ctrl18.bit'),
         'parent_manifest_sha256':sha(P/'checkpoints/C11318_ctrl18_20261021_offline/manifest.json'),
         'source_snapshot_files':len(snapshot),'status':'VIDEO_INTEGRATION_IN_PROGRESS','hardware_status':'BOARD_NOT_TESTED'}
(B/'baseline/receipt.json').write_text(json.dumps(receipt,indent=2),encoding='utf-8')
print(json.dumps(receipt))
