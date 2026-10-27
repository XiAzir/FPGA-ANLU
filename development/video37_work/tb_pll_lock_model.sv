`timescale 1ns/1ps
module tb_pll_lock_model;
    reg clk = 0, reset = 0;
    wire pixel, serial, locked;
    always #10 clk = ~clk;
    video_pll dut(.refclk(clk),.reset(reset),.extlock(locked),.clk0_out(pixel),.clk1_out(serial));
    initial begin
        #10000;
        $display("PLL_NO_RESET locked=%b fakecount=%b internal_lock=%b lock_count=%d period_difference=%f",
            locked,dut.pll_inst.fakelockcnt,dut.pll_inst.int_lock,dut.pll_inst.lock_cnt,dut.pll_inst.tmp_time_value);
        if (locked !== 1'b0 || (^dut.pll_inst.fakelockcnt) !== 1'bx)
            $fatal(1,"Expected uninitialized fake-lock counter was not reproduced");
        reset = 1;
        #200 reset = 0;
        #10000;
        $display("PLL_AFTER_RESET locked=%b fakecount=%b internal_lock=%b lock_count=%d period_difference=%f",
            locked,dut.pll_inst.fakelockcnt,dut.pll_inst.int_lock,dut.pll_inst.lock_cnt,dut.pll_inst.tmp_time_value);
        if (locked !== 1'b1 || dut.pll_inst.fakelockcnt !== 4'd6)
            $fatal(1,"PLL model did not lock after input reset");
        $display("PLL_MODEL_RESET_INITIALIZATION_REPRODUCED");
        $finish;
    end
endmodule
