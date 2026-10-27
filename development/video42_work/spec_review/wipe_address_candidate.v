// Timing candidate only. Keeps the original frame_ack capture edge and
// collapses offset subtraction plus mapped-base addition into one delta add.
module player_wipe_address_candidate #(
    parameter integer FRAME_WIDTH=640,
    parameter integer FRAME_HEIGHT=480,
    parameter integer ADDR_BITS=21
)(
    input wire clk, rst,
    input wire frame_ack,
    input wire wipe_active_async,
    input wire [8:0] wipe_rows_async,
    input wire [1:0] old_buffer_async, new_buffer_async,
    input wire [ADDR_BITS-1:0] linear_addr,
    output wire [ADDR_BITS-1:0] mapped_addr
);
    localparam integer LINE_WORDS=(FRAME_WIDTH/4)*3;
    localparam [ADDR_BITS-1:0] FRAME_WORDS=LINE_WORDS*FRAME_HEIGHT;

    reg active_s0,active_s1;
    reg [8:0] rows_s0,rows_s1;
    reg [1:0] old_s0,old_s1,new_s0,new_s1;
    reg ack_prev,active;
    reg [ADDR_BITS-1:0] old_base;
    reg [ADDR_BITS:0] cut_absolute;
    reg signed [ADDR_BITS:0] base_delta;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            active_s0<=0; active_s1<=0; rows_s0<=0; rows_s1<=0;
            old_s0<=0; old_s1<=0; new_s0<=0; new_s1<=0;
            ack_prev<=0; active<=0; old_base<=0; cut_absolute<=0; base_delta<=0;
        end else begin
            active_s0<=wipe_active_async; active_s1<=active_s0;
            rows_s0<=wipe_rows_async; rows_s1<=rows_s0;
            old_s0<=old_buffer_async; old_s1<=old_s0;
            new_s0<=new_buffer_async; new_s1<=new_s0;
            ack_prev<=frame_ack;
            if(frame_ack && !ack_prev) begin
                active<=active_s1;
                old_base<=old_s1[0] ? FRAME_WORDS : {ADDR_BITS{1'b0}};
                cut_absolute<= (old_s1[0] ? {1'b0,FRAME_WORDS} : '0) + rows_s1*LINE_WORDS;
                base_delta<= $signed({1'b0,(new_s1[0] ? FRAME_WORDS : {ADDR_BITS{1'b0}})}) -
                             $signed({1'b0,(old_s1[0] ? FRAME_WORDS : {ADDR_BITS{1'b0}})});
            end
        end
    end

    wire [ADDR_BITS:0] linear_ext={1'b0,linear_addr};
    wire in_old_cut=(linear_ext >= {1'b0,old_base}) &&
                    (linear_ext < cut_absolute);
    wire signed [ADDR_BITS:0] mapped_sum=$signed({1'b0,linear_addr})+base_delta;
    assign mapped_addr=(active && in_old_cut) ? mapped_sum[ADDR_BITS-1:0] : linear_addr;
endmodule
