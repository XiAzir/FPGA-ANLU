`timescale 1ns/1ps
module tb_player_spectrum_analyzer;
    localparam integer CASES=13;
    reg clk=0, rst=1, audio_valid=0, source_change=0;
    reg signed [15:0] audio_pcm=0;
    wire band_valid, frame_done;
    wire [4:0] band_index;
    wire [15:0] band_value;
    reg [15:0] sample_mem [0:CASES*1024-1];
    reg [15:0] expected_mem [0:CASES*24-1];
    integer case_id, count, diff, i, c;
    integer failures=0,max_diff=0;
    reg [1023:0] vec_file, exp_file;
    player_spectrum_analyzer dut(.clk(clk),.rst(rst),.audio_valid(audio_valid),.audio_pcm(audio_pcm),
        .source_change(source_change),.band_valid(band_valid),.band_index(band_index),
        .band_value(band_value),.frame_done(frame_done));
    always #10 clk=~clk;
    initial begin
        if (!$value$plusargs("VEC=%s",vec_file)) $fatal(1,"missing +VEC");
        if (!$value$plusargs("EXP=%s",exp_file)) $fatal(1,"missing +EXP");
        $readmemh(vec_file,sample_mem);
        $readmemh(exp_file,expected_mem);
        for(case_id=0;case_id<CASES;case_id=case_id+1) begin
            reset_dut();
            feed_frame(case_id);
            await_and_check(case_id, 60000);
        end
        // One physical-rate capture uses 521 main-clock cycles between audio samples.
        reset_dut(); feed_frame_physical_rate(1); await_and_check(1,60000);
        // Back-to-back frames prove automatic recapture after frame_done.
        reset_dut(); feed_frame(5); await_and_check(5,60000);
        feed_frame(0); await_and_check(0,60000);
        // source_change during partial capture must discard the old prefix.
        reset_dut();
        for(i=0;i<400;i=i+1) begin
            @(negedge clk); audio_pcm=sample_mem[i]; audio_valid=1;
            if(band_valid || frame_done) fail("stale result during partial capture");
        end
        pulse_source_change();
        feed_frame(2); await_and_check(2,60000);
        // source_change during analysis must abort pending old-frame publication.
        reset_dut(); feed_frame(0);
        repeat(150) @(negedge clk);
        pulse_source_change();
        feed_frame(2); await_and_check(2,60000);
        // Reset during analysis must also suppress a stale result and restart cleanly.
        reset_dut(); feed_frame(2);
        repeat(150) @(negedge clk);
        reset_dut(); feed_frame(0); await_and_check(0,60000);
        if(max_diff!=0) begin $display("FAIL fixed-point oracle max absolute error=%0d",max_diff); failures=failures+1; end
        if(failures!=0) $fatal(1,"spectrum analyzer failures=%0d",failures);
        $display("PASS spectrum_analyzer cases=%0d output_bands=%0d max_fixedpoint_error=%0d physical_rate_capture=521clk plus_continuous_frames=2 source_change_abort=2 reset_abort=1",CASES,CASES*24,max_diff);
        $finish;
    end
    task fail(input [8*96-1:0] message);
        begin $display("FAIL %0s",message); failures=failures+1; end
    endtask
    task reset_dut;
        begin
            @(negedge clk); rst=1; audio_valid=0; source_change=0; audio_pcm=0;
            repeat(3) @(negedge clk);
            rst=0;
            @(negedge clk);
            if(band_valid || frame_done) fail("output active after reset release");
        end
    endtask
    task feed_frame(input integer id);
        integer n;
        begin
            for(n=0;n<1024;n=n+1) begin
                @(negedge clk); audio_pcm=sample_mem[id*1024+n]; audio_valid=1;
                if(n>0 && (band_valid || frame_done)) fail("unexpected output while feeding capture frame");
            end
            @(negedge clk); audio_valid=0; audio_pcm=0;
        end
    endtask
    task feed_frame_physical_rate(input integer id);
        integer n;
        begin
            for(n=0;n<1024;n=n+1) begin
                @(negedge clk); audio_pcm=sample_mem[id*1024+n]; audio_valid=1;
                @(negedge clk); audio_valid=0;
                if(n<1023) repeat(520) @(negedge clk);
            end
            @(negedge clk); audio_pcm=0;
        end
    endtask
    task pulse_source_change;
        begin
            @(negedge clk); audio_valid=0; source_change=1;
            @(negedge clk); source_change=0;
            if(band_valid || frame_done) fail("source_change leaked stale output");
        end
    endtask
    task await_and_check(input integer id, input integer timeout_cycles);
        integer cyc;
        begin
            count=0;
            for(cyc=0;cyc<timeout_cycles && count<24;cyc=cyc+1) begin
                @(posedge clk); #1;
                if(band_valid) begin
                    if(band_index !== count[4:0]) begin
                        $display("FAIL case=%0d band order count=%0d index=%0d",id,count,band_index); failures=failures+1;
                    end
                    diff=$signed({1'b0,band_value})-$signed({1'b0,expected_mem[id*24+count]});
                    if(diff<0) diff=-diff;
                    if(diff>max_diff) max_diff=diff;
                    if(diff>0) begin
                        $display("FAIL case=%0d band=%0d got=%0d expected=%0d diff=%0d",id,band_index,band_value,expected_mem[id*24+count],diff); failures=failures+1;
                    end
                    if(frame_done !== (count==23)) begin
                        $display("FAIL case=%0d frame_done alignment count=%0d done=%b",id,count,frame_done); failures=failures+1;
                    end
                    count=count+1;
                end else if(frame_done) begin
                    $display("FAIL case=%0d frame_done without band_valid",id); failures=failures+1;
                end
            end
            if(count!=24) begin $display("FAIL case=%0d timeout emitted=%0d",id,count); failures=failures+1; end
            if(failures!=0) $fatal(1,"spectrum analyzer failures=%0d",failures);
        end
    endtask
endmodule







