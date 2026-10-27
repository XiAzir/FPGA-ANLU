// Byte-center Y/Cb/Cr samples and pack every four sequential block samples
// into one aligned 32-bit, little-endian word. Plane storage is MCU-tiled:
// Y blocks TL/TR/BL/BR, then one 8x8 Cb and Cr block per 16x16 MCU.
module yuv420_cache_write_packer #(
    parameter integer FRAME_WIDTH = 1920,
    parameter integer FRAME_HEIGHT = 1080,
    parameter integer ADDR_BITS = 21
) (
    input  wire                     clk,
    input  wire                     rst,
    input  wire                     frame_start,
    input  wire [ADDR_BITS-1:0]     frame_base_word,

    input  wire                     sample_valid,
    output wire                     sample_ready,
    input  wire [1:0]               sample_plane, // 0=Y, 1=Cb, 2=Cr
    input  wire [6:0]               mcu_x,
    input  wire [6:0]               mcu_y,
    input  wire [1:0]               y_block,      // TL, TR, BL, BR; ignored for Cb/Cr
    input  wire [5:0]               sample_index, // row-major 8x8 block index
    input  wire signed [31:0]       sample_centered,

    output reg                      write_valid,
    input  wire                     write_ready,
    output reg  [ADDR_BITS-1:0]     write_word_addr,
    output reg  [31:0]              write_data
);
    localparam integer MCU_COLS = (FRAME_WIDTH + 15) / 16;
    localparam integer MCU_ROWS = (FRAME_HEIGHT + 15) / 16;
    localparam integer MCU_COUNT = MCU_COLS * MCU_ROWS;
    localparam integer Y_PLANE_WORDS = MCU_COUNT * 64;
    localparam integer C_PLANE_WORDS = MCU_COUNT * 16;
    localparam integer FRAME_WORDS = Y_PLANE_WORDS + 2 * C_PLANE_WORDS;

    reg [7:0] lane0_q, lane1_q, lane2_q;

    wire signed [32:0] centered_plus_128 = {sample_centered[31], sample_centered} + 33'sd128;
    wire [7:0] sample_byte = centered_plus_128[32] ? 8'd0 :
                             ((|centered_plus_128[31:8]) ? 8'd255 : centered_plus_128[7:0]);

    wire output_slot_ready = !write_valid || write_ready;
    assign sample_ready = output_slot_ready;
    wire sample_fire = sample_valid && sample_ready && !frame_start;

    wire [16:0] mcu_index = mcu_y * MCU_COLS + mcu_x;
    wire [31:0] y_word_offset_full = mcu_index * 32'd64 + y_block * 32'd16 + sample_index[5:2];
    wire [31:0] cb_word_offset_full = Y_PLANE_WORDS + mcu_index * 32'd16 + sample_index[5:2];
    wire [31:0] cr_word_offset_full = Y_PLANE_WORDS + C_PLANE_WORDS +
                                      mcu_index * 32'd16 + sample_index[5:2];
    wire [ADDR_BITS-1:0] y_word_offset = y_word_offset_full[ADDR_BITS-1:0];
    wire [ADDR_BITS-1:0] cb_word_offset = cb_word_offset_full[ADDR_BITS-1:0];
    wire [ADDR_BITS-1:0] cr_word_offset = cr_word_offset_full[ADDR_BITS-1:0];
    wire [ADDR_BITS-1:0] sample_word_addr = frame_base_word +
        ((sample_plane == 2'd0) ? y_word_offset :
         (sample_plane == 2'd1) ? cb_word_offset : cr_word_offset);

    always @(posedge clk) begin
        if (rst || frame_start) begin
            lane0_q <= 8'd0;
            lane1_q <= 8'd0;
            lane2_q <= 8'd0;
            write_valid <= 1'b0;
            write_word_addr <= {ADDR_BITS{1'b0}};
            write_data <= 32'd0;
        end else begin
            if (write_valid && write_ready)
                write_valid <= 1'b0;

            if (sample_fire) begin
                case (sample_index[1:0])
                    2'd0: lane0_q <= sample_byte;
                    2'd1: lane1_q <= sample_byte;
                    2'd2: lane2_q <= sample_byte;
                    2'd3: begin
                        write_data <= {sample_byte, lane2_q, lane1_q, lane0_q};
                        write_word_addr <= sample_word_addr;
                        write_valid <= 1'b1;
                    end
                endcase
            end
        end
    end

    // FRAME_WORDS is intentionally kept as a local geometry invariant.
    // At 1920x1080 it is 783360 32-bit words, so two frames fit in 21 bits.
    wire unused_geometry = (FRAME_WORDS == 0);
endmodule
