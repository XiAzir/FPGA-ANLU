`timescale 1ns/1ps

module tb_mjp_jpeg_core;
    reg clk = 1'b0;
    always #10 clk = ~clk;

    reg rst = 1'b1;
    reg jpeg_rst = 1'b1;
    reg start = 1'b0;
    reg next_frame = 1'b0;
    wire card_read;
    wire [31:0] card_addr;
    reg [7:0] card_data = 8'd0;
    reg card_valid = 1'b0;
    reg card_end = 1'b0;
    reg file_error = 1'b0;
    wire file_ready;
    wire [8:0] last_index;
    wire frame_ready;
    wire [8:0] frame_index;
    wire [31:0] frame_length;
    wire jpeg_valid;
    wire [31:0] jpeg_data;
    wire [3:0] jpeg_strb;
    wire jpeg_last;
    wire jpeg_accept;
    wire frame_sent;
    wire [8:0] sequence_index;
    wire reader_busy;
    wire reader_error;

    wire core_in_accept;
    wire core_out_valid;
    wire [15:0] core_width, core_height, core_x, core_y;
    wire [7:0] core_r, core_g, core_b;
    wire core_idle;
    wire core_out_accept = 1'b1;

    localparam integer MAX_CARD_BYTES = 262144;
    reg [7:0] card_mem [0:MAX_CARD_BYTES-1];
    integer card_bytes;
    integer card_period;
    integer expected_requests;
    integer fd;
    integer c;
    integer i;
    integer card_busy;
    integer card_sector;
    integer card_byte;
    integer card_period_count;
    integer request_count;
    integer total_card_bytes;
    integer frame_card_bytes;
    integer frame_sector_count;
    integer last_card_end_cycle;
    integer frame_start_cycle;
    integer frame_active;
    integer cycles;
    integer frame_pixels;
    integer completed_frames;
    integer target_frame;
    integer frame_sent_count;
    integer jpeg_input_bytes;
    integer expected_frame0_bytes;
    integer expected_frame1_bytes;
    integer jpeg_byte_increment;
    integer crc_lane;
    reg [31:0] jpeg_input_crc;
    reg [31:0] jpeg_crc_next;
    reg [31:0] expected_frame0_crc;
    reg [31:0] expected_frame1_crc;
    integer pixel_fd;
    integer summary_fd;
    integer out_index;
    integer pixel_addr;
    integer frame_index_seen;
    integer x, y, rr, gg, bb;
    integer budget_cycles;
    real card_rate_mbps;
    reg [7:0] seen [0:307199];
    reg [1023:0] card_hex_path;
    reg [1023:0] pixels_path;
    reg [1023:0] summary_path;

    function [31:0] crc32_byte;
        input [31:0] crc_in;
        input [7:0] data_in;
        reg [31:0] value;
        integer bit_index;
        begin
            value = crc_in ^ data_in;
            for (bit_index = 0; bit_index < 8; bit_index = bit_index + 1)
                if (value[0]) value = (value >> 1) ^ 32'hedb88320;
                else value = value >> 1;
            crc32_byte = value;
        end
    endfunction

    mjp_file_reader reader (
        .clk(clk), .rst(rst), .start(start), .next_frame(next_frame),
        .card_read(card_read), .card_addr(card_addr), .card_data(card_data),
        .card_valid(card_valid), .card_end(card_end), .file_error(file_error),
        .file_ready(file_ready), .last_index(last_index),
        .frame_ready(frame_ready), .frame_index(frame_index), .frame_length(frame_length),
        .jpeg_valid(jpeg_valid), .jpeg_data(jpeg_data), .jpeg_strb(jpeg_strb),
        .jpeg_last(jpeg_last), .jpeg_accept(jpeg_accept),
        .frame_sent(frame_sent), .sequence_index(sequence_index),
        .busy(reader_busy), .error(reader_error)
    );

    jpeg_core #(.SUPPORT_WRITABLE_DHT(0)) core (
        .clk_i(clk), .rst_i(jpeg_rst),
        .inport_valid_i(jpeg_valid), .inport_data_i(jpeg_data),
        .inport_strb_i(jpeg_strb), .inport_last_i(jpeg_last),
        .outport_accept_i(core_out_accept), .inport_accept_o(core_in_accept),
        .outport_valid_o(core_out_valid), .outport_width_o(core_width),
        .outport_height_o(core_height), .outport_pixel_x_o(core_x),
        .outport_pixel_y_o(core_y), .outport_pixel_r_o(core_r),
        .outport_pixel_g_o(core_g), .outport_pixel_b_o(core_b), .idle_o(core_idle)
    );
    assign jpeg_accept = core_in_accept;

    initial begin : load_inputs
        if (!$value$plusargs("CARD_HEX=%s", card_hex_path)) $fatal(1, "missing +CARD_HEX");
        if (!$value$plusargs("OUT=%s", pixels_path)) $fatal(1, "missing +OUT");
        if (!$value$plusargs("SUMMARY=%s", summary_path)) $fatal(1, "missing +SUMMARY");
        if (!$value$plusargs("CARD_BYTES=%d", card_bytes)) $fatal(1, "missing +CARD_BYTES");
        if (!$value$plusargs("CARD_PERIOD=%d", card_period)) $fatal(1, "missing +CARD_PERIOD");
        if (!$value$plusargs("SECTOR_REQUESTS=%d", expected_requests)) $fatal(1, "missing +SECTOR_REQUESTS");
        expected_frame0_bytes = -1;
        expected_frame1_bytes = -1;
        expected_frame0_crc = 32'd0;
        expected_frame1_crc = 32'd0;
        void'($value$plusargs("FRAME0_BYTES=%d", expected_frame0_bytes));
        void'($value$plusargs("FRAME1_BYTES=%d", expected_frame1_bytes));
        void'($value$plusargs("FRAME0_CRC=%h", expected_frame0_crc));
        void'($value$plusargs("FRAME1_CRC=%h", expected_frame1_crc));
        $readmemh(card_hex_path, card_mem, 0, card_bytes-1);
        pixel_fd = $fopen(pixels_path, "wb");
        summary_fd = $fopen(summary_path, "w");
        if (!pixel_fd || !summary_fd) $fatal(1, "cannot open simulation output");
        for (i = 0; i < 307200; i = i + 1) seen[i] = 0;
    end

    always @(posedge clk) begin
        if (rst) begin
            cycles <= 0;
            card_valid <= 1'b0;
            card_end <= 1'b0;
            card_busy <= 0;
            card_sector <= 0;
            card_byte <= 0;
            card_period_count <= 0;
            request_count <= 0;
            total_card_bytes <= 0;
            frame_card_bytes <= 0;
            frame_sector_count <= 0;
            last_card_end_cycle <= 0;
            frame_pixels <= 0;
            completed_frames <= 0;
            frame_sent_count <= 0;
            jpeg_input_bytes <= 0;
            jpeg_input_crc <= 32'hffffffff;
            target_frame <= 0;
            frame_index_seen <= 0;
        end else begin
            cycles <= cycles + 1;
            if ((cycles % 1000000) == 0)
                $display("PROGRESS cycles=%0d frame=%0d frame_pixels=%0d card_bytes=%0d requests=%0d file_ready=%0d last_index=%0d next_frame=%0d reader_state=%0d card_valid=%0d card_end=%0d core_idle=%0d",
                    cycles, target_frame, frame_pixels, total_card_bytes, request_count,
                    file_ready, last_index, next_frame, reader.state, card_valid, card_end, core_idle);
            card_valid <= 1'b0;
            card_end <= 1'b0;

            jpeg_byte_increment = 0;
            jpeg_crc_next = jpeg_input_crc;
            if (jpeg_valid && jpeg_accept) begin
                for (crc_lane = 0; crc_lane < 4; crc_lane = crc_lane + 1) begin
                    if (jpeg_strb[crc_lane]) begin
                        jpeg_crc_next = crc32_byte(jpeg_crc_next, jpeg_data[crc_lane*8 +: 8]);
                        jpeg_byte_increment = jpeg_byte_increment + 1;
                    end
                end
                jpeg_input_bytes <= jpeg_input_bytes + jpeg_byte_increment;
                jpeg_input_crc <= jpeg_crc_next;
            end

            if (card_busy) begin
                if (card_period_count == card_period - 1) begin
                    card_valid <= 1'b1;
                    card_data <= card_mem[card_sector*512 + card_byte];
                    card_period_count <= 0;
                    card_byte <= card_byte + 1;
                    total_card_bytes <= total_card_bytes + 1;
                    if (frame_active)
                        frame_card_bytes <= frame_card_bytes + 1;
                    if (card_byte == 511) begin
                        $display("CARD_SECTOR_END cycle=%0d lba=%0d file_ready=%0d reader_state=%0d",
                            cycles, card_sector, file_ready, reader.state);
                        card_end <= 1'b1;
                        card_busy <= 0;
                        frame_sector_count <= frame_sector_count + 1;
                        if (frame_active)
                            last_card_end_cycle <= cycles;
                    end
                end else begin
                    card_period_count <= card_period_count + 1;
                end
            end else if (card_read) begin
                if (card_addr !== request_count[31:0])
                    $fatal(1, "sector sequence mismatch request=%0d addr=%0d", request_count, card_addr);
                card_sector <= card_addr;
                card_byte <= 0;
                card_period_count <= 0;
                card_busy <= 1;
                request_count <= request_count + 1;
            end

            if (core_out_valid && core_out_accept) begin
                if (core_width != 640 || core_height != 480)
                    $fatal(1, "unexpected decoded dimensions %0dx%0d", core_width, core_height);
                if (core_x >= 640 || core_y >= 480)
                    $fatal(1, "pixel coordinate out of range (%0d,%0d)", core_x, core_y);
                pixel_addr = core_y * 640 + core_x;
                if (seen[pixel_addr] != 0)
                    $fatal(1, "duplicate coordinate frame=%0d (%0d,%0d)", target_frame, core_x, core_y);
                seen[pixel_addr] = 1;
                $fwrite(pixel_fd, "%c%c%c%c%c%c%c", core_x[7:0], core_x[15:8],
                    core_y[7:0], core_y[15:8], core_r, core_g, core_b);
                frame_pixels <= frame_pixels + 1;
            end

            if (frame_ready) begin
                $display("FRAME_READY cycle=%0d index=%0d length=%0d",
                    cycles, frame_index, frame_length);
                frame_index_seen <= frame_index;
                jpeg_input_bytes <= 0;
                jpeg_input_crc <= 32'hffffffff;
                if (frame_index !== target_frame[8:0])
                    $fatal(1, "frame header index=%0d expected=%0d", frame_index, target_frame);
            end
            if (frame_sent) begin
                frame_sent_count <= frame_sent_count + 1;
                if (sequence_index !== target_frame[8:0])
                    $fatal(1, "reader sequence index=%0d expected=%0d", sequence_index, target_frame);
                if (jpeg_input_bytes != ((target_frame == 0) ? expected_frame0_bytes : expected_frame1_bytes) &&
                    ((target_frame == 0) ? expected_frame0_bytes : expected_frame1_bytes) >= 0)
                    $fatal(1, "frame %0d JPEG input bytes=%0d expected=%0d", target_frame,
                        jpeg_input_bytes, (target_frame == 0) ? expected_frame0_bytes : expected_frame1_bytes);
                if (target_frame == 0 && expected_frame0_bytes >= 0 && ~jpeg_input_crc !== expected_frame0_crc)
                    $fatal(1, "frame 0 JPEG input CRC=%08x expected=%08x", ~jpeg_input_crc, expected_frame0_crc);
                if (target_frame == 1 && expected_frame1_bytes >= 0 && ~jpeg_input_crc !== expected_frame1_crc)
                    $fatal(1, "frame 1 JPEG input CRC=%08x expected=%08x", ~jpeg_input_crc, expected_frame1_crc);
                $display("JPEG_INPUT frame=%0d bytes=%0d crc32=%08x", target_frame, jpeg_input_bytes, ~jpeg_input_crc);
                $fwrite(summary_fd, "JPEG_INPUT frame=%0d bytes=%0d crc32=%08x\n", target_frame, jpeg_input_bytes, ~jpeg_input_crc);
            end
            if (cycles > 20000000) $fatal(1, "timeout frame=%0d pixels=%0d", target_frame, frame_pixels);
        end
    end

    task begin_frame;
        input integer index;
        integer k;
        begin
            $display("TB_BEGIN_FRAME index=%0d cycle=%0d", index, cycles);
            target_frame = index;
            frame_active = 1'b1;
            frame_start_cycle = cycles;
            frame_card_bytes = 0;
            frame_sector_count = 0;
            last_card_end_cycle = 0;
            frame_pixels = 0;
            for (k = 0; k < 307200; k = k + 1) seen[k] = 0;
            @(negedge clk);
            next_frame = 1'b1;
            @(negedge clk);
            next_frame = 1'b0;
            $display("TB_NEXT_FRAME_PULSED index=%0d cycle=%0d", index, cycles);
        end
    endtask

    task report_frame;
        input integer index;
        integer total_cycles;
        integer card_cycles;
        begin
            total_cycles = cycles - frame_start_cycle;
            card_cycles = last_card_end_cycle - frame_start_cycle;
            if (frame_pixels != 307200) $fatal(1, "frame %0d pixels=%0d", index, frame_pixels);
            if (request_count == 0 || frame_sector_count == 0)
                $fatal(1, "frame %0d missing card sectors", index);
            card_rate_mbps = (card_cycles > 0) ?
                (1.0 * frame_card_bytes * 8.0 * 50.0 / card_cycles) : 0.0;
            $display("FRAME index=%0d jpeg_bytes=%0d card_bytes=%0d sectors=%0d total_cycles=%0d card_mbps=%.3f within_15fps=%0d",
                index, frame_length, frame_card_bytes, frame_sector_count, total_cycles,
                card_rate_mbps, (total_cycles <= budget_cycles));
            $fwrite(summary_fd,
                "FRAME index=%0d jpeg_bytes=%0d card_bytes=%0d sectors=%0d total_cycles=%0d card_mbps=%.3f within_15fps=%0d\n",
                index, frame_length, frame_card_bytes, frame_sector_count, total_cycles,
                card_rate_mbps, (total_cycles <= budget_cycles));
            if (total_cycles > budget_cycles)
                $display("WARNING frame %0d exceeds 15fps cycle budget %0d", index, budget_cycles);
            completed_frames = completed_frames + 1;
        end
    endtask

    initial begin
        frame_active = 1'b0;
        frame_start_cycle = 0;
        budget_cycles = 3333333;
        repeat (5) @(negedge clk);
        rst = 1'b0;
        jpeg_rst = 1'b0;
        start = 1'b1;
        @(negedge clk);
        start = 1'b0;
        wait (file_ready);
        $display("TB_FILE_READY last_index=%0d cycle=%0d", last_index, cycles);
        if (last_index !== 9'd299) $fatal(1, "last_index=%0d expected=299", last_index);

        begin_frame(0);
        wait (frame_sent_count == 1);
        wait (frame_pixels == 307200 && core_idle);
        report_frame(0);
        frame_active = 1'b0;

        @(negedge clk);
        jpeg_rst = 1'b1;
        repeat (2) @(negedge clk);
        jpeg_rst = 1'b0;
        begin_frame(1);
        wait (frame_sent_count == 2);
        wait (frame_pixels == 307200 && core_idle);
        report_frame(1);
        frame_active = 1'b0;

        @(negedge clk);
        if (request_count != expected_requests)
            $fatal(1, "sector requests=%0d expected=%0d", request_count, expected_requests);
        if (reader_error) $fatal(1, "reader reported error");
        $fwrite(summary_fd, "PASS frames=2 sector_requests=%0d card_bytes=%0d\n", request_count, total_card_bytes);
        $fclose(pixel_fd);
        $fclose(summary_fd);
        $display("PASS frames=2 sector_requests=%0d card_bytes=%0d", request_count, total_card_bytes);
        $finish;
    end
endmodule
