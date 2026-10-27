"""C31: restore exactly the C29 audio observer group on frozen C30."""
from pathlib import Path
import hashlib
import json
import shutil

ROOT = Path(__file__).resolve().parents[2]
OLD = ROOT / 'development/player_video30_probe_prune'
BASE = ROOT / 'development/player_video29_media_flow'
NEW = ROOT / 'development/player_video31_audio_ablation'
assert not NEW.exists(), NEW
shutil.copytree(OLD / 'src/user_source', NEW / 'src/user_source')
shutil.copytree(OLD / 'src/td_project/al_ip', NEW / 'src/td_project/al_ip')
shutil.copy2(OLD / 'src/td_project/AC201_tf_hdmi.al', NEW / 'src/td_project/AC201_tf_hdmi.al')
shutil.copytree(OLD / 'scripts', NEW / 'scripts')
(NEW / 'verification').mkdir()
for name in ('check_final_stages.ps1', 'normalize_project.tcl', 'dump_final_routed.tcl'):
    shutil.copy2(OLD / 'verification' / name, NEW / 'verification' / name)
for path in [NEW / 'src/td_project/AC201_tf_hdmi.al', *(NEW / 'scripts').iterdir(), *(NEW / 'verification').iterdir()]:
    path.write_text(path.read_text(encoding='utf-8-sig').replace('player_video30_probe_prune', 'player_video31_audio_ablation'), encoding='utf-8')
hdl = NEW / 'src/user_source/hdl_source'
(hdl / 'player_audio_output.v').unlink()
shutil.copy2(BASE / 'src/user_source/hdl_source/player_audio_probe.v', hdl / 'player_audio_probe.v')
al = NEW / 'src/td_project/AC201_tf_hdmi.al'
al.write_text(al.read_text(encoding='utf-8').replace('hdl_source/player_audio_output.v', 'hdl_source/player_audio_probe.v'), encoding='utf-8')
top = hdl / 'top_tf_hdmi_audio.v'
text = top.read_text(encoding='utf-8-sig')
text = text.replace('player_audio_output #', 'player_audio_probe #')
assert text.count('.tone_mode(debug_tone_mode)\n);') == 1
text = text.replace('.tone_mode(debug_tone_mode)\n);', '.led(led),.tone_mode(debug_tone_mode)\n);')
assert text.count('assign led = ~{video_mode,debug_tone_mode,display_valid,fs_ready};') == 1
text = text.replace('// D3 video mode, D2 internal tone, D1 committed image, D0 mounted.\nassign led = ~{video_mode,debug_tone_mode,display_valid,fs_ready};', '// C31 controlled ablation restores C29 audio observations and LED meanings.')
text = text.replace("32'h00C11330", "32'h00C11331")
top.write_text(text, encoding='utf-8')
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
a = {p.relative_to(OLD / 'src/user_source').as_posix(): sha(p) for p in (OLD / 'src/user_source').rglob('*') if p.is_file()}
b = {p.relative_to(NEW / 'src/user_source').as_posix(): sha(p) for p in (NEW / 'src/user_source').rglob('*') if p.is_file()}
changed = [p for p in a.keys() & b.keys() if a[p] != b[p]]
assert changed == ['hdl_source/top_tf_hdmi_audio.v'], changed
assert sha(hdl / 'player_audio_probe.v') == sha(BASE / 'src/user_source/hdl_source/player_audio_probe.v')
result = {'status': 'PREPARED_CONTROLLED_ABLATION', 'build': '00C11331',
          'base': 'C11330', 'purpose': 'Restore only C29 audio observation group and its LED outputs; test board audio regression',
          'changed': changed, 'removed': sorted(a.keys() - b.keys()), 'added': sorted(b.keys() - a.keys()),
          'audio_probe_identical_to_C29': True, 'source_inputs': b,
          'board_status': 'PENDING', 'root_cause': 'UNDETERMINED'}
(NEW / 'verification/preparation.json').write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')
print('C31_PREPARED_ONLY_AUDIO_OBSERVER_GROUP_RESTORED')
