`timescale 1ns/1ps

module video_rgb565_packer (
    input  wire        clk_i,
    input  wire        rst_i,
    input  wire        pixel_valid_i,
    output wire        pixel_ready_o,
    input  wire [23:0] pixel_rgb_i,
    output reg         word_valid_o,
    input  wire        word_ready_i,
    output reg  [31:0] word_data_o
);
    reg first_pixel_valid;
    reg [15:0] first_pixel_565;
    wire [15:0] current_pixel_565 = {
        pixel_rgb_i[23:19], pixel_rgb_i[15:10], pixel_rgb_i[7:3]
    };

    assign pixel_ready_o = !word_valid_o || word_ready_i;

    always @(posedge clk_i) begin
        if (rst_i) begin
            first_pixel_valid <= 1'b0;
            first_pixel_565 <= 16'd0;
            word_valid_o <= 1'b0;
            word_data_o <= 32'd0;
        end else begin
            if (word_valid_o && word_ready_i)
                word_valid_o <= 1'b0;

            if (pixel_valid_i && pixel_ready_o) begin
                if (!first_pixel_valid) begin
                    first_pixel_565 <= current_pixel_565;
                    first_pixel_valid <= 1'b1;
                end else begin
                    word_data_o <= {current_pixel_565, first_pixel_565};
                    word_valid_o <= 1'b1;
                    first_pixel_valid <= 1'b0;
                end
            end
        end
    end
endmodule
