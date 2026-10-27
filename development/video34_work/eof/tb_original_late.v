`timescale 1ns/1ps
module tb_original_late;
 reg clk=0; always #5 clk=~clk;
 reg rst=1,start=0,img_end=0,sob=0,eob=0;
 wire [31:0] id; wire [1:0] bt; wire eof;
 integer k;
 jpeg_mcu_id dut(.clk_i(clk),.rst_i(rst),.img_start_i(start),.img_end_i(img_end),
  .img_width_i(16'd16),.img_height_i(16'd16),.img_mode_i(2'd2),
  .start_of_block_i(sob),.end_of_block_i(eob),.block_id_o(id),.block_type_o(bt),.end_of_image_o(eof));
 initial begin
  repeat(3) @(negedge clk);rst=0;start=1;@(negedge clk);start=0;
  for(k=0;k<6;k=k+1) begin
   @(negedge clk);sob=1;
   @(negedge clk);sob=0;
   if(k==5) img_end=1; // EOI arrives after the final CR block has started.
   eob=1;@(negedge clk);eob=0;
   if(k<5 && eof) $fatal(1,"baseline ended early at block %0d",k);
  end
  if(eof) $fatal(1,"baseline unexpectedly recognized EOI after final CR start");
  $display("BASELINE_FIRST_DIVERGENCE block=5(final CR) end_of_image remains 0 after its EOB");
  $finish;
 end
 initial begin #100000;$fatal(1,"baseline compare timeout");end
endmodule
