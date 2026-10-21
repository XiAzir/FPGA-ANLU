// Runtime-only video-source diagnostic. It never changes or resets the SD,
// SDRAM, audio, PLL, or frame-read machinery.
module player_video_source_probe (
    input  wire        clk,
    input  wire        rst,
    input  wire        key0_n_async,
    input  wire        tone_press,
    input  wire        vs,
    input  wire        bmp_valid,
    input  wire [1:0]  image_index,
    input  wire [23:0] bmp_rgb,
    output reg         probe_mode,
    output wire        tone_toggle,
    output wire        key0_active,
    output wire [23:0] rgb_out
);
    reg key0_meta;
    reg key0_sync;
    reg vs_d;
    reg pending_toggle;
    wire probe_request = tone_press && !key0_sync;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            key0_meta <= 1'b1;
            key0_sync <= 1'b1;
            vs_d <= 1'b0;
            pending_toggle <= 1'b0;
            probe_mode <= 1'b0;
        end else begin
            key0_meta <= key0_n_async;
            key0_sync <= key0_meta;
            vs_d <= vs;

            if (vs && !vs_d) begin
                if (pending_toggle ^ probe_request) begin
                    probe_mode <= ~probe_mode;
                end
                pending_toggle <= 1'b0;
            end else if (probe_request) begin
                pending_toggle <= ~pending_toggle;
            end
        end
    end

    assign key0_active = !key0_sync;
    assign tone_toggle = tone_press && key0_sync;
    reg [23:0] probe_rgb;
    always @* begin
        case (image_index)
            2'd0: probe_rgb = 24'hffffff;
            2'd1: probe_rgb = 24'h808080;
            2'd2: probe_rgb = 24'hff0000;
            2'd3: probe_rgb = 24'h00ff00;
            default: probe_rgb = 24'h000000;
        endcase
    end

    assign rgb_out = probe_mode ? probe_rgb :
                     (bmp_valid ? bmp_rgb : 24'h000000);
endmodule
