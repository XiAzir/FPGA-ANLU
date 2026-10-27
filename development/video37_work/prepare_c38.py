from pathlib import Path
import hashlib
import json
import re
import shutil

ROOT = Path(__file__).resolve().parents[2]
BASE = ROOT/'development/player_video37_open_tx'
TARGET = ROOT/'development/player_video38_open_tx'
OLD_PROJECT = 'AC201_video37_open_tx'
PROJECT = 'AC201_video38_open_tx'

binding = []
for source in sorted((BASE/'src/user_source').rglob('*')):
    if not source.is_file():
        continue
    relative = source.relative_to(BASE)
    target = TARGET/relative
    target.parent.mkdir(parents=True,exist_ok=True)
    shutil.copy2(source,target)
    binding.append({'relative':relative.as_posix(), 'baseline_sha256':hashlib.sha256(source.read_bytes()).hexdigest()})

top = TARGET/'src/user_source/hdl_source/top.v'
text = top.read_text(encoding='utf-8')
text = re.sub(r'cx < (80|160|240|320|400|480|560)\b',
              lambda match:'cx < '+str(int(match.group(1))*3),text)
text = text.replace('.H_ACTIVE(640), .H_FRONT(16), .H_SYNC(96), .H_BACK(248)',
                    '.H_ACTIVE(1920), .H_FRONT(8), .H_SYNC(8), .H_BACK(64)')
text = text.replace('.V_ACTIVE(480), .V_FRONT(10), .V_SYNC(2), .V_BACK(58)',
                    '.V_ACTIVE(1080), .V_FRONT(4), .V_SYNC(5), .V_BACK(11)')
text = text.replace('cx == 999 && cy == 549','cx == 1999 && cy == 1099')
text = text.replace("32'h00C11337","32'h00C11338")
top.write_text(text,encoding='utf-8')

project_dir = TARGET/'src/td_project'
project_dir.mkdir(parents=True,exist_ok=True)
project = (BASE/f'src/td_project/{OLD_PROJECT}.al').read_text(encoding='utf-8')
project = project.replace(BASE.as_posix(),TARGET.as_posix()).replace(OLD_PROJECT,PROJECT)
(project_dir/f'{PROJECT}.al').write_text(project,encoding='utf-8')
(TARGET/'scripts').mkdir(exist_ok=True)
(TARGET/'build/manual').mkdir(parents=True,exist_ok=True)
for name in ('build_manual_syn.tcl','build_manual_phy.tcl','fix_hold.tcl','generate_bit.tcl'):
    script = (BASE/'scripts'/name).read_text(encoding='utf-8')
    script = script.replace(BASE.as_posix(),TARGET.as_posix()).replace(OLD_PROJECT,PROJECT).replace('C11337','C11338')
    (TARGET/'scripts'/name).write_text(script,encoding='utf-8')

for item in binding:
    item['candidate_sha256'] = hashlib.sha256((TARGET/item['relative']).read_bytes()).hexdigest()
assert [item['relative'] for item in binding if item['baseline_sha256'] != item['candidate_sha256']] == ['src/user_source/hdl_source/top.v']
(ROOT/'development/video37_work/c38_source_pair.json').write_text(json.dumps({
    'baseline':BASE.as_posix(),'candidate':TARGET.as_posix(),'user_source':binding,
    'changes':'Only top geometry, palette band width, frame-end count and build ID; identical TX, PLL, PHY and constraints.'
},indent=2)+'\n')
print(json.dumps({'candidate':TARGET.as_posix(),'source_files':len(binding),'geometry':[1920,1080,2000,1100]}))
