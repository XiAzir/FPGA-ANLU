`timescale 1ns/1ps
module tb_framebuffer;
 reg memclk=0,wclk=0,rclk=0,rst=1;
 always #10 memclk=~memclk;
 initial begin #3;forever #10 wclk=~wclk;end
 initial begin #7;forever #20 rclk=~rclk;end
 reg wreq=0,wvalid=0,rreq=0,ren=0;
 reg [23:0] wrgb=0;
 wire wack,wready,finish,rack;
 wire [23:0] rgb;
 frame_buffer_rgb888 dut(.rst(rst),.mem_clk(memclk),.mem_clk_shift(~memclk),
 .write_clk(wclk),.write_req(wreq),.write_req_ack(wack),.write_frame_index(2'b0),
 .write_pixel_en(wvalid),.write_pixel_rgb(wrgb),.write_pixel_ready(wready),.write_finish(finish),
 .read_clk(rclk),.read_req(rreq),.read_req_ack(rack),.read_frame_index(2'b0),
 .read_wipe_active(1'b0),.read_wipe_rows(9'b0),.read_wipe_new_index(2'b0),
 .read_pixel_en(ren),.read_pixel_rgb(rgb));
 integer n,x,y,checks=0,commits=0;
 function[23:0] pixel;
 input integer px,py;
 begin pixel={8'((px*17+py*3)%256),8'((px*5+py*11)%256),8'((px*7+py*19)%256)};end
 endfunction
 always @(posedge finish)commits=commits+1;
 initial begin
  $display("BOUNDARY full 640x480 real frame backend/FIFOs/codec, explicit application memory contract, no physical SDRAM model");
  repeat(10)@(negedge memclk);rst=0;
  wait(dut.init_done===1);@(negedge wclk);wreq=1;
  wait(wack===1);@(negedge wclk);wreq=0;wait(wack===0);
  for(n=0;n<307200;n=n+1)begin
   @(negedge wclk);while(wready!==1)@(negedge wclk);
   wrgb=pixel(n%640,479-n/640);wvalid=1;
   @(negedge wclk);wvalid=0;
   repeat(8)@(negedge wclk);
  end
  wait(commits==1);
  if(dut.u_sdram.write_count!=230400)$fatal(1,"memory write count %0d",dut.u_sdram.write_count);
  if($test$plusargs("corrupt"))begin
   dut.u_sdram.pages[0][0]=~dut.u_sdram.pages[0][0];
   $display("NEGATIVE injected one stored RGB byte bit at first pixel");
  end
  @(negedge rclk);rreq=1;wait(rack===1);
  @(negedge rclk);rreq=0;wait(rack===0);repeat(50)@(negedge rclk);
  for(y=0;y<480;y=y+1)begin
   for(x=0;x<800;x=x+1)begin
    @(negedge rclk);ren=x<640;
    @(posedge rclk);#1;
    if(ren)begin
     if(rgb!==pixel(x,y))$fatal(1,"FRAME_GOLD_MISMATCH x=%0d y=%0d got=%h want=%h",x,y,rgb,pixel(x,y));
     if(dut.read_underflow)$fatal(1,"read underflow");
     checks=checks+1;
    end
   end
  end
  @(negedge rclk);ren=0;
  if(checks!=307200 || dut.u_sdram.read_count!=230400)$fatal(1,"pixel/read counts mismatch");
  $display("FRAMEBUFFER_DATA_PASS pixels=%0d writes=%0d reads=%0d",checks,dut.u_sdram.write_count,dut.u_sdram.read_count);$finish;
 end
 initial begin #120000000;$fatal(1,"framebuffer timeout writes=%0d commits=%0d",dut.u_sdram.write_count,commits);end
endmodule
