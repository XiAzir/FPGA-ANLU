`timescale 1ns/1ps

module tb_jpeg_core;
    reg clk = 0;
    always #5 clk = ~clk;

    reg rst = 1;
    reg inport_valid = 0;
    reg [31:0] inport_data = 0;
    reg [3:0] inport_strb = 0;
    reg inport_last = 0;
    reg outport_accept = 1;
    wire inport_accept;
    wire outport_valid;
    wire [15:0] out_width, out_height, out_x, out_y;
    wire [7:0] out_r, out_g, out_b;
    wire idle;

    jpeg_core #(.SUPPORT_WRITABLE_DHT(0)) dut (
        .clk_i(clk), .rst_i(rst),
        .inport_valid_i(inport_valid), .inport_data_i(inport_data),
        .inport_strb_i(inport_strb), .inport_last_i(inport_last),
        .outport_accept_i(outport_accept), .inport_accept_o(inport_accept),
        .outport_valid_o(outport_valid), .outport_width_o(out_width),
        .outport_height_o(out_height), .outport_pixel_x_o(out_x),
        .outport_pixel_y_o(out_y), .outport_pixel_r_o(out_r),
        .outport_pixel_g_o(out_g), .outport_pixel_b_o(out_b), .idle_o(idle)
    );

    reg [7:0] jpeg_bytes [0:524287];
    reg [7:0] seen [0:307199];
    integer byte_count, in_idx, out_idx, accepted_bytes, pixels, accepted, remaining;
    integer cycles, stalls, hold_errors, dup_coords, bad_coords;
    integer fd, logfd, i, rem, mode, gap_max, seed, prev_valid;
    integer expected_frames, abort_bytes, aborted_input_bytes, send_limit, capture_enable, frame_slot, pause_after_bytes;
    integer hold_last_cycles, last_pixel_stalls, last_hold_count;
    integer expected_width, expected_height, frame_pixels;
    integer tail_strb_seen, empty_last_accepted;
    integer prev_x, prev_y, prev_r, prev_g, prev_b;
    reg [31:0] word_data;
    reg [3:0] word_strb;
    reg [15:0] width_seen, height_seen;
    reg [15:0] prev_width, prev_height;
    reg [31:0] rng_input, rng_output;
    reg [1023:0] jpeg_path, pixels_path, log_path;

    function [31:0] next_rand(input [31:0] value);
        reg [31:0] x;
        begin
            x = value;
            x = x ^ (x << 13);
            x = x ^ (x >> 17);
            x = x ^ (x << 5);
            next_rand = x;
        end
    endfunction

    initial begin
        if (!$value$plusargs("JPEG=%s", jpeg_path)) $fatal(1, "missing +JPEG");
        if (!$value$plusargs("OUT=%s", pixels_path)) $fatal(1, "missing +OUT");
        if (!$value$plusargs("LOG=%s", log_path)) $fatal(1, "missing +LOG");
        if (!$value$plusargs("MODE=%d", mode)) mode = 0;
        if (!$value$plusargs("GAP=%d", gap_max)) gap_max = 0;
        if (!$value$plusargs("SEED=%d", seed)) seed = 32'h13579bdf;
        if (!$value$plusargs("FRAMES=%d", expected_frames)) expected_frames = 1;
        if (!$value$plusargs("ABORT_BYTES=%d", abort_bytes)) abort_bytes = 0;
        if (!$value$plusargs("HOLD_LAST_CYCLES=%d", hold_last_cycles)) hold_last_cycles = 0;
        if (!$value$plusargs("PAUSE_AFTER_BYTES=%d", pause_after_bytes)) pause_after_bytes = 0;
        if (!$value$plusargs("WIDTH=%d", expected_width)) expected_width = 640;
        if (!$value$plusargs("HEIGHT=%d", expected_height)) expected_height = 480;
        frame_pixels = expected_width * expected_height;
        if (frame_pixels > 307200) $fatal(1, "frame exceeds testbench coordinate map");
        if ((abort_bytes % 4) != 0) $fatal(1, "ABORT_BYTES must be a multiple of four");
        rng_input = seed;
        rng_output = seed ^ 32'h9e3779b9;
        fd = $fopen(jpeg_path, "rb");
        if (!fd) $fatal(1, "cannot open JPEG: %0s", jpeg_path);
        byte_count = 0;
        while (!$feof(fd)) begin
            i = $fgetc(fd);
            if (i >= 0) begin
                if (byte_count >= 524288) $fatal(1, "JPEG fixture too large");
                jpeg_bytes[byte_count] = i[7:0];
                byte_count = byte_count + 1;
            end
        end
        $fclose(fd);
        fd = $fopen(pixels_path, "wb");
        logfd = $fopen(log_path, "w");
        if (!fd || !logfd) $fatal(1, "cannot create output files");
        for (i = 0; i < frame_pixels; i = i + 1) seen[i] = 0;
        byte_count = byte_count;
        accepted_bytes = 0; aborted_input_bytes = 0; pixels = 0; cycles = 0; stalls = 0;
        tail_strb_seen = 0; empty_last_accepted = 0;
        last_pixel_stalls = 0; last_hold_count = 0;
        hold_errors = 0; dup_coords = 0; bad_coords = 0;
        width_seen = 0; height_seen = 0; prev_valid = 0;
        capture_enable = (abort_bytes == 0);

        repeat (5) @(posedge clk);
        @(negedge clk); rst = 0;

        in_idx = 0;
        send_limit = (abort_bytes > 0) ? abort_bytes : byte_count;
        while (in_idx < send_limit) begin
            if (pause_after_bytes > 0 && in_idx == pause_after_bytes) begin
                @(negedge clk); inport_valid = 0; inport_strb = 0; inport_data = 0;
                while (pixels < frame_pixels || !idle) begin
                    @(posedge clk);
                    if (cycles > 10000000) $fatal(1, "timeout draining frame before next input");
                end
                pause_after_bytes = 0;
            end
            word_data = {
                ((in_idx+3 < byte_count) ? jpeg_bytes[in_idx+3] : 8'h00),
                ((in_idx+2 < byte_count) ? jpeg_bytes[in_idx+2] : 8'h00),
                ((in_idx+1 < byte_count) ? jpeg_bytes[in_idx+1] : 8'h00),
                jpeg_bytes[in_idx]
            };
            remaining = byte_count - in_idx;
            if (remaining >= 4) word_strb = 4'hf;
            else word_strb = (1 << remaining) - 1;
            if (remaining < 4) tail_strb_seen = word_strb;
            @(negedge clk);
            inport_data = word_data;
            inport_strb = word_strb;
            inport_last = 0;
            inport_valid = 1;
            accepted = 0;
            while (!accepted) begin
                @(posedge clk);
                if (inport_valid && inport_accept) begin
                    accepted_bytes = accepted_bytes + ((word_strb[0] ? 1 : 0) + (word_strb[1] ? 1 : 0) +
                                                        (word_strb[2] ? 1 : 0) + (word_strb[3] ? 1 : 0));
                    in_idx = in_idx + 4;
                    accepted = 1;
                end
                if (!accepted) begin
                    @(negedge clk);
                    if (gap_max > 0) begin
                    rng_input = next_rand(rng_input);
                    if ((rng_input % (gap_max+1)) == 0) inport_valid = 0;
                    else inport_valid = 1;
                    end
                end
            end
        end
        if (abort_bytes > 0) begin
            aborted_input_bytes = accepted_bytes;
            @(negedge clk); inport_valid = 0; inport_strb = 0; inport_data = 0; inport_last = 0; rst = 1;
            repeat (4) @(posedge clk);
            @(negedge clk);
            for (i = 0; i < frame_pixels; i = i + 1) seen[i] = 0;
            accepted_bytes = 0; pixels = 0; cycles = 0; stalls = 0;
            hold_errors = 0; dup_coords = 0; bad_coords = 0;
            prev_valid = 0; width_seen = 0; height_seen = 0;
            capture_enable = 1; in_idx = 0; send_limit = byte_count; rst = 0;
            while (in_idx < send_limit) begin
                word_data = {
                    ((in_idx+3 < byte_count) ? jpeg_bytes[in_idx+3] : 8'h00),
                    ((in_idx+2 < byte_count) ? jpeg_bytes[in_idx+2] : 8'h00),
                    ((in_idx+1 < byte_count) ? jpeg_bytes[in_idx+1] : 8'h00),
                    jpeg_bytes[in_idx]
                };
                remaining = byte_count - in_idx;
                if (remaining >= 4) word_strb = 4'hf;
                else word_strb = (1 << remaining) - 1;
                if (remaining < 4) tail_strb_seen = word_strb;
                @(negedge clk); inport_data = word_data; inport_strb = word_strb; inport_last = 0; inport_valid = 1;
                accepted = 0;
                while (!accepted) begin
                    @(posedge clk);
                    if (inport_valid && inport_accept) begin
                        accepted_bytes = accepted_bytes + ((word_strb[0] ? 1 : 0) + (word_strb[1] ? 1 : 0) +
                                                            (word_strb[2] ? 1 : 0) + (word_strb[3] ? 1 : 0));
                        in_idx = in_idx + 4; accepted = 1;
                    end
                    if (!accepted) begin
                        @(negedge clk);
                        if (gap_max > 0) begin
                            rng_input = next_rand(rng_input);
                            if ((rng_input % (gap_max+1)) == 0) inport_valid = 0;
                            else inport_valid = 1;
                        end
                    end
                end
            end
        end
        // The core treats last_i as an immediate stream-ending control; issue it
        // as an empty beat after all JPEG bytes, including any zero-padded tail.
        @(negedge clk);
        inport_valid = 1;
        inport_data = 0;
        inport_strb = 0;
        inport_last = 1;
        accepted = 0;
        while (!accepted) begin
            @(posedge clk);
            if (inport_valid && inport_accept) begin accepted = 1; empty_last_accepted = 1; end
        end
        @(negedge clk);
        inport_valid = 0;
        inport_last = 0;

        while (pixels < (frame_pixels * expected_frames) || !idle) begin
            @(posedge clk);
            if (cycles > 10000000) $fatal(1, "timeout pixels=%0d idle=%0d", pixels, idle);
        end
        if (last_pixel_stalls != hold_last_cycles)
            $fatal(1, "final pixel stall count mismatch: got=%0d expected=%0d", last_pixel_stalls, hold_last_cycles);

        $fclose(fd);
        $fwrite(logfd, "RESULT bytes=%0d aborted_input_bytes=%0d accepted_bytes=%0d tail_strb=0x%0h empty_last_accepted=%0d pixels=%0d cycles=%0d stalls=%0d last_pixel_stalls=%0d hold_errors=%0d duplicate_coords=%0d bad_coords=%0d width=%0d height=%0d idle=%0d\n",
                byte_count, aborted_input_bytes, accepted_bytes, tail_strb_seen, empty_last_accepted, pixels, cycles, stalls, last_pixel_stalls, hold_errors, dup_coords, bad_coords, width_seen, height_seen, idle);
        $fclose(logfd);
        $display("RESULT bytes=%0d aborted_input_bytes=%0d accepted_bytes=%0d tail_strb=0x%0h empty_last_accepted=%0d pixels=%0d cycles=%0d stalls=%0d last_pixel_stalls=%0d hold_errors=%0d duplicate_coords=%0d bad_coords=%0d width=%0d height=%0d idle=%0d",
                 byte_count, aborted_input_bytes, accepted_bytes, tail_strb_seen, empty_last_accepted, pixels, cycles, stalls, last_pixel_stalls, hold_errors, dup_coords, bad_coords, width_seen, height_seen, idle);
        $finish;
    end

    always @(negedge clk) begin
        if (!rst && hold_last_cycles > 0 && outport_valid &&
            out_x == expected_width-1 && out_y == expected_height-1 && last_hold_count < hold_last_cycles) begin
            outport_accept = 0;
            last_hold_count = last_hold_count + 1;
        end else if (!rst && (mode == 2 || mode == 3)) begin
            rng_output = next_rand(rng_output);
            outport_accept = ((rng_output % 5) != 0);
        end else if (!rst) begin
            outport_accept = 1;
        end
    end

    always @(posedge clk) begin
        if (!rst) begin
            cycles = cycles + 1;
            if (prev_valid) begin
                if (!outport_valid || out_x !== prev_x[15:0] || out_y !== prev_y[15:0] ||
                    out_r !== prev_r[7:0] || out_g !== prev_g[7:0] || out_b !== prev_b[7:0] ||
                    out_width !== prev_width || out_height !== prev_height) hold_errors = hold_errors + 1;
            end
            prev_valid = outport_valid && !outport_accept;
            if (prev_valid) begin
                prev_x = out_x; prev_y = out_y; prev_r = out_r; prev_g = out_g; prev_b = out_b;
                prev_width = out_width; prev_height = out_height;
            end
            if (outport_valid && !outport_accept) stalls = stalls + 1;
            if (outport_valid && !outport_accept && out_x == expected_width-1 && out_y == expected_height-1) begin
                last_pixel_stalls = last_pixel_stalls + 1;
                if (idle) $fatal(1, "idle asserted before final held pixel drain");
            end
            if (capture_enable && outport_valid && outport_accept) begin
                if (out_width != expected_width || out_height != expected_height) bad_coords = bad_coords + 1;
                if (out_x >= expected_width || out_y >= expected_height) bad_coords = bad_coords + 1;
                else begin
                    out_idx = out_y * expected_width + out_x;
                    frame_slot = (pixels / frame_pixels) + 1;
                    if (seen[out_idx] == frame_slot) dup_coords = dup_coords + 1;
                    seen[out_idx] = frame_slot[7:0];
                end
                $fwrite(fd, "%c%c%c%c%c%c%c", out_x[7:0], out_x[15:8], out_y[7:0], out_y[15:8], out_r, out_g, out_b);
                pixels = pixels + 1;
                width_seen = out_width; height_seen = out_height;
            end
        end
    end
endmodule
