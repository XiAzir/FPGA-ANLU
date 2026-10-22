// RGB888 packed words in JPEG420 MCU order: TL, TR, BL, BR 8x8 blocks.
// The SD-domain packer emits six words per block row, 48 words per block.
// Each accepted memory word advances this address; stalls preserve position.
module jpeg420_word_address #(
    parameter RGB565 = 0
) (
    input wire clk, rst,
    input wire start,
    input wire [20:0] frame_base,
    input wire word_take,
    output reg [20:0] word_address
);
    reg [2:0] word_column;
    reg [2:0] block_row;
    reg [1:0] block_part;
    reg [5:0] mcu_column;
    localparam ROW_WORDS = RGB565 ? 4 : 6;
    localparam STRIDE = RGB565 ? 320 : 480;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            word_address <= 0;
            word_column <= 0;
            block_row <= 0;
            block_part <= 0;
            mcu_column <= 0;
        end else if (start) begin
            word_address <= frame_base;
            word_column <= 0;
            block_row <= 0;
            block_part <= 0;
            mcu_column <= 0;
        end else if (word_take) begin
            if (word_column != ROW_WORDS-1) begin
                word_column <= word_column + 1'b1;
                word_address <= word_address + 1'b1;
            end else begin
                word_column <= 0;
                if (block_row != 7) begin
                    block_row <= block_row + 1'b1;
                    word_address <= word_address + STRIDE-(ROW_WORDS-1);
                end else begin
                    block_row <= 0;
                    block_part <= block_part + 1'b1;
                    case (block_part)
                        0,2: word_address <= word_address - (7*STRIDE-1);
                        1: word_address <= word_address + STRIDE-(2*ROW_WORDS-1);
                        3: begin
                            if (mcu_column == 39) begin
                                mcu_column <= 0;
                                word_address <= word_address + 1'b1;
                            end else begin
                                mcu_column <= mcu_column + 1'b1;
                                word_address <= word_address - (15*STRIDE-1);
                            end
                        end
                    endcase
                end
            end
        end
    end
endmodule
