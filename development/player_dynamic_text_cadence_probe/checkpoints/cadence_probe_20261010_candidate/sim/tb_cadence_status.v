`timescale 1ns/1ps
// Exercise the actual status mailbox toggle and observer together. Only the
// mailbox/page timebase is scaled; audio DDS and video frame length are real.
module tb_cadence_status;
    reg clk=0; always #20 clk=~clk;
    reg rst=1, tone_mode=0;
    reg [18:0] frame_count=0;
    wire sof=(frame_count==0);
    wire av, toggle;
    wire [23:0] left_pcm, right_pcm;
    wire [3:0] flags;
    wire [23:0] gaps, bad_frame, halves, period, samples, clock_errors, id;
    wire [31:0] hex_value;
    hdmi_audio_tone_pcm_scale tone(.I_clk(clk),.I_rst(rst),
        .O_audio_valid(av),.O_audio_left_data(left_pcm),.O_audio_right_data(right_pcm));
    always @(posedge clk) begin
        if(rst || frame_count==419999) frame_count<=0;
        else frame_count<=frame_count+1'b1;
    end
    player_cadence_probe observer(.clk(clk),.rst(rst),.audio_valid(av),
        .tone_mode(tone_mode),.valid(sof),.user(sof),.window_toggle(toggle),
        .locked(1'b1),.tmds_clock_word(10'h3e0),.flags(flags),
        .audio_gap_range(gaps),.bad_gap_frame_samples(bad_frame),
        .window_half_cycles(halves),.frame_period(period),
        .window_audio_samples(samples),.clock_word_errors(clock_errors),.build_id(id));
    player_status_monitor #(.PIXEL_HZ(50000),.SYS_HZ(50000),
        .PAGE_SECONDS(1),.SHOW_SELF_TEST(0)) status(
        .pixel_clk(clk),.sys_clk(clk),.rst(rst),.sys_rst(rst),
        .axis_rgb(24'd0),.axis_valid(sof),.axis_user(sof),.hdmi_locked(1'b1),
        .audio_valid(av),.tone_mode(tone_mode),.underflow(1'b0),.audio_pcm(left_pcm),
        .startup_flags(4'hd),.file_flags(8'ha8),.fs_code(8'd0),.wav_map_code(8'd0),
        .packet_samples(gaps),.packet_count(bad_frame),.packet_bad_bch(halves),
        .packet_bad_terc(period),.packet_tone_bad(samples),.packet_cts(clock_errors),
        .packet_n(id),.packet_flags(flags),.window_toggle_out(toggle),.hex_value(hex_value));

    integer checks=0, cycles=0, last_toggle=0, windows=0, frame_events=0;
    integer ref_samples=0, ref_frame_audio=0, last_frame=0;
    reg prev_toggle=0, window_seen=0, frame_seen=0;
    reg [15:0] pages_seen=0;
    task check;
        input cond;
        input [8*100-1:0] label_text;
        begin
            checks=checks+1;
            if(cond!==1'b1) begin $display("FAIL %0s at %0t",label_text,$time);$fatal(1);end
        end
    endtask
    reg sampled_av;
    always @(posedge clk) begin
        if(!rst) begin
            sampled_av=av;
            cycles=cycles+1;
            if(sof) begin
                if(frame_seen) begin
                    #1;
                    check(period==cycles-last_frame,"observed frame interval");
                    check(bad_frame[11:0]==ref_frame_audio,"per-frame samples");
                    check(ref_frame_audio==806 || ref_frame_audio==807,"real frame sample cadence");
                    frame_events=frame_events+1;
                end
                frame_seen=1;last_frame=cycles;ref_frame_audio=0;
            end
            if(frame_seen && sampled_av) ref_frame_audio=ref_frame_audio+1;
            if(toggle!=prev_toggle) begin
                if(window_seen) begin
                    #1;
                    check(cycles-last_toggle==50000,"mailbox ack has no missed window");
                    check(halves==25000,"observer sees actual mailbox toggle interval");
                    check(samples==ref_samples+sampled_av,"observer sees independent sample count");
                    check(samples==96,"scaled window exact DDS count");
                    windows=windows+1;
                end
                last_toggle=cycles;window_seen=1;ref_samples=0;
                prev_toggle=toggle;
            end else if(window_seen && sampled_av) ref_samples=ref_samples+1;
        end
    end
    always @(negedge clk) begin
        #2;
        if(!rst && cycles>100000) begin
            pages_seen[hex_value[31:28]]=1;
            case(hex_value[31:28])
                4'h1: if(hex_value!==32'h1da80000) $fatal(1,"startup page");
                // Mode is captured at a window boundary; allow either mode
                // while switching. Both must retain the exact sample count.
                4'h3: if(hex_value[23:0]!==24'd96) $fatal(1,"audio mailbox page");
                4'h6: if(hex_value[23:0]!==gaps) $fatal(1,"gap page binding");
                4'h7: if(hex_value[23:0]!==bad_frame) $fatal(1,"frame sample page binding");
                4'h8: if(hex_value[23:0]!==halves) $fatal(1,"window edge page binding");
                4'h9: if(hex_value[23:0]!==period) $fatal(1,"frame period page binding");
                4'ha: if(hex_value[23:0]!==samples) $fatal(1,"window sample page binding");
                4'hb: if(hex_value[23:0]!==clock_errors) $fatal(1,"clock word page binding");
                4'hc: if(hex_value[23:0]!==24'hc10902) $fatal(1,"build ID page binding");
                default: $fatal(1,"unexpected page prefix");
            endcase
        end
    end
    initial begin
        repeat(4) @(negedge clk); #3; rst=0;
        repeat(460000) @(negedge clk); #3; tone_mode=1;
        repeat(460000) @(negedge clk); #3;
        check(windows>=16,"multiple mailbox handshakes");
        check(frame_events==2,"two full real frame intervals");
        check((pages_seen & 16'h1fca)==16'h1fca,"all nine pages observed");
        check(gaps==24'h208209 && bad_frame[23:12]==0,"mode switch resets gap history");
        check(flags==4'hf,"tone mode flags");
        check(clock_errors==24'h0003e0,"TMDS clock word value");
        $display("PASS checks=%0d windows=%0d frames=%0d pages=%h",checks,windows,frame_events,pages_seen);
        $finish;
    end
    initial begin #40000000; $fatal(1,"timeout");end
endmodule
