`timescale 1ns/1ps
module tb_spectrum_real_music;
    reg clk=0,rst=1,audio_valid=0,source_change=0;
    reg signed [15:0] audio_pcm=0;
    wire band_valid,frame_done;
    wire [4:0] band_index;
    wire [15:0] band_value;
    reg [15:0] samples[0:2047];
    reg [15:0] expected[0:47];
    reg [1023:0] sample_file,expected_file;
    integer frame_id,i,c,count,diff,max_diff=0,failures=0;
    player_spectrum_analyzer dut(.clk(clk),.rst(rst),.audio_valid(audio_valid),.audio_pcm(audio_pcm),
        .source_change(source_change),.band_valid(band_valid),.band_index(band_index),
        .band_value(band_value),.frame_done(frame_done));
    always #20 clk=~clk;
    initial begin
        if(!$value$plusargs("SAMPLES=%s",sample_file)) $fatal(1,"missing +SAMPLES");
        if(!$value$plusargs("EXPECTED=%s",expected_file)) $fatal(1,"missing +EXPECTED");
        $readmemh(sample_file,samples);$readmemh(expected_file,expected);
        @(negedge clk);rst=1;repeat(3)@(negedge clk);rst=0;
        for(frame_id=0;frame_id<2;frame_id=frame_id+1) begin
            for(i=0;i<1024;i=i+1) begin
                @(negedge clk);audio_pcm=samples[frame_id*1024+i];audio_valid=1;
            end
            @(negedge clk);audio_valid=0;audio_pcm=0;
            count=0;
            for(c=0;c<60000 && count<24;c=c+1) begin
                @(posedge clk);#1;
                if(band_valid) begin
                    if(band_index!==count[4:0]) begin $display("FAIL frame=%0d order got=%0d expected=%0d",frame_id,band_index,count);failures=failures+1;end
                    diff=$signed({1'b0,band_value})-$signed({1'b0,expected[frame_id*24+count]});if(diff<0)diff=-diff;
                    if(diff>max_diff)max_diff=diff;
                    if(diff!=0) begin $display("FAIL frame=%0d band=%0d got=%0d expected=%0d diff=%0d",frame_id,band_index,band_value,expected[frame_id*24+count],diff);failures=failures+1;end
                    if(frame_done!==(count==23)) begin $display("FAIL frame_done alignment frame=%0d band=%0d done=%b",frame_id,count,frame_done);failures=failures+1;end
                    $display("MUSIC_BAND %0d %0d %0d",frame_id,count,band_value);
                    count=count+1;
                end
            end
            if(count!=24) begin $display("FAIL frame=%0d timeout outputs=%0d",frame_id,count);failures=failures+1;end
        end
        if(max_diff!=0) begin $display("FAIL max_abs_error=%0d",max_diff);failures=failures+1;end
        if(failures) $fatal(1,"real music failures=%0d",failures);
        $display("PASS real_music_windows=2 fft_frames=2 bands=48 max_abs_error=%0d continuous_capture=1",max_diff);
        $finish;
    end
endmodule
