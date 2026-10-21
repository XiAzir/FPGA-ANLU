`timescale 1ns/1ps
module tb_fault_snapshot_fft;
 reg clk=0,rst=1,valid=0,tone=0,axis_user=0,axis_valid=0,fault=0;
 reg [23:0] pcm=0;
 wire [23:0] frames,data,progress,events,accepted;
 wire [7:0] control;
 wire [23:0] rgb;
 player_pcm_waveform wave(.clk(clk),.rst(rst),.vs(1'b0),.de(1'b0),.rgb_in(24'h123456),
 .audio_valid(valid),.audio_pcm(pcm),.tone_mode(tone),.freeze_toggle(1'b0),.rgb_out(rgb),
 .spectrum_debug_frames(frames),.spectrum_debug_data(data),.spectrum_debug_progress(progress),
 .spectrum_debug_events(events),.spectrum_debug_accepted(accepted),.spectrum_debug_control(control));
 wire captured;
 wire [27:0] header;
 wire [23:0] pp,cp,pa,ca,sf,se;
 wire [23:0] observed_accepted=fault?24'd0:accepted;
 player_fault_snapshot trace(.clk(clk),.rst(rst),.tone_mode(tone),.audio_valid(valid),
 .axis_valid(axis_valid),.axis_user(axis_user),.hdmi_locked(1'b1),.progress(progress),.accepted(observed_accepted),
 .events(events),.frames(frames),.control(control),.snapshot_valid(captured),.snapshot_header(header),
 .snapshot_prev_progress(pp),.snapshot_progress(cp),.snapshot_prev_accepted(pa),.snapshot_accepted(ca),.snapshot_frames(sf),.snapshot_events(se));
 reg [15:0] samples[0:13311],expected[0:311];
 reg [1023:0] vec_file,exp_file;
 integer n,c,band_count=0,case_id=0,errors=0;
 always #20 clk=~clk;
 always @(posedge clk)if(!rst && wave.band_valid)begin
  if(wave.band_index!==band_count || wave.band_value!==expected[case_id*24+band_count])begin
   errors=errors+1;$display("FAIL band case=%0d n=%0d got=%h expected=%h",case_id,band_count,wave.band_value,expected[case_id*24+band_count]);
  end
  band_count=band_count+1;
 end
 task feed;
 begin
  band_count=0;
  for(n=0;n<1024;n=n+1)begin @(negedge clk);pcm={samples[case_id*1024+n],8'd0};valid=1;end
  @(negedge clk);valid=0;
  for(c=0;c<60000 && band_count<24;c=c+1)@(negedge clk);
  if(band_count!=24 || errors!=0)$fatal(1,"FFT changed by observer count=%0d errors=%0d",band_count,errors);
  repeat(10)@(negedge clk);
 end
 endtask
 initial begin
  if(!$value$plusargs("VEC=%s",vec_file)||!$value$plusargs("EXP=%s",exp_file))$fatal(1,"inputs missing");
  $readmemh(vec_file,samples);$readmemh(exp_file,expected);
  repeat(10)@(negedge clk);rst=0;repeat(5)@(negedge clk);
  feed();
  if(captured)$fatal(1,"false invariant during real FFT");
  repeat(4)begin axis_valid=1;axis_user=1;@(negedge clk);axis_valid=0;axis_user=0;@(negedge clk);end
  if(!captured || header[27:24]!=1 || sf!=1)$fatal(1,"healthy FFT snapshot missing header=%h frames=%h",header,sf);
  tone=1;repeat(5)@(negedge clk);
  if(captured)$fatal(1,"tone did not rearm");
  // Testbench-only observation fault: arithmetic input/control remain intact.
  fault=1;case_id=1;feed();
  if(!captured || header[27:24]!=4 || ca!=0 || cp[18:9]==0)$fatal(1,"broken counter observation not captured header=%h pa=%h ca=%h progress=%h",header,pa,ca,cp);
  // The existing renderer resets its frame telemetry on every source switch.
  if(frames!=1 || errors!=0)$fatal(1,"post-switch frame telemetry mismatch frames=%h expected=1 errors=%0d",frames,errors);
  $display("PASS snapshot_fft_integration frames=2 exact_bands=48 false_triggers=0 healthy_capture=1 source_rearm=1 counter_fault_capture=1 FFT_unchanged_under_observation_fault=1");$finish;
 end
 initial begin #10000000;$fatal(1,"timeout");end
endmodule
