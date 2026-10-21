`timescale 1ns/1ps
module tb_waveform_proposal;
  reg clk=0, rst=1, vs=0, de=0;
  reg [23:0] rgb_in=0, audio_pcm=0;
  reg audio_valid=0, tone_mode=0, freeze_toggle=0;
  always #5 clk=~clk;

  wire [23:0] rgb_ref, rgb_prop, frames_ref, frames_prop;
  wire [23:0] data_ref, data_prop, progress_ref, progress_prop;
  wire [23:0] events_ref, events_prop, accepted_ref, accepted_prop;
  wire [7:0] control_ref, control_prop;
  integer cycles=0, frame_no=0, commits=0, source_clears=0;
  integer commit_source_aborts=0, commit_reset_aborts=0;
  integer analyzer_bands=0,analyzer_frames=0;
  reg [23:0] sampled_calc_mask=0;
  integer k;
  integer seed=32'h42a16739;
  integer x,y,n,r;
  reg was_calc,was_commit,was_source_clear;
  integer calc_index;
  reg [13:0] front_word,back_word;

  player_pcm_waveform_reference #(.CLK_FREQ_HZ(1000),.STALE_MS(20),.FFT_TIMEOUT_SAMPLES(0)) ref_dut(
    .clk(clk),.rst(rst),.vs(vs),.de(de),.rgb_in(rgb_in),.audio_valid(audio_valid),.audio_pcm(audio_pcm),.tone_mode(tone_mode),.freeze_toggle(freeze_toggle),
    .rgb_out(rgb_ref),.spectrum_debug_frames(frames_ref),.spectrum_debug_data(data_ref),.spectrum_debug_progress(progress_ref),
    .spectrum_debug_events(events_ref),.spectrum_debug_accepted(accepted_ref),.spectrum_debug_control(control_ref));

  player_pcm_waveform_proposal #(.CLK_FREQ_HZ(1000),.STALE_MS(20),.FFT_TIMEOUT_SAMPLES(0)) prop_dut(
    .clk(clk),.rst(rst),.vs(vs),.de(de),.rgb_in(rgb_in),.audio_valid(audio_valid),.audio_pcm(audio_pcm),.tone_mode(tone_mode),.freeze_toggle(freeze_toggle),
    .rgb_out(rgb_prop),.spectrum_debug_frames(frames_prop),.spectrum_debug_data(data_prop),.spectrum_debug_progress(progress_prop),
    .spectrum_debug_events(events_prop),.spectrum_debug_accepted(accepted_prop),.spectrum_debug_control(control_prop));

  always @(posedge clk) begin
    if(!rst && ref_dut.band_valid) analyzer_bands=analyzer_bands+1;
    if(!rst && ref_dut.frame_done) analyzer_frames=analyzer_frames+1;
    was_calc=!rst && !ref_dut.source_waiting && (ref_dut.update_state==ref_dut.U_CALC);
    calc_index=ref_dut.update_index;
    was_commit=!rst && !ref_dut.source_waiting && (ref_dut.update_state==ref_dut.U_COMMIT);
    was_source_clear=!rst && ref_dut.vs_rise && ref_dut.source_waiting;
    #1;
    cycles=cycles+1;
    if ({rgb_ref,frames_ref,data_ref,progress_ref,events_ref,accepted_ref,control_ref} !==
        {rgb_prop,frames_prop,data_prop,progress_prop,events_prop,accepted_prop,control_prop}) begin
      $display("OUTPUT MISMATCH cycle=%0d x=%0d y=%0d de=%b vs=%b ref rgb=%06x prop=%06x",cycles,ref_dut.x_pos,ref_dut.y_pos,de,vs,rgb_ref,rgb_prop);
      $fatal(1,"waveform external output mismatch");
    end
    if (rst || was_source_clear || was_commit) sampled_calc_mask=0;
    else if (was_calc) sampled_calc_mask[calc_index]=1'b1;
    if (was_commit) commits=commits+1;
    if (was_source_clear) source_clears=source_clears+1;

    if (was_commit || was_source_clear || rst) begin
      for(k=0;k<24;k=k+1) begin
        if (prop_dut.front_valid) begin
          front_word=prop_dut.wave_mem[{prop_dut.front_bank,5'(k)}];
          if (front_word[13:7] !== ref_dut.display_height[k] || front_word[6:0] !== ref_dut.peak_height[k]) begin
            $display("FRONT SNAPSHOT MISMATCH cycle=%0d band=%0d ref=%0d/%0d prop=%0d/%0d",cycles,k,
              ref_dut.display_height[k],ref_dut.peak_height[k],front_word[13:7],front_word[6:0]);
            $fatal(1,"front snapshot mismatch");
          end
          if (prop_dut.front_nonzero_mask[k] !== (ref_dut.display_height[k]!=0))
            $fatal(1,"front nonzero mask mismatch cycle=%0d band=%0d",cycles,k);
        end else if (ref_dut.display_height[k]!==0 || ref_dut.peak_height[k]!==0 || prop_dut.front_nonzero_mask[k]!==0) begin
          $fatal(1,"invalid front did not behave as zero cycle=%0d band=%0d",cycles,k);
        end
      end
    end
    if (was_calc) begin
      k=calc_index;
      back_word=prop_dut.wave_mem[{~prop_dut.front_bank,5'(k)}];
      if (back_word[13:7] !== ref_dut.back_height[k] || back_word[6:0] !== ref_dut.back_peak[k]) begin
        $display("BACK SNAPSHOT MISMATCH cycle=%0d band=%0d ref=%0d/%0d prop=%0d/%0d state=%0d index=%0d",cycles,k,
          ref_dut.back_height[k],ref_dut.back_peak[k],back_word[13:7],back_word[6:0],ref_dut.update_state,ref_dut.update_index);
        $fatal(1,"back snapshot mismatch");
      end
      if (prop_dut.back_nonzero_mask[k] !== (ref_dut.back_height[k]!=0))
        $fatal(1,"back nonzero mask mismatch cycle=%0d band=%0d",cycles,k);
    end
  end

  // Fast deterministic analyzer stub: it consumes audio_valid, emits a varied
  // 24-band frame and preserves the same interface/debug cadence for both DUTs.
  initial begin
    #1;
  end
  initial begin
    repeat(4) @(negedge clk); rst=0;
    repeat(40) @(negedge clk);
    sweep_frame(0); pulse_vs(); wait_commits(1,120);
    tone_mode=1; @(posedge clk); #1; pulse_vs(); sweep_frame(1);
    pulse_vs(); wait_commits(2,120);
    pulse_freeze(); pulse_vs(); sweep_frame(2); pulse_vs(); repeat(80) @(negedge clk);
    if(commits!=2) $fatal(1,"HOLD changed front commit count=%0d",commits);
    pulse_freeze(); pulse_vs(); wait_commits(3,120);
    // Abort a live update with reset, then establish another visible frame.
    pulse_vs(); repeat(8) @(negedge clk);
    rst=1; de=0; audio_valid=0; repeat(3) @(negedge clk); rst=0;
    repeat(3) @(negedge clk); pulse_vs(); sweep_frame(3); pulse_vs(); wait_commits(4,120);
    // Source switch on the same cycle as the rising VS edge, plus randomized
    // audio/DE/HOLD traffic in and around the overlay viewport.
    @(negedge clk); tone_mode=0; vs=1; de=0; @(negedge clk); vs=0;
    random_burst(12000);
    pulse_vs(); repeat(80) @(negedge clk);
    // Deliberately collide source_change + rising VS with U_COMMIT. Source
    // selection wins and the pending bank must remain uncommitted.
    if(ref_dut.freeze_requested) pulse_freeze();
    pulse_vs(); wait_update_commit(120);
    @(negedge clk); tone_mode=~tone_mode; vs=1; de=0;
    @(posedge clk); #1;
    if(ref_dut.update_done || prop_dut.update_done || prop_dut.front_valid || ref_dut.display_height[0]!=0)
      $fatal(1,"source/VS collision at U_COMMIT did not clear and cancel front");
    commit_source_aborts=commit_source_aborts+1;
    @(negedge clk); vs=0;
    wait_update_idle(40);
    if(ref_dut.freeze_requested) pulse_freeze();
    pulse_vs(); wait_update_commit(120);
    // Reset assertion on the U_COMMIT edge must cancel the normal commit and
    // asynchronously invalidate both implementations' visible front.
    @(negedge clk); rst=1; de=0; vs=0;
    @(posedge clk); #1;
    if(ref_dut.update_done || prop_dut.update_done || prop_dut.front_valid || ref_dut.display_height[0]!=0)
      $fatal(1,"reset at U_COMMIT did not suppress commit");
    commit_reset_aborts=commit_reset_aborts+1;
    repeat(3) @(negedge clk); tone_mode=0; rst=0; audio_valid=0; de=0;
    repeat(30) @(negedge clk);
    if (cycles < 750000 || commits < 4 || source_clears < 2 || commit_source_aborts!=1 || commit_reset_aborts!=1 || analyzer_bands<100 || analyzer_frames<3) begin
      $display("COVERAGE cycles=%0d commits=%0d source_clears=%0d bands=%0d analyzer_frames=%0d debug_frames=%0d",cycles,commits,source_clears,analyzer_bands,analyzer_frames,frames_ref);
      $fatal(1,"waveform coverage incomplete");
    end
    $display("PASS waveform proposal cycles=%0d commits=%0d source_clears=%0d commit_abort_source=%0d commit_abort_reset=%0d bands=%0d analyzer_frames=%0d debug_frames=%0d",cycles,commits,source_clears,commit_source_aborts,commit_reset_aborts,analyzer_bands,analyzer_frames,frames_ref);
    $finish;
  end

  task pulse_vs;
    begin @(negedge clk); de=0; vs=1; @(negedge clk); vs=0; end
  endtask
  task pulse_freeze;
    begin @(negedge clk); freeze_toggle=1; @(negedge clk); freeze_toggle=0; end
  endtask
  task sweep_frame(input integer fid);
    integer yy,xx,rr,blank;
    begin
      frame_no=fid;
      for(yy=0;yy<436;yy=yy+1) begin
        for(xx=0;xx<640;xx=xx+1) begin
          @(negedge clk);
          de=1;
          rgb_in={8'(xx+fid*17),8'(yy*3+xx),8'(xx^yy^fid)};
          rr=$random(seed);
          audio_valid=((rr & 3)!=0);
          audio_pcm={8'(rr>>8),8'(rr)};
          freeze_toggle=0;
        end
        @(negedge clk); de=0; freeze_toggle=0; audio_valid=0;
        blank=(yy%5==0)?2:1;
        repeat(blank) @(negedge clk);
      end
    end
  endtask
  task wait_commits(input integer target,input integer limit);
    integer z;
    begin
      z=0;
      while(commits<target && z<limit) begin @(negedge clk); z=z+1; end
      if(commits<target) begin $display("WAIT COMMIT target=%0d have=%0d state=%0d frame_done=%b ready=%b",target,commits,ref_dut.update_state,ref_dut.frame_done,ref_dut.ready_valid); $fatal(1,"commit wait timeout"); end
    end
  endtask
  task wait_update_commit(input integer limit);
    integer z;
    begin
      z=0;
      while(ref_dut.update_state!=ref_dut.U_COMMIT && z<limit) begin @(negedge clk); z=z+1; end
      if(ref_dut.update_state!=ref_dut.U_COMMIT) begin
        $display("WAIT U_COMMIT state=%0d pending=%b ready=%b frozen=%b freeze_req=%b",ref_dut.update_state,ref_dut.frame_pending,ref_dut.ready_valid,ref_dut.frozen_front,ref_dut.freeze_requested);
        $fatal(1,"U_COMMIT wait timeout");
      end
    end
  endtask
  task wait_update_idle(input integer limit);
    integer z;
    begin z=0; while(ref_dut.update_state!=ref_dut.U_IDLE && z<limit) begin @(negedge clk); z=z+1; end
      if(ref_dut.update_state!=ref_dut.U_IDLE) $fatal(1,"U_INIT did not finish"); end
  endtask
  task random_burst(input integer count);
    integer z,rr;
    begin
      for(z=0;z<count;z=z+1) begin
        @(negedge clk); rr=$random(seed);
        de=((rr&7)!=0); vs=0;
        audio_valid=((rr&3)!=0);
        audio_pcm={8'(rr>>8),8'(rr)};
        rgb_in=rr[23:0];
        freeze_toggle=((z%997)==0);
        if ((z%211)==7) tone_mode=~tone_mode;
      end
      @(negedge clk); de=0;vs=0;audio_valid=0;freeze_toggle=0;
    end
  endtask
endmodule

module player_spectrum_analyzer #(
  parameter HANN_FILE="", TWIDDLE_FILE="", parameter integer FRAME_TIMEOUT_SAMPLES=4096
)(
  input wire clk,input wire rst,input wire audio_valid,input wire signed [15:0] audio_pcm,input wire source_change,
  output reg band_valid,output reg [4:0] band_index,output reg [15:0] band_value,output reg frame_done,
  output reg [1:0] debug_coeff_nonzero,output wire [23:0] debug_progress,debug_events,debug_accepted,output wire [7:0] debug_control
);
  reg [5:0] sample_count;
  reg [4:0] emit_index;
  reg emitting;
  reg [7:0] frame_seq;
  reg [15:0] mix;
  reg [23:0] accepted;
  reg [7:0] source_events;
  reg [23:0] emitted_frames;
  assign debug_progress={11'd0,emitting,emit_index,sample_count,2'b0};
  assign debug_events={8'd0,source_events,8'd0};
  assign debug_accepted=accepted;
  assign debug_control={1'b0,source_change,1'b0,audio_valid,frame_done,band_valid,debug_coeff_nonzero};
  always @(posedge clk or posedge rst) begin
    if(rst) begin
      sample_count<=0;emit_index<=0;emitting<=0;frame_seq<=0;mix<=0;accepted<=0;source_events<=0;emitted_frames<=0;
      band_valid<=0;band_index<=0;band_value<=0;frame_done<=0;debug_coeff_nonzero<=0;
    end else if(source_change) begin
      sample_count<=0;emit_index<=0;emitting<=0;mix<=0;accepted<=0;
      if(source_events!=8'hff) source_events<=source_events+1'b1;
      band_valid<=0;frame_done<=0;
    end else begin
      band_valid<=0;frame_done<=0;
      if(audio_valid) begin
        mix<=mix+audio_pcm;
        if(accepted!=24'hffffff) accepted<=accepted+1'b1;
        if(!emitting) begin
          if(sample_count==15) begin sample_count<=0;emitting<=1;emit_index<=0;end
          else sample_count<=sample_count+1'b1;
        end
      end
      if(emitting) begin
        band_valid<=1;band_index<=emit_index;
        if (((emit_index+frame_seq)%6)==0 || ((frame_seq%4)==3 && emit_index[0])) band_value<=0;
        else band_value<=16'd24 + ((mix ^ (frame_seq*97) ^ (emit_index*251)) & 16'h7fff);
        debug_coeff_nonzero<=2'b11;
        if(emit_index==23) begin
          frame_done<=1;emitting<=0;emit_index<=0;frame_seq<=frame_seq+1'b1;
          if(emitted_frames!=24'hffffff) emitted_frames<=emitted_frames+1'b1;
        end else emit_index<=emit_index+1'b1;
      end
    end
  end
endmodule
