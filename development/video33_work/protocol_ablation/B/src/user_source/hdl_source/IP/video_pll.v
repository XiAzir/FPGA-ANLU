`timescale 1 ns / 100 fs

// C33 diagnostic PLL configuration derived from the EG4 IP generator settings:
// 50 MHz reference, No compensation (VCO_PHASE_0 feedback), M=33, N=2.
// VCO = 50 * 33 / 2 = 825 MHz; C0=/25 -> 33 MHz; C1=/5 -> 165 MHz.
module video_pll (
    input  wire refclk,
    input  wire reset,
    output wire extlock,
    output wire clk0_out,
    output wire clk1_out
);
    wire clk0_buf;
    wire [4:0] pll_clkc_unused;
    wire [7:0] pll_do_unused;
    wire pll_psdone_unused;

    EG_LOGIC_BUFG u_pixel_gclk (
        .i(clk0_buf),
        .o(clk0_out)
    );

    EG_PHY_PLL #(
        .DPHASE_SOURCE("DISABLE"),
        .DYNCFG("DISABLE"),
        .FIN("50.000000"),
        .FEEDBK_MODE("NOCOMP"),
        .FEEDBK_PATH("VCO_PHASE_0"),
        .STDBY_ENABLE("DISABLE"),
        .PLLRST_ENA("ENABLE"),
        .SYNC_ENABLE("DISABLE"),
        .GMC_GAIN(2),
        .ICP_CURRENT(9),
        .KVCO(2),
        .LPF_CAPACITOR(1),
        .LPF_RESISTOR(8),
        .REFCLK_DIV(2),
        .FBCLK_DIV(33),
        .CLKC0_ENABLE("ENABLE"),
        .CLKC0_DIV(25),
        .CLKC0_CPHASE(24),
        .CLKC0_FPHASE(0),
        .CLKC1_ENABLE("ENABLE"),
        .CLKC1_DIV(5),
        .CLKC1_CPHASE(4),
        .CLKC1_FPHASE(0)
    ) pll_inst (
        .refclk(refclk),
        .reset(reset),
        .stdby(1'b0),
        .extlock(extlock),
        .load_reg(1'b0),
        .psclk(1'b0),
        .psdown(1'b0),
        .psstep(1'b0),
        .psclksel(3'b000),
        .psdone(pll_psdone_unused),
        .dclk(1'b0),
        .dcs(1'b0),
        .dwe(1'b0),
        .di(8'b0),
        .daddr(6'b0),
        .do(pll_do_unused),
        .fbclk(1'b0),
        .clkc(pll_clkc_unused)
    );

    assign clk0_buf = pll_clkc_unused[0];
    assign clk1_out = pll_clkc_unused[1];
endmodule


