`timescale 1ns/1ps
module tb_pll_c32_model;
reg refclk=0; wire lock; wire c0,c1; wire raw0;
always #10 refclk=~refclk;
EG_PHY_PLL #(.FIN("50.000000"),.FEEDBK_MODE("NORMAL"),.FEEDBK_PATH("CLKC0_EXT"),.REFCLK_DIV(2),.FBCLK_DIV(1),.PLLRST_ENA("ENABLE"),.SYNC_ENABLE("DISABLE"),.GMC_GAIN(2),.ICP_CURRENT(9),.KVCO(2),.LPF_CAPACITOR(1),.LPF_RESISTOR(8),.CLKC0_ENABLE("ENABLE"),.CLKC0_DIV(40),.CLKC0_CPHASE(39),.CLKC1_ENABLE("ENABLE"),.CLKC1_DIV(8),.CLKC1_CPHASE(7)) p(.refclk(refclk),.reset(1'b0),.stdby(1'b0),.extlock(lock),.load_reg(5'b0),.psclk(1'b0),.psdown(1'b0),.psstep(1'b0),.psclksel(3'b0),.psdone(),.dclk(1'b0),.dcs(1'b0),.dwe(1'b0),.di(8'b0),.daddr(6'b0),.do(),.fbclk(c0),.clkc({open,open,open,c1,raw0}));
EG_LOGIC_BUFG b(.i(raw0),.o(c0));
initial begin #5000000; $display("C32 model lock=%b clk0=%b phase7=%b fake=%0d",lock,c0,p.phase7,p.fakelockcnt); $finish; end
endmodule
