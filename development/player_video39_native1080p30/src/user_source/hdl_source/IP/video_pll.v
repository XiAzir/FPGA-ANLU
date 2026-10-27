`timescale 1 ns / 100 fs

// C39 native-IO evaluation: 50MHz reference, M=104, N=7.
// VCO=742.857142857MHz, C0=10 -> 74.285714286MHz, C1=2 -> 371.428571429MHz.
// Nominal CTA 1080p30 pixel clock is 74.25MHz; this candidate is +0.0481000481%.
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
        .REFCLK_DIV(7),
        .FBCLK_DIV(104),
        .CLKC0_ENABLE("ENABLE"),
        .CLKC0_DIV(10),
        .CLKC0_CPHASE(9),
        .CLKC0_FPHASE(0),
        .CLKC1_ENABLE("ENABLE"),
        .CLKC1_DIV(2),
        .CLKC1_CPHASE(1),
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

