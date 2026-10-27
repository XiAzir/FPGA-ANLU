// Verilog-2001 translation of the frozen video_only_tmds_tx.sv candidate.
// Geometry, packet cadence, RGB sampling and output ports are unchanged.
module video_only_tmds_tx #(
    parameter integer H_ACTIVE = 1920,
    parameter integer H_FRONT = 8,
    parameter integer H_SYNC = 8,
    parameter integer H_BACK = 64,
    parameter integer V_ACTIVE = 1080,
    parameter integer V_FRONT = 4,
    parameter integer V_SYNC = 5,
    parameter integer V_BACK = 11,
    parameter HSYNC_ACTIVE_LOW = 1'b1,
    parameter VSYNC_ACTIVE_LOW = 1'b1
) (
    input wire pixel_clk,
    input wire reset,
    input wire [23:0] rgb,
    output wire [15:0] cx,
    output wire [15:0] cy,
    output wire active,
    output wire [9:0] tmds0,
    output wire [9:0] tmds1,
    output wire [9:0] tmds2,
    output wire [9:0] clockword
);
    function integer clog2;
        input integer value;
        integer n;
        begin
            value = value - 1;
            for (n = 0; value > 0; n = n + 1)
                value = value >> 1;
            clog2 = n;
        end
    endfunction

    localparam integer H_TOTAL = H_ACTIVE + H_FRONT + H_SYNC + H_BACK;
    localparam integer V_TOTAL = V_ACTIVE + V_FRONT + V_SYNC + V_BACK;
    localparam integer H_COUNT_W = clog2(H_TOTAL);
    localparam integer V_COUNT_W = clog2(V_TOTAL);
    localparam integer PACKETS_PER_LINE = 1;

    reg [H_COUNT_W-1:0] x_count;
    reg [V_COUNT_W-1:0] y_count;
    reg hsync, vsync, hsync_pulse, vsync_pulse;
    reg video_preamble, video_guard;
    reg data_island_preamble, data_island_guard, data_island_period;
    reg [2:0] mode;
    reg [5:0] control_data;
    reg [11:0] data_island_data;
    reg [23:0] packet_header;
    reg [223:0] packet_sub_flat;
    wire [23:0] avi_header;
    wire [223:0] avi_sub_flat;
    wire [8:0] packet_data;
    wire [4:0] packet_pixel_counter;
    integer j;

    initial begin
        x_count = H_TOTAL - 32;
        y_count = V_TOTAL - 1;
    end

    assign cx = x_count;
    assign cy = y_count;
    assign active = (x_count < H_ACTIVE) && (y_count < V_ACTIVE);
    assign clockword = 10'b0000011111;

    always @(posedge pixel_clk) begin
        if (reset) begin
            x_count <= H_TOTAL - 32;
            y_count <= V_TOTAL - 1;
        end else if (x_count == H_TOTAL - 1) begin
            x_count <= {H_COUNT_W{1'b0}};
            if (y_count == V_TOTAL - 1)
                y_count <= {V_COUNT_W{1'b0}};
            else
                y_count <= y_count + 1'b1;
        end else begin
            x_count <= x_count + 1'b1;
        end
    end

    function [7:0] spd_byte;
        input integer index;
        begin
            case (index)
                0: spd_byte = 8'h70;
                1: spd_byte = "F";
                2: spd_byte = "P";
                3: spd_byte = "G";
                4: spd_byte = "A";
                5: spd_byte = "A";
                6: spd_byte = "N";
                7: spd_byte = "L";
                8: spd_byte = "U";
                9: spd_byte = "V";
                10: spd_byte = "I";
                11: spd_byte = "D";
                12: spd_byte = "E";
                13: spd_byte = "O";
                14: spd_byte = " ";
                15: spd_byte = "O";
                16: spd_byte = "N";
                17: spd_byte = "L";
                18: spd_byte = "Y";
                19: spd_byte = " ";
                20: spd_byte = "T";
                21: spd_byte = "X";
                default: spd_byte = 8'd0;
            endcase
        end
    endfunction

    function [55:0] make_spd_sub;
        input integer which;
        begin
            make_spd_sub = {spd_byte(6 + which*7), spd_byte(5 + which*7),
                            spd_byte(4 + which*7), spd_byte(3 + which*7),
                            spd_byte(2 + which*7), spd_byte(1 + which*7),
                            spd_byte(which*7)};
        end
    endfunction

    auxiliary_video_information_info_frame avi_infoframe (
        .header(avi_header),
        .sub_flat(avi_sub_flat)
    );

    always @* begin
        hsync_pulse = (x_count >= H_ACTIVE + H_FRONT) &&
                      (x_count < H_ACTIVE + H_FRONT + H_SYNC);
        hsync = HSYNC_ACTIVE_LOW ? !hsync_pulse : hsync_pulse;
        vsync_pulse = (y_count >= V_ACTIVE + V_FRONT) &&
                      (y_count < V_ACTIVE + V_FRONT + V_SYNC);
        if (y_count == V_ACTIVE + V_FRONT - 1)
            vsync = VSYNC_ACTIVE_LOW ? !(x_count >= H_ACTIVE + H_FRONT) :
                                       (x_count >= H_ACTIVE + H_FRONT);
        else if (y_count == V_ACTIVE + V_FRONT + V_SYNC - 1)
            vsync = VSYNC_ACTIVE_LOW ? !(x_count < H_ACTIVE + H_FRONT) :
                                       (x_count < H_ACTIVE + H_FRONT);
        else
            vsync = VSYNC_ACTIVE_LOW ? !vsync_pulse : vsync_pulse;

        video_preamble = (x_count >= H_TOTAL - 10) && (x_count < H_TOTAL - 2) &&
                         ((y_count == V_TOTAL - 1) || (y_count < V_ACTIVE - 1));
        video_guard = (x_count >= H_TOTAL - 2) && (x_count < H_TOTAL) &&
                      ((y_count == V_TOTAL - 1) || (y_count < V_ACTIVE - 1));
        data_island_preamble = (x_count >= H_ACTIVE + 4) && (x_count < H_ACTIVE + 12);
        data_island_guard =
            (((x_count >= H_ACTIVE + 12) && (x_count < H_ACTIVE + 14)) ||
             ((x_count >= H_ACTIVE + 14 + 32 * PACKETS_PER_LINE) &&
              (x_count < H_ACTIVE + 16 + 32 * PACKETS_PER_LINE)));
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
    end

    always @* begin
        packet_header = 24'd0;
        packet_sub_flat = 224'd0;
        if (y_count == 0) begin
            packet_header = avi_header;
            packet_sub_flat = avi_sub_flat;
        end else if (y_count == 1) begin
            packet_header = 24'h190183;
            packet_sub_flat = {make_spd_sub(3), make_spd_sub(2),
                               make_spd_sub(1), make_spd_sub(0)};
        end
    end

    packet_assembler_compat packet_ecc (
        .clk_pixel(pixel_clk),
        .reset(reset),
        .data_island_period(data_island_period),
        .header(packet_header),
        .sub_flat(packet_sub_flat),
        .packet_data(packet_data),
        .counter(packet_pixel_counter)
    );

    tmds_channel #(.CN(0)) tmds_blue (
        .clk_pixel(pixel_clk), .video_data(rgb[7:0]),
        .data_island_data(data_island_data[3:0]),
        .control_data(control_data[1:0]), .mode(mode), .tmds(tmds0)
    );
    tmds_channel #(.CN(1)) tmds_green (
        .clk_pixel(pixel_clk), .video_data(rgb[15:8]),
        .data_island_data(data_island_data[7:4]),
        .control_data(control_data[3:2]), .mode(mode), .tmds(tmds1)
    );
    tmds_channel #(.CN(2)) tmds_red (
        .clk_pixel(pixel_clk), .video_data(rgb[23:16]),
        .data_island_data(data_island_data[11:8]),
        .control_data(control_data[5:4]), .mode(mode), .tmds(tmds2)
    );
endmodule
