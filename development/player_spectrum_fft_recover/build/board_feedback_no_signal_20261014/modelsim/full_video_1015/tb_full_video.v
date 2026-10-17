`timescale 1ns/1ps
module tb_full_video;
 reg clk=0,rst_n=0;
 wire hp,d0,d1,d2,sdclk,mosi,cs,dio,rclk,sclk;
 wire [3:0] led;
 top dut(.clk(clk),.rst_n(rst_n),.key1(1'b1),.key2(1'b1),.sd_miso(1'b1),
 .HDMI_CLK_P(hp),.HDMI_D0_P(d0),.HDMI_D1_P(d1),.HDMI_D2_P(d2),.led(led),
 .sd_dclk(sdclk),.sd_mosi(mosi),.sd_ncs(cs),.seg7_dio(dio),.seg7_rclk(rclk),.seg7_sclk(sclk));
 always #10 clk=~clk;
 wire pclk=dut.\u_status_monitor/sys_clk ;
 wire rst=dut.\u_status_monitor/startup_flags [1];
 wire valid=dut.\u_adjust_osd/de_prev ;
 wire [23:0] fft_frames=dut.\u_pcm_waveform/spectrum_debug_frames ;
 integer cycles=0,beats=0,sofs=0,audio=0,runlen=0,lines=0,errors=0;
 reg prev_valid=0,prev_user=0;
 always @(posedge pclk) begin
  if(!rst) begin
   cycles=cycles+1;
   if(valid===1'b1)begin beats=beats+1;runlen=runlen+1;end
   else if(valid===1'b0 && prev_valid) begin
    lines=lines+1;
    if(runlen!=640) begin errors=errors+1;$display("BAD_LINE n=%0d len=%0d",lines,runlen);end
    runlen=0;
   end
   if(dut.axis_s_user && !prev_user) begin
    sofs=sofs+1;
    $display("SOF n=%0d cycle=%0d beats=%0d lines=%0d locked=%b fft_frames=%h",sofs,cycles,beats,lines,dut.hdmi_video_locked,fft_frames);
   end
   if(dut.\u_audio_probe/audio_valid )audio=audio+1;
   if(cycles%100000==0) $display("PROGRESS cycles=%0d beats=%0d sofs=%0d lines=%0d audio=%0d lock=%b fft=%h progress=%h accepted=%h",cycles,beats,sofs,lines,audio,dut.hdmi_video_locked,fft_frames,dut.\u_pcm_waveform/u_spectrum/debug_progress ,dut.\u_pcm_waveform/u_spectrum/debug_accepted );
   if(sofs>=4) begin
    if(dut.hdmi_video_locked!==1'b1 || lines!=1440 || errors!=0 || audio<2000 || fft_frames===0 || (^fft_frames===1'bx))
      $display("FAIL full_video cycles=%0d beats=%0d lines=%0d errors=%0d audio=%0d locked=%b fft_frames=%h",cycles,beats,lines,errors,audio,dut.hdmi_video_locked,fft_frames);
    else $display("PASS full_video cycles=%0d beats=%0d lines=%0d errors=%0d audio=%0d locked=%b fft_frames=%h",cycles,beats,lines,errors,audio,dut.hdmi_video_locked,fft_frames);
    $finish;
   end
  end
  prev_valid=valid;prev_user=dut.axis_s_user;
 end
 always @(dut.hdmi_video_locked) $display("LOCK t=%0t value=%b",$time,dut.hdmi_video_locked);
 initial begin
  #200 rst_n=1;
  #2000;force dut.sys_pll_lock=1'b1;force dut.video_pll_lock=1'b1;
  #2000;force dut.rst_cnt=20'd1000000;
  #100;release dut.rst_cnt;
  #2000;force dut.\u_audio_probe/tone_mode =1'b1;
  $display("BOUNDARY PLL_READY forced; startup_wait skipped; tone_mode selected; full routed video/FFT/PHY logic retained; SD_MISO high/no card model; no SDF");
 end
 initial begin #60000000;$display("FAIL timeout cycles=%0d sofs=%0d lines=%0d locked=%b fft=%h",cycles,sofs,lines,dut.hdmi_video_locked,fft_frames);$finish;end
endmodule
