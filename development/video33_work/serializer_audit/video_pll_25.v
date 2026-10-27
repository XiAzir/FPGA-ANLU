module video_pll_25 (input refclk, input reset, output extlock, output clk0_out, output clk1_out);
  wire clk0_buf; wire [4:0] opens; wire [7:0] do_bus; wire psdone;
  EG_LOGIC_BUFG bufg_feedback(.i(clk0_buf),.o(clk0_out));
  EG_PHY_PLL #(.DPHASE_SOURCE("DISABLE"),.DYNCFG("DISABLE"),.FIN("50.000000"),.FEEDBK_MODE("NORMAL"),.FEEDBK_PATH("CLKC0_EXT"),.STDBY_ENABLE("DISABLE"),.PLLRST_ENA("ENABLE"),.SYNC_ENABLE("DISABLE"),.GMC_GAIN(2),.ICP_CURRENT(9),.KVCO(2),.LPF_CAPACITOR(1),.LPF_RESISTOR(8),
    .REFCLK_DIV(2),.FBCLK_DIV(1),.CLKC0_ENABLE("ENABLE"),.CLKC0_DIV(40),.CLKC0_CPHASE(39),.CLKC0_FPHASE(0),.CLKC1_ENABLE("ENABLE"),.CLKC1_DIV(8),.CLKC1_CPHASE(7),.CLKC1_FPHASE(0)) pll_inst(
    .refclk(refclk),.reset(reset),.stdby(1'b0),.extlock(extlock),.load_reg(1'b0),.psclk(1'b0),.psdown(1'b0),.psstep(1'b0),.psclksel(3'b000),
    .psdone(psdone),.dclk(1'b0),.dcs(1'b0),.dwe(1'b0),.di(8'b0),.daddr(6'b0),.do(do_bus),.fbclk(clk0_out),.clkc({opens[4:2],clk1_out,clk0_buf}));
endmodule
