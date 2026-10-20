"""Prepare a passive atomic diagnostic candidate from the failed C11310 source."""
from pathlib import Path
import shutil,json,hashlib

root=Path(__file__).resolve().parents[1]
old=root/'development/player_spectrum_fft_recover'
new=root/'development/player_spectrum_trace'
if new.exists():raise SystemExit('Refusing to overwrite an existing trace candidate')
for name in ('src','scripts','sim'):
    shutil.copytree(old/name,new/name,ignore=shutil.ignore_patterns('__pycache__','*.db','*.dmp','*.vvp','*_Runs','work'))
for folder in ('scripts','sim'):
    for f in (new/folder).iterdir():
        if f.suffix in ('.ps1','.tcl','.py'):
            f.write_text(f.read_text(encoding='utf-8-sig').replace('player_spectrum_fft_recover','player_spectrum_trace'),encoding='utf-8')
hdl=new/'src/user_source/hdl_source'
def edit(name,oldtext,newtext):
    f=hdl/name;s=f.read_text(encoding='utf-8-sig')
    assert s.count(oldtext)==1,(name,oldtext)
    f.write_text(s.replace(oldtext,newtext),encoding='utf-8')

edit('player_spectrum_analyzer.v','output wire [23:0] debug_progress, debug_events, debug_accepted','output wire [23:0] debug_progress, debug_events, debug_accepted,\n    output wire [7:0] debug_control')
edit('player_spectrum_analyzer.v','assign debug_accepted=accepted_samples;','assign debug_accepted=accepted_samples;\n    assign debug_control={fft_reset,source_change,timeout_pulse,sample_write_en,frame_done,band_valid,debug_coeff_nonzero};')
# Declaration ordering only, required by the installed ModelSim 10.1c.
edit('player_spectrum_analyzer.v','    reg [8:0] twiddle_addr;\n','')
edit('player_spectrum_analyzer.v','    wire [31:0] twiddle_q;','    wire [31:0] twiddle_q;\n    reg [8:0] twiddle_addr;')
edit('player_pcm_waveform.v','output wire [23:0] spectrum_debug_progress,spectrum_debug_events,spectrum_debug_accepted','output wire [23:0] spectrum_debug_progress,spectrum_debug_events,spectrum_debug_accepted,\n    output wire [7:0] spectrum_debug_control')
edit('player_pcm_waveform.v','.debug_accepted(spectrum_debug_accepted)','.debug_accepted(spectrum_debug_accepted),.debug_control(spectrum_debug_control)')
edit('top_tf_hdmi_audio.v','wire [23:0] spectrum_debug_progress,spectrum_debug_events,spectrum_debug_accepted;','wire [23:0] spectrum_debug_progress,spectrum_debug_events,spectrum_debug_accepted;\nwire [7:0] spectrum_debug_control;')
edit('top_tf_hdmi_audio.v','.spectrum_debug_events(spectrum_debug_events),.spectrum_debug_accepted(spectrum_debug_accepted)', '.spectrum_debug_events(spectrum_debug_events),.spectrum_debug_accepted(spectrum_debug_accepted),\n .spectrum_debug_control(spectrum_debug_control)')
snapshot='''wire snapshot_valid;
wire [27:0] snapshot_header;
wire [23:0] snapshot_prev_progress,snapshot_progress,snapshot_prev_accepted,snapshot_accepted,snapshot_frames,snapshot_events;
player_fault_snapshot u_fault_snapshot (
 .clk(video_clk),.rst(rst_all),.tone_mode(debug_tone_mode),.audio_valid(audio_valid),
 .axis_valid(axis_s_valid),.axis_user(axis_s_user),.hdmi_locked(hdmi_video_locked),
 .progress(spectrum_debug_progress),.accepted(spectrum_debug_accepted),
 .events(spectrum_debug_events),.frames(spectrum_debug_frames),.control(spectrum_debug_control),
 .snapshot_valid(snapshot_valid),.snapshot_header(snapshot_header),
 .snapshot_prev_progress(snapshot_prev_progress),.snapshot_progress(snapshot_progress),
 .snapshot_prev_accepted(snapshot_prev_accepted),.snapshot_accepted(snapshot_accepted),
 .snapshot_frames(snapshot_frames),.snapshot_events(snapshot_events)
);
'''
edit('top_tf_hdmi_audio.v','player_status_monitor #(.SYS_HZ(25000000),.BUILD_ID(24\'hC11310))',snapshot+'player_status_monitor #(.SYS_HZ(25000000),.BUILD_ID(24\'hC11312))')
edit('top_tf_hdmi_audio.v','.fft_progress(spectrum_debug_progress),.fft_events(spectrum_debug_events),.fft_accepted(spectrum_debug_accepted)', '.fft_progress(spectrum_debug_progress),.fft_events(spectrum_debug_events),.fft_accepted(spectrum_debug_accepted),\n    .snapshot_valid(snapshot_valid),.snapshot_header(snapshot_header),\n    .snapshot_prev_progress(snapshot_prev_progress),.snapshot_progress(snapshot_progress),\n    .snapshot_prev_accepted(snapshot_prev_accepted),.snapshot_accepted(snapshot_accepted),\n    .snapshot_frames(snapshot_frames),.snapshot_events(snapshot_events)')
edit('player_status_monitor.v',"BUILD_ID=24'hC11310","BUILD_ID=24'hC11312")
edit('player_status_monitor.v','    output wire window_toggle_out,','''    input snapshot_valid,
    input [27:0] snapshot_header,
    input [23:0] snapshot_prev_progress,snapshot_progress,snapshot_prev_accepted,snapshot_accepted,snapshot_frames,snapshot_events,
    output wire window_toggle_out,''')
replacements={
"2: hex_value={4'h6,packet_flags,packet_samples};":"2: hex_value={4'h6,snapshot_header};",
"3: hex_value={4'h7,packet_flags,packet_count};":"3: hex_value={4'h7,snapshot_valid,3'b000,snapshot_prev_progress};",
"4: hex_value={4'h8,packet_flags,packet_bad_bch};":"4: hex_value={4'h8,snapshot_valid,3'b000,snapshot_progress};",
"5: hex_value={4'h9,packet_flags,packet_bad_terc};":"5: hex_value={4'h9,snapshot_valid,3'b000,snapshot_prev_accepted};",
"6: hex_value={4'hA,packet_flags,packet_tone_bad};":"6: hex_value={4'hA,snapshot_valid,3'b000,snapshot_accepted};",
"7: hex_value={4'hB,packet_flags,packet_cts};":"7: hex_value={4'hB,snapshot_valid,3'b000,snapshot_frames};",
"8: hex_value={4'hC,packet_flags,packet_n};":"8: hex_value={4'hC,snapshot_valid,3'b000,snapshot_events};"}
for a,b in replacements.items():edit('player_status_monitor.v',a,b)
al=new/'src/td_project/AC201_tf_hdmi.al'
s=al.read_text(encoding='utf-8-sig').replace('player_spectrum_fft_recover','player_spectrum_trace')
s=s.replace('        </Verilog>','''            <File Path="../user_source/hdl_source/player_fault_snapshot.v">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="68"/>
                </FileInfo>
            </File>
        </Verilog>''')
al.write_text(s,encoding='utf-8')
(new/'build').mkdir()
scope={}
for f in (old/'src/user_source').rglob('*'):
    if f.is_file():
        relative=f.relative_to(old/'src/user_source');other=new/'src/user_source'/relative
        if other.is_file() and f.read_bytes()!=other.read_bytes():scope[str(relative)]='modified'
assert len(scope)==4,scope
(new/'build/preparation.json').write_text(json.dumps({'build_id':'C11312','status':'PREPARED_NOT_BUILT','purpose':'passive atomic fault snapshot, not a claimed fix','source':str(old),'changed_source_files':scope,'hardware_operations':False},indent=2),encoding='utf-8')
print(new)
