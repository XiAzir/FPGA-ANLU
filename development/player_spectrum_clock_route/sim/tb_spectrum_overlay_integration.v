`timescale 1ns/1ps
module tb_spectrum_overlay_integration;
    reg clk=0,rst=1,vs=0,de=0,audio_valid=0,tone_mode=0,freeze_toggle=0;
    reg [23:0] audio_pcm=0,rgb_in=24'h123456;
    wire [23:0] rgb_out;
    reg [15:0] pcm_mem[0:13*1024-1];
    reg [1023:0] pcm_file,obs_file;
    integer active_frame=0,fd,j,cycle_count,errors=0,x,y,k;
    reg [6:0] old_front[0:23],old_peak[0:23];
    reg [6:0] old_snapshot[0:23];
    reg old_snapshot_bank,old_snapshot_valid;
    player_pcm_waveform dut(.clk(clk),.rst(rst),.vs(vs),.de(de),.rgb_in(rgb_in),
        .audio_valid(audio_valid),.audio_pcm(audio_pcm),.tone_mode(tone_mode),
        .freeze_toggle(freeze_toggle),.rgb_out(rgb_out));
    always #20 clk=~clk;
    always @(posedge clk) begin
        if(!rst && dut.band_valid) $fdisplay(fd,"BAND %0d %0d %0d",active_frame,dut.band_index,dut.band_value);
        if(!rst && dut.update_done) $fdisplay(fd,"COMMIT %0d %0d",dut.snapshot_tone,dut.update_index);
    end
    initial begin
        if(!$value$plusargs("PCM=%s",pcm_file)) $fatal(1,"missing +PCM");
        if(!$value$plusargs("OBS=%s",obs_file)) $fatal(1,"missing +OBS");
        $readmemh(pcm_file,pcm_mem);
        fd=$fopen(obs_file,"w"); if(!fd) $fatal(1,"cannot open observation log");
        @(negedge clk); rst=1; repeat(3) @(negedge clk); rst=0; wait_init_idle();
        feed_frame(0); finish_frame(60000); dump_state("after_tone");
        // Complete a real second PCM frame and assert VS on its frame_done edge.
        // The update must use the old ready bank and keep its selected snapshot immutable.
        feed_frame(5); wait_frame_done_then_vs_check_bank(80); dump_state("tone_commit");
        if(!dut.frame_pending) $fatal(1,"overlapped frame_done was lost");
        pulse_vs(); repeat(8) @(negedge clk); assert_front("silence_mid");
        wait_update_done(80); dump_state("silence_commit");
        capture_pixel("silence_live",194,414-dut.display_height[4]);
        // HOLD freezes front while accepting another actual analyzer frame; thaw starts a serial update.
        pulse_freeze(); pulse_vs(); dump_state("held");
        feed_frame(12); finish_frame(60000); dump_state("held_new_frame_pending");
        pulse_vs(); dump_state("held_still");
        pulse_freeze(); pulse_vs(); repeat(8) @(negedge clk); assert_front("thaw_mid");
        wait_update_done(80); dump_state("thawed_commit");
        // Stale forces a zero target on the next VS and commits only after all 24 calculations.
        cycle_count=0;
        while(!dut.stale && cycle_count<2600000) begin @(posedge clk); #1; cycle_count=cycle_count+1; end
        if(!dut.stale) $fatal(1,"stale timeout did not fire");
        $fdisplay(fd,"TIMEOUT %0d",cycle_count);
        pulse_vs(); repeat(8) @(negedge clk); assert_front("stale_mid");
        wait_update_done(80); dump_state("stale_commit");
        // Start another serial update, then source-change cancels it before VS clears the front.
        pulse_vs(); repeat(4) @(negedge clk); if(dut.update_state==dut.U_IDLE) $fatal(1,"update did not start for source abort");
        save_front(); tone_mode=1; @(posedge clk); #1;
        if(dut.update_state!=dut.U_IDLE) $fatal(1,"source change failed to cancel update");
        assert_front("source_cancel"); pulse_vs(); dump_state("source_clear");
        wait_init_idle(); dump_state("source_init_done");
        capture_pixel("source_blank",72,414-dut.display_height[0]);
        // Move back to the WAV source, let its init finish, then reset during a normal active update.
        tone_mode=0; @(posedge clk); #1; pulse_vs(); wait_init_idle();
        pulse_vs(); repeat(3) @(negedge clk); if(dut.update_state==dut.U_IDLE) $fatal(1,"update did not start for reset abort");
        rst=1; #1;
        for(k=0;k<24;k=k+1) if(dut.display_height[k]!==0 || dut.peak_height[k]!==0) $fatal(1,"reset did not clear visible front");
        repeat(2) @(negedge clk); rst=0; wait_init_idle(); dump_state("reset_init_done");
        $fclose(fd);
        $display("PASS spectrum_overlay_integration actual_pcm_frames=3 actual_band_frames=3 atomic_front_commit=1 update_abort_source=1 reset_during_update=1 stale_full_cycle=%0d",cycle_count);
        $finish;
    end
    task feed_frame(input integer id);
        integer n;
        begin active_frame=id; for(n=0;n<1024;n=n+1) begin @(negedge clk); audio_pcm={pcm_mem[id*1024+n],8'h00}; audio_valid=1; end
            @(negedge clk); audio_valid=0; audio_pcm=0; end
    endtask
    task finish_frame(input integer timeout_limit);
        integer c; begin c=0; while(!dut.frame_done && c<timeout_limit) begin @(negedge clk); c=c+1; end
            if(!dut.frame_done) $fatal(1,"frame_done timeout %0d",active_frame); @(posedge clk); #1; end
    endtask
    task wait_done_then_vs;
        integer c; begin c=0; while(!dut.frame_done && c<60000) begin @(negedge clk); c=c+1; end
            if(!dut.frame_done) $fatal(1,"frame_done timeout before same-cycle VS"); vs=1; @(posedge clk); #1; @(negedge clk); vs=0; end
    endtask
    task wait_frame_done_then_vs_check_bank(input integer limit);
        integer c,done_seen; begin
            c=0;while(!dut.frame_done && c<60000) begin @(negedge clk);c=c+1;end
            if(!dut.frame_done) $fatal(1,"real PCM frame_done timeout");
            save_front();vs=1;@(posedge clk);#1;vs=0;
            if(!dut.update_busy || !dut.snapshot_valid) $fatal(1,"same-cycle VS did not start a valid snapshot update");
            if(dut.snapshot_bank===dut.ready_bank) $fatal(1,"bank swap did not preserve previous ready bank");
            old_snapshot_bank=dut.snapshot_bank;old_snapshot_valid=dut.snapshot_valid;
            for(k=0;k<24;k=k+1) old_snapshot[k]=dut.target_mem[(dut.snapshot_bank*32)+k];
            c=0;done_seen=0;
            while(dut.update_busy && c<limit) begin
                @(posedge clk);#1;c=c+1;
                if(dut.snapshot_bank!==old_snapshot_bank || dut.snapshot_valid!==old_snapshot_valid)
                    $fatal(1,"snapshot selector changed during serial update");
                for(k=0;k<24;k=k+1) if(dut.target_mem[(old_snapshot_bank*32)+k]!==old_snapshot[k])
                    $fatal(1,"real PCM changed selected snapshot bank word=%0d",k);
                if(dut.update_done) done_seen=1;
                else for(k=0;k<24;k=k+1) if(dut.display_height[k]!==old_front[k] || dut.peak_height[k]!==old_peak[k])
                    $fatal(1,"front changed before atomic update_done band=%0d",k);
            end
            if(dut.update_busy || !done_seen) $fatal(1,"atomic update timeout or missing update_done");
            $fdisplay(fd,"STABLE rise_mid 24");$fdisplay(fd,"SNAPSTABLE real_pcm_frame 24");
        end
    endtask
    task wait_update_done(input integer limit);
        integer c; begin c=0; while(!dut.update_done && c<limit) begin @(negedge clk); c=c+1; end
            if(!dut.update_done) $fatal(1,"update_done timeout state=%0d index=%0d",dut.update_state,dut.update_index); @(posedge clk); #1; end
    endtask
    task wait_init_idle;
        integer c; begin c=0; while(dut.update_state!=dut.U_IDLE && c<40) begin @(negedge clk); c=c+1; end
            if(dut.update_state!=dut.U_IDLE) $fatal(1,"state RAM init timeout"); end
    endtask
    task pulse_vs; begin save_front(); @(negedge clk); vs=1; @(posedge clk); #1; @(negedge clk); vs=0; end endtask
    task pulse_freeze; begin @(negedge clk); freeze_toggle=1; @(posedge clk); #1; @(negedge clk); freeze_toggle=0; end endtask
    task save_front; begin for(k=0;k<24;k=k+1) begin old_front[k]=dut.display_height[k]; old_peak[k]=dut.peak_height[k]; end end endtask
    task capture_front(input [8*24-1:0] label); begin save_front(); $fdisplay(fd,"FRONT %0s",label); for(k=0;k<24;k=k+1) $fdisplay(fd,"F %0s %0d %0d",label,dut.display_height[k],dut.peak_height[k]); end endtask
    task assert_front(input [8*24-1:0] label); begin for(k=0;k<24;k=k+1) if(dut.display_height[k]!==old_front[k] || dut.peak_height[k]!==old_peak[k]) $fatal(1,"front changed before commit: %0s band=%0d",label,k); $fdisplay(fd,"STABLE %0s 24",label); end endtask
    task capture_pixel(input [8*24-1:0] label,input integer px,input integer py);
        begin @(negedge clk); x=px; y=py; dut.x_pos=x; dut.y_pos=y; de=1; rgb_in=24'h123456; #1;
            $fdisplay(fd,"PIX %0s %0d %0d %0d %06x %06x %0d %0d",label,x,y,de,rgb_in,rgb_out,dut.frozen_front,dut.frame_tone_mode); de=0; end
    endtask
    task dump_state(input [8*32-1:0] label);
        integer z; begin for(z=0;z<24;z=z+1) $fdisplay(fd,"STATE %0s %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d",label,z,
            dut.ready_valid?dut.target_mem[(dut.ready_bank*32)+z]:0,
            dut.snapshot_valid?dut.target_mem[(dut.snapshot_bank*32)+z]:0,
            dut.display_height[z],dut.peak_height[z],dut.state_mem[z][3:0],dut.frame_pending,dut.freeze_requested,dut.frozen_front,dut.frame_tone_mode,dut.stale,dut.source_pending,dut.update_state,dut.snapshot_tone,dut.update_busy,
            dut.ready_bank,dut.snapshot_bank,dut.ready_valid,dut.snapshot_valid,dut.capture_bank); end endtask
endmodule
