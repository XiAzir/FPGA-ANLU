`timescale 1ns/1ps
module tb;
reg clk=0; always #5 clk=~clk;
reg rst=1,start=0,endf=0,iv=0,eob=0,accept=1;
reg [15:0] data=0; reg [5:0] idx=0; reg [31:0] id=0;
wire ia,ov; wire [31:0] od,oid; wire [5:0] oi;
integer cyc=0, outcnt=0, startcyc=0;
jpeg_idct dut(clk,rst,start,endf,iv,data,idx,eob,id,accept,ia,ov,od,oi,oid);
always @(posedge clk) begin
 cyc<=cyc+1;
 if (ov && accept) begin $display("OUT %0d %0d %0d",oi,$signed(od),cyc); outcnt<=outcnt+1; end
end
initial begin
 repeat(3) @(negedge clk); rst=0; start=1; @(negedge clk); start=0;
 wait(ia); @(negedge clk); iv=1; data=16'sd128; idx=0; id=32'h1234; eob=1;
 @(negedge clk); iv=0;eob=0;
 wait(outcnt==64); $display("DONE %0d",cyc); $finish;
end
initial begin #1000000; $display("TIMEOUT"); $finish; end
endmodule
