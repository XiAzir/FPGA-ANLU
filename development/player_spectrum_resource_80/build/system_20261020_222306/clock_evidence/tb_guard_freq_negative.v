`timescale 1ns/100fs
module tb_guard_freq_negative;
 reg refclk=0;
 wire slock,vlock,s0,s1,s2,pclk,serclk;
 pll_clock_replay dut(.refclk(refclk),.reset(1'b0),.slock(slock),.vlock(vlock),.sys0(s0),.sys1(s1),.sys2(s2),.pclk(pclk),.serclk(serclk));
 always #9 refclk=~refclk;
 initial begin #1000; $display("FAIL frequency guard did not fire"); $finish; end
endmodule
