`timescale 1ns/1ps
module tb_vendor_memory;
 reg refclk=0,rst=1;
 wire clk,shift,unused,locked;
 sys_pll pll(.refclk(refclk),.reset(1'b0),.extlock(locked),.clk0_out(unused),.clk1_out(clk),.clk2_out(shift));
 always #10 refclk=~refclk;
 reg wen=0,ren=0;
 reg [20:0] wa=0,ra=0;
 reg [31:0] wd=0;
 wire init,refresh,busy,rv;
 wire [31:0] rd;
 sdram dut(.Clk(clk),.Clk_sft(shift),.Rst(rst),.Sdr_init_done(init),.Sdr_init_ref_vld(refresh),.Sdr_busy(busy),
  .App_wr_en(wen),.App_wr_addr(wa),.App_wr_dm(4'b0),.App_wr_din(wd),
  .App_rd_en(ren),.App_rd_addr(ra),.Sdr_rd_en(rv),.Sdr_rd_dout(rd));
 integer i,reads=0,unknowns=0,cycles=0,file;
 reg started=0;
 function [31:0] pattern;input integer addr;begin pattern=32'h93a50000^(addr*32'h0103070b);end endfunction
 always @(posedge clk)begin
  cycles=cycles+1;
  if(started)begin
   $fdisplay(file,"%0d,%b,%h,%b,%h",cycles,ren,ra,rv,rd);
   if(rv===1)begin reads=reads+1;if(^rd===1'bx)unknowns=unknowns+1;end
  end
 end
 initial begin
  file=$fopen("vendor_memory.csv","w");if(file==0)$fatal(1,"cannot open memory trace");
  $display("BOUNDARY original sdram/controller and vendor physical SDRAM model; nominal PLL with documented initialization adapter; no data/valid replacement");
  repeat(100)@(negedge refclk);
  if(locked!==1)$fatal(1,"PLL not locked");rst=0;
  wait(init===1);
  $display("MEM_INIT t_ns=%0.3f",$realtime);
  repeat(50)@(negedge clk);
  wait(busy===0);
  for(i=0;i<256;i=i+1)begin @(negedge clk);wen=1;wa=i;wd=pattern(i);end
  @(negedge clk);wen=0;
  repeat(100)@(negedge clk);
  wait(busy===0);started=1;
  for(i=0;i<256;i=i+1)begin @(negedge clk);ren=1;ra=i;end
  @(negedge clk);ren=0;
  repeat(100)@(negedge clk);
  $fclose(file);
  $display("MEM_RESULT valid_words=%0d unknown_words=%0d",reads,unknowns);
  if(reads!=256 || unknowns!=0)$fatal(1,"vendor memory is not a usable content model");
  $display("MEM_TRACE_COMPLETE needs independent alignment/content comparison");$finish;
 end
 initial begin #2000000;$fatal(1,"vendor memory timeout init=%b busy=%b reads=%0d",init,busy,reads);end
endmodule
