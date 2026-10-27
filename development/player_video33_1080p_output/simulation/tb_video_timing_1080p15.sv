`timescale 1ns/1ps
module tb_video_timing_1080p15;
    localparam integer H_TOTAL = 2000;
    localparam integer V_TOTAL = 1100;
    localparam integer FRAME_CYCLES = H_TOTAL * V_TOTAL;
    localparam integer ACTIVE_CYCLES = 1920 * 1080;

    reg pixel_clk = 1'b0;
    reg reset = 1'b1;
    wire hsync, vsync, de;
    wire [23:0] rgb;
    wire [11:0] x;
    wire [10:0] y;
    wire axis_user, axis_valid, axis_last;
    wire [23:0] axis_data;

    always #15.151515 pixel_clk = ~pixel_clk;

    video_timing_1080p_custom_colorbar #(
        .H_ACTIVE(1920), .H_FRONT(8), .H_SYNC(8), .H_BACK(64), .H_TOTAL(H_TOTAL),
        .V_ACTIVE(1080), .V_FRONT(4), .V_SYNC(5), .V_BACK(11), .V_TOTAL(V_TOTAL)
    ) dut (
        .pixel_clk(pixel_clk), .reset(reset), .hsync(hsync), .vsync(vsync),
        .de(de), .rgb(rgb), .x(x), .y(y)
    );

    video_axis_1080p_adapter adapter (
        .pixel_clk(pixel_clk), .reset(reset), .de(de), .x(x), .y(y), .rgb(rgb),
        .axis_user(axis_user), .axis_valid(axis_valid), .axis_last(axis_last), .axis_data(axis_data)
    );

    integer started = 0;
    integer frame_cycles = 0;
    integer active_cycles = 0;
    integer blank_cycles = 0;
    integer hsync_rises = 0;
    integer hsync_high_cycles = 0;
    integer vsync_high_cycles = 0;
    integer sof_count = 0;
    integer eol_count = 0;
    integer frame_count = 0;
    reg prev_hsync = 0;
    reg prev_vsync = 0;
    reg prev_de = 0;
    reg [11:0] prev_x = 0;
    reg [10:0] prev_y = 0;
    reg [7:0] bar_mask = 0;
    integer expected_x;
    integer expected_y;

    initial begin
        repeat (4) @(posedge pixel_clk);
        #1 reset = 1'b0;
    end

    always @(posedge pixel_clk) begin
        #1;
        if (reset) begin
            prev_hsync = hsync;
            prev_vsync = vsync;
            prev_de = de;
            prev_x = x;
            prev_y = y;
        end else begin
            if (de !== ((x < 1920) && (y < 1080)))
                $fatal(1, "DE/coordinate mismatch x=%0d y=%0d de=%b", x, y, de);
            if (axis_valid !== prev_de)
                $fatal(1, "AXIS valid mismatch x=%0d y=%0d", x, y);
            if (started) begin
                if (prev_x == H_TOTAL - 1) begin
                    expected_x = 0;
                    expected_y = (prev_y == V_TOTAL - 1) ? 0 : prev_y + 1;
                end else begin
                    expected_x = prev_x + 1;
                    expected_y = prev_y;
                end
                if ((x != expected_x) || (y != expected_y))
                    $fatal(1, "Raster counter discontinuity previous=(%0d,%0d) current=(%0d,%0d)", prev_x, prev_y, x, y);
            end

            if (vsync && !prev_vsync) begin
                if (started) begin
                    if (frame_cycles != FRAME_CYCLES - 1)
                        $fatal(1, "frame cycles %0d expected %0d", frame_cycles, FRAME_CYCLES - 1);
                    if (active_cycles != ACTIVE_CYCLES)
                        $fatal(1, "active cycles %0d expected %0d", active_cycles, ACTIVE_CYCLES);
                    if (blank_cycles != FRAME_CYCLES - 1 - ACTIVE_CYCLES)
                        $fatal(1, "blank cycles %0d expected %0d", blank_cycles, FRAME_CYCLES - 1 - ACTIVE_CYCLES);
                    if (hsync_rises != V_TOTAL)
                        $fatal(1, "H sync pulses %0d expected %0d", hsync_rises, V_TOTAL);
                    if (hsync_high_cycles != V_TOTAL * 8)
                        $fatal(1, "H sync high cycles %0d expected %0d", hsync_high_cycles, V_TOTAL * 8);
                    if (vsync_high_cycles != 5 * H_TOTAL - 1)
                        $fatal(1, "V sync high cycles %0d expected %0d", vsync_high_cycles, 5 * H_TOTAL - 1);
                    if (sof_count != 1 || eol_count != 1080)
                        $fatal(1, "AXIS frame markers SOF=%0d EOL=%0d expected 1/1080", sof_count, eol_count);
                    if (bar_mask != 8'hFF)
                        $fatal(1, "color bar coverage mask=%02x expected FF", bar_mask);
                    $display("PASS: 1080p15 frame=%0d cycles active=%0d blank=%0d Hsync=%0d?8 Vsync=%0d?%0d SOF=%0d EOL=%0d bars=%02x",
                        frame_cycles + 1, active_cycles, blank_cycles + 1,
                        hsync_rises, H_TOTAL, 5, sof_count, eol_count, bar_mask);
                    $finish;
                end
                started = 1;
                frame_cycles = 0;
                active_cycles = 0;
                blank_cycles = 0;
                hsync_rises = 0;
                hsync_high_cycles = 0;
                vsync_high_cycles = 0;
                sof_count = 0;
                eol_count = 0;
                bar_mask = 0;
            end else if (started) begin
                frame_cycles = frame_cycles + 1;
                if (de) begin
                    active_cycles = active_cycles + 1;
                    if (axis_data == 24'hFFFFFF) bar_mask[0] = 1'b1;
                    if (axis_data == 24'hFFFF00) bar_mask[1] = 1'b1;
                    if (axis_data == 24'h00FFFF) bar_mask[2] = 1'b1;
                    if (axis_data == 24'h00FF00) bar_mask[3] = 1'b1;
                    if (axis_data == 24'hFF00FF) bar_mask[4] = 1'b1;
                    if (axis_data == 24'hFF0000) bar_mask[5] = 1'b1;
                    if (axis_data == 24'h0000FF) bar_mask[6] = 1'b1;
                    if (axis_data == 24'h000000) bar_mask[7] = 1'b1;
                end else begin
                    blank_cycles = blank_cycles + 1;
                end
                if (hsync) hsync_high_cycles = hsync_high_cycles + 1;
                if (hsync && !prev_hsync) hsync_rises = hsync_rises + 1;
                if (vsync) vsync_high_cycles = vsync_high_cycles + 1;
                if (axis_user) sof_count = sof_count + 1;
                if (axis_last) eol_count = eol_count + 1;
            end

            prev_hsync = hsync;
            prev_vsync = vsync;
            prev_de = de;
            prev_x = x;
            prev_y = y;
        end
    end

    initial begin
        #200000000;
        $fatal(1, "timeout waiting for two VSYNC rising edges");
    end
endmodule
