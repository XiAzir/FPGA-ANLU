`timescale 1ns/1ps
module tb_player_pcm_crc_probe;
    localparam integer BLOCK_SAMPLES=4096;
    localparam integer POSITIVE_SAMPLES=3*BLOCK_SAMPLES;
    reg clk=0, rst=1, audio_valid=0;
    reg [23:0] audio_left=0, audio_right=0;
    wire [15:0] first_crc,last_crc,block_index;
    wire [23:0] sample_count;
    always #5 clk=~clk;

    reg [15:0] samples[0:POSITIVE_SAMPLES-1];
    reg [15:0] expected_crc[0:2];
    reg [15:0] expected_negative[0:0];
    integer phase=0;
    integer checked_blocks=0;
    integer i, period_cycles;
    reg [15:0] saved_first;

    player_pcm_crc_probe dut (
        .clk(clk),.rst(rst),.audio_valid(audio_valid),
        .audio_left(audio_left),.audio_right(audio_right),
        .first_crc(first_crc),.last_crc(last_crc),.block_index(block_index),
        .sample_count(sample_count)
    );

    task automatic send_sample(input integer sample_index,input integer flip_left,input integer spacing);
        reg [15:0] pcm;
        begin
            pcm=samples[sample_index];
            @(negedge clk);
            audio_left={pcm,8'h00};
            if(flip_left && sample_index==0) audio_left=audio_left ^ 24'h000100;
            audio_right={pcm,8'h00};
            audio_valid=1'b1;
            @(negedge clk);
            audio_valid=1'b0;
            repeat(spacing-2) @(negedge clk);
        end
    endtask

    task automatic reset_probe;
        begin
            @(negedge clk); rst=1'b1; audio_valid=1'b0;
            repeat(3) @(posedge clk);
            #1;
            if(first_crc!==0 || last_crc!==0 || block_index!==0 || sample_count!==0)
                $fatal(1,"reset outputs not cleared first=%h last=%h block=%0d count=%0d",first_crc,last_crc,block_index,sample_count);
            @(negedge clk); rst=1'b0;
        end
    endtask

    always @(posedge clk) begin
        if(rst) checked_blocks=0;
        else if(dut.blocks_completed > checked_blocks) begin
            checked_blocks=dut.blocks_completed;
            #1;
            if(phase==1) begin
                if(checked_blocks>3) $fatal(1,"unexpected positive block %0d",checked_blocks);
                if(last_crc!==expected_crc[checked_blocks-1])
                    $fatal(1,"positive CRC block=%0d got=%h expected=%h",checked_blocks-1,last_crc,expected_crc[checked_blocks-1]);
                if(block_index!==checked_blocks-1)
                    $fatal(1,"positive block index got=%0d expected=%0d",block_index,checked_blocks-1);
                if(first_crc!==expected_crc[0])
                    $fatal(1,"first CRC did not freeze got=%h expected=%h",first_crc,expected_crc[0]);
            end else if(phase==2) begin
                if(checked_blocks!=1 || last_crc!==expected_negative[0] ||
                   first_crc!==expected_negative[0] || block_index!==0)
                    $fatal(1,"negative CRC result block=%0d first=%h last=%h expected=%h index=%0d",checked_blocks,first_crc,last_crc,expected_negative[0],block_index);
            end
        end
    end

    initial begin
        $readmemh("samples_3blocks.mem",samples);
        $readmemh("expected_3blocks.mem",expected_crc);
        $readmemh("expected_negative.mem",expected_negative);
        if((^samples[0])===1'bx || (^samples[POSITIVE_SAMPLES-1])===1'bx ||
           (^expected_crc[0])===1'bx || (^expected_crc[2])===1'bx || (^expected_negative[0])===1'bx)
            $fatal(1,"missing generated golden fixture");

        repeat(4) @(posedge clk);
        #1;
        if(first_crc!==0 || last_crc!==0 || sample_count!==0) $fatal(1,"reset initialization failed");
        @(negedge clk); rst=1'b0;

        phase=1;
        for(i=0;i<POSITIVE_SAMPLES;i=i+1) begin
            period_cycles=(i%2==0)?520:521;
            send_sample(i,0,period_cycles);
        end
        repeat(50) @(posedge clk);
        #1;
        if(checked_blocks!=3 || sample_count!==24'd12288 || block_index!==16'd2 ||
           first_crc!==expected_crc[0] || last_crc!==expected_crc[2])
            $fatal(1,"three-block final state blocks=%0d count=%0d index=%0d first=%h last=%h",checked_blocks,sample_count,block_index,first_crc,last_crc);
        saved_first=first_crc;
        $display("PASS positive CRC: blocks=3 samples=%0d first=%h block1=%h block2=%h",sample_count,first_crc,expected_crc[1],last_crc);

        reset_probe();
        phase=2;
        for(i=0;i<BLOCK_SAMPLES;i=i+1) begin
            period_cycles=(i%2==0)?521:520;
            send_sample(i,(i==0),period_cycles);
        end
        repeat(50) @(posedge clk);
        #1;
        if(checked_blocks!=1 || sample_count!==24'd4096 || block_index!==16'd0 ||
           first_crc!==expected_negative[0] || last_crc!==expected_negative[0] ||
           expected_negative[0]===saved_first)
            $fatal(1,"single-bit negative control failed first=%h last=%h neg=%h base=%h",first_crc,last_crc,expected_negative[0],saved_first);
        $display("PASS single-bit negative control: base=%h flipped_L_pcm_lsb=%h",saved_first,expected_negative[0]);
        $display("PASS reset and 520/521-cycle cadence checks");
        $finish;
    end

    initial begin
        #200000000;
        $fatal(1,"watchdog sample_count=%0d block=%0d",sample_count,block_index);
    end
endmodule
