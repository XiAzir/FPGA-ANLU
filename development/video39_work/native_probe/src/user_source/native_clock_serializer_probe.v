module native_clock_serializer_probe(input wire refclk, input wire reset,
 output wire L4_P, output wire L6_P, output wire L7_P, output wire L9_P);
 wire pixel_clk, serial_clk, locked;
 video_pll u_pll(.refclk(refclk), .reset(reset), .extlock(locked), .clk0_out(pixel_clk), .clk1_out(serial_clk));
 reg [9:0] data_word=10'b1010011101;
 always @(posedge pixel_clk or posedge reset) if(reset) data_word<=10'b1010011101; else data_word<={data_word[8:0],data_word[9]};
 lane_lvds_10_1 #(.DEVICE("EG")) u_lane0(.I_pixel_clk(pixel_clk),.I_serial_clk(serial_clk),.I_rst(reset),.I_data_in(data_word),.O_serial_out(L4_P));
 lane_lvds_10_1 #(.DEVICE("EG")) u_lane1(.I_pixel_clk(pixel_clk),.I_serial_clk(serial_clk),.I_rst(reset),.I_data_in(~data_word),.O_serial_out(L6_P));
 lane_lvds_10_1 #(.DEVICE("EG")) u_lane2(.I_pixel_clk(pixel_clk),.I_serial_clk(serial_clk),.I_rst(reset),.I_data_in(data_word ^ 10'h155),.O_serial_out(L7_P));
 lane_lvds_10_1 #(.DEVICE("EG")) u_lane3(.I_pixel_clk(pixel_clk),.I_serial_clk(serial_clk),.I_rst(reset),.I_data_in(data_word ^ 10'h2aa),.O_serial_out(L9_P));
endmodule
