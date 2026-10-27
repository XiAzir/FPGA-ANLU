// Verilog-2001 scalar-register translation of packet_assembler_compat.sv.
// sub_flat groups subpacket 0 in bits [55:0], then subpacket 1, 2 and 3.
module packet_assembler_compat (
    input wire clk_pixel,
    input wire reset,
    input wire data_island_period,
    input wire [23:0] header,
    input wire [223:0] sub_flat,
    output wire [8:0] packet_data,
    output reg [4:0] counter
);
    function [7:0] next_ecc;
        input [7:0] ecc;
        input next_bch_bit;
        begin
            next_ecc = (ecc >> 1) ^ ((ecc[0] ^ next_bch_bit) ? 8'b10000011 : 8'd0);
        end
    endfunction

    wire [55:0] sub0 = sub_flat[55:0];
    wire [55:0] sub1 = sub_flat[111:56];
    wire [55:0] sub2 = sub_flat[167:112];
    wire [55:0] sub3 = sub_flat[223:168];
    reg [7:0] parity0, parity1, parity2, parity3, parity4;
    wire [5:0] counter_t2 = {counter, 1'b0};
    wire [5:0] counter_t2_p1 = {counter, 1'b1};
    wire [63:0] bch0, bch1, bch2, bch3;
    wire [31:0] bch4;
    wire [7:0] parity0_next, parity1_next, parity2_next, parity3_next;
    wire [7:0] parity0_next2, parity1_next2, parity2_next2, parity3_next2;
    wire [7:0] parity4_next;

    assign bch0 = {parity0, sub0};
    assign bch1 = {parity1, sub1};
    assign bch2 = {parity2, sub2};
    assign bch3 = {parity3, sub3};
    assign bch4 = {parity4, header};
    assign parity0_next = next_ecc(parity0, sub0[counter_t2]);
    assign parity1_next = next_ecc(parity1, sub1[counter_t2]);
    assign parity2_next = next_ecc(parity2, sub2[counter_t2]);
    assign parity3_next = next_ecc(parity3, sub3[counter_t2]);
    assign parity0_next2 = next_ecc(parity0_next, sub0[counter_t2_p1]);
    assign parity1_next2 = next_ecc(parity1_next, sub1[counter_t2_p1]);
    assign parity2_next2 = next_ecc(parity2_next, sub2[counter_t2_p1]);
    assign parity3_next2 = next_ecc(parity3_next, sub3[counter_t2_p1]);
    assign parity4_next = next_ecc(parity4, header[counter]);

    assign packet_data = {bch3[counter_t2_p1], bch2[counter_t2_p1],
                          bch1[counter_t2_p1], bch0[counter_t2_p1],
                          bch3[counter_t2], bch2[counter_t2],
                          bch1[counter_t2], bch0[counter_t2], bch4[counter]};

    initial begin
        counter = 5'd0;
        parity0 = 8'd0;
        parity1 = 8'd0;
        parity2 = 8'd0;
        parity3 = 8'd0;
        parity4 = 8'd0;
    end

    always @(posedge clk_pixel) begin
        if (reset)
            counter <= 5'd0;
        else if (data_island_period)
            counter <= counter + 5'd1;
    end

    always @(posedge clk_pixel) begin
        if (reset || !data_island_period) begin
            parity0 <= 8'd0;
            parity1 <= 8'd0;
            parity2 <= 8'd0;
            parity3 <= 8'd0;
            parity4 <= 8'd0;
        end else if (counter < 5'd28) begin
            parity0 <= parity0_next2;
            parity1 <= parity1_next2;
            parity2 <= parity2_next2;
            parity3 <= parity3_next2;
            if (counter < 5'd24)
                parity4 <= parity4_next;
        end else if (counter == 5'd31) begin
            parity0 <= 8'd0;
            parity1 <= 8'd0;
            parity2 <= 8'd0;
            parity3 <= 8'd0;
            parity4 <= 8'd0;
        end
    end
endmodule
