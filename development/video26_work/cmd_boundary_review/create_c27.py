from pathlib import Path
import shutil,hashlib,json
ROOT=Path(__file__).resolve().parents[3]
base=ROOT/'development/player_video26_runtime_diag'
p=ROOT/'development/player_video27_command_boundary'
assert not p.exists()
(p/'src/td_project').mkdir(parents=True)
shutil.copytree(base/'src/user_source',p/'src/user_source')
shutil.copytree(base/'src/td_project/al_ip',p/'src/td_project/al_ip')
shutil.copy2(base/'src/td_project/AC201_tf_hdmi.al',p/'src/td_project/AC201_tf_hdmi.al')
shutil.copytree(base/'scripts',p/'scripts')
(p/'verification').mkdir()
for n in ['check_final_stages.ps1','dump_final_routed.tcl','normalize_project.tcl']:
    shutil.copy2(base/'verification'/n,p/'verification'/n)
for f in list((p/'scripts').iterdir())+list((p/'verification').iterdir())+[p/'src/td_project/AC201_tf_hdmi.al']:
    if f.is_file():
        t=f.read_text(encoding='utf-8-sig').replace('player_video26_runtime_diag','player_video27_command_boundary')
        f.write_text(t,encoding='utf-8')
source=Path(__file__).resolve().parent/'sd_card_cmd.v'
shutil.copy2(source,p/'src/user_source/hdl_source/SD/sd_card_cmd.v')
f=p/'src/user_source/hdl_source/player_compact_status_pages.v'
f.write_text(f.read_text(encoding='utf-8-sig').replace('00C11326','00C11327'),encoding='utf-8')
sha=lambda f:hashlib.sha256(f.read_bytes()).hexdigest()
changed=[]
for f in (p/'src/user_source').rglob('*'):
    if f.is_file() and sha(f)!=sha(base/'src/user_source'/f.relative_to(p/'src/user_source')):
        changed.append(f.relative_to(p/'src/user_source').as_posix())
assert sorted(changed)==['hdl_source/SD/sd_card_cmd.v','hdl_source/player_compact_status_pages.v']
(p/'verification/source_delta.json').write_text(json.dumps({'base':'C11326','changed':changed,'other_source_files_identical':119,'command_parser_sha256':sha(source),'purpose':'Complete six command bytes before examining R1; observer follows same phase boundary','matrix':str(source.parent/'matrix_summary.json')},indent=2)+'\n',encoding='utf-8')
print('Created C27: six-byte command/response boundary only, C26 observations retained')
