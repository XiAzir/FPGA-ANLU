`timescale 1ns/1ps
module tb_fft_gate;
 reg clk=0,rst_n=0,stim_valid=0;
 reg [23:0] stim_pcm=0;
 wire hp,d0,d1,d2,sdclk,mosi,cs,dio,rclk,sclk;
 wire [3:0] led;
 top dut(.clk(clk),.rst_n(rst_n),.key1(1'b1),.key2(1'b1),.sd_miso(1'b1),
 .HDMI_CLK_P(hp),.HDMI_D0_P(d0),.HDMI_D1_P(d1),.HDMI_D2_P(d2),.led(led),
 .sd_dclk(sdclk),.sd_mosi(mosi),.sd_ncs(cs),.seg7_dio(dio),.seg7_rclk(rclk),.seg7_sclk(sclk));
 always #10 clk=~clk;
 wire pclk=dut.\u_status_monitor/sys_clk ;
 wire [23:0] progress=dut.\u_pcm_waveform/u_spectrum/debug_progress ;
 wire [15:0] band=dut.\u_pcm_waveform/u_spectrum/band_value ;
 wire [4:0] index=dut.\u_pcm_waveform/u_spectrum/band_index ;
 wire valid=dut.\u_pcm_waveform/band_valid ;
 wire done=dut.\u_pcm_waveform/frame_done ;
 reg [15:0] samples[0:13311];
 reg [15:0] expected[0:311];
 integer i,case_id,outputs=0,errors=0,cyc,nonzero=0;
 reg [1023:0] vec_file,exp_file;
 initial begin
  if(!$value$plusargs("VEC=%s",vec_file) || !$value$plusargs("EXP=%s",exp_file))begin $display("FAIL missing inputs");$finish;end
  $readmemh(vec_file,samples);$readmemh(exp_file,expected);
  #200 rst_n=1;
  #2000;force dut.sys_pll_lock=1'b1;force dut.video_pll_lock=1'b1;
  #2000;force dut.rst_cnt=20'd1000000;
  #100;release dut.rst_cnt;
  #2000;force dut.\u_audio_probe/tone_mode =1'b1;
  force dut.\u_audio_probe/audio_valid =stim_valid;
  force dut.audio_left_data=stim_pcm;
  #1000;
  $display("BOUNDARY forced PLL ready / fast startup / selected tone / PCM and valid only; real routed FSM RAM DSP ROM retained; no SDF");
  for(case_id=0;case_id<3;case_id=case_id+1) begin
   for(i=0;i<1024;i=i+1)begin
    @(negedge pclk);stim_pcm={samples[case_id*1024+i],8'd0};stim_valid=1;
   end
   @(negedge pclk);stim_valid=0;
   outputs=0;nonzero=0;
   for(cyc=0;cyc<65000 && outputs<24;cyc=cyc+1)begin
    @(posedge pclk);#15;
    if(cyc%10000==0) $display("FFT_PROGRESS case=%0d cycle=%0d progress=%h coeff=%h",case_id,cyc,progress,dut.\u_pcm_waveform/u_spectrum/debug_coeff_nonzero );
    if(valid)begin
     $display("BAND case=%0d n=%0d index=%0d got=%h expected=%h done=%b",case_id,outputs,index,band,expected[case_id*24+outputs],done);
     if(index!==outputs || band!==expected[case_id*24+outputs] || done!==(outputs==23))errors=errors+1;
     if(band!=0)nonzero=nonzero+1;
     outputs=outputs+1;
    end
   end
   if(outputs!=24)errors=errors+1;
   $display("CASE_RESULT case=%0d outputs=%0d nonzero=%0d cycles=%0d errors=%0d progress=%h",case_id,outputs,nonzero,cyc,errors,progress);
   if(errors!=0)begin $display("FAIL fft_gate errors=%0d",errors);$finish;end
   repeat(8)@(negedge pclk);
  end
  $display("PASS fft_gate cases=3 bands=72 max_fixedpoint_error=0 autonomous_recapture=2");$finish;
 end
 initial begin #9000000;$display("FAIL fft_gate timeout progress=%h",progress);$finish;end
endmodule
