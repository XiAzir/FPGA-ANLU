`timescale 1ns/1ps
module tb_mcu_eof;
 reg clk=0; always #5 clk=~clk;

 reg rst=1,img_start=0,img_end=0;
 reg [15:0] width=16,height=16;
 reg [1:0] mode=2;
 reg sob=0,eob=0;
 wire [31:0] block_id;
 wire [1:0] block_type;
 wire end_image;
 integer i;
 reg geometry_done=0,protocol_done=0;
 jpeg_mcu_id u_id(.clk_i(clk),.rst_i(rst),.img_start_i(img_start),.img_end_i(img_end),
  .img_width_i(width),.img_height_i(height),.img_mode_i(mode),
  .start_of_block_i(sob),.end_of_block_i(eob),.block_id_o(block_id),
  .block_type_o(block_type),.end_of_image_o(end_image));

 reg prst=1,pstart=0,pimg_end=1,pblk_space=0;
 wire [5:0] ppop,pidx; wire preq,pvalid,peob;
 wire [1:0] ptable; wire [15:0] pinput,pdata;
 wire [31:0] pid;
 wire [4:0] pwidth; wire [7:0] pvalue;
 integer eof_samples=0,eof_eobs=0;
 jpeg_mcu_proc u_proc(.clk_i(clk),.rst_i(prst),.img_start_i(pstart),.img_end_i(pimg_end),
  .img_width_i(16'd16),.img_height_i(16'd16),.img_mode_i(2'd2),
  .inport_valid_i(1'b0),.inport_data_i(32'b0),.inport_last_i(1'b0),
  .lookup_valid_i(1'b0),.lookup_width_i(5'b0),.lookup_value_i(8'b0),
  .outport_blk_space_i(pblk_space),.inport_pop_o(ppop),.lookup_req_o(preq),
  .lookup_table_o(ptable),.lookup_input_o(pinput),.outport_valid_o(pvalid),
  .outport_data_o(pdata),.outport_idx_o(pidx),.outport_id_o(pid),.outport_eob_o(peob));

 always @(posedge clk) begin
  if(!prst) begin
   if(pvalid) begin
    eof_samples<=eof_samples+1;
    if(!peob || pidx!=0 || pid[31:30]!=2'd3) $fatal(1,"bad EOF sample eob=%b idx=%0d id=%h",peob,pidx,pid);
   end
   if(peob) eof_eobs<=eof_eobs+1;
  end
 end

 task frame_start(input [1:0] m,input [15:0] w,input [15:0] h);
 begin
  @(negedge clk);mode=m;width=w;height=h;img_start=1;
  @(negedge clk);img_start=0;
  if(end_image || block_type!=0) $fatal(1,"img_start failed to reset MCU ID");
 end endtask

 task feed_block(input integer k,input integer blocks,input integer eoi_phase,input [1:0] m);
 integer expected_type;
 begin
  if(m==2) begin
   if(k%6<4) expected_type=0;
   else expected_type=(k%6)-3;
  end
  else if(m==1) expected_type=k%3;
  else expected_type=0;
  @(negedge clk);
  if(eoi_phase==1 && k==0) img_end=1;
  if(eoi_phase==2 && k==blocks-1) img_end=0;
  sob=1;
  @(negedge clk);sob=0;
  if(block_type!=expected_type[1:0]) $fatal(1,"type block=%0d got=%0d expected=%0d",k,block_type,expected_type);
  if(k<blocks-1 && end_image) $fatal(1,"early EOF block=%0d/%0d",k,blocks);
  if(eoi_phase==1 && k==0) img_end=0;
  if(eoi_phase==2 && k==blocks-1) img_end=1; // EOI after the final CR start.
  eob=1;
  @(negedge clk);eob=0;
  if(k<blocks-1 && end_image) $fatal(1,"early EOF after block=%0d/%0d",k,blocks);
  if(k==blocks-1 && !end_image) $fatal(1,"missing geometry EOF on final block %0d",k);
 end endtask

 task run_frame(input [1:0] m,input [15:0] w,input [15:0] h,input integer blocks,input integer eoi_phase);
 integer k;
 begin
  frame_start(m,w,h);
  for(k=0;k<blocks;k=k+1) feed_block(k,blocks,eoi_phase,m);
  @(negedge clk);sob=1; // Processor's next IDLE request for the EOF descriptor.
  @(negedge clk);sob=0;
  if(block_type!=3 || !end_image) $fatal(1,"missing EOF descriptor id type=%0d eof=%b",block_type,end_image);
  img_end=0;
 end endtask

 initial begin
  repeat(4) @(negedge clk);rst=0;prst=0;
  run_frame(2,16,16,6,1);  // EOI before final CR start.
  run_frame(2,16,16,6,2);  // EOI after final CR start, before CR EOB.
  run_frame(2,17,17,24,0); // 4:2:0 edge padded to two 16x16 MCUs.
  run_frame(0,16,16,4,0);  // Monochrome: ceil(width/8)*ceil(height/8).
  run_frame(1,16,16,12,0); // 4:4:4: three blocks per 8x8 MCU.
  run_frame(2,1920,1080,48960,0);
  $display("GEOMETRY PASS 420=6+6+48960 mono=4 444=12");
  geometry_done=1;
 end

 initial begin
  repeat(4) @(negedge clk);prst=0;
  force u_proc.end_of_image_w = 1'b1;
  repeat(8) @(negedge clk);
  if(pvalid || peob || eof_samples!=0) $fatal(1,"EOF ignored block-space backpressure");
  pblk_space=1;
  wait(pvalid);
  @(negedge clk);
  repeat(40) @(negedge clk);
  if(eof_samples!=1 || eof_eobs!=1 || pvalid || peob)
   $fatal(1,"EOF repeated samples=%0d eobs=%0d valid=%b eob=%b",eof_samples,eof_eobs,pvalid,peob);
  pstart=1; release u_proc.end_of_image_w;
  @(negedge clk);pstart=0;pblk_space=0;
  repeat(8) @(negedge clk);
  if(eof_samples!=1 || eof_eobs!=1 || pvalid || peob) $fatal(1,"EOF leaked across img_start");
  force u_proc.end_of_image_w = 1'b1;pblk_space=1;
  wait(eof_samples==2); @(negedge clk);repeat(10) @(negedge clk);
  if(eof_samples!=2 || eof_eobs!=2 || pvalid || peob) $fatal(1,"next frame EOF failed");
  $display("EOF_PROTOCOL PASS single sample/EOB, block-space wait, next frame");
  protocol_done=1;
 end

 initial begin wait(geometry_done && protocol_done); #1; $finish; end
 initial begin #30000000;$fatal(1,"test timeout");end
endmodule
