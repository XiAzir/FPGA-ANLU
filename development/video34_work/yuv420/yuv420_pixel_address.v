// Pixel-to-byte addresses for the MCU-tiled Y, Cb and Cr planes used by
// yuv420_cache_write_packer. Addresses are 32-bit word indices plus lanes.
module yuv420_pixel_address #(
    parameter integer FRAME_WIDTH = 1920,
    parameter integer FRAME_HEIGHT = 1080,
    parameter integer ADDR_BITS = 21
) (
    input  wire [ADDR_BITS-1:0] frame_base_word,
    input  wire [15:0] pixel_x,
    input  wire [15:0] pixel_y,
    output wire [ADDR_BITS-1:0] y_word_addr,
    output wire [1:0] y_lane,
    output wire [ADDR_BITS-1:0] cb_word_addr,
    output wire [1:0] cb_lane,
    output wire [ADDR_BITS-1:0] cr_word_addr,
    output wire [1:0] cr_lane
);
    localparam integer MCU_COLS = (FRAME_WIDTH + 15) / 16;
    localparam integer MCU_ROWS = (FRAME_HEIGHT + 15) / 16;
    localparam integer MCU_COUNT = MCU_COLS * MCU_ROWS;
    localparam integer Y_PLANE_WORDS = MCU_COUNT * 64;
    localparam integer C_PLANE_WORDS = MCU_COUNT * 16;

    wire [31:0] mcu_index = (pixel_y[15:4] * MCU_COLS) + pixel_x[15:4];
    wire [1:0] y_subblock = {pixel_y[3], pixel_x[3]};
    wire [5:0] y_sample_index = {pixel_y[2:0], pixel_x[2:0]};
    wire [31:0] y_offset = mcu_index * 32'd64 + y_subblock * 32'd16 + y_sample_index[5:2];

    wire [5:0] c_sample_index = {pixel_y[3:1], pixel_x[3:1]};
    wire [31:0] c_offset = mcu_index * 32'd16 + c_sample_index[5:2];

    assign y_word_addr = frame_base_word + y_offset[ADDR_BITS-1:0];
    assign y_lane = y_sample_index[1:0];
    assign cb_word_addr = frame_base_word + Y_PLANE_WORDS + c_offset[ADDR_BITS-1:0];
    assign cb_lane = c_sample_index[1:0];
    assign cr_word_addr = frame_base_word + Y_PLANE_WORDS + C_PLANE_WORDS + c_offset[ADDR_BITS-1:0];
    assign cr_lane = c_sample_index[1:0];
endmodule
