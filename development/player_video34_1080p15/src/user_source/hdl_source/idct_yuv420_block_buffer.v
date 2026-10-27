// Reorder two IDCT blocks by sample index, then emit 16 contiguous words.
// The IDCT grants a whole non-stallable block; block_space is that grant.
// Each plane is stored as MCU tiles, including the final padded MCU row.
module idct_yuv420_block_buffer #(
    parameter integer FRAME_WIDTH = 1920,
    parameter integer FRAME_HEIGHT = 1080,
    parameter integer ADDR_BITS = 21
) (
    input wire clk, rst, frame_start,
    input wire [ADDR_BITS-1:0] frame_base_word,
    output wire block_space,
    input wire sample_valid,
    input wire signed [31:0] sample_data,
    input wire [5:0] sample_index,
    input wire [31:0] sample_id,
    output wire word_valid,
    input wire word_ready,
    output wire [ADDR_BITS-1:0] word_address,
    output wire [31:0] word_data
);
    localparam integer MCU_COLUMNS = (FRAME_WIDTH+15)/16;
    localparam integer MCU_ROWS = (FRAME_HEIGHT+15)/16;
    localparam integer Y_WORDS = MCU_COLUMNS*MCU_ROWS*64;
    localparam integer C_WORDS = MCU_COLUMNS*MCU_ROWS*16;
    reg [7:0] lane0[0:31],lane1[0:31],lane2[0:31],lane3[0:31];
    reg [ADDR_BITS-1:0] block_base[0:1];
    reg [1:0] occupied, ready;
    reg write_bank, read_bank;
    reg [3:0] read_word;
    wire [4:0] write_slot = {write_bank,sample_index[5:2]};
    wire [4:0] read_slot = {read_bank,read_word};
    wire signed [32:0] shifted = {sample_data[31],sample_data}+33'sd128;
    wire [7:0] sample_byte = shifted[32] ? 0 : ((|shifted[31:8]) ? 255 : shifted[7:0]);
    wire [16:0] mcu_index = sample_id[23:17]*MCU_COLUMNS+sample_id[7:1];
    wire [1:0] y_block = {sample_id[16],sample_id[0]};
    wire [ADDR_BITS-1:0] sample_block_base = frame_base_word+
        ((sample_id[31:30]==0) ? (mcu_index*64+y_block*16) :
         (sample_id[31:30]==1) ? (Y_WORDS+mcu_index*16) :
                                (Y_WORDS+C_WORDS+mcu_index*16));
    assign block_space = !occupied[write_bank];
    assign word_valid = ready[read_bank];
    assign word_address = block_base[read_bank]+read_word;
    assign word_data = {lane3[read_slot],lane2[read_slot],lane1[read_slot],lane0[read_slot]};
    always @(posedge clk) begin
        if(rst || frame_start) begin
            occupied<=0;ready<=0;write_bank<=0;read_bank<=0;read_word<=0;
            block_base[0]<=0;block_base[1]<=0;
        end else begin
            if(word_valid && word_ready) begin
                read_word<=read_word+1'b1;
                if(read_word==15) begin
                    occupied[read_bank]<=0;ready[read_bank]<=0;
                    read_bank<=~read_bank;
                end
            end
            if(sample_valid && sample_id[31:30]!=3) begin
                case(sample_index[1:0])
                    0:lane0[write_slot]<=sample_byte;
                    1:lane1[write_slot]<=sample_byte;
                    2:lane2[write_slot]<=sample_byte;
                    3:lane3[write_slot]<=sample_byte;
                endcase
                if(sample_index==0) begin
                    occupied[write_bank]<=1;
                    block_base[write_bank]<=sample_block_base;
                end
                if(sample_index==63) begin
                    ready[write_bank]<=1;
                    write_bank<=~write_bank;
                end
            end
        end
    end
endmodule
