`timescale 1ns/1ps
module tb_video_full_cone;
 reg clk=0,rst=1;
 wire locked,user,valid,pause;
 video_full_cone dut(.clk(clk),.rst(rst),.locked(locked),.user(user),.valid(valid),.pause(pause));
 always #20 clk=~clk;
 integer cycles=0,beats=0,sofs=0,lines=0,runlen=0,errors=0;
 reg prev_valid=0,prev_user=0;
 always @(posedge clk)begin
  if(!rst)begin
   cycles=cycles+1;
   if(valid)begin beats=beats+1;runlen=runlen+1;end
   if(!valid && prev_valid)begin
    lines=lines+1;
    if(runlen!=640)begin errors=errors+1;$display("BAD_LINE %0d len=%0d",lines,runlen);end
    runlen=0;
   end
   if(user && !prev_user)begin
    sofs=sofs+1;
    $display("SOF n=%0d cycles=%0d beats=%0d lines=%0d lock=%b pause=%b",sofs,cycles,beats,lines,locked,pause);
   end
   if(cycles%200000==0)$display("VIDEO_PROGRESS cycles=%0d sofs=%0d lines=%0d lock=%b",cycles,sofs,lines,locked);
   if(sofs>=4)begin
    if(locked!==1 || lines!=1440 || errors!=0 || beats!=921601)$display("FAIL video_full_cone lock=%b lines=%0d beats=%0d errors=%0d",locked,lines,beats,errors);
    else $display("PASS video_full_cone lock=1 full_lines=1440 complete_pixels=921600 next_frame_first_pixel=1 errors=0");
    $finish;
   end
  end
  prev_valid=valid;prev_user=user;
 end
 initial begin repeat(20)@(negedge clk);rst=0;$display("BOUNDARY clk25MHz and global reset only; real gate video source timing/valid/user and complete lock control preserved; no pixel data/FIFO/PHY/SDF");end
 initial begin #60000000;$display("FAIL timeout cycles=%0d sofs=%0d lines=%0d lock=%b",cycles,sofs,lines,locked);$finish;end
endmodule
