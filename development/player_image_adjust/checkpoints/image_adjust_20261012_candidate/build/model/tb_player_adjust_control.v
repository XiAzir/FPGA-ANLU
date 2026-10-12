`timescale 1ns/1ps
module tb_player_adjust_control;
    reg clk = 0;
    always #5 clk = ~clk;
    reg rst = 1;
    reg vs = 0;
    reg key0_n = 1;
    reg key1_n = 1;
    wire next_n, auto_n, tone_press;
    wire [1:0] mode;
    wire [3:0] brightness_index;
    wire [2:0] contrast_index;
    integer pulse_width;
    integer high_width;
    integer tone_count;
    integer legacy_next_count;
    wire legacy_next_press;
    wire [1:0] unused_mode;
    wire [3:0] unused_brightness;
    wire [2:0] unused_contrast;
    wire unused_next, unused_auto, unused_tone;

    player_adjust_control default_parameters_dut (
        .clk(clk), .rst(rst), .vs(1'b0), .key0_n(1'b1), .key1_n(1'b1),
        .next_n(unused_next), .auto_n(unused_auto), .tone_press(unused_tone),
        .mode(unused_mode), .brightness_index(unused_brightness), .contrast_index(unused_contrast)
    );

    key_press_debounce #(.CLK_FREQ_HZ(1000), .DEBOUNCE_MS(50)) legacy_next_debounce (
        .clk(clk), .rst(rst), .button_in(next_n), .press_pulse(legacy_next_press)
    );

    player_adjust_control #(
        .CLK_FREQ_HZ(1000), .DEBOUNCE_MS(3), .HOLD_MS(20), .PULSE_MS(100), .LEGACY_GAP_MS(100)
    ) dut (
        .clk(clk), .rst(rst), .vs(vs), .key0_n(key0_n), .key1_n(key1_n),
        .next_n(next_n), .auto_n(auto_n), .tone_press(tone_press), .mode(mode),
        .brightness_index(brightness_index), .contrast_index(contrast_index)
    );

    always @(posedge clk) begin
        if (tone_press) tone_count = tone_count + 1;
        if (legacy_next_press) legacy_next_count = legacy_next_count + 1;
    end

    task tick;
        input integer n;
        integer i;
        begin for (i = 0; i < n; i = i + 1) @(posedge clk); #1; end
    endtask

    task press0;
        input integer n;
        begin key0_n = 0; tick(n); end
    endtask
    task release0;
        input integer n;
        begin key0_n = 1; tick(n); end
    endtask
    task press1;
        input integer n;
        begin key1_n = 0; tick(n); end
    endtask
    task release1;
        input integer n;
        begin key1_n = 1; tick(n); end
    endtask

    task check;
        input condition;
        input [8*96-1:0] message;
        begin if (!condition) begin $display("FAIL: %0s", message); $fatal(1); end end
    endtask

    initial begin
        tone_count = 0;
        legacy_next_count = 0;
        tick(3); rst = 0; tick(2);
        check(mode == 0 && brightness_index == 4 && contrast_index == 2 && next_n && auto_n, "reset defaults");
        check(default_parameters_dut.DB_CYCLES == 500000 &&
              default_parameters_dut.HOLD_CYCLES == 37500000 &&
              default_parameters_dut.PULSE_CYCLES == 2500000 &&
              default_parameters_dut.GAP_CYCLES == 2500000,
              "production cycle constants avoid overflow");

        // A short bounce never becomes a debounced press.
        key0_n = 0; tick(1); key0_n = 1; tick(8);
        check(mode == 0 && next_n, "short bounce rejected");

        // KEY0 short press in PLAY emits one active-low pulse on release.
        press0(7); release0(6);
        check(!next_n, "next pulse asserted on short release");
        pulse_width = 1;
        tick(20); pulse_width = pulse_width + 20;
        // A second short event during the low pulse is coalesced into one queued event.
        press0(7); release0(6);
        pulse_width = pulse_width + 13;
        while (!next_n) begin tick(1); if (!next_n) pulse_width = pulse_width + 1; end
        check(pulse_width == 100, "next pulse is exactly PULSE_MS");
        check(legacy_next_count == 1, "legacy debounce accepts first next pulse");
        high_width = 0;
        while (next_n) begin tick(1); if (next_n) high_width = high_width + 1; end
        check(high_width >= 100, "next pulses have legacy recovery high interval");
        pulse_width = 1;
        while (!next_n) begin tick(1); if (!next_n) pulse_width = pulse_width + 1; end
        check(pulse_width == 100, "queued next pulse has exact low width");
        tick(52);
        check(legacy_next_count == 2, "legacy debounce accepts second queued next pulse");

        // KEY1 short press toggles auto through the legacy active-low input.
        press1(7); release1(6);
        check(!auto_n, "auto pulse asserted");
        pulse_width = 1;
        while (!auto_n) begin tick(1); if (!auto_n) pulse_width = pulse_width + 1; end
        check(pulse_width == 100, "auto pulse is exactly PULSE_MS");

        // Make the second key stable at KEY1's long threshold. The chord takes
        // priority on that edge, so no tone is emitted and PLAY mode is kept.
        key1_n = 0;
        while (!dut.key1_pressed) tick(1);
        while (dut.key1_hold_count < 14) tick(1);
        key0_n = 0;
        while (!dut.key0_pressed) tick(1);
        tick(3);
        check(mode == 0 && tone_count == 0, "simultaneous chord wins single-key hold threshold");
        key0_n = 1; key1_n = 1; tick(8);

        // KEY0 long press cycles to brightness without producing a next pulse.
        press0(28); check(mode == 1 && next_n, "KEY0 hold enters brightness once");
        release0(6); check(mode == 1 && next_n, "KEY0 long release has no short action");

        // Brightness edits are pending until VS rising edge.
        press1(7); release1(6);
        check(brightness_index == 4, "brightness output waits for VS");
        vs = 1; tick(2); vs = 0; tick(2);
        check(brightness_index == 5, "brightness commits on VS rising edge");
        press0(7); release0(6); // 5 -> 4
        press0(7); release0(6); // 4 -> 3
        vs = 1; tick(2); vs = 0; tick(2);
        check(brightness_index == 3, "brightness decrease and frame commit");
        press0(7); release0(6); // 3 -> 2
        press0(7); release0(6); // 2 -> 1
        press0(7); release0(6); // 1 -> 0
        press0(7); release0(6); // saturated at 0
        vs = 1; tick(2); vs = 0; tick(2);
        check(brightness_index == 0, "brightness saturates at zero");

        // KEY1 long in an edit mode neither increments nor emits tone.
        press1(28); release1(6);
        check(brightness_index == 0 && tone_count == 0, "edit-mode KEY1 long is suppressed");

        // Advance to contrast, then verify upper saturation and VS commit.
        press0(28); release0(6); check(mode == 2, "long KEY0 advances to contrast");
        press1(7); release1(6); // 2 -> 3
        press1(7); release1(6); // 3 -> 4
        press1(7); release1(6); // saturates
        vs = 1; tick(2); vs = 0; tick(2);
        check(contrast_index == 4, "contrast saturates at four");

        // Short overlapping chord suppresses both release actions and rearms
        // only after both keys are fully released.
        key0_n = 0; key1_n = 0; tick(8);
        key0_n = 1; tick(6); key1_n = 1; tick(6);
        check(mode == 2 && next_n && auto_n, "short chord suppresses tap actions");
        press0(7); release0(6); check(mode == 2, "keys rearm after full chord release");

        // Releasing one key during a chord breaks the continuous hold timer.
        key0_n = 0; key1_n = 0; tick(14);
        key0_n = 1; tick(6);
        key0_n = 0; tick(12);
        check(mode == 2, "interrupted chord does not accumulate hold time");
        key0_n = 1; key1_n = 1; tick(7);

        // A long chord resets the edit state without touching legacy pulses or tone.
        key0_n = 0; key1_n = 0; tick(30);
        check(mode == 0, "long chord resets mode");
        key0_n = 1; key1_n = 1; tick(7);
        vs = 1; tick(2); vs = 0; tick(2);
        check(brightness_index == 4 && contrast_index == 2, "long chord restores defaults at VS");

        // KEY1 alone held long in PLAY produces exactly one tone_press pulse,
        // and never creates an auto toggle.
        press1(28);
        check(tone_count == 1, "KEY1 long creates one tone_press pulse");
        release1(6);
        check(auto_n && tone_count == 1, "KEY1 long does not trigger auto or repeat");
        $display("PASS tb_player_adjust_control");
        $finish;
    end
endmodule
