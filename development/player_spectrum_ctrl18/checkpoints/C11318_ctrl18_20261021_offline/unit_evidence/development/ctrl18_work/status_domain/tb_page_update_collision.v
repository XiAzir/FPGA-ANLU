`timescale 1ns/1ps
module tb_page_update_collision;
    reg video_clk = 0;
    reg monitor_rst = 1;
    reg display_rst = 1;
    wire [31:0] status_hex;
    wire seg7_dio, seg7_sclk, seg7_rclk;
    wire frame_start;
    integer hex_changes = 0;
    integer frame_starts = 0;
    integer changes_at_start = 0;
    reg [31:0] last_status_hex = 0;
    reg [31:0] frame_start_value = 0;

    initial begin
        #20;
        forever #20 video_clk = ~video_clk;
    end

    player_status_monitor #(
        .PIXEL_HZ(4), .SYS_HZ(2), .PAGE_SECONDS(1),
        .SHOW_SELF_TEST(1), .BUILD_ID(24'hC11317)
    ) u_status_monitor (
        .pixel_clk(video_clk), .sys_clk(video_clk), .rst(monitor_rst), .sys_rst(monitor_rst),
        .axis_rgb(24'd0), .axis_valid(1'b0), .axis_user(1'b0), .hdmi_locked(1'b0),
        .audio_valid(1'b0), .tone_mode(1'b0), .underflow(1'b0), .audio_pcm(24'd0),
        .startup_flags(4'b0101), .file_flags(8'hA5), .fs_code(8'h23), .wav_map_code(8'h45),
        .packet_samples(24'd0), .packet_count(24'd0), .packet_bad_bch(24'd0),
        .packet_bad_terc(24'd0), .packet_tone_bad(24'd0), .packet_cts(24'd0), .packet_n(24'd0),
        .packet_flags(4'd0), .bmp_diag(27'd0), .sd_crc_diag(32'd0),
        .fft_progress(24'h123456), .fft_events(24'h89ABCD), .fft_accepted(24'hFEDCBA),
        .snapshot_valid(1'b1), .snapshot_header(28'h1234567),
        .snapshot_prev_progress(24'h102030), .snapshot_progress(24'h405060),
        .snapshot_prev_accepted(24'h708090), .snapshot_accepted(24'hA0B0C0),
        .snapshot_frames(24'hD0E0F0), .snapshot_events(24'h0F1E2D),
        .window_toggle_out(), .hex_value(status_hex), .cw_count_data(), .cw_count_trigger()
    );

    status_hex595 #(.CLK_HZ(25000000), .SCAN_HZ(1000)) u_candidate_595 (
        .clk(video_clk), .rst(display_rst), .hex_value(status_hex),
        .seg7_dio(seg7_dio), .seg7_sclk(seg7_sclk), .seg7_rclk(seg7_rclk)
    );

    assign frame_start =
        (u_candidate_595.state == 3'd0) &&
        (u_candidate_595.slot_count >= u_candidate_595.SLOT_CYCLES - 1) &&
        (u_candidate_595.digit_index == 3'd0);

    status_word_checker #(.ID(2)) u_candidate_check (
        .clk(video_clk), .rst(display_rst), .dio(seg7_dio), .sclk(seg7_sclk), .rclk(seg7_rclk),
        .hex_value(status_hex), .frame_start(frame_start),
        .frame_count(), .digit3_events(), .frame_value_0(), .frame_value_1(), .last_frame_value(),
        .min_high_ns(), .max_high_ns(), .min_low_ns(), .max_low_ns(), .min_setup_ns(),
        .max_rise_period_ns(), .min_rise_period_ns(), .min_rclk_high_ns(), .max_rclk_high_ns(),
        .min_blank_data_ns(), .max_blank_data_ns(), .min_blank_slot_ns(), .max_blank_slot_ns(),
        .min_frame_period_ns(), .max_frame_period_ns()
    );

    always @(status_hex) begin
        if (!monitor_rst && ((^status_hex) !== 1'bx)) begin
            if (status_hex !== last_status_hex) begin
                hex_changes = hex_changes + 1;
                last_status_hex = status_hex;
            end
        end
    end

    always @(posedge video_clk) begin
        if (!display_rst && frame_start) begin
            frame_starts = frame_starts + 1;
            frame_start_value = status_hex;
            changes_at_start = hex_changes;
        end
    end

    initial begin
        // Release the monitor first. The first page/self-test transition occurs
        // on a falling edge; release the display after page_count reaches one,
        // so the next falling-edge update lands immediately before digit-zero
        // frame_value capture on the following rising edge.
        #101 monitor_rst = 0;
        wait (u_status_monitor.page_count == 1);
        @(posedge video_clk);
        #1 display_rst = 0;

        wait (u_candidate_check.frame_count >= 1);
        #1;
        if (frame_starts == 0 || frame_start_value !== 32'h88888888)
            $fatal(1, "page change was not aligned before digit-zero snapshot: starts=%0d value=%08h",
                frame_starts, frame_start_value);
        if (u_candidate_check.frame_value_0 !== frame_start_value)
            $fatal(1, "digit-zero frame snapshot differs from monitor page at its boundary");
        if (hex_changes - changes_at_start < 100)
            $fatal(1, "too few page value changes occurred during the eight-digit scan: %0d",
                hex_changes - changes_at_start);

        u_candidate_check.report();
        $display("PASS tb_page_update_collision frame=%08h page_changes_during_frame=%0d starts=%0d",
            u_candidate_check.frame_value_0, hex_changes - changes_at_start, frame_starts);
        $finish;
    end

    initial begin
        #20000000;
        $fatal(1, "tb_page_update_collision timeout");
    end
endmodule
