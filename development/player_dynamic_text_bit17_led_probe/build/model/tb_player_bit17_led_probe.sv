`timescale 1ns/1ps
module tb_player_bit17_led_probe;
    reg video_clk = 1'b0;
    reg rst = 1'b1;
    reg tone_mode = 1'b0;
    reg [9:0] cw_count_data = 10'b0;
    wire [3:0] led;

    player_bit17_led_probe dut (
        .video_clk(video_clk), .rst(rst), .tone_mode(tone_mode),
        .cw_count_data(cw_count_data), .led(led)
    );

    always #5 video_clk = ~video_clk;

    task tick;
        begin @(posedge video_clk); #1; end
    endtask

    task expect_led(input [3:0] expected, input [8*64-1:0] label);
        begin
            if (led !== expected) begin
                $display("FAIL %0s expected=%h actual=%h flags=%b", label, expected, led, dut.flags);
                $fatal(1);
            end
            $display("PASS %0s led=%h flags=%b", label, led, dut.flags);
        end
    endtask

    task clear_and_enter_tone;
        begin
            @(negedge video_clk); tone_mode=0; cw_count_data=10'h3ff;
            tick(); expect_led(4'hf, "WAV does not latch");
            @(negedge video_clk); tone_mode=1; cw_count_data=10'b0;
            tick(); expect_led(4'hf, "tone entry starts clear");
        end
    endtask

    initial begin
        #12; rst=0; tick(); expect_led(4'hf, "reset clears and LEDs off");

        clear_and_enter_tone();
        @(negedge video_clk); cw_count_data=10'b0000000001;
        tick(); expect_led(4'he, "bit0 audio_count17 maps to LED0");
        @(negedge video_clk); cw_count_data=10'b0;
        tick(); expect_led(4'he, "one-cycle bit0 pulse remains sticky");

        clear_and_enter_tone();
        @(negedge video_clk); cw_count_data=10'b0000000010;
        tick(); expect_led(4'hd, "bit1 mailbox17 maps to LED1");

        clear_and_enter_tone();
        @(negedge video_clk); cw_count_data=10'b0000000100;
        tick(); expect_led(4'hb, "bit2 received17 maps to LED2");

        clear_and_enter_tone();
        @(negedge video_clk); cw_count_data=10'b0000001000;
        tick(); expect_led(4'hf, "hex17 ignored outside internal page1");
        @(negedge video_clk); cw_count_data=10'b0000101000;
        tick(); expect_led(4'h7, "hex17 maps to LED3 on display page3");
        @(negedge video_clk); cw_count_data=10'b0000100000;
        tick(); expect_led(4'h7, "hex17 page3 event remains sticky");

        @(negedge video_clk); tone_mode=0; cw_count_data=10'h3ff;
        tick(); expect_led(4'hf, "return to WAV clears all flags");
        @(negedge video_clk); cw_count_data=10'h3ff;
        tick(); expect_led(4'hf, "WAV remains unlatched");

        $display("MODEL_PASS");
        $finish;
    end
endmodule

