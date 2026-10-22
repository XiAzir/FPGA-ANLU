`timescale 1ns/1ps
module tb_compact_status_pages;
    reg clk = 1'b0;
    reg rst = 1'b1;
    reg [7:0] file_flags = 8'hA5;
    reg [3:0] photo_state = 4'h3;
    reg [3:0] video_state = 4'hC;
    reg [7:0] fs_error_code = 8'h76;
    reg [3:0] file_error_flags = 4'h9;
    reg [15:0] sd_crc_checked = 16'h1234;
    reg [15:0] sd_crc_bad = 16'h00AB;
    reg audio_underflow = 1'b1;
    reg [23:0] spectrum_frames = 24'hABCDEF;
    wire [31:0] hex_value;
    wire [1:0] page_index;

    always #5 clk = ~clk;

    player_compact_status_pages #(.PAGE_CYCLES(4)) dut (
        .clk(clk), .rst(rst), .file_flags(file_flags),
        .photo_state(photo_state), .video_state(video_state),
        .fs_error_code(fs_error_code), .file_error_flags(file_error_flags),
        .sd_crc_checked(sd_crc_checked), .sd_crc_bad(sd_crc_bad),
        .audio_underflow(audio_underflow), .spectrum_frames(spectrum_frames),
        .hex_value(hex_value), .page_index(page_index)
    );

    task check_page;
        input [1:0] expected_page;
        input [31:0] expected_value;
        begin
            #1;
            if (page_index !== expected_page || hex_value !== expected_value)
                $fatal(1, "page mismatch page=%0d value=%08x expected_page=%0d expected=%08x",
                       page_index, hex_value, expected_page, expected_value);
        end
    endtask

    integer page;
    initial begin
        @(posedge clk);
        #1;
        check_page(2'd0, 32'h00C11319);
        @(negedge clk);
        rst = 1'b0;
        for (page = 1; page <= 4; page = page + 1) begin
            repeat (4) @(posedge clk);
            case (page)
                1: check_page(2'd1, 32'h2A53C769);
                2: check_page(2'd2, 32'h123400AB);
                3: check_page(2'd3, 32'hABCDEF08);
                4: check_page(2'd0, 32'h00C11319);
            endcase
        end
        $display("COMPACT_STATUS_PAGES_PASS build=file_crc=audio_fft wrap=1");
        $finish;
    end

    initial begin
        #1000;
        $fatal(1, "compact status page watchdog timeout");
    end
endmodule
