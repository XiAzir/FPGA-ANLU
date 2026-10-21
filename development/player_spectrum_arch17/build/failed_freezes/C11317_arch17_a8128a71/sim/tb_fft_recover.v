`timescale 1ns/1ps
module tb_fft_recover;
    reg clk=0;
    reg rst=0;
    reg audio_valid=0;
    reg source_change=0;
    reg signed [15:0] audio_pcm=0;
    wire band_valid,frame_done;
    wire [4:0] band_index;
    wire [15:0] band_value;
    wire [1:0] debug_coeff_nonzero;
    wire [23:0] debug_progress,debug_events,debug_accepted;
    reg [15:0] samples[0:13*1024-1];
    reg [1023:0] sample_file;
    reg hold_capture=0;
    integer global_reset_edges=0;
    integer sent_samples=0;
    integer band_count,max_band,cycles,bad_state,i;

    // Module defaults are part of this test: production timeout remains 4096.
    player_spectrum_analyzer dut(
        .clk(clk),.rst(rst),.audio_valid(audio_valid),.audio_pcm(audio_pcm),
        .source_change(source_change),.band_valid(band_valid),.band_index(band_index),
        .band_value(band_value),.frame_done(frame_done),
        .debug_coeff_nonzero(debug_coeff_nonzero),.debug_progress(debug_progress),
        .debug_events(debug_events),.debug_accepted(debug_accepted)
    );

    always #20 clk=~clk; // 25 MHz main clock
    always @(posedge rst) global_reset_edges=global_reset_edges+1;

    // TESTBENCH-ONLY fault injection: hold the public FSM register in legal
    // ST_CAPTURE while valid samples continue. No production RTL is modified.
    always @(negedge clk) if(hold_capture) dut.state=5'd0;

    initial begin
        if(!$value$plusargs("SAMPLES=%s",sample_file)) $fatal(1,"missing +SAMPLES");
        $readmemh(sample_file,samples);

        // Assert and release reset off-edge, then allow the two-cycle pixel
        // reset synchronizer plus a settling edge before the first sample.
        #7 rst=1;
        #3 rst=0;
        repeat(3) @(posedge clk);
        #1;
        if(dut.fft_reset!==1'b0 || debug_progress[23:19]!==5'd0 ||
           debug_progress[18:9]!==10'd0 || debug_events!==24'd0 || debug_accepted!==24'd0)
            $fatal(1,"async assertion/pixel release failed progress=%06x events=%06x accepted=%06x",debug_progress,debug_events,debug_accepted);
        $display("PASS reset_release async_assert=1 nonaligned_deassert=1 pixel_wait=3");

        // Verify a source switch resets only analyzer-local progress after a
        // partially captured real-rate frame.
        for(i=0;i<97;i=i+1) send_rate_sample(i);
        if(debug_progress[23:19]!==5'd0 || debug_progress[18:9]!==10'd97 || debug_accepted!==24'd97)
            $fatal(1,"partial capture counters wrong progress=%06x accepted=%0d",debug_progress,debug_accepted);
        pulse_source_change();
        if(debug_progress[23:19]!==5'd0 || debug_progress[18:9]!==10'd0 ||
           debug_events[15:8]!==8'd0 || debug_events[7:0]!==8'd1 || debug_accepted!==24'd0)
            $fatal(1,"source_change did not reset local capture progress progress=%06x events=%06x accepted=%0d",debug_progress,debug_events,debug_accepted);
        $display("PASS source_change abort=1 source_count=%0d accepted_reset=1",debug_events[7:0]);

        // Testbench-only injection of every invalid binary state. The next
        // clock must execute the RTL default branch, clear progress, and return
        // to fresh capture without global reset or source_change.
        for(bad_state=17;bad_state<32;bad_state=bad_state+1) begin
            @(negedge clk);
            audio_valid=0;
            dut.sample_count=10'd777;
            dut.win_index=10'd321;
            dut.state=bad_state[4:0];
            @(posedge clk); #1;
            if(debug_progress[23:19]!==5'd0 || debug_progress[18:9]!==10'd0 ||
               debug_progress[8:0]!==9'd0 || band_valid || frame_done)
                $fatal(1,"illegal state %0d did not recover to clean capture progress=%06x",bad_state,debug_progress);
        end
        if(global_reset_edges!=1 || debug_events[7:0]!==8'd1)
            $fatal(1,"illegal-state recovery used unexpected global/source reset edges=%0d events=%06x",global_reset_edges,debug_events);
        $display("PASS binary_illegal_state_recovery injected=17..31 recovered=15 global_reset_edges=%0d source_changes=%0d",global_reset_edges,debug_events[7:0]);

        // A real-rate 48 kHz tone frame must complete before the production
        // 4096-valid-sample watchdog and must contain nonzero coefficients/data.
        feed_rate_frame(0);
        await_frame("normal");
        if(debug_events[15:8]!==8'd0 || debug_events[7:0]!==8'd1 ||
           debug_accepted!==24'd1024 || debug_coeff_nonzero!==2'b11)
            $fatal(1,"normal frame watchdog/telemetry mismatch events=%06x accepted=%0d coeff=%b",debug_events,debug_accepted,debug_coeff_nonzero);
        $display("PASS normal_real_rate_frame max_band=%0d accepted=%0d recovery_count=%0d",max_band,debug_accepted,debug_events[15:8]);

        // Stall in capture using a testbench-only force. Keep audio_valid at
        // 521-clock intervals until the default 4096-sample timeout fires.
        // The source stimulus remains independent and receives no recovery
        // feedback; no source_change or global reset is generated here.
        @(negedge clk); hold_capture=1; audio_valid=0;
        for(i=0;i<4096;i=i+1) send_rate_sample(i);
        @(negedge clk); hold_capture=0; audio_valid=0; audio_pcm=0;
        @(posedge clk); #1;
        if(debug_events[15:8]!==8'd1 || debug_events[7:0]!==8'd1 ||
           debug_progress[23:19]!==5'd0 || debug_progress[18:9]!==10'd0 ||
           debug_accepted!==24'd5120 || global_reset_edges!=1)
            $fatal(1,"watchdog did not recover local capture events=%06x progress=%06x accepted=%0d global_rst=%0d",debug_events,debug_progress,debug_accepted,global_reset_edges);
        $display("PASS watchdog_timeout default=4096 recovery_count=%0d source_changes=%0d accepted=%0d",debug_events[15:8],debug_events[7:0],debug_accepted);

        // Prove recovery is autonomous: without source_change/global reset,
        // the next full 521-clock frame must reach nonzero bands and frame_done.
        feed_rate_frame(0);
        await_frame("post_timeout");
        if(debug_events[15:8]!==8'd1 || debug_events[7:0]!==8'd1 ||
           debug_accepted!==24'd6144 || global_reset_edges!=1)
            $fatal(1,"post-timeout autonomous frame mismatch events=%06x accepted=%0d global_rst=%0d",debug_events,debug_accepted,global_reset_edges);
        $display("PASS autonomous_post_timeout_frame max_band=%0d accepted=%0d recovery_count=%0d source_changes=%0d",max_band,debug_accepted,debug_events[15:8],debug_events[7:0]);

        // Test saturating telemetry at the boundary. These hierarchical
        // counter deposits are testbench-only boundary setup, not RTL changes.
        @(negedge clk); dut.accepted_samples=24'hfffffe;
        send_rate_sample(0);
        if(debug_accepted!==24'hffffff) $fatal(1,"accepted counter did not reach saturation: %06x",debug_accepted);
        send_rate_sample(1);
        if(debug_accepted!==24'hffffff) $fatal(1,"accepted counter did not saturate: %06x",debug_accepted);

        @(negedge clk); dut.frame_age_samples=12'd4095; dut.recovery_count=8'hfe;
        send_rate_sample(2);
        if(debug_events[15:8]!==8'hff) $fatal(1,"recovery counter failed to saturate: %06x",debug_events);
        @(negedge clk); dut.frame_age_samples=12'd4095;
        send_rate_sample(3);
        if(debug_events[15:8]!==8'hff) $fatal(1,"recovery counter wrapped: %06x",debug_events);

        @(negedge clk); dut.source_change_count=8'hfe;
        pulse_source_change();
        if(debug_events[7:0]!==8'hff || debug_accepted!==24'd0)
            $fatal(1,"source-change counter/reset boundary failed events=%06x accepted=%0d",debug_events,debug_accepted);
        pulse_source_change();
        if(debug_events[7:0]!==8'hff) $fatal(1,"source-change counter wrapped: %06x",debug_events);
        if(global_reset_edges!=1) $fatal(1,"unexpected global reset edge count=%0d",global_reset_edges);
        $display("PASS telemetry_saturation recovery=%0d source_change=%0d accepted=%06x",debug_events[15:8],debug_events[7:0],debug_accepted);
        $display("PASS fft_recover production_timeout=4096 real_rate=521clk invalid_states=17..31 autonomous_recovery=1 source_feedback=none global_reset_edges=%0d",global_reset_edges);
        $finish;
    end

    task send_rate_sample(input integer index);
        begin
            @(negedge clk);
            audio_pcm=$signed(samples[index%1024]); audio_valid=1;
            @(posedge clk); #1;
            sent_samples=sent_samples+1;
            @(negedge clk); audio_valid=0; audio_pcm=0;
            repeat(520) @(negedge clk);
        end
    endtask

    task pulse_source_change;
        begin
            @(negedge clk); audio_valid=0; audio_pcm=0; source_change=1;
            @(posedge clk); #1;
            @(negedge clk); source_change=0;
            repeat(3) @(posedge clk);
            #1;
        end
    endtask

    task feed_rate_frame(input integer first_sample);
        integer n;
        begin
            for(n=0;n<1024;n=n+1) send_rate_sample(first_sample+n);
        end
    endtask

    task await_frame(input [8*24-1:0] label);
        integer n;
        reg done_seen;
        begin
            band_count=0; max_band=0; done_seen=0;
            for(n=0;n<60000 && !done_seen;n=n+1) begin
                @(posedge clk); #1;
                if(band_valid) begin
                    if(band_index!==band_count[4:0]) $fatal(1,"%0s band order mismatch got=%0d expected=%0d",label,band_index,band_count);
                    if(band_value>max_band) max_band=band_value;
                    band_count=band_count+1;
                end
                if(frame_done) done_seen=1;
            end
            if(!done_seen || band_count!=24 || max_band==0)
                $fatal(1,"%0s frame failed done=%0d bands=%0d max=%0d progress=%06x",label,done_seen,band_count,max_band,debug_progress);
        end
    endtask

    initial begin
        #300000000;
        $fatal(1,"tb_fft_recover global timeout at progress=%06x events=%06x accepted=%06x",debug_progress,debug_events,debug_accepted);
    end
endmodule
