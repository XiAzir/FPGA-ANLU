`timescale 1ns/1ps
module tb_controller_gate;
 reg clk=0,shift=0,rst=1;
 always #10 clk=~clk;
 initial begin #8;forever #10 shift=~shift;end
 reg wen=0,ren=0;
 reg [20:0] wa=0,ra=0;
 reg [31:0] wd=0;
 reg [3:0] dm=0;
 wire init,refresh,busy,rv;
 wire [31:0] rd;
 sdram dut(.Clk(clk),.Clk_sft(shift),.Rst(rst),.Sdr_init_done(init),.Sdr_init_ref_vld(refresh),.Sdr_busy(busy),
  .App_wr_en(wen),.App_wr_addr(wa),.App_wr_dm(dm),.App_wr_din(wd),
  .App_rd_en(ren),.App_rd_addr(ra),.Sdr_rd_en(rv),.Sdr_rd_dout(rd));
 integer reads=0,cycles=0,file,golden,b,i,refreshes=0;
 reg started=0,corrupt=0;
 function [31:0] pattern;input integer addr;begin pattern=32'h93a50000^(addr*32'h0103070b);end endfunction
 always @(posedge clk)begin
  cycles=cycles+1;
  if(refresh===1)refreshes=refreshes+1;
  if(started)begin
   $fdisplay(file,"%0d,%b,%h,%b,%h,%b,%b",cycles,ren,ra,rv,rd,busy,refresh);
   if(rv===1)reads=reads+1;
  end
 end
 task write_burst;
 input integer base,count;input [3:0] mask;input [31:0] xor_mask;
 integer j;
 begin
  wait(busy===0);
  for(j=0;j<count;j=j+1)begin
   @(negedge clk);wen=1;wa=base+j;dm=mask;wd=pattern(base+j)^xor_mask;
   if(corrupt && base==0 && j==20 && mask==0)wd=wd^32'h00000001;
  end
  @(negedge clk);wen=0;repeat(50)@(negedge clk);wait(busy===0);
 end endtask
 task read_burst;
 input integer base,count;input [31:0] xor_mask;
 integer j;
 begin
  wait(busy===0);
  for(j=0;j<count;j=j+1)begin
   @(negedge clk);ren=1;ra=base+j;
   $fdisplay(golden,"%h,%h",base+j,pattern(base+j)^xor_mask);
  end
  @(negedge clk);ren=0;repeat(50)@(negedge clk);wait(busy===0);
 end endtask
 initial begin
  corrupt=$test$plusargs("corrupt_data");
  file=$fopen("controller_memory.csv","w");golden=$fopen("expected.csv","w");
  if(file==0 || golden==0)$fatal(1,"cannot open controller evidence");
  $display("BOUNDARY unmodified production controller gate/PADs, APUG011 pin model, nominal clocks; no SDF");
  repeat(100)@(negedge clk);rst=0;
  wait(init===1);$display("MEM_INIT t_ns=%0.3f",$realtime);
  repeat(50)@(negedge clk);wait(busy===0);started=1;
  write_burst(0,256,0,0);read_burst(0,256,0);
  for(b=0;b<4;b=b+1)write_burst((b<<19)+256,64,0,0);
  for(b=0;b<4;b=b+1)read_burst((b<<19)+256,64,0);
  write_burst(0,32,4'b1010,32'hffffffff);
  read_burst(0,32,32'h00ff00ff);
  // Allow real refresh cycles, then verify retention and row/bank reopening.
  repeat(5000)@(negedge clk);
  read_burst(32,224,0);
  for(b=0;b<4;b=b+1)read_burst((b<<19)+256,64,0);
  $fclose(file);$fclose(golden);
  if(reads!=1024 || refreshes==0)$fatal(1,"controller coverage reads=%0d refresh_cycles=%0d",reads,refreshes);
  $display("CONTROLLER_TRACE_COMPLETE valid_words=%0d refresh_cycles=%0d independent content check required",reads,refreshes);$finish;
 end
 initial begin #10000000;$fatal(1,"controller timeout init=%b busy=%b reads=%0d",init,busy,reads);end
 initial begin repeat(10)begin #1000000;$display("CONTROLLER_PROGRESS t_ns=%0.0f init=%b busy=%b",$realtime,init,busy);end end
endmodule
