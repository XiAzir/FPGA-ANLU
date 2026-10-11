`timescale 1ns/1ps

module tb_player_dynamic_text_pixels_probe;
    reg clk = 1'b0;
    reg rst = 1'b1;
    reg vs = 1'b0;
    reg de = 1'b0;
    reg [23:0] rgb_source = 24'h000000;
    wire [23:0] legacy_rgb;
    wire [23:0] rgb_out;
    wire [23:0] probe1_rgb;

    player_osd legacy (
        .clk(clk), .rst(rst), .vs(vs), .de(de), .rgb_in(rgb_source),
        .image_index(2'd2), .image_count(3'd4), .auto_mode(1'b1),
        .image_valid(1'b1), .rgb_out(legacy_rgb)
    );

    player_dynamic_text #(.CLK_FREQ_HZ(2)) dut (
        .clk(clk), .rst(rst), .vs(vs), .de(de), .probe_mode(1'b0),
        .rgb_in(legacy_rgb), .rgb_out(rgb_out)
    );
    player_dynamic_text #(.CLK_FREQ_HZ(2)) probe1 (
        .clk(clk), .rst(rst), .vs(vs), .de(de), .probe_mode(1'b1),
        .rgb_in(legacy_rgb), .rgb_out(probe1_rgb)
    );

    always #5 clk = ~clk;

    // Test-only shadow clock. It is updated once per sampled clock and never
    // reads DUT state, so frame snapshots are independently predicted.
    integer shadow_cycles = 0;
    integer shadow_seconds = 0;
    integer snapshot_seconds = 0;
    integer x_model = 0;
    integer y_model = 0;
    integer prev_de_model = 0;
    reg prev_vs_model = 1'b0;
    integer arm_line_model = 1;
    integer scroll_model = 0;
    integer frame_no = 0;
    integer frame_pixels = 0;
    integer region_pixels = 0;
    integer top_overlay_pixels = 0;
    integer bottom_overlay_pixels = 0;
    integer passthrough_pixels = 0;
    integer blank_checks = 0;
    integer expected_frames = 0;
    integer phase_target = 0;
    integer phase_frame_checks = 0;
    integer phase_mask = 0;
    integer vs_edge_checks = 0;
    integer active_time_changes = 0;
    integer rst_count = 0;
    integer preview_fd = 0;
    integer preview_pixels = 0;

    function automatic [23:0] source_pixel(input integer x, input integer y, input integer salt);
        begin
            source_pixel[23:16] = (x * 3 + y + salt * 29) & 8'hff;
            source_pixel[15:8]  = (x + y * 5 + salt * 47) & 8'hff;
            source_pixel[7:0]   = (x * 7 + y * 11 + salt * 13) & 8'hff;
        end
    endfunction

    // Independent hand-recorded ASCII 5x7 font. Bit 4 is the leftmost pixel.
    function automatic [4:0] oracle_glyph(input [7:0] c, input integer row);
        begin
            oracle_glyph = 5'b00000;
            case (c)
                "A": case(row) 0:oracle_glyph=5'b01110; 1,2:oracle_glyph=5'b10001; 3:oracle_glyph=5'b11111; 4,5,6:oracle_glyph=5'b10001; endcase
                "D": case(row) 0,6:oracle_glyph=5'b11110; 1,2,3,4,5:oracle_glyph=5'b10001; endcase
                "E": case(row) 0,6:oracle_glyph=5'b11111; 1,2,4,5:oracle_glyph=5'b10000; 3:oracle_glyph=5'b11110; endcase
                "F": case(row) 0:oracle_glyph=5'b11111; 1,2,4,5,6:oracle_glyph=5'b10000; 3:oracle_glyph=5'b11110; endcase
                "G": case(row) 0:oracle_glyph=5'b01111; 1,2:oracle_glyph=5'b10000; 3:oracle_glyph=5'b10111; 4,5:oracle_glyph=5'b10001; 6:oracle_glyph=5'b01111; endcase
                "I": case(row) 0,6:oracle_glyph=5'b11111; 1,2,3,4,5:oracle_glyph=5'b00100; endcase
                "L": case(row) 0,1,2,3,4,5:oracle_glyph=5'b10000; 6:oracle_glyph=5'b11111; endcase
                "M": case(row) 0:oracle_glyph=5'b10001; 1:oracle_glyph=5'b11011; 2,3:oracle_glyph=5'b10101; 4,5,6:oracle_glyph=5'b10001; endcase
                "N": case(row) 0:oracle_glyph=5'b10001; 1:oracle_glyph=5'b11001; 2:oracle_glyph=5'b10101; 3:oracle_glyph=5'b10011; 4,5,6:oracle_glyph=5'b10001; endcase
                "P": case(row) 0:oracle_glyph=5'b11110; 1,2:oracle_glyph=5'b10001; 3:oracle_glyph=5'b11110; 4,5,6:oracle_glyph=5'b10000; endcase
                "R": case(row) 0:oracle_glyph=5'b11110; 1,2:oracle_glyph=5'b10001; 3:oracle_glyph=5'b11110; 4:oracle_glyph=5'b10100; 5:oracle_glyph=5'b10010; 6:oracle_glyph=5'b10001; endcase
                "U": case(row) 0,1,2,3,4,5:oracle_glyph=5'b10001; 6:oracle_glyph=5'b01110; endcase
                "Y": case(row) 0,1:oracle_glyph=5'b10001; 2:oracle_glyph=5'b01010; 3,4,5,6:oracle_glyph=5'b00100; endcase
                "0": case(row) 0,6:oracle_glyph=5'b01110; 1:oracle_glyph=5'b10001; 2:oracle_glyph=5'b10011; 3:oracle_glyph=5'b10101; 4:oracle_glyph=5'b11001; 5:oracle_glyph=5'b10001; endcase
                "1": case(row) 0:oracle_glyph=5'b00100; 1:oracle_glyph=5'b01100; 2,3,4,5:oracle_glyph=5'b00100; 6:oracle_glyph=5'b01110; endcase
                "2": case(row) 0:oracle_glyph=5'b01110; 1:oracle_glyph=5'b10001; 2:oracle_glyph=5'b00001; 3:oracle_glyph=5'b00010; 4:oracle_glyph=5'b00100; 5:oracle_glyph=5'b01000; 6:oracle_glyph=5'b11111; endcase
                "3": case(row) 0:oracle_glyph=5'b11110; 1,2:oracle_glyph=5'b00001; 3:oracle_glyph=5'b01110; 4,5:oracle_glyph=5'b00001; 6:oracle_glyph=5'b11110; endcase
                "4": case(row) 0,1,2:oracle_glyph=5'b10010; 3:oracle_glyph=5'b11111; 4,5,6:oracle_glyph=5'b00010; endcase
                "5": case(row) 0:oracle_glyph=5'b11111; 1,2:oracle_glyph=5'b10000; 3:oracle_glyph=5'b11110; 4,5:oracle_glyph=5'b00001; 6:oracle_glyph=5'b11110; endcase
                "6": case(row) 0:oracle_glyph=5'b01111; 1,2:oracle_glyph=5'b10000; 3:oracle_glyph=5'b11110; 4,5:oracle_glyph=5'b10001; 6:oracle_glyph=5'b01110; endcase
                "7": case(row) 0:oracle_glyph=5'b11111; 1:oracle_glyph=5'b00001; 2:oracle_glyph=5'b00010; 3:oracle_glyph=5'b00100; 4,5,6:oracle_glyph=5'b01000; endcase
                "8": case(row) 0,3,6:oracle_glyph=5'b01110; 1,2,4,5:oracle_glyph=5'b10001; endcase
                "9": case(row) 0:oracle_glyph=5'b01110; 1,2:oracle_glyph=5'b10001; 3:oracle_glyph=5'b01111; 4,5:oracle_glyph=5'b00001; 6:oracle_glyph=5'b11110; endcase
                ":": case(row) 2,3,5,6:oracle_glyph=5'b00100; endcase
                default: oracle_glyph=5'b00000;
            endcase
        end
    endfunction

    function automatic [7:0] time_char(input integer idx, input integer seconds_value, input integer probe);
        integer mm;
        integer ss;
        begin
            mm = (seconds_value / 60) % 100;
            ss = seconds_value % 60;
            case (idx)
                0:time_char="R"; 1:time_char=probe ? "E" : "U"; 2:time_char=probe ? "F" : "N"; 3:time_char=8'h20;
                4:time_char="0" + (mm / 10); 5:time_char="0" + (mm % 10);
                6:time_char=":"; 7:time_char="0" + (ss / 10); 8:time_char="0" + (ss % 10);
                default:time_char=8'h20;
            endcase
        end
    endfunction

    function automatic [7:0] scroll_char(input integer idx);
        begin
            case (idx)
                0:scroll_char="F"; 1:scroll_char="P"; 2:scroll_char="G"; 3:scroll_char="A";
                4:scroll_char=8'h20; 5:scroll_char="M"; 6:scroll_char="E"; 7:scroll_char="D";
                8:scroll_char="I"; 9:scroll_char="A"; 10:scroll_char=8'h20;
                11:scroll_char="P"; 12:scroll_char="L"; 13:scroll_char="A"; 14:scroll_char="Y";
                15:scroll_char="E"; 16:scroll_char="R"; default:scroll_char=8'h20;
            endcase
        end
    endfunction

    function automatic [23:0] expected_pixel(input integer px, input integer py, input integer phase, input integer shown_seconds, input integer probe, input [23:0] passthrough);
        integer lx;
        integer gy;
        integer gc;
        integer gr;
        integer ci;
        reg [4:0] bits;
        reg [7:0] ch;
        begin
            expected_pixel = passthrough;
            if (px >= 448 && px < 624 && py >= 16 && py < 48) begin
                expected_pixel = 24'h000000;
                if (px >= 456 && px < 600 && py >= 24 && py < 40) begin
                    lx = px - 456; gy = (py - 24) / 2; gc = (lx % 16) / 2; gr = (py - 24) / 2; ci = lx / 16;
                    ch = time_char(ci, shown_seconds, probe); bits = oracle_glyph(ch, gr);
                    if (gc < 5 && gr < 7 && bits[4-gc]) expected_pixel = 24'hffffff;
                end
            end else if (px >= 16 && px < 624 && py >= 432 && py < 464) begin
                expected_pixel = 24'h000000;
                lx = px + phase - 624;
                if (lx >= 0 && lx < 272 && py >= 440 && py < 456) begin
                    ci = lx / 16; gc = (lx % 16) / 2; gr = (py - 440) / 2;
                    ch = scroll_char(ci); bits = oracle_glyph(ch, gr);
                    if (gc < 5 && gr < 7 && bits[4-gc]) expected_pixel = 24'hffffff;
                end
            end
        end
    endfunction

    always @(posedge clk) begin
        #1;
        if (rst) begin
            shadow_cycles = 0;
            shadow_seconds = 0;
            snapshot_seconds = 0;
            x_model = 0;
            y_model = 0;
            prev_de_model = 0;
            prev_vs_model = vs;
            arm_line_model = 1;
            scroll_model = 0;
            rst_count = rst_count + 1;
        end else begin
            if (vs !== prev_vs_model) begin
                x_model = 0; y_model = 0; arm_line_model = 1;
                snapshot_seconds = shadow_seconds;
                vs_edge_checks = vs_edge_checks + 1;
                if (vs) scroll_model = (scroll_model == 879) ? 0 : scroll_model + 1;
            end else if (de) begin
                x_model = x_model + 1;
                if (!prev_de_model && arm_line_model) begin y_model = 0; arm_line_model = 0; end
            end else begin
                x_model = 0;
                if (prev_de_model && y_model < 511) y_model = y_model + 1;
            end

            if (de) begin
                if (shadow_seconds != snapshot_seconds) active_time_changes = active_time_changes + 1;
                if (x_model < 1 || x_model > 640 || y_model < 0 || y_model >= 480)
                    $fatal(1, "Raster model out of range x=%0d y=%0d", x_model, y_model);
                // DUT coordinate registers describe the next active pixel after a clock edge.
                if (rgb_out !== expected_pixel(x_model-1, y_model, scroll_model, snapshot_seconds, 0, legacy_rgb)) begin
                    $display("FAIL frame=%0d phase=%0d xy=(%0d,%0d) shown=%0d in=%06h exp=%06h got=%06h",
                        frame_no, scroll_model, x_model-1, y_model, snapshot_seconds, legacy_rgb,
                        expected_pixel(x_model-1, y_model, scroll_model, snapshot_seconds, 0, legacy_rgb), rgb_out);
                    $fatal(1, "dynamic text pixel mismatch");
                end
                if (probe1_rgb !== expected_pixel(x_model-1, y_model, scroll_model, snapshot_seconds, 1, legacy_rgb)) begin
                    $display("FAIL REF frame=%0d xy=(%0d,%0d) in=%06h exp=%06h got=%06h",
                        frame_no, x_model-1, y_model, legacy_rgb,
                        expected_pixel(x_model-1, y_model, scroll_model, snapshot_seconds, 1, legacy_rgb), probe1_rgb);
                    $fatal(1, "probe REF pixel mismatch");
                end
                if (frame_no == 2 && scroll_model == 450) begin
                    $fwrite(preview_fd, "%c%c%c", rgb_out[23:16], rgb_out[15:8], rgb_out[7:0]);
                    preview_pixels = preview_pixels + 1;
                end
                frame_pixels = frame_pixels + 1;
                if (x_model-1 >= 448 && x_model-1 < 624 && y_model >= 16 && y_model < 48) begin region_pixels=region_pixels+1; top_overlay_pixels=top_overlay_pixels+1; end
                else if (x_model-1 >= 16 && x_model-1 < 624 && y_model >= 432 && y_model < 464) begin region_pixels=region_pixels+1; bottom_overlay_pixels=bottom_overlay_pixels+1; end
                else passthrough_pixels=passthrough_pixels+1;
                if (frame_no == expected_frames && scroll_model == phase_target) phase_frame_checks=phase_frame_checks+1;
            end else begin
                if (rgb_out !== legacy_rgb) $fatal(1, "blank RGB must pass through exactly");
                if (probe1_rgb !== legacy_rgb) $fatal(1, "REF blank RGB must pass through exactly");
                blank_checks = blank_checks + 1;
            end
            prev_de_model = de;
            prev_vs_model = vs;

            shadow_cycles = shadow_cycles + 1;
            if (shadow_cycles == 2) begin shadow_cycles=0; shadow_seconds=(shadow_seconds+1)%6000; end
        end
    end

    task automatic drive_blank(input integer cycles);
        integer i;
        begin
            for (i=0;i<cycles;i=i+1) begin
                @(negedge clk); de=0; rgb_source=source_pixel(i,frame_no,frame_no+11);
                @(posedge clk);
            end
        end
    endtask

    task automatic advance_phase_to(input integer target);
        begin
            while (scroll_model != target) begin
                @(negedge clk); vs=~vs; de=0; rgb_source=source_pixel(target,scroll_model,frame_no+17);
                @(posedge clk); #2;
            end
        end
    endtask

    task automatic render_full_frame(input integer id, input integer target_phase);
        integer yy,xx;
        integer salt;
        begin
            frame_no=id; expected_frames=id; phase_target=target_phase; salt=id+71;
            // Set the phase at the frame's VS edge. A rising edge increments it;
            // a falling edge resets raster coordinates without affecting phase.
            if (vs) begin @(negedge clk); vs=0; de=0; end
            if (target_phase == 0) begin
                advance_phase_to(879);
            end else begin
                advance_phase_to(target_phase-1);
                if (vs) begin @(negedge clk); vs=0; de=0; end
            end
            @(negedge clk); vs=1; de=0; rgb_source=source_pixel(0,0,salt);
            @(posedge clk); #2;
            if (scroll_model != target_phase)
                $fatal(1, "phase setup mismatch frame=%0d expected=%0d model=%0d", id, target_phase, scroll_model);
            phase_mask = phase_mask | (1 << id);
            for (yy=0; yy<480; yy=yy+1) begin
                for (xx=0; xx<640; xx=xx+1) begin
                    @(posedge clk); de <= 1; rgb_source <= source_pixel(xx,yy,salt);
                end
                @(posedge clk); de <= 0; rgb_source <= source_pixel(yy,xx,salt+1);
            end
            #2;
            repeat(2) begin @(posedge clk); de <= 0; rgb_source <= source_pixel(id,480,salt+2); end
        end
    endtask

    initial begin
        preview_fd = $fopen("build/dynamic_sim/dynamic_preview.ppm", "wb");
        if (preview_fd == 0) $fatal(1, "cannot create dynamic_preview.ppm");
        $fwrite(preview_fd, "P6\n640 480\n255\n");
        repeat(4) @(posedge clk);
        @(negedge clk); rst=0;
        // Blank cycles add both VS polarities; the first active line following
        // either polarity must be tracked as y=0.
        render_full_frame(0,2);
        render_full_frame(1,200);
        render_full_frame(2,450);
        render_full_frame(3,700);
        // Drive to phase 879 with only blank cycles, then test wrap to zero.
        if (vs) begin @(negedge clk); vs=0; de=0; end
        advance_phase_to(879);
        render_full_frame(4,0);
        // Second reset exercises timer/raster/phase reinitialization. The frame
        // at phase 2 also checks a new first line after both reset and VS edge.
        @(negedge clk); rst=1; de=0; vs=0; rgb_source=24'h5a39c7;
        repeat(3) @(posedge clk);
        @(negedge clk); rst=0;
        render_full_frame(5,2);
        if (frame_pixels != 6*640*480) $fatal(1, "frame coverage %0d", frame_pixels);
        if (top_overlay_pixels != 6*176*32) $fatal(1, "top overlay region coverage %0d", top_overlay_pixels);
        if (bottom_overlay_pixels != 6*608*32) $fatal(1, "bottom overlay region coverage %0d", bottom_overlay_pixels);
        if (passthrough_pixels < 6*640*480 - (6*176*32) - (6*608*32)) $fatal(1, "passthrough not covered");
        if (blank_checks < 50) $fatal(1, "blank checks too few: %0d", blank_checks);
        if (phase_mask != 6'b111111) $fatal(1, "phase scenario mask=%b", phase_mask);
        if (phase_frame_checks < 6*640*480) $fatal(1, "phase pixel coverage too few: %0d", phase_frame_checks);
        if (vs_edge_checks < 10) $fatal(1, "VS edge coverage too few: %0d", vs_edge_checks);
        if (active_time_changes < 100) $fatal(1, "active-time snapshot coverage too few: %0d", active_time_changes);
        if (rst_count < 2) $fatal(1, "expected two reset assertions");
        if (preview_pixels != 640*480) $fatal(1, "preview pixel count %0d", preview_pixels);
        $fclose(preview_fd);
        $display("PASS pixels=%0d overlay=%0d top=%0d bottom=%0d passthrough=%0d blank=%0d phases=2,200,450,700,879-wrap,reset-to-2; VS edges=%0d active-time-change=%0d; preview=%0d pixels; probe0 RUN and probe1 REF exactly matched, scroll/pass-through unchanged", frame_pixels, region_pixels, top_overlay_pixels, bottom_overlay_pixels, passthrough_pixels, blank_checks, vs_edge_checks, active_time_changes, preview_pixels);
        $finish;
    end
endmodule
