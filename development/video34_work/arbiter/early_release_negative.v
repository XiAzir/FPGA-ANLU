// APUG011 application interface: addresses may jump only on 4-word boundaries.
// One read transaction owns the path until all four responses have returned.
// An IDCT block buffer supplies one complete, contiguous 16-word write block.
module yuv_sdram_burst_arbiter #(
    parameter integer ADDR_BITS=21,
    parameter integer SDR_READ_DATA_DELAY=1
) (
    input wire clk,rst,
    input wire init_done,refresh_valid,sdr_busy,
    input wire rd_cmd_valid,
    output wire rd_cmd_ready,
    input wire [ADDR_BITS-1:0] rd_cmd_address,
    output wire rd_valid,
    output wire [31:0] rd_data,
    input wire wr_valid,
    output wire wr_ready,
    input wire [ADDR_BITS-1:0] wr_address,
    input wire [31:0] wr_data,
    output wire idle,
    output wire app_rd_en,
    output wire [ADDR_BITS-1:0] app_rd_address,
    output wire app_wr_en,
    output wire [ADDR_BITS-1:0] app_wr_address,
    output wire [31:0] app_wr_data,
    output wire [3:0] app_wr_mask,
    input wire sdr_rd_valid,
    input wire [31:0] sdr_rd_data
);
    localparam IDLE=0,RD_ISSUE=1,RD_DRAIN=2,WR_ISSUE=3,WR_DRAIN=4;
    reg [2:0] state;
    reg [4:0] issued;
    reg [2:0] returned;
    reg [ADDR_BITS-1:0] read_base;
    reg [31:0] read_data_d1;
    wire transaction_ready=init_done && !refresh_valid && !sdr_busy;
    wire reading=state==RD_ISSUE || state==RD_DRAIN;
    assign rd_cmd_ready=state==IDLE && transaction_ready;
    assign rd_valid=reading && sdr_rd_valid;
    assign rd_data=SDR_READ_DATA_DELAY ? read_data_d1 : sdr_rd_data;
    assign app_rd_en=state==RD_ISSUE && issued<4;
    assign app_rd_address=read_base+issued;
    assign wr_ready=state==WR_ISSUE && issued<16;
    assign app_wr_en=wr_ready && wr_valid;
    assign app_wr_address=wr_address;
    assign app_wr_data=wr_data;
    assign app_wr_mask=0;
    assign idle=state==IDLE && transaction_ready;
    always @(posedge clk) begin
        if(rst) begin
            state<=IDLE;issued<=0;returned<=0;read_base<=0;read_data_d1<=0;
        end else begin
            read_data_d1<=sdr_rd_data;
            if(rd_valid) returned<=returned+1'b1;
            case(state)
                IDLE: if(transaction_ready) begin
                    issued<=0;returned<=0;
                    if(rd_cmd_valid) begin read_base<=rd_cmd_address;state<=RD_ISSUE;end
                    else if(wr_valid) state<=WR_ISSUE;
                end
                RD_ISSUE: begin
                    issued<=issued+1'b1;
                    if(issued==3) state<=RD_DRAIN;
                end
                RD_DRAIN: if(issued==4 && transaction_ready) state<=IDLE;
                WR_ISSUE: if(app_wr_en) begin
                    issued<=issued+1'b1;
                    if(issued==15) state<=WR_DRAIN;
                end
                WR_DRAIN: if(transaction_ready) state<=IDLE;
            endcase
        end
    end
endmodule
