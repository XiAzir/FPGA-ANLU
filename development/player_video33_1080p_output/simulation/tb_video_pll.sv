`timescale 1ns/1ps
module tb_video_pll;
    reg refclk = 1'b0;
    wire pll_lock;
    wire pixel_clk;
    wire serial_clk;
    realtime t0, t1, pixel_period, serial_period;

    always #10 refclk = ~refclk;

    video_pll dut (
        .refclk(refclk), .reset(1'b0), .extlock(pll_lock),
        .clk0_out(pixel_clk), .clk1_out(serial_clk)
    );

    initial begin
        #5_000_000;
        $display("PLL model lock after 5 ms: %0b", pll_lock);
        $display("PLL internals ref_cycle=%0.6f ref_cycle_reg=%0.6f tmp=%0.6f phase7=%b fake=%0d elock=%b pulse_count=%0d",
            dut.pll_inst.refclk_cycle, dut.pll_inst.refclk_cycle_reg,
            dut.pll_inst.tmp_time_value, dut.pll_inst.phase7,
            dut.pll_inst.fakelockcnt, dut.pll_inst.elock_rls, dut.pll_inst.pulse_count);
        fork
            begin
                @(posedge pixel_clk); t0 = $realtime;
                @(posedge pixel_clk); t1 = $realtime;
                pixel_period = t1 - t0;
                @(posedge serial_clk); t0 = $realtime;
                @(posedge serial_clk); t1 = $realtime;
                serial_period = t1 - t0;
            end
            begin
                #1000;
                $fatal(1, "PLL output clocks did not start");
            end
        join_any
        $display("PLL_LOCK=%0b pixel_period_ns=%0.6f serial_period_ns=%0.6f pixel_MHz=%0.6f serial_MHz=%0.6f",
            pll_lock, pixel_period, serial_period, 1000.0/pixel_period, 1000.0/serial_period);
        if (pixel_period < 30.2 || pixel_period > 30.4)
            $fatal(1, "pixel clock outside 33 MHz tolerance");
        if (serial_period < 6.0 || serial_period > 6.2)
            $fatal(1, "serial clock outside 165 MHz tolerance");
        $display("PASS: EG4 vendor PLL model realizes 50 MHz -> 33/165 MHz.");
        $finish;
    end
endmodule
