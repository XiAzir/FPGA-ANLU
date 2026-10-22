`timescale 1ns/1ps
module schedule_osd_tb;
    reg sd_clk = 1'b0;
    reg pixel_clk = 1'b0;
    reg rst = 1'b1;
    reg enable = 1'b0;
    reg catalog_ready = 1'b1;
    reg video_found = 1'b1;
    reg wav_primed = 1'b0;
    reg file_ready = 1'b0;
    reg reader_frame_sent = 1'b0;
    reg decoder_idle = 1'b1;
    reg write_finish_toggle = 1'b0;
    reg sample_take = 1'b0;
    reg read_req = 1'b0;
    reg read_req_ack = 1'b0;
    reg [1:0] source_image = 2'd0;
    reg [2:0] source_count = 3'd1;
    reg source_auto = 1'b0;
    reg source_video = 1'b1;

    wire reader_start;
    wire reader_next;
    wire decoder_reset;
    wire write_req;
    wire write_req_ack;
    wire [1:0] write_buffer;
    wire [1:0] display_buffer;
    wire display_valid;
    wire audio_go;
    wire [3:0] state_code;
    wire [8:0] displayed_frame;
    wire frame_late;
    wire [1:0] display_finish_toggle;
    wire read_req_out;
    wire [1:0] osd_buffer;
    wire [1:0] osd_image;
    wire [2:0] osd_count;
    wire osd_auto;
    wire osd_valid;
    wire wipe_active;
    wire [8:0] wipe_rows;
    wire [1:0] wipe_new_buffer;

    integer total_audio_samples = 0;
    integer total_formal_frames = 0;
    integer total_reader_frames = 0;
    integer read_transactions = 0;
    integer late_injections = 0;
    integer reader_next_count = 0;
    integer reader_next_consumed = 0;
    integer phase_epoch = 0;
    integer phase_reader_frames = 0;
    integer phase_frame = 0;
    reg read_req_prev = 1'b0;
    reg read_guard = 1'b0;
    reg [1:0] guarded_buffer = 2'b00;
    reg [1:0] guarded_finish_toggle = 2'b00;
    reg saw_initial_commit = 1'b0;

    always #5 sd_clk = ~sd_clk;
    always #7 pixel_clk = ~pixel_clk;

    // Count the one-cycle scheduler request so procedural tasks cannot miss it.
    always @(posedge sd_clk) begin
        if (rst) reader_next_count <= 0;
        else if (reader_next) reader_next_count <= reader_next_count + 1;
    end

    player_video_schedule u_schedule (
        .clk(sd_clk), .rst(rst), .enable(enable),
        .catalog_ready(catalog_ready), .video_found(video_found),
        .wav_primed(wav_primed), .file_ready(file_ready),
        .reader_frame_sent(reader_frame_sent), .decoder_idle(decoder_idle),
        .reader_start(reader_start), .reader_next(reader_next),
        .decoder_reset(decoder_reset),
        .write_finish_toggle(write_finish_toggle),
        .display_finish_toggle(display_finish_toggle[1]),
        .sample_take(sample_take), .write_req(write_req),
        .write_req_ack(write_req_ack), .write_buffer(write_buffer),
        .display_buffer(display_buffer), .display_valid(display_valid),
        .audio_go(audio_go), .state_code(state_code),
        .displayed_frame(displayed_frame), .frame_late(frame_late)
    );

    player_osd_state #(.FRAME_HEIGHT(480), .WIPE_STEP_ROWS(8)) u_osd (
        .sd_clk(sd_clk), .pixel_clk(pixel_clk), .rst(rst),
        .source_buffer(display_buffer), .source_image(source_image),
        .source_count(source_count), .source_auto(source_auto),
        .source_valid(display_valid), .source_video(source_video),
        .read_req(read_req), .read_req_ack(read_req_ack),
        .read_req_out(read_req_out), .frame_buffer(osd_buffer),
        .frame_image(osd_image), .frame_count(osd_count),
        .frame_auto(osd_auto), .frame_valid(osd_valid),
        .wipe_active(wipe_active), .wipe_rows(wipe_rows),
        .wipe_new_buffer(wipe_new_buffer),
        .display_finish_toggle(display_finish_toggle[0])
    );

    assign display_finish_toggle[1] = display_finish_toggle[0];

    // Fake write-request acknowledgement, sampled on the opposite clock edge.
    reg write_ack_drive = 1'b0;
    assign write_req_ack = write_ack_drive;
    always @(negedge sd_clk or posedge rst) begin
        if (rst) write_ack_drive <= 1'b0;
        else write_ack_drive <= write_req;
    end

    // Ownership checks run continuously in both clock domains.
    always @(posedge sd_clk) begin
        #1;
        if (!rst) begin
            if (display_valid && !wav_primed && !audio_go)
                $fatal(1, "display became valid before WAV prime");
            if ((state_code == 4 || state_code == 5) &&
                display_valid && write_buffer == display_buffer)
                $fatal(1, "writer reused the buffer still owned by display");
            if (audio_go && !saw_initial_commit)
                $fatal(1, "audio_go rose before initial display commit/read ACK");
        end
    end

    always @(posedge pixel_clk) begin
        #1;
        if (rst) begin
            read_req_prev = 1'b0;
            read_guard = 1'b0;
        end else begin
            if (read_req && !read_req_prev) begin
                if (!osd_valid)
                    $fatal(1, "pixel read began before OSD frame was valid");
                if (osd_buffer !== display_buffer)
                    $fatal(1, "OSD owner does not match committed display buffer");
                guarded_buffer = osd_buffer;
                guarded_finish_toggle = display_finish_toggle;
                read_guard = 1'b1;
                read_transactions = read_transactions + 1;
            end
            if (read_guard) begin
                if (osd_buffer !== guarded_buffer || display_buffer !== guarded_buffer)
                    $fatal(1, "frame buffer ownership changed before display ACK");
                if (display_finish_toggle !== guarded_finish_toggle)
                    read_guard = 1'b0;
            end
            read_req_prev = read_req;
        end
    end

    task reset_and_start;
        begin
            @(negedge sd_clk);
            rst = 1'b1;
            enable = 1'b0;
            file_ready = 1'b0;
            wav_primed = 1'b0;
            sample_take = 1'b0;
            reader_frame_sent = 1'b0;
            saw_initial_commit = 1'b0;
            decoder_idle = 1'b1;
            write_finish_toggle = 1'b0;
            read_req = 1'b0;
            read_req_ack = 1'b0;
            repeat (8) @(posedge sd_clk);
            repeat (8) @(posedge pixel_clk);
            #1;
            if (display_valid || audio_go || displayed_frame != 0 || frame_late)
                $fatal(1, "reset failed to clear scheduler state");
            phase_epoch = 0;
            phase_reader_frames = 0;
            reader_next_consumed = 0;
            source_image = 2'd0;
            source_count = 3'd1;
            @(negedge sd_clk);
            rst = 1'b0;
            enable = 1'b1;
            file_ready = 1'b0;
            wav_primed = 1'b0;
        end
    endtask

    task send_reader_frame;
        input integer inject_late;
        begin
            wait (reader_next_count > reader_next_consumed);
            reader_next_consumed = reader_next_consumed + 1;
            @(negedge sd_clk);
            decoder_idle = 1'b0;
            wait (state_code == 4'd4);
            @(negedge sd_clk);
            reader_frame_sent = 1'b1;
            @(negedge sd_clk);
            reader_frame_sent = 1'b0;
            total_reader_frames = total_reader_frames + 1;
            phase_reader_frames = phase_reader_frames + 1;
            repeat (8) @(negedge sd_clk);
            write_finish_toggle = ~write_finish_toggle;
            if (!inject_late) decoder_idle = 1'b1;
        end
    endtask

    task finish_display_read;
        input [1:0] expected_buffer;
        reg [1:0] saved_finish;
        begin
            wait ((u_osd.latest_pixel[8] === 1'b1) &&
                  (u_osd.latest_pixel[7:6] === expected_buffer));
            repeat (2) @(posedge pixel_clk);
            #1;
            if (display_buffer !== expected_buffer)
                $fatal(1, "scheduler buffer changed before pixel read");
            saved_finish = display_finish_toggle;
            @(negedge pixel_clk);
            read_req = 1'b1;
            wait (u_osd.frame_edge === 1'b1);
            @(posedge pixel_clk);
            #1;
            if (!osd_valid || osd_buffer !== expected_buffer)
                $fatal(1, "OSD publish mismatch valid=%b osd_buffer=%0d expected=%0d source_valid=%b source_buffer=%0d held=%h latest=%h request=%b ack=%b req_sync=%b ack_sync=%b",
                       osd_valid, osd_buffer, expected_buffer, display_valid, display_buffer,
                       u_osd.held_sd, u_osd.latest_pixel, u_osd.request_sd,
                       u_osd.acknowledge_pixel, u_osd.req_sync_pixel, u_osd.ack_sync_sd);
            wait (read_req_out === 1'b1);
            repeat (2) @(negedge pixel_clk);
            read_req_ack = 1'b1;
            repeat (3) @(negedge pixel_clk);
            read_req = 1'b0;
            repeat (5) @(negedge pixel_clk);
            read_req_ack = 1'b0;
            wait (display_finish_toggle !== saved_finish);
            repeat (8) @(posedge sd_clk);
            #1;
        end
    endtask

    task prime_initial_frame;
        reg [1:0] first_buffer;
        begin
            wait (reader_start === 1'b1);
            @(negedge sd_clk);
            file_ready = 1'b1;
            send_reader_frame(0);
            wait (state_code == 4'd5);
            repeat (12) begin
                @(posedge sd_clk);
                #1;
                if (display_valid || audio_go)
                    $fatal(1, "initial frame escaped before WAV prime");
            end
            @(negedge sd_clk);
            wav_primed = 1'b1;
            wait (display_valid === 1'b1);
            first_buffer = display_buffer;
            saw_initial_commit = 1'b1;
            finish_display_read(first_buffer);
            if (!audio_go || displayed_frame != 0)
                $fatal(1, "initial read ACK did not start audio at frame zero");
        end
    endtask

    task run_audio_source_frame;
        input integer pause_samples;
        input integer inject_late;
        reg [1:0] old_buffer;
        reg [8:0] old_displayed_frame;
        integer sample_index;
        begin
            old_buffer = display_buffer;
            old_displayed_frame = displayed_frame;
            for (sample_index = 0; sample_index < 3200; sample_index = sample_index + 1) begin
                @(negedge sd_clk);
                if (pause_samples && sample_index == 10) begin
                    sample_take = 1'b0;
                    repeat (50) begin
                        @(posedge sd_clk);
                        #1;
                        if (display_buffer !== old_buffer || displayed_frame !== old_displayed_frame)
                            $fatal(1, "display advanced while audio samples were paused");
                        if (u_schedule.frame_due)
                            $fatal(1, "frame became due while sample_take was paused");
                    end
                end
                sample_take = 1'b1;
                @(posedge sd_clk);
                #1;
                total_audio_samples = total_audio_samples + 1;
                if (sample_index < 3199 && display_buffer !== old_buffer)
                    $fatal(1, "source frame switched before 3200 samples");
            end
            @(negedge sd_clk);
            sample_take = 1'b0;
            phase_epoch = phase_epoch + 1;
            source_count = phase_epoch[2:0];
            source_image = phase_epoch[1:0];
            total_formal_frames = total_formal_frames + 1;
            if (u_schedule.sample_in_frame !== 0 || !u_schedule.frame_due)
                $fatal(1, "frame deadline did not occur at exactly sample 3200");
            if (inject_late) begin
                if (!frame_late || state_code != 4'd4)
                    $fatal(1, "late frame was not detected while decoder was busy");
                late_injections = late_injections + 1;
                decoder_idle = 1'b1;
            end
            repeat (5) @(posedge sd_clk);
            if (phase_reader_frames != phase_epoch + 1)
                $fatal(1, "reader frame count advanced without one 3200-sample epoch");
        end
    endtask

    task run_phase;
        input integer inject_late_on_frame;
        input integer pause_first_frame;
        integer frame_index;
        reg [1:0] target_buffer;
        integer expected_display_count;
        begin
            for (frame_index = 0; frame_index < 301; frame_index = frame_index + 1) begin
                target_buffer = write_buffer;
                send_reader_frame(frame_index == inject_late_on_frame);
                run_audio_source_frame(
                    pause_first_frame && frame_index == 0,
                    frame_index == inject_late_on_frame
                );
                wait (display_buffer == target_buffer && state_code == 4'd6);
                if (phase_reader_frames != phase_epoch + 1)
                    $fatal(1, "reader/source frame epoch mismatch at commit");
                if (inject_late_on_frame >= 0 && frame_index > inject_late_on_frame && !frame_late)
                    $fatal(1, "sticky frame_late cleared before reset");
                if (inject_late_on_frame < 0 && frame_late)
                    $fatal(1, "unexpected late flag after reset");
                finish_display_read(target_buffer);
                expected_display_count = ((frame_index + 1) % 300);
                if (displayed_frame !== expected_display_count[8:0])
                    $fatal(1, "300-frame counter mismatch phase frame=%0d got=%0d expected=%0d",
                           frame_index + 1, displayed_frame, expected_display_count);
                if (((frame_index + 1) % 50) == 0 || frame_index == 300)
                    $display("SCHEDULE_PROGRESS phase_epoch=%0d phase_frame=%0d total_frames=%0d reads=%0d time=%0t",
                             phase_epoch, frame_index + 1, total_formal_frames,
                             read_transactions, $time);
            end
        end
    endtask

    initial begin
        #100_000_000;
        $fatal(1, "GLOBAL WATCHDOG timeout formal_frames=%0d samples=%0d reader_frames=%0d reads=%0d",
               total_formal_frames, total_audio_samples, total_reader_frames, read_transactions);
    end

    initial begin
        repeat (8) @(posedge sd_clk);
        repeat (8) @(posedge pixel_clk);
        @(negedge sd_clk);
        rst = 1'b0;
        enable = 1'b1;
        prime_initial_frame();
        run_phase(10, 1);
        if (!frame_late)
            $fatal(1, "late flag did not remain sticky through first 301-frame phase");

        reset_and_start();
        if (frame_late)
            $fatal(1, "reset did not clear sticky late flag");
        prime_initial_frame();
        run_phase(-1, 0);
        if (frame_late)
            $fatal(1, "second phase injected an unexpected late frame");

        if (total_formal_frames != 602 || total_audio_samples != 602*3200)
            $fatal(1, "formal frame/sample totals mismatch frames=%0d samples=%0d",
                   total_formal_frames, total_audio_samples);
        if (late_injections != 1)
            $fatal(1, "expected one late injection, got %0d", late_injections);
        if (read_transactions != 604)
            $fatal(1, "display read count mismatch: %0d", read_transactions);
        $display("SCHEDULE_OSD_PASS formal_frames=%0d audio_samples=%0d reader_frames=%0d reads=%0d late_injections=1",
                 total_formal_frames, total_audio_samples, total_reader_frames, read_transactions);
        $finish;
    end
endmodule
