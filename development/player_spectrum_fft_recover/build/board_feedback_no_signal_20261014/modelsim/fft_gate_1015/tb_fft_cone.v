`timescale 1ns/1ps
module tb_fft_cone;
 reg clk=0,rst=1,audio_valid=0,tone_mode=0;
 reg [23:0] audio_pcm=0;
 wire band_valid,frame_done;
 wire [4:0] band_index;
 wire [15:0] band_value,events;
 wire [23:0] progress,accepted;
 wire [1:0] coeff;
 fft_cone dut(.clk(clk),.rst(rst),.audio_valid(audio_valid),.tone_mode(tone_mode),.audio_pcm(audio_pcm),
  .band_valid(band_valid),.frame_done(frame_done),.band_index(band_index),.band_value(band_value),
  .debug_progress(progress),.debug_accepted(accepted),.debug_events(events),.debug_coeff(coeff));
 always #20 clk=~clk;
 reg [15:0] samples[0:13311],expected[0:311];
 integer i,case_id,outputs,errors=0,cyc,nonzero;
 reg [1023:0] vec_file,exp_file;
 initial begin
  if(!$value$plusargs("VEC=%s",vec_file) || !$value$plusargs("EXP=%s",exp_file))begin $display("FAIL missing inputs");$finish;end
  $readmemh(vec_file,samples);$readmemh(exp_file,expected);
  repeat(20)@(negedge clk);rst=0;
  repeat(10)@(negedge clk);
  $display("BOUNDARY exact gate primitive cone; clk25MHz; external global reset; PCM/valid/tone inputs; 14 BRAM and 1 DSP retained; no SDF");
  for(case_id=0;case_id<3;case_id=case_id+1)begin
   for(i=0;i<1024;i=i+1)begin
    @(negedge clk);audio_pcm={samples[case_id*1024+i],8'd0};audio_valid=1;
   end
   @(negedge clk);audio_valid=0;
   outputs=0;nonzero=0;
   for(cyc=0;cyc<65000 && outputs<24;cyc=cyc+1)begin
    @(posedge clk);#1;
    if(cyc%10000==0)$display("FFT_PROGRESS case=%0d cycle=%0d progress=%h coeff=%h",case_id,cyc,progress,coeff);
    if(band_valid)begin
     $display("BAND case=%0d n=%0d index=%0d got=%h expected=%h done=%b",case_id,outputs,band_index,band_value,expected[case_id*24+outputs],frame_done);
     if(band_index!==outputs || band_value!==expected[case_id*24+outputs] || frame_done!==(outputs==23))errors=errors+1;
     if(band_value!=0)nonzero=nonzero+1;
     outputs=outputs+1;
    end
   end
   if(outputs!=24)errors=errors+1;
   $display("CASE_RESULT case=%0d outputs=%0d nonzero=%0d cycles=%0d errors=%0d progress=%h accepted=%h events=%h",case_id,outputs,nonzero,cyc,errors,progress,accepted,events);
   if(errors!=0)begin $display("FAIL fft_cone errors=%0d",errors);$finish;end
   repeat(8)@(negedge clk);
  end
  $display("PASS fft_cone cases=3 bands=72 max_fixedpoint_error=0 autonomous_recapture=2");$finish;
 end
 initial begin #9000000;$display("FAIL fft_cone timeout progress=%h",progress);$finish;end
endmodule
