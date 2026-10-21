`timescale 1ns/1ps
module tb;
reg clk=0, rst=1;
reg [31:0] value=0;
wire bd,bs,br,cd,cs,cr;
integer i;
always #10 clk=~clk;
status_hex595_base b(clk,rst,value,bd,bs,br);
status_hex595_cand c(clk,rst,value,cd,cs,cr);
initial begin
  repeat(4) @(posedge clk);
  rst=0;
  for(i=0;i<52000;i=i+1) begin
    @(negedge clk);
    if ((i % 100)==0) value = $random;
    @(posedge clk); #1;
    if({bd,bs,br} !== {cd,cs,cr}) begin
      $display("MISMATCH cycle=%0d base=%b cand=%b",i,{bd,bs,br},{cd,cs,cr});
      $fatal(1);
    end
  end
  $display("PASS cycles=52000 default parameters");
  $finish;
end
endmodule
