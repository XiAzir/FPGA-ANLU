// Packed words arrive in JPEG420 MCU order: TL, TR, BL, BR 8x8 blocks.
// Geometry is in pixels; SDRAM addresses are 32-bit word addresses.
// An 8-row final MCU omits its padded bottom block pair.
module jpeg420_word_address #(
    parameter RGB565 = 0,
    parameter integer FRAME_WIDTH = 640,
    parameter integer FRAME_HEIGHT = 480
) (
    input wire clk, rst,
    input wire start,
    input wire [20:0] frame_base,
    input wire word_take,
    output wire [20:0] word_address
);
    localparam integer ROW_WORDS = RGB565 ? 4 : 6;
    localparam integer STRIDE = RGB565 ? FRAME_WIDTH / 2 : FRAME_WIDTH / 4 * 3;
    localparam integer MCU_COLUMNS = FRAME_WIDTH / 16;
    localparam integer MCU_ROWS = (FRAME_HEIGHT + 15) / 16;
    localparam integer COLUMN_BITS = $clog2(ROW_WORDS);
    localparam integer MCU_X_BITS = MCU_COLUMNS > 1 ? $clog2(MCU_COLUMNS) : 1;
    localparam integer MCU_Y_BITS = MCU_ROWS > 1 ? $clog2(MCU_ROWS) : 1;
    reg [20:0] address;
    reg [COLUMN_BITS-1:0] column;
    reg [2:0] row;
    reg [1:0] part;
    reg [MCU_X_BITS-1:0] mcu_x;
    reg [MCU_Y_BITS-1:0] mcu_y;
    wire short_mcu_row = (FRAME_HEIGHT % 16 == 8) && (mcu_y == MCU_ROWS - 1);
    wire last_part = short_mcu_row ? part == 1 : part == 3;
    assign word_address = address;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            address <= 0;
            column <= 0; row <= 0; part <= 0; mcu_x <= 0; mcu_y <= 0;
        end else if (start) begin
            address <= frame_base;
            column <= 0; row <= 0; part <= 0; mcu_x <= 0; mcu_y <= 0;
        end else if (word_take) begin
            if (column != ROW_WORDS - 1) begin
                column <= column + 1'b1;
                address <= address + 1'b1;
            end else begin
                column <= 0;
                if (row != 7) begin
                    row <= row + 1'b1;
                    address <= address + STRIDE - (ROW_WORDS - 1);
                end else begin
                    row <= 0;
                    if (last_part) begin
                        part <= 0;
                        if (mcu_x == MCU_COLUMNS - 1) begin
                            mcu_x <= 0;
                            mcu_y <= mcu_y + 1'b1;
                            address <= address + 1'b1;
                        end else begin
                            mcu_x <= mcu_x + 1'b1;
                            address <= address + 1 - (short_mcu_row ? 7 : 15) * STRIDE;
                        end
                    end else begin
                        part <= part + 1'b1;
                        if (!part[0])
                            address <= address + 1 - 7 * STRIDE;
                        else
                            address <= address + STRIDE - (2 * ROW_WORDS - 1);
                    end
                end
            end
        end
    end
endmodule
