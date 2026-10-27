"""Create observer-removal ablations from frozen C29 without editing it."""
from pathlib import Path
import hashlib
import json
import re
import shutil

ROOT=Path(__file__).resolve().parents[2]
BASE=ROOT/'development/player_video29_media_flow'
CAND=ROOT/'development/player_video30_probe_prune'
WORK=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):return p.read_text(encoding='utf-8-sig')
def write(p,t):p.write_text(t,encoding='utf-8')
def replace(t,a,b):
    assert t.count(a)==1,(a,t.count(a))
    return t.replace(a,b)
def sub(t,a,b=''):
    t,n=re.subn(a,b,t,flags=re.S)
    assert n==1,(a,n)
    return t

assert not CAND.exists()
shutil.copytree(BASE/'src',CAND/'src')
shutil.copytree(BASE/'scripts',CAND/'scripts')
(CAND/'verification').mkdir()
for name in ('check_final_stages.ps1','normalize_project.tcl','dump_final_routed.tcl'):
    shutil.copy2(BASE/'verification'/name,CAND/'verification'/name)
for directory in (CAND/'scripts',CAND/'verification'):
    for p in directory.iterdir():
        if p.is_file():write(p,read(p).replace('player_video29_media_flow','player_video30_probe_prune'))
al=CAND/'src/td_project/AC201_tf_hdmi.al'
write(al,read(al).replace('player_video29_media_flow','player_video30_probe_prune'))
hdl=CAND/'src/user_source/hdl_source'
top=hdl/'top_tf_hdmi_audio.v'
t=read(top)
t=sub(t,r'reg \[31:0\] sd_crc_sync0,sd_crc_sync1;.*?(?=wire \[127:0\] fs_bmp_clusters)')
t=t.replace('wire [15:0] sd_crc_checked, sd_crc_bad;\n','')
t=sub(t,r'// Declare diagnostic buses before their first connection.*?(?=// Stereo PCM)')
t=sub(t,r'wire \[31:0\] compact_status_hex;.*?(?=wire \[9:0\]  tmds_ch0_data;)')
t=t.replace('reg [3:0] video_mode_press_count;\n','')
for line in ('wire [15:0] adjust_debug_state;\n','wire [15:0] card_debug_state;\n',
             'wire [21:0] card_command_debug;\n','        video_mode_press_count<=0;\n',
             "        if(video_mode_press) video_mode_press_count<=video_mode_press_count+1'b1;\n"):
    assert line in t,line
    t=t.replace(line,'')
t=replace(t,'.failure_detail(photo_failure_detail)','.failure_detail()')
t=replace(t,'.debug_state(adjust_debug_state)','.debug_state()')
t=sub(t,r'player_video_source_probe u_video_source_probe \(.*?\n\);\nassign vout_data_base = vout_data_probe;',
      '''// key0_n_async was tied high in C29: test pattern mode is unreachable.
assign probe_mode = 1'b0;
assign probe_tone_toggle = debug_tone_press;
assign vout_data_base = osd_frame_valid ? vout_data_raw : 24'd0;''')
t=t.replace('wire [23:0] vout_data_probe;\n','')
t=replace(t,'wire        probe_mode, probe_tone_toggle, probe_key0_active;',
          'wire        probe_mode, probe_tone_toggle;')
t=sub(t,r'    \.debug_memory\(debug_memory\),.*?\.debug_underflow\(memory_underflow\)',
      '    .debug_memory()')
t=sub(t,r'    \.debug_state\(debug_wav_state\),.*?\.debug_push_pos\(\),\.debug_data_offset\(\)',
      '''    .debug_state(),.debug_phase(),.debug_scan_pos(),.debug_scan_byte(),
    .debug_sample_push(),.debug_push_data(),.debug_fifo_level(),
    .debug_push_pos(),.debug_data_offset()''')
t=sub(t,r'// Diagnostic-only build: monitor source pixels.*?(?=// Combinational overlays)')
t=sub(t,r'wire \[23:0\] spectrum_debug_frames,spectrum_debug_data;.*?(?=// Passive observer of the exact PCM)')
t=sub(t,r'\.rgb_out\(vout_data\),\.spectrum_debug_frames\(spectrum_debug_frames\),.*?\.spectrum_debug_control\(spectrum_debug_control\)',
      '''.rgb_out(vout_data),.spectrum_debug_frames(),.spectrum_debug_data(),
 .spectrum_debug_progress(),.spectrum_debug_events(),.spectrum_debug_accepted(),
 .spectrum_debug_control()''')
t=replace(t,'.underflow_event(audio_underflow_event)','.underflow_event()')
t=replace(t,'.debug_state(card_debug_state), .debug_command(card_command_debug),',
          '.debug_state(), .debug_command(),')
t=replace(t,'.read_crc_checked(sd_crc_checked),.read_crc_bad(sd_crc_bad)',
          '.read_crc_checked(),.read_crc_bad()')
t=sub(t,r'wire \[27:0\] compact_file_status_sd = .*?(?=endmodule)',
      '''// Fixed build identifier; no runtime diagnostic page counters.
status_hex595 #(.CLK_HZ(25000000)) u_status_hex (
    .clk(video_clk),.rst(rst_all),.hex_value(32'h00C11330),
    .seg7_dio(seg7_dio),.seg7_sclk(seg7_sclk),.seg7_rclk(seg7_rclk)
);
''')
t=t.replace('// LED meanings in this audio probe are owned by u_audio_probe below.',
            '// Active-low LEDs show the live playback state in the final candidate.')
write(top,t)

# Restore the original memory-control files; C29 added only passive tap ports.
for name in ('frame_buffer_rgb888.v','SD/frame_read_write.v','SD/frame_fifo_read.v'):
    shutil.copy2(ROOT/'development/player_video27_command_boundary/src/user_source/hdl_source'/name,hdl/name)

removed=['player_video_source_probe.v','player_memory_runtime_probe.v','player_pcm_crc_probe.v',
         'hdmi_packet_monitor.v','player_compact_status_pages.v','player_debug_monitor.v',
         'player_debug_overlay.v','player_bit17_led_probe.v','player_cadence_probe.v']
altext=read(al)
for name in removed:
    p=hdl/name
    assert p.exists(),name
    p.unlink()
    pattern=r'            <File Path="[^"\n]*/'+re.escape(name)+r'">.*?            </File>\n'
    altext,n=re.subn(pattern,'',altext,flags=re.S)
    assert n==1,(name,n)
write(al,altext)

# D1 removes external observers while retaining the old audio LED observations.
d1=WORK/'ablation/D1_observers_off'
assert not d1.exists()
shutil.copytree(CAND,d1)
for p in [d1/'src/td_project/AC201_tf_hdmi.al',*list((d1/'scripts').iterdir()),*list((d1/'verification').iterdir())]:
    if p.is_file():write(p,read(p).replace(str(CAND).replace('\\','/'),str(d1).replace('\\','/')))

# D2 removes audio LED-only measurements and uses live state indicators.
audio=hdl/'player_audio_probe.v'
a=read(audio)
a=sub(a,r'    reg fifo_nonzero_seen, take_seen;.*?(?=    wav_pcm_bridge)')
a=sub(a,r'    always @\(posedge sd_clk or posedge rst\).*?(?=endmodule)',
      '''    always @(posedge pixel_clk or posedge rst) begin
        if(rst) tone_mode <= 1'b0;
        else if(tone_toggle) tone_mode <= ~tone_mode;
    end
''')
a=a.replace('    output [3:0] led,\n','')
a=a.replace('module player_audio_probe #(','module player_audio_output #(')
a=a.replace('// Diagnostic source selection and independent observations; no TF writes.',
            '// WAV/tone source selection and HDMI PCM/ACR output.')
write(hdl/'player_audio_output.v',a)
audio.unlink()
write(al,read(al).replace('hdl_source/player_audio_probe.v','hdl_source/player_audio_output.v'))
t=read(top).replace('player_audio_probe #','player_audio_output #')
t=replace(t,'.led(led),.tone_mode(debug_tone_mode)', '.tone_mode(debug_tone_mode)')
t=replace(t,'assign shared_card_read=fs_ready ? arb_card_read : fs_read;',
          '''// D3 video mode, D2 internal tone, D1 committed image, D0 mounted.
assign led = ~{video_mode,debug_tone_mode,display_valid,fs_ready};
assign shared_card_read=fs_ready ? arb_card_read : fs_read;''')
write(top,t)

# CRC counters never affected SD acceptance; delete that observer at its source.
cmd=hdl/'SD/sd_card_cmd.v'
c=read(cmd)
for line in c.splitlines(True):
    if re.match(r'\s*(output reg\[15:0\]\s+read_crc_(checked|bad),|reg\[15:0\]\s+read_crc16;|reg\[7:0\]\s+read_crc_hi;)',line):
        c=c.replace(line,'')
c=sub(c,r'function \[15:0\] crc16_ccitt_byte;.*?endfunction\n')
c=sub(c,r'// Passive CRC-16/CCITT.*?(?=endmodule)')
write(cmd,c)
sdtop=hdl/'SD/sd_card_top.v'
c=read(sdtop)
for line in c.splitlines(True):
    if re.match(r'\s*(output\[15:0\]\s+read_crc_(checked|bad),|\.read_crc_(checked|bad)\s*\()',line):
        c=c.replace(line,'')
write(sdtop,c)
t=read(top)
t=replace(t,"    .sd_sec_write_data_req(), .sd_sec_write_end(),\n    .read_crc_checked(),.read_crc_bad()",
          "    .sd_sec_write_data_req(), .sd_sec_write_end()")
write(top,t)

manifest={'base':'C11329','candidate':'C11330','groups':{
 'D1':'Remove post-core packet, PCM CRC, memory probes, snapshots and runtime diagnostic pages; collapse unreachable test-pattern source; fixed version display',
 'D2':'Remove audio LED measurements/blink and passive SD CRC arithmetic/counters; live LED indicators'},
 'removed_files':removed+['player_audio_probe.v'],
 'added_files':['player_audio_output.v'],
 'baseline_bit_sha256':sha(ROOT/'download/video29_media_flow.bit'),
 'baseline_package_sha256':sha(ROOT/'deliverables/video29_media_flow_c11329_20261023.zip')}
assert manifest['baseline_bit_sha256']=='0f87f90f55eec622fcfe2373fbcb7c7a97a349bda79babcbafbe483e4a6e3c56'
(WORK/'preparation.json').write_text(json.dumps(manifest,indent=2),encoding='utf-8')
print('C30 and D1 observer-removal ablation sources prepared; C29 preserved')
