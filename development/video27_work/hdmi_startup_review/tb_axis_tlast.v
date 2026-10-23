`timescale 1ns/1ps
module tb;
  reg clk=0, rst=1, vs=0, de=0;
  reg [23:0] rgb=24'h123456;
  wire user, valid, last;
  wire [23:0] data;
  integer i, last_at;
  always #5 clk=~clk;
  video_rgb_to_axis_640x480 dut(.I_clk(clk),.I_rst(rst),.I_vs(vs),.I_de(de),.I_rgb(rgb),
    .O_video_user(user),.O_video_valid(valid),.O_video_last(last),.O_video_data(data));
  initial begin
    repeat(2) @(negedge clk); rst=0;
    @(negedge clk); de=1;
    last_at=0;
    for(i=1;i<=641;i=i+1) begin
      @(posedge clk); #1;
      if(last) begin last_at=i; $display("TLAST active_pixel=%0d valid=%0b", i, valid); end
    end
    $display("SUMMARY width640_has_last=%0d width641_last_at=%0d", (last_at>0 && last_at<=640), last_at);
    $finish;
  end
endmodule
