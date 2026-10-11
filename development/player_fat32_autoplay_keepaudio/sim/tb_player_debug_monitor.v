`timescale 1ns/1ps
module tb_player_debug_monitor;
    reg clk=0; always #10 clk=~clk;
    reg rst=1;
    reg [7:0] flags=8'hcd,fs_code=1,bmp_map_code=2,wav_map_code=3;
    reg write_req=0,write_en=0;
    reg [23:0] write_rgb=0;
    reg [31:0] wav_addr=0;
    reg wav_valid=0,wav_end=0,wav_error=0;
    reg [7:0] wav_data=0,wav_scan_byte=8'hff;
    reg [3:0] wav_state=6,wav_phase=0;
    reg [31:0] wav_scan_pos=0;
    wire [127:0] debug_rows;
    player_debug_monitor #(.FRAME_PIXELS(4)) dut(.*);
    task step; begin @(posedge clk); #1; end endtask
    integer i;
    initial begin
        step; @(negedge clk); rst=0;
        write_req=1; step; @(negedge clk); write_req=0;
        for(i=1;i<=4;i=i+1) begin
            write_en=1; write_rgb=i; step;
            if(i<4 && debug_rows[95:64]!==0) $fatal(1,"partial checksum published");
            @(negedge clk);
        end
        write_en=0;
        if(debug_rows[95:64]!==10) $fatal(1,"checksum incorrect");
        write_req=1; step; @(negedge clk); write_req=0;
        for(i=1;i<=4;i=i+1) begin write_en=1; write_rgb=i+10; step; @(negedge clk); end
        write_en=0;
        if(debug_rows[95:64]!==50) $fatal(1,"frame checksum not reset");
        wav_valid=1; wav_data=8'h52; step; @(negedge clk);
        wav_data=8'h49; step; @(negedge clk);
        wav_data=8'hff; step; @(negedge clk); wav_valid=0;
        if(debug_rows[15:0]!==16'h4952) $fatal(1,"WAV magic capture incorrect");
        wav_error=1; wav_scan_pos=32'h12345678; wav_scan_byte=8'hab; step;
        @(negedge clk); wav_scan_pos=99; wav_scan_byte=0; wav_state=12; step;
        if(debug_rows[63:32]!==32'h12345678 || debug_rows[31:16]!==16'hab60) $fatal(1,"first error snapshot not held");
        if(debug_rows[127:96]!==32'hcd010203) $fatal(1,"error row ordering incorrect");
        $display("PASS: frame sums, WAV byte capture, error freeze, row order");
        $finish;
    end
endmodule
