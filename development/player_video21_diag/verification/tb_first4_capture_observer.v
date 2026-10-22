`timescale 1ns/1ps
module tb_first4_capture_observer;
    reg sd_card_clk=0;
    always #5 sd_card_clk=~sd_card_clk;
    reg rst_all=1;
    reg [3:0] compact_status_page=4'd4;
    reg bmp_card_read=0,bmp_card_valid=0,bmp_card_end=0;
    reg [31:0] bmp_card_addr=0;
    reg [7:0] bmp_card_data=0;
    reg wav_card_read=0,wav_card_valid=0,wav_card_end=0;
    reg [31:0] wav_card_addr=0;
    reg [7:0] wav_card_data=0;
    wire [9:0] diag_bmp_byte,diag_wav_byte;
    wire [31:0] diag_bmp_head,diag_wav_head;

    first4_capture_observer dut (
        .sd_card_clk(sd_card_clk),.rst_all(rst_all),.compact_status_page(compact_status_page),
        .bmp_card_read(bmp_card_read),.bmp_card_valid(bmp_card_valid),.bmp_card_end(bmp_card_end),
        .bmp_card_addr(bmp_card_addr),.bmp_card_data(bmp_card_data),
        .wav_card_read(wav_card_read),.wav_card_valid(wav_card_valid),.wav_card_end(wav_card_end),
        .wav_card_addr(wav_card_addr),.wav_card_data(wav_card_data),
        .diag_bmp_byte(diag_bmp_byte),.diag_wav_byte(diag_wav_byte),
        .diag_bmp_head(diag_bmp_head),.diag_wav_head(diag_wav_head)
    );

    task tick;
        begin @(posedge sd_card_clk); #1; end
    endtask
    task check_bmp(input [31:0] head,input [9:0] count,input [255:0] label_text);
        begin
            if(diag_bmp_head!==head || diag_bmp_byte!==count) begin
                $display("FAIL BMP %0s head=%08x/%08x count=%0d/%0d",label_text,diag_bmp_head,head,diag_bmp_byte,count);
                $fatal(1);
            end
        end
    endtask
    task check_wav(input [31:0] head,input [9:0] count,input [255:0] label_text);
        begin
            if(diag_wav_head!==head || diag_wav_byte!==count) begin
                $display("FAIL WAV %0s head=%08x/%08x count=%0d/%0d",label_text,diag_wav_head,head,diag_wav_byte,count);
                $fatal(1);
            end
        end
    endtask

    initial begin
        tick(); rst_all=0; tick();
        check_bmp(0,0,"reset clears BMP state");
        check_wav(0,0,"reset clears WAV state");

        // MJP-style one-clock request followed by delayed data and valid gaps.
        bmp_card_addr=0; bmp_card_read=1; tick(); bmp_card_read=0;
        bmp_card_data=8'h11; bmp_card_valid=1; tick(); bmp_card_valid=0;
        repeat(3) tick();
        bmp_card_data=8'h22; bmp_card_valid=1; tick(); bmp_card_valid=0;
        bmp_card_data=8'h33; bmp_card_valid=1; tick(); bmp_card_valid=0;
        repeat(2) tick();
        bmp_card_data=8'h44; bmp_card_valid=1; tick(); bmp_card_valid=0;
        check_bmp(32'h11223344,4,"single-pulse request delayed data with gaps");

        // WAV request stays asserted while bytes arrive; gaps do not consume positions.
        wav_card_addr=0; wav_card_read=1;
        wav_card_data=8'h52; wav_card_valid=1; tick(); wav_card_valid=0;
        repeat(2) tick();
        wav_card_data=8'h49; wav_card_valid=1; tick(); wav_card_valid=0;
        wav_card_data=8'h46; wav_card_valid=1; tick(); wav_card_valid=0;
        repeat(1) tick();
        wav_card_data=8'h46; wav_card_valid=1; tick(); wav_card_valid=0;
        wav_card_read=0;
        check_wav(32'h52494646,4,"sustained request with valid gaps");

        // A subsequent nonzero logical sector must not replace the captured header.
        bmp_card_addr=1; bmp_card_read=1; tick();
        bmp_card_data=8'hAA; bmp_card_valid=1; tick(); bmp_card_valid=0;
        bmp_card_data=8'hBB; bmp_card_valid=1; tick(); bmp_card_valid=0;
        bmp_card_end=1; tick(); bmp_card_end=0; bmp_card_read=0;
        check_bmp(32'h11223344,0,"nonzero sector preserves first-sector head; end clears count");

        // Exercise both observers at once, then reset halfway through a capture.
        bmp_card_addr=0; bmp_card_read=1; wav_card_addr=0; wav_card_read=1;
        tick(); bmp_card_read=0; wav_card_read=0;
        bmp_card_data=8'hDE; bmp_card_valid=1; wav_card_data=8'h52; wav_card_valid=1; tick();
        bmp_card_valid=0; wav_card_valid=0;
        bmp_card_data=8'hAD; bmp_card_valid=1; wav_card_data=8'h49; wav_card_valid=1; tick();
        bmp_card_valid=0; wav_card_valid=0;
        check_bmp(32'hDEAD3344,2,"partial stream before asynchronous reset");
        check_wav(32'h52494646,6,"partial stream before asynchronous reset");
        rst_all=1; #1;
        check_bmp(0,0,"asynchronous reset clears BMP capture");
        check_wav(0,0,"asynchronous reset clears WAV capture");
        tick(); rst_all=0; tick();

        // After reset, a fresh sector-zero stream starts at byte index zero.
        bmp_card_addr=0; bmp_card_read=1; tick(); bmp_card_read=0;
        bmp_card_data=8'h42; bmp_card_valid=1; tick(); bmp_card_valid=0;
        bmp_card_data=8'h4D; bmp_card_valid=1; tick(); bmp_card_valid=0;
        bmp_card_data=8'h00; bmp_card_valid=1; tick(); bmp_card_valid=0;
        bmp_card_data=8'h00; bmp_card_valid=1; tick(); bmp_card_valid=0;
        check_bmp(32'h424D0000,4,"fresh capture after reset");
        $display("PASS first4 observer: single-pulse/delayed, continuous/gapped, nonzero sector, end, reset");
        $finish;
    end
endmodule
