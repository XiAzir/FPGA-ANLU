`timescale 1ns/1ps
module tb_waveform_chord_control;
    reg clk = 1'b0;
    always #5 clk = ~clk;
    reg rst = 1'b1;
    reg key0_n = 1'b1;
    reg key1_n = 1'b1;
    wire next_n, auto_n, tone_press, waveform_toggle;
    wire [1:0] mode;
    wire [3:0] brightness_index;
    wire [2:0] contrast_index;
    integer waveform_count = 0;
    reg waveform_was_high = 1'b0;

    player_adjust_control #(
        .CLK_FREQ_HZ(1000), .DEBOUNCE_MS(3), .HOLD_MS(20),
        .PULSE_MS(100), .LEGACY_GAP_MS(100)
    ) dut (
        .clk(clk), .rst(rst), .vs(1'b0), .key0_n(key0_n), .key1_n(key1_n),
        .next_n(next_n), .auto_n(auto_n), .tone_press(tone_press),
        .waveform_toggle(waveform_toggle), .mode(mode),
        .brightness_index(brightness_index), .contrast_index(contrast_index)
    );

    always @(posedge clk) begin
        if (waveform_toggle) begin
            waveform_count = waveform_count + 1;
            if (waveform_was_high) begin
                $display("FAIL: waveform_toggle lasted more than one cycle");
                $fatal(1);
            end
        end
        waveform_was_high = waveform_toggle;
    end

    task tick;
        input integer n;
        integer i;
        begin
            for (i = 0; i < n; i = i + 1) @(posedge clk);
            #1;
        end
    endtask

    task check;
        input condition;
        input [8*100-1:0] message;
        begin
            if (!condition) begin
                $display("FAIL: %0s", message);
                $fatal(1);
            end
        end
    endtask

    initial begin
        tick(3);
        rst = 1'b0;
        tick(2);
        check(!waveform_toggle && mode == 0, "reset defaults");

        // Neither short simultaneous bounce nor a sub-debounce overlap is a chord.
        key0_n = 1'b0; key1_n = 1'b0; tick(1);
        key0_n = 1'b1; key1_n = 1'b1; tick(8);
        check(waveform_count == 0, "bouncing pair rejected");

        // Both keys must become stable down together. Releasing only one key
        // must not emit; the event occurs after the second stable release.
        key0_n = 1'b0; tick(7);
        key1_n = 1'b0; tick(7);
        key0_n = 1'b1; tick(7);
        check(waveform_count == 0, "first release does not emit");
        key1_n = 1'b1; tick(7);
        check(waveform_count == 1 && !waveform_toggle, "staggered short chord emits one-cycle event");

        // Reverse the release order to show that either key may be last.
        key0_n = 1'b0; key1_n = 1'b0; tick(7);
        key1_n = 1'b1; tick(7);
        check(waveform_count == 1, "second first-release remains silent");
        key0_n = 1'b1; tick(7);
        check(waveform_count == 2, "reverse release order emits once");

        // A single key short action is still independent of the waveform event.
        key0_n = 1'b0; tick(7); key0_n = 1'b1; tick(7);
        check(waveform_count == 2, "single-key action does not toggle");

        // Long chord restores PLAY and is excluded from the short event.
        key0_n = 1'b0; key1_n = 1'b0; tick(30);
        check(mode == 0, "long chord keeps or restores PLAY");
        key0_n = 1'b1; key1_n = 1'b1; tick(8);
        check(waveform_count == 2, "long chord release does not toggle");

        // Enter brightness mode with the established KEY0 long action; a short
        // chord in an edit mode must not reach the waveform output.
        key0_n = 1'b0; tick(30);
        check(mode == 1, "KEY0 long action still enters brightness");
        key0_n = 1'b1; tick(7);
        key0_n = 1'b0; key1_n = 1'b0; tick(7);
        key0_n = 1'b1; tick(7); key1_n = 1'b1; tick(7);
        check(waveform_count == 2, "edit-mode chord does not toggle");

        $display("PASS tb_waveform_chord_control");
        $finish;
    end
endmodule
