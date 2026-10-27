module top (
    input wire clk,
    input wire rst_n,
    output wire [3:0] led,
    output wire seg7_dio,
    output wire seg7_sclk,
    output wire seg7_rclk,
    output wire HDMI_CLK_P,
    output wire HDMI_D0_P,
    output wire HDMI_D1_P,
    output wire HDMI_D2_P
);
    wire pll_lock, pixel_clk, serial_clk_raw, serial_clk;
    video_pll u_video_pll (
        .refclk(clk), .reset(1'b0), .extlock(pll_lock),
        .clk0_out(pixel_clk), .clk1_out(serial_clk_raw)
    );
    EG_LOGIC_BUFG u_hdmi_serial_bufg (.i(serial_clk_raw), .o(serial_clk));

    reg [19:0] startup_count = 0;
    reg startup_done = 0;
    always @(posedge pixel_clk or negedge rst_n) begin
        if (!rst_n) begin
            startup_count <= 0;
            startup_done <= 0;
        end else if (!pll_lock) begin
            startup_count <= 0;
            startup_done <= 0;
        end else if (!startup_done) begin
            if (startup_count == 20'd999999)
                startup_done <= 1;
            else
                startup_count <= startup_count + 1'b1;
        end
    end
    wire pixel_reset = !rst_n || !pll_lock || !startup_done;
    wire [15:0] cx, cy;
    wire pixel_active;
    wire [23:0] rgb = cx < 240  ? 24'hffffff :
                      cx < 480 ? 24'hffff00 :
                      cx < 720 ? 24'h00ffff :
                      cx < 960 ? 24'h00ff00 :
                      cx < 1200 ? 24'hff00ff :
                      cx < 1440 ? 24'hff0000 :
                      cx < 1680 ? 24'h0000ff : 24'h000000;
    wire [9:0] tmds0, tmds1, tmds2, clockword;
    video_only_tmds_tx #(
        .H_ACTIVE(1920), .H_FRONT(88), .H_SYNC(44), .H_BACK(148),
        .V_ACTIVE(1080), .V_FRONT(4), .V_SYNC(5), .V_BACK(36),
        .HSYNC_ACTIVE_LOW(1'b0), .VSYNC_ACTIVE_LOW(1'b0)
    ) u_video_tx (
        .pixel_clk(pixel_clk), .reset(pixel_reset), .rgb(rgb),
        .cx(cx), .cy(cy), .active(pixel_active),
        .tmds0(tmds0), .tmds1(tmds1), .tmds2(tmds2), .clockword(clockword)
    );
    hdmi_phy_wrapper #(.DEVICE("EG")) u_hdmi_phy (
        .I_pixel_clk(pixel_clk), .I_serial_clk(serial_clk), .I_rst(pixel_reset),
        .I_tmds_channel_0(tmds0), .I_tmds_channel_1(tmds1),
        .I_tmds_channel_2(tmds2), .I_tmds_channel_clk(clockword),
        .O_tmds_ch0_p(HDMI_D0_P), .O_tmds_ch1_p(HDMI_D1_P),
        .O_tmds_ch2_p(HDMI_D2_P), .O_tmds_clk_p(HDMI_CLK_P)
    );

    reg [3:0] frame_count;
    reg frame_seen;
    always @(posedge pixel_clk) begin
        if (pixel_reset) begin
            frame_count <= 0;
            frame_seen <= 0;
        end else if (cx == 2199 && cy == 1124) begin
            frame_count <= frame_count + 1'b1;
            frame_seen <= 1;
        end
    end
    assign led[0] = ~pll_lock;
    assign led[1] = ~frame_seen;
    assign led[2] = ~frame_count[2];
    assign led[3] = ~startup_done;
    status_hex595 #(.CLK_HZ(74285714)) u_build_id (
        .clk(pixel_clk), .rst(pixel_reset), .hex_value(32'h00C11339),
        .seg7_dio(seg7_dio), .seg7_sclk(seg7_sclk), .seg7_rclk(seg7_rclk)
    );
endmodule
