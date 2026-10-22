`timescale 1ns/1ps

module tb_mjp_file_reader;
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

    localparam integer MAX_CARD_BYTES = 262144;
    localparam integer MAX_JPEG_BYTES = 65536;
    reg [7:0] card_mem [0:MAX_CARD_BYTES-1];
    reg [7:0] expected0 [0:MAX_JPEG_BYTES-1];
    reg [7:0] expected1 [0:MAX_JPEG_BYTES-1];
    integer card_bytes;
    integer expected0_len;
    integer expected1_len;
    integer expected_requests;
    integer fd;
    integer c;
    integer i;
    integer card_busy;
    integer card_sector;
    integer card_byte;
    integer request_count;
    integer completed_frames;
    integer target_frame;
    integer received_bytes;
    integer accepted_empty_last;
    integer frame_ready_count;
    integer stall_cycles;
    integer cycles;
    integer lane;
    integer saw_last;
    reg [31:0] rng = 32'h61c88647;
    reg stalled_prev = 1'b0;
    reg [31:0] stalled_data;
    reg [3:0] stalled_strb;
    reg stalled_last;
    reg [8:0] stalled_index;
    reg [31:0] stalled_length;

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

    initial begin : load_inputs
        reg [1023:0] card_hex_path;
        reg [1023:0] jpeg0_path;
        reg [1023:0] jpeg1_path;
        if (!$value$plusargs("CARD_HEX=%s", card_hex_path)) $fatal(1, "missing +CARD_HEX");
        if (!$value$plusargs("JPEG0=%s", jpeg0_path)) $fatal(1, "missing +JPEG0");
        if (!$value$plusargs("JPEG1=%s", jpeg1_path)) $fatal(1, "missing +JPEG1");
        if (!$value$plusargs("CARD_BYTES=%d", card_bytes)) $fatal(1, "missing +CARD_BYTES");
        if (!$value$plusargs("JPEG0_LEN=%d", expected0_len)) $fatal(1, "missing +JPEG0_LEN");
        if (!$value$plusargs("JPEG1_LEN=%d", expected1_len)) $fatal(1, "missing +JPEG1_LEN");
        if (!$value$plusargs("SECTOR_REQUESTS=%d", expected_requests)) $fatal(1, "missing +SECTOR_REQUESTS");
        $readmemh(card_hex_path, card_mem, 0, card_bytes-1);
        fd = $fopen(jpeg0_path, "rb");
        if (!fd) $fatal(1, "cannot open frame 0 reference");
        for (i = 0; i < expected0_len; i = i + 1) begin
            c = $fgetc(fd);
            if (c < 0) $fatal(1, "short frame 0 reference");
            expected0[i] = c[7:0];
        end
        $fclose(fd);
        fd = $fopen(jpeg1_path, "rb");
        if (!fd) $fatal(1, "cannot open frame 1 reference");
        for (i = 0; i < expected1_len; i = i + 1) begin
            c = $fgetc(fd);
            if (c < 0) $fatal(1, "short frame 1 reference");
            expected1[i] = c[7:0];
        end
        $fclose(fd);
    end

    always @(negedge clk) begin
        if (rst) begin
            jpeg_accept = 1'b0;
            card_valid = 1'b0;
            card_end = 1'b0;
        end else begin
            rng = xorshift32(rng);
            jpeg_accept = (rng[2:0] != 3'b000);

            card_valid = 1'b0;
            card_end = 1'b0;
            if (card_busy) begin
                card_valid = 1'b1;
                card_data = card_mem[card_sector*512 + card_byte];
                if (card_byte == 511) begin
                    card_end = 1'b1;
                    card_busy = 0;
                end else begin
                    card_byte = card_byte + 1;
                end
            end else if (card_read) begin
                if (card_addr !== request_count[31:0])
                    $fatal(1, "sector sequence mismatch request=%0d addr=%0d", request_count, card_addr);
                card_sector = card_addr;
                card_byte = 0;
                card_busy = 1;
                request_count = request_count + 1;
            end
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            stalled_prev <= 1'b0;
        end else begin
            cycles <= cycles + 1;
            if (cycles > 3000000) $fatal(1, "timeout busy=%0d frame=%0d bytes=%0d", busy, target_frame, received_bytes);

            if (stalled_prev && (!jpeg_valid || jpeg_data !== stalled_data ||
                    jpeg_strb !== stalled_strb || jpeg_last !== stalled_last ||
                    frame_index !== stalled_index || frame_length !== stalled_length))
                $fatal(1, "JPEG output changed while backpressured");
            stalled_prev <= jpeg_valid && !jpeg_accept;
            if (jpeg_valid && !jpeg_accept)
                stall_cycles <= stall_cycles + 1;
            if (jpeg_valid && !jpeg_accept) begin
                stalled_data <= jpeg_data;
                stalled_strb <= jpeg_strb;
                stalled_last <= jpeg_last;
                stalled_index <= frame_index;
                stalled_length <= frame_length;
            end

            if (frame_ready) begin
                frame_ready_count <= frame_ready_count + 1;
                if (frame_index !== target_frame[8:0])
                    $fatal(1, "frame_ready index=%0d expected=%0d", frame_index, target_frame);
                if (frame_length !== ((target_frame == 0) ? expected0_len : expected1_len))
                    $fatal(1, "frame_ready length=%0d target=%0d", frame_length, target_frame);
            end

            if (jpeg_valid && jpeg_accept) begin
                if (jpeg_last) begin
                    if (jpeg_strb != 4'b0000 || jpeg_data != 32'd0)
                        $fatal(1, "tail beat must be empty");
                    accepted_empty_last <= accepted_empty_last + 1;
                    saw_last <= 1;
                end else begin
                    if (jpeg_strb == 0 || (jpeg_strb & (jpeg_strb + 1'b1)) != 0)
                        $fatal(1, "invalid JPEG strb=%b", jpeg_strb);
                    for (lane = 0; lane < 4; lane = lane + 1) begin
                        if (jpeg_strb[lane]) begin
                            if (target_frame == 0) begin
                                if (received_bytes >= expected0_len || jpeg_data[lane*8 +: 8] !== expected0[received_bytes])
                                    $fatal(1, "frame0 byte mismatch at %0d got=%02x", received_bytes, jpeg_data[lane*8 +: 8]);
                            end else begin
                                if (received_bytes >= expected1_len || jpeg_data[lane*8 +: 8] !== expected1[received_bytes])
                                    $fatal(1, "frame1 byte mismatch at %0d got=%02x", received_bytes, jpeg_data[lane*8 +: 8]);
                            end
                            received_bytes = received_bytes + 1;
                        end
                    end
                end
            end

            if (frame_sent) begin
                if (!saw_last) $fatal(1, "frame_sent without accepted empty last");
                if (sequence_index !== target_frame[8:0])
                    $fatal(1, "sequence index=%0d expected=%0d", sequence_index, target_frame);
                if (received_bytes !== ((target_frame == 0) ? expected0_len : expected1_len))
                    $fatal(1, "frame bytes=%0d target=%0d", received_bytes, target_frame);
                saw_last <= 0;
                completed_frames <= completed_frames + 1;
                if (target_frame == 0) begin
                    target_frame <= 1;
                    received_bytes <= 0;
                    next_frame <= 1'b1;
                end
            end

            if (next_frame)
                next_frame <= 1'b0;
        end
    end

    initial begin
        card_busy = 0;
        card_sector = 0;
        card_byte = 0;
        request_count = 0;
        completed_frames = 0;
        target_frame = 0;
        received_bytes = 0;
        accepted_empty_last = 0;
        frame_ready_count = 0;
        stall_cycles = 0;
        cycles = 0;
        saw_last = 0;
        repeat (5) @(negedge clk);
        rst = 1'b0;
        start = 1'b1;
        @(negedge clk);
        start = 1'b0;

        wait (file_ready);
        if (last_index !== 9'd299) $fatal(1, "last_index=%0d expected=299", last_index);
        @(negedge clk);
        next_frame = 1'b1;
        @(negedge clk);
        next_frame = 1'b0;
        wait (completed_frames == 2);
        @(negedge clk);
        if (error) $fatal(1, "reader reported error");
        if (request_count != expected_requests)
            $fatal(1, "sector requests=%0d expected=%0d", request_count, expected_requests);
        if (accepted_empty_last != 2) $fatal(1, "empty last count=%0d", accepted_empty_last);
        if (frame_ready_count != 2) $fatal(1, "frame_ready count=%0d", frame_ready_count);
        if (stall_cycles == 0) $fatal(1, "random accept did not backpressure JPEG output");
        $display("PASS frames=%0d requests=%0d accept_stalls=%0d", completed_frames,
                 request_count, stall_cycles);
        $finish;
    end
endmodule
