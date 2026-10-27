`timescale 1ns/1ps
module tb_vsync_contract #(
    parameter integer H_ACTIVE = 1920,
    parameter integer H_FRONT  = 8,
    parameter integer H_SYNC   = 8,
    parameter integer H_BACK   = 64,
    parameter integer V_ACTIVE = 1080,
    parameter integer V_FRONT  = 4,
    parameter integer V_SYNC   = 5,
    parameter integer V_BACK   = 11
);
    localparam integer H_TOTAL = H_ACTIVE + H_FRONT + H_SYNC + H_BACK;
    localparam integer V_TOTAL = V_ACTIVE + V_FRONT + V_SYNC + V_BACK;
    localparam integer FRAME_CYCLES = H_TOTAL * V_TOTAL;
    localparam integer VS_START = ((V_ACTIVE - 1) * H_TOTAL + H_ACTIVE + H_FRONT
                                  + V_FRONT * H_TOTAL) % FRAME_CYCLES;
    localparam integer VS_END = (VS_START + V_SYNC * H_TOTAL) % FRAME_CYCLES;

    logic pixel_clk = 1'b0;
    logic reset = 1'b1;
    logic [23:0] rgb;
    logic [15:0] cx, cy;
    logic active;
    logic [9:0] tmds0, tmds1, tmds2, clockword;
    integer n, x, y, fpos, delta, errors = 0;
    integer hfall_samples = 0, hrise_samples = 0;
    integer vfalls = 0, vrises = 0;
    integer last_vfall = -1, last_vrise = -1;
    integer last_hfall = -1, last_hrise = -1;
    integer prev_v = -1, have_prev_v = 0;
    logic [1:0] observed_sync;
    logic [3:0] terc_value;
    logic [23:0] rgb_expected;
    logic active_expected;
    logic sync_known;
    logic is_di_preamble, is_di_guard, is_di_payload, is_video_guard;

    always #5 pixel_clk = ~pixel_clk;
    always_comb rgb = {cx[7:0], cy[7:0], (cx[7:0] ^ cy[7:0])};

    video_only_tmds_tx #(
        .H_ACTIVE(H_ACTIVE), .H_FRONT(H_FRONT), .H_SYNC(H_SYNC), .H_BACK(H_BACK),
        .V_ACTIVE(V_ACTIVE), .V_FRONT(V_FRONT), .V_SYNC(V_SYNC), .V_BACK(V_BACK),
        .HSYNC_ACTIVE_LOW(1'b1), .VSYNC_ACTIVE_LOW(1'b1)
    ) dut (
        .pixel_clk(pixel_clk), .reset(reset), .rgb(rgb),
        .cx(cx), .cy(cy), .active(active),
        .tmds0(tmds0), .tmds1(tmds1), .tmds2(tmds2), .clockword(clockword)
    );

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
                10'b1011000011: decode_terc4 = 4'hf;
                default: decode_terc4 = 4'hx;
            endcase
        end
    endfunction

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

    task automatic fail(input string message);
        begin
            errors = errors + 1;
            if (errors <= 12)
                $display("FAIL %s mode=%0d x=%0d y=%0d fpos=%0d", message,
                         dut.mode, x, y, fpos);
        end
    endtask

    initial begin
        repeat (4) @(posedge pixel_clk);
        @(negedge pixel_clk);
        reset = 1'b0;

        while (cx != 0 || cy != 0)
            @(negedge pixel_clk);

        for (n = 0; n < FRAME_CYCLES; n = n + 1) begin
            x = cx;
            y = cy;
            fpos = y * H_TOTAL + x;
            delta = (fpos - VS_START + FRAME_CYCLES) % FRAME_CYCLES;
            rgb_expected = rgb;
            active_expected = (x < H_ACTIVE && y < V_ACTIVE);
            @(posedge pixel_clk);
            #1;

            if (clockword !== 10'b0000011111)
                fail("clock word");

            is_di_preamble = (x >= H_ACTIVE + 4 && x < H_ACTIVE + 12);
            is_di_guard = ((x >= H_ACTIVE + 12 && x < H_ACTIVE + 14) ||
                           (x >= H_ACTIVE + 46 && x < H_ACTIVE + 48));
            is_di_payload = (x >= H_ACTIVE + 14 && x < H_ACTIVE + 46);
            is_video_guard = (x >= H_TOTAL - 2) &&
                             (y < V_ACTIVE - 1 || y == V_TOTAL - 1);
            sync_known = 1'b0;
            observed_sync = 2'bxx;

            if (is_di_payload || is_di_guard) begin
                terc_value = decode_terc4(tmds0);
                if ((^terc_value) === 1'bx)
                    fail("channel 0 TERC4 sync symbol class");
                else begin
                    if (is_di_guard && terc_value[3:2] !== 2'b11)
                        fail("channel 0 data guard symbol class");
                    observed_sync = terc_value[1:0];
                    sync_known = 1'b1;
                end
            end else if (!active_expected && !is_video_guard) begin
                observed_sync = decode_control(tmds0);
                if ((^observed_sync) === 1'bx)
                    fail("channel 0 control symbol class");
                else
                    sync_known = 1'b1;
            end

            if (sync_known) begin
                if (observed_sync[1] !== (delta < V_SYNC * H_TOTAL ? 1'b0 : 1'b1))
                    fail("VSYNC differs from independent frame-modulo contract");
                if (observed_sync[0] !== ((x >= H_ACTIVE + H_FRONT &&
                                           x < H_ACTIVE + H_FRONT + H_SYNC) ? 1'b0 : 1'b1))
                    fail("HSYNC differs from independent horizontal contract");

                if (have_prev_v) begin
                    if (prev_v == 1 && observed_sync[1] == 0) begin
                        vfalls = vfalls + 1;
                        last_vfall = fpos;
                    end
                    if (prev_v == 0 && observed_sync[1] == 1) begin
                        vrises = vrises + 1;
                        last_vrise = fpos;
                    end
                end
                prev_v = observed_sync[1];
                have_prev_v = 1;
            end

            if (x == H_ACTIVE + H_FRONT) begin
                hfall_samples = hfall_samples + 1;
                if (observed_sync[0] !== 1'b0)
                    fail("HSYNC falling-edge sample is not low");
                if (last_hfall >= 0 && fpos - last_hfall != H_TOTAL)
                    fail("HSYNC falling-edge period");
                last_hfall = fpos;
            end
            if (x == H_ACTIVE + H_FRONT + H_SYNC) begin
                hrise_samples = hrise_samples + 1;
                if (observed_sync[0] !== 1'b1)
                    fail("HSYNC rising-edge sample is not high");
                if (fpos - last_hfall != H_SYNC)
                    fail("HSYNC pulse width");
                last_hrise = fpos;
            end

            if (fpos == VS_START && observed_sync[1] !== 1'b0)
                fail("VSYNC falling edge at contracted coordinate");
            if (fpos == VS_END && observed_sync[1] !== 1'b1)
                fail("VSYNC rising edge at contracted coordinate");

            if (y == 0 && (x == 0 || x == H_ACTIVE - 1)) begin
                if ({decode_video(tmds2), decode_video(tmds1), decode_video(tmds0)} !== rgb_expected)
                    fail("first active row RGB boundary alignment");
            end
        end

        if (cx != 0 || cy != 0)
            fail("next frame start coordinate / frame period");
        if (hfall_samples != V_TOTAL || hrise_samples != V_TOTAL)
            fail("one HSYNC pulse per line");
        if (vfalls != 1 || vrises != 1)
            fail("one VSYNC falling and rising edge per frame");
        if (last_vfall != VS_START || last_vrise != VS_END)
            fail("decoded VSYNC edge coordinates");
        if ((last_vrise - last_vfall + FRAME_CYCLES) % FRAME_CYCLES != V_SYNC * H_TOTAL)
            fail("decoded VSYNC pulse width");
        if (FRAME_CYCLES != H_TOTAL * V_TOTAL)
            fail("frame period arithmetic");

        if (errors != 0)
            $fatal(1, "FAIL with %0d errors", errors);
        $display("PASS: H=%0d/%0d V=%0d/%0d F=%0d; VS fall=%0d rise=%0d width=%0d; H fall/rise=%0d/%0d; next-frame=%0d",
                 H_ACTIVE, H_TOTAL, V_ACTIVE, V_TOTAL, FRAME_CYCLES,
                 last_vfall, last_vrise, V_SYNC*H_TOTAL,
                 hfall_samples, hrise_samples, FRAME_CYCLES);
        $finish;
    end
endmodule
