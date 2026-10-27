// Dual-clock scan cache for the MCU-tiled YUV420 store.
// mem_clk owns BL4 command/return sequencing and bank writes. pixel_clk reads
// one 32-bit word from each plane per active pixel, selecting byte lanes after
// the synchronous RAM read. One complete four-line group is banked at a time.
module yuv420_scan_cache #(
    parameter integer FRAME_WIDTH = 1920,
    parameter integer FRAME_HEIGHT = 1080,
    parameter integer ADDR_BITS = 21
) (
    input  wire                    mem_clk,
    input  wire                    mem_rst,
    input  wire                    frame_start_mem,
    input  wire [ADDR_BITS-1:0]    frame_base_word,
    output wire                    rd_cmd_valid,
    input  wire                    rd_cmd_ready,
    output wire [ADDR_BITS-1:0]    rd_cmd_addr,
    input  wire                    rd_valid,
    input  wire [31:0]             rd_data,
    output reg                     frame_done_mem,

    input  wire                    pixel_clk,
    input  wire                    pixel_rst,
    input  wire                    frame_start_pixel,
    input  wire [15:0]             in_pixel_x,
    input  wire [15:0]             in_pixel_y,
    input  wire                    in_pixel_de,
    output wire [15:0]             out_pixel_x,
    output wire [15:0]             out_pixel_y,
    output wire                    out_pixel_de,
    output wire [7:0]              out_y,
    output wire [7:0]              out_cb,
    output wire [7:0]              out_cr,
    output wire                    out_bank_ready,
    output wire [1:0]              pixel_bank_ready,
    output wire                    pixel_underflow
);
    localparam integer MCU_COLS = (FRAME_WIDTH + 15) / 16;
    localparam integer MCU_ROWS = (FRAME_HEIGHT + 15) / 16;
    localparam integer MCU_COUNT = MCU_COLS * MCU_ROWS;
    localparam integer Y_PLANE_WORDS = MCU_COUNT * 64;
    localparam integer C_PLANE_WORDS = MCU_COUNT * 16;
    localparam integer GROUP_COUNT = (FRAME_HEIGHT + 3) / 4;
    localparam integer Y_WORDS_PER_ROW = FRAME_WIDTH / 4;
    localparam integer C_WORDS_PER_ROW = FRAME_WIDTH / 8;
    localparam integer Y_WORDS_PER_BANK = Y_WORDS_PER_ROW * 4;
    localparam integer C_WORDS_PER_BANK = C_WORDS_PER_ROW * 2;
    localparam integer Y_COMMANDS = (FRAME_WIDTH / 8) * 2;
    localparam integer C_COMMANDS_PER_PLANE = FRAME_WIDTH / 16;
    localparam integer COMMANDS_PER_GROUP = Y_COMMANDS + 2 * C_COMMANDS_PER_PLANE;
    localparam integer GROUP_BITS = (GROUP_COUNT > 1) ? $clog2(GROUP_COUNT) : 1;
    localparam integer COMMAND_BITS = (COMMANDS_PER_GROUP > 1) ? $clog2(COMMANDS_PER_GROUP) : 1;
    localparam integer RETURN_BITS = 2;

    // Each cache bank is 4*W Y bytes plus 2*(W/2) Cb and Cr bytes.
    // At W=1920: 1920 + 480 + 480 words = 2880 words = 11,520 bytes/bank.
    reg [31:0] y_bank0 [0:Y_WORDS_PER_BANK-1];
    reg [31:0] y_bank1 [0:Y_WORDS_PER_BANK-1];
    reg [31:0] cb_bank0 [0:C_WORDS_PER_BANK-1];
    reg [31:0] cb_bank1 [0:C_WORDS_PER_BANK-1];
    reg [31:0] cr_bank0 [0:C_WORDS_PER_BANK-1];
    reg [31:0] cr_bank1 [0:C_WORDS_PER_BANK-1];

    reg [1:0] ready_toggle_mem;
    reg [1:0] release_toggle_pixel;
    reg [1:0] release_meta_mem, release_sync_mem;
    reg [1:0] ready_meta_pixel, ready_sync_pixel;
    reg [1:0] ready_seen_pixel;
    reg [1:0] bank_full_pixel;

    always @(posedge mem_clk) begin
        if (mem_rst) begin
            release_meta_mem <= 2'b00;
            release_sync_mem <= 2'b00;
        end else begin
            release_meta_mem <= release_toggle_pixel;
            release_sync_mem <= release_meta_mem;
        end
    end

    always @(posedge pixel_clk) begin
        if (pixel_rst) begin
            ready_meta_pixel <= 2'b00;
            ready_sync_pixel <= 2'b00;
        end else begin
            ready_meta_pixel <= ready_toggle_mem;
            ready_sync_pixel <= ready_meta_pixel;
        end
    end

    reg frame_active_mem;
    reg fetch_active_mem;
    reg outstanding_mem;
    reg [GROUP_BITS-1:0] group_index_mem;
    reg [COMMAND_BITS-1:0] command_index_mem;
    reg [RETURN_BITS-1:0] return_count_mem;
    reg [ADDR_BITS-1:0] frame_base_mem;

    wire bank_mem = group_index_mem[0];
    wire bank_free_mem = (release_sync_mem[bank_mem] == ready_toggle_mem[bank_mem]);
    wire [31:0] group_mcu_y = group_index_mem >> 2;
    wire [1:0] group_in_mcu = group_index_mem[1:0];
    wire [31:0] y_chunk = command_index_mem >> 1;
    wire y_pair = command_index_mem[0];
    wire [31:0] y_mcu_x = y_chunk >> 1;
    wire [1:0] y_block = {group_in_mcu[1], y_chunk[0]};
    wire [31:0] y_row_in_block = (group_in_mcu[0] ? 32'd4 : 32'd0) + (y_pair ? 32'd2 : 32'd0);
    wire [31:0] y_mcu_index = group_mcu_y * MCU_COLS + y_mcu_x;
    wire [31:0] y_command_word = frame_base_mem + y_mcu_index * 32'd64 +
                                  y_block * 32'd16 + y_row_in_block * 32'd2;

    wire [31:0] c_command_local = command_index_mem - Y_COMMANDS;
    wire c_is_cr = (command_index_mem >= Y_COMMANDS + C_COMMANDS_PER_PLANE);
    wire [31:0] c_mcu_x = c_is_cr ? (c_command_local - C_COMMANDS_PER_PLANE) : c_command_local;
    wire [31:0] c_mcu_index = group_mcu_y * MCU_COLS + c_mcu_x;
    wire [31:0] c_plane_offset = c_is_cr ? (Y_PLANE_WORDS + C_PLANE_WORDS) : Y_PLANE_WORDS;
    wire [31:0] c_command_word = frame_base_mem + c_plane_offset + c_mcu_index * 32'd16 +
                                  group_in_mcu * 32'd4;

    assign rd_cmd_valid = frame_active_mem && fetch_active_mem && !outstanding_mem;
    assign rd_cmd_addr = rd_cmd_valid ?
                         ((command_index_mem < Y_COMMANDS) ? y_command_word[ADDR_BITS-1:0] :
                                                           c_command_word[ADDR_BITS-1:0]) :
                         {ADDR_BITS{1'b0}};

    wire [31:0] y_chunk_for_store = command_index_mem >> 1;
    wire y_pair_for_store = command_index_mem[0];
    wire [31:0] c_local_for_store = command_index_mem - Y_COMMANDS;
    wire c_is_cr_for_store = command_index_mem >= Y_COMMANDS + C_COMMANDS_PER_PLANE;
    wire [31:0] c_mcu_x_for_store = c_is_cr_for_store ?
                                     (c_local_for_store - C_COMMANDS_PER_PLANE) : c_local_for_store;
    wire [31:0] store_word_column = (command_index_mem < Y_COMMANDS) ?
                                     (y_chunk_for_store * 32'd2 + return_count_mem[0]) :
                                     (c_mcu_x_for_store * 32'd2 + return_count_mem[0]);
    wire [31:0] store_row = (command_index_mem < Y_COMMANDS) ?
                             (y_pair_for_store * 32'd2 + (return_count_mem >> 1)) :
                             (return_count_mem >> 1);
    wire [31:0] y_store_index = store_row * Y_WORDS_PER_ROW + store_word_column;
    wire [31:0] c_store_index = store_row * C_WORDS_PER_ROW + store_word_column;
    wire [GROUP_BITS-1:0] unused_group_width = group_index_mem;

    integer bank_i;
    always @(posedge mem_clk) begin
        if (mem_rst) begin
            ready_toggle_mem <= 2'b00;
            frame_active_mem <= 1'b0;
            fetch_active_mem <= 1'b0;
            outstanding_mem <= 1'b0;
            group_index_mem <= {GROUP_BITS{1'b0}};
            command_index_mem <= {COMMAND_BITS{1'b0}};
            return_count_mem <= 2'b00;
            frame_base_mem <= {ADDR_BITS{1'b0}};
            frame_done_mem <= 1'b0;
        end else begin
            frame_done_mem <= 1'b0;

            if (frame_start_mem) begin
                frame_base_mem <= frame_base_word;
                group_index_mem <= {GROUP_BITS{1'b0}};
                command_index_mem <= {COMMAND_BITS{1'b0}};
                return_count_mem <= 2'b00;
                frame_active_mem <= 1'b1;
                fetch_active_mem <= 1'b0;
                outstanding_mem <= 1'b0;
            end else begin
                if (!fetch_active_mem && frame_active_mem && group_index_mem < GROUP_COUNT && bank_free_mem) begin
                    fetch_active_mem <= 1'b1;
                    command_index_mem <= {COMMAND_BITS{1'b0}};
                    return_count_mem <= 2'b00;
                end

                if (rd_cmd_valid && rd_cmd_ready) begin
                    outstanding_mem <= 1'b1;
                    return_count_mem <= 2'b00;
                end

                if (rd_valid && outstanding_mem) begin
                    if (return_count_mem == 2'd3) begin
                        outstanding_mem <= 1'b0;
                        return_count_mem <= 2'b00;
                        if (command_index_mem == COMMANDS_PER_GROUP - 1) begin
                            ready_toggle_mem[bank_mem] <= ~ready_toggle_mem[bank_mem];
                            fetch_active_mem <= 1'b0;
                            if (group_index_mem == GROUP_COUNT - 1) begin
                                frame_active_mem <= 1'b0;
                                frame_done_mem <= 1'b1;
                            end else begin
                                group_index_mem <= group_index_mem + 1'b1;
                            end
                        end else begin
                            command_index_mem <= command_index_mem + 1'b1;
                        end
                    end else begin
                        return_count_mem <= return_count_mem + 1'b1;
                    end
                end
            end
        end
    end

    // Store each returned word in row-major scan-cache order. Y BL4 is two
    // words for each of two rows. Chroma BL4 is two words for each of two
    // chroma rows. The output address context stays fixed until beat four.
    always @(posedge mem_clk) begin
        if (!mem_rst && !frame_start_mem && rd_valid && outstanding_mem) begin
            if (command_index_mem < Y_COMMANDS) begin
                if (bank_mem)
                    y_bank1[y_store_index] <= rd_data;
                else
                    y_bank0[y_store_index] <= rd_data;
            end else if (!c_is_cr_for_store) begin
                if (bank_mem)
                    cb_bank1[c_store_index] <= rd_data;
                else
                    cb_bank0[c_store_index] <= rd_data;
            end else begin
                if (bank_mem)
                    cr_bank1[c_store_index] <= rd_data;
                else
                    cr_bank0[c_store_index] <= rd_data;
            end
        end
    end

    reg [15:0] out_x_q, out_y_q;
    reg out_de_q, out_bank_ready_q, underflow_q;
    reg [31:0] y_read_word_q, cb_read_word_q, cr_read_word_q;
    reg [1:0] y_lane_q;
    reg [1:0] c_lane_q;

    wire pixel_in_bounds = in_pixel_x < FRAME_WIDTH && in_pixel_y < FRAME_HEIGHT;
    wire pixel_sample = in_pixel_de && pixel_in_bounds && !frame_start_pixel && !pixel_rst;
    wire pixel_bank = in_pixel_y[2];
    wire [31:0] y_read_index = (in_pixel_y[1:0] * Y_WORDS_PER_ROW) + (in_pixel_x >> 2);
    wire [31:0] c_read_index = (in_pixel_y[1] * C_WORDS_PER_ROW) + (in_pixel_x >> 3);

    always @(posedge pixel_clk) begin
        if (pixel_rst) begin
            out_x_q <= 16'd0;
            out_y_q <= 16'd0;
            out_de_q <= 1'b0;
            out_bank_ready_q <= 1'b0;
            underflow_q <= 1'b0;
            y_read_word_q <= 32'd0;
            cb_read_word_q <= 32'd0;
            cr_read_word_q <= 32'd0;
            y_lane_q <= 2'b00;
            c_lane_q <= 2'b00;
        end else begin
            out_x_q <= in_pixel_x;
            out_y_q <= in_pixel_y;
            out_de_q <= in_pixel_de && pixel_in_bounds && !frame_start_pixel;
            out_bank_ready_q <= pixel_sample && bank_full_pixel[pixel_bank];
            underflow_q <= pixel_sample && !bank_full_pixel[pixel_bank];
            if (pixel_sample) begin
                if (pixel_bank) begin
                    y_read_word_q <= y_bank1[y_read_index];
                    cb_read_word_q <= cb_bank1[c_read_index];
                    cr_read_word_q <= cr_bank1[c_read_index];
                end else begin
                    y_read_word_q <= y_bank0[y_read_index];
                    cb_read_word_q <= cb_bank0[c_read_index];
                    cr_read_word_q <= cr_bank0[c_read_index];
                end
                y_lane_q <= in_pixel_x[1:0];
                c_lane_q <= in_pixel_x[2:1];
            end else begin
                y_read_word_q <= 32'd0;
                cb_read_word_q <= 32'd0;
                cr_read_word_q <= 32'd0;
                y_lane_q <= 2'b00;
                c_lane_q <= 2'b00;
            end
        end
    end

    wire [31:0] y_shifted = y_read_word_q >> {y_lane_q, 3'b000};
    wire [31:0] cb_shifted = cb_read_word_q >> {c_lane_q, 3'b000};
    wire [31:0] cr_shifted = cr_read_word_q >> {c_lane_q, 3'b000};
    assign out_pixel_x = out_x_q;
    assign out_pixel_y = out_y_q;
    assign out_pixel_de = out_de_q;
    assign out_y = y_shifted[7:0];
    assign out_cb = cb_shifted[7:0];
    assign out_cr = cr_shifted[7:0];
    assign out_bank_ready = out_bank_ready_q;
    assign pixel_bank_ready = bank_full_pixel;
    assign pixel_underflow = underflow_q;

    wire unused_sizes = (Y_WORDS_PER_BANK == 0) || (C_WORDS_PER_BANK == 0) ||
                        (unused_group_width == {GROUP_BITS{1'b1}} && FRAME_HEIGHT == 0);

    // CDC release/ready toggle handshake. frame_start_pixel clears local bank
    // validity and samples the synchronized toggle epoch; it does not reset
    // either toggle, avoiding a false event on each frame.
    wire last_pixel_in_group = pixel_sample && (in_pixel_x == FRAME_WIDTH - 1) &&
                               (in_pixel_y[1:0] == 2'b11);
    always @(posedge pixel_clk) begin
        if (pixel_rst) begin
            ready_seen_pixel <= 2'b00;
            bank_full_pixel <= 2'b00;
            release_toggle_pixel <= 2'b00;
        end else if (frame_start_pixel) begin
            ready_seen_pixel <= ready_sync_pixel;
            bank_full_pixel <= 2'b00;
        end else begin
            if (!bank_full_pixel[0] && ready_sync_pixel[0] != ready_seen_pixel[0]) begin
                bank_full_pixel[0] <= 1'b1;
                ready_seen_pixel[0] <= ready_sync_pixel[0];
            end
            if (!bank_full_pixel[1] && ready_sync_pixel[1] != ready_seen_pixel[1]) begin
                bank_full_pixel[1] <= 1'b1;
                ready_seen_pixel[1] <= ready_sync_pixel[1];
            end
            if (last_pixel_in_group && bank_full_pixel[pixel_bank]) begin
                bank_full_pixel[pixel_bank] <= 1'b0;
                release_toggle_pixel[pixel_bank] <= ready_seen_pixel[pixel_bank];
            end
        end
    end
endmodule
