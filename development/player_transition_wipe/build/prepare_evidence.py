from pathlib import Path
import sys

for _anlu_root in Path(__file__).resolve().parents:
    if (_anlu_root / 'scripts' / 'anlu_paths.py').is_file():
        sys.path.insert(0, str(_anlu_root / 'scripts'))
        break
from anlu_paths import DOCS_ROOT, REPOSITORY_ROOT, recorded_path

import json,hashlib
root=REPOSITORY_ROOT;p=root/'development/player_transition_wipe';parent=root/'development/player_pcm_waveform_keyfreeze/checkpoints/waveform_keyfreeze_20261012_verified'
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest().upper()
same,changed=[],[]
for f in (parent/'src/user_source').rglob('*'):
 if f.is_file():
  rel=f.relative_to(parent/'src');(same if sha(f)==sha(p/'src'/rel) else changed).append(rel.as_posix())
assert set(changed)=={'user_source/hdl_source/top_tf_hdmi_audio.v','user_source/hdl_source/player_status_monitor.v','user_source/hdl_source/tf_bmp_file_player.v','user_source/hdl_source/player_osd_state.v','user_source/hdl_source/frame_buffer_rgb888.v'}
new=['user_source/hdl_source/player_wipe_address.v']
(p/'build/model/parent_source_audit.json').write_text(json.dumps({'parentVersion':'C11204','parentFrozenFiles':158,'parentManifestSha256':sha(parent/'manifest.json'),'unchangedInheritedSources':same,'changedSources':changed,'newSources':new},indent=2),encoding='utf-8')
al=p/'src/td_project/AC201_tf_hdmi.al';text=al.read_text(encoding='utf-8-sig')
if 'player_wipe_address.v' not in text:
 text=text.replace('        </Verilog>','''            <File Path="../user_source/hdl_source/player_wipe_address.v">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&amp;R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="63"/>
                </FileInfo>
            </File>
        </Verilog>''',1)
 al.write_text(text,encoding='utf-8')
(p/'build/model/normalize_project.tcl').write_text('cd '+p.as_posix()+'/src/td_project\nif {[catch {\n import_device eagle_s20.db -package EG4S20BG256\n open_project AC201_tf_hdmi.al -single_run\n close_project\n} message]} { puts "PROJECT_NORMALIZATION_ERROR: $message"; exit 1 }\nputs PROJECT_NORMALIZATION_COMPLETE\nexit\n',encoding='utf-8')
print(json.dumps({'unchanged':len(same),'changed':changed,'new':new}))
