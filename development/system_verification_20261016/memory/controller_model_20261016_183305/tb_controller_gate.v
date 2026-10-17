`timescale 1ns/1ps
module tb_controller_gate;
 reg clk=0,shift=0,rst=1;
 // Nominal production 50MHz clocks, shifted clock delayed 8ns (144 degrees).
 always #10 clk=~clk;
 initial begin #8;forever #10 shift=~shift;end
 reg wen=0,ren=0;
 reg [20:0] wa=0,ra=0;
 reg [31:0] wd=0;
 wire init,refresh,busy,rv;
 wire [31:0] rd;
 sdram dut(.Clk(clk),.Clk_sft(shift),.Rst(rst),.Sdr_init_done(init),.Sdr_init_ref_vld(refresh),.Sdr_busy(busy),
  .App_wr_en(wen),.App_wr_addr(wa),.App_wr_dm(4'b0),.App_wr_din(wd),
  .App_rd_en(ren),.App_rd_addr(ra),.Sdr_rd_en(rv),.Sdr_rd_dout(rd));
 integer i,reads=0,cycles=0,file;
 reg started=0;
 function [31:0] pattern;input integer addr;begin pattern=32'h93a50000^(addr*32'h0103070b);end endfunction
 always @(posedge clk)begin
  cycles=cycles+1;
  if(started)begin
   // Pre-NBA: values seen by production consumers on this rising edge.
   $fdisplay(file,"%0d,%b,%h,%b,%h,%b,%b",cycles,ren,ra,rv,rd,busy,refresh);
   if(rv===1)begin
    if(reads<8)$display("MEM_WORD index=%0d data=%h t_ns=%0.3f",reads,rd,$realtime);
    reads=reads+1;
   end
  end
 end
 initial begin
  file=$fopen("controller_memory.csv","w");if(file==0)$fatal(1,"cannot open memory trace");
  $display("BOUNDARY production controller synthesized gate, vendor PAD models, APUG011 IS42s32200 pin model; no SDF, nominal clocks");
  repeat(100)@(negedge clk);rst=0;
  wait(init===1);$display("MEM_INIT t_ns=%0.3f",$realtime);
  repeat(50)@(negedge clk);wait(busy===0);
  for(i=0;i<256;i=i+1)begin @(negedge clk);wen=1;wa=i;wd=pattern(i);end
  @(negedge clk);wen=0;
  repeat(100)@(negedge clk);wait(busy===0);started=1;
  for(i=0;i<256;i=i+1)begin @(negedge clk);ren=1;ra=i;end
  @(negedge clk);ren=0;
  repeat(100)@(negedge clk);$fclose(file);
  if(reads!=256)$fatal(1,"expected 256 valid words got %0d",reads);
  $display("CONTROLLER_TRACE_COMPLETE valid_words=%0d independent content check required",reads);$finish;
 end
 initial begin #2000000;$fatal(1,"controller timeout init=%b busy=%b reads=%0d",init,busy,reads);end
endmodule
