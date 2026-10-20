`timescale 1ns/1ps
// Qualification probe only. No controller substitution and no bitstream.
module tb_physical_sdram_probe;
 reg clk=0;always #10 clk=~clk;
 reg ras_n=1,cas_n=1,we_n=1;
 reg [10:0] addr=0;reg[1:0] ba=0;
 reg drive=0;reg[31:0] data=0;
 wire[31:0] dq;assign dq=drive?data:32'bz;
 EG_PHY_SDRAM_2M_32 dut(.clk(clk),.ras_n(ras_n),.cas_n(cas_n),.we_n(we_n),
 .addr(addr),.ba(ba),.dq(dq),.cs_n(1'b0),.dm0(1'b0),.dm1(1'b0),.dm2(1'b0),.dm3(1'b0),.cke(1'b1));
 integer known=0,matching=0,z_samples=0,x_samples=0,i,cas;
 task command;input[2:0] cmd;input[10:0] a;begin
  @(negedge clk);{ras_n,cas_n,we_n}=cmd;addr=a;
 end endtask
 task nop;input integer n;integer k;begin
  command(3'b111,0);for(k=0;k<n;k=k+1)@(negedge clk);
 end endtask
 initial begin
  // Conservative initialization and spacing; BL1, sequential, CAS2 then CAS3.
  #200000;
  for(cas=2;cas<=3;cas=cas+1)begin
   command(3'b010,11'h400);nop(8);
   for(i=0;i<8;i=i+1)begin command(3'b001,0);nop(16);end
   command(3'b000,cas<<4);nop(8);
   command(3'b011,11'd3);nop(8);
   @(negedge clk);drive=1;data=32'h12ab34cd;{ras_n,cas_n,we_n}=3'b100;addr=5;
   @(posedge clk);#1;if(dq!==data)$fatal(1,"probe write drive/wiring failure");
   @(negedge clk);drive=0;{ras_n,cas_n,we_n}=3'b111;addr=0;
   nop(8);command(3'b101,11'd5);
   @(posedge clk);#1;
   command(3'b111,0);
   for(i=0;i<16;i=i+1)begin
    @(posedge clk);#1;
    if(dq===32'bz)z_samples=z_samples+1;
    else if(^dq===1'bx)x_samples=x_samples+1;
    else begin known=known+1;if(dq===32'h12ab34cd)matching=matching+1;end
    $display("SDRAM_PROBE CAS=%0d step=%0d dq=%08h",cas,i,dq);
   end
  end
  $display("SDRAM_PHYSICAL_MODEL_PROBE_COMPLETE known=%0d matching=%0d z=%0d x=%0d",known,matching,z_samples,x_samples);
  $display("BOUNDARY a probe with no data response is unqualified; any response still needs controller/data/timing qualification");$finish;
 end
endmodule
