`timescale 1ns/1ps
module tb_vga60_timing;
 reg clk=0; always #1 clk=~clk; reg reset=1;
 wire hs,vs,de; wire [23:0] rgb; wire [11:0] x; wire [10:0] y;
 wire user,valid,last; wire [23:0] axisdata;
 video_timing_1080p_custom_colorbar #(.H_ACTIVE(640),.H_FRONT(16),.H_SYNC(96),.H_BACK(248),.H_TOTAL(1000),.V_ACTIVE(480),.V_FRONT(10),.V_SYNC(2),.V_BACK(58),.V_TOTAL(550),.HSYNC_ACTIVE_LOW(1),.VSYNC_ACTIVE_LOW(1)) timing(.pixel_clk(clk),.reset(reset),.hsync(hs),.vsync(vs),.de(de),.rgb(rgb),.x(x),.y(y));
 video_axis_1080p_adapter #(.H_ACTIVE(640)) adapter(.pixel_clk(clk),.reset(reset),.de(de),.x(x),.y(y),.rgb(rgb),.axis_user(user),.axis_valid(valid),.axis_last(last),.axis_data(axisdata));
 integer n=0,cde=0,chslo=0,cvslow=0,cuser=0,cvalid=0,clast=0;
 initial begin repeat(3) @(posedge clk); reset=0; repeat(550000) begin @(posedge clk); #0.1; n=n+1; cde=cde+de; chslo=chslo+!hs; cvslow=cvslow+!vs; cuser=cuser+user; cvalid=cvalid+valid; clast=clast+last; end
  $display("C11335 frame clocks=%0d DE=%0d HSyncLow=%0d VSyncLow=%0d AXIS_USER=%0d VALID=%0d LAST=%0d",n,cde,chslo,cvslow,cuser,cvalid,clast);
  if(n!=550000 || cde!=307200 || chslo!=52800 || cvslow!=2000 || cuser!=1 || cvalid!=307200 || clast!=480) $fatal(1,"timing/AXIS mismatch");
  $display("C11335 one-frame timing PASS; 33 MHz / 550000 = 60 fps"); $finish;
 end
endmodule
