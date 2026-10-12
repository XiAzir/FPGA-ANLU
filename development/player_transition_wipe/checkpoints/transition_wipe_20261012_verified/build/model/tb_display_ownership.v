`timescale 1ns/1ps
module tb_display_ownership;
    reg sd_clk = 0, pixel_clk = 0, mem_clk = 0, rst = 1;
    always #7 sd_clk = ~sd_clk;
    always #5 pixel_clk = ~pixel_clk;
    always #11 mem_clk = ~mem_clk;

    reg [1:0] source_buffer = 0, source_image = 0;
    reg [2:0] source_count = 1;
    reg source_auto = 0, source_valid = 0;
    reg read_req = 0, read_req_ack = 0;
    wire read_req_out;
    wire [1:0] frame_buffer, frame_image, wipe_new_buffer;
    wire [2:0] frame_count;
    wire frame_auto, frame_valid, wipe_active;
    wire [8:0] wipe_rows;
    wire display_finish_toggle;

    player_osd_state #(.FRAME_HEIGHT(16), .WIPE_STEP_ROWS(8)) osd (
        .sd_clk(sd_clk), .pixel_clk(pixel_clk), .rst(rst),
        .source_buffer(source_buffer), .source_image(source_image),
        .source_count(source_count), .source_auto(source_auto), .source_valid(source_valid),
        .read_req(read_req), .read_req_ack(read_req_ack), .read_req_out(read_req_out),
        .frame_buffer(frame_buffer), .frame_image(frame_image), .frame_count(frame_count),
        .frame_auto(frame_auto), .frame_valid(frame_valid), .wipe_active(wipe_active),
        .wipe_rows(wipe_rows), .wipe_new_buffer(wipe_new_buffer),
        .display_finish_toggle(display_finish_toggle)
    );

    reg key_next = 0, key_auto = 0, catalog_ready = 0;
    reg [2:0] bmp_count = 0;
    reg [127:0] bmp_clusters = 0, bmp_sizes = 0;
    reg [7:0] card_data = 0;
    reg card_valid = 0, card_end = 0, file_error = 0;
    reg write_finish_toggle = 0, write_req_ack = 0;
    wire [31:0] file_cluster, file_size, card_addr;
    wire card_read, write_en, display_valid, error, auto_mode;
    wire [23:0] write_data;
    wire [1:0] write_buf_idx, disp_buf_idx, current_image_index;
    wire write_req;
    wire [3:0] state_code;

    tf_bmp_file_player #(.CLK_FREQ_HZ(1000), .FRAME_WIDTH(4), .FRAME_HEIGHT(4), .WAIT_LIMIT(4)) loader (
        .clk(sd_clk), .rst(rst), .key_next(key_next), .key_auto(key_auto),
        .catalog_ready(catalog_ready), .bmp_count(bmp_count),
        .bmp_clusters(bmp_clusters), .bmp_sizes(bmp_sizes),
        .file_cluster(file_cluster), .file_size(file_size), .card_read(card_read), .card_addr(card_addr),
        .card_data(card_data), .card_valid(card_valid), .card_end(card_end), .file_error(file_error),
        .write_finish_toggle(write_finish_toggle), .display_finish_toggle(display_finish_toggle),
        .write_buf_idx(write_buf_idx), .disp_buf_idx(disp_buf_idx), .write_req(write_req),
        .write_req_ack(write_req_ack), .write_en(write_en), .write_data(write_data),
        .display_valid(display_valid), .error(error), .state_code(state_code),
        .current_image_index(current_image_index), .auto_mode(auto_mode)
    );

    task tick_pixel;
        begin @(posedge pixel_clk); #1; end
    endtask
    task publish_source(input [1:0] buf_idx, input [1:0] img_idx,
                        input [2:0] count_value, input auto_value);
        begin
            @(negedge sd_clk);
            source_buffer = buf_idx; source_image = img_idx;
            source_count = count_value; source_auto = auto_value; source_valid = 1;
            repeat (20) @(posedge pixel_clk);
            #1;
        end
    endtask
    task frame_start;
        begin
            @(negedge pixel_clk); read_req = 1;
            tick_pixel();
            @(negedge pixel_clk); read_req = 0;
            tick_pixel();
        end
    endtask
    task pulse_delayed_ack;
        begin
            // Raw request and delayed output are both withdrawn before the
            // memory-domain ACK returns and traverses the two pixel flops.
            repeat (2) tick_pixel();
            @(negedge mem_clk); read_req_ack = 1;
            repeat (4) tick_pixel();
            @(negedge mem_clk); read_req_ack = 0;
            repeat (3) tick_pixel();
        end
    endtask
    task check(input condition, input [8*96-1:0] message);
        begin
            if (!condition) begin $display("FAIL %0s", message); $fatal(1); end
        end
    endtask

    reg finish_before;
    initial begin
        repeat (4) tick_pixel();
        @(negedge pixel_clk); rst = 0;
        repeat (5) tick_pixel();

        // Initial image is shown whole, with one completion only after ACK.
        publish_source(0, 0, 1, 0);
        frame_start();
        check(frame_valid && frame_buffer == 0 && frame_image == 0 && !wipe_active,
              "first image displays directly");
        finish_before = display_finish_toggle;
        pulse_delayed_ack();
        check(display_finish_toggle != finish_before, "initial read ACK releases once");
        finish_before = display_finish_toggle;

        // Distinct source starts an 8-row wipe but keeps old buffer/image.
        publish_source(1, 1, 2, 0);
        frame_start();
        check(wipe_active && wipe_rows == 8 && wipe_new_buffer == 1,
              "first wipe boundary advances eight rows");
        check(frame_buffer == 0 && frame_image == 0 && frame_count == 2,
              "old source identity and latest labels are held");

        // Mailbox count/auto updates during wipe; identity remains locked.
        publish_source(1, 1, 3, 1);
        frame_start();
        check(!wipe_active && wipe_rows == 0 && frame_buffer == 1 && frame_image == 1,
              "height threshold commits target");
        check(frame_count == 3 && frame_auto, "final frame uses latest labels");
        finish_before = display_finish_toggle;
        pulse_delayed_ack();
        check(display_finish_toggle != finish_before, "final memory ACK releases exactly once");
        finish_before = display_finish_toggle;
        repeat (5) tick_pixel();
        check(display_finish_toggle == finish_before, "release does not repeat after ACK");

        // Re-publishing identical identity refreshes metadata only.
        publish_source(1, 1, 4, 0);
        frame_start();
        check(!wipe_active && frame_buffer == 1 && frame_image == 1 && frame_count == 4,
              "same source does not animate");
        check(display_finish_toggle == finish_before, "same source does not ACK as a transition");

        // Loader enters WAIT_DISPLAY after COMMIT and cannot timeout or start
        // a second load while the pixel-domain toggle is absent.
        @(negedge sd_clk);
        loader.state = 4'd7; loader.write_done = 0;
        loader.pending_buffer = 1; loader.load_index = 1;
        @(posedge sd_clk); #1;
        check(state_code == 4'd7, "loader waits for synchronized write completion");
        @(negedge sd_clk); write_finish_toggle = 1;
        repeat (5) @(posedge sd_clk);
        #1;
        check(state_code == 4'd9 && disp_buf_idx == 1 && display_valid,
              "loader publishes then waits for display finish");
        @(negedge sd_clk); loader.next_pending = 1; loader.auto_enabled = 1;
        repeat (10) begin @(posedge sd_clk); #1; check(state_code == 4'd9,
              "WAIT_DISPLAY ignores loading watchdog"); end
        check(loader.next_pending && loader.auto_enabled && loader.auto_count == 0,
              "queued-next and auto state are retained without counting in wait");
        finish_before = display_finish_toggle;
        // Return one display completion toggle and wait for the loader 3FF.
        @(negedge pixel_clk); osd.display_finish_toggle = ~osd.display_finish_toggle;
        repeat (5) @(posedge sd_clk);
        #1 check(state_code == 4'd1, "loader resumes only after synchronized display finish");

        // Error before commit cannot publish a source bundle.
        @(negedge sd_clk); rst = 1;
        repeat (3) @(posedge sd_clk);
        @(negedge sd_clk); rst = 0; file_error = 1; catalog_ready = 1;
        repeat (3) @(posedge sd_clk);
        #1 check(error && !display_valid, "loader error never publishes image");

        $display("PASS tb_display_ownership");
        $finish;
    end
endmodule
