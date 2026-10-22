`timescale 1ns/100fs
// Simulation-only wrapper substitutes. Qualification must precede selection.
// The production top and its million-cycle startup controller remain unchanged.
module sys_pll(input refclk,reset,output extlock,clk0_out,clk1_out,clk2_out);
 pll_clock_replay replay(.refclk(refclk),.reset(reset),.slock(extlock),
  .sys0(clk0_out),.sys1(clk1_out),.sys2(clk2_out),.vlock(),.pclk(),.serclk());
endmodule
module video_pll(input refclk,reset,output extlock,clk0_out,clk1_out);
 pll_clock_replay replay(.refclk(refclk),.reset(reset),.vlock(extlock),
  .pclk(clk0_out),.serclk(clk1_out),.slock(),.sys0(),.sys1(),.sys2());
endmodule
