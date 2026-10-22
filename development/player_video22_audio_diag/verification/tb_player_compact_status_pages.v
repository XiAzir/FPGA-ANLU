`timescale 1ns/1ps
module tb_player_compact_status_pages;
    reg clk = 0;
    reg rst = 0;
    always #5 clk = ~clk;

    reg [7:0] file_flags = 8'hA6;
    reg [3:0] photo_state = 4'h7;
    reg [3:0] video_state = 4'hB;
    reg [7:0] fs_error_code = 8'h5C;
    reg [3:0] file_error_flags = 4'hD;
    reg [15:0] sd_crc_checked = 16'h1234;
    reg [15:0] sd_crc_bad = 16'hABCD;
    reg audio_underflow = 1'b1;
    reg [23:0] spectrum_frames = 24'h654321;
    reg [31:0] diag4=32'hD1040004, diag5=32'hD1050005;
    reg [31:0] diag6=32'hD1060006, diag7=32'hD1070007;
    reg [31:0] diag8=32'hD1080008, diag9=32'hD1090009;
    reg [31:0] diag10=32'hD10A000A, diag11=32'hD10B000B;
    reg [31:0] diag12=32'hD10C000C, diag13=32'hD10D000D;
    reg [31:0] diag14=32'hD10E000E, diag15=32'hD10F000F;
    wire [31:0] hex_value;
    wire [3:0] page_index;

    player_compact_status_pages #(.PAGE_CYCLES(3)) dut (
        .clk(clk), .rst(rst), .file_flags(file_flags),
        .photo_state(photo_state), .video_state(video_state),
        .fs_error_code(fs_error_code), .file_error_flags(file_error_flags),
        .sd_crc_checked(sd_crc_checked), .sd_crc_bad(sd_crc_bad),
        .audio_underflow(audio_underflow), .spectrum_frames(spectrum_frames),
        .diag4(diag4), .diag5(diag5), .diag6(diag6), .diag7(diag7),
        .diag8(diag8), .diag9(diag9), .diag10(diag10), .diag11(diag11),
        .diag12(diag12), .diag13(diag13), .diag14(diag14), .diag15(diag15),
        .hex_value(hex_value), .page_index(page_index)
    );

    function [31:0] expected_page(input [3:0] index);
        begin
            case (index)
                0: expected_page=32'h00C11322;
                1: expected_page={4'h2,file_flags,photo_state,video_state,fs_error_code,file_error_flags};
                2: expected_page={sd_crc_checked,sd_crc_bad};
                3: expected_page={spectrum_frames,4'h0,audio_underflow,3'b000};
                4: expected_page=diag4; 5: expected_page=diag5;
                6: expected_page=diag6; 7: expected_page=diag7;
                8: expected_page=diag8; 9: expected_page=diag9;
                10: expected_page=diag10; 11: expected_page=diag11;
                12: expected_page=diag12; 13: expected_page=diag13;
                14: expected_page=diag14; default: expected_page=diag15;
            endcase
        end
    endfunction

    task check_page(input [3:0] wanted);
        begin
            #1;
            if (page_index !== wanted || hex_value !== expected_page(wanted)) begin
                $display("FAIL page expected=%0d got=%0d hex=%08x expected_hex=%08x", wanted, page_index, hex_value, expected_page(wanted));
                $fatal(1);
            end
        end
    endtask

    task advance_page;
        begin
            repeat (3) @(posedge clk);
            @(negedge clk);
        end
    endtask

    integer i;
    initial begin
        rst=1;
        @(posedge clk); @(negedge clk); check_page(0);
        rst=0;
        for (i=1;i<16;i=i+1) begin
            advance_page();
            check_page(i[3:0]);
        end
        advance_page();
        check_page(0);

        // Abort a partial page interval and require reset to restart at page 0.
        repeat (2) @(posedge clk);
        @(negedge clk); rst=1;
        @(posedge clk); @(negedge clk); check_page(0);
        rst=0;
        for (i=1;i<16;i=i+1) begin
            advance_page();
            check_page(i[3:0]);
        end
        advance_page();
        check_page(0);
        $display("PASS status pages: all 16 outputs, wrap, and mid-cycle reset");
        $finish;
    end
endmodule
