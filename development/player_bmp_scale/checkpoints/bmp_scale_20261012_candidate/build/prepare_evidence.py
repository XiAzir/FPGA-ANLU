from pathlib import Path
import json, hashlib

root=Path('E:/VSCODE-project/FPGA-ANLU')
p=root/'development/player_bmp_scale'
parent=root/'development/player_transition_wipe/checkpoints/transition_wipe_20261012_verified'
def sha(f): return hashlib.sha256(f.read_bytes()).hexdigest().upper()
assert sha(parent/'manifest.json')=='A6B0AE1DBCAF1A92D360FA7F6E4AA935C1777A06D705940ED1364999A239A4A9'
manifest=json.loads((parent/'manifest.json').read_text(encoding='utf-8-sig'))
assert len(manifest)==169
for entry in manifest: assert sha(parent/entry['path'])==entry['sha256']
same,changed=[],[]
for f in (parent/'src/user_source').rglob('*'):
    if f.is_file():
        rel=f.relative_to(parent/'src')
        (same if sha(f)==sha(p/'src'/rel) else changed).append(rel.as_posix())
assert set(changed)=={'user_source/hdl_source/top_tf_hdmi_audio.v',
 'user_source/hdl_source/player_status_monitor.v',
 'user_source/hdl_source/tf_bmp_file_player.v',
 'user_source/hdl_source/frame_buffer_rgb888.v',
 'user_source/hdl_source/SD/frame_read_write.v'}
new=sorted(f.relative_to(p/'src').as_posix() for f in (p/'src/user_source').rglob('*')
 if f.is_file() and not (parent/'src'/f.relative_to(p/'src')).exists())
assert new==['user_source/hdl_source/bmp_scale_engine.v']
(p/'build/model/parent_source_audit.json').write_text(json.dumps({
 'parentVersion':'C11205','parentFrozenFiles':len(manifest),'parentManifestSha256':sha(parent/'manifest.json'),
 'unchangedInheritedSources':same,'changedSources':changed,'newSources':new},indent=2),encoding='utf-8')
al=p/'src/td_project/AC201_tf_hdmi.al'
text=al.read_text(encoding='utf-8-sig')
if 'bmp_scale_engine.v' not in text:
    text=text.replace('        </Verilog>','''            <File Path="../user_source/hdl_source/bmp_scale_engine.v">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&amp;R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="64"/>
                </FileInfo>
            </File>
        </Verilog>''',1)
    al.write_text(text,encoding='utf-8')
(p/'build/model/normalize_project.tcl').write_text('cd '+p.as_posix()+'/src/td_project\nif {[catch {\n import_device eagle_s20.db -package EG4S20BG256\n open_project AC201_tf_hdmi.al -single_run\n close_project\n} message]} { puts "PROJECT_NORMALIZATION_ERROR: $message"; exit 1 }\nputs PROJECT_NORMALIZATION_COMPLETE\nexit\n',encoding='utf-8')
print(json.dumps({'parentFiles':len(manifest),'unchanged':len(same),'changed':changed,'new':new}))
