`timescale 1ns/1ps
module tb_video_framebuffer;
 reg memclk=0,shift=0,wclk=0,rclk=0,rst=1;
 always #10 memclk=~memclk;
 initial begin #8;forever #10 shift=~shift;end
 initial begin #3;forever #10 wclk=~wclk;end
 initial begin #7;forever #20 rclk=~rclk;end
 reg wreq=0,wvalid=0,rreq=0,ren=0;
 reg [23:0] wrgb=0;
 wire wack,wready,finish,rack;
 wire [23:0] rgb;
 frame_buffer_rgb888 dut(.rst(rst),.mem_clk(memclk),.mem_clk_shift(shift),
 .write_clk(wclk),.write_req(wreq),.write_req_ack(wack),.write_frame_index(2'b1),
 .write_jpeg420(1'b1),.write_pixel_en(wvalid),.write_pixel_rgb(wrgb),
 .write_pixel_ready(wready),.write_finish(finish),
 .read_clk(rclk),.read_req(rreq),.read_req_ack(rack),.read_frame_index(2'b1),
 .read_jpeg420(1'b1),.read_wipe_active(1'b0),.read_wipe_rows(9'd0),
 .read_wipe_new_index(2'b0),.read_pixel_en(ren),.read_pixel_rgb(rgb));
 integer n,x,y,mx,my,part,row,col,checks=0,commits=0,writes=0,reads=0;
 integer burst_length=0,burst_count=0,max_stall=0,stall=0;
 reg previous_wen=0;
 reg background=0;
 integer bg_x=0;
 function [23:0] pixel;
 input integer px,py;
 reg [7:0] r,g,b;
 begin
 r=px*17+py*3;g=px*5+py*11;b=px*7+py*19;
 pixel={r[7:3],r[7:5],g[7:2],g[7:6],b[7:3],b[7:5]};
 end
 endfunction
 always @(posedge finish)commits=commits+1;
 always @(negedge rclk)if(background)begin ren=bg_x<640;bg_x=(bg_x+1)%800;end
 always @(posedge memclk)begin
 if(dut.app_write_en)begin
 writes=writes+1;burst_length=burst_length+1;
 if(dut.app_read_en)$fatal(1,"overlapping memory commands");
 end
 if(previous_wen && !dut.app_write_en)begin
 if(burst_length!=4)$fatal(1,"short burst length %0d",burst_length);
 burst_count=burst_count+1;burst_length=0;
 end
 previous_wen=dut.app_write_en;
 if(dut.mem_read_valid)reads=reads+1;
 end
 initial begin
 repeat(100)@(negedge memclk);rst=0;wait(dut.init_done===1);
 @(negedge rclk);rreq=1;wait(rack===1);
 @(negedge rclk);rreq=0;wait(rack===0);background=1;
 @(negedge wclk);wreq=1;wait(wack===1);
 @(negedge wclk);wreq=0;wait(wack===0);
 for(n=0;n<307200;n=n+1)begin
 my=n/10240;mx=(n%10240)/256;part=(n%256)/64;
 row=(n%64)/8;col=n%8;x=mx*16+(part%2)*8+col;y=my*16+(part/2)*8+row;
 @(negedge wclk);stall=0;
 while(wready!==1)begin @(negedge wclk);stall=stall+1;end
 if(stall>max_stall)max_stall=stall;
 wrgb=pixel(x,y);wvalid=1;
 @(negedge wclk);wvalid=0;
 if(n%4096==0)$display("WRITE_PROGRESS n=%0d words=%0d burst=%0d t=%0t",n,writes,burst_count,$time);
 end
 wait(commits==1);background=0;@(negedge rclk);ren=0;
 if(writes!=153600 || burst_count!=38400)$fatal(1,"write count words=%0d bursts=%0d",writes,burst_count);
 // Restart at the committed frame after controller pipeline completion.
 repeat(100)@(negedge rclk);
 @(negedge rclk);rreq=1;wait(rack===1);
 @(negedge rclk);rreq=0;wait(rack===0);repeat(100)@(negedge rclk);
 for(y=0;y<480;y=y+1)begin
 for(x=0;x<800;x=x+1)begin
 @(negedge rclk);ren=x<640;
 @(posedge rclk);#1;
 if(ren)begin
 if(rgb!==pixel(x,y))$fatal(1,"GATE_FRAME_RGB x=%0d y=%0d got=%h expected=%h",x,y,rgb,pixel(x,y));
 if(dut.read_underflow)$fatal(1,"read underflow x=%0d y=%0d",x,y);
 checks=checks+1;
 end
 end
 end
 $display("VIDEO_GATE_FRAMEBUFFER_PASS pixels=%0d words=%0d bursts=%0d reads=%0d max_stall=%0d",checks,writes,burst_count,reads,max_stall);
 $finish;
 end
 initial begin #150000000;$fatal(1,"gate framebuffer timeout n=%0d words=%0d commits=%0d",n,writes,commits);end
endmodule
