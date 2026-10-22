`timescale 1ns/1ps

module tb_mjp_stream_loop;
    localparam integer CARD_MAX_BYTES = 11755520;
    localparam integer FRAME_COUNT = 300;

    reg clk = 1'b0;
    always #10 clk = ~clk;

    reg rst = 1'b1;
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
    reg jpeg_accept = 1'b0;
    wire frame_sent;
    wire [8:0] sequence_index;
    wire busy;
    wire error;

    reg [7:0] card_mem [0:CARD_MAX_BYTES-1];
    reg [31:0] expected_lengths [0:FRAME_COUNT-1];
    reg [31:0] expected_crcs [0:FRAME_COUNT-1];
    integer card_bytes;
    integer trace_fd, request_fd;
    integer card_busy, card_sector, card_byte;
    integer request_count, total_frame_count, segment_id, expected_frame, active_frame;
    integer received_bytes, frame_stall_cycles, card_gap_cycles, cycle_count;
    integer empty_last_count, frame_ready_count;
    integer lane, i, max_stall_run, current_stall_run;
    integer cycle_at_request;
    reg [31:0] crc_state, completed_crc;
    reg saw_last;
    reg stalled_prev;
    reg [31:0] stalled_data;
    reg [3:0] stalled_strb;
    reg stalled_last;
    reg [8:0] stalled_index;
    reg [31:0] stalled_length;
    reg [31:0] card_rng = 32'h61c88647;
    reg [31:0] accept_rng = 32'h9e3779b9;
    integer beat_count;

    mjp_file_reader dut (
        .clk(clk), .rst(rst), .start(start), .next_frame(next_frame),
        .card_read(card_read), .card_addr(card_addr), .card_data(card_data),
        .card_valid(card_valid), .card_end(card_end), .file_error(file_error),
        .file_ready(file_ready), .last_index(last_index),
        .frame_ready(frame_ready), .frame_index(frame_index), .frame_length(frame_length),
        .jpeg_valid(jpeg_valid), .jpeg_data(jpeg_data), .jpeg_strb(jpeg_strb),
        .jpeg_last(jpeg_last), .jpeg_accept(jpeg_accept),
        .frame_sent(frame_sent), .sequence_index(sequence_index),
        .busy(busy), .error(error)
    );

    function [31:0] xorshift32(input [31:0] x);
        begin
            x = x ^ (x << 13);
            x = x ^ (x >> 17);
            x = x ^ (x << 5);
            xorshift32 = x;
        end
    endfunction

    function [31:0] crc32_byte(input [31:0] prior, input [7:0] value);
        reg [31:0] c;
        integer bit_no;
        begin
            c = prior ^ value;
            for (bit_no = 0; bit_no < 8; bit_no = bit_no + 1)
                c = c[0] ? ((c >> 1) ^ 32'hedb88320) : (c >> 1);
            crc32_byte = c;
        end
    endfunction

    initial begin : load_inputs
        reg [1023:0] card_hex_path;
        reg [1023:0] lengths_path;
        reg [1023:0] crcs_path;
        reg [1023:0] trace_path;
        reg [1023:0] request_path;
        if (!$value$plusargs("CARD_HEX=%s", card_hex_path)) $fatal(1, "missing +CARD_HEX");
        if (!$value$plusargs("CARD_BYTES=%d", card_bytes)) $fatal(1, "missing +CARD_BYTES");
        if (!$value$plusargs("LENGTHS_HEX=%s", lengths_path)) $fatal(1, "missing +LENGTHS_HEX");
        if (!$value$plusargs("CRCS_HEX=%s", crcs_path)) $fatal(1, "missing +CRCS_HEX");
        if (!$value$plusargs("FRAME_TRACE=%s", trace_path)) $fatal(1, "missing +FRAME_TRACE");
        if (!$value$plusargs("REQUEST_TRACE=%s", request_path)) $fatal(1, "missing +REQUEST_TRACE");
        if (card_bytes != CARD_MAX_BYTES || card_bytes % 512 != 0)
            $fatal(1, "unexpected card length=%0d", card_bytes);
        $readmemh(card_hex_path, card_mem, 0, card_bytes-1);
        $readmemh(lengths_path, expected_lengths);
        $readmemh(crcs_path, expected_crcs);
        trace_fd = $fopen(trace_path, "w");
        request_fd = $fopen(request_path, "w");
        if (!trace_fd || !request_fd) $fatal(1, "could not open trace output");
        $fdisplay(trace_fd, "segment,ordinal,frame_index,length_bytes,crc32,cycles,accept_stalls,empty_last");
        $fdisplay(request_fd, "segment,ordinal,frame_index,cycle,lba");
    end

    always @(negedge clk) begin
        if (rst) begin
            jpeg_accept = 1'b0;
            card_valid = 1'b0;
            card_end = 1'b0;
            card_busy = 0;
            card_byte = 0;
        end else begin
            accept_rng = xorshift32(accept_rng);
            beat_count = beat_count + 1;
            // Random-ready stalls plus a deterministic 18-cycle hold every 251 accepted words.
            jpeg_accept = (accept_rng[2:0] != 3'b000) && ((beat_count % 251) >= 18);

            card_valid = 1'b0;
            card_end = 1'b0;
            if (card_busy) begin
                card_rng = xorshift32(card_rng);
                if (card_rng[4:0] == 5'b00000) begin
                    card_gap_cycles = card_gap_cycles + 1;
                end else begin
                    card_valid = 1'b1;
                    card_data = card_mem[card_sector*512 + card_byte];
                    if (card_byte == 511) begin
                        card_end = 1'b1;
                        card_busy = 0;
                    end else begin
                        card_byte = card_byte + 1;
                    end
                end
            end else if (card_read) begin
                if (card_addr >= (card_bytes/512))
                    $fatal(1, "card request outside MJP sectors lba=%0d", card_addr);
                card_sector = card_addr;
                card_byte = 0;
                card_busy = 1;
                $fdisplay(request_fd, "%0d,%0d,%0d,%0d,%0d", segment_id,
                    request_count, expected_frame, cycle_count, card_addr);
                request_count = request_count + 1;
            end
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            stalled_prev <= 1'b0;
            current_stall_run <= 0;
        end else begin
            cycle_count = cycle_count + 1;
            if (cycle_count > 50000000) $fatal(1, "watchdog busy=%0d segment=%0d", busy, segment_id);

            if (stalled_prev && (!jpeg_valid || jpeg_data !== stalled_data ||
                    jpeg_strb !== stalled_strb || jpeg_last !== stalled_last ||
                    frame_index !== stalled_index || frame_length !== stalled_length))
                $fatal(1, "output changed while jpeg_accept=0 at cycle=%0d", cycle_count);
            stalled_prev <= jpeg_valid && !jpeg_accept;
            if (jpeg_valid && !jpeg_accept) begin
                frame_stall_cycles = frame_stall_cycles + 1;
                current_stall_run = current_stall_run + 1;
                if (current_stall_run > max_stall_run) max_stall_run = current_stall_run;
                stalled_data <= jpeg_data;
                stalled_strb <= jpeg_strb;
                stalled_last <= jpeg_last;
                stalled_index <= frame_index;
                stalled_length <= frame_length;
            end else begin
                current_stall_run = 0;
            end

            if (frame_ready) begin
                if (frame_index !== expected_frame[8:0])
                    $fatal(1, "frame_ready index=%0d expected=%0d", frame_index, expected_frame);
                if (frame_length !== expected_lengths[expected_frame])
                    $fatal(1, "frame_ready length=%0d expected=%0d frame=%0d",
                        frame_length, expected_lengths[expected_frame], expected_frame);
                frame_ready_count = frame_ready_count + 1;
                active_frame = expected_frame;
                received_bytes = 0;
                crc_state = 32'hffffffff;
                frame_stall_cycles = 0;
                saw_last = 1'b0;
                cycle_at_request = cycle_count;
            end

            if (jpeg_valid && jpeg_accept) begin
                if (jpeg_last) begin
                    if (jpeg_strb !== 4'b0000 || jpeg_data !== 32'd0)
                        $fatal(1, "tail beat must be empty frame=%0d", expected_frame);
                    if (received_bytes !== expected_lengths[active_frame])
                        $fatal(1, "frame byte count=%0d expected=%0d frame=%0d",
                            received_bytes, expected_lengths[active_frame], active_frame);
                    completed_crc = crc_state ^ 32'hffffffff;
                    if (completed_crc !== expected_crcs[active_frame])
                        $fatal(1, "CRC mismatch frame=%0d got=%08x expected=%08x",
                            active_frame, completed_crc, expected_crcs[active_frame]);
                    empty_last_count = empty_last_count + 1;
                    saw_last = 1'b1;
                end else begin
                    if (jpeg_strb == 0 || (jpeg_strb & (jpeg_strb + 1'b1)) != 0)
                        $fatal(1, "invalid jpeg_strb=%b frame=%0d", jpeg_strb, expected_frame);
                    for (lane = 0; lane < 4; lane = lane + 1) begin
                        if (jpeg_strb[lane]) begin
                            if (received_bytes >= expected_lengths[active_frame])
                                $fatal(1, "frame overrun frame=%0d", active_frame);
                            crc_state = crc32_byte(crc_state, jpeg_data[lane*8 +: 8]);
                            received_bytes = received_bytes + 1;
                        end else if (jpeg_data[lane*8 +: 8] !== 8'd0) begin
                            $fatal(1, "invalid high padding frame=%0d strb=%b", active_frame, jpeg_strb);
                        end
                    end
                end
            end

            if (frame_sent) begin
                if (!saw_last || sequence_index !== active_frame[8:0])
                    $fatal(1, "bad frame_sent index=%0d expected=%0d saw_last=%0d",
                        sequence_index, active_frame, saw_last);
                total_frame_count = total_frame_count + 1;
                $fdisplay(trace_fd, "%0d,%0d,%0d,%0d,%08x,%0d,%0d,1", segment_id,
                    total_frame_count, sequence_index, received_bytes, completed_crc,
                    cycle_count-cycle_at_request, frame_stall_cycles);
            end
        end
    end

    task pulse_start;
        begin
            @(negedge clk); start = 1'b1;
            @(negedge clk); start = 1'b0;
        end
    endtask

    task send_frame;
        input integer index;
        begin
            expected_frame = index;
            @(negedge clk); next_frame = 1'b1;
            @(negedge clk); next_frame = 1'b0;
            @(posedge frame_sent);
            @(negedge clk);
        end
    endtask

    integer ordinal;
    initial begin
        card_busy = 0;
        card_sector = 0;
        card_byte = 0;
        request_count = 0;
        total_frame_count = 0;
        segment_id = 0;
        expected_frame = 0;
        active_frame = 0;
        received_bytes = 0;
        frame_stall_cycles = 0;
        card_gap_cycles = 0;
        cycle_count = 0;
        empty_last_count = 0;
        frame_ready_count = 0;
        max_stall_run = 0;
        current_stall_run = 0;
        beat_count = 0;
        saw_last = 1'b0;
        stalled_prev = 1'b0;
        crc_state = 32'hffffffff;
        completed_crc = 32'd0;
        repeat (5) @(negedge clk);
        rst = 1'b0;
        pulse_start();
        wait (file_ready);
        if (last_index !== 9'd299) $fatal(1, "last_index=%0d expected=299", last_index);

        for (ordinal = 0; ordinal < 301; ordinal = ordinal + 1)
            send_frame(ordinal % FRAME_COUNT);

        if (total_frame_count != 301 || empty_last_count != 301 || frame_ready_count != 301)
            $fatal(1, "first run count frames=%0d tails=%0d ready=%0d",
                total_frame_count, empty_last_count, frame_ready_count);
        $display("STREAM_PHASE1_PASS frames=301 wrap_index=%0d last_index=%0d", sequence_index, last_index);

        segment_id = 1;
        @(negedge clk); rst = 1'b1;
        repeat (4) @(negedge clk);
        rst = 1'b0;
        pulse_start();
        wait (file_ready);
        if (last_index !== 9'd299 || error) $fatal(1, "reset playback header mismatch");
        send_frame(0);
        if (total_frame_count != 302 || empty_last_count != 302 || frame_ready_count != 302)
            $fatal(1, "reset replay count frames=%0d tails=%0d ready=%0d",
                total_frame_count, empty_last_count, frame_ready_count);
        if (sequence_index !== 9'd0 || error) $fatal(1, "reset replay frame0 failed");

        @(negedge clk); file_error = 1'b1;
        @(negedge clk); file_error = 1'b0;
        wait (error);
        @(negedge clk);
        if (busy || card_read) $fatal(1, "file_error did not stop reader");
        if (request_count < 23000) $fatal(1, "unexpected low sector request count=%0d", request_count);
        if (card_gap_cycles == 0 || max_stall_run < 18)
            $fatal(1, "stress stimulus missing gaps=%0d max_stall=%0d", card_gap_cycles, max_stall_run);
        $display("STREAM_LOOP_PASS frames=%0d full_loop=301 reset_frame0=1 requests=%0d card_gaps=%0d jpeg_stall_cycles=%0d max_stall=%0d empty_last=%0d error=%b",
            total_frame_count, request_count, card_gap_cycles, frame_stall_cycles,
            max_stall_run, empty_last_count, error);
        $fclose(trace_fd);
        $fclose(request_fd);
        $finish;
    end
endmodule
