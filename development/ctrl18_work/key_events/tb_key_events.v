`timescale 1ns/1ps

module tb_key_events;
    reg src_clk = 1'b0;
    reg dst_clk = 1'b0;
    always #5 src_clk = ~src_clk;
    always #7 dst_clk = ~dst_clk;

    reg rst = 1'b1;
    reg vs = 1'b0;
    reg key0_n = 1'b1;
    reg key1_n = 1'b1;

    wire ref_next_n, ref_auto_n, ref_tone, ref_wave;
    wire [1:0] ref_mode;
    wire [3:0] ref_brightness;
    wire [2:0] ref_contrast;
    wire cand_next_req, cand_auto_req, cand_tone, cand_wave;
    wire cand_next_ack, cand_auto_ack, cand_next_press, cand_auto_press;
    wire [1:0] cand_mode;
    wire [3:0] cand_brightness;
    wire [2:0] cand_contrast;
    wire ref_next_press, ref_auto_press;

    reg manual_next_req = 1'b0;
    reg manual_auto_req = 1'b0;
    wire manual_next_ack, manual_auto_ack;
    wire manual_next_press, manual_auto_press;

    integer ref_next_count = 0;
    integer ref_auto_count = 0;
    integer cand_next_count = 0;
    integer cand_auto_count = 0;
    integer ref_tone_count = 0;
    integer cand_tone_count = 0;
    integer ref_wave_count = 0;
    integer cand_wave_count = 0;
    integer ref_order_count = 0;
    integer cand_order_count = 0;
    integer ref_order [0:31];
    integer cand_order [0:31];
    integer i;
    integer checks = 0;
    integer width_cycles = 0;
    integer saw_ref_low = 0;
    integer saw_ref_high = 0;
    integer manual_both_seen = 0;
    integer pre_reset_ref_next = 0;
    integer pre_reset_ref_auto = 0;
    integer pre_reset_cand_next = 0;
    integer pre_reset_cand_auto = 0;
    integer ref_source_event_count = 0;
    integer cand_source_event_count = 0;
    time ref_source_event_time [0:15];
    time cand_source_event_time [0:15];
    time ref_first_accept_time = 0;
    time cand_first_accept_time = 0;
    time ref_first_low_time = 0;
    time cand_first_req_time = 0;
    reg ref_low_seen = 1'b0;
    reg ref_high_seen = 1'b0;
    reg cand_req_seen = 1'b0;
    reg manual_both_seen_d = 1'b0;
    reg prev_ref_next_n = 1'b1;
    reg prev_ref_auto_n = 1'b1;
    reg prev_cand_next_req = 1'b0;

    legacy_player_adjust_control #(
        .CLK_FREQ_HZ(1000), .DEBOUNCE_MS(3), .HOLD_MS(20),
        .PULSE_MS(100), .LEGACY_GAP_MS(100)
    ) reference_dut (
        .clk(src_clk), .rst(rst), .vs(vs), .key0_n(key0_n), .key1_n(key1_n),
        .next_n(ref_next_n), .auto_n(ref_auto_n), .tone_press(ref_tone),
        .mode(ref_mode), .brightness_index(ref_brightness), .contrast_index(ref_contrast),
        .waveform_toggle(ref_wave)
    );

    player_adjust_control #(
        .CLK_FREQ_HZ(1000), .DEBOUNCE_MS(3), .HOLD_MS(20),
        .PULSE_MS(100), .LEGACY_GAP_MS(100)
    ) candidate_dut (
        .clk(src_clk), .rst(rst), .vs(vs), .key0_n(key0_n), .key1_n(key1_n),
        .next_req_toggle(cand_next_req), .next_ack_async(cand_next_ack),
        .auto_req_toggle(cand_auto_req), .auto_ack_async(cand_auto_ack),
        .tone_press(cand_tone), .waveform_toggle(cand_wave), .mode(cand_mode),
        .brightness_index(cand_brightness), .contrast_index(cand_contrast)
    );

    key_event_mailbox_sink candidate_sink (
        .clk(dst_clk), .rst(rst),
        .next_req_toggle(cand_next_req), .next_ack_toggle(cand_next_ack), .next_press(cand_next_press),
        .auto_req_toggle(cand_auto_req), .auto_ack_toggle(cand_auto_ack), .auto_press(cand_auto_press)
    );

    key_press_debounce #(.CLK_FREQ_HZ(1000), .DEBOUNCE_MS(50)) reference_next_debounce (
        .clk(dst_clk), .rst(rst), .button_in(ref_next_n), .press_pulse(ref_next_press)
    );
    key_press_debounce #(.CLK_FREQ_HZ(1000), .DEBOUNCE_MS(50)) reference_auto_debounce (
        .clk(dst_clk), .rst(rst), .button_in(ref_auto_n), .press_pulse(ref_auto_press)
    );

    key_event_mailbox_sink simultaneous_sink (
        .clk(dst_clk), .rst(rst),
        .next_req_toggle(manual_next_req), .next_ack_toggle(manual_next_ack), .next_press(manual_next_press),
        .auto_req_toggle(manual_auto_req), .auto_ack_toggle(manual_auto_ack), .auto_press(manual_auto_press)
    );

    always @(posedge src_clk) begin
        if (!rst) begin
            if (ref_tone) ref_tone_count = ref_tone_count + 1;
            if (cand_tone) cand_tone_count = cand_tone_count + 1;
            if (ref_wave) ref_wave_count = ref_wave_count + 1;
            if (cand_wave) cand_wave_count = cand_wave_count + 1;
        end
    end

    always @(negedge src_clk) begin
        if (!rst) begin
            if (!ref_next_n && !ref_low_seen) begin
                ref_low_seen = 1'b1;
                ref_first_low_time = $time;
            end
            if (prev_ref_next_n && !ref_next_n) begin
                ref_source_event_time[ref_source_event_count] = $time;
                ref_source_event_count = ref_source_event_count + 1;
            end
            if (ref_next_n && ref_low_seen) begin
                ref_high_seen = 1'b1;
                ref_low_seen = 1'b0;
            end
            if (cand_next_req != prev_cand_next_req && !cand_req_seen) begin
                cand_req_seen = 1'b1;
                cand_first_req_time = $time;
            end
            if (cand_next_req != prev_cand_next_req) begin
                cand_source_event_time[cand_source_event_count] = $time;
                cand_source_event_count = cand_source_event_count + 1;
            end
            prev_cand_next_req = cand_next_req;
            prev_ref_next_n = ref_next_n;
            prev_ref_auto_n = ref_auto_n;
        end else begin
            prev_ref_next_n = ref_next_n;
            prev_ref_auto_n = ref_auto_n;
            prev_cand_next_req = cand_next_req;
        end
    end

    always @(posedge dst_clk) begin
        if (!rst) begin
            if (ref_next_press) begin
                if (ref_next_count == 0) ref_first_accept_time = $time;
                ref_next_count = ref_next_count + 1;
                ref_order[ref_order_count] = 0;
                ref_order_count = ref_order_count + 1;
            end
            if (ref_auto_press) begin
                ref_auto_count = ref_auto_count + 1;
                ref_order[ref_order_count] = 1;
                ref_order_count = ref_order_count + 1;
            end
            if (cand_next_press) begin
                if (cand_next_count == 0) cand_first_accept_time = $time;
                cand_next_count = cand_next_count + 1;
                cand_order[cand_order_count] = 0;
                cand_order_count = cand_order_count + 1;
            end
            if (cand_auto_press) begin
                cand_auto_count = cand_auto_count + 1;
                cand_order[cand_order_count] = 1;
                cand_order_count = cand_order_count + 1;
            end
            if (manual_next_press && manual_auto_press) manual_both_seen = 1;
        end
    end

    task tick_source;
        input integer n;
        integer j;
        begin for (j = 0; j < n; j = j + 1) @(posedge src_clk); #1; end
    endtask

    task tick_dest;
        input integer n;
        integer j;
        begin for (j = 0; j < n; j = j + 1) @(posedge dst_clk); #1; end
    endtask

    task tick_both;
        input integer source_cycles;
        input integer destination_cycles;
        begin tick_source(source_cycles); tick_dest(destination_cycles); end
    endtask

    task short0;
        begin key0_n = 1'b0; tick_source(8); key0_n = 1'b1; tick_source(8); end
    endtask

    task short1;
        begin key1_n = 1'b0; tick_source(8); key1_n = 1'b1; tick_source(8); end
    endtask

    task check;
        input condition;
        input [8*112-1:0] label_text;
        begin
            checks = checks + 1;
            if (condition !== 1'b1) begin
                $display("FAIL %0s at %0t", label_text, $time);
                $fatal(1);
            end
        end
    endtask

    task check_control_state;
        input [8*112-1:0] label_text;
        begin
            check(ref_mode === cand_mode, {label_text, " mode"});
            check(ref_brightness === cand_brightness, {label_text, " brightness"});
            check(ref_contrast === cand_contrast, {label_text, " contrast"});
            check(ref_tone_count == cand_tone_count, {label_text, " tone events"});
            check(ref_wave_count == cand_wave_count, {label_text, " waveform events"});
        end
    endtask

    task compare_event_logs;
        integer j;
        begin
            check(ref_next_count == cand_next_count, "next event count matches legacy receiver");
            check(ref_auto_count == cand_auto_count, "auto event count matches legacy receiver");
            check(ref_order_count == cand_order_count, "total event count matches");
            for (j = 0; j < ref_order_count; j = j + 1)
                check(ref_order[j] == cand_order[j], "cross-button event order matches");
        end
    endtask

    initial begin
        tick_both(4, 4); rst = 1'b0; tick_both(5, 5);
        check(cand_mode == 0 && cand_brightness == 4 && cand_contrast == 2, "reset defaults");
        check(candidate_dut.EVENT_INTERVAL_CYCLES == 200 &&
              candidate_dut.EVENT_W == 8, "one source-domain 200-cycle cooldown replaces two 100-cycle counters");

        // A one-cycle bounce never passes the unchanged physical-key debounce.
        key0_n = 1'b0; tick_source(1); key0_n = 1'b1; tick_source(12); tick_dest(20);
        check(ref_next_count == 0 && cand_next_count == 0, "short bounce rejected by both versions");

        // One immediate next event, followed by two taps in the same 200 ms
        // window: both implementations emit one queued event, coalescing the third tap.
        short0;
        tick_source(8); short0; tick_source(8); short0;
        tick_both(240, 120);
        check(ref_next_count == 2 && cand_next_count == 2, "three next taps coalesce to two events");
        check(ref_first_low_time != 0 && cand_first_req_time != 0, "first source event observed in both implementations");
        check(ref_source_event_count == 2 && cand_source_event_count == 2,
              "two source-side events match after three rapid taps");
        check(ref_source_event_time[0] == cand_source_event_time[0] &&
              ref_source_event_time[1] == cand_source_event_time[1],
              "first and coalesced source events preserve exact cycle and order");
        $display("SOURCE_TIMING ref0=%0t ref1=%0t cand0=%0t cand1=%0t interval=%0t", ref_source_event_time[0], ref_source_event_time[1], cand_source_event_time[0], cand_source_event_time[1], (ref_source_event_time[1]-ref_source_event_time[0]));
        check(ref_source_event_time[1] - ref_source_event_time[0] == 2010,
              "combined cooldown dispatches the queued event after the legacy 201 source cycles");
        check(ref_first_accept_time > cand_first_accept_time, "event mailbox removes the legacy 50 ms input debounce delay");
        check((ref_first_accept_time - cand_first_accept_time) >= 560 &&
              (ref_first_accept_time - cand_first_accept_time) <= 900,
              "measured first-event response gain is 40 to 65 destination clocks in this asynchronous model");

        // Auto events use their own cooldown and mailbox. An auto event arrives
        // between a next request and that key's one-deep queued follow-up.
        short0; tick_source(28); short1; tick_both(230, 120);
        check(ref_next_count == 3 && cand_next_count == 3, "next lane accepts the queued follow-up once");
        check(ref_auto_count == 1 && cand_auto_count == 1, "auto lane remains independent from next lane");
        compare_event_logs;

        key0_n = 1'b0; key1_n = 1'b0; tick_source(8);
        key0_n = 1'b1; tick_source(6); key1_n = 1'b1; tick_source(8);
        check_control_state("play-mode short chord emits one waveform toggle");
        check(cand_wave_count == 1, "short chord waveform action is retained");
        check(ref_next_count == 3 && cand_next_count == 3 && ref_auto_count == 1 && cand_auto_count == 1,
              "short chord suppresses both event lanes");

        key0_n = 1'b0; key1_n = 1'b0; tick_source(14);
        key0_n = 1'b1; tick_source(6); key0_n = 1'b0; tick_source(12);
        check_control_state("interrupted chord restarts continuous hold timing");
        check(cand_mode == 0 && cand_tone_count == 0, "interrupted chord stays below long action");
        key0_n = 1'b1; key1_n = 1'b1; tick_source(8);

        // Long, chord, edit, saturation, and release-rearm behavior stays identical.
        key0_n = 1'b0; tick_source(28);
        check_control_state("KEY0 long enters brightness once");
        check(cand_mode == 1, "KEY0 long changes mode without a short next event");
        key0_n = 1'b1; tick_source(8);
        short1; vs = 1'b1; tick_source(2); vs = 1'b0; tick_source(2);
        check_control_state("brightness short edit and VS commit");
        check(cand_brightness == 5, "brightness increment commits on VS");

        // The second key joins just before KEY1's long threshold; the chord
        // wins, matching the reference's same-edge priority.
        key1_n = 1'b0;
        while (!reference_dut.key1_pressed) tick_source(1);
        while (reference_dut.key1_hold_count < 14) tick_source(1);
        key0_n = 1'b0;
        while (!reference_dut.key0_pressed) tick_source(1);
        tick_source(3);
        check_control_state("near-threshold chord priority");
        check(cand_mode == 1 && cand_tone_count == 0, "chord suppresses impending single-key long actions");
        key0_n = 1'b1; key1_n = 1'b1; tick_source(8);

        key0_n = 1'b0; key1_n = 1'b0; tick_source(8);
        key0_n = 1'b1; tick_source(6); key1_n = 1'b1; tick_source(8);
        check_control_state("short chord suppresses both release taps");

        // Long chord resets adjustment defaults. A subsequent KEY1 long emits
        // one tone and does not create an auto event.
        key0_n = 1'b0; key1_n = 1'b0; tick_source(30);
        check_control_state("long chord resets adjustment state");
        check(cand_mode == 0, "long chord returns to play mode");
        key0_n = 1'b1; key1_n = 1'b1; tick_source(8);
        key1_n = 1'b0; tick_source(28);
        check_control_state("KEY1 long produces one tone");
        check(cand_tone_count == 1 && cand_auto_req == 1'b1, "KEY1 long does not toggle auto");
        key1_n = 1'b1; tick_source(8);

        // The sink accepts independent toggles together and returns both acks;
        // the loader's existing next-then-auto statements retain same-cycle order.
        @(negedge dst_clk); manual_next_req = 1'b1; manual_auto_req = 1'b1;
        tick_dest(5);
        check(manual_both_seen && manual_next_ack && manual_auto_ack,
              "same-cycle cross-button requests are accepted independently");
        @(negedge dst_clk); manual_next_req = 1'b0; manual_auto_req = 1'b0;
        tick_dest(5);
        check(manual_next_ack == 1'b0 && manual_auto_ack == 1'b0,
              "both toggled requests complete a second handshake");

        // Reset cancels pending coalesced work in both implementations.
        pre_reset_ref_next = ref_next_count; pre_reset_ref_auto = ref_auto_count;
        pre_reset_cand_next = cand_next_count; pre_reset_cand_auto = cand_auto_count;
        $display("PRE_RESET_COUNTS ref(next=%0d auto=%0d) candidate(next=%0d auto=%0d)",
                 pre_reset_ref_next, pre_reset_ref_auto, pre_reset_cand_next, pre_reset_cand_auto);
        short0; tick_source(8); short0;
        rst = 1'b1; key0_n = 1'b1; key1_n = 1'b1;
        tick_both(4, 4);
        ref_next_count = 0; ref_auto_count = 0; cand_next_count = 0; cand_auto_count = 0;
        ref_order_count = 0; cand_order_count = 0;
        ref_first_accept_time = 0; cand_first_accept_time = 0;
        rst = 1'b0; tick_both(220, 120);
        check(ref_next_count == 0 && cand_next_count == 0,
              "reset clears the current request and one-deep pending event");
        check(cand_next_req == 1'b0 && cand_next_ack == 1'b0,
              "reset returns the request/ack mailbox to the same toggle state");
        short0; tick_both(80, 80);
        check(ref_next_count == 1 && cand_next_count == 1, "new event works after reset");
        compare_event_logs;

        $display("PASS tb_key_events checks=%0d pre_reset_ref(next=%0d auto=%0d) pre_reset_candidate(next=%0d auto=%0d) post_reset_ref(next=%0d) post_reset_candidate(next=%0d) first_accept_gain=%0t", checks, pre_reset_ref_next, pre_reset_ref_auto, pre_reset_cand_next, pre_reset_cand_auto, ref_next_count, cand_next_count, (ref_first_accept_time-cand_first_accept_time));
        $finish;
    end

    initial begin #20000000; $fatal(1, "tb_key_events timeout"); end
endmodule

module key_press_debounce #(
    parameter integer CLK_FREQ_HZ = 100_000_000,
    parameter integer DEBOUNCE_MS = 20
)(
    input wire clk,
    input wire rst,
    input wire button_in,
    output reg press_pulse
);
localparam integer DEBOUNCE_CYCLES = (CLK_FREQ_HZ / 1000) * DEBOUNCE_MS;
reg button_sync0;
reg button_sync1;
reg button_stable;
reg [31:0] cnt;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        button_sync0<=1'b1; button_sync1<=1'b1; button_stable<=1'b1;
        cnt<=32'd0; press_pulse<=1'b0;
    end else begin
        button_sync0<=button_in; button_sync1<=button_sync0; press_pulse<=1'b0;
        if(button_sync1==button_stable) cnt<=32'd0;
        else if(cnt>=DEBOUNCE_CYCLES-1) begin
            if(button_stable && !button_sync1) press_pulse<=1'b1;
            button_stable<=button_sync1; cnt<=32'd0;
        end else cnt<=cnt+1'b1;
    end
end
endmodule
