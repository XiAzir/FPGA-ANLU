`timescale 1ns/1ps

module tb_freeze_waveform;
    reg clk = 1'b0;
    always #5 clk = ~clk;

    reg rst = 1'b1;
    reg vs_main = 1'b0;
    reg de_main = 1'b0;
    reg [23:0] rgb_main = 24'h123456;
    reg valid_main = 1'b0;
    reg [23:0] pcm_main = 24'd0;
    reg tone_main = 1'b0;
    wire [23:0] rgb_out_main;

    reg valid_prod = 1'b0;
    reg [23:0] pcm_prod = 24'd0;
    wire [23:0] rgb_out_prod;

    reg valid_off = 1'b0;
    reg [23:0] pcm_off = 24'd0;
    wire [23:0] rgb_out_off;

    integer checks = 0;
    integer writes_before;
    integer i;
    integer j;
    integer cyan_runs;
    integer cyan_open;
    integer cyan_seen;
    integer line_y;
    integer sample_x = 200;
    reg [13:0] held_front [0:127];
    reg [13:0] held_capture [0:127];
    reg held_display_bank;
    reg held_capture_bank;
    reg [23:0] pixel_sample;

    player_pcm_waveform #(
        .CLK_FREQ_HZ(1000), .SAMPLES_PER_BIN(1), .STALE_MS(10),
        .DIAG_FREEZE_AFTER_SAMPLES(200)
    ) dut (
        .clk(clk), .rst(rst), .vs(vs_main), .de(de_main), .rgb_in(rgb_main),
        .audio_valid(valid_main), .audio_pcm(pcm_main), .tone_mode(tone_main),
        .rgb_out(rgb_out_main)
    );

    // Production-threshold instance: dense events intentionally exercise the
    // counter limit quickly, not a 48 kHz wall-clock or WAV lead-in simulation.
    player_pcm_waveform #(
        .CLK_FREQ_HZ(1000), .SAMPLES_PER_BIN(8), .STALE_MS(10),
        .DIAG_FREEZE_AFTER_SAMPLES(144000)
    ) dut_prod (
        .clk(clk), .rst(rst), .vs(1'b0), .de(1'b0), .rgb_in(24'd0),
        .audio_valid(valid_prod), .audio_pcm(pcm_prod), .tone_mode(1'b0),
        .rgb_out(rgb_out_prod)
    );

    player_pcm_waveform #(
        .CLK_FREQ_HZ(1000), .SAMPLES_PER_BIN(1), .STALE_MS(10),
        .DIAG_FREEZE_AFTER_SAMPLES(0)
    ) dut_off (
        .clk(clk), .rst(rst), .vs(1'b0), .de(1'b0), .rgb_in(24'd0),
        .audio_valid(valid_off), .audio_pcm(pcm_off), .tone_mode(1'b0),
        .rgb_out(rgb_out_off)
    );

    task check;
        input condition;
        input [8*120-1:0] message;
        begin
            checks = checks + 1;
            if (condition !== 1'b1) begin
                $display("FAIL check=%0d: %0s", checks, message);
                $fatal(1);
            end
        end
    endtask

    task send_main;
        input integer code;
        begin
            @(negedge clk);
            valid_main = 1'b1;
            pcm_main = (code - 28) * 65536;
            @(posedge clk); #1;
        end
    endtask

    task send_prod;
        begin
            @(negedge clk);
            valid_prod = 1'b1;
            pcm_prod = 24'h001234;
            @(posedge clk); #1;
        end
    endtask

    task send_off;
        begin
            @(negedge clk);
            valid_off = 1'b1;
            pcm_off = 24'h007700;
            @(posedge clk); #1;
        end
    endtask

    task main_vs_rise;
        begin
            @(negedge clk); vs_main = 1'b1;
            @(posedge clk); #1;
            @(negedge clk); vs_main = 1'b0;
            @(posedge clk); #1;
        end
    endtask

    task snapshot_banks;
        integer b;
        begin
            held_display_bank = dut.display_bank;
            held_capture_bank = dut.capture_bank;
            for (b = 0; b < 128; b = b + 1) begin
                held_front[b] = dut.trace_mem[{held_display_bank, b[6:0]}];
                held_capture[b] = dut.trace_mem[{held_capture_bank, b[6:0]}];
            end
        end
    endtask

    task check_banks_held;
        integer b;
        begin
            check(dut.display_bank === held_display_bank, "display bank changed while frozen");
            check(dut.capture_bank === held_capture_bank, "capture bank changed while frozen");
            for (b = 0; b < 128; b = b + 1) begin
                check(dut.trace_mem[{held_display_bank, b[6:0]}] === held_front[b], "held front RAM entry changed");
                check(dut.trace_mem[{held_capture_bank, b[6:0]}] === held_capture[b], "capture RAM was written while frozen");
            end
        end
    endtask

    task scan_two_frames;
        integer y;
        integer x;
        integer frame;
        begin
            cyan_runs = 0;
            cyan_open = 0;
            cyan_seen = 0;
            for (frame = 0; frame < 2; frame = frame + 1) begin
                main_vs_rise();
                for (y = 0; y < 480; y = y + 1) begin
                    @(negedge clk); de_main = 1'b1;
                    for (x = 1; x <= 640; x = x + 1) begin
                        @(posedge clk); #1;
                        if (x == sample_x) begin
                            pixel_sample = rgb_out_main;
                            if (pixel_sample === 24'h00ffff) begin
                                cyan_seen = cyan_seen + 1;
                                if (!cyan_open) begin
                                    cyan_runs = cyan_runs + 1;
                                    cyan_open = 1;
                                end
                            end else begin
                                cyan_open = 0;
                            end
                        end
                    end
                    @(negedge clk); de_main = 1'b0;
                    @(posedge clk); #1;
                end
            end
            check(cyan_seen > 0, "frozen graph produced no cyan pixels at selected x");
            check(cyan_runs == 2, "selected x did not show one contiguous cyan interval per frame");
        end
    endtask

    task sample_title_pixel;
        input integer x_target;
        input integer y_target;
        output [23:0] value;
        integer y;
        integer x;
        begin
            value = 24'hxxxxxx;
            main_vs_rise();
            for (y = 0; y <= y_target; y = y + 1) begin
                @(negedge clk); de_main = 1'b1;
                for (x = 1; x <= 640; x = x + 1) begin
                    @(posedge clk); #1;
                    if ((y == y_target) && (x == x_target)) value = rgb_out_main;
                end
                @(negedge clk); de_main = 1'b0;
                @(posedge clk); #1;
            end
        end
    endtask

    initial begin
        $display("FREEZE MODEL START: scaled main threshold=200; production threshold=144000 dense events");
        repeat (3) @(posedge clk);
        #1; rst = 1'b0;

        // Build a visibly non-flat window, then reach the threshold exactly on
        // the same edge as VS. The edge priority under review is observable here.
        for (i = 0; i < 128; i = i + 1) begin
            if (i[0]) send_main(48); else send_main(8);
        end
        check(dut.capture_ready === 1'b1, "one complete 128-bin window was not ready");
        for (i = 128; i < 199; i = i + 1) send_main(28);
        check(dut.freeze_sample_count == 199 && !dut.freeze_requested && !dut.frozen_front,
              "scaled count was not live immediately before threshold");
        @(negedge clk); valid_main = 1'b1; pcm_main = 24'h000000; vs_main = 1'b1;
        @(posedge clk); #1;
        check(dut.freeze_sample_count == 199, "VS edge did not coincide with threshold event count");
        check(dut.freeze_requested === 1'b1, "threshold event did not request freeze");
        check(dut.frozen_front === 1'b0, "threshold request froze without a prior registered request");
        check(dut.front_valid === 1'b1, "complete front was not presented at threshold VS");
        check(dut.display_bank === 1'b1, "threshold VS did not swap the completed bank");
        @(negedge clk); vs_main = 1'b0;
        @(posedge clk); #1;

        // The coincident request must be consumed at the next complete-window VS.
        for (i = 0; i < 128; i = i + 1) begin
            if (i[0]) send_main(12); else send_main(44);
        end
        check(dut.capture_ready === 1'b1 && !dut.frozen_front, "second complete window not pending for freeze");
        main_vs_rise();
        check(dut.frozen_front === 1'b1 && dut.capture_active === 1'b0,
              "registered request did not freeze at a complete-window VS");
        check(dut.front_valid === 1'b1, "frozen front is not valid");
        snapshot_banks();

        // Continuous different PCM, several VS edges, then stale/no-sample time.
        for (i = 0; i < 300; i = i + 1) send_main((i % 2) ? 56 : 0);
        repeat (4) main_vs_rise();
        @(negedge clk); valid_main = 1'b0;
        repeat (40) begin @(posedge clk); #1; end
        check_banks_held();
        check(dut.frozen_front === 1'b1 && dut.freeze_requested === 1'b1,
              "frozen flags cleared by continued events or stale interval");

        // Validate the actual raster output: at one fixed x, cyan is one
        // contiguous vertical interval in each of two complete frames.
        scan_two_frames();
        // Frozen WAV title has W at character index 5; W row 0 column 0 is lit.
        sample_title_pixel(105, 328, pixel_sample);
        check(pixel_sample === 24'hffffff, "HOLD WAV X4 title pixel is not lit at expected W glyph location");

        // Source/tone change re-arms the observer and invalidates the old front
        // at VS; freeze the fresh TONE-shaped window on a new threshold.
        @(negedge clk); tone_main = 1'b1; valid_main = 1'b1; pcm_main = 24'h000000;
        @(posedge clk); #1;
        check(!dut.frozen_front && !dut.freeze_requested && dut.freeze_sample_count == 0,
              "tone change did not clear freeze request/count");
        check(dut.invalidate_pending === 1'b1, "non-VS tone change did not schedule old-front invalidation");
        main_vs_rise();
        check(dut.front_valid === 1'b0, "VS did not clear old front after non-VS tone change");
        for (i = 0; i < 200; i = i + 1) send_main(36);
        check(dut.freeze_requested === 1'b1 && !dut.frozen_front, "new tone source did not request at 200 events");
        for (i = 0; i < 128; i = i + 1) send_main((i % 3) ? 42 : 20);
        check(dut.capture_ready === 1'b1, "new tone window failed to complete");
        main_vs_rise();
        check(dut.frozen_front === 1'b1 && dut.frame_tone_mode === 1'b1,
              "new tone window did not freeze with tone title selection");
        sample_title_pixel(107, 328, pixel_sample);
        check(pixel_sample === 24'hffffff, "HOLD TONE X4 title pixel is not lit at expected T glyph location");

        // Reset must release frozen state and permit a new live capture.
        @(negedge clk); rst = 1'b1; valid_main = 1'b0;
        repeat (2) @(posedge clk);
        #1;
        check(!dut.frozen_front && !dut.freeze_requested && dut.freeze_sample_count == 0,
              "reset did not release frozen state");
        @(negedge clk); rst = 1'b0; valid_main = 1'b0;
        tone_main = 1'b0;
        send_main(28);
        check(dut.capture_active === 1'b1, "capture did not resume after reset release");
        for (i = 1; i < 199; i = i + 1) send_main(28);
        check(dut.freeze_sample_count == 199 && !dut.freeze_requested,
              "post-reset threshold setup did not reach 199 events");
        @(negedge clk); tone_main = 1'b1; valid_main = 1'b1; pcm_main = 24'h000000;
        @(posedge clk); #1;
        check(dut.freeze_sample_count == 0 && !dut.freeze_requested && !dut.frozen_front,
              "tone change did not take priority over a same-edge threshold event");
        check(dut.invalidate_pending === 1'b1, "same-edge tone change did not schedule front invalidation");

        // Disabled parameter must never request freeze despite valid samples.
        for (i = 0; i < 260; i = i + 1) send_off();
        check(dut_off.freeze_sample_count === 0 && !dut_off.freeze_requested && !dut_off.frozen_front,
              "DIAG_FREEZE_AFTER_SAMPLES=0 unexpectedly triggered");

        // Production parameter: exact event boundary and counter-width evidence.
        for (i = 0; i < 143999; i = i + 1) send_prod();
        check(dut_prod.freeze_sample_count == 143999 && !dut_prod.freeze_requested,
              "production counter requested before exactly 144000 valid events");
        send_prod();
        check(dut_prod.freeze_sample_count == 143999 && dut_prod.freeze_requested,
              "production counter failed exact 144000-event request boundary");
        check($bits(dut_prod.freeze_sample_count) == $clog2(144001),
              "production freeze counter width does not cover 0..144000");

        $display("PASS checks=%0d; frozen window, bank RAM, raster, title, reset, source switch and threshold boundaries verified", checks);
        $display("LIMIT: dense production events validate event count only; not 48 kHz timing, BRAM primitive, encrypted logic, or monitor behavior");
        $finish;
    end
endmodule
