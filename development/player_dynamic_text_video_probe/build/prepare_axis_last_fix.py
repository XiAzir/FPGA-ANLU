from pathlib import Path
from datetime import datetime, timezone, timedelta
import hashlib
import json
import shutil

root = Path('E:/VSCODE-project/FPGA-ANLU')
source = root / 'development/player_dynamic_text_video_probe'
dest = root / 'development/player_dynamic_text_axis_last_fix'
assert not dest.exists(), 'Refuse to overwrite an existing experiment'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest().upper()
before = {str(p.relative_to(source / 'src')): sha(p) for p in (source / 'src').rglob('*') if p.is_file()}
audit = source / 'build/axis_protocol_fix_audit'
assert 'failures=0' in (audit / 'run.log').read_text(encoding='utf-8')
old_path = source / 'src/user_source/hdl_source/video_rgb_to_axis_640x480.v'
old = old_path.read_bytes()
assert old.count(b"S_x_cnt == 11'd639") == 1
new = old.replace(b"S_x_cnt == 11'd639", b"S_x_cnt == 11'd638")
prototype = (audit / 'prototype/video_rgb_to_axis_640x480_fixed.v').read_text(encoding='utf-8')
assert prototype.replace('module video_rgb_to_axis_640x480_fixed(', 'module video_rgb_to_axis_640x480(').rstrip('\n') == new.decode('utf-8').replace('\r\n', '\n').rstrip('\n')

(dest / 'src/td_project').mkdir(parents=True)
shutil.copytree(source / 'src/user_source', dest / 'src/user_source')
shutil.copytree(source / 'src/td_project/al_ip', dest / 'src/td_project/al_ip')
al_text = (source / 'src/td_project/AC201_tf_hdmi.al').read_text(encoding='utf-8')
al_text = al_text.replace(source.as_posix(), dest.as_posix())
(dest / 'src/td_project/AC201_tf_hdmi.al').write_text(al_text, encoding='utf-8')
(dest / 'src/user_source/hdl_source/video_rgb_to_axis_640x480.v').write_bytes(new)

(dest / 'scripts').mkdir()
for name in ['build_candidate.ps1', 'build_manual_syn.tcl', 'build_manual_phy.tcl', 'fix_hold.tcl', 'generate_bit.tcl']:
    script = (source / 'scripts' / name).read_text(encoding='utf-8')
    script = script.replace(source.as_posix(), dest.as_posix())
    script = script.replace('AC201_player_dynamic_text_video_probe.bit', 'AC201_player_dynamic_text_axis_last_fix.bit')
    (dest / 'scripts' / name).write_text(script, encoding='utf-8')

# Test the actual candidate source, with a named copy of the OLD module only
# for the parallel comparison; production source never gets a test alias.
model_dir = dest / 'sim/axis_protocol'
model_dir.mkdir(parents=True)
(model_dir / 'video_rgb_to_axis_640x480_old.v').write_bytes(old.replace(b'module video_rgb_to_axis_640x480(', b'module video_rgb_to_axis_640x480_old('))
tb = (audit / 'tb_axis_protocol_fix_audit.v').read_text(encoding='utf-8')
tb = tb.replace('video_rgb_to_axis_640x480 ', 'video_rgb_to_axis_640x480_old ')
tb = tb.replace('video_rgb_to_axis_640x480_fixed ', 'video_rgb_to_axis_640x480 ')
(model_dir / 'tb_axis_protocol_fix_audit.v').write_text(tb, encoding='utf-8')

diffs = []
for p in (source / 'src/user_source').rglob('*'):
    if p.is_file():
        other = dest / 'src/user_source' / p.relative_to(source / 'src/user_source')
        if sha(p) != sha(other):
            diffs.append(str(p.relative_to(source / 'src/user_source')))
assert diffs == ['hdl_source\\video_rgb_to_axis_640x480.v'] or diffs == ['hdl_source/video_rgb_to_axis_640x480.v']
assert before == {str(p.relative_to(source / 'src')): sha(p) for p in (source / 'src').rglob('*') if p.is_file()}, 'Old sources changed during preparation'
(dest / 'build').mkdir()
info = {
    'created_beijing': datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S'),
    'source_project': str(source), 'candidate_project': str(dest),
    'user_source_total': len([p for p in (dest / 'src/user_source').rglob('*') if p.is_file()]),
    'changed_user_source': diffs, 'change': 'Only TLAST comparison 639 -> 638; module interface, SOF/valid/data latency retained',
    'old_source_sha256': sha(old_path), 'new_source_sha256': sha(dest / 'src/user_source/hdl_source/video_rgb_to_axis_640x480.v'),
    'original_sources_unchanged': True,
    'prototype_model': str(audit / 'REPORT.md'),
    'candidate_model': 'PENDING', 'td_build': 'NOT_STARTED', 'hardware_result': 'NOT_TESTED',
    'root_cause': 'NOT_CONFIRMED', 'agent_card_or_flash_operations': 'NONE'
}
(dest / 'build/preparation.json').write_text(json.dumps(info, ensure_ascii=False, indent=2), encoding='utf-8')
print(json.dumps(info, ensure_ascii=True, indent=2))
