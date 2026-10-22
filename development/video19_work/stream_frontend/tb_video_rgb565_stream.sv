`timescale 1ns/1ps

module tb_video_rgb565_stream;
    localparam integer PIXELS = 1024;
    reg clk = 1'b0;
    always #10 clk = ~clk;

    reg rst = 1'b1;
    reg source_valid = 1'b0;
    reg [23:0] source_rgb = 24'd0;
    wire source_ready;
    wire word_valid;
    wire word_ready;
    wire [31:0] word_data;
    wire result_valid;
    reg result_ready = 1'b0;
    wire [23:0] result_rgb;

    reg [23:0] reference [0:PIXELS-1];
    integer sent = 0;
    integer received = 0;
    integer cycles = 0;
    integer random_state = 32'h52a9_631d;
    reg source_accepted = 1'b0;
    reg hold_check = 1'b0;
    reg [23:0] held_rgb;
    integer n;

    video_rgb565_packer packer (
        .clk_i(clk), .rst_i(rst),
        .pixel_valid_i(source_valid), .pixel_ready_o(source_ready), .pixel_rgb_i(source_rgb),
        .word_valid_o(word_valid), .word_ready_i(word_ready), .word_data_o(word_data)
    );
    video_rgb565_unpacker unpacker (
        .clk_i(clk), .rst_i(rst),
        .word_valid_i(word_valid), .word_ready_o(word_ready), .word_data_i(word_data),
        .pixel_valid_o(result_valid), .pixel_ready_i(result_ready), .pixel_rgb_o(result_rgb)
    );

    function [23:0] quantized_rgb;
        input [23:0] value;
        reg [4:0] red, blue;
        reg [5:0] green;
        begin
            red = value[23:19];
            green = value[15:10];
            blue = value[7:3];
            quantized_rgb = {red, red[4:2], green, green[5:4], blue, blue[4:2]};
        end
    endfunction

    initial begin
        for (n = 0; n < PIXELS; n = n + 1) begin
            reference[n][23:16] = (n * 37 + (n >> 3) * 11) & 255;
            reference[n][15:8] = (n * 73 + 17) & 255;
            reference[n][7:0] = (n * 19 + 91) & 255;
        end
        repeat (4) @(negedge clk);
        rst = 1'b0;
    end

    always @(negedge clk) begin
        if (rst) begin
            source_valid = 1'b0;
            result_ready = 1'b0;
        end else begin
            random_state = $random(random_state);
            result_ready = ((random_state & 3) != 0);
            if (source_accepted || !source_valid) begin
                source_accepted = 1'b0;
                random_state = $random(random_state);
                if (sent < PIXELS && (random_state & 7) != 0) begin
                    source_valid = 1'b1;
                    source_rgb = reference[sent];
                end else begin
                    source_valid = 1'b0;
                end
            end
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            sent <= 0;
            received <= 0;
            cycles <= 0;
            hold_check <= 1'b0;
            source_accepted <= 1'b0;
        end else begin
            cycles <= cycles + 1;
            if (cycles > 200000) $fatal(1, "timeout sent=%0d received=%0d", sent, received);
            if (source_valid && source_ready) begin
                sent <= sent + 1;
                source_accepted <= 1'b1;
            end

            if (hold_check && (!result_valid || result_rgb !== held_rgb))
                $fatal(1, "pixel changed while stalled at output index %0d", received);
            hold_check <= result_valid && !result_ready;
            if (result_valid && !result_ready)
                held_rgb <= result_rgb;

            if (result_valid && result_ready) begin
                if (received >= PIXELS) $fatal(1, "extra output pixel");
                if (result_rgb !== quantized_rgb(reference[received]))
                    $fatal(1, "pixel mismatch index=%0d got=%06x expected=%06x",
                        received, result_rgb, quantized_rgb(reference[received]));
                received <= received + 1;
            end

            if (received == PIXELS) begin
                if (sent != PIXELS) $fatal(1, "input count=%0d", sent);
                $display("PASS rgb565_stream pixels=%0d cycles=%0d randomized_source_gaps_and_output_stalls", received, cycles);
                $finish;
            end
        end
    end
endmodule
