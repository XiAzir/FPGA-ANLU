module lvds_property_parser_probe (
 input wire refclk,
 output wire L4_P,
 output wire L6_P,
 output wire L7_P,
 output wire L9_P
);
assign L4_P = refclk;
assign L6_P = refclk;
assign L7_P = refclk;
assign L9_P = refclk;
endmodule
