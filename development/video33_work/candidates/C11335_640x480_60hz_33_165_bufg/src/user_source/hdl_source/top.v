module top (
    input  wire       clk,
    input  wire       rst_n,
    output wire [3:0] led,
    output wire       seg7_dio,
    output wire       seg7_sclk,
    output wire       seg7_rclk,
    output wire       HDMI_CLK_P,
    output wire       HDMI_D0_P,
    output wire       HDMI_D1_P,
    output wire       HDMI_D2_P
);
    wire pll_lock;
    wire pixel_clk;
    wire serial_clk_raw;
    wire serial_clk;

    video_pll u_video_pll (
        .refclk(clk),
        .reset(1'b0),
        .extlock(pll_lock),
        .clk0_out(pixel_clk),
        .clk1_out(serial_clk_raw)
    );

    EG_LOGIC_BUFG u_hdmi_serial_bufg (.i(serial_clk_raw),.o(serial_clk));

    // Hold the pixel/core/PHY reset for about 30 ms of the generated pixel
    // clock. This keeps reset sequencing in one clock domain and gives the
    // 50 MHz reference-derived PLL time to stabilize before video starts.
    reg [19:0] startup_count = 20'd0;
    reg startup_done = 1'b0;
    always @(posedge pixel_clk or negedge rst_n) begin
        if (!rst_n) begin
            startup_count <= 20'd0;
            startup_done  <= 1'b0;
        end else if (!startup_done) begin
            if (startup_count == 20'd999_999)
                startup_done <= 1'b1;
            else
                startup_count <= startup_count + 1'b1;
        end
    end

    wire pixel_reset = !rst_n || !startup_done;

    wire hsync;
    wire vsync;
    wire de;
    wire [23:0] rgb;
    wire [11:0] x;
    wire [10:0] y;

    video_timing_1080p_custom_colorbar #(
        .H_ACTIVE(640), .H_FRONT(16), .H_SYNC(96), .H_BACK(248), .H_TOTAL(1000),
        .V_ACTIVE(480), .V_FRONT(10), .V_SYNC(2), .V_BACK(58), .V_TOTAL(550),
        .HSYNC_ACTIVE_LOW(1), .VSYNC_ACTIVE_LOW(1)
    ) u_colorbars (
        .pixel_clk(pixel_clk), .reset(pixel_reset),
        .hsync(hsync), .vsync(vsync), .de(de), .rgb(rgb), .x(x), .y(y)
    );

    wire axis_user;
    wire axis_valid;
    wire axis_last;
    wire [23:0] axis_data;
    wire axis_ready;
    video_axis_1080p_adapter #(.H_ACTIVE(640)) u_axis_adapter (
        .pixel_clk(pixel_clk), .reset(pixel_reset), .de(de), .x(x), .y(y), .rgb(rgb),
        .axis_user(axis_user), .axis_valid(axis_valid), .axis_last(axis_last), .axis_data(axis_data)
    );

    wire video_locked;
    wire [9:0] tmds_ch0;
    wire [9:0] tmds_ch1;
    wire [9:0] tmds_ch2;
    wire [9:0] tmds_clk;

    hdmi_1_4b_transmitter_core_wrapper #(
        .DEVICE("EG"),
        .HTOTAL(1000), .HSA(96), .HFP(16), .HBP(248), .HACTIVE(640),
        .VTOTAL(550), .VSA(2), .VFP(10), .VBP(58), .VACTIVE(480),
        .VIDEO_VIC(0),
        .VIDEO_TPG("Disable"),
        .VIDEO_FORMAT("RGB"),
        .AUDIO_SAMPLE_RATE("48K"),
        .IIC_SCL_DIV(125)
    ) u_hdmi_core (
        .I_pixel_clk(pixel_clk),
        .I_rst(pixel_reset),
        .I_edid_read_trig(1'b0),
        .O_edid_read_valid(), .O_edid_read_data(),
        .I_axis_s_user(axis_user), .I_axis_s_valid(axis_valid), .I_axis_s_last(axis_last),
        .I_axis_s_data(axis_data), .O_axis_s_ready(axis_ready),
        .I_audio_valid(1'b0), .I_audio_left_data(24'd0), .I_audio_right_data(24'd0),
        .I_acr_valid(1'b0), .I_acr_cts(20'd0), .I_acr_n(20'd0),
        .O_video_locked(video_locked),
        .O_ddc_scl(), .IO_ddc_sda(),
        .O_ch0_tmds_data(tmds_ch0), .O_ch1_tmds_data(tmds_ch1),
        .O_ch2_tmds_data(tmds_ch2), .O_clk_tmds_data(tmds_clk)
    );

    hdmi_phy_wrapper #(.DEVICE("EG")) u_hdmi_phy (
        .I_pixel_clk(pixel_clk), .I_serial_clk(serial_clk), .I_rst(pixel_reset),
        .I_tmds_channel_0(tmds_ch0), .I_tmds_channel_1(tmds_ch1),
        .I_tmds_channel_2(tmds_ch2), .I_tmds_channel_clk(tmds_clk),
        .O_tmds_ch0_p(HDMI_D0_P), .O_tmds_ch1_p(HDMI_D1_P),
        .O_tmds_ch2_p(HDMI_D2_P), .O_tmds_clk_p(HDMI_CLK_P)
    );

    // AC201 LEDs are active low. LED0=PLL locked, LED1=HDMI core locked,
    // LED2=frame activity (~1 s blink), LED3=startup complete.
    reg [3:0] frame_count;
    reg vsync_d;
    always @(posedge pixel_clk or posedge pixel_reset) begin
        if (pixel_reset) begin
            frame_count <= 4'd0;
            vsync_d <= 1'b0;
        end else begin
            vsync_d <= vsync;
            if (vsync && !vsync_d)
                frame_count <= frame_count + 1'b1;
        end
    end
    assign led[0] = ~pll_lock;
    assign led[1] = ~video_locked;
    assign led[2] = ~frame_count[2];
    assign led[3] = ~startup_done;

    status_hex595 #(.CLK_HZ(33000000)) u_build_id (
        .clk(pixel_clk), .rst(pixel_reset), .hex_value(32'h00C11335),
        .seg7_dio(seg7_dio), .seg7_sclk(seg7_sclk), .seg7_rclk(seg7_rclk)
    );
endmodule



