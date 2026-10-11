`timescale 1ns/1ps

module tb_audio_rate;
    localparam integer PIXEL_HZ = 25000000;

    reg clk = 1'b0;
    always #20 clk = ~clk;

    reg audio_rst = 1'b1;
    reg monitor_rst = 1'b1;
    reg tone_toggle = 1'b0;
    wire tone_mode;
    wire probe_valid;
    wire [23:0] probe_left, probe_right;
    wire probe_underflow, sample_take;
    wire acr_valid;
    wire [19:0] acr_cts, acr_n;
    wire [3:0] led;

    player_audio_probe #(.PIXEL_HZ(PIXEL_HZ), .SAMPLE_HZ(48000)) audio_probe (
        .pixel_clk(clk), .sd_clk(clk), .rst(audio_rst), .tone_toggle(tone_toggle),
        .primed(1'b0), .sample_available(1'b0), .sample_data(16'd0),
        .sample_take(sample_take), .underflow(probe_underflow),
        .audio_valid(probe_valid), .audio_left(probe_left), .audio_right(probe_right),
        .acr_valid(acr_valid), .acr_cts(acr_cts), .acr_n(acr_n), .led(led),
        .tone_mode(tone_mode)
    );

    wire tone_valid;
    wire [23:0] tone_left, tone_right;
    hdmi_audio_tone_pcm_scale #(
        .CLK_FREQ_HZ(PIXEL_HZ), .SAMPLE_RATE_HZ(48000), .AMP(24'sd1000000)
    ) tone_reference (
        .I_clk(clk), .I_rst(audio_rst), .O_audio_valid(tone_valid),
        .O_audio_left_data(tone_left), .O_audio_right_data(tone_right)
    );

    wire [31:0] hex_value;
    player_status_monitor #(
        .PIXEL_HZ(PIXEL_HZ), .SYS_HZ(PIXEL_HZ), .PAGE_SECONDS(2),
        .SHOW_SELF_TEST(0)
    ) status_monitor (
        .pixel_clk(clk), .sys_clk(clk), .rst(monitor_rst), .sys_rst(monitor_rst),
        .axis_rgb(24'd0), .axis_valid(1'b0), .axis_user(1'b0), .hdmi_locked(1'b1),
        .audio_valid(probe_valid), .tone_mode(tone_mode), .underflow(probe_underflow),
        .audio_pcm(probe_left), .startup_flags(4'd0), .file_flags(8'd0),
        .fs_code(8'd0), .wav_map_code(8'd0), .packet_samples(24'd0),
        .packet_count(24'd0), .packet_bad_bch(24'd0), .packet_bad_terc(24'd0),
        .packet_tone_bad(24'd0), .packet_cts(24'd0), .packet_n(24'd0),
        .packet_flags(4'd0), .hex_value(hex_value)
    );

    integer window_edges = 0;
    integer probe_count = 0;
    integer tone_count = 0;
    integer completed_windows = 0;
    integer expected_probe [0:1];
    integer expected_tone [0:1];

    // Independent 25,000,000-edge windows. Count the pre-edge valid values,
    // matching the input samples visible to the monitor on each clock edge.
    always @(posedge clk) begin
        if (monitor_rst) begin
            window_edges <= 0;
            probe_count <= 0;
            tone_count <= 0;
            completed_windows <= 0;
        end else if (completed_windows < 2) begin
            if (window_edges == PIXEL_HZ-1) begin
                expected_probe[completed_windows] <= probe_count + (probe_valid ? 1 : 0);
                expected_tone[completed_windows] <= tone_count + (tone_valid ? 1 : 0);
                completed_windows <= completed_windows + 1;
                window_edges <= 0;
                probe_count <= 0;
                tone_count <= 0;
            end else begin
                window_edges <= window_edges + 1;
                if (probe_valid) probe_count <= probe_count + 1;
                if (tone_valid) tone_count <= tone_count + 1;
            end
        end
    end

    integer i;
    initial begin
        expected_probe[0] = -1; expected_probe[1] = -1;
        expected_tone[0] = -1; expected_tone[1] = -1;
        repeat (5) @(negedge clk);
        audio_rst = 1'b0;
        tone_toggle = 1'b1;
        @(negedge clk);
        tone_toggle = 1'b0;
        repeat (8) @(negedge clk);
        if (!tone_mode) $fatal(1, "tone_mode did not enter tone mode");

        monitor_rst = 1'b0;
        for (i = 0; i < 2; i = i + 1) begin
            wait (completed_windows == i + 1);
            repeat (5) @(negedge clk);
            $display("WINDOW %0d edges=%0d tone_valid=%0d probe_valid=%0d mailbox=%0d tone_mode=%0b underflow=%0b",
                i+1, PIXEL_HZ, expected_tone[i], expected_probe[i],
                status_monitor.received[23:0], status_monitor.received[27],
                status_monitor.received[26]);
            if (expected_tone[i] != 48000) $fatal(1, "reference tone count mismatch");
            if (expected_probe[i] != expected_tone[i]) $fatal(1, "probe mux changed tone valid count");
            if (status_monitor.received[23:0] != expected_probe[i]) $fatal(1, "mailbox differs from independent valid count");
            if (status_monitor.received[27] != 1'b1) $fatal(1, "mailbox did not capture tone mode");
        end

        $display("PASS: two real 25 MHz windows matched tone source, player_audio_probe output, and status mailbox.");
        $finish;
    end
endmodule
