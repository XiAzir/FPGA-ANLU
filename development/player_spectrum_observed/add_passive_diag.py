from pathlib import Path

p=Path(__file__).resolve().parent
hdl=p/'src/user_source/hdl_source'
f=hdl/'player_spectrum_analyzer.v'
s=f.read_text(encoding='utf-8-sig')
s=s.replace('output reg                frame_done','output reg                frame_done,\n    output reg         [1:0]  debug_coeff_nonzero')
probe='''    // Passive coefficient observations; never drive FFT or playback control.
    always @(posedge clk or posedge rst) begin
        if (rst) debug_coeff_nonzero <= 2'b00;
        else if (source_change) debug_coeff_nonzero <= 2'b00;
        else begin
            if (state == ST_WIN_MUL && hann_q != 0) debug_coeff_nonzero[1] <= 1'b1;
            if (state == ST_FFT_M0 && twiddle_q != 0) debug_coeff_nonzero[0] <= 1'b1;
        end
    end

'''
s=s.replace('    function [9:0] bit_reverse10;',probe+'    function [9:0] bit_reverse10;')
f.write_text(s,encoding='utf-8')
f=hdl/'player_pcm_waveform.v';s=f.read_text(encoding='utf-8-sig')
s=s.replace('input wire freeze_toggle, output reg [23:0] rgb_out','input wire freeze_toggle, output reg [23:0] rgb_out,\n    output reg [23:0] spectrum_debug_frames, output wire [23:0] spectrum_debug_data')
s=s.replace('    wire [15:0] band_value;', '    wire [15:0] band_value;\n    wire [1:0] debug_coeff_nonzero;')
s=s.replace('.band_value(band_value),.frame_done(frame_done)', '.band_value(band_value),.frame_done(frame_done),.debug_coeff_nonzero(debug_coeff_nonzero)')
diag='''    // Page B: completed FFT frames, reset on source change. Page C:
    // {PCM seen, frame seen, nonzero band seen, Hann nonzero, twiddle nonzero,
    //  front commit seen, nonzero front seen, frozen front, last frame max[15:0]}.
    reg diag_pcm_seen,diag_frame_seen,diag_band_seen,diag_commit_seen,diag_front_seen;
    reg [15:0] diag_work_max,diag_last_max;
    wire [23:0] diag_front_nonzero;
    genvar diag_j;
    generate for(diag_j=0;diag_j<24;diag_j=diag_j+1) begin: g_diag_front
        assign diag_front_nonzero[diag_j]=|display_height[diag_j];
    end endgenerate
    wire [15:0] diag_final_max=(band_index==0)?band_value:
                                 ((band_value>diag_work_max)?band_value:diag_work_max);
    assign spectrum_debug_data={diag_pcm_seen,diag_frame_seen,diag_band_seen,
        debug_coeff_nonzero,diag_commit_seen,diag_front_seen,frozen_front,diag_last_max};
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            spectrum_debug_frames<=0;diag_pcm_seen<=0;diag_frame_seen<=0;
            diag_band_seen<=0;diag_commit_seen<=0;diag_front_seen<=0;
            diag_work_max<=0;diag_last_max<=0;
        end else if(source_change) begin
            spectrum_debug_frames<=0;diag_pcm_seen<=0;diag_frame_seen<=0;
            diag_band_seen<=0;diag_commit_seen<=0;diag_front_seen<=0;
            diag_work_max<=0;diag_last_max<=0;
        end else begin
            if(audio_valid) diag_pcm_seen<=1;
            if(update_done) diag_commit_seen<=1;
            if(|diag_front_nonzero) diag_front_seen<=1;
            if(band_valid) begin
                diag_work_max<=diag_final_max;
                if(band_value!=0) diag_band_seen<=1;
                if(frame_done) diag_last_max<=diag_final_max;
            end
            if(frame_done) begin
                diag_frame_seen<=1;
                if(spectrum_debug_frames!=24'hffffff)
                    spectrum_debug_frames<=spectrum_debug_frames+1'b1;
            end
        end
    end

'''
s=s.replace('    reg [9:0] x_pos;',diag+'    reg [9:0] x_pos;')
f.write_text(s,encoding='utf-8')
f=hdl/'top_tf_hdmi_audio.v';s=f.read_text(encoding='utf-8-sig')
s=s.replace('// Passive observer of the exact PCM/VALID buses presented to the HDMI core.', 'wire [23:0] spectrum_debug_frames,spectrum_debug_data;\n// Passive observer of the exact PCM/VALID buses presented to the HDMI core.')
s=s.replace(' .rgb_out(vout_data)\n);',' .rgb_out(vout_data),.spectrum_debug_frames(spectrum_debug_frames),\n .spectrum_debug_data(spectrum_debug_data)\n);')
s=s.replace('assign packet_cts=prefix_high_pos;','// B/C retain display transport only; now observe actual spectrum hardware.\nassign packet_cts=spectrum_debug_frames;')
s=s.replace('assign packet_n=prefix_data_offset;','assign packet_n=spectrum_debug_data;')
f.write_text(s,encoding='utf-8')
print('Passive B/C spectrum telemetry added, no path to audio/TF/HDMI control')
