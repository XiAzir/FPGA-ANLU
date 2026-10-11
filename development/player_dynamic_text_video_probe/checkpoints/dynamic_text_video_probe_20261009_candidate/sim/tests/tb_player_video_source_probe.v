`timescale 1ns/1ps

module tb_player_video_source_probe;
    reg clk = 1'b0;
    reg rst = 1'b1;
    reg key0_n = 1'b1;
    reg key1_n = 1'b1;
    reg vs = 1'b0;
    reg bmp_valid = 1'b0;
    reg [1:0] image_index = 2'bxx;
    reg [23:0] bmp_rgb = 24'h12a5e7;
    reg corner_key0_n = 1'b1;
    reg corner_tone_press = 1'b0;
    reg corner_vs = 1'b0;
    wire key0_active, probe_mode, tone_toggle;
    wire [23:0] rgb_out;
    wire corner_mode;
    wire corner_tone_toggle;
    wire bmp_key_next = key0_n | !key1_n;
    wire bmp_key_auto = key1_n | !key0_n;
    wire tone_press;
    wire bmp_next_press, bmp_auto_press;
    integer tone_events = 0;
    integer next_events = 0;
    integer auto_events = 0;
    integer tone_toggles = 0;

    player_video_source_probe dut (
        .clk(clk), .rst(rst), .key0_n_async(key0_n), .tone_press(tone_press),
        .vs(vs), .bmp_valid(bmp_valid), .image_index(image_index),
        .bmp_rgb(bmp_rgb), .probe_mode(probe_mode), .tone_toggle(tone_toggle),
        .key0_active(key0_active), .rgb_out(rgb_out)
    );
    player_video_source_probe corner_dut (
        .clk(clk), .rst(rst), .key0_n_async(corner_key0_n),
        .tone_press(corner_tone_press), .vs(corner_vs), .bmp_valid(1'b1),
        .image_index(2'd0), .bmp_rgb(24'h123456), .probe_mode(corner_mode),
        .tone_toggle(corner_tone_toggle), .key0_active(), .rgb_out()
    );
    // Production debounce RTL with scaled thresholds: 12 cycles for the long
    // tone gesture, 3 cycles for the BMP key gestures.
    key_press_debounce #(.CLK_FREQ_HZ(1000), .DEBOUNCE_MS(12)) long_key (
        .clk(clk), .rst(rst), .button_in(key1_n), .press_pulse(tone_press)
    );
    key_press_debounce #(.CLK_FREQ_HZ(1000), .DEBOUNCE_MS(3)) bmp_next_key (
        .clk(clk), .rst(rst), .button_in(bmp_key_next), .press_pulse(bmp_next_press)
    );
    key_press_debounce #(.CLK_FREQ_HZ(1000), .DEBOUNCE_MS(3)) bmp_auto_key (
        .clk(clk), .rst(rst), .button_in(bmp_key_auto), .press_pulse(bmp_auto_press)
    );

    always #5 clk = ~clk;
    always @(posedge clk) begin
        #1;
        if (!rst) begin
            if (tone_press) tone_events = tone_events + 1;
            if (tone_toggle) tone_toggles = tone_toggles + 1;
            if (bmp_next_press) next_events = next_events + 1;
            if (bmp_auto_press) auto_events = auto_events + 1;
        end
    end

    task automatic ticks(input integer count);
        integer i;
        begin for (i=0;i<count;i=i+1) @(posedge clk); #2; end
    endtask
    task automatic release_keys;
        begin
            @(negedge clk); key0_n=1; key1_n=1;
            ticks(18);
        end
    endtask
    task automatic pulse_vs;
        begin
            @(negedge clk); vs=1;
            ticks(3);
            @(negedge clk); vs=0;
            ticks(3);
        end
    endtask
    task automatic check_color(input [1:0] idx, input [23:0] expected);
        begin
            image_index=idx; #1;
            if (rgb_out !== expected)
                $fatal(1, "probe color index=%0d expected=%06h got=%06h", idx, expected, rgb_out);
        end
    endtask

    integer n0, na, nn, nt;
    initial begin
        ticks(3); @(negedge clk); rst=0; ticks(4);
        image_index=0; #1;
        if (probe_mode !== 1'b0) $fatal(1, "reset mode must be BMP");
        if (rgb_out !== 24'h000000) $fatal(1, "invalid BMP must preserve first-frame black");
        bmp_valid=1; #1;
        if (rgb_out !== bmp_rgb) $fatal(1, "BMP source did not pass through");

        // Two requests with the second coincident with VS must cancel by
        // parity, proving that same-edge request handling loses neither event.
        @(negedge clk); corner_key0_n=0; ticks(4);
        @(negedge clk); corner_tone_press=1; ticks(1);
        @(negedge clk); corner_tone_press=0; ticks(2);
        if (corner_dut.pending_toggle !== 1'b1 || corner_mode !== 1'b0)
            $fatal(1, "first corner request did not become pending");
        @(negedge clk); corner_tone_press=1; corner_vs=1; ticks(1);
        if (corner_mode !== 1'b0 || corner_dut.pending_toggle !== 1'b0)
            $fatal(1, "simultaneous pending/request VS parity failed");
        @(negedge clk); corner_tone_press=0; corner_vs=0; corner_key0_n=1; ticks(4);

        // A raw KEY0 edge simultaneous with tone_press has not traversed the
        // two-flop synchronizer: the old synchronized value is high, so it is
        // classified as tone and cannot queue a video switch.
        @(negedge clk); corner_key0_n=0; corner_tone_press=1;
        ticks(1);
        if (!corner_tone_toggle || corner_dut.pending_toggle !== 1'b0)
            $fatal(1, "unsynchronized KEY0 edge did not use prior high sample");
        @(negedge clk); corner_tone_press=0; ticks(4);
        if (corner_mode !== 1'b0) $fatal(1, "unsynchronized KEY0 edge queued a mode change");

        // Once KEY0 is synchronized low, an event coincident with the raw
        // release still sees the old synchronized low value and queues one
        // frame-boundary change, while tone remains gated.
        @(negedge clk); corner_tone_press=1; corner_key0_n=1;
        ticks(1);
        if (corner_tone_toggle || corner_dut.pending_toggle !== 1'b1)
            $fatal(1, "KEY0 release edge did not use prior low synchronized sample");
        @(negedge clk); corner_tone_press=0; ticks(2);
        if (corner_mode !== 1'b0) $fatal(1, "release-edge request bypassed VS");
        @(negedge clk); corner_vs=1; ticks(3);
        if (corner_mode !== 1'b1) $fatal(1, "release-edge request missed VS");
        @(negedge clk); corner_vs=0; corner_key0_n=1; ticks(2);

        // Short KEY0 alone may deliver one manual-next event through the
        // existing 50 ms debounce; it must not trigger tone or probe mode.
        n0=next_events; na=auto_events;
        @(negedge clk); key0_n=0; ticks(7);
        if (!key0_active || probe_mode || tone_events || tone_toggles || next_events != n0+1 || auto_events != na)
            $fatal(1, "short KEY0 gesture mismatch");
        release_keys();

        // Short KEY1/long-key input remains the ordinary BMP auto gesture,
        // below the long tone threshold, with no source/tone change.
        na=auto_events; nt=tone_events; n0=tone_toggles;
        @(negedge clk); key1_n=0; ticks(7);
        if (auto_events != na+1 || tone_events != nt || tone_toggles != n0 || probe_mode)
            $fatal(1, "short KEY1 did not remain BMP-only");
        release_keys();

        // Long KEY1 alone must toggle tone exactly once and leave video in BMP.
        na=auto_events; nt=tone_events; n0=tone_toggles;
        @(negedge clk); key1_n=0; ticks(20);
        if (tone_events != nt+1 || tone_toggles != n0+1 || auto_events != na+1 || probe_mode)
            $fatal(1, "long KEY1 alone did not produce exactly one tone toggle");
        release_keys();

        // Hold KEY0 first, then long KEY1. BMP buttons are masked, tone is
        // not toggled, and the probe source changes only at VS rising.
        na=auto_events; nt=tone_events; n0=tone_toggles;
        @(negedge clk); key0_n=0; ticks(5);
        if (!key0_active) $fatal(1, "KEY0 did not synchronize before long gesture");
        nn=next_events; // a KEY0-only manual step may already have completed
        @(negedge clk); key1_n=0; ticks(20);
        if (tone_events != nt+1 || tone_toggles != n0 || auto_events != na || next_events != nn) begin
            $display("chord counts tone=%0d/%0d toggles=%0d/%0d auto=%0d/%0d next=%0d",tone_events,nt,tone_toggles,n0,auto_events,na,next_events);
            $fatal(1, "chord toggled tone or leaked into BMP buttons");
        end
        if (probe_mode !== 1'b0) $fatal(1, "probe source changed before VS rising");
        pulse_vs();
        if (probe_mode !== 1'b1) $fatal(1, "pending source change missed VS rising");
        // Held VS cannot apply the same request twice; pending has been cleared.
        @(negedge clk); vs=1; ticks(4);
        if (!probe_mode) $fatal(1, "held VS repeated source toggle");
        @(negedge clk); vs=0; ticks(3);
        release_keys();

        check_color(2'd0,24'hffffff);
        check_color(2'd1,24'h808080);
        check_color(2'd2,24'hff0000);
        check_color(2'd3,24'h00ff00);
        bmp_valid=0; #1;
        check_color(2'd2,24'hff0000);

        // Re-arm after release and perform another complete chord. It returns
        // to BMP on the next frame, with no extra tone or BMP event.
        nt=tone_events; n0=tone_toggles; na=auto_events;
        @(negedge clk); key0_n=0; ticks(5);
        @(negedge clk); key1_n=0; ticks(20);
        if (tone_events != nt+1 || tone_toggles != n0 || auto_events != na)
            $fatal(1, "re-armed chord event counts are wrong");
        if (!probe_mode) $fatal(1, "second toggle occurred before frame boundary");
        pulse_vs();
        if (probe_mode !== 1'b0) $fatal(1, "second VS toggle did not restore BMP mode");
        release_keys();

        // Reset while probe mode is active must return to BMP/black.
        @(negedge clk); key0_n=0; ticks(5);
        @(negedge clk); key1_n=0; ticks(20);
        if (probe_mode) $fatal(1, "third source change occurred before VS");
        pulse_vs();
        if (!probe_mode) $fatal(1, "third source change did not latch at VS");
        release_keys();
        @(negedge clk); bmp_valid=0; rst=1; vs=0; ticks(3);
        @(negedge clk); rst=0; ticks(3);
        if (probe_mode !== 1'b0 || rgb_out !== 24'h000000)
            $fatal(1, "reset did not restore BMP/black output");
        $display("PASS source probe: short KEY0, short/long KEY1, chord mask, one-shot tone, VS-boundary toggles, release/rearm, reset/BMP black, BMP passthrough, and four 24-bit colors");
        $finish;
    end
endmodule
