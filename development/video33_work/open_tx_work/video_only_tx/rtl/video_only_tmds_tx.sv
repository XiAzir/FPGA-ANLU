// Video-only HDMI 1.4b parallel-TMDS experiment.
// The TMDS channel encoder, AVI InfoFrame and packet ECC are the pinned
// hdl-util/hdmi sources in ../upstream/src. This file is the local scheduler
// and geometry fork; it deliberately has no audio/sample-clock interface.
module video_only_tmds_tx #(
    parameter integer H_ACTIVE = 1920,
    parameter integer H_FRONT = 8,
    parameter integer H_SYNC = 8,
    parameter integer H_BACK = 64,
    parameter integer V_ACTIVE = 1080,
    parameter integer V_FRONT = 4,
    parameter integer V_SYNC = 5,
    parameter integer V_BACK = 11,
    parameter bit HSYNC_ACTIVE_LOW = 1'b1,
    parameter bit VSYNC_ACTIVE_LOW = 1'b1
) (
    input  logic        pixel_clk,
    input  logic        reset,
    input  logic [23:0] rgb,
    output logic [15:0] cx,
    output logic [15:0] cy,
    output logic        active,
    output logic [9:0]  tmds0,
    output logic [9:0]  tmds1,
    output logic [9:0]  tmds2,
    output logic [9:0]  clockword
);
    localparam integer H_TOTAL = H_ACTIVE + H_FRONT + H_SYNC + H_BACK;
    localparam integer V_TOTAL = V_ACTIVE + V_FRONT + V_SYNC + V_BACK;
    localparam integer H_COUNT_W = $clog2(H_TOTAL);
    localparam integer V_COUNT_W = $clog2(V_TOTAL);
    // This experiment only targets the measured C35/C36 geometries. Both
    // blanks fit one slot; the scheduler intentionally emits one packet/line.
    localparam integer PACKETS_PER_LINE = 1;

    logic [H_COUNT_W-1:0] x_count = H_TOTAL - 32;
    logic [V_COUNT_W-1:0] y_count = V_TOTAL - 1;
    logic hsync;
    logic vsync;
    logic hsync_pulse;
    logic vsync_pulse;
    logic video_preamble;
    logic video_guard;
    logic data_island_preamble;
    logic data_island_guard;
    logic data_island_period;
    logic [2:0] mode;
    logic [5:0] control_data;
    logic [11:0] data_island_data;
    logic [23:0] video_data;
    logic [23:0] packet_header;
    logic [55:0] packet_sub [3:0];
    logic [8:0] packet_data;
    logic [4:0] packet_pixel_counter;

    assign cx = x_count;
    assign cy = y_count;
    assign active = (x_count < H_ACTIVE) && (y_count < V_ACTIVE);
    assign clockword = 10'b0000011111;

    always_ff @(posedge pixel_clk) begin
        if (reset) begin
            x_count <= H_TOTAL - 32;
            y_count <= V_TOTAL - 1;
        end else if (x_count == H_TOTAL - 1) begin
            x_count <= '0;
            if (y_count == V_TOTAL - 1)
                y_count <= '0;
            else
                y_count <= y_count + 1'b1;
        end else begin
            x_count <= x_count + 1'b1;
        end
    end

    always_comb begin
        hsync_pulse = (x_count >= H_ACTIVE + H_FRONT) &&
                      (x_count < H_ACTIVE + H_FRONT + H_SYNC);
        hsync = HSYNC_ACTIVE_LOW ? !hsync_pulse : hsync_pulse;
        vsync_pulse = (y_count >= V_ACTIVE + V_FRONT) &&
                      (y_count < V_ACTIVE + V_FRONT + V_SYNC);

        if (y_count == V_ACTIVE + V_FRONT - 1)
            vsync = VSYNC_ACTIVE_LOW ?
                    !(x_count >= H_ACTIVE + H_FRONT) :
                     (x_count >= H_ACTIVE + H_FRONT);
        else if (y_count == V_ACTIVE + V_FRONT + V_SYNC - 1)
            vsync = VSYNC_ACTIVE_LOW ?
                    !(x_count < H_ACTIVE + H_FRONT) :
                     (x_count < H_ACTIVE + H_FRONT);
        else begin
            vsync = VSYNC_ACTIVE_LOW ? !vsync_pulse : vsync_pulse;
        end

        video_preamble = (x_count >= H_TOTAL - 10) && (x_count < H_TOTAL - 2) &&
                         ((y_count == V_TOTAL - 1) || (y_count < V_ACTIVE - 1));
        video_guard = (x_count >= H_TOTAL - 2) && (x_count < H_TOTAL) &&
                      ((y_count == V_TOTAL - 1) || (y_count < V_ACTIVE - 1));
        data_island_preamble = (x_count >= H_ACTIVE + 4) && (x_count < H_ACTIVE + 12);
        data_island_guard =
            (((x_count >= H_ACTIVE + 12) && (x_count < H_ACTIVE + 14)) ||
             ((x_count >= H_ACTIVE + 14 + 32 * PACKETS_PER_LINE) &&
              (x_count <  H_ACTIVE + 16 + 32 * PACKETS_PER_LINE)));
        data_island_period = (x_count >= H_ACTIVE + 14) &&
            (x_count < H_ACTIVE + 14 + 32 * PACKETS_PER_LINE);

        if (data_island_guard)
            mode = 3'd4;
        else if (data_island_period)
            mode = 3'd3;
        else if (video_guard)
            mode = 3'd2;
        else if (active)
            mode = 3'd1;
        else
            mode = 3'd0;

        control_data = {{1'b0, data_island_preamble},
                        {1'b0, (video_preamble || data_island_preamble)},
                        {vsync, hsync}};
        data_island_data[11:4] = packet_data[8:1];
        data_island_data[3] = (x_count != 0);
        data_island_data[2] = packet_data[0];
        data_island_data[1:0] = {vsync, hsync};
        video_data = rgb;
    end

    logic [23:0] avi_header;
    wire [55:0] avi_sub [3:0];
    auxiliary_video_information_info_frame #(
        .VIDEO_ID_CODE(0)
    ) avi_infoframe (
        .header(avi_header),
        .sub(avi_sub)
    );

    logic [7:0] spd_byte [27:0];
    integer spd_sum;
    integer k;
    always_comb begin
        for (k = 0; k < 28; k = k + 1)
            spd_byte[k] = 8'd0;
        // SPD: vendor="FPGAANLU", product="VIDEO ONLY TX" (ASCII padded).
        spd_byte[1] = "F"; spd_byte[2] = "P"; spd_byte[3] = "G"; spd_byte[4] = "A";
        spd_byte[5] = "A"; spd_byte[6] = "N"; spd_byte[7] = "L"; spd_byte[8] = "U";
        spd_byte[9] = "V"; spd_byte[10] = "I"; spd_byte[11] = "D"; spd_byte[12] = "E";
        spd_byte[13] = "O"; spd_byte[14] = " "; spd_byte[15] = "O"; spd_byte[16] = "N";
        spd_byte[17] = "L"; spd_byte[18] = "Y"; spd_byte[19] = " "; spd_byte[20] = "T";
        spd_byte[21] = "X"; spd_byte[25] = 8'd0;
        spd_sum = 8'h83 + 8'd1 + 8'd25;
        for (k = 1; k <= 25; k = k + 1)
            spd_sum = spd_sum + spd_byte[k];
        spd_byte[0] = -spd_sum;
    end

    integer j;
    always_comb begin
        packet_header = 24'd0;
        for (j = 0; j < 4; j = j + 1)
            packet_sub[j] = 56'd0;

        if (y_count == 0) begin
            packet_header = avi_header;
            for (j = 0; j < 4; j = j + 1)
                packet_sub[j] = avi_sub[j];
        end else if (y_count == 1) begin
            packet_header = {3'b000, 5'd25, 8'd1, 8'h83};
            for (j = 0; j < 4; j = j + 1)
                packet_sub[j] = {spd_byte[6 + j*7], spd_byte[5 + j*7],
                                 spd_byte[4 + j*7], spd_byte[3 + j*7],
                                 spd_byte[2 + j*7], spd_byte[1 + j*7],
                                 spd_byte[j*7]};
        end
    end

    packet_assembler_compat packet_ecc (
        .clk_pixel(pixel_clk),
        .reset(reset),
        .data_island_period(data_island_period),
        .header(packet_header),
        .sub(packet_sub),
        .packet_data(packet_data),
        .counter(packet_pixel_counter)
    );

    tmds_channel #(.CN(0)) tmds_blue (
        .clk_pixel(pixel_clk), .video_data(video_data[7:0]),
        .data_island_data(data_island_data[3:0]),
        .control_data(control_data[1:0]), .mode(mode), .tmds(tmds0)
    );
    tmds_channel #(.CN(1)) tmds_green (
        .clk_pixel(pixel_clk), .video_data(video_data[15:8]),
        .data_island_data(data_island_data[7:4]),
        .control_data(control_data[3:2]), .mode(mode), .tmds(tmds1)
    );
    tmds_channel #(.CN(2)) tmds_red (
        .clk_pixel(pixel_clk), .video_data(video_data[23:16]),
        .data_island_data(data_island_data[11:8]),
        .control_data(control_data[5:4]), .mode(mode), .tmds(tmds2)
    );
endmodule
