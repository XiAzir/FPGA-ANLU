module native_io_probe(input wire clk, output wire L4_P, output wire L6_P, output wire L7_P, output wire L9_P);
  reg div = 1'b0;
  always @(posedge clk) div <= ~div;
  assign L4_P=div; assign L6_P=div; assign L7_P=div; assign L9_P=div;
endmodule
