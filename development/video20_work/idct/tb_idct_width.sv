`timescale 1ns/1ps
module tb_idct_width;
reg clk=0;
always #5 clk=~clk;
reg rst=1;
reg sx_valid=0, sy_valid=0, sx_start=0, sy_start=0;
reg [15:0] xd0=0,xd1=0,xd2=0,xd3=0;
reg [31:0] yd0=0,yd1=0,yd2=0,yd3=0;
reg [2:0] xi=0, yi=0;
wire xv_ref,xv_cand,xv_b,xv_ab,yv_ref,yv_cand,yv_b,yv_ab;
wire [31:0] xo_ref,xo_cand,xo_b,xo_ab,yo_ref,yo_cand,yo_b,yo_ab;
wire [5:0] xidx_ref,xidx_cand,xidx_b,xidx_ab,yidx_ref,yidx_cand,yidx_b,yidx_ab;
integer cyc=0, mismatches=0, xchecks=0, ychecks=0;

jpeg_idct_x_reference xref(clk,rst,sx_start,1'b0,sx_valid,xd0,xd1,xd2,xd3,xi,xv_ref,xo_ref,xidx_ref);
jpeg_idct_x xcand(clk,rst,sx_start,1'b0,sx_valid,xd0,xd1,xd2,xd3,xi,xv_cand,xo_cand,xidx_cand);
jpeg_idct_x_b xb(clk,rst,sx_start,1'b0,sx_valid,xd0,xd1,xd2,xd3,xi,xv_b,xo_b,xidx_b);
jpeg_idct_x_ab xab(clk,rst,sx_start,1'b0,sx_valid,xd0,xd1,xd2,xd3,xi,xv_ab,xo_ab,xidx_ab);
jpeg_idct_y_reference yref(clk,rst,sy_start,1'b0,sy_valid,yd0,yd1,yd2,yd3,yi,yv_ref,yo_ref,yidx_ref);
jpeg_idct_y ycand(clk,rst,sy_start,1'b0,sy_valid,yd0,yd1,yd2,yd3,yi,yv_cand,yo_cand,yidx_cand);
jpeg_idct_y_b yb(clk,rst,sy_start,1'b0,sy_valid,yd0,yd1,yd2,yd3,yi,yv_b,yo_b,yidx_b);
jpeg_idct_y_ab yab(clk,rst,sy_start,1'b0,sy_valid,yd0,yd1,yd2,yd3,yi,yv_ab,yo_ab,yidx_ab);

integer seed=32'h51D7C0DE;
integer k;
reg [31:0] rnd;
initial begin
  repeat (2) @(negedge clk);
  rst=0;
  for (k=0;k<200000;k=k+1) begin
    @(negedge clk);
    cyc=k;
    sx_start=(k%997==0); sy_start=(k%991==0);
    rst=(k%12011==12010);
    sx_valid=(($random(seed)&7)!=0); sy_valid=(($random(seed)&7)!=0);
    xi=$random(seed); yi=$random(seed);
    xd0=$random(seed); xd1=$random(seed); xd2=$random(seed); xd3=$random(seed);
    // Y-stage contract: each value is a signed 21-bit result of arithmetic >>> 11.
    yd0={{11{1'b0}},$random(seed)}; yd1={{11{1'b0}},$random(seed)};
    yd2={{11{1'b0}},$random(seed)}; yd3={{11{1'b0}},$random(seed)};
    yd0[31:21]={11{yd0[20]}}; yd1[31:21]={11{yd1[20]}};
    yd2[31:21]={11{yd2[20]}}; yd3[31:21]={11{yd3[20]}};
    case (k%16)
      0: begin xd0=16'h8000; yd0=32'hfff00000; end
      1: begin xd0=16'h7fff; yd0=32'h000fffff; end
      2: begin xd1=16'h8000; yd1=32'hfff00000; end
      3: begin xd2=16'h7fff; yd2=32'h000fffff; end
      4: begin xd3=16'h8000; yd3=32'hfff00000; end
      5: begin xd2=16'h8000; yd2=32'h000fffff; end
      6: begin xd1=16'h7fff; yd1=32'hfff00000; end
      7: begin xd3=16'h7fff; yd3=32'h000fffff; end
      8: begin xd0=0; yd0=0; end
      9: begin xd1=16'hffff; yd1=32'hffffffff; end
    endcase
    @(posedge clk); #1;
    xchecks=xchecks+1; ychecks=ychecks+1;
    if ({xv_ref,xo_ref,xidx_ref} !== {xv_cand,xo_cand,xidx_cand} || {xv_ref,xo_ref,xidx_ref} !== {xv_b,xo_b,xidx_b} || {xv_ref,xo_ref,xidx_ref} !== {xv_ab,xo_ab,xidx_ab}) begin
      if(mismatches<20) $display("X_MISMATCH cycle=%0d ref=%b/%h/%d cand=%b/%h/%d",k,xv_ref,xo_ref,xidx_ref,xv_cand,xo_cand,xidx_cand);
      mismatches=mismatches+1;
    end
    if ({yv_ref,yo_ref,yidx_ref} !== {yv_cand,yo_cand,yidx_cand} || {yv_ref,yo_ref,yidx_ref} !== {yv_b,yo_b,yidx_b} || {yv_ref,yo_ref,yidx_ref} !== {yv_ab,yo_ab,yidx_ab}) begin
      if(mismatches<20) $display("Y_MISMATCH cycle=%0d ref=%b/%h/%d cand=%b/%h/%d",k,yv_ref,yo_ref,yidx_ref,yv_cand,yo_cand,yidx_cand);
      mismatches=mismatches+1;
    end
  end
  $display("RESULT cycles=%0d xchecks=%0d ychecks=%0d mismatches=%0d",cyc+1,xchecks,ychecks,mismatches);
  if(mismatches!=0) $fatal(1,"differential mismatch");
  $finish;
end
endmodule
