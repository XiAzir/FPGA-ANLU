`timescale 1ns/1ps
module tb;
reg clk=0; always #5 clk=~clk; reg rst=1,start=0,iv=0,eob=0,accept=1; reg [15:0] data; reg [5:0] idx; reg [31:0] id;
wire ia,ov; wire [31:0] od,oid; wire [5:0] oi; integer cyc=0; reg signed [15:0] vals[0:7]; integer vi=0; reg seen=0;
jpeg_idct dut(clk,rst,start,1'b0,iv,data,idx,eob,id,accept,ia,ov,od,oi,oid);
always @(posedge clk) begin cyc<=cyc+1; if(ov&&accept&&!seen) begin $display("DC %0d OUT %0d",$signed(vals[vi]),$signed(od)); seen<=1; end end
initial begin vals[0]=0;vals[1]=1;vals[2]=-1;vals[3]=128;vals[4]=-128;vals[5]=32767;vals[6]=-32768;vals[7]=256; repeat(3) @(negedge clk);rst=0;
for(vi=0;vi<8;vi=vi+1) begin start=1; @(negedge clk); start=0; wait(ia); @(negedge clk);iv=1;data=vals[vi];idx=0;eob=1;@(negedge clk);iv=0;eob=0; wait(seen); repeat(64) @(negedge clk); seen=0; end $finish; end
initial begin #1000000;$finish;end
endmodule

