// Passive observer: never drives the video/audio/PHY data paths.
// Half-rate elapsed counter deliberately differs from the producer's second
// counter. It measures time BETWEEN mailbox toggles, not a presumed second.
module player_cadence_probe #(
    parameter integer GAP_MIN = 520,
    parameter integer GAP_MAX = 521
)(
    input wire clk, rst, audio_valid, tone_mode, valid, user,
    input wire window_toggle, locked,
    input wire [9:0] tmds_clock_word,
    output wire [3:0] flags,
    output wire [23:0] audio_gap_range,
    output wire [23:0] bad_gap_frame_samples,
    output reg [23:0] window_half_cycles,
    output reg [23:0] frame_period,
    output reg [23:0] window_audio_samples,
    output wire [23:0] clock_word_errors,
    output wire [23:0] build_id
);
    reg prev_mode, prev_window, half_phase;
    reg audio_seen, window_seen, frame_seen;
    reg [11:0] gap_ticks, shortest_gap, longest_gap, bad_gaps;
    reg [11:0] frame_audio, last_frame_audio;
    reg [23:0] half_ticks, frame_ticks;
    reg [15:0] window_audio;
    reg [13:0] clock_bad;
    reg [9:0] clock_last;
    wire window_event = window_toggle != prev_window;
    wire frame_event = valid && user;
    wire [11:0] gap_now = (&gap_ticks) ? 12'hfff : gap_ticks + 12'd1;
    wire [23:0] half_now = half_phase && !(&half_ticks) ? half_ticks + 24'd1 : half_ticks;
    wire [15:0] audio_now = audio_valid && !(&window_audio) ? window_audio + 16'd1 : window_audio;
    wire [23:0] period_now = (&frame_ticks) ? 24'hffffff : frame_ticks + 24'd1;
    assign flags = {tone_mode, locked, audio_seen, window_seen};
    assign audio_gap_range = {shortest_gap, longest_gap};
    assign bad_gap_frame_samples = {bad_gaps, last_frame_audio};
    assign clock_word_errors = {clock_bad, clock_last};
    assign build_id = 24'hC10902;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            prev_mode<=0; prev_window<=0; half_phase<=0;
            audio_seen<=0; window_seen<=0; frame_seen<=0;
            gap_ticks<=0; shortest_gap<=12'hfff; longest_gap<=0; bad_gaps<=0;
            frame_audio<=0; last_frame_audio<=0;
            half_ticks<=0; frame_ticks<=0; window_audio<=0;
            window_half_cycles<=0; frame_period<=0; window_audio_samples<=0;
            clock_bad<=0; clock_last<=0;
        end else begin
            prev_mode<=tone_mode;
            prev_window<=window_toggle;
            half_phase<=~half_phase;
            clock_last<=tmds_clock_word;
            if (locked && tmds_clock_word!=10'h3e0 && tmds_clock_word!=10'h01f && !(&clock_bad))
                clock_bad<=clock_bad+14'd1;

            // Skip the interval spanning a source switch; restart the gap
            // history for the newly selected source.
            if (tone_mode!=prev_mode) begin
                audio_seen<=0; gap_ticks<=0;
                shortest_gap<=12'hfff; longest_gap<=0; bad_gaps<=0;
            end else if (audio_valid) begin
                audio_seen<=1;
                gap_ticks<=0;
                if (audio_seen) begin
                    if (gap_now<shortest_gap) shortest_gap<=gap_now;
                    if (gap_now>longest_gap) longest_gap<=gap_now;
                    if ((gap_now<GAP_MIN || gap_now>GAP_MAX) && !(&bad_gaps))
                        bad_gaps<=bad_gaps+12'd1;
                end
            end else if (audio_seen) gap_ticks<=gap_now;

            if (frame_event) begin
                if (frame_seen) begin
                    frame_period<=period_now;
                    last_frame_audio<=frame_audio;
                end
                frame_seen<=1;
                frame_ticks<=0;
                frame_audio<=audio_valid ? 12'd1 : 12'd0;
            end else begin
                if (frame_seen) begin
                    frame_ticks<=period_now;
                    if (audio_valid && !(&frame_audio)) frame_audio<=frame_audio+12'd1;
                end
            end

            if (window_event) begin
                if (window_seen) begin
                    window_half_cycles<=half_now;
                    window_audio_samples<={8'd0,audio_now};
                end
                window_seen<=1;
                half_ticks<=0;
                window_audio<=0;
            end else begin
                if (window_seen) begin
                    half_ticks<=half_now;
                    window_audio<=audio_now;
                end
            end
        end
    end
endmodule
