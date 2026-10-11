`timescale 1ns/1ps
module tb_axis_readonly_audit;
    reg clk = 1'b0;
    reg rst = 1'b1;
    always #20 clk = ~clk;

    wire timing_hs, timing_vs, timing_de;
    wire hs, vs, de;
    wire [23:0] rgb;
    wire read_req;
    wire axis_user, axis_valid, axis_last;
    wire [23:0] axis_data;

    video_timing_data u_timing (
        .video_clk(clk), .rst(rst), .read_req(read_req),
        .read_req_ack(1'b0), .hs(timing_hs), .vs(timing_vs), .de(timing_de)
    );

    video_delay u_delay (
        .video_clk(clk), .rst(rst), .read_en(), .read_data(24'h123456),
        .hs(timing_hs), .vs(timing_vs), .de(timing_de),
        .hs_r(hs), .vs_r(vs), .de_r(de), .vout_data(rgb)
    );

    video_rgb_to_axis_640x480 u_axis (
        .I_clk(clk), .I_rst(rst), .I_vs(vs), .I_de(de), .I_rgb(rgb),
        .O_video_user(axis_user), .O_video_valid(axis_valid),
        .O_video_last(axis_last), .O_video_data(axis_data)
    );

    integer src_len = 0;
    integer valid_len = 0;
    integer src_lines = 0;
    integer valid_lines = 0;
    integer last_count = 0;
    integer last_while_valid = 0;
    integer bad = 0;
    reg de_prev = 1'b0;
    reg valid_prev = 1'b0;

    always @(negedge clk) begin
        if (rst) begin
            src_len = 0;
            valid_len = 0;
            src_lines = 0;
            valid_lines = 0;
            last_count = 0;
            last_while_valid = 0;
            bad = 0;
            de_prev = 1'b0;
            valid_prev = 1'b0;
        end else begin
            if (de)
                src_len = src_len + 1;
            if (!de && de_prev) begin
                src_lines = src_lines + 1;
                if (src_len != 640) begin
                    $display("FAIL source DE line %0d width=%0d", src_lines, src_len);
                    bad = 1;
                end
                src_len = 0;
            end

            if (axis_valid)
                valid_len = valid_len + 1;
            if (axis_last) begin
                last_count = last_count + 1;
                if (axis_valid)
                    last_while_valid = last_while_valid + 1;
            end
            if (!axis_valid && valid_prev) begin
                valid_lines = valid_lines + 1;
                if (valid_len != 640) begin
                    $display("FAIL AXIS valid line %0d width=%0d", valid_lines, valid_len);
                    bad = 1;
                end
                valid_len = 0;
            end

            de_prev = de;
            valid_prev = axis_valid;

            if (src_lines >= 4 && valid_lines >= 4) begin
                if (bad) begin
                    $display("FAIL actual timing-chain width check");
                    $fatal(1);
                end
                if (last_count == 0)
                    $display("PASS audit: 4 source DE lines=640 clocks; 4 AXIS valid lines=640 clocks; TLAST pulses=0 (missing for all observed lines)");
                else
                    $display("PASS audit: 4 source DE lines=640 clocks; 4 AXIS valid lines=640 clocks; TLAST pulses=%0d, TLAST-with-valid=%0d", last_count, last_while_valid);
                $finish;
            end
        end
    end

    initial begin
        repeat (8) @(posedge clk);
        rst = 1'b0;
        #50000000;
        $display("FAIL timeout source_lines=%0d valid_lines=%0d", src_lines, valid_lines);
        $fatal(1);
    end
endmodule