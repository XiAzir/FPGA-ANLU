`timescale 1ns/1ps

module video_rgb565_unpacker (
    input  wire        clk_i,
    input  wire        rst_i,
    input  wire        word_valid_i,
    output wire        word_ready_o,
    input  wire [31:0] word_data_i,
    output wire        pixel_valid_o,
    input  wire        pixel_ready_i,
    output wire [23:0] pixel_rgb_o
);
    reg word_pending;
    reg high_pixel;
    reg [31:0] word_data;
    wire [15:0] pixel_565 = high_pixel ? word_data[31:16] : word_data[15:0];

    assign pixel_valid_o = word_pending;
    assign word_ready_o = !word_pending || (high_pixel && pixel_ready_i);
    assign pixel_rgb_o = {
        pixel_565[15:11], pixel_565[15:13],
        pixel_565[10:5], pixel_565[10:9],
        pixel_565[4:0], pixel_565[4:2]
    };

    always @(posedge clk_i) begin
        if (rst_i) begin
            word_pending <= 1'b0;
            high_pixel <= 1'b0;
            word_data <= 32'd0;
        end else begin
            if (word_pending && pixel_ready_i) begin
                if (!high_pixel) begin
                    high_pixel <= 1'b1;
                end else if (word_valid_i && word_ready_o) begin
                    word_data <= word_data_i;
                    high_pixel <= 1'b0;
                    word_pending <= 1'b1;
                end else begin
                    high_pixel <= 1'b0;
                    word_pending <= 1'b0;
                end
            end else if (!word_pending && word_valid_i && word_ready_o) begin
                word_data <= word_data_i;
                high_pixel <= 1'b0;
                word_pending <= 1'b1;
            end
        end
    end
endmodule
