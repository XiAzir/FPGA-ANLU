`timescale 1ns/1ps
module tb_routed_smoke;
 reg clk=0, rst_n=0;
 wire hp,d0,d1,d2,sdclk,mosi,cs,dio,rclk,sclk;
 wire [3:0] led;
 top dut(.clk(clk),.rst_n(rst_n),.key1(1'b1),.key2(1'b1),.sd_miso(1'b1),
  .HDMI_CLK_P(hp),.HDMI_D0_P(d0),.HDMI_D1_P(d1),.HDMI_D2_P(d2),.led(led),
  .sd_dclk(sdclk),.sd_mosi(mosi),.sd_ncs(cs),.seg7_dio(dio),.seg7_rclk(rclk),.seg7_sclk(sclk));
 always #10 clk=~clk;
 wire pclk=dut.\u_status_monitor/sys_clk ;
 wire rst=dut.\u_status_monitor/startup_flags [1];
 wire [23:0] progress=dut.\u_pcm_waveform/u_spectrum/debug_progress ;
 wire [23:0] accepted=dut.\u_pcm_waveform/u_spectrum/debug_accepted ;
 wire [23:0] events=dut.\u_pcm_waveform/u_spectrum/debug_events ;
 wire [23:0] fft_frames=dut.\u_pcm_waveform/spectrum_debug_frames ;
 wire audio=dut.\u_audio_probe/audio_valid ;
 integer pulses=0, pixel_cycles=0,sof=0;
 always @(posedge pclk) begin
   pixel_cycles=pixel_cycles+1;
   if(!rst && audio) begin
     pulses=pulses+1;
     if(pulses<20 || pulses%128==0) begin
       #1; $display("PCM t=%0t n=%0d progress=%h accepted=%h events=%h fft=%h",$time,pulses,progress,accepted,events,fft_frames);
     end
   end
   if(!rst && dut.axis_s_user) begin
     sof=sof+1; $display("SOF t=%0t n=%0d locked=%b",$time,sof,dut.hdmi_video_locked);
   end
 end
 always @(dut.hdmi_video_locked) $display("LOCK t=%0t value=%b",$time,dut.hdmi_video_locked);
 initial begin
   #200 rst_n=1;
   // Testbench-only fast startup: preserve reset distribution and release logic,
   // skip the one-million-reference-clock wait. No TF card or receiver model.
   // Boundary stimulus for logic-only verification: PLL output clocks run,
   // assert their ready inputs explicitly; this does not test analog PLL lock.
   #2000;
   force dut.sys_pll_lock=1'b1;
   force dut.video_pll_lock=1'b1;
   #2000;
   $display("STARTUP t=%0t flags=%h pll=%b%b count=%h pclk=%0d",$time,dut.\u_status_monitor/startup_flags ,dut.sys_pll_lock,dut.video_pll_lock,dut.rst_cnt,pixel_cycles);
   force dut.rst_cnt=20'd1000000;
   #100; release dut.rst_cnt;
   #2000;
   force dut.\u_audio_probe/tone_mode =1'b1;
   $display("TONE t=%0t rst=%b progress=%h",$time,rst,progress);
   #100000;
   $display("RESULT smoke pclk=%0d pulses=%0d SOF=%0d locked=%b progress=%h accepted=%h events=%h fft=%h",pixel_cycles,pulses,sof,dut.hdmi_video_locked,progress,accepted,events,fft_frames);
   $finish;
 end
 initial begin
  #200000; $display("TIMEOUT"); $finish;
 end
endmodule
