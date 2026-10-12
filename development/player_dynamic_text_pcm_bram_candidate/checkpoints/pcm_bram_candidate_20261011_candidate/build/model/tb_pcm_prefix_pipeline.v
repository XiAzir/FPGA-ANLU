`timescale 1ns/1ps
module tb_pcm_prefix_pipeline;
    localparam integer PREFIX = 1024;
    localparam integer SKIP = 512;
    localparam integer FIFO_DEPTH = 256;
    localparam integer FAULT_SAMPLE = 123;
    localparam integer REAL_SKIP = 65536;
    localparam integer REAL_PREFIX = 32768;
    localparam integer REAL_EVENTS = REAL_SKIP + REAL_PREFIX;

    reg sd_clk = 1'b0;
    reg pixel_clk = 1'b0;
    reg rst = 1'b1;
    always #7 sd_clk = ~sd_clk;
    always #11 pixel_clk = ~pixel_clk;
    reg real_clk = 1'b0;
    always #3 real_clk = ~real_clk;

    reg sd_init_done = 1'b0;
    reg file_error = 1'b0;
    reg [31:0] file_size = 0;
    wire sd_read;
    wire [31:0] sd_addr;
    reg [7:0] sd_data = 0;
    reg sd_valid = 0;
    reg sd_end = 0;
    wire [15:0] player_sample_data;
    wire player_sample_available, primed, player_error;
    wire [3:0] debug_state, debug_phase;
    wire [31:0] debug_scan_pos;
    wire [7:0] debug_scan_byte;
    wire debug_sample_push;
    wire [15:0] debug_push_data;
    wire [31:0] debug_push_pos, debug_data_offset;
    wire sample_take, audio_valid, underflow;
    wire [23:0] audio_left, audio_right;

    reg [7:0] wav_image [0:2047];
    reg [15:0] reference [0:9];
    reg [15:0] real_stream [0:REAL_EVENTS-1];
    reg [15:0] real_reference [0:5];
    reg real_rst = 1'b1;
    reg real_valid = 1'b0;
    reg [15:0] real_data = 0;
    reg [31:0] real_input_index = 0;
    wire [15:0] real_crc, real_count;
    wire real_done, real_capture_event;

    integer servicing = 0;
    integer service_index = 0;
    integer service_gap = 0;
    reg [31:0] service_sector = 0;
    integer cycles = 0;
    reg [31:0] audio_event_count = 0;
    reg [31:0] pop_event_count = 0;
    reg [31:0] push_event_count = 0;
    integer errors = 0;
    integer timeout_cycles = 0;
    integer i;

    // Fault injection is only in passive monitor branches. The real playback
    // connection from tf_wav_file_player through wav_pcm_bridge is untouched.
    wire fifo_fault_valid = sample_take && player_sample_available;
    wire [15:0] fifo_fault_data = (pop_event_count == SKIP + FAULT_SAMPLE) ?
        (player_sample_data ^ 16'h0001) : player_sample_data;
    wire [15:0] hdmi_fault_word = (audio_event_count == SKIP + FAULT_SAMPLE) ?
        (audio_left[23:8] ^ 16'h0001) : audio_left[23:8];
    wire [23:0] hdmi_fault_left = {hdmi_fault_word, audio_left[7:0]};
    wire [23:0] hdmi_fault_right = {hdmi_fault_word, audio_right[7:0]};

    reg early_tone_mode = 1'b0;
    integer early_event_count = 0;
    reg nominal_tone_mode = 1'b0;
    reg [15:0] frozen_src_crc, frozen_fifo_crc, frozen_hdmi_crc;
    reg [15:0] frozen_hdmi_count;
    integer post_tone_target;

    // Real-file, full-parameter unit stream: exactly 65,536 skipped samples,
    // then the 32,768-sample host-verified window. No player or bridge is in
    // this path, so this independently checks the probe's production skip count.
    pcm_prefix_crc #(.PREFIX_SAMPLES(REAL_PREFIX), .SKIP_SAMPLES(REAL_SKIP)) u_real_crc (
        .clk(real_clk), .rst(real_rst), .valid(real_valid), .data(real_data),
        .crc(real_crc), .count(real_count), .done(real_done), .capture_event(real_capture_event)
    );
    always @(negedge real_clk) begin
        if (real_rst) begin
            real_input_index <= 0;
            real_valid <= 1'b0;
            real_data <= 0;
        end else if (real_input_index < REAL_EVENTS) begin
            real_data <= real_stream[real_input_index];
            real_valid <= 1'b1;
            real_input_index <= real_input_index + 1'b1;
        end else real_valid <= 1'b0;
    end

    tf_wav_file_player #(.FIFO_DEPTH(FIFO_DEPTH), .WAIT_LIMIT(32'd500000)) u_player (
        .clk(sd_clk), .rst(rst), .sd_init_done(sd_init_done), .file_size(file_size),
        .file_error(file_error), .sd_read(sd_read), .sd_addr(sd_addr),
        .sd_data(sd_data), .sd_valid(sd_valid), .sd_end(sd_end),
        .sample_take(sample_take), .sample_data(player_sample_data),
        .sample_available(player_sample_available), .primed(primed), .error(player_error),
        .debug_state(debug_state), .debug_phase(debug_phase),
        .debug_scan_pos(debug_scan_pos), .debug_scan_byte(debug_scan_byte),
        .debug_sample_push(debug_sample_push), .debug_push_data(debug_push_data),
        .debug_push_pos(debug_push_pos), .debug_data_offset(debug_data_offset)
    );

    wav_pcm_bridge #(.PIXEL_HZ(25000000), .SAMPLE_HZ(48000)) u_bridge (
        .pixel_clk(pixel_clk), .sd_clk(sd_clk), .rst(rst), .primed(primed),
        .sample_available(player_sample_available), .sample_data(player_sample_data),
        .sample_take(sample_take), .audio_valid(audio_valid),
        .audio_left(audio_left), .audio_right(audio_right), .underflow(underflow)
    );

    // Nominal probe: all three stages must match the independent Python prefix.
    wire [15:0] src_crc, fifo_crc, hdmi_crc;
    wire [3:0] capture_flags;
    wire [15:0] format_bad, hdmi_count;
    wire [23:0] first_high_pos_sync, data_offset_sync;
    player_pcm_prefix_probe #(.PREFIX_SAMPLES(PREFIX), .SKIP_SAMPLES(SKIP)) u_probe (
        .sd_clk(sd_clk), .pixel_clk(pixel_clk), .rst(rst),
        .push_valid(debug_sample_push), .push_data(debug_push_data),
        .push_high_pos(debug_push_pos), .data_offset(debug_data_offset),
        .pop_valid(fifo_fault_valid), .pop_data(player_sample_data),
        .audio_valid(audio_valid), .tone_mode(nominal_tone_mode),
        .audio_left(audio_left), .audio_right(audio_right),
        .src_crc(src_crc), .fifo_crc(fifo_crc), .hdmi_crc(hdmi_crc),
        .capture_flags(capture_flags), .format_bad(format_bad),
        .hdmi_count(hdmi_count), .first_high_pos_sync(first_high_pos_sync),
        .data_offset_sync(data_offset_sync)
    );

    // A pop-only bit flip must leave source CRC intact and fail the FIFO CRC.
    wire [15:0] fifo_fault_src_crc, fifo_fault_crc, fifo_fault_hdmi_crc;
    wire [3:0] fifo_fault_flags;
    wire [15:0] fifo_fault_format_bad, fifo_fault_hdmi_count;
    wire [23:0] fifo_fault_first_high, fifo_fault_data_offset;
    player_pcm_prefix_probe #(.PREFIX_SAMPLES(PREFIX), .SKIP_SAMPLES(SKIP)) u_fifo_fault_probe (
        .sd_clk(sd_clk), .pixel_clk(pixel_clk), .rst(rst),
        .push_valid(debug_sample_push), .push_data(debug_push_data),
        .push_high_pos(debug_push_pos), .data_offset(debug_data_offset),
        .pop_valid(fifo_fault_valid), .pop_data(fifo_fault_data),
        .audio_valid(audio_valid), .tone_mode(1'b0),
        .audio_left(audio_left), .audio_right(audio_right),
        .src_crc(fifo_fault_src_crc), .fifo_crc(fifo_fault_crc),
        .hdmi_crc(fifo_fault_hdmi_crc), .capture_flags(fifo_fault_flags),
        .format_bad(fifo_fault_format_bad), .hdmi_count(fifo_fault_hdmi_count),
        .first_high_pos_sync(fifo_fault_first_high), .data_offset_sync(fifo_fault_data_offset)
    );

    // An HDMI-input-only bit flip must leave source and FIFO CRC intact.
    wire [15:0] hdmi_fault_src_crc, hdmi_fault_fifo_crc, hdmi_fault_crc;
    wire [3:0] hdmi_fault_flags;
    wire [15:0] hdmi_fault_format_bad, hdmi_fault_count;
    wire [23:0] hdmi_fault_first_high, hdmi_fault_data_offset;
    player_pcm_prefix_probe #(.PREFIX_SAMPLES(PREFIX), .SKIP_SAMPLES(SKIP)) u_hdmi_fault_probe (
        .sd_clk(sd_clk), .pixel_clk(pixel_clk), .rst(rst),
        .push_valid(debug_sample_push), .push_data(debug_push_data),
        .push_high_pos(debug_push_pos), .data_offset(debug_data_offset),
        .pop_valid(fifo_fault_valid), .pop_data(player_sample_data),
        .audio_valid(audio_valid), .tone_mode(1'b0),
        .audio_left(hdmi_fault_left), .audio_right(hdmi_fault_right),
        .src_crc(hdmi_fault_src_crc), .fifo_crc(hdmi_fault_fifo_crc),
        .hdmi_crc(hdmi_fault_crc), .capture_flags(hdmi_fault_flags),
        .format_bad(hdmi_fault_format_bad), .hdmi_count(hdmi_fault_count),
        .first_high_pos_sync(hdmi_fault_first_high), .data_offset_sync(hdmi_fault_data_offset)
    );

    // A low-byte format fault leaves the high-word CRC intact but must be
    // counted once inside the capture window.
    wire [7:0] format_fault_low = (audio_event_count == SKIP + FAULT_SAMPLE) ?
        (audio_left[7:0] | 8'h01) : audio_left[7:0];
    wire [23:0] format_fault_left = {audio_left[23:8], format_fault_low};
    wire [23:0] format_fault_right = {audio_right[23:8], format_fault_low};
    wire [15:0] format_fault_src_crc, format_fault_fifo_crc, format_fault_hdmi_crc;
    wire [3:0] format_fault_flags;
    wire [15:0] format_fault_bad, format_fault_count;
    wire [23:0] format_fault_first_high, format_fault_data_offset;
    player_pcm_prefix_probe #(.PREFIX_SAMPLES(PREFIX), .SKIP_SAMPLES(SKIP)) u_format_fault_probe (
        .sd_clk(sd_clk), .pixel_clk(pixel_clk), .rst(rst),
        .push_valid(debug_sample_push), .push_data(debug_push_data),
        .push_high_pos(debug_push_pos), .data_offset(debug_data_offset),
        .pop_valid(fifo_fault_valid), .pop_data(player_sample_data),
        .audio_valid(audio_valid), .tone_mode(1'b0),
        .audio_left(format_fault_left), .audio_right(format_fault_right),
        .src_crc(format_fault_src_crc), .fifo_crc(format_fault_fifo_crc),
        .hdmi_crc(format_fault_hdmi_crc), .capture_flags(format_fault_flags),
        .format_bad(format_fault_bad), .hdmi_count(format_fault_count),
        .first_high_pos_sync(format_fault_first_high), .data_offset_sync(format_fault_data_offset)
    );

    // Early tone switches only this observer. It must abort the HDMI prefix,
    // while the real bridge and all three other observer instances keep running.
    wire [15:0] abort_src_crc, abort_fifo_crc, abort_hdmi_crc;
    wire [3:0] abort_flags;
    wire [15:0] abort_format_bad, abort_hdmi_count;
    wire [23:0] abort_first_high, abort_data_offset;
    always @(posedge pixel_clk or posedge rst) begin
        if (rst) begin
            early_event_count <= 0;
            early_tone_mode <= 1'b0;
        end else if (audio_valid) begin
            early_event_count <= early_event_count + 1;
            if (early_event_count == 40) early_tone_mode <= 1'b1;
        end
    end
    player_pcm_prefix_probe #(.PREFIX_SAMPLES(PREFIX), .SKIP_SAMPLES(SKIP)) u_abort_probe (
        .sd_clk(sd_clk), .pixel_clk(pixel_clk), .rst(rst),
        .push_valid(debug_sample_push), .push_data(debug_push_data),
        .push_high_pos(debug_push_pos), .data_offset(debug_data_offset),
        .pop_valid(fifo_fault_valid), .pop_data(player_sample_data),
        .audio_valid(audio_valid), .tone_mode(early_tone_mode),
        .audio_left(audio_left), .audio_right(audio_right),
        .src_crc(abort_src_crc), .fifo_crc(abort_fifo_crc), .hdmi_crc(abort_hdmi_crc),
        .capture_flags(abort_flags), .format_bad(abort_format_bad),
        .hdmi_count(abort_hdmi_count), .first_high_pos_sync(abort_first_high),
        .data_offset_sync(abort_data_offset)
    );

    // SD model: complete 512-byte sectors, with deterministic valid-low gaps.
    // Poison padding after file_size catches an accidental logical EOF overread.
    always @(negedge sd_clk) begin
        sd_valid <= 1'b0;
        sd_end <= 1'b0;
        if (rst) begin
            servicing <= 0;
            service_index <= 0;
            service_gap <= 0;
            sd_data <= 0;
        end else if (servicing != 0) begin
            if (service_gap != 0) begin
                service_gap <= service_gap - 1;
            end else if (service_index < 512) begin
                sd_data <= wav_image[service_sector * 512 + service_index];
                sd_valid <= 1'b1;
                service_index <= service_index + 1;
                if ((service_index % 41) == 7) service_gap <= 2;
            end else begin
                sd_end <= 1'b1;
                servicing <= 0;
            end
        end else if (sd_read) begin
            servicing <= 1;
            service_index <= 0;
            service_sector <= sd_addr;
        end
    end

    always @(posedge sd_clk) begin
        if (rst) begin
            pop_event_count <= 0;
            push_event_count <= 0;
        end else begin
            if (sample_take && player_sample_available)
                pop_event_count <= pop_event_count + 1'b1;
            if (debug_sample_push)
                push_event_count <= push_event_count + 1'b1;
        end
    end

    always @(posedge pixel_clk) begin
        if (rst) audio_event_count <= 0;
        else if (audio_valid) audio_event_count <= audio_event_count + 1'b1;
    end

    task fail(input [8*180-1:0] message);
        begin
            $display("FAIL: %0s", message);
            errors = errors + 1;
        end
    endtask

    initial begin
        $readmemh("input.hex", wav_image);
        $readmemh("reference.hex", reference);
        $readmemh("real_stream.hex", real_stream);
        $readmemh("real_reference.hex", real_reference);
        repeat (5) @(negedge real_clk);
        real_rst = 1'b0;
        #3;
        repeat (6) @(negedge sd_clk);
        rst = 1'b0;
        sd_init_done = 1'b1;
        file_size = reference[8];

        timeout_cycles = 0;
        while ((!capture_flags[0] || !fifo_fault_flags[0] || !hdmi_fault_flags[0]) &&
               !player_error && timeout_cycles < 1200000) begin
            @(posedge pixel_clk);
            timeout_cycles = timeout_cycles + 1;
        end
        if (player_error) fail("WAV player raised error");
        if (timeout_cycles >= 1200000) fail("timeout waiting for three prefix captures");

        if (src_crc !== reference[4] || fifo_crc !== reference[4] || hdmi_crc !== reference[4])
            fail("nominal source/FIFO/HDMI CRC did not match Python prefix");
        if (reference[9] !== SKIP) fail("scaled probe skip count/reference mismatch");
        if (hdmi_count !== PREFIX[15:0]) fail("nominal HDMI sample count mismatch");
        if (format_bad !== 0) fail("nominal HDMI format checks failed");
        if (underflow) fail("integrated player/bridge underflowed during the scaled prefix");
        if (!capture_flags[1] || !capture_flags[2]) fail("source/FIFO done CDC flags missing");
        if (first_high_pos_sync !== reference[1] || data_offset_sync !== reference[0])
            fail("absolute first sample offset did not synchronize correctly");
        if (push_event_count < PREFIX || pop_event_count < PREFIX || audio_event_count < PREFIX)
            fail("one or more source streams ended before the requested prefix");

        if (fifo_fault_src_crc !== reference[4] || fifo_fault_crc !== reference[5] ||
            fifo_fault_hdmi_crc !== reference[4])
            fail("pop-word fault was not isolated to FIFO-stage CRC");
        if (fifo_fault_format_bad !== 0) fail("pop-word high-bit fault unexpectedly hit format checks");

        if (hdmi_fault_src_crc !== reference[4] || hdmi_fault_fifo_crc !== reference[4] ||
            hdmi_fault_crc !== reference[5])
            fail("HDMI-input fault was not isolated to HDMI-stage CRC");
        if (hdmi_fault_format_bad !== 0) fail("equal stereo HDMI word fault unexpectedly hit format checks");

        if (!abort_flags[3] || abort_flags[0] || abort_hdmi_count >= PREFIX)
            fail("early tone did not permanently abort the HDMI prefix");

        if (!real_done || real_count !== REAL_PREFIX || real_crc !== real_reference[0] ||
            real_crc !== 16'hF485)
            fail("full-parameter direct CRC did not match the host TEST.WAV window");
        if (real_reference[1] !== 16'd44 || real_reference[2] !== 16'h002D)
            fail("host TEST.WAV data/first-window high-byte offsets changed");
        if (real_reference[3] !== 16'h0002)
            fail("host TEST.WAV first-window high-byte offset upper bits changed");

        if (format_fault_src_crc !== reference[4] || format_fault_fifo_crc !== reference[4] ||
            format_fault_hdmi_crc !== reference[4] || format_fault_bad !== 1)
            fail("format-only fault was not counted once while leaving PCM high-word CRC unchanged");

        // Once captured, the prefix must remain frozen even if tone mode changes.
        frozen_src_crc = src_crc;
        frozen_fifo_crc = fifo_crc;
        frozen_hdmi_crc = hdmi_crc;
        frozen_hdmi_count = hdmi_count;
        nominal_tone_mode = 1'b1;
        post_tone_target = audio_event_count + 12;
        while (audio_event_count < post_tone_target) @(posedge pixel_clk);
        if (src_crc !== frozen_src_crc || fifo_crc !== frozen_fifo_crc || hdmi_crc !== frozen_hdmi_crc)
            fail("completed prefix CRC changed after tone-mode switch");
        if (capture_flags[3] || hdmi_count !== frozen_hdmi_count)
            fail("tone after completion changed abort flag or frozen HDMI count");

        $display("prefix expected=%04h src=%04h fifo=%04h hdmi=%04h count=%0d first_high=%0d data_offset=%0d",
            reference[4], src_crc, fifo_crc, hdmi_crc, hdmi_count,
            first_high_pos_sync, data_offset_sync);
        $display("fault pop: src=%04h fifo=%04h hdmi=%04h expected_fault=%04h",
            fifo_fault_src_crc, fifo_fault_crc, fifo_fault_hdmi_crc, reference[5]);
        $display("fault HDMI: src=%04h fifo=%04h hdmi=%04h expected_fault=%04h",
            hdmi_fault_src_crc, hdmi_fault_fifo_crc, hdmi_fault_crc, reference[5]);
        $display("format fault: crc=%04h format_bad=%0d", format_fault_hdmi_crc, format_fault_bad);
        $display("real full-parameter direct: crc=%04h count=%0d done=%b input-events=%0d",
            real_crc, real_count, real_done, real_input_index);

        if (errors != 0) $fatal(1, "tb_pcm_prefix_pipeline: %0d failure(s)", errors);
        $display("PASS tb_pcm_prefix_pipeline");
        $finish;
    end

    initial begin
        #300000000;
        $fatal(1, "tb_pcm_prefix_pipeline watchdog");
    end

endmodule
