`timescale 1ns/1ps

module tb_video_rgb565_unpacker_rate;
    localparam integer WORDS = 256;
    reg clk = 1'b0;
    always #10 clk = ~clk;

    reg rst = 1'b1;
    reg word_valid = 1'b0;
    reg [31:0] word_data = 32'd0;
    wire word_ready;
    wire pixel_valid;
    wire [23:0] pixel_rgb;
    integer sent_words = 0;
    integer received_pixels = 0;
    integer cycles = 0;
    integer n;
    reg previous_pixel_valid = 1'b0;

    video_rgb565_unpacker unpacker (
        .clk_i(clk), .rst_i(rst),
        .word_valid_i(word_valid), .word_ready_o(word_ready), .word_data_i(word_data),
        .pixel_valid_o(pixel_valid), .pixel_ready_i(1'b1), .pixel_rgb_o(pixel_rgb)
    );

    function [15:0] value565;
        input integer index;
        begin value565 = (index * 16'h39ad + 16'h5678) & 16'hffff; end
    endfunction

    function [23:0] expand565;
        input [15:0] value;
        begin
            expand565 = {value[15:11], value[15:13], value[10:5], value[10:9],
                         value[4:0], value[4:2]};
        end
    endfunction

    initial begin
        repeat (4) @(negedge clk);
        rst = 1'b0;
    end

    always @(negedge clk) begin
        if (rst) begin
            word_valid = 1'b0;
        end else if (!word_valid || word_ready) begin
            word_valid = (sent_words < WORDS);
            if (sent_words < WORDS)
                word_data = {value565(sent_words * 2 + 1), value565(sent_words * 2)};
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            sent_words <= 0;
            received_pixels <= 0;
            cycles <= 0;
            previous_pixel_valid <= 1'b0;
        end else begin
            cycles <= cycles + 1;
            if (cycles > 10000) $fatal(1, "rate test timeout");
            if (word_valid && word_ready)
                sent_words <= sent_words + 1;
            if (pixel_valid) begin
                if (received_pixels > 0 && previous_pixel_valid !== 1'b1)
                    $fatal(1, "pixel output bubble at index=%0d cycle=%0d", received_pixels, cycles);
                n = received_pixels;
                if (n >= WORDS * 2) $fatal(1, "extra pixel");
                if (pixel_rgb !== expand565(value565(n)))
                    $fatal(1, "rate data mismatch index=%0d got=%06x expected=%06x",
                        n, pixel_rgb, expand565(value565(n)));
                received_pixels <= received_pixels + 1;
            end
            previous_pixel_valid <= pixel_valid;
            if (received_pixels == WORDS * 2) begin
                $display("PASS rgb565_unpacker_rate pixels=%0d cycles=%0d continuous_1pixel_per_cycle", received_pixels, cycles);
                $finish;
            end
        end
    end
endmodule
