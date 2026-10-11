// Pixel interface independent of SDRAM word layout.
// First backend preserves the verified {R,G,B,8'b0} storage and FIFO latency.
// No compact RGB888 packing is implemented in this version.
module frame_buffer_rgb888 #(
    parameter FRAME_WIDTH = 640,
    parameter FRAME_HEIGHT = 480,
    parameter WRITE_V_FLIP = 1
)(
    input         rst,
    input         mem_clk,
    input         mem_clk_shift,
    input         write_clk,
    input         write_req,
    output        write_req_ack,
    input  [1:0]  write_frame_index,
    input         write_pixel_en,
    input  [23:0] write_pixel_rgb,
    output        write_finish,
    input         read_clk,
    input         read_req,
    output        read_req_ack,
    input  [1:0]  read_frame_index,
    input         read_pixel_en,
    output [23:0] read_pixel_rgb
);
    // Addresses below are 32-bit SDRAM word addresses, never pixel API ports.
    // This compatibility backend supports only frame indices 0 and 1.
    localparam ADDR_BITS = 21;
    localparam [ADDR_BITS-1:0] FRAME_WORDS = FRAME_WIDTH * FRAME_HEIGHT;
    localparam [ADDR_BITS-1:0] BUF0_WORD_ADDR = 0;
    localparam [ADDR_BITS-1:0] BUF1_WORD_ADDR = FRAME_WORDS;
    localparam [ADDR_BITS-1:0] UNUSED_WORD_ADDR = 0;

    wire init_done, init_ref_valid, mem_busy;
    wire app_read_en, app_write_en, mem_read_valid;
    wire [ADDR_BITS-1:0] app_read_addr, app_write_addr;
    wire [31:0] mem_read_word, mem_write_word, read_word;
    wire [3:0] write_mask;
    wire [31:0] write_word = {write_pixel_rgb, 8'b0};
    assign read_pixel_rgb = read_word[31:8];

    // These connections are identical to the successful 32-bit frame backend.
    // The frame completion pulse remains in mem_clk, and both FIFO clock
    // domains and the existing pixel read latency are preserved.
    frame_read_write #(
        .WRITE_V_FLIP(WRITE_V_FLIP),
        .FRAME_WIDTH(FRAME_WIDTH),
        .FRAME_HEIGHT(FRAME_HEIGHT)
    ) u_legacy_frame_backend (
        .mem_clk(mem_clk), .rst(rst),
        .Sdr_init_done(init_done), .Sdr_init_ref_vld(init_ref_valid),
        .Sdr_busy(mem_busy),
        .App_rd_en(app_read_en), .App_rd_addr(app_read_addr),
        .Sdr_rd_en(mem_read_valid), .Sdr_rd_dout(mem_read_word),
        .read_clk(read_clk), .read_req(read_req), .read_req_ack(read_req_ack),
        .read_finish(),
        .read_addr_0(BUF0_WORD_ADDR), .read_addr_1(BUF1_WORD_ADDR),
        .read_addr_2(UNUSED_WORD_ADDR), .read_addr_3(UNUSED_WORD_ADDR),
        .read_addr_index(read_frame_index), .read_len(FRAME_WORDS),
        .read_en(read_pixel_en), .read_data(read_word),
        .App_wr_en(app_write_en), .App_wr_addr(app_write_addr),
        .App_wr_din(mem_write_word), .App_wr_dm(write_mask),
        .write_clk(write_clk), .write_req(write_req),
        .write_req_ack(write_req_ack), .write_finish(write_finish),
        .write_addr_0(BUF0_WORD_ADDR), .write_addr_1(BUF1_WORD_ADDR),
        .write_addr_2(UNUSED_WORD_ADDR), .write_addr_3(UNUSED_WORD_ADDR),
        .write_addr_index(write_frame_index), .write_len(FRAME_WORDS),
        .write_en(write_pixel_en), .write_data(write_word)
    );

    sdram u_sdram (
        .Clk(mem_clk), .Clk_sft(mem_clk_shift), .Rst(rst),
        .Sdr_init_done(init_done), .Sdr_init_ref_vld(init_ref_valid),
        .Sdr_busy(mem_busy),
        .App_wr_en(app_write_en), .App_wr_addr(app_write_addr),
        .App_wr_dm(write_mask), .App_wr_din(mem_write_word),
        .App_rd_en(app_read_en), .App_rd_addr(app_read_addr),
        .Sdr_rd_en(mem_read_valid), .Sdr_rd_dout(mem_read_word)
    );
endmodule
