`timescale 1ns/1ps
module tb_routed_capture;
 reg clk=0,rst_n=0,stim_valid=0;
 wire hp,d0,d1,d2,sdclk,mosi,cs,dio,rclk,sclk;
 wire [3:0] led;
 top dut(.clk(clk),.rst_n(rst_n),.key1(1'b1),.key2(1'b1),.sd_miso(1'b1),
 .HDMI_CLK_P(hp),.HDMI_D0_P(d0),.HDMI_D1_P(d1),.HDMI_D2_P(d2),.led(led),
 .sd_dclk(sdclk),.sd_mosi(mosi),.sd_ncs(cs),.seg7_dio(dio),.seg7_rclk(rclk),.seg7_sclk(sclk));
 always #10 clk=~clk;
 wire pclk=dut.\u_status_monitor/sys_clk ;
 wire [23:0] progress=dut.\u_pcm_waveform/u_spectrum/debug_progress ;
 wire [23:0] accepted=dut.\u_pcm_waveform/u_spectrum/debug_accepted ;
 integer i,errors=0;
 initial begin
  #200 rst_n=1;
  #2000; force dut.sys_pll_lock=1'b1;force dut.video_pll_lock=1'b1;
  #2000; force dut.rst_cnt=20'd1000000;
  #100; release dut.rst_cnt;
  #2000; force dut.\u_audio_probe/tone_mode =1'b1;
  force dut.\u_audio_probe/audio_valid =stim_valid;
  #1000;
  for(i=1;i<=1024;i=i+1) begin
   @(negedge pclk);stim_valid=1;
   @(posedge pclk);#15;
   if(accepted!==i) begin
    if(errors<5)$display("FAIL accepted i=%0d q=%h progress=%h",i,accepted,progress);
    errors=errors+1;
   end
   if(i<1024 && (progress[23:19]!==0 || progress[18:9]!==i))begin
    if(errors<5)$display("FAIL capture i=%0d progress=%h",i,progress);errors=errors+1;
   end
  end
  @(negedge pclk);stim_valid=0;
  $display("CAPTURE_RESULT accepted=%h progress=%h errors=%0d",accepted,progress,errors);
  if(errors!=0 || progress[23:19]!==5'd1)begin $display("FAIL routed_capture");$finish;end
  $display("PASS routed_capture all1024_accepted state_entered_window=1");
  $finish;
 end
 initial begin #100000; $display("FAIL capture timeout");$finish;end
endmodule
