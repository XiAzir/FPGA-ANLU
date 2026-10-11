from pathlib import Path
from datetime import datetime, timezone, timedelta
import shutil, json, hashlib

root = Path('E:/VSCODE-project/FPGA-ANLU')
source = root/'development/player_dynamic_text_fit'
dest = root/'development/player_dynamic_text_video_probe'
assert not dest.exists(), 'Do not overwrite an experiment'
dest.mkdir()
shutil.copytree(source/'src', dest/'src')
(dest/'scripts').mkdir()
for name in ['build_candidate.ps1','build_manual_syn.tcl','build_manual_phy.tcl','fix_hold.tcl','generate_bit.tcl']:
    text=(source/'scripts'/name).read_text(encoding='utf-8-sig')
    text=text.replace('player_dynamic_text_fit','player_dynamic_text_video_probe')
    (dest/'scripts'/name).write_text(text, encoding='utf-8')
project=dest/'src/td_project/AC201_tf_hdmi.al'
project.write_text(project.read_text(encoding='utf-8-sig').replace('player_dynamic_text_fit','player_dynamic_text_video_probe'),encoding='utf-8')
assert str(dest).replace('\\','/')+'/src/td_project' in project.read_text(encoding='utf-8')
(dest/'sim').mkdir()
(dest/'build').mkdir()
sha=lambda p: hashlib.sha256(p.read_bytes()).hexdigest().upper()
manifest=[{'path':p.relative_to(source/'src/user_source').as_posix(),'sha256':sha(p)} for p in sorted((source/'src/user_source').rglob('*')) if p.is_file()]
data={'created_beijing':datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S'),'source_project':str(source),'destination':str(dest),'source_user_manifest':manifest,'build_status':'NOT_BUILT','hardware_result':'NOT_TESTED','purpose':'Runtime image/constant-source isolation in same FPGA implementation; not a root-cause claim or production fix','card_or_flash_operations':'NONE'}
(dest/'build/preparation.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(str(dest))
