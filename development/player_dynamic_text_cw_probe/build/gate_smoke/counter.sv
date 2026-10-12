module cw_gate_smoke_top(
    input wire clk,
    input wire rst,
    output wire led
);
    reg [31:0] cw_count_data;

    always @(posedge clk or posedge rst) begin
        if (rst)
            cw_count_data <= 32'd0;
        else
            cw_count_data <= cw_count_data + 1'b1;
    end

    assign led = cw_count_data[31];
endmodule
