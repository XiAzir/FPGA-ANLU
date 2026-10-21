`timescale 1ns/1ps
module tb_spectrum_diag;
reg clk=0,rst=1,vs=0,audio_valid=0,tone_mode=0,freeze_toggle=0;
reg [23:0] audio_pcm=0;
wire [23:0] rgb_out,frames,diag;
reg [15:0] samples[0:13311];
integer cycle=0,pcm_index=0,k;
reg [23:0] before_hold;
always #5 clk=~clk;
// This telemetry regression accelerates valid samples to one per four clocks.
// The production watchdog is covered at real 521-clock intervals by tb_fft_recover.
player_pcm_waveform #(.FFT_TIMEOUT_SAMPLES(0)) dut(.clk(clk),.rst(rst),.vs(vs),.de(1'b0),.rgb_in(24'h123456),
 .audio_valid(audio_valid),.audio_pcm(audio_pcm),.tone_mode(tone_mode),
 .freeze_toggle(freeze_toggle),.rgb_out(rgb_out),.spectrum_debug_frames(frames),.spectrum_debug_data(diag));
always @(negedge clk) begin
 cycle=cycle+1;
 vs=(cycle%8000==0);
 audio_valid=!rst && cycle%4==0;
 if(audio_valid) begin
   audio_pcm={samples[pcm_index],8'd0};
   pcm_index=(pcm_index+1)%1024;
 end
end
initial begin
 $readmemh("../../../sim/vectors/all_samples.mem",samples);
 repeat(4) @(posedge clk);
 @(negedge clk);rst=0;
 repeat(3) @(posedge clk);
 repeat(230000) @(posedge clk);
 #1;
 if(frames<3 || diag[23:16]!==8'hFE || diag[15:0]==0)
   $fatal(1,"Nonzero tone telemetry did not become healthy: frames=%h diag=%h",frames,diag);
 before_hold=frames;
 @(negedge clk);freeze_toggle=1;
 @(negedge clk);freeze_toggle=0;
 repeat(80000) @(posedge clk);
 #1;
 if(frames<=before_hold || diag[16]!==1'b1 || diag[15:0]==0)
   $fatal(1,"HOLD must freeze front while FFT telemetry advances: frames=%h diag=%h",frames,diag);
 @(negedge clk);tone_mode=1;
 @(posedge clk);#1;
 if(frames!==0 || diag[23:17]!==0 || diag[15:0]!==0)
   $fatal(1,"Source change did not clear source-specific telemetry: %h %h",frames,diag);
 repeat(160000) @(posedge clk);#1;
 if(frames<2 || diag[23:16]!==8'hFE || diag[15:0]==0)
   $fatal(1,"Telemetry did not recover after source change: %h %h",frames,diag);
 @(negedge clk);rst=1;
 #1;if(frames!==0 || diag!==0) $fatal(1,"Global reset did not clear telemetry");
 $display("PASS spectrum_diag nonzero_coefficients=1 complete_frames=1 nonzero_band_max=1 front_nonzero=1 hold_keeps_analysis=1 source_reset=1 global_reset=1");
 $finish;
end
initial begin #10000000;$fatal(1,"Telemetry test timed out");end
endmodule
