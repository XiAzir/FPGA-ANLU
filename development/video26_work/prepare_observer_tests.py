from pathlib import Path
import hashlib
import json

ROOT = Path(__file__).resolve().parents[2]
w = Path(__file__).resolve().parent
p = ROOT / 'development/player_video26_runtime_diag/src/user_source/hdl_source'
t = (p / 'top_tf_hdmi_audio.v').read_text(encoding='utf-8-sig')
a = t.index('always @(posedge video_clk or posedge rst_all_reg)', t.index('reg video_mode;'))
b = t.index('always @(posedge sd_card_clk or posedge rst_all_reg)', a)
probe = '''module mode_counter_probe(input video_clk,rst_all_reg,video_mode_press,video_restart_toggle,
output reg video_mode,media_reset_active,output reg [3:0] video_mode_press_count);
reg [4:0] media_reset_count; reg [1:0] video_restart_sync; reg video_restart_seen;
''' + t[a:b] + '\nendmodule\n'
(w / 'mode_counter_probe.v').write_text(probe, encoding='utf-8')
files = [p / 'top_tf_hdmi_audio.v', p / 'SD/sd_card_cmd.v', p / 'SD/sd_card_top.v',
         p / 'SD/sd_card_sec_read_write.v', p / 'SD/spi_master.v', w / 'mode_counter_probe.v']
(w / 'observer_test_inputs.json').write_text(json.dumps([
    {'path': str(f), 'sha256': hashlib.sha256(f.read_bytes()).hexdigest()} for f in files
], indent=2) + '\n', encoding='utf-8')
