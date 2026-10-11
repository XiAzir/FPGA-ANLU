`timescale 1ns/1ps
module tb_axis_protocol_fix_audit;
    reg clk = 1'b0;
    reg rst = 1'b1;
    reg axis_rst = 1'b1;
    always #20 clk = ~clk;

    wire timing_hs, timing_vs, timing_de;
    wire hs, vs, de;
    wire [23:0] rgb;
    wire read_req;
    wire orig_user, orig_valid, orig_last;
    wire [23:0] orig_data;
    wire fix_user, fix_valid, fix_last;
    wire [23:0] fix_data;

    video_timing_data u_timing (
        .video_clk(clk), .rst(rst), .read_req(read_req),
        .read_req_ack(1'b0), .hs(timing_hs), .vs(timing_vs), .de(timing_de)
    );
    video_delay u_delay (
        .video_clk(clk), .rst(rst), .read_en(), .read_data(24'h123456),
        .hs(timing_hs), .vs(timing_vs), .de(timing_de),
        .hs_r(hs), .vs_r(vs), .de_r(de), .vout_data(rgb)
    );
    video_rgb_to_axis_640x480_old u_original (
        .I_clk(clk), .I_rst(axis_rst), .I_vs(vs), .I_de(de), .I_rgb(rgb),
        .O_video_user(orig_user), .O_video_valid(orig_valid),
        .O_video_last(orig_last), .O_video_data(orig_data)
    );
    video_rgb_to_axis_640x480 u_fixed (
        .I_clk(clk), .I_rst(axis_rst), .I_vs(vs), .I_de(de), .I_rgb(rgb),
        .O_video_user(fix_user), .O_video_valid(fix_valid),
        .O_video_last(fix_last), .O_video_data(fix_data)
    );

    integer full_done = 0;
    integer full_valid_pixels = 0;
    integer full_orig_last_count = 0;
    integer full_fix_last_count = 0;
    integer full_sof_count = 0;
    integer full_line_count = 0;
    integer full_line_len = 0;
    integer full_x = -1;
    integer full_prev_de = 0;
    reg full_prev_vs = 1'b0;
    integer full_sof_arm = 1;
    reg sample_de, sample_vs;
    reg [23:0] sample_rgb;
    integer exp_user;
    integer fail_count = 0;

    // Sample the actual converter inputs before the active edge, then inspect
    // registered outputs after NBA updates. The line oracle counts real DE
    // beats from video_timing_data + video_delay; it does not clone S_x_cnt.
    always @(posedge clk) begin
        if (axis_rst) begin
            full_prev_de = 0;
            full_prev_vs = 1'b0;
            full_sof_arm = 1;
            full_line_len = 0;
            full_x = -1;
            #1;
            if (orig_valid || orig_last || orig_user || fix_valid || fix_last || fix_user) begin
                $display("FAIL full-chain reset outputs not clear");
                fail_count = fail_count + 1;
            end
        end else begin
            sample_de = de;
            sample_vs = vs;
            sample_rgb = rgb;
            exp_user = (sample_de && !full_prev_de && full_sof_arm) ? 1 : 0;
            #1;
            if (orig_valid !== sample_de || fix_valid !== sample_de) begin
                $display("FAIL valid latency orig=%b fix=%b sampled_de=%b t=%0t", orig_valid, fix_valid, sample_de, $time);
                fail_count = fail_count + 1;
            end
            if (orig_data !== sample_rgb || fix_data !== sample_rgb) begin
                $display("FAIL data latency orig=%06x fix=%06x sampled_rgb=%06x t=%0t", orig_data, fix_data, sample_rgb, $time);
                fail_count = fail_count + 1;
            end
            if (orig_user !== exp_user || fix_user !== exp_user) begin
                $display("FAIL SOF latency orig=%b fix=%b expected=%0d de=%b prev_de=%0d vs=%b prev_vs=%b arm=%0d t=%0t timing_de=%b video_de_d0=%b video_de_d1=%b delay_de=%b delay_pipe=%b", orig_user, fix_user, exp_user, sample_de, full_prev_de, sample_vs, full_prev_vs, full_sof_arm, $time, timing_de, u_timing.video_de_d0, u_timing.video_de_d1, de, u_delay.de_d);
                fail_count = fail_count + 1;
            end
            if (!sample_de && (orig_last || orig_user || fix_last || fix_user)) begin
                $display("FAIL last/user asserted during blank t=%0t", $time);
                fail_count = fail_count + 1;
            end

            if (sample_de) begin
                full_valid_pixels = full_valid_pixels + 1;
                if (!full_prev_de) begin
                    full_line_len = 1;
                    full_x = 0;
                    if (exp_user) begin
                        if ((full_line_count != 0) && (full_line_count != 480)) begin
                            $display("FAIL SOF at line=%0d (expected frame row 0 or 480)", full_line_count);
                            fail_count = fail_count + 1;
                        end
                        full_sof_count = full_sof_count + 1;
                    end
                end else begin
                    full_line_len = full_line_len + 1;
                    full_x = full_x + 1;
                end
                if (orig_last !== 1'b0) begin
                    $display("FAIL original unexpectedly asserted TLAST x=%0d line=%0d", full_x, full_line_count);
                    fail_count = fail_count + 1;
                end
                if (fix_last !== (full_x == 639)) begin
                    $display("FAIL fixed TLAST x=%0d got=%b expected=%b line=%0d", full_x, fix_last, (full_x == 639), full_line_count);
                    fail_count = fail_count + 1;
                end
                if (orig_last) full_orig_last_count = full_orig_last_count + 1;
                if (fix_last) full_fix_last_count = full_fix_last_count + 1;
            end else if (full_prev_de) begin
                if (full_line_len != 640) begin
                    $display("FAIL actual DE row %0d width=%0d", full_line_count, full_line_len);
                    fail_count = fail_count + 1;
                end
                full_line_count = full_line_count + 1;
                full_line_len = 0;
                full_x = -1;
                if (full_line_count == 960) begin
                    full_done = 1;
                    $display("FULL SUMMARY lines=%0d pixels=%0d orig_last=%0d fixed_last=%0d sof=%0d failures=%0d", full_line_count, full_valid_pixels, full_orig_last_count, full_fix_last_count, full_sof_count, fail_count);
                end
            end

            // Match the converter's VS-edge arming semantics without copying
            // its pixel counter: an edge arms SOF, while a consumed row start
            // clears the old arm. The actual source keeps VS changes in blank.
            if (sample_vs != full_prev_vs)
                full_sof_arm = 1;
            if (sample_de && !full_prev_de && exp_user)
                full_sof_arm = 0;
            full_prev_vs = sample_vs;
            full_prev_de = sample_de;
        end
    end

    reg dir_rst = 1'b1;
    reg dir_vs = 1'b0;
    reg dir_de = 1'b0;
    reg [23:0] dir_rgb = 24'h0;
    wire dir_user, dir_valid, dir_last;
    wire [23:0] dir_data;
    integer dir_prev_de = 0;
    reg dir_prev_vs = 1'b0;
    integer dir_sof_arm = 1;
    integer dir_line_len = 0;
    integer dir_x = -1;
    integer dir_last_count = 0;
    integer dir_sof_count = 0;
    integer dir_done = 0;
    reg dir_sample_vs, dir_sample_de;
    reg [23:0] dir_sample_rgb;
    integer dir_expected_user;
    integer dir_active_beats = 0;

    video_rgb_to_axis_640x480 u_fixed_direct (
        .I_clk(clk), .I_rst(dir_rst), .I_vs(dir_vs), .I_de(dir_de), .I_rgb(dir_rgb),
        .O_video_user(dir_user), .O_video_valid(dir_valid),
        .O_video_last(dir_last), .O_video_data(dir_data)
    );

    // Independent behavioral oracle for directed short-row/reset cases.
    always @(posedge clk) begin
        if (dir_rst) begin
            dir_prev_de = 0;
            dir_prev_vs = 1'b0;
            dir_sof_arm = 1;
            dir_line_len = 0;
            dir_x = -1;
            #1;
            if (dir_valid || dir_last || dir_user || dir_data !== 24'd0) begin
                $display("FAIL directed async/sync reset outputs not clear at %0t", $time);
                fail_count = fail_count + 1;
            end
        end else begin
            dir_sample_de = dir_de;
            dir_sample_vs = dir_vs;
            dir_sample_rgb = dir_rgb;
            dir_expected_user = (dir_sample_de && !dir_prev_de && dir_sof_arm) ? 1 : 0;
            #1;
            if (dir_valid !== dir_sample_de || dir_data !== dir_sample_rgb) begin
                $display("FAIL directed valid/data latency valid=%b de=%b data=%06x expected=%06x", dir_valid, dir_sample_de, dir_data, dir_sample_rgb);
                fail_count = fail_count + 1;
            end
            if (dir_user !== dir_expected_user) begin
                $display("FAIL directed SOF got=%b expected=%0d", dir_user, dir_expected_user);
                fail_count = fail_count + 1;
            end
            if (!dir_sample_de && (dir_last || dir_user)) begin
                $display("FAIL directed last/user during blank");
                fail_count = fail_count + 1;
            end
            if (dir_sample_de) begin
                dir_active_beats = dir_active_beats + 1;
                if (!dir_prev_de) begin
                    dir_line_len = 1;
                    dir_x = 0;
                    if (dir_expected_user) dir_sof_count = dir_sof_count + 1;
                end else begin
                    dir_line_len = dir_line_len + 1;
                    dir_x = dir_x + 1;
                end
                if (dir_last !== (dir_x == 639)) begin
                    $display("FAIL directed TLAST x=%0d got=%b expected=%b", dir_x, dir_last, (dir_x == 639));
                    fail_count = fail_count + 1;
                end
                if (dir_last) dir_last_count = dir_last_count + 1;
            end else begin
                dir_line_len = 0;
                dir_x = -1;
            end
            if (dir_sample_vs != dir_prev_vs) dir_sof_arm = 1;
            if (dir_sample_de && !dir_prev_de && dir_expected_user) dir_sof_arm = 0;
            dir_prev_vs = dir_sample_vs;
            dir_prev_de = dir_sample_de;
        end
    end

    task automatic drive_direct(input reg v, input reg d, input reg [23:0] pix);
        begin
            @(negedge clk);
            dir_vs = v;
            dir_de = d;
            dir_rgb = pix;
            @(posedge clk);
            #2;
        end
    endtask

    integer i;
    initial begin : directed_tests
        // First test a 639-beat line: it must never emit TLAST.
        repeat (5) @(posedge clk);
        @(negedge clk);
        dir_rst = 1'b0;
        for (i = 0; i < 639; i = i + 1)
            drive_direct(1'b0, 1'b1, i[23:0]);
        drive_direct(1'b0, 1'b0, 24'h0);
        if (dir_last_count != 0) $fatal(1, "short 639-pixel row emitted TLAST");
        $display("DIRECT short-row PASS: 639 valid beats produced no TLAST");
        for (i = 0; i < 640; i = i + 1)
            drive_direct(1'b0, 1'b1, (24'h080000 + i));
        drive_direct(1'b0, 1'b0, 24'h0);
        if (dir_last_count != 1) $fatal(1, "row-start restart after short row TLAST count=%0d expected=1", dir_last_count);
        $display("DIRECT row-start PASS: next 640-beat row restarted count and emitted one TLAST");

        // Interrupt a partial row with asynchronous reset, then start a clean row.
        for (i = 0; i < 300; i = i + 1)
            drive_direct(1'b0, 1'b1, (24'h100000 + i));
        @(negedge clk);
        dir_rst = 1'b1;
        #1;
        if (dir_valid || dir_last || dir_user || dir_data !== 24'd0)
            $fatal(1, "asynchronous reset did not clear direct outputs immediately");
        repeat (2) @(posedge clk);
        @(negedge clk);
        dir_de = 1'b0;
        dir_vs = 1'b0;
        dir_rst = 1'b0;
        for (i = 0; i < 640; i = i + 1)
            drive_direct(1'b0, 1'b1, (24'h200000 + i));
        drive_direct(1'b0, 1'b0, 24'h0);
        if (dir_last_count != 2) $fatal(1, "post-reset clean row total TLAST count=%0d expected=2", dir_last_count);
        $display("DIRECT reset-restart PASS: 300-beat partial row aborted; clean post-reset 640-beat row emitted one additional TLAST");

        // The original policy arms SOF on either VS polarity transition.
        drive_direct(1'b1, 1'b0, 24'h0);
        for (i = 0; i < 640; i = i + 1)
            drive_direct(1'b1, 1'b1, (24'h300000 + i));
        drive_direct(1'b1, 1'b0, 24'h0);
        drive_direct(1'b0, 1'b0, 24'h0);
        for (i = 0; i < 640; i = i + 1)
            drive_direct(1'b0, 1'b1, (24'h400000 + i));
        drive_direct(1'b0, 1'b0, 24'h0);
        if (dir_sof_count != 4) $fatal(1, "VS-edge SOF count=%0d expected=4", dir_sof_count);
        if (dir_last_count != 4) $fatal(1, "directed TLAST count=%0d expected=4", dir_last_count);
        dir_done = 1;
        $display("DIRECT VS-edge PASS: both rising and falling VS transitions re-armed SOF");
    end

    initial begin : full_chain_test
        repeat (10) @(posedge clk);
        @(negedge clk);
        rst = 1'b0;
        repeat (40) @(posedge clk);
        @(negedge clk);
        axis_rst = 1'b0;
        wait (full_done && dir_done);
        #2;
        if (fail_count != 0) $fatal(1, "full/direct protocol oracle failures=%0d", fail_count);
        if (full_line_count != 960 || full_valid_pixels != 614400) $fatal(1, "full dimensions mismatch lines=%0d pixels=%0d", full_line_count, full_valid_pixels);
        if (full_orig_last_count != 0 || full_fix_last_count != 960) $fatal(1, "TLAST comparison mismatch original=%0d fixed=%0d", full_orig_last_count, full_fix_last_count);
        if (full_sof_count != 2) $fatal(1, "SOF count=%0d expected=2", full_sof_count);
        $display("PASS: 2 actual frames, 960 lines, 614400 pixels; original TLAST=0, fixed TLAST=960; SOF=2; data/valid latency=1");
        $finish;
    end

    initial begin
        #50000000;
        $fatal(1, "TIMEOUT full_lines=%0d full_pixels=%0d dir_done=%0d", full_line_count, full_valid_pixels, dir_done);
    end
endmodule



