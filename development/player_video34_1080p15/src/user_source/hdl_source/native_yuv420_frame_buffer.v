// Video-only memory client. The caller owns mode selection and the shared
// physical SDRAM instance. Decode and memory requests use mem_clk.
module native_yuv420_frame_buffer #(
    parameter integer FRAME_WIDTH=1920,
    parameter integer FRAME_HEIGHT=1080,
    parameter integer ADDR_BITS=21,
    parameter integer SDR_READ_DATA_DELAY=1
) (
    input wire mem_clk,mem_rst,pixel_clk,pixel_rst,
    input wire init_done,refresh_valid,sdr_busy,
    input wire write_frame_start,write_frame_index,
    input wire decode_idle,
    output wire decode_block_space,
    input wire native_valid,
    input wire signed [31:0] native_sample,
    input wire [5:0] native_index,
    input wire [31:0] native_id,
    output reg write_frame_done,
    input wire read_frame_start_mem,read_frame_index,
    input wire read_frame_start_pixel,
    input wire [15:0] pixel_x,pixel_y,
    input wire pixel_de,
    output wire rgb_valid,
    output wire [15:0] rgb_x,rgb_y,
    output wire [23:0] rgb,
    output wire pixel_underflow,
    output wire [1:0] pixel_bank_ready,
    output wire prefetch_frame_done,
    output wire app_rd_en,
    output wire [ADDR_BITS-1:0] app_rd_address,
    output wire app_wr_en,
    output wire [ADDR_BITS-1:0] app_wr_address,
    output wire [31:0] app_wr_data,
    output wire [3:0] app_wr_mask,
    input wire sdr_rd_valid,
    input wire [31:0] sdr_rd_data
);
    localparam integer FRAME_WORDS=((FRAME_WIDTH+15)/16)*((FRAME_HEIGHT+15)/16)*96;
    reg [ADDR_BITS-1:0] write_base;
    reg [ADDR_BITS:0] written_words;
    reg write_active;
    wire [ADDR_BITS-1:0] scan_base=read_frame_index ? FRAME_WORDS : 0;
    wire write_word_valid,write_word_ready,arb_idle;
    wire [ADDR_BITS-1:0] write_word_address;
    wire [31:0] write_word_data;
    wire read_command_valid,read_command_ready,read_valid;
    wire [ADDR_BITS-1:0] read_command_address;
    wire [31:0] read_data;
    wire [15:0] scan_x,scan_y;
    wire scan_de,scan_bank_ready;
    wire [7:0] scan_luma,scan_cb,scan_cr;
    wire color_ready;
    always @(posedge mem_clk) begin
        if(mem_rst) begin
            write_base<=0;written_words<=0;write_active<=0;write_frame_done<=0;
        end else begin
            write_frame_done<=0;
            if(write_frame_start) begin
                write_base<=write_frame_index ? FRAME_WORDS : 0;
                written_words<=0;write_active<=1;
            end else if(write_active) begin
                if(app_wr_en) written_words<=written_words+1'b1;
                if(written_words==FRAME_WORDS && decode_idle && arb_idle && !write_word_valid) begin
                    write_frame_done<=1;write_active<=0;
                end
            end
        end
    end
    idct_yuv420_block_buffer #(.FRAME_WIDTH(FRAME_WIDTH),.FRAME_HEIGHT(FRAME_HEIGHT),.ADDR_BITS(ADDR_BITS)) u_blocks (
        .clk(mem_clk),.rst(mem_rst),.frame_start(write_frame_start),.frame_base_word(write_base),
        .block_space(decode_block_space),.sample_valid(native_valid),.sample_data(native_sample),
        .sample_index(native_index),.sample_id(native_id),.word_valid(write_word_valid),
        .word_ready(write_word_ready),.word_address(write_word_address),.word_data(write_word_data));
    yuv_sdram_burst_arbiter #(.ADDR_BITS(ADDR_BITS),.SDR_READ_DATA_DELAY(SDR_READ_DATA_DELAY)) u_arbiter (
        .clk(mem_clk),.rst(mem_rst),.init_done(init_done),.refresh_valid(refresh_valid),.sdr_busy(sdr_busy),
        .rd_cmd_valid(read_command_valid),.rd_cmd_ready(read_command_ready),.rd_cmd_address(read_command_address),
        .rd_valid(read_valid),.rd_data(read_data),.wr_valid(write_word_valid),.wr_ready(write_word_ready),
        .wr_address(write_word_address),.wr_data(write_word_data),.idle(arb_idle),
        .app_rd_en(app_rd_en),.app_rd_address(app_rd_address),.app_wr_en(app_wr_en),
        .app_wr_address(app_wr_address),.app_wr_data(app_wr_data),.app_wr_mask(app_wr_mask),
        .sdr_rd_valid(sdr_rd_valid),.sdr_rd_data(sdr_rd_data));
    yuv420_scan_cache #(.FRAME_WIDTH(FRAME_WIDTH),.FRAME_HEIGHT(FRAME_HEIGHT),.ADDR_BITS(ADDR_BITS)) u_scan (
        .mem_clk(mem_clk),.mem_rst(mem_rst),.frame_start_mem(read_frame_start_mem),.frame_base_word(scan_base),
        .rd_cmd_valid(read_command_valid),.rd_cmd_ready(read_command_ready),.rd_cmd_addr(read_command_address),
        .rd_valid(read_valid),.rd_data(read_data),.frame_done_mem(prefetch_frame_done),
        .pixel_clk(pixel_clk),.pixel_rst(pixel_rst),.frame_start_pixel(read_frame_start_pixel),
        .in_pixel_x(pixel_x),.in_pixel_y(pixel_y),.in_pixel_de(pixel_de),
        .out_pixel_x(scan_x),.out_pixel_y(scan_y),.out_pixel_de(scan_de),
        .out_y(scan_luma),.out_cb(scan_cb),.out_cr(scan_cr),.out_bank_ready(scan_bank_ready),
        .pixel_bank_ready(pixel_bank_ready),.pixel_underflow(pixel_underflow));
    yuv420_to_rgb888 u_color (
        .clk(pixel_clk),.rst(pixel_rst),.in_valid(scan_de),.in_ready(color_ready),
        .in_x(scan_x),.in_y(scan_y),.in_y_sample(scan_luma),.in_cb_sample(scan_cb),.in_cr_sample(scan_cr),
        .out_valid(rgb_valid),.out_ready(1'b1),.out_x(rgb_x),.out_y(rgb_y),
        .out_r(rgb[23:16]),.out_g(rgb[15:8]),.out_b(rgb[7:0]));
endmodule
