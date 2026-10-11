`timescale 1ns/1ps

module tb_player_osd;
    reg clk = 1'b0;
    reg rst = 1'b1;
    reg vs = 1'b0;
    reg de = 1'b0;
    reg [23:0] rgb_in = 24'h000000;
    reg [1:0] image_index = 2'd3;
    reg [2:0] image_count = 3'd0;
    reg auto_mode = 1'b1;
    reg image_valid = 1'b0;
    wire [23:0] rgb_out;

    player_osd dut (
        .clk(clk), .rst(rst), .vs(vs), .de(de), .rgb_in(rgb_in),
        .image_index(image_index), .image_count(image_count),
        .auto_mode(auto_mode), .image_valid(image_valid), .rgb_out(rgb_out)
    );

    always #5 clk = ~clk;

    reg [7:0] chars [0:13];
    integer scenario = 0;
    integer frame_number = 0;
    integer checks = 0;
    integer active_checks = 0;
    integer overlay_checks = 0;
    integer x_pos = 0;
    integer y_pos = 0;
    integer previous_de = 0;
    integer sync_pending = 0;
    reg previous_vs = 1'b0;
    integer preview_fd = 0;
    integer preview_started = 0;

    function automatic [23:0] source_pixel(input integer x, input integer y, input integer salt);
        begin
            source_pixel[23:16] = (x * 3 + y + salt * 29) & 8'hff;
            source_pixel[15:8]  = (x + y * 5 + salt * 47) & 8'hff;
            source_pixel[7:0]   = (x * 7 + y * 11 + salt * 13) & 8'hff;
        end
    endfunction

    // Independent bitmap oracle: one 5-bit row per glyph row, bit 4 is the left edge.
    function automatic [4:0] glyph_row(input [7:0] glyph, input integer row);
        begin
            glyph_row = 5'b00000;
            case (glyph)
                "I": case (row)
                    0,6: glyph_row=5'b11111; 1,2,3,4,5: glyph_row=5'b00100;
                endcase
                "M": case (row)
                    0: glyph_row=5'b10001; 1: glyph_row=5'b11011; 2: glyph_row=5'b10101;
                    3: glyph_row=5'b10101; 4: glyph_row=5'b10001; 5: glyph_row=5'b10001;
                    6: glyph_row=5'b10001;
                endcase
                "G": case (row)
                    0: glyph_row=5'b01110; 1: glyph_row=5'b10001; 2: glyph_row=5'b10000;
                    3: glyph_row=5'b10111; 4: glyph_row=5'b10001; 5: glyph_row=5'b10001;
                    6: glyph_row=5'b01110;
                endcase
                "1": case (row)
                    0: glyph_row=5'b00100; 1: glyph_row=5'b01100; 2,3,4,5: glyph_row=5'b00100;
                    6: glyph_row=5'b01110;
                endcase
                "2": case (row)
                    0: glyph_row=5'b01110; 1: glyph_row=5'b10001; 2: glyph_row=5'b00001;
                    3: glyph_row=5'b00010; 4: glyph_row=5'b00100; 5: glyph_row=5'b01000;
                    6: glyph_row=5'b11111;
                endcase
                "3": case (row)
                    0: glyph_row=5'b11110; 1,2: glyph_row=5'b00001; 3: glyph_row=5'b01110;
                    4,5: glyph_row=5'b00001; 6: glyph_row=5'b11110;
                endcase
                "/": case (row)
                    0: glyph_row=5'b00001; 1: glyph_row=5'b00010; 2: glyph_row=5'b00100;
                    3: glyph_row=5'b01000; 4: glyph_row=5'b10000;
                endcase
                "4": case (row)
                    0,1,2: glyph_row=5'b10010; 3: glyph_row=5'b11111; 4,5,6: glyph_row=5'b00010;
                endcase
                "0": case (row)
                    0,6: glyph_row=5'b01110; 1: glyph_row=5'b10001; 2: glyph_row=5'b10011;
                    3: glyph_row=5'b10101; 4: glyph_row=5'b11001; 5: glyph_row=5'b10001;
                endcase
                "N": case (row)
                    0: glyph_row=5'b10001; 1: glyph_row=5'b11001; 2: glyph_row=5'b10101;
                    3: glyph_row=5'b10011; 4: glyph_row=5'b10001; 5: glyph_row=5'b10001;
                    6: glyph_row=5'b10001;
                endcase
                "L": case (row)
                    0,1,2,3,4,5: glyph_row=5'b10000; 6: glyph_row=5'b11111;
                endcase
                "A": case (row)
                    0: glyph_row=5'b01110; 1,2: glyph_row=5'b10001; 3: glyph_row=5'b11111;
                    4,5,6: glyph_row=5'b10001;
                endcase
                "U": case (row)
                    0,1,2,3,4,5: glyph_row=5'b10001; 6: glyph_row=5'b01110;
                endcase
                "T": case (row)
                    0: glyph_row=5'b11111; 1,2,3,4,5,6: glyph_row=5'b00100;
                endcase
                "O": case (row)
                    0,6: glyph_row=5'b01110; 1,2,3,4,5: glyph_row=5'b10001;
                endcase
                default: glyph_row=5'b00000;
            endcase
        end
    endfunction

    function automatic [23:0] expected_pixel(input integer px, input integer py, input [23:0] passthrough);
        integer cell_index;
        integer local_x;
        integer local_y;
        integer glyph_col;
        integer glyph_row_index;
        reg [4:0] bits;
        begin
            expected_pixel = passthrough;
            if (de && px >= 16 && px <= 255 && py >= 16 && py <= 47) begin
                expected_pixel = 24'h000000;
                if (px >= 24 && px < 248 && py >= 24 && py < 40) begin
                    cell_index = (px - 24) / 16;
                    local_x = (px - 24) % 16;
                    local_y = (py - 24) % 16;
                    glyph_col = local_x / 2;
                    glyph_row_index = local_y / 2;
                    bits = glyph_row(chars[cell_index], glyph_row_index);
                    if (glyph_col < 5 && glyph_row_index < 7 && bits[4-glyph_col])
                        expected_pixel = 24'hffffff;
                end
            end
        end
    endfunction

    task automatic prepare_scenario(input integer which);
        integer current_number;
        integer total_number;
        integer p;
        reg [7:0] mode_chars [0:5];
        begin
            scenario = which;
            case (which)
                0: begin image_index=0; image_count=4; image_valid=1; auto_mode=0; end
                1: begin image_index=3; image_count=4; image_valid=1; auto_mode=1; end
                2: begin image_index=1; image_count=2; image_valid=1; auto_mode=0; end
                3: begin image_index=2; image_count=3; image_valid=1; auto_mode=1; end
                4: begin image_index=0; image_count=0; image_valid=1; auto_mode=0; end
                default: begin image_index=3; image_count=4; image_valid=0; auto_mode=0; end
            endcase
            current_number = (!image_valid || image_count == 0) ? 0 : image_index + 1;
            total_number = (image_count >= 1 && image_count <= 4) ? image_count : 0;
            chars[0]="I"; chars[1]="M"; chars[2]="G"; chars[3]=" ";
            chars[4]="0" + current_number; chars[5]="/"; chars[6]="0" + total_number;
            chars[7]=" ";
            if (auto_mode) begin
                mode_chars[0]="A"; mode_chars[1]="U"; mode_chars[2]="T"; mode_chars[3]="O";
                mode_chars[4]=" "; mode_chars[5]=" ";
            end else begin
                mode_chars[0]="M"; mode_chars[1]="A"; mode_chars[2]="N";
                mode_chars[3]="U"; mode_chars[4]="A"; mode_chars[5]="L";
            end
            for (p=0; p<6; p=p+1) chars[8+p] = mode_chars[p];
        end
    endtask

    // Score after NBA updates so the check sees the upstream registered pixel for this cycle.
    always @(posedge clk) begin
        #1;
        if (rst) begin
            previous_de = 0;
            previous_vs = vs;
            sync_pending = 0;
            x_pos = 0;
            y_pos = 0;
        end else begin
            if (vs !== previous_vs) begin
                sync_pending = 1;
                x_pos = 0;
                y_pos = 0;
            end
            if (de) begin
                if (!previous_de) begin
                    x_pos = 0;
                    if (sync_pending) begin
                        y_pos = 0;
                        sync_pending = 0;
                    end else begin
                        y_pos = y_pos + 1;
                    end
                end
                if (x_pos < 0 || x_pos >= 640 || y_pos < 0 || y_pos >= 480)
                    $fatal(1, "Raster model out of range at scenario=%0d x=%0d y=%0d", scenario, x_pos, y_pos);
                if (rgb_out !== expected_pixel(x_pos, y_pos, rgb_in)) begin
                    $display("FAIL scenario=%0d frame=%0d xy=(%0d,%0d) de=%b char=%c in=%06h expected=%06h actual=%06h",
                        scenario, frame_number, x_pos, y_pos, de, chars[(x_pos >= 24 && x_pos < 248) ? (x_pos-24)/16 : 0], rgb_in,
                        expected_pixel(x_pos, y_pos, rgb_in), rgb_out);
                    $fatal(1, "player_osd pixel mismatch");
                end
                active_checks = active_checks + 1;
                if (x_pos >= 16 && x_pos <= 255 && y_pos >= 16 && y_pos <= 47)
                    overlay_checks = overlay_checks + 1;
                if (preview_fd != 0 && frame_number == 0 && x_pos < 640 && y_pos < 480)
                    $fwrite(preview_fd, "%c%c%c", rgb_out[23:16], rgb_out[15:8], rgb_out[7:0]);
                x_pos = x_pos + 1;
            end else begin
                if (rgb_out !== rgb_in) begin
                    $display("FAIL blank/pass-through scenario=%0d frame=%0d in=%06h actual=%06h", scenario, frame_number, rgb_in, rgb_out);
                    $fatal(1, "RGB must pass through when de=0");
                end
            end
            checks = checks + 1;
            previous_de = de;
            previous_vs = vs;
        end
    end

    task automatic send_frame(input integer frame_id, input integer scenario_id);
        integer yy;
        integer xx;
        integer salt;
        begin
            frame_number = frame_id;
            prepare_scenario(scenario_id);
            salt = frame_id + 3;
            @(posedge clk); vs <= ~vs; de <= 1'b0; rgb_in <= source_pixel(0,0,salt);
            repeat (4) begin @(posedge clk); de <= 1'b0; rgb_in <= source_pixel(0,0,salt+1); end
            for (yy=0; yy<480; yy=yy+1) begin
                for (xx=0; xx<640; xx=xx+1) begin
                    @(posedge clk);
                    de <= 1'b1;
                    rgb_in <= source_pixel(xx, yy, salt);
                end
                @(posedge clk); de <= 1'b0; rgb_in <= source_pixel(yy, xx, salt+1);
                repeat (2) begin @(posedge clk); de <= 1'b0; rgb_in <= source_pixel(yy+1, 0, salt+2); end
            end
            repeat (4) begin @(posedge clk); de <= 1'b0; rgb_in <= source_pixel(1,1,salt+2); end
        end
    endtask

    initial begin
        preview_fd = $fopen("development/player_osd/build/osd_sim/osd_preview.ppm", "wb");
        if (preview_fd == 0) $fatal(1, "Cannot create build/osd_sim/osd_preview.ppm");
        $fwrite(preview_fd, "P6\n640 480\n255\n");
        @(posedge clk); #2; rst = 1'b0;
        send_frame(0,0);
        send_frame(1,1);
        @(posedge clk); #2; rst = 1'b1; de = 1'b0; rgb_in = 24'h13579b;
        repeat (3) @(posedge clk);
        #2; rst = 1'b0;
        send_frame(2,2);
        send_frame(3,3);
        send_frame(4,4);
        send_frame(5,5);
        repeat (4) begin @(posedge clk); de <= 1'b0; rgb_in <= 24'h2468ac; end
        #2;
        $fclose(preview_fd);
        if (active_checks != 6*640*480)
            $fatal(1, "Active pixel coverage mismatch: got %0d expected %0d", active_checks, 6*640*480);
        if (overlay_checks != 6*240*32)
            $fatal(1, "Overlay rectangle coverage mismatch: got %0d expected %0d", overlay_checks, 6*240*32);
        $display("PASS: %0d active pixels across six 640x480 frames; %0d overlay-region pixels; blank pass-through checked; both VS edges, reset, metadata/mode changes, and frame boundaries covered.", active_checks, overlay_checks);
        $display("PREVIEW: development/player_osd/build/osd_sim/osd_preview.ppm");
        $finish;
    end
endmodule
