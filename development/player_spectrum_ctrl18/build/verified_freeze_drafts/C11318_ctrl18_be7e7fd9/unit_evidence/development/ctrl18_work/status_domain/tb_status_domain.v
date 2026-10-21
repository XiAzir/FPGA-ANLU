`timescale 1ns/1ps
module tb_status_domain;
    parameter integer PHASE_NS = 0;

    reg video_clk = 0;
    reg sys_clk = 0;
    reg rst = 1;
    reg [31:0] status_hex = 32'h01234567;
    wire [31:0] status_hex_system;
    wire candidate_dio, candidate_sclk, candidate_rclk;
    wire legacy_dio, legacy_sclk, legacy_rclk;

    initial begin
        #20;
        forever #20 video_clk = ~video_clk;
    end
    initial begin
        #(10 + PHASE_NS);
        forever #10 sys_clk = ~sys_clk;
    end

    player_status_mailbox u_legacy_mailbox (
        .source_clk(video_clk),
        .destination_clk(sys_clk),
        .rst(rst),
        .source_hex(status_hex),
        .destination_hex(status_hex_system)
    );

    status_hex595 #(.CLK_HZ(50000000), .SCAN_HZ(1000)) u_legacy_595 (
        .clk(sys_clk), .rst(rst), .hex_value(status_hex_system),
        .seg7_dio(legacy_dio), .seg7_sclk(legacy_sclk), .seg7_rclk(legacy_rclk)
    );

    status_hex595 #(.CLK_HZ(25000000), .SCAN_HZ(1000)) u_candidate_595 (
        .clk(video_clk), .rst(rst), .hex_value(status_hex),
        .seg7_dio(candidate_dio), .seg7_sclk(candidate_sclk), .seg7_rclk(candidate_rclk)
    );

    wire legacy_frame_start =
        (u_legacy_595.state == 3'd0) &&
        (u_legacy_595.slot_count >= u_legacy_595.SLOT_CYCLES - 1) &&
        (u_legacy_595.digit_index == 3'd0);
    wire candidate_frame_start =
        (u_candidate_595.state == 3'd0) &&
        (u_candidate_595.slot_count >= u_candidate_595.SLOT_CYCLES - 1) &&
        (u_candidate_595.digit_index == 3'd0);

    status_word_checker #(.ID(0)) u_legacy_check (
        .clk(sys_clk), .rst(rst), .dio(legacy_dio), .sclk(legacy_sclk), .rclk(legacy_rclk),
        .hex_value(status_hex_system), .frame_start(legacy_frame_start),
        .frame_count(), .digit3_events(), .frame_value_0(), .frame_value_1(), .last_frame_value(),
        .min_high_ns(), .max_high_ns(), .min_low_ns(), .max_low_ns(), .min_setup_ns(),
        .max_rise_period_ns(), .min_rise_period_ns(), .min_rclk_high_ns(), .max_rclk_high_ns(),
        .min_blank_data_ns(), .max_blank_data_ns(), .min_blank_slot_ns(), .max_blank_slot_ns(),
        .min_frame_period_ns(), .max_frame_period_ns()
    );

    status_word_checker #(.ID(1)) u_candidate_check (
        .clk(video_clk), .rst(rst), .dio(candidate_dio), .sclk(candidate_sclk), .rclk(candidate_rclk),
        .hex_value(status_hex), .frame_start(candidate_frame_start),
        .frame_count(), .digit3_events(), .frame_value_0(), .frame_value_1(), .last_frame_value(),
        .min_high_ns(), .max_high_ns(), .min_low_ns(), .max_low_ns(), .min_setup_ns(),
        .max_rise_period_ns(), .min_rise_period_ns(), .min_rclk_high_ns(), .max_rclk_high_ns(),
        .min_blank_data_ns(), .max_blank_data_ns(), .min_blank_slot_ns(), .max_blank_slot_ns(),
        .min_frame_period_ns(), .max_frame_period_ns()
    );

    // The checker outputs used for directed assertions and measured timing.
    wire [31:0] legacy_value0, legacy_value1, legacy_last_value;
    wire [31:0] candidate_value0, candidate_value1, candidate_last_value;
    integer legacy_frames, candidate_frames;
    integer legacy_digit3, candidate_digit3;
    integer legacy_high_min, legacy_high_max, legacy_low_min, legacy_low_max;
    integer legacy_setup_min, legacy_period_min, legacy_period_max;
    integer legacy_latch_min, legacy_latch_max, legacy_blank_data_min, legacy_blank_data_max;
    integer legacy_slot_min, legacy_slot_max;
    integer candidate_high_min, candidate_high_max, candidate_low_min, candidate_low_max;
    integer candidate_setup_min, candidate_period_min, candidate_period_max;
    integer candidate_latch_min, candidate_latch_max, candidate_blank_data_min, candidate_blank_data_max;
    integer candidate_slot_min, candidate_slot_max;

    // Hierarchical checker aliases keep the test assertions readable.
    always @* begin
        legacy_frames = u_legacy_check.frame_count;
        candidate_frames = u_candidate_check.frame_count;
        legacy_digit3 = u_legacy_check.digit3_events;
        candidate_digit3 = u_candidate_check.digit3_events;
    end

    initial begin
        #113 rst = 0;

        // Change the 32-bit bus after digit 3 is visible. The remaining digits
        // of this scan must still come from its digit-zero frame snapshot.
        wait (u_candidate_check.digit3_events >= 1);
        @(negedge video_clk);
        status_hex = 32'h89ABCDEF;

        wait (candidate_frames >= 2 && legacy_frames >= 2);
        #1;
        if (u_candidate_check.frame_value_0 !== 32'h01234567)
            $fatal(1, "candidate frame zero did not preserve 01234567");
        if (u_candidate_check.frame_value_1 !== 32'h89ABCDEF)
            $fatal(1, "candidate frame one did not update to 89ABCDEF");
        if (u_legacy_check.frame_value_1 !== 32'h89ABCDEF)
            $fatal(1, "legacy mailbox did not deliver 89ABCDEF atomically");

        // Assert reset between serial edges while SCLK is high, then check the
        // asynchronous output reset and a clean restart with the new frame.
        @(posedge candidate_sclk);
        #1 rst = 1;
        #2;
        if (candidate_sclk !== 1'b0 || candidate_rclk !== 1'b0 || candidate_dio !== 1'b1)
            $fatal(1, "candidate pins did not take their reset values");
        if (legacy_sclk !== 1'b0 || legacy_rclk !== 1'b0 || legacy_dio !== 1'b1)
            $fatal(1, "legacy pins did not take their reset values");
        #51 rst = 0;

        wait (candidate_frames >= 3 && legacy_frames >= 4);
        #1;
        if (u_candidate_check.last_frame_value !== 32'h89ABCDEF)
            $fatal(1, "candidate did not restart from the current frame after reset");
        if (u_legacy_check.last_frame_value !== 32'h89ABCDEF)
            $fatal(1, "legacy mailbox did not recover after reset");

        // These values are measured from the unchanged 6-state transmitter.
        // The source formula gives HALF_DIV=25 at 50 MHz and 13 at 25 MHz.
        if (u_legacy_check.min_high_ns != 500 || u_legacy_check.min_low_ns != 520)
            $fatal(1, "legacy serial pulse measurements differ from the 50 MHz baseline");
        if (u_candidate_check.min_high_ns != 520 || u_candidate_check.min_low_ns != 560)
            $fatal(1, "candidate serial pulse measurements differ from the 25 MHz candidate");
        if (u_legacy_check.min_setup_ns < 500 || u_candidate_check.min_setup_ns < 500)
            $fatal(1, "DIO setup interval narrowed below the baseline minimum");
        if (u_legacy_check.min_rclk_high_ns != 20 || u_candidate_check.min_rclk_high_ns != 40)
            $fatal(1, "RCLK high pulse widths differ from expected clock-cycle widths");
        if (u_legacy_check.min_blank_slot_ns != 1032720 ||
            u_candidate_check.min_blank_slot_ns != 1034720)
            $fatal(1, "measured per-digit blank-to-blank intervals changed");
        if (u_legacy_check.min_frame_period_ns != 8261760 ||
            u_candidate_check.min_frame_period_ns != 8277760)
            $fatal(1, "measured eight-digit frame periods changed");
        if (u_candidate_check.min_high_ns < u_legacy_check.min_high_ns ||
            u_candidate_check.min_low_ns < u_legacy_check.min_low_ns ||
            u_candidate_check.min_setup_ns < u_legacy_check.min_setup_ns ||
            u_candidate_check.min_rclk_high_ns < u_legacy_check.min_rclk_high_ns)
            $fatal(1, "candidate 74HC595-facing pulse/setup windows narrowed relative to baseline");

        u_legacy_check.report();
        u_candidate_check.report();
        $display("PASS tb_status_domain phase_ns=%0d patterns=01234567/89ABCDEF reset=async_mid_sclk frames=%0d/%0d",
            PHASE_NS, legacy_frames, candidate_frames);
        $finish;
    end

    initial begin
        #50000000;
        $fatal(1, "tb_status_domain timeout phase_ns=%0d", PHASE_NS);
    end
endmodule
