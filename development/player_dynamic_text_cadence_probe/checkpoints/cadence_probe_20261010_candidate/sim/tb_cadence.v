`timescale 1ns/1ps
module tb_cadence;
    reg clk=0; always #20 clk=~clk;
    reg rst=1, manual_audio=0, use_tone=0, mode=0;
    reg valid=0,user=0,toggle=0,locked=0;
    reg [9:0] clock_word=10'h3e0;
    wire tone_valid;
    wire [23:0] tone_l,tone_r;
    wire av=use_tone?tone_valid:manual_audio;
    wire [3:0] flags;
    wire [23:0] gaps,bad_frame,halves,period,samples,clock_errors,id;
    hdmi_audio_tone_pcm_scale tone(.I_clk(clk),.I_rst(rst),
        .O_audio_valid(tone_valid),.O_audio_left_data(tone_l),.O_audio_right_data(tone_r));
    player_cadence_probe dut(.clk(clk),.rst(rst),.audio_valid(av),.tone_mode(mode),
        .valid(valid),.user(user),.window_toggle(toggle),.locked(locked),
        .tmds_clock_word(clock_word),.flags(flags),.audio_gap_range(gaps),
        .bad_gap_frame_samples(bad_frame),.window_half_cycles(halves),
        .frame_period(period),.window_audio_samples(samples),
        .clock_word_errors(clock_errors),.build_id(id));
    integer checks=0;
    task check;
        input cond;
        input [8*100-1:0] label;
        begin
            checks=checks+1;
            if(cond!==1'b1) begin $display("FAIL %0s t=%0t gaps=%h badframe=%h",label,$time,gaps,bad_frame); $fatal(1);end
        end
    endtask
    task cycles;
        input integer n;
        begin repeat(n) @(negedge clk); end
    endtask
    task pulse;
        begin manual_audio=1;cycles(1);manual_audio=0;end
    endtask
    task reset;
        begin rst=1; cycles(3);rst=0;cycles(2);end
    endtask

    // Independent scoreboard counts edges/events between external markers.
    reg score=0, seen_frame=0,seen_window=0,old_toggle=0;
    integer edge_number=0, frame_start=0, window_start=0;
    integer ref_frame_audio=0,ref_window_audio=0,frames_checked=0,windows_checked=0;
    integer frame_interval,window_interval;
    always @(posedge clk) begin
        if(rst || !score) begin
            edge_number=0;seen_frame=0;seen_window=0;old_toggle=toggle;
            ref_frame_audio=0;ref_window_audio=0;
        end else begin
            edge_number=edge_number+1;
            if(valid && user) begin
                frame_interval=edge_number-frame_start;
                if(seen_frame) begin
                    #1;
                    check(period==frame_interval,"frame period matches independent edges");
                    check(bad_frame[11:0]==ref_frame_audio,"frame audio equals independent count");
                    check(ref_frame_audio==806 || ref_frame_audio==807,"real 420000 frame gets806or807");
                    frames_checked=frames_checked+1;
                end
                seen_frame=1;frame_start=edge_number;ref_frame_audio=0;
            end
            // AV is sampled pre-edge by the production observer. The tone
            // source updates on the same edge, so use the saved TB value below.
            if(toggle!=old_toggle) begin
                window_interval=edge_number-window_start;
                if(seen_window) begin
                    #1;
                    check(halves==window_interval/2,"half-cycle count independent interval");
                    check(samples==ref_window_audio+sampled_audio,"window audio count independent");
                    check(window_interval==25000000,"one full unscaled25M edge interval");
                    check(samples==48000,"one full window48000 audio samples");
                    windows_checked=windows_checked+1;
                    $display("REAL_WINDOW edges=%0d half_ticks=%0d samples=%0d gaps=%h",window_interval,halves,samples,gaps);
                end
                seen_window=1;window_start=edge_number;ref_window_audio=0;
            end else if(seen_window && sampled_audio) ref_window_audio=ref_window_audio+1;
            if(seen_frame && sampled_audio) ref_frame_audio=ref_frame_audio+1;
            old_toggle=toggle;
        end
    end
    // Stable through the next posedge/NBA; avoids a scoreboard race with tone.
    reg sampled_audio=0;
    always @(negedge clk) #1 sampled_audio=av;

    integer i;
    initial begin
        cycles(3);rst=0;cycles(2);
        check(id==24'hc10902,"build id");
        check(gaps==24'hfff000,"reset gap state");
        pulse();cycles(519);pulse();cycles(520);pulse();
        check(gaps==24'h208209,"nominal520and521 gaps");
        check(bad_frame[23:12]==0,"nominal no bad gaps");
        cycles(1041);pulse();
        check(gaps[11:0]==1042 && bad_frame[23:12]==1,"missing sample gap recorded");
        manual_audio=1;cycles(2);manual_audio=0;
        check(gaps[23:12]==1 && bad_frame[23:12]==3,"consecutive pulses recorded");
        cycles(5000);pulse();
        check(gaps[11:0]==4095 && bad_frame[23:12]==4,"long gap saturation");
        mode=1;cycles(1);
        check(gaps==24'hfff000 && bad_frame[23:12]==0,"mode clears history");
        pulse();cycles(519);pulse();
        check(gaps==24'h208208 && bad_frame[23:12]==0,"first gap after switch");
        clock_word=0;cycles(4);
        check(clock_errors[23:10]==0,"unlocked clock invalid ignored");
        locked=1;cycles(5);
        check(clock_errors[23:10]==5,"locked clock invalid counted");
        clock_word=10'h01f;cycles(4);
        check(clock_errors=={14'd5,10'h01f},"valid inverted clock word");
        clock_word=10'h3e0;cycles(2);
        check(clock_errors=={14'd5,10'h3e0},"valid clock word");
        clock_word=0;cycles(17000);
        check(clock_errors[23:10]==16383,"clock errors saturate");
        manual_audio=1;cycles(4200);manual_audio=0;
        check(bad_frame[23:12]==4095,"bad gap count saturates");
        score=0;mode=0;toggle=0;locked=1;clock_word=10'h3e0;valid=0;user=0;
        reset();
        check(clock_errors==24'h0003e0 && period==0 && samples==0,"reset clears histories");
        use_tone=1;score=1;cycles(1000);toggle=1;valid=1;user=1;
        fork
            begin
                repeat(59) begin cycles(1);valid=0;user=0;cycles(419999);valid=1;user=1;end
                cycles(1);valid=0;user=0;
            end
            begin cycles(25000000);toggle=0;end
        join
        cycles(3);
        check(windows_checked==1 && frames_checked==59,"all independent scoreboards executed");
        check(gaps==24'h208209 && bad_frame[23:12]==0,"steady real tone gaps");
        check(flags==4'h7,"wav mode diagnostic flags");
        $display("PASS checks=%0d frames=%0d real_windows=%0d",checks,frames_checked,windows_checked);
        $finish;
    end
    initial begin #1100000000; $fatal(1,"timeout");end
endmodule
