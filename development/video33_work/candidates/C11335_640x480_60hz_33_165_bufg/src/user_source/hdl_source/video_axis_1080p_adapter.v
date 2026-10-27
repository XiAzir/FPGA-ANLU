module video_axis_1080p_adapter #(parameter integer H_ACTIVE = 1920) (
    input  wire        pixel_clk,
    input  wire        reset,
    input  wire        de,
    input  wire [11:0] x,
    input  wire [10:0] y,
    input  wire [23:0] rgb,
    output reg         axis_user,
    output reg         axis_valid,
    output reg         axis_last,
    output reg  [23:0] axis_data
);
    always @(posedge pixel_clk or posedge reset) begin
        if (reset) begin
            axis_user  <= 1'b0;
            axis_valid <= 1'b0;
            axis_last  <= 1'b0;
            axis_data  <= 24'd0;
        end else begin
            axis_user  <= de && (x == 12'd0) && (y == 11'd0);
            axis_valid <= de;
            axis_last  <= de && (x == H_ACTIVE - 1);
            axis_data  <= rgb;
        end
    end
endmodule


