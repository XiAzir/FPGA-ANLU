`timescale 1ns/1ps
module tb_wav_service_gap;
    localparam integer FILE_BYTES=8270;
    localparam integer CARD_BYTES=8704;
    localparam integer DATA_OFFSET=78;
    localparam integer LOOP_SAMPLES=4096;
    localparam integer TARGET_OUTPUTS=12000;
    localparam integer PIXEL_HZ=12;
    localparam integer SAMPLE_HZ=1;

    reg clk=0, rst=1, init_done=0;
    always #5 clk=~clk;
    reg [7:0] card[0:CARD_BYTES-1];
    wire sd_read;
    wire [31:0] sd_addr;
    reg [7:0] sd_data=0;
    reg sd_valid=0, sd_end=0;
    wire sample_take, primed, player_error;
    wire [15:0] sample_data;
    wire sample_available;
    wire audio_valid, underflow;
    wire [23:0] audio_left, audio_right;
    integer fd, b, i;
    integer active=0, byte_index=0, delay_left=0, stall_cycles=0;
    integer stall_done=0, stall_fifo_count=-1, requests=0;
    integer takes=0, delivered=0, outputs=0, silence_outputs=0;
    integer first_underflow_seen=0, first_underflow_output=-1, recovery_seen=0;
    integer expected_idx, expected_lo, expected_hi;
    reg [15:0] expected_word;

    tf_wav_file_player #(.FIFO_DEPTH(2048),.WAIT_LIMIT(1000000)) u_player (
        .clk(clk),.rst(rst),.sd_init_done(init_done),.file_size(FILE_BYTES),.file_error(1'b0),
        .sd_read(sd_read),.sd_addr(sd_addr),.sd_data(sd_data),.sd_valid(sd_valid),.sd_end(sd_end),
        .sample_take(sample_take),.sample_data(sample_data),.sample_available(sample_available),
        .primed(primed),.error(player_error),.debug_state(),.debug_phase(),
        .debug_scan_pos(),.debug_scan_byte(),.debug_sample_push(),.debug_push_data(),
        .debug_push_pos(),.debug_data_offset()
    );
    wav_pcm_bridge #(.PIXEL_HZ(PIXEL_HZ),.SAMPLE_HZ(SAMPLE_HZ),.PLAY_GATE(1)) u_bridge (
        .pixel_clk(clk),.sd_clk(clk),.rst(rst),.primed(primed),.play_enable(1'b1),
        .sample_available(sample_available),.sample_data(sample_data),.sample_take(sample_take),
        .audio_valid(audio_valid),.audio_left(audio_left),.audio_right(audio_right),.underflow(underflow)
    );

    initial begin
        for(i=0;i<CARD_BYTES;i=i+1) card[i]=0;
        fd=$fopen("short_loop_4096.wav","rb");
        if(!fd) $fatal(1,"cannot open short_loop_4096.wav");
        for(i=0;i<FILE_BYTES;i=i+1) begin
            b=$fgetc(fd);
            if(b<0) $fatal(1,"short fixture at byte %0d",i);
            card[i]=b[7:0];
        end
        b=$fgetc(fd);
        if(b>=0) $fatal(1,"fixture longer than expected");
        $fclose(fd);
        if(!$value$plusargs("STALL_CYCLES=%d",stall_cycles)) stall_cycles=0;
        repeat(8) @(negedge clk);
        rst=0;
        init_done=1;
    end

    // A flat logical-file sector model with a selectable no-service interval.
    // The delay starts on the first playback request after priming.
    always @(negedge clk) begin
        if(rst) begin
            active=0; byte_index=0; delay_left=0;
            sd_data=0; sd_valid=0; sd_end=0;
        end else begin
            sd_valid=0; sd_end=0;
            if(!active && sd_read) begin
                active=1; byte_index=0; requests=requests+1;
                if(stall_cycles>0 && primed && !stall_done) begin
                    stall_done=1;
                    stall_fifo_count=u_player.fifo_count;
                    delay_left=stall_cycles;
                    $display("SERVICE_GAP begin cycles=%0d fifo_count=%0d request=%0d",stall_cycles,stall_fifo_count,requests);
                end
            end else if(active && delay_left>0) begin
                delay_left=delay_left-1;
            end else if(active && byte_index<512) begin
                sd_data=card[sd_addr*512+byte_index];
                sd_valid=1;
                byte_index=byte_index+1;
            end else if(active) begin
                sd_end=1;
                active=0;
            end
        end
    end

    always @(posedge clk) begin
        if(!rst) begin
            if(player_error) $fatal(1,"WAV player error fifo=%0d state=%0d",u_player.fifo_count,u_player.state);
            if(sample_take && sample_available) takes=takes+1;
            if(underflow && !first_underflow_seen) begin
                first_underflow_seen=1;
                first_underflow_output=outputs;
                $display("UNDERFLOW_FIRST output=%0d takes=%0d fifo=%0d state=%0d waiting=%b prefetch_valid=%b",outputs,takes,u_player.fifo_count,u_player.state,u_bridge.waiting,u_bridge.prefetch_valid);
            end
            if(audio_valid) begin
                expected_idx=delivered%LOOP_SAMPLES;
                expected_lo=DATA_OFFSET+expected_idx*2;
                expected_hi=expected_lo+1;
                expected_word={card[expected_hi],card[expected_lo]};
                if(delivered<takes) begin
                    if(audio_left!=={expected_word,8'b0} || audio_right!=={expected_word,8'b0})
                        $fatal(1,"audio mismatch out=%0d takes=%0d L=%h R=%h expected=%h",outputs,takes,audio_left,audio_right,{expected_word,8'b0});
                    delivered=delivered+1;
                    if(first_underflow_seen) recovery_seen=1;
                end else begin
                    if(audio_left!==24'd0 || audio_right!==24'd0)
                        $fatal(1,"missing-sample slot must be silence out=%0d L=%h R=%h",outputs,audio_left,audio_right);
                    silence_outputs=silence_outputs+1;
                end
                outputs=outputs+1;
                if(outputs==TARGET_OUTPUTS) begin
                    if(stall_cycles==0 && (underflow || silence_outputs!=0))
                        $fatal(1,"unexpected baseline underflow sticky=%b silence=%0d",underflow,silence_outputs);
                    if(stall_cycles>0 && (!stall_done || !underflow || silence_outputs==0 || !recovery_seen))
                        $fatal(1,"service-gap underflow not reproduced done=%0d sticky=%b silence=%0d fifo_at_gap=%0d",stall_done,underflow,silence_outputs,stall_fifo_count);
                    $display("PASS service test: outputs=%0d takes=%0d requests=%0d stall_cycles=%0d fifo_at_gap=%0d first_underflow_output=%0d underflow=%b inserted_silence=%0d recovery=%b",outputs,takes,requests,stall_cycles,stall_fifo_count,first_underflow_output,underflow,silence_outputs,recovery_seen);
                    $finish;
                end
            end
        end
    end

    initial begin
        #100000000;
        $fatal(1,"watchdog outputs=%0d takes=%0d requests=%0d state=%0d fifo=%0d",outputs,takes,requests,u_player.state,u_player.fifo_count);
    end
endmodule
