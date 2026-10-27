`timescale 1ns/1ps
module tb_hdmi_core_blank;
    reg pixel_clk = 1'b0;
    reg reset = 1'b1;
    wire hsync, vsync, de;
    wire [23:0] rgb;
    wire [11:0] x;
    wire [10:0] y;
    wire axis_user, axis_valid, axis_last;
    wire [23:0] axis_data;
    wire axis_ready;
    wire video_locked;
    wire [9:0] ch0, ch1, ch2, tmds_clk;
    integer locked_samples = 0;

    always #15.151515 pixel_clk = ~pixel_clk;
    initial begin
        repeat (8) @(posedge pixel_clk);
        #1 reset = 1'b0;
    end

    video_timing_1080p_custom_colorbar #(
        .H_ACTIVE(1920), .H_FRONT(8), .H_SYNC(8), .H_BACK(64), .H_TOTAL(2000),
        .V_ACTIVE(1080), .V_FRONT(4), .V_SYNC(5), .V_BACK(11), .V_TOTAL(1100)
    ) timing (
        .pixel_clk(pixel_clk), .reset(reset), .hsync(hsync), .vsync(vsync),
        .de(de), .rgb(rgb), .x(x), .y(y)
    );
    video_axis_1080p_adapter adapter (
        .pixel_clk(pixel_clk), .reset(reset), .de(de), .x(x), .y(y), .rgb(rgb),
        .axis_user(axis_user), .axis_valid(axis_valid), .axis_last(axis_last), .axis_data(axis_data)
    );
    hdmi_1_4b_transmitter_core_wrapper #(
        .DEVICE("EG"),
        .HTOTAL(2000), .HSA(8), .HFP(8), .HBP(64), .HACTIVE(1920),
        .VTOTAL(1100), .VSA(5), .VFP(4), .VBP(11), .VACTIVE(1080),
        .VIDEO_VIC(0), .VIDEO_TPG("Disable"), .VIDEO_FORMAT("RGB"),
        .AUDIO_SAMPLE_RATE("48K"), .IIC_SCL_DIV(125)
    ) core (
        .I_pixel_clk(pixel_clk), .I_rst(reset),
        .I_edid_read_trig(1'b0), .O_edid_read_valid(), .O_edid_read_data(),
        .I_axis_s_user(axis_user), .I_axis_s_valid(axis_valid), .I_axis_s_last(axis_last),
        .I_axis_s_data(axis_data), .O_axis_s_ready(axis_ready),
        .I_audio_valid(1'b0), .I_audio_left_data(24'd0), .I_audio_right_data(24'd0),
        .I_acr_valid(1'b0), .I_acr_cts(20'd0), .I_acr_n(20'd0),
        .O_video_locked(video_locked), .O_ddc_scl(), .IO_ddc_sda(),
        .O_ch0_tmds_data(ch0), .O_ch1_tmds_data(ch1), .O_ch2_tmds_data(ch2), .O_clk_tmds_data(tmds_clk)
    );

    always @(posedge pixel_clk) begin
        if (!reset && video_locked)
            locked_samples <= locked_samples + 1;
    end
    initial begin
        #150_000_000;
        $display("1080p15 core: lock=%0b lock_samples=%0d axis_ready=%0b", video_locked, locked_samples, axis_ready);
        if (!video_locked || locked_samples < 100)
            $fatal(1, "HDMI Core did not lock to 2000x1100/1920x1080/15 Hz input");
        $display("PASS: HDMI Core locked to custom 1080p15 timing with HBlank=80 and VBlank=20.");
        $finish;
    end
endmodule
