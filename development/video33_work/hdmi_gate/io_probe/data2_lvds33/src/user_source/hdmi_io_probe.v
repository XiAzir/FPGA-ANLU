module hdmi_io_probe (
    input  wire clk,
    output wire HDMI_CLK_P,
    output wire HDMI_D0_P,
    output wire HDMI_D1_P,
    output wire HDMI_D2_P
);
    reg div = 1'b0;
    always @(posedge clk)
        div <= ~div;
    assign HDMI_CLK_P = div;
    assign HDMI_D0_P  = div;
    assign HDMI_D1_P  = div;
    assign HDMI_D2_P  = div;
endmodule
