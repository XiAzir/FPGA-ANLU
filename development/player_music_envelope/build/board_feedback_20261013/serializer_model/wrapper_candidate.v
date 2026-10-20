

module hdmi_phy_wrapper#(
    parameter DEVICE = "EG",
    parameter integer TOGGLE_DELAY_PS = 0,
    parameter integer ODDR_D0_DELAY_PS = 0,
    parameter integer ODDR_D1_DELAY_PS = 0,
    parameter integer PAD_CLK_DELAY_PS = 0
    )(
    input wire      I_pixel_clk,
    input wire      I_serial_clk,
    input wire      I_rst,

    input wire[9:0] I_tmds_channel_0,
    input wire[9:0] I_tmds_channel_1,
    input wire[9:0] I_tmds_channel_2,
    input wire[9:0] I_tmds_channel_clk,
    
    output wire     O_tmds_ch0_p,
    output wire     O_tmds_ch1_p,
    output wire     O_tmds_ch2_p,
    output wire     O_tmds_clk_p
);
    
    // Capture all TMDS lanes as one word on the middle of the pixel period.
    // Includes video, controls, audio/data islands and forwarded clock alike.
    // The lane marker also launches on this falling edge. With the existing
    // 25/125 MHz PLL, it is 4 ns from either adjacent serial rising edge.
    reg [9:0] tmds_word_0, tmds_word_1, tmds_word_2, tmds_word_clk;
    always @(negedge I_pixel_clk or posedge I_rst) begin
        if (I_rst) begin
            tmds_word_0 <= 10'd0;
            tmds_word_1 <= 10'd0;
            tmds_word_2 <= 10'd0;
            tmds_word_clk <= 10'd0;
        end else begin
            tmds_word_0 <= I_tmds_channel_0;
            tmds_word_1 <= I_tmds_channel_1;
            tmds_word_2 <= I_tmds_channel_2;
            tmds_word_clk <= I_tmds_channel_clk;
        end
    end

    wire[9:0] S_tmds_data_ch0;
    wire[9:0] S_tmds_data_ch1;
    wire[9:0] S_tmds_data_ch2;
    wire[9:0] S_tmds_data_clk;

    assign S_tmds_data_ch0 = {tmds_word_0[0],
                              tmds_word_0[1],
                              tmds_word_0[2],
                              tmds_word_0[3],
                              tmds_word_0[4],
                              tmds_word_0[5],
                              tmds_word_0[6],
                              tmds_word_0[7],
                              tmds_word_0[8],
                              tmds_word_0[9]};

    assign S_tmds_data_ch1 = {tmds_word_1[0],
                              tmds_word_1[1],
                              tmds_word_1[2],
                              tmds_word_1[3],
                              tmds_word_1[4],
                              tmds_word_1[5],
                              tmds_word_1[6],
                              tmds_word_1[7],
                              tmds_word_1[8],
                              tmds_word_1[9]};

    assign S_tmds_data_ch2 = {tmds_word_2[0],
                              tmds_word_2[1],
                              tmds_word_2[2],
                              tmds_word_2[3],
                              tmds_word_2[4],
                              tmds_word_2[5],
                              tmds_word_2[6],
                              tmds_word_2[7],
                              tmds_word_2[8],
                              tmds_word_2[9]};

    assign S_tmds_data_clk = {tmds_word_clk[0],
                              tmds_word_clk[1],
                              tmds_word_clk[2],
                              tmds_word_clk[3],
                              tmds_word_clk[4],
                              tmds_word_clk[5],
                              tmds_word_clk[6],
                              tmds_word_clk[7],
                              tmds_word_clk[8],
                              tmds_word_clk[9]};


    lane_lvds_10_1 #(
        .DEVICE ( DEVICE ),
        .TOGGLE_DELAY_PS ( TOGGLE_DELAY_PS ),
        .ODDR_D0_DELAY_PS ( ODDR_D0_DELAY_PS ),
        .ODDR_D1_DELAY_PS ( ODDR_D1_DELAY_PS ),
        .PAD_CLK_DELAY_PS ( PAD_CLK_DELAY_PS )    
    )u0_lane_lvds_8_1(
        .I_pixel_clk  ( I_pixel_clk     ),
        .I_serial_clk ( I_serial_clk    ),
        .I_rst        ( I_rst           ),

        .I_data_in    ( S_tmds_data_ch0 ),
        .O_serial_out ( O_tmds_ch0_p    )
    );


    lane_lvds_10_1 #(
        .DEVICE ( DEVICE ),
        .TOGGLE_DELAY_PS ( TOGGLE_DELAY_PS ),
        .ODDR_D0_DELAY_PS ( ODDR_D0_DELAY_PS ),
        .ODDR_D1_DELAY_PS ( ODDR_D1_DELAY_PS ),
        .PAD_CLK_DELAY_PS ( PAD_CLK_DELAY_PS )    
    )u1_lane_lvds_8_1(
        .I_pixel_clk  ( I_pixel_clk     ),
        .I_serial_clk ( I_serial_clk    ),
        .I_rst        ( I_rst           ),
        
        .I_data_in    ( S_tmds_data_ch1 ),
        .O_serial_out ( O_tmds_ch1_p    )
    );


    lane_lvds_10_1 #(
        .DEVICE ( DEVICE ),
        .TOGGLE_DELAY_PS ( TOGGLE_DELAY_PS ),
        .ODDR_D0_DELAY_PS ( ODDR_D0_DELAY_PS ),
        .ODDR_D1_DELAY_PS ( ODDR_D1_DELAY_PS ),
        .PAD_CLK_DELAY_PS ( PAD_CLK_DELAY_PS )    
    )u2_lane_lvds_8_1(
        .I_pixel_clk  ( I_pixel_clk     ),
        .I_serial_clk ( I_serial_clk    ),
        .I_rst        ( I_rst           ),
        
        .I_data_in    ( S_tmds_data_ch2 ),
        .O_serial_out ( O_tmds_ch2_p    )
    );


    lane_lvds_10_1 #(
        .DEVICE ( DEVICE ),
        .TOGGLE_DELAY_PS ( TOGGLE_DELAY_PS ),
        .ODDR_D0_DELAY_PS ( ODDR_D0_DELAY_PS ),
        .ODDR_D1_DELAY_PS ( ODDR_D1_DELAY_PS ),
        .PAD_CLK_DELAY_PS ( PAD_CLK_DELAY_PS )    
    )u3_lane_lvds_8_1(
        .I_pixel_clk  ( I_pixel_clk     ),
        .I_serial_clk ( I_serial_clk    ),
        .I_rst        ( I_rst           ),
        
        .I_data_in    ( S_tmds_data_clk ),
        .O_serial_out ( O_tmds_clk_p    )
    );


endmodule






