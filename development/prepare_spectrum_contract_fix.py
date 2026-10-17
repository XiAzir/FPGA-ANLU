from pathlib import Path
import shutil

root = Path(__file__).resolve().parents[1]
old = root / 'development/player_spectrum_fft_recover'
new = root / 'development/player_spectrum_contract_fix'
if new.exists():
    raise SystemExit('Destination exists; refusing to overwrite candidate')
for name in ('src', 'scripts', 'sim'):
    shutil.copytree(old/name, new/name, ignore=shutil.ignore_patterns('__pycache__', '*.db', '*.vvp', 'AC201_tf_hdmi_Runs'))
for folder in ('scripts','sim'):
    for f in (new/folder).iterdir():
        if f.suffix in ('.ps1','.tcl','.py'):
            f.write_text(f.read_text(encoding='utf-8-sig').replace('player_spectrum_fft_recover','player_spectrum_contract_fix'), encoding='utf-8')
f=new/'src/td_project/AC201_tf_hdmi.al'
f.write_text(f.read_text(encoding='utf-8-sig').replace('player_spectrum_fft_recover','player_spectrum_contract_fix'), encoding='utf-8')
for name in ('top_tf_hdmi_audio.v','player_status_monitor.v'):
    f=new/'src/user_source/hdl_source'/name
    f.write_text(f.read_text(encoding='utf-8-sig').replace('C11310','C11311'), encoding='utf-8')
f=new/'src/user_source/hdl_source/video_rgb_to_axis_640x480.v'
s=f.read_text(encoding='utf-8-sig')
needle="// 一行首像素"+chr(10)+"                S_x_cnt <= 11'd0;"
assert s.count(needle)==1
s=s.replace(needle,"// Count pixels emitted, including this first pixel."+chr(10)+"                S_x_cnt <= 11'd1;")
s=s.replace('// 640x480 最后一个有效像素','// Old count 639 means this is the 640th active pixel.')
f.write_text(s,encoding='utf-8')
(new/'build/model').mkdir(parents=True)
shutil.copyfile(old/'build/board_feedback_no_signal_20261014/tb_video_axis_contract.v',new/'sim/tb_video_axis_contract.v')
print(new)
