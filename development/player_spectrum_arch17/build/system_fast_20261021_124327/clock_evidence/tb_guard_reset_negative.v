`timescale 1ns/100fs
module tb_guard_reset_negative;
 reg refclk=0,reset=0;
 wire slock,vlock,s0,s1,s2,pclk,serclk;
 pll_clock_replay dut(.refclk(refclk),.reset(reset),.slock(slock),.vlock(vlock),.sys0(s0),.sys1(s1),.sys2(s2),.pclk(pclk),.serclk(serclk));
 always #10 refclk=~refclk;
 initial begin #50 reset=1; #1000; $display("FAIL reset guard did not fire"); $finish; end
endmodule
