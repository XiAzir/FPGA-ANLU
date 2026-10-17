from pathlib import Path
import shutil
root=Path(__file__).resolve().parents[1]
old=root/'development/player_spectrum_clock_route';new=root/'development/player_spectrum_fft_recover'
assert not new.exists()
for name in ('src','scripts','sim'):
    shutil.copytree(old/name,new/name,ignore=shutil.ignore_patterns('__pycache__','*.db','*.vvp','AC201_tf_hdmi_Runs'))
for folder in ('scripts','sim'):
    for f in (new/folder).iterdir():
        if f.suffix in ('.ps1','.tcl','.py'):
            f.write_text(f.read_text(encoding='utf-8-sig').replace('player_spectrum_clock_route','player_spectrum_fft_recover'),encoding='utf-8')
f=new/'src/td_project/AC201_tf_hdmi.al'
f.write_text(f.read_text(encoding='utf-8-sig').replace('player_spectrum_clock_route','player_spectrum_fft_recover'),encoding='utf-8')
for name in ('top_tf_hdmi_audio.v','player_status_monitor.v'):
    f=new/'src/user_source/hdl_source'/name
    f.write_text(f.read_text(encoding='utf-8-sig').replace('C11309','C11310'),encoding='utf-8')
(new/'build/audit').mkdir(parents=True)
for f in (old/'build/audit').iterdir():
    if f.suffix in ('.py','.tcl'):
        shutil.copyfile(f,new/'build/audit'/f.name)
f=new/'src/user_source/hdl_source/player_spectrum_analyzer.v'
s=f.read_text(encoding='utf-8-sig')
s=s.replace('output reg         [1:0]  debug_coeff_nonzero','output reg         [1:0]  debug_coeff_nonzero,\n    output wire [23:0] debug_progress, debug_events, debug_accepted')
s=s.replace('    reg [4:0] state;','    (* fsm_encoding = "none" *) reg [4:0] state;')
marker='    // Natural-order input staging RAM'
pos=s.index(marker)
s=s[:pos]+'''    // FFT-local reset: asynchronous assertion and pixel-clock release.
    // Retain binary encoding and the explicit default recovery (SWUG106 4.2.7).
    (* ASYNC_REG="TRUE" *) reg [1:0] reset_pipe=2'b11;
    always @(posedge clk or posedge rst) begin
        if(rst) reset_pipe<=2'b11;
        else reset_pipe<={reset_pipe[0],1'b0};
    end
    wire fft_reset=reset_pipe[1];
    reg [11:0] frame_age_samples;
    reg timeout_pulse;
    reg [7:0] recovery_count,source_change_count;
    reg [23:0] accepted_samples;
    assign debug_progress={state,sample_count,win_index[8:0]};
    assign debug_events={8'd0,recovery_count,source_change_count};
    assign debug_accepted=accepted_samples;
    // A normal frame needs ~1024 capture + <200 compute-time audio pulses.
    // 4096 incoming pulses without completion recover only this analyzer.
    always @(posedge clk or posedge fft_reset) begin
        if(fft_reset) begin
            frame_age_samples<=0;timeout_pulse<=0;recovery_count<=0;
            source_change_count<=0;accepted_samples<=0;
        end else begin
            timeout_pulse<=0;
            if(source_change) begin
                frame_age_samples<=0;accepted_samples<=0;
                if(source_change_count!=8'hff) source_change_count<=source_change_count+1'b1;
            end else begin
                if(sample_write_en && accepted_samples!=24'hffffff)
                    accepted_samples<=accepted_samples+1'b1;
                if(frame_done) frame_age_samples<=0;
                else if(audio_valid) begin
                    if(frame_age_samples==12'd4095) begin
                        frame_age_samples<=0;timeout_pulse<=1;
                        if(recovery_count!=8'hff) recovery_count<=recovery_count+1'b1;
                    end else frame_age_samples<=frame_age_samples+1'b1;
                end
            end
        end
    end

'''+s[pos:]
# Only analyzer control/observations use FFT-local reset; RAM outputs stay reset free.
s=s.replace('always @(posedge clk or posedge rst) begin\n        if (rst) debug_coeff_nonzero', 'always @(posedge clk or posedge fft_reset) begin\n        if (fft_reset) debug_coeff_nonzero')
s=s.replace('wire sample_write_en = (state == ST_CAPTURE) && audio_valid;', 'wire sample_write_en = !fft_reset && !source_change && !timeout_pulse && (state == ST_CAPTURE) && audio_valid;')
s=s.replace('wire work_ram_write_en = (state == ST_WIN_WRITE) ||\n                             (state == ST_FFT_WRITE) ||\n                             (state == ST_FFT_WRITE_B);','wire work_ram_write_en = !fft_reset && !source_change && !timeout_pulse && ((state == ST_WIN_WRITE) ||\n                             (state == ST_FFT_WRITE) ||\n                             (state == ST_FFT_WRITE_B));')
old='    always @(posedge clk) begin\n        if (rst || source_change) begin\n'
start=s.index(old)
end=s.index('        end else begin\n            band_valid',start)
reset_body=s[start+len(old):end]
s=s[:start]+'''    task reset_control;
        begin
'''+reset_body+'''        end
    endtask
    always @(posedge clk or posedge fft_reset) begin
        if (fft_reset) begin
            reset_control();
        end else if (source_change || timeout_pulse) begin
            reset_control();
'''+s[end:]
s=s.replace('default: state <= ST_CAPTURE;','default: begin\n                    reset_control();\n                end')
f.write_text(s,encoding='utf-8')
print(new)

