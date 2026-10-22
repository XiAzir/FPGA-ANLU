module player_rgb_adjust_reference (
    input wire [23:0] rgb_in,
    input wire [3:0] brightness_index,
    input wire [2:0] contrast_index,
    output wire [23:0] rgb_out
);
    wire [7:0] pixel_r = rgb_in[23:16];
    wire [7:0] pixel_g = rgb_in[15:8];
    wire [7:0] pixel_b = rgb_in[7:0];
    wire signed [11:0] centered_r = $signed({1'b0, pixel_r}) - 12'sd128;
    wire signed [11:0] centered_g = $signed({1'b0, pixel_g}) - 12'sd128;
    wire signed [11:0] centered_b = $signed({1'b0, pixel_b}) - 12'sd128;

    reg signed [11:0] adjusted_r;
    reg signed [11:0] adjusted_g;
    reg signed [11:0] adjusted_b;
    reg signed [11:0] gain_r;
    reg signed [11:0] gain_g;
    reg signed [11:0] gain_b;
    reg signed [11:0] offset;
    reg [7:0] result_r;
    reg [7:0] result_g;
    reg [7:0] result_b;
    reg [2:0] contrast_safe;
    reg [3:0] brightness_safe;

    always @* begin
        contrast_safe = (contrast_index <= 3'd4) ? contrast_index : 3'd2;
        // An invalid selector is neutral brightness (B=4, offset zero).
        brightness_safe = (brightness_index <= 4'd8) ? brightness_index : 4'd4;
        offset = ($signed({1'b0, brightness_safe}) - 12'sd4) <<< 4;

        case (contrast_safe)
            3'd0: begin
                gain_r = centered_r >>> 1;
                gain_g = centered_g >>> 1;
                gain_b = centered_b >>> 1;
            end
            3'd1: begin
                gain_r = (centered_r + (centered_r <<< 1)) >>> 2;
                gain_g = (centered_g + (centered_g <<< 1)) >>> 2;
                gain_b = (centered_b + (centered_b <<< 1)) >>> 2;
            end
            3'd2: begin
                gain_r = centered_r;
                gain_g = centered_g;
                gain_b = centered_b;
            end
            3'd3: begin
                gain_r = (centered_r + (centered_r <<< 2)) >>> 2;
                gain_g = (centered_g + (centered_g <<< 2)) >>> 2;
                gain_b = (centered_b + (centered_b <<< 2)) >>> 2;
            end
            3'd4: begin
                gain_r = (centered_r + (centered_r <<< 1)) >>> 1;
                gain_g = (centered_g + (centered_g <<< 1)) >>> 1;
                gain_b = (centered_b + (centered_b <<< 1)) >>> 1;
            end
            default: begin
                gain_r = centered_r;
                gain_g = centered_g;
                gain_b = centered_b;
            end
        endcase

        adjusted_r = gain_r + 12'sd128 + offset;
        adjusted_g = gain_g + 12'sd128 + offset;
        adjusted_b = gain_b + 12'sd128 + offset;

        if (adjusted_r < 0) result_r = 8'd0;
        else if (adjusted_r > 255) result_r = 8'd255;
        else result_r = adjusted_r[7:0];
        if (adjusted_g < 0) result_g = 8'd0;
        else if (adjusted_g > 255) result_g = 8'd255;
        else result_g = adjusted_g[7:0];
        if (adjusted_b < 0) result_b = 8'd0;
        else if (adjusted_b > 255) result_b = 8'd255;
        else result_b = adjusted_b[7:0];
    end

    assign rgb_out = {result_r, result_g, result_b};
endmodule
