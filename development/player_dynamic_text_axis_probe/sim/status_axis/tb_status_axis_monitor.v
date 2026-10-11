`timescale 1ns/1ps
module tb_status_axis_monitor;
    reg pixel_clk=0;
    reg sys_clk=0;
    reg rst=1, sys_rst=1;
    always #5 pixel_clk=~pixel_clk;
    always #5 sys_clk=~sys_clk;

    reg [23:0] axis_rgb=24'h123456;
    reg axis_valid=0, axis_user=0, hdmi_locked=0;
    reg audio_valid=0, tone_mode=0, underflow=0;
    reg [23:0] audio_pcm=0;
    reg [3:0] startup_flags=0;
    reg [7:0] file_flags=0, fs_code=0, wav_map_code=0;
    reg [23:0] packet_samples=0, packet_count=0, packet_bad_bch=0;
    reg [23:0] packet_bad_terc=0, packet_tone_bad=0;
    reg [23:0] packet_cts=0, packet_n=0;
    reg [3:0] packet_flags=0;
    wire [31:0] hex_value;

    // Same cadence as the top's 25 MHz system/page counter, scaled so a page
    // advances in four test clocks. PIXEL_HZ is likewise reduced for simulation.
    player_status_monitor #(
        .PIXEL_HZ(4), .SYS_HZ(4), .PAGE_SECONDS(1), .SHOW_SELF_TEST(1)
    ) dut (
        .pixel_clk(pixel_clk), .sys_clk(sys_clk), .rst(rst), .sys_rst(sys_rst),
        .axis_rgb(axis_rgb), .axis_valid(axis_valid), .axis_user(axis_user),
        .hdmi_locked(hdmi_locked), .audio_valid(audio_valid),
        .tone_mode(tone_mode), .underflow(underflow), .audio_pcm(audio_pcm),
        .startup_flags(startup_flags), .file_flags(file_flags),
        .fs_code(fs_code), .wav_map_code(wav_map_code), .hex_value(hex_value),
        .packet_samples(packet_samples), .packet_count(packet_count),
        .packet_bad_bch(packet_bad_bch), .packet_bad_terc(packet_bad_terc),
        .packet_tone_bad(packet_tone_bad), .packet_cts(packet_cts),
        .packet_n(packet_n), .packet_flags(packet_flags)
    );

    task fail;
        input [8*180-1:0] message;
        begin $display("FAIL: %0s at %0t hex=%08h", message, $time, hex_value); $fatal(1); end
    endtask

    task expect_hex;
        input [31:0] expected;
        input [8*64-1:0] label_text;
        begin
            #1;
            if (hex_value !== expected) begin
                $display("Mismatch %0s expected=%08h got=%08h", label_text, expected, hex_value);
                $fatal(1);
            end
        end
    endtask

    task next_page;
        begin
            repeat (4) @(negedge sys_clk);
            #1;
        end
    endtask

    integer round;
    reg [31:0] expected;
    initial begin
        startup_flags=4'hB;
        file_flags=8'hA5;
        fs_code=8'h3C;
        wav_map_code=8'hD6;
        packet_flags=4'hA;
        packet_samples=24'hABCDEF;
        packet_count=24'hFEDCBA;
        packet_bad_bch=24'h89ABCD;
        packet_bad_terc=24'h765432;
        packet_tone_bad=24'hC0FFEE;
        packet_cts=24'hABCDEF;
        packet_n=24'hABCDEF;
        tone_mode=1;
        underflow=1;
        hdmi_locked=1;
        #23;
        rst=0;
        sys_rst=0;

        // Exercise legacy audio mailbox capture: one observed AXIS SOF makes
        // frame_seen sticky; tone/underflow/lock are captured in the mailbox.
        @(negedge pixel_clk); axis_valid=1; axis_user=1;
        @(negedge pixel_clk); axis_valid=0; axis_user=0;
        expect_hex(32'h01234567, "self-test 1");
        next_page(); expect_hex(32'h88888888, "self-test 2");
        next_page(); expect_hex(32'h1BA53CD6, "startup and file status page");
        next_page(); expect_hex(32'h3F000000, "legacy audio mailbox page");

        // Walk the nine actual display pages through three complete rounds.
        // This independently checks prefix+flags+payload as displayed by RTL,
        // including all four high payload nibbles of pages B and C.
        for (round=0; round<3; round=round+1) begin
            expected={4'h6,4'hA,24'hABCDEF}; next_page(); expect_hex(expected,"page 6 samples/dims");
            expected={4'h7,4'hA,24'hFEDCBA}; next_page(); expect_hex(expected,"page 7 frame period/count");
            expected={4'h8,4'hA,24'h89ABCD}; next_page(); expect_hex(expected,"page 8 pixels/frame count");
            expected={4'h9,4'hA,24'h765432}; next_page(); expect_hex(expected,"page 9 line/frame errors");
            expected={4'hA,4'hA,24'hC0FFEE}; next_page(); expect_hex(expected,"page A ready/blank gap");
            expected={4'hB,4'hA,24'hABCDEF}; next_page(); expect_hex(expected,"page B full CTS payload");
            expected={4'hC,4'hA,24'hABCDEF}; next_page(); expect_hex(expected,"page C full N payload");
            next_page(); expect_hex(32'h1BA53CD6,"wrap to startup page");
            next_page(); expect_hex(32'h3F000000,"wrap to legacy audio mailbox page");
        end
        $display("PASS: 2 self-test patterns; startup/audio pages; three complete 9-page rounds; full 24-bit page B/C payloads and flags.");
        $finish;
    end
endmodule
