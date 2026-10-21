module tb_timer_param_elab;
    reg clk=0, rst=1;
    wire p0,p1,a0valid,a1valid;
    fat32_file_sector #(.WAIT_LIMIT(32'd0)) m0();
    fat32_file_sector #(.WAIT_LIMIT(32'hffffffff)) m1();
    fat32_file_sector mdefault();
    key_press_debounce #(.CLK_FREQ_HZ(0),.DEBOUNCE_MS(50)) k0
        (.clk(clk),.rst(rst),.button_in(1'b1),.press_pulse(p0));
    key_press_debounce #(.CLK_FREQ_HZ(1000),.DEBOUNCE_MS(1)) k1
        (.clk(clk),.rst(rst),.button_in(1'b1),.press_pulse(p1));
    key_press_debounce kdefault
        (.clk(clk),.rst(rst),.button_in(1'b1),.press_pulse());
    key_press_debounce #(.CLK_FREQ_HZ(50000000),.DEBOUNCE_MS(50)) k_tf_active
        (.clk(clk),.rst(rst),.button_in(1'b1),.press_pulse());
    key_press_debounce #(.CLK_FREQ_HZ(100000000),.DEBOUNCE_MS(50)) k_sd_card
        (.clk(clk),.rst(rst),.button_in(1'b1),.press_pulse());
    player_audio_probe #(.PIXEL_HZ(0)) a0
        (.pixel_clk(clk),.sd_clk(clk),.rst(rst),.tone_toggle(1'b0),
         .primed(1'b0),.sample_available(1'b0),.sample_data(16'd0));
    player_audio_probe #(.PIXEL_HZ(-1)) a1
        (.pixel_clk(clk),.sd_clk(clk),.rst(rst),.tone_toggle(1'b0),
         .primed(1'b0),.sample_available(1'b0),.sample_data(16'd0));
    player_audio_probe adefault
        (.pixel_clk(clk),.sd_clk(clk),.rst(rst),.tone_toggle(1'b0),
         .primed(1'b0),.sample_available(1'b0),.sample_data(16'd0));
    tf_bmp_file_player #(.CLK_FREQ_HZ(0),.FRAME_WIDTH(1),.FRAME_HEIGHT(1),.WAIT_LIMIT(0)) l0();
    tf_bmp_file_player #(.CLK_FREQ_HZ(-1),.FRAME_WIDTH(1),.FRAME_HEIGHT(1),.WAIT_LIMIT(32'hffffffff)) l1();
    tf_bmp_file_player ldefault();
    initial begin
        #1;
        $display("PARAM_WIDTHS mapper_zero=%0d mapper_max=%0d mapper_default=%0d debounce_zero=%0d debounce_one=%0d debounce_default=%0d debounce_tf_active=%0d debounce_sd_card=%0d blink_zero=%0d blink_negative=%0d blink_default=%0d loader_watchdog_zero=%0d auto_zero=%0d loader_watchdog_max=%0d auto_negative=%0d loader_watchdog_default=%0d auto_default=%0d",
            m0.WAIT_COUNT_W,m1.WAIT_COUNT_W,mdefault.WAIT_COUNT_W,
            k0.DEBOUNCE_COUNT_W,k1.DEBOUNCE_COUNT_W,kdefault.DEBOUNCE_COUNT_W,
            k_tf_active.DEBOUNCE_COUNT_W,k_sd_card.DEBOUNCE_COUNT_W,
            a0.BLINK_COUNT_W,a1.BLINK_COUNT_W,adefault.BLINK_COUNT_W,
            l0.WATCHDOG_W,l0.AUTO_COUNT_W,l1.WATCHDOG_W,l1.AUTO_COUNT_W,
            ldefault.WATCHDOG_W,ldefault.AUTO_COUNT_W);
        $finish;
    end
endmodule
