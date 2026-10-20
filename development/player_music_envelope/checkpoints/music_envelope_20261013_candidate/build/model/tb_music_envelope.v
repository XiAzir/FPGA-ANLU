`timescale 1ns/1ps
module tb_music_envelope;
  parameter integer AVG_LOG2 = 8;
  parameter integer FRAME_CYCLES = 420000;
  parameter integer CLK_FREQ_HZ = 25000000;
  parameter integer VALID_RATE_HZ = 48000;
  localparam integer AVG_N = (1 << AVG_LOG2);
  reg clk=0, rst=1, vs=0, de=0;
  reg [23:0] rgb_in=24'h123456;
  reg audio_valid=0;
  reg audio_gate=1;
  reg [23:0] audio_pcm=0;
  reg tone_mode=0, freeze_toggle=0;
  wire [23:0] rgb_out;
  always #5 clk=~clk;
  integer valid_phase=0, valid_count=0;
  // Fractional accumulator models 48 kHz audio independently from DE.
  always @(negedge clk) begin
    if(rst) begin valid_phase=0; audio_valid=0; end
    else if(!audio_gate) audio_valid=0;
    else begin
      valid_phase=valid_phase+VALID_RATE_HZ;
      if(audio_gate && valid_phase>=CLK_FREQ_HZ) begin
        valid_phase=valid_phase-CLK_FREQ_HZ;
        audio_valid=1; valid_count=valid_count+1;
      end else audio_valid=0;
    end
  end

  player_pcm_waveform #(.AVG_LOG2(AVG_LOG2),.CLK_FREQ_HZ(CLK_FREQ_HZ)) dut(
    .clk(clk),.rst(rst),.vs(vs),.de(de),.rgb_in(rgb_in),
    .audio_valid(audio_valid),.audio_pcm(audio_pcm),.tone_mode(tone_mode),
    .freeze_toggle(freeze_toggle),.rgb_out(rgb_out));

  integer errors=0, env_errors=0, pixel_errors=0, scanned=0, frame_no=0;
  integer sample_n=0, sample_sum=0, sample_abs=0;
  integer ref_env=0, ref_target=0, ref_delta=0, ref_step=0;
  integer hist[0:127];
  integer visible_hist[0:127];
  integer gold[0:511];
  integer visible_gold[0:511];
  integer i,j,ri,fd;
  integer ref_vs_prev=0, last_tone=0, requested_hold=0, ref_hold=0;
  wire ref_source_change=(tone_mode!=last_tone);
  integer stable_front=0;
  integer max_abs_seen=0, avg_events=0, vs_commits=0;
  integer env_checks=0;
  integer control_errors=0, control_checks=0, ptr_snapshot=0, valid_start=0, stale_expected=0;
  integer front_snapshot=0,bank_snapshot=0,title_snapshot=0;
  integer p0,p1,p2,p3,num,h,lo,hi,idx,k,den;
  integer expected_rgb, actual_rgb, alpha, ch_r,ch_g,ch_b;
  integer scan_x, scan_y;
  reg [15:0] pcm_value;
  reg [1023:0] out_prefix;
  reg [1023:0] out_path;

  function integer abs_i(input integer v); begin abs_i=(v<0)?-v:v; end endfunction
  function integer hist_at(input integer n);
    begin hist_at=hist[n]; end
  endfunction
  function integer height_from_env(input integer e);
    integer v;
    begin
      if(e<=65536) v=e>>7;
      else v=512+((e-65536)>>9);
      if(v<0) v=0; if(v>832) v=832;
      height_from_env=v;
    end
  endfunction
  function integer interp(input integer col);
    integer seg, frac, a,b,c,d,n, mn,mx;
    begin
      seg=col>>2; frac=col&3;
      a=hist_at((seg==0)?0:seg-1); b=hist_at(seg);
      c=hist_at((seg>=127)?127:seg+1); d=hist_at((seg>=126)?127:seg+2);
      case(frac)
        0:n=128*b;
        1:n=-9*a+111*b+29*c-3*d;
        2:n=-8*a+72*b+72*c-8*d;
        default:n=-3*a+29*b+111*c-9*d;
      endcase
      // Mathematical floor(n/128), including negative numerators.
      h=n/128; if(n<0 && (n%128)!=0) h=h-1;
      mn=(b<c)?b:c; mx=(b>c)?b:c;
      if(h<mn) h=mn; if(h>mx) h=mx;
      interp=h;
    end
  endfunction
  function integer rgb_for(input integer y, input integer height);
    integer dd, aa, rr,gg,bb;
    begin
      dd=abs_i((408-y)*16-height);
      if(dd<16) begin
        aa=16-dd;
        if(aa==16) begin rr=72; gg=220; bb=210; end
        else begin rr=7+(aa*65)/16; gg=11+(aa*209)/16; bb=18+(aa*192)/16; end
        rgb_for=(rr<<16)|(gg<<8)|bb;
      end else if(dd<32) begin
        aa=32-dd; rr=7+(aa*4)/16; gg=11+(aa*13)/16; bb=18+(aa*12)/16;
        rgb_for=(rr<<16)|(gg<<8)|bb;
      end else if(y==408) rgb_for=24'h17212c;
      else rgb_for=24'h070b12;
    end
  endfunction

  // Independent sample-domain integer oracle. Input samples are read only;
  // no DUT state or output is used to calculate this reference.
  always @(posedge clk) begin
    if(rst) begin
      sample_n=0; sample_sum=0; ref_env=0; ref_target=0;
      ref_vs_prev=0; last_tone=tone_mode; requested_hold=0; ref_hold=0;
      for(ri=0;ri<128;ri=ri+1) begin hist[ri]=0; visible_hist[ri]=0; end
      for(ri=0;ri<512;ri=ri+1) begin gold[ri]=0; visible_gold[ri]=0; end
    end else begin
      if(ref_source_change) begin
        for(ri=0;ri<128;ri=ri+1) hist[ri]=0;
        ref_env=0; ref_target=0; sample_n=0; sample_sum=0;
        ref_hold=0; requested_hold=0;
      end
      if(vs && !ref_vs_prev) begin
        vs_commits=vs_commits+1;
        for(ri=0;ri<128;ri=ri+1) visible_hist[ri]=hist[ri];
        for(ri=0;ri<512;ri=ri+1) visible_gold[ri]=gold[ri];
        if(!ref_source_change && freeze_toggle) requested_hold=!requested_hold;
        if(!ref_source_change && !ref_hold && !requested_hold) begin
          for(ri=0;ri<127;ri=ri+1) hist[ri]=hist[ri+1];
          hist[127]=height_from_env(ref_env);
        end
        for(ri=0;ri<512;ri=ri+1) gold[ri]=interp(ri);
        if(requested_hold && vs_commits>1) ref_hold=1;
        if(!requested_hold) ref_hold=0;
      end
      ref_vs_prev=vs;
      last_tone=tone_mode;
      if(audio_valid && !ref_source_change) begin
        pcm_value=audio_pcm[23:8];
        sample_abs=(pcm_value[15]) ? (65536-pcm_value) : pcm_value;
        if(sample_abs>max_abs_seen) max_abs_seen=sample_abs;
        sample_sum=sample_sum+sample_abs;
        sample_n=sample_n+1;
        if(sample_n==AVG_N) begin
          ref_target=(sample_sum/AVG_N)<<4;
          ref_delta=ref_target-ref_env;
          if(ref_delta>0) ref_step=(ref_delta+15)/16;
          else if(ref_delta<0) ref_step=(-ref_delta+63)/64;
          else ref_step=0;
          if(ref_delta>0) ref_env=ref_env+ref_step;
          else if(ref_delta<0) ref_env=ref_env-ref_step;
          sample_n=0; sample_sum=0; avg_events=avg_events+1;
        end
      end
    end
  end

  // Compare the independently accumulated sample/attack/release state against
  // the DUT after nonblocking assignments settle. The reference never reads
  // DUT state to form its expected value.
  always @(negedge clk) begin
    if(!rst && audio_valid) begin
      env_checks=env_checks+1;
      if(dut.env_q4 !== ref_env) begin
        if(env_errors<32) $display("ENV_MISMATCH samples=%0d expected=%0d got=%0d",sample_n,ref_env,dut.env_q4);
        env_errors=env_errors+1;
        errors=errors+1;
      end
    end
  end

  task set_pcm(input integer v);
    begin
      if(v<0) audio_pcm={v[15:0],8'h00};
      else audio_pcm={v[15:0],8'h00};
    end
  endtask
  task pulse_vs;
    begin
      @(negedge clk); vs=1;
      @(negedge clk); vs=0;
    end
  endtask
  task nominal_frame(input integer v);
    integer c;
    begin
      set_pcm(v); pulse_vs();
      for(c=0;c<FRAME_CYCLES;c=c+1) @(negedge clk);
      frame_no=frame_no+1;
    end
  endtask
  task scan_full_graph;
    integer yy,xx;
    begin
      // Full 57 x 512 active graph rectangle, with a real DE line for every
      // row and x=0..575 so the DUT's own coordinate counter is exercised.
      // Advance the real line counter from the post-VS origin to y=356.
      for(yy=0;yy<356;yy=yy+1) begin
        @(negedge clk); de=0;
        @(negedge clk); de=1;
        @(negedge clk); de=0;
      end
      for(yy=356;yy<=412;yy=yy+1) begin
        @(negedge clk); de=0;
        // The first DE cycle maps to x=0; include the additional final cycle
        // so both outside-edge sentinels x=63 and x=576 are exercised.
        for(xx=0;xx<=576;xx=xx+1) begin
          @(negedge clk); de=1;
          #1;
          if(dut.x_pos>=63 && dut.x_pos<=576 && dut.y_pos>=356 && dut.y_pos<=412) begin
            scan_y=dut.y_pos;
            if(dut.x_pos==63 || dut.x_pos==576) expected_rgb=24'h070b12;
            else begin scan_x=dut.x_pos-64; expected_rgb=rgb_for(scan_y,visible_gold[scan_x]); end
            actual_rgb=rgb_out;
            if(actual_rgb!==expected_rgb) begin
              if(pixel_errors<32) $display("PIXEL_MISMATCH x=%0d y=%0d heightQ4=%0d exp=%06x got=%06x",dut.x_pos,dut.y_pos,visible_gold[scan_x],expected_rgb,actual_rgb);
              pixel_errors=pixel_errors+1;
              errors=errors+1;
            end
            scanned=scanned+1;
          end
        end
        @(negedge clk); de=0;
      end
    end
  endtask

  initial begin
    if(!$value$plusargs("OUT_PREFIX=%s",out_prefix)) out_prefix="envelope";
    for(i=0;i<128;i=i+1) hist[i]=0;
    repeat(6) @(negedge clk); rst=0;
    // Exercise signed full-scale and varied amplitudes while maintaining VALID
    // so stale is not triggered by the nominal frame's blank intervals.
    nominal_frame(-32768);
    pulse_vs(); repeat(2048) @(negedge clk); scan_full_graph();
    for(i=1;i<128;i=i+1) begin
      if(i<20) set_pcm(-32768);
      else case(i%6)
        0:set_pcm(0);
        1:set_pcm(32767);
        2:set_pcm(4096);
        3:set_pcm(-8192);
        4:set_pcm(16384);
        default:set_pcm(1024);
      endcase
      pulse_vs();
      repeat(FRAME_CYCLES) @(negedge clk);
      frame_no=frame_no+1;
    end
    // At this boundary a completed bank is expected to be front-visible.
    pulse_vs(); repeat(2048) @(negedge clk);
    scan_full_graph();

    $sformat(out_path,"%0s_reference_history.txt",out_prefix);
    fd=$fopen(out_path,"w");
    for(i=0;i<128;i=i+1) $fdisplay(fd,"%0d %0d",i,visible_hist[i]);
    $fclose(fd);
    $sformat(out_path,"%0s_expected_512.txt",out_prefix);
    fd=$fopen(out_path,"w");
    for(i=0;i<512;i=i+1) $fdisplay(fd,"%0d %0d",i,visible_gold[i]);
    $fclose(fd);

    // Freeze request is registered before VS; visible history pointer must
    // stop while HOLD is active, then advance once on the resume boundary.
    freeze_toggle=1; @(negedge clk); freeze_toggle=0;
    pulse_vs(); repeat(4) @(negedge clk);
    control_checks=control_checks+1;
    if(!dut.frozen_front) begin $display("CONTROL_FAIL hold did not latch"); control_errors=control_errors+1; end
    ptr_snapshot=dut.hist_write_ptr;
    set_pcm(16384); pulse_vs(); repeat(4) @(negedge clk);
    control_checks=control_checks+1;
    if(dut.hist_write_ptr!==ptr_snapshot) begin $display("CONTROL_FAIL history moved during HOLD exp=%0d got=%0d",ptr_snapshot,dut.hist_write_ptr); control_errors=control_errors+1; end
    freeze_toggle=1; @(negedge clk); freeze_toggle=0;
    pulse_vs(); repeat(4) @(negedge clk);
    control_checks=control_checks+1;
    if(dut.frozen_front || dut.hist_write_ptr!==((ptr_snapshot+1)&127)) begin $display("CONTROL_FAIL resume ptr exp=%0d got=%0d frozen=%0d",(ptr_snapshot+1)&127,dut.hist_write_ptr,dut.frozen_front); control_errors=control_errors+1; end

    // A non-VS source change aborts only the unpublished back build. Keep the
    // visible bank, front-valid, and title mode until VS commits the change.
    freeze_toggle=1; @(negedge clk); freeze_toggle=0;
    pulse_vs(); repeat(4) @(negedge clk);
    control_checks=control_checks+1;
    if(!dut.frozen_front) begin $display("CONTROL_FAIL HOLD before source transition"); control_errors=control_errors+1; end
    front_snapshot=dut.front_valid; bank_snapshot=dut.display_bank;
    title_snapshot=dut.frame_tone_mode;
    @(negedge clk); tone_mode=~tone_mode;
    repeat(4) @(negedge clk);
    control_checks=control_checks+1;
    if(!dut.source_pending || dut.front_valid!==front_snapshot || dut.display_bank!==bank_snapshot || dut.frame_tone_mode!==title_snapshot || dut.env_q4!==0 || !dut.frozen_front) begin
      $display("CONTROL_FAIL source pre-VS pending=%0d front=%0d/%0d bank=%0d/%0d title=%0d/%0d env=%0d frozen=%0d",dut.source_pending,dut.front_valid,front_snapshot,dut.display_bank,bank_snapshot,dut.frame_tone_mode,title_snapshot,dut.env_q4,dut.frozen_front);
      control_errors=control_errors+1;
    end
    @(negedge clk); vs=1; freeze_toggle=1;
    @(negedge clk); vs=0; freeze_toggle=0; repeat(4) @(negedge clk);
    control_checks=control_checks+1;
    if(dut.hist_write_ptr!==0 || dut.hist_count!==0 || dut.front_valid!==0 || dut.frozen_front!==0 || dut.freeze_requested!==0 || dut.source_pending!==0 || dut.frame_tone_mode!==tone_mode) begin
      $display("CONTROL_FAIL source VS commit ptr=%0d count=%0d front=%0d frozen=%0d requested=%0d pending=%0d title=%0d/%0d",dut.hist_write_ptr,dut.hist_count,dut.front_valid,dut.frozen_front,dut.freeze_requested,dut.source_pending,dut.frame_tone_mode,tone_mode);
      control_errors=control_errors+1;
    end

    // Fill exactly one default average window after source reset, then test
    // stale timeout/decay/recovery using the independent reference envelope.
    set_pcm(8192); valid_start=valid_count;
    while(valid_count-valid_start<AVG_N) @(negedge clk);
    audio_gate=0; audio_valid=0;
    repeat((CLK_FREQ_HZ/10)+4) @(negedge clk);
    control_checks=control_checks+1;
    if(!dut.stale_active) begin $display("CONTROL_FAIL stale timeout did not fire"); control_errors=control_errors+1; end
    stale_expected=ref_env-((ref_env+15)>>4);
    pulse_vs(); repeat(2) @(negedge clk);
    control_checks=control_checks+1;
    if(dut.env_q4!==stale_expected) begin $display("CONTROL_FAIL stale decay exp=%0d got=%0d",stale_expected,dut.env_q4); control_errors=control_errors+1; end
    ref_env=stale_expected;
    stale_expected=ref_env-((ref_env+15)>>4);
    pulse_vs(); repeat(2) @(negedge clk);
    control_checks=control_checks+1;
    if(dut.env_q4!==stale_expected) begin $display("CONTROL_FAIL stale second decay exp=%0d got=%0d",stale_expected,dut.env_q4); control_errors=control_errors+1; end
    ref_env=stale_expected;
    audio_gate=1; valid_start=valid_count;
    while(valid_count==valid_start) @(negedge clk);
    repeat(2) @(negedge clk);
    control_checks=control_checks+1;
    if(dut.stale_active) begin $display("CONTROL_FAIL audio recovery did not clear stale"); control_errors=control_errors+1; end

    $sformat(out_path,"%0s_model_report.txt",out_prefix);
    fd=$fopen(out_path,"w");
    $fdisplay(fd,"status=%s",(errors==0 && control_errors==0)?"PASS":"FAIL");
    $fdisplay(fd,"avg_log2=%0d avg_n=%0d clk_hz=%0d valid_hz=%0d frame_cycles=%0d frames=%0d vs_commits=%0d avg_events=%0d valid_samples=%0d",AVG_LOG2,AVG_N,CLK_FREQ_HZ,VALID_RATE_HZ,FRAME_CYCLES,frame_no,vs_commits,avg_events,valid_count);
    $fdisplay(fd,"max_abs=%0d env_q4=%0d env_checks=%0d scanned_graph_pixels=%0d env_errors=%0d pixel_errors=%0d total_errors=%0d control_checks=%0d control_errors=%0d",max_abs_seen,ref_env,env_checks,scanned,env_errors,pixel_errors,errors,control_checks,control_errors);
    $fclose(fd);
    $display("MODEL_RESULT total_errors=%0d env_errors=%0d pixel_errors=%0d control_errors=%0d controls=%0d frames=%0d commits=%0d avg_events=%0d pixels=%0d env=%0d",errors,env_errors,pixel_errors,control_errors,control_checks,frame_no,vs_commits,avg_events,scanned,ref_env);
    if(errors!=0 || control_errors!=0) $fatal(1,"model verification failed");
    $finish;
  end
endmodule
