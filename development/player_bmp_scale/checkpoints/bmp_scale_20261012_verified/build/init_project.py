from pathlib import Path
import hashlib,json,shutil
root=Path('E:/VSCODE-project/FPGA-ANLU');p=root/'development/player_bmp_scale'
parent=root/'development/player_transition_wipe/checkpoints/transition_wipe_20261012_verified'
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest().upper()
assert sha(parent/'manifest.json')=='A6B0AE1DBCAF1A92D360FA7F6E4AA935C1777A06D705940ED1364999A239A4A9'
entries=json.loads((parent/'manifest.json').read_text(encoding='utf-8-sig'));assert len(entries)==169
for e in entries:assert sha(parent/e['path'])==e['sha256']
assert not (p/'src').exists()
for name in ['src','scripts']:shutil.copytree(parent/name,p/name)
for f in (p/'scripts').rglob('*'):
    if f.is_file():f.write_text(f.read_text(encoding='utf-8-sig').replace('player_transition_wipe','player_bmp_scale'),encoding='utf-8')
al=p/'src/td_project/AC201_tf_hdmi.al';al.write_text(al.read_text(encoding='utf-8-sig').replace('/player_transition_wipe/','/player_bmp_scale/'),encoding='utf-8')
for name in ['top_tf_hdmi_audio.v','player_status_monitor.v']:
    f=p/'src/user_source/hdl_source'/name;f.write_text(f.read_text(encoding='utf-8-sig').replace('C11205','C11206'),encoding='utf-8')
model=p/'build/model';model.mkdir(parents=True)
for f in (parent/'build/model').iterdir():
    if f.suffix in ['.v','.ps1','.py','.hex','.json','.md']:shutil.copy2(f,model/f.name)
for f in model.glob('*.ps1'):f.write_text(f.read_text(encoding='utf-8-sig').replace('/player_transition_wipe/','/player_bmp_scale/'),encoding='utf-8')
print('C11206_PARENT169_SHA_PASS_ISOLATED_SOURCE_READY')
