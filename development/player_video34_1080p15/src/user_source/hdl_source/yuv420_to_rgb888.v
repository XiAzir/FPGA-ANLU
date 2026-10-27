// Two-stage elastic YCbCr-to-RGB pipeline matching jpeg_output.v fixed-point
// coefficients and arithmetic-shift semantics. Inputs are stored 8-bit
// samples: Y=centered_IDCT_Y+128, Cb/Cr=centered_delta+128, each saturated
// to [0,255] by the cache writer before storage.
module yuv420_to_rgb888 (
    input  wire        clk,
    input  wire        rst,
    input  wire        in_valid,
    output wire        in_ready,
    input  wire [15:0] in_x,
    input  wire [15:0] in_y,
    input  wire [7:0]  in_y_sample,
    input  wire [7:0]  in_cb_sample,
    input  wire [7:0]  in_cr_sample,

    output wire        out_valid,
    input  wire        out_ready,
    output reg  [15:0] out_x,
    output reg  [15:0] out_y,
    output reg  [7:0]  out_r,
    output reg  [7:0]  out_g,
    output reg  [7:0]  out_b
);
    reg s1_valid_q;
    reg [15:0] s1_x_q, s1_y_q;
    reg [7:0] s1_y_sample_q;
    reg signed [31:0] s1_cr_1402_q, s1_cr_0714_q;
    reg signed [31:0] s1_cb_0344_q, s1_cb_1772_q;
    reg s2_valid_q;

    wire s2_ready = !s2_valid_q || out_ready;
    wire s1_ready = !s1_valid_q || s2_ready;
    assign in_ready = s1_ready;
    assign out_valid = s2_valid_q;

    wire signed [8:0] cb_delta = $signed({1'b0, in_cb_sample}) - 9'sd128;
    wire signed [8:0] cr_delta = $signed({1'b0, in_cr_sample}) - 9'sd128;
    wire signed [31:0] cb_delta_32 = {{23{cb_delta[8]}}, cb_delta};
    wire signed [31:0] cr_delta_32 = {{23{cr_delta[8]}}, cr_delta};

    wire signed [31:0] cr_1402_product = cr_delta_32 * 32'sd5743;
    wire signed [31:0] cr_1402 = cr_1402_product >>> 12;

    (* dsp_style = "no" *) wire signed [31:0] cr_0714_product =
          (cr_delta_32 <<< 12) - (cr_delta_32 <<< 10)
        - (cr_delta_32 <<< 7) - (cr_delta_32 <<< 4)
        - (cr_delta_32 <<< 2) + cr_delta_32;
    (* dsp_style = "no" *) wire signed [31:0] cr_0714 = cr_0714_product >>> 12;

    (* dsp_style = "no" *) wire signed [31:0] cb_0344_product =
          (cb_delta_32 <<< 10) + (cb_delta_32 <<< 8)
        + (cb_delta_32 <<< 7) + (cb_delta_32 <<< 1);
    (* dsp_style = "no" *) wire signed [31:0] cb_0344 = cb_0344_product >>> 12;

    wire signed [31:0] cb_1772_product = cb_delta_32 * 32'sd7258;
    wire signed [31:0] cb_1772 = cb_1772_product >>> 12;

    wire signed [31:0] r_sum = $signed({1'b0, s1_y_sample_q}) + s1_cr_1402_q;
    wire signed [31:0] g_sum = $signed({1'b0, s1_y_sample_q}) - s1_cb_0344_q - s1_cr_0714_q;
    wire signed [31:0] b_sum = $signed({1'b0, s1_y_sample_q}) + s1_cb_1772_q;

    function [7:0] clip8;
        input signed [31:0] value;
        begin
            if (value < 0)
                clip8 = 8'd0;
            else if (value > 32'sd255)
                clip8 = 8'd255;
            else
                clip8 = value[7:0];
        end
    endfunction

    always @(posedge clk) begin
        if (rst) begin
            s1_valid_q <= 1'b0;
            s2_valid_q <= 1'b0;
            s1_x_q <= 16'd0; s1_y_q <= 16'd0; s1_y_sample_q <= 8'd0;
            s1_cr_1402_q <= 0; s1_cr_0714_q <= 0;
            s1_cb_0344_q <= 0; s1_cb_1772_q <= 0;
            out_x <= 16'd0; out_y <= 16'd0;
            out_r <= 8'd0; out_g <= 8'd0; out_b <= 8'd0;
        end else begin
            if (s2_ready)
                s2_valid_q <= s1_valid_q;
            if (s1_valid_q && s2_ready) begin
                out_x <= s1_x_q;
                out_y <= s1_y_q;
                out_r <= clip8(r_sum);
                out_g <= clip8(g_sum);
                out_b <= clip8(b_sum);
            end
            if (s1_ready) begin
                s1_valid_q <= in_valid;
                if (in_valid) begin
                    s1_x_q <= in_x;
                    s1_y_q <= in_y;
                    s1_y_sample_q <= in_y_sample;
                    s1_cr_1402_q <= cr_1402;
                    s1_cr_0714_q <= cr_0714;
                    s1_cb_0344_q <= cb_0344;
                    s1_cb_1772_q <= cb_1772;
                end
            end
        end
    end
endmodule
