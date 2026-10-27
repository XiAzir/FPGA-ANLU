`timescale 1ns/1ps
module tb;
 reg clk=0; always #5 clk=~clk;
 reg rst=1,start=0,accept=1,iv0=0,iv1=0,eob0=0,eob1=0;
 reg [15:0] data0=0,data1=0; reg [5:0] idx0=0,idx1=0; reg [31:0] id0=0,id1=0;
 wire ia0,ia1,ov0,ov1; wire [31:0] od0,od1,oid0,oid1; wire [5:0] oi0,oi1;
 integer cyc=0,n0=0,n1=0,end0=0,end1=0,startcyc=0,last0=0,last1=0;
 integer bdc0=0,bac0=0,bdc1=0,bac1=0,ndc0=0,nac0=0,ndc1=0,nac1=0;
 jpeg_idct base(clk,rst,start,1'b0,iv0,data0,idx0,eob0,id0,accept,ia0,ov0,od0,oi0,oid0);
 jpeg_idct_dc_fast cand(clk,rst,start,1'b0,iv1,data1,idx1,eob1,id1,accept,ia1,ov1,od1,oi1,oid1);
 always @(posedge clk) begin
  cyc<=cyc+1;
  if(iv0&&ia0) begin iv0<=0;eob0<=0;end
  if(iv1&&ia1) begin iv1<=0;eob1<=0;end
  if(ov0&&accept&&oi0==63) begin
   if(n0>0) if((n0%5)==4) begin bac0<=bac0+cyc-last0;nac0<=nac0+1;end else begin bdc0<=bdc0+cyc-last0;ndc0<=ndc0+1;end
   n0<=n0+1;end0<=cyc;last0<=cyc;
  end
  if(ov1&&accept&&oi1==63) begin
   if(n1>0) if((n1%5)==4) begin bac1<=bac1+cyc-last1;nac1<=nac1+1;end else begin bdc1<=bdc1+cyc-last1;ndc1<=ndc1+1;end
   n1<=n1+1;end1<=cyc;last1<=cyc;
  end
 end
 task send0(input [5:0] ix,input signed [15:0] val,input last,input [31:0] ident);
 begin
  @(negedge clk); while(!ia0) @(negedge clk);
  iv0=1;idx0=ix;data0=val;eob0=last;id0=ident;
  while(iv0) @(negedge clk);
 end endtask
 task send1(input [5:0] ix,input signed [15:0] val,input last,input [31:0] ident);
 begin
  @(negedge clk); while(!ia1) @(negedge clk);
  iv1=1;idx1=ix;data1=val;eob1=last;id1=ident;
  while(iv1) @(negedge clk);
 end endtask
 task stream0;
 integer k; reg [15:0] dc;
 begin
  for(k=0;k<80;k=k+1) begin
   dc=(k*16'd25173+16'd13849);
   if(k%5==4) begin send0(0,$signed(dc),0,32'h4000+k);send0(1,16'sd37,1,32'h4000+k);end
   else send0(0,$signed(dc),1,32'h4000+k);
  end
 end endtask
 task stream1;
 integer k; reg [15:0] dc;
 begin
  for(k=0;k<80;k=k+1) begin
   dc=(k*16'd25173+16'd13849);
   if(k%5==4) begin send1(0,$signed(dc),0,32'h4000+k);send1(1,16'sd37,1,32'h4000+k);end
   else send1(0,$signed(dc),1,32'h4000+k);
  end
 end endtask
 initial begin
  repeat(3) @(negedge clk);rst=0;start=1;@(negedge clk);start=0;startcyc=cyc;
  fork stream0; stream1; join
  wait(n0==80&&n1==80); repeat(2) @(negedge clk);
  $display("SUSTAINED blocks=80 dc=64 ac=16 base_cycles=%0d fast_cycles=%0d saved=%0d",end0-startcyc,end1-startcyc,(end0-end1));
  $display("INTERVAL_AVG base_dc=%0d base_ac=%0d fast_dc=%0d fast_ac=%0d",bdc0/ndc0,bac0/nac0,bdc1/ndc1,bac1/nac1);
  $finish;
 end
 initial begin #5000000;$fatal(1,"timeout base=%0d fast=%0d",n0,n1);end
endmodule
