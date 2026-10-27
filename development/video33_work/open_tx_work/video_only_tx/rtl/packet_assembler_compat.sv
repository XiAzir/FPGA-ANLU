// Forked from upstream/src/packet_assembler.sv at 83b1c9543a91b776671a44e68e130f81cae437b7.
// Icarus 12 does not support the upstream unpacked-array assignments; this
// scalar-register form preserves the upstream BCH bit and counter ordering.
module packet_assembler_compat (
    input logic clk_pixel,
    input logic reset,
    input logic data_island_period,
    input logic [23:0] header,
    input logic [55:0] sub [3:0],
    output logic [8:0] packet_data,
    output logic [4:0] counter = 5'd0
);
    logic [7:0] parity0 = 8'd0;
    logic [7:0] parity1 = 8'd0;
    logic [7:0] parity2 = 8'd0;
    logic [7:0] parity3 = 8'd0;
    logic [7:0] parity4 = 8'd0;
    wire [5:0] counter_t2 = {counter, 1'b0};
    wire [5:0] counter_t2_p1 = {counter, 1'b1};
    wire [63:0] bch0 = {parity0, sub[0]};
    wire [63:0] bch1 = {parity1, sub[1]};
    wire [63:0] bch2 = {parity2, sub[2]};
    wire [63:0] bch3 = {parity3, sub[3]};
    wire [31:0] bch4 = {parity4, header};
    wire [7:0] parity0_next = next_ecc(parity0, sub[0][counter_t2]);
    wire [7:0] parity1_next = next_ecc(parity1, sub[1][counter_t2]);
    wire [7:0] parity2_next = next_ecc(parity2, sub[2][counter_t2]);
    wire [7:0] parity3_next = next_ecc(parity3, sub[3][counter_t2]);
    wire [7:0] parity0_next2 = next_ecc(parity0_next, sub[0][counter_t2_p1]);
    wire [7:0] parity1_next2 = next_ecc(parity1_next, sub[1][counter_t2_p1]);
    wire [7:0] parity2_next2 = next_ecc(parity2_next, sub[2][counter_t2_p1]);
    wire [7:0] parity3_next2 = next_ecc(parity3_next, sub[3][counter_t2_p1]);
    wire [7:0] parity4_next = next_ecc(parity4, header[counter]);

    function automatic [7:0] next_ecc(input [7:0] ecc, input next_bch_bit);
        next_ecc = (ecc >> 1) ^ ((ecc[0] ^ next_bch_bit) ? 8'b10000011 : 8'd0);
    endfunction

    always_comb begin
        packet_data = {bch3[counter_t2_p1], bch2[counter_t2_p1],
                       bch1[counter_t2_p1], bch0[counter_t2_p1],
                       bch3[counter_t2], bch2[counter_t2],
                       bch1[counter_t2], bch0[counter_t2], bch4[counter]};
    end

    always_ff @(posedge clk_pixel) begin
        if (reset)
            counter <= 5'd0;
        else if (data_island_period)
            counter <= counter + 5'd1;
    end

    always_ff @(posedge clk_pixel) begin
        if (reset || !data_island_period) begin
            parity0 <= 8'd0; parity1 <= 8'd0; parity2 <= 8'd0;
            parity3 <= 8'd0; parity4 <= 8'd0;
        end else if (counter < 5'd28) begin
            parity0 <= parity0_next2;
            parity1 <= parity1_next2;
            parity2 <= parity2_next2;
            parity3 <= parity3_next2;
            if (counter < 5'd24)
                parity4 <= parity4_next;
        end else if (counter == 5'd31) begin
            parity0 <= 8'd0; parity1 <= 8'd0; parity2 <= 8'd0;
            parity3 <= 8'd0; parity4 <= 8'd0;
        end
    end
endmodule
