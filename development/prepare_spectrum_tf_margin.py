from pathlib import Path
import shutil

root=Path(__file__).resolve().parents[1]
old=root/'development/player_spectrum_observed'
new=root/'development/player_spectrum_tf_margin'
assert not new.exists()
for name in ('src','scripts','sim'):
    shutil.copytree(old/name,new/name,ignore=shutil.ignore_patterns('__pycache__','*.db','*.vvp','AC201_tf_hdmi_Runs'))
for folder in ('scripts','sim'):
    for f in (new/folder).iterdir():
        if f.suffix in ('.ps1','.tcl','.py'):
            f.write_text(f.read_text(encoding='utf-8-sig').replace('player_spectrum_observed','player_spectrum_tf_margin'),encoding='utf-8')
f=new/'src/td_project/AC201_tf_hdmi.al'
f.write_text(f.read_text(encoding='utf-8-sig').replace('player_spectrum_observed','player_spectrum_tf_margin'),encoding='utf-8')
for name in ('top_tf_hdmi_audio.v','player_status_monitor.v'):
    f=new/'src/user_source/hdl_source'/name
    f.write_text(f.read_text(encoding='utf-8-sig').replace('C11307','C11308'),encoding='utf-8')
(new/'build/audit').mkdir(parents=True)
for f in (old/'build/audit').glob('*.py'):
    shutil.copyfile(f,new/'build/audit'/f.name)
for f in (old/'build/audit').glob('*.tcl'):
    shutil.copyfile(f,new/'build/audit'/f.name)
print(new)
