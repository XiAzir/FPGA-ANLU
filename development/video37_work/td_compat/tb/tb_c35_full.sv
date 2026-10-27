`timescale 1ns/1ps
module tb_video_only_tmds_tx;
    localparam integer H_ACTIVE = 640;
    localparam integer H_FRONT = 16;
    localparam integer H_SYNC = 96;
    localparam integer H_BACK = 248;
    localparam integer H_TOTAL = 1000;
    localparam integer V_ACTIVE = 480;
    localparam integer V_FRONT = 10;
    localparam integer V_SYNC = 2;
    localparam integer V_BACK = 58;
    localparam integer V_TOTAL = 550;
    localparam integer FRAME_CYCLES = H_TOTAL * V_TOTAL;
    localparam integer SIM_CYCLES = 32 + FRAME_CYCLES;
    localparam integer C35_H_TOTAL = 640 + 16 + 96 + 248;
    localparam integer C35_V_TOTAL = 480 + 10 + 2 + 58;
    localparam integer C35_H_BLANK = 16 + 96 + 248;

    logic pixel_clk = 1'b0;
    logic reset = 1'b1;
    logic [23:0] rgb;
    logic [15:0] cx, cy;
    logic active;
    logic [9:0] tmds0, tmds1, tmds2, clockword;
    integer frame_starts = 0;
    integer active_pixels = 0;
    integer packet_symbols = 0;
    integer packet_count_per_row = 0;
    integer active_count_per_row = 0;
    integer line_full = 0;
    integer errors = 0;
    integer prior_x = -1;
    integer prior_y = -1;
    integer n, exp_x, exp_y, exp_active, exp_packet;
    integer island_index, sub_index, body_index, checksum_sum;
    logic [23:0] exp_rgb;
    logic [23:0] captured_header;
    logic [55:0] captured_sub [3:0];
    logic [7:0] captured_ecc [4:0];
    logic [9:0] probe;
    logic [3:0] terc;
    logic [3:0] terc_ch1, terc_ch2;
    logic [1:0] ctl;

    always #5 pixel_clk = ~pixel_clk;

    function automatic [23:0] color_at(input integer x);
        integer band;
        begin
            band = (x * 8) / H_ACTIVE;
            case (band)
                0: color_at = 24'hff0000;
                1: color_at = 24'h00ff00;
                2: color_at = 24'h0000ff;
                3: color_at = 24'hffff00;
                4: color_at = 24'hff00ff;
                5: color_at = 24'h00ffff;
                6: color_at = 24'hffffff;
                default: color_at = 24'h000000;
            endcase
        end
    endfunction

    always_comb begin
        rgb = active ? color_at(cx) : 24'd0;
    end

    video_only_tmds_tx #(
        .H_ACTIVE(H_ACTIVE), .H_FRONT(H_FRONT), .H_SYNC(H_SYNC), .H_BACK(H_BACK),
        .V_ACTIVE(V_ACTIVE), .V_FRONT(V_FRONT), .V_SYNC(V_SYNC), .V_BACK(V_BACK),
        .HSYNC_ACTIVE_LOW(1'b1), .VSYNC_ACTIVE_LOW(1'b1)
    ) dut (
        .pixel_clk(pixel_clk), .reset(reset), .rgb(rgb),
        .cx(cx), .cy(cy), .active(active),
        .tmds0(tmds0), .tmds1(tmds1), .tmds2(tmds2), .clockword(clockword)
    );

    function automatic [7:0] decode_video(input logic [9:0] code);
        logic [8:0] qm;
        logic [7:0] value;
        integer b;
        begin
            qm[8] = code[8];
            qm[7:0] = code[7:0] ^ {8{code[9]}};
            value[0] = qm[0];
            for (b = 0; b < 7; b = b + 1)
                value[b+1] = qm[8] ? (qm[b] ^ qm[b+1]) : ~(qm[b] ^ qm[b+1]);
            decode_video = value;
        end
    endfunction

    function automatic is_terc4(input logic [9:0] code);
        begin
            case (code)
                10'b1010011100, 10'b1001100011, 10'b1011100100, 10'b1011100010,
                10'b0101110001, 10'b0100011110, 10'b0110001110, 10'b0100111100,
                10'b1011001100, 10'b0100111001, 10'b0110011100, 10'b1011000110,
                10'b1010001110, 10'b1001110001, 10'b0101100011, 10'b1011000011:
                    is_terc4 = 1'b1;
                default: is_terc4 = 1'b0;
            endcase
        end
    endfunction

    function automatic [3:0] decode_terc4(input logic [9:0] code);
        begin
            case (code)
                10'b1010011100: decode_terc4 = 4'h0;
                10'b1001100011: decode_terc4 = 4'h1;
                10'b1011100100: decode_terc4 = 4'h2;
                10'b1011100010: decode_terc4 = 4'h3;
                10'b0101110001: decode_terc4 = 4'h4;
                10'b0100011110: decode_terc4 = 4'h5;
                10'b0110001110: decode_terc4 = 4'h6;
                10'b0100111100: decode_terc4 = 4'h7;
                10'b1011001100: decode_terc4 = 4'h8;
                10'b0100111001: decode_terc4 = 4'h9;
                10'b0110011100: decode_terc4 = 4'ha;
                10'b1011000110: decode_terc4 = 4'hb;
                10'b1010001110: decode_terc4 = 4'hc;
                10'b1001110001: decode_terc4 = 4'hd;
                10'b0101100011: decode_terc4 = 4'he;
                default: decode_terc4 = 4'hf;
            endcase
        end
    endfunction

    function automatic [1:0] decode_control(input logic [9:0] code);
        begin
            case (code)
                10'b1101010100: decode_control = 2'b00;
                10'b0010101011: decode_control = 2'b01;
                10'b0101010100: decode_control = 2'b10;
                10'b1010101011: decode_control = 2'b11;
                default: decode_control = 2'bxx;
            endcase
        end
    endfunction

    function automatic expected_vsync(input integer x, input integer y);
        begin
            if (y == V_ACTIVE + V_FRONT - 1)
                expected_vsync = (x >= H_ACTIVE + H_FRONT) ? 1'b0 : 1'b1;
            else if (y == V_ACTIVE + V_FRONT + V_SYNC - 1)
                expected_vsync = (x < H_ACTIVE + H_FRONT) ? 1'b0 : 1'b1;
            else
                expected_vsync = (y >= V_ACTIVE + V_FRONT &&
                                  y < V_ACTIVE + V_FRONT + V_SYNC) ? 1'b0 : 1'b1;
        end
    endfunction

    function automatic [1:0] expected_sync(input integer x, input integer y);
        logic expected_hsync_level;
        begin
            expected_hsync_level = (x >= H_ACTIVE + H_FRONT &&
                                    x < H_ACTIVE + H_FRONT + H_SYNC) ? 1'b0 : 1'b1;
            expected_sync = {expected_vsync(x, y), expected_hsync_level};
        end
    endfunction

    function automatic [9:0] expected_di_guard0(input [1:0] sync_bits);
        begin
            case (sync_bits)
                2'b00: expected_di_guard0 = 10'b1010001110;
                2'b01: expected_di_guard0 = 10'b1001110001;
                2'b10: expected_di_guard0 = 10'b0101100011;
                default: expected_di_guard0 = 10'b1011000011;
            endcase
        end
    endfunction

    function automatic [7:0] next_ecc(input logic [7:0] ecc, input logic bit_in);
        next_ecc = (ecc >> 1) ^ ((ecc[0] ^ bit_in) ? 8'b10000011 : 8'd0);
    endfunction

    function automatic [7:0] ecc_header(input logic [23:0] data);
        logic [7:0] ecc;
        integer b;
        begin
            ecc = 8'd0;
            for (b = 0; b < 24; b = b + 1)
                ecc = next_ecc(ecc, data[b]);
            ecc_header = ecc;
        end
    endfunction

    function automatic [7:0] ecc_sub(input logic [55:0] data);
        logic [7:0] ecc;
        integer b;
        begin
            ecc = 8'd0;
            for (b = 0; b < 56; b = b + 1)
                ecc = next_ecc(ecc, data[b]);
            ecc_sub = ecc;
        end
    endfunction

    function automatic [7:0] get_body_byte(input integer index);
        integer word_index;
        integer byte_offset;
        begin
            word_index = index / 7;
            byte_offset = (index % 7) * 8;
            get_body_byte = captured_sub[word_index][byte_offset +: 8];
        end
    endfunction

    task automatic fail(input string message);
        begin
            errors = errors + 1;
            if (errors < 20)
                $display("FAIL: %s at y=%0d x=%0d", message, exp_y, exp_x);
        end
    endtask

    initial begin
        probe = 10'b1010011101;
        if (is_terc4(10'b1010011100) !== 1'b1 || is_terc4(probe) !== 1'b0)
            $fatal(1, "single-bit negative control did not distinguish a TERC4 symbol");
        if (dut.PACKETS_PER_LINE != 1)
            $fatal(1, "80-clock horizontal blank did not select one packet");
        if (C35_H_TOTAL != 1000 || C35_V_TOTAL != 550 || C35_H_BLANK != 360 ||
            ((C35_H_BLANK - 30) / 32) < 1)
            $fatal(1, "C35 360-clock blank check failed");
        if (1920 + 8 + 8 + 64 != 2000 || 1080 + 4 + 5 + 11 != 1100)
            $fatal(1, "C36 timing constant check failed");

        repeat (4) @(posedge pixel_clk);
        @(negedge pixel_clk);
        reset = 1'b0;

        for (n = 0; n < SIM_CYCLES; n = n + 1) begin
            if (n != 0)
                @(negedge pixel_clk);
            exp_x = cx;
            exp_y = cy;
            exp_active = active;
            exp_rgb = rgb;
            exp_packet = (exp_x >= H_ACTIVE + 14) && (exp_x < H_ACTIVE + 46);
            if (exp_x == 0 && exp_y == 0)
                frame_starts = frame_starts + 1;
            if (prior_x >= 0) begin
                if (exp_x == 0) begin
                    if (prior_x != H_TOTAL - 1 || exp_y != ((prior_y + 1) % V_TOTAL))
                        fail("horizontal/vertical counter wrap");
                end else if (exp_x != prior_x + 1 || exp_y != prior_y) begin
                    fail("pixel coordinate increment");
                end
            end
            prior_x = exp_x;
            prior_y = exp_y;
            if (exp_x == 0) begin
                active_count_per_row = 0;
                line_full = 1;
            end
            if (exp_active)
                active_count_per_row = active_count_per_row + 1;
            if (exp_packet)
                packet_count_per_row = packet_count_per_row + 1;

            @(posedge pixel_clk);
            #1;
            if (clockword !== 10'b0000011111)
                fail("parallel TMDS clock word");
            if (exp_active) begin
                if ({decode_video(tmds2), decode_video(tmds1), decode_video(tmds0)} !== exp_rgb)
                    fail("RGB888 active pixel decode");
                active_pixels = active_pixels + 1;
            end
            if (exp_packet) begin
                if (!is_terc4(tmds0) || !is_terc4(tmds1) || !is_terc4(tmds2))
                    fail("data-island payload symbol class");
                terc = decode_terc4(tmds0);
                terc_ch1 = decode_terc4(tmds1);
                terc_ch2 = decode_terc4(tmds2);
                island_index = exp_x - (H_ACTIVE + 14);
                if (island_index == 0) begin
                    captured_header = 24'd0;
                    for (sub_index = 0; sub_index < 4; sub_index = sub_index + 1)
                        captured_sub[sub_index] = 56'd0;
                    for (sub_index = 0; sub_index < 5; sub_index = sub_index + 1)
                        captured_ecc[sub_index] = 8'd0;
                end
                if (island_index < 24)
                    captured_header[island_index] = terc[2];
                else
                    captured_ecc[4][island_index-24] = terc[2];
                if (island_index < 28) begin
                    for (sub_index = 0; sub_index < 4; sub_index = sub_index + 1) begin
                        captured_sub[sub_index][2*island_index] = terc_ch1[sub_index];
                        captured_sub[sub_index][2*island_index+1] = terc_ch2[sub_index];
                    end
                end else begin
                    for (sub_index = 0; sub_index < 4; sub_index = sub_index + 1) begin
                        captured_ecc[sub_index][2*(island_index-28)] = terc_ch1[sub_index];
                        captured_ecc[sub_index][2*(island_index-28)+1] = terc_ch2[sub_index];
                    end
                end
                if (island_index == 31) begin
                    if (exp_y == 0 && captured_header !== 24'h0d0282)
                        fail("AVI packet header type/version/length");
                    else if (exp_y == 1 && captured_header !== 24'h190183)
                        fail("SPD packet header type/version/length");
                    else if (exp_y >= 2 && captured_header !== 24'h000000)
                        fail("NULL packet header");
                    if (captured_ecc[4] !== ecc_header(captured_header))
                        fail("packet header BCH ECC");
                    for (sub_index = 0; sub_index < 4; sub_index = sub_index + 1)
                        if (captured_ecc[sub_index] !== ecc_sub(captured_sub[sub_index]))
                            fail("packet subpacket BCH ECC");
                    checksum_sum = captured_header[23:16] + captured_header[15:8] + captured_header[7:0];
                    for (body_index = 0; body_index < 28; body_index = body_index + 1)
                        checksum_sum = checksum_sum + get_body_byte(body_index);
                    if ((checksum_sum & 8'hff) != 0)
                        fail("InfoFrame checksum or NULL body");
                    if (exp_y == 0 && get_body_byte(4) !== 8'h00)
                        fail("AVI VIC0 payload");
                    if (exp_y == 1) begin
                        if (get_body_byte(1) !== "F" || get_body_byte(2) !== "P" ||
                            get_body_byte(3) !== "G" || get_body_byte(4) !== "A" ||
                            get_body_byte(5) !== "A" || get_body_byte(6) !== "N" ||
                            get_body_byte(7) !== "L" || get_body_byte(8) !== "U" ||
                            get_body_byte(25) !== 8'd0)
                            fail("SPD vendor and source-device payload");
                    end
                end
                if (terc[1:0] !== {expected_vsync(exp_x, exp_y),
                                  ((exp_x >= H_ACTIVE + H_FRONT) && (exp_x < H_ACTIVE + H_FRONT + H_SYNC)) ? 1'b0 : 1'b1})
                    fail("H/V sync bits embedded in TERC4 payload");
                packet_symbols = packet_symbols + 1;
            end else if (exp_x >= H_ACTIVE + 12 && exp_x < H_ACTIVE + 14) begin
                if (tmds1 !== 10'b0100110011 || tmds2 !== 10'b0100110011)
                    fail("data-island leading guard-band");
                if (tmds0 !== expected_di_guard0(expected_sync(exp_x, exp_y)))
                    fail("H/V sync state in TERC4 leading guard");
            end else if (exp_x >= H_ACTIVE + 46 && exp_x < H_ACTIVE + 48) begin
                if (tmds1 !== 10'b0100110011 || tmds2 !== 10'b0100110011)
                    fail("data-island trailing guard-band");
                if (tmds0 !== expected_di_guard0(expected_sync(exp_x, exp_y)))
                    fail("H/V sync state in TERC4 trailing guard");
            end else if (exp_x >= H_ACTIVE + 4 && exp_x < H_ACTIVE + 12) begin
                if (tmds1 !== 10'b0010101011 || tmds2 !== 10'b0010101011)
                    fail("data-island 8-symbol preamble");
                ctl = decode_control(tmds0);
                if (ctl !== expected_sync(exp_x, exp_y))
                    fail("H/V sync bits in island control preamble");
            end else if (exp_x >= H_TOTAL - 10 && exp_x < H_TOTAL - 2 &&
                         (exp_y < V_ACTIVE - 1 || exp_y == V_TOTAL - 1)) begin
                if (tmds1 !== 10'b0010101011 || tmds2 !== 10'b1101010100)
                    fail("video 8-symbol preamble");
            end else if (exp_x >= H_TOTAL - 2 &&
                         (exp_y < V_ACTIVE - 1 || exp_y == V_TOTAL - 1)) begin
                if (tmds0 !== 10'b1011001100 || tmds1 !== 10'b0100110011 ||
                    tmds2 !== 10'b1011001100)
                    fail("video guard-band before the first pixel");
            end

            if ((exp_x >= H_ACTIVE + 4 && exp_x < H_ACTIVE + 12) ||
                (exp_x >= H_ACTIVE + 14 && exp_x < H_ACTIVE + 46)) begin
                if (!is_terc4(tmds0) && exp_x >= H_ACTIVE + 14)
                    fail("channel 0 TERC4 packet run");
            end else if (exp_x < H_ACTIVE + 4 || exp_x >= H_ACTIVE + 48) begin
                ctl = decode_control(tmds0);
                if (ctl !== 2'bxx) begin
                    if (ctl !== expected_sync(exp_x, exp_y))
                        fail("H/V sync bits embedded in control symbol");
                end
            end

            if (exp_x == H_TOTAL - 1 && line_full) begin
                if ((exp_y < V_ACTIVE && active_count_per_row != H_ACTIVE) ||
                    (exp_y >= V_ACTIVE && active_count_per_row != 0))
                    fail("active symbol count per row");
                if (packet_count_per_row != 32)
                    fail("packet symbols are not one complete 32-symbol packet per row");
                packet_count_per_row = 0;
            end
        end

        if (frame_starts != 1)
            fail("one full C35 frame start was not observed");
        if (active_pixels != H_ACTIVE * V_ACTIVE)
            fail("active RGB pixel total over two frames");
        if (packet_symbols != V_TOTAL * 32)
            fail("32 payload symbols per line over two frames");
        if (errors != 0)
            $fatal(1, "FAILED with %0d errors", errors);
        $display("PASS: C35 full frame after startup VP/GB, %0d RGB pixels, %0d packet payload symbols, Hblank=360, P_line=1", active_pixels, packet_symbols);
        $finish;
    end

endmodule
