module native_clock_serializer_probe_b(input wire refclk, input wire reset,
 output wire L4_P, output wire L6_P, output wire L7_P, output wire L9_P);
 wire pixel_clk, serial_clk, locked;
 video_pll u_pll(.refclk(refclk),.reset(reset),.extlock(locked),.clk0_out(pixel_clk),.clk1_out(serial_clk));
 reg [9:0] lfsr0=10'h155;
 reg [9:0] lfsr1=10'h2a3;
 reg [9:0] lfsr2=10'h31b;
 always @(posedge pixel_clk or posedge reset) begin
  if(reset) begin lfsr0<=10'h155; lfsr1<=10'h2a3; lfsr2<=10'h31b; end
  else begin
   lfsr0<={lfsr0[8:0],lfsr0[9]^lfsr0[6]};
   lfsr1<={lfsr1[8:0],lfsr1[9]^lfsr1[2]};
   lfsr2<={lfsr2[8:0],lfsr2[9]^lfsr2[5]^lfsr2[3]^lfsr2[0]};
  end
 end
 lane_lvds_10_1 #(.DEVICE("EG")) u_lane0(.I_pixel_clk(pixel_clk),.I_serial_clk(serial_clk),.I_rst(reset),.I_data_in(lfsr0),.O_serial_out(L4_P));
 lane_lvds_10_1 #(.DEVICE("EG")) u_lane1(.I_pixel_clk(pixel_clk),.I_serial_clk(serial_clk),.I_rst(reset),.I_data_in(lfsr1),.O_serial_out(L6_P));
 lane_lvds_10_1 #(.DEVICE("EG")) u_lane2(.I_pixel_clk(pixel_clk),.I_serial_clk(serial_clk),.I_rst(reset),.I_data_in(lfsr2),.O_serial_out(L7_P));
 lane_lvds_10_1 #(.DEVICE("EG")) u_lane3(.I_pixel_clk(pixel_clk),.I_serial_clk(serial_clk),.I_rst(reset),.I_data_in(10'b0000011111),.O_serial_out(L9_P));
endmodule
