`timescale 1ns/1ps

// Integration audit for the real C11318 loader plus its appended CDC sink.
// State deposits are test-only shortcuts to loader states; request toggles
// always traverse the actual key_event_mailbox_sink instance.
module tb_loader_event;
    reg clk = 1'b0;
    always #10 clk = ~clk;

    reg rst = 1'b1;
    reg next_req_toggle = 1'b0;
    reg auto_req_toggle = 1'b0;
    wire next_ack_toggle;
    wire auto_ack_toggle;
    reg catalog_ready = 1'b0;
    reg [2:0] bmp_count = 3'd0;
    reg [127:0] bmp_clusters = 128'd0;
    reg [127:0] bmp_sizes = 128'd0;
    wire [31:0] file_cluster;
    wire [31:0] file_size;
    wire card_read;
    wire [31:0] card_addr;
    reg [7:0] card_data = 8'd0;
    reg card_valid = 1'b0;
    reg card_end = 1'b0;
    reg file_error = 1'b0;
    reg write_finish_toggle = 1'b0;
    reg display_finish_toggle = 1'b0;
    wire [1:0] write_buf_idx;
    wire [1:0] disp_buf_idx;
    wire write_req;
    reg write_req_ack = 1'b0;
    reg write_ready = 1'b1;
    wire write_en;
    wire [23:0] write_data;
    wire display_valid;
    wire error;
    wire [3:0] state_code;
    wire [1:0] current_image_index;
    wire auto_mode;
    wire [23:0] failure_detail;

    integer next_events = 0;
    integer auto_events = 0;
    integer saw_wait_catalog_pending = 0;
    integer saw_idle_pending = 0;
    integer saw_payload_pending = 0;
    integer saw_finish_event_collision = 0;
    integer checks = 0;
    integer timeout_count;
    integer target_toggle;
    integer pre_reset_next_events;
    integer pre_reset_auto_events;

    tf_bmp_file_player #(.CLK_FREQ_HZ(16), .WAIT_LIMIT(1000)) dut (
        .clk(clk), .rst(rst),
        .key_next_req_toggle(next_req_toggle), .key_auto_req_toggle(auto_req_toggle),
        .key_next_ack_toggle(next_ack_toggle), .key_auto_ack_toggle(auto_ack_toggle),
        .catalog_ready(catalog_ready), .bmp_count(bmp_count),
        .bmp_clusters(bmp_clusters), .bmp_sizes(bmp_sizes),
        .file_cluster(file_cluster), .file_size(file_size),
        .card_read(card_read), .card_addr(card_addr),
        .card_data(card_data), .card_valid(card_valid), .card_end(card_end),
        .file_error(file_error), .write_finish_toggle(write_finish_toggle),
        .display_finish_toggle(display_finish_toggle),
        .write_buf_idx(write_buf_idx), .disp_buf_idx(disp_buf_idx),
        .write_req(write_req), .write_req_ack(write_req_ack), .write_ready(write_ready),
        .write_en(write_en), .write_data(write_data),
        .display_valid(display_valid), .error(error), .state_code(state_code),
        .current_image_index(current_image_index), .auto_mode(auto_mode),
        .failure_detail(failure_detail)
    );

    always @(posedge clk) begin
        if (!rst) begin
            if (dut.u_key_event_mailbox.next_press) next_events = next_events + 1;
            if (dut.u_key_event_mailbox.auto_press) auto_events = auto_events + 1;
            if (dut.state == 4'd1 && dut.next_pending) saw_idle_pending = 1;
            if (dut.state == 4'd5 && dut.next_pending) saw_payload_pending = 1;
            if (dut.state == 4'd9 && dut.display_finish_pulse &&
                dut.u_key_event_mailbox.next_press)
                saw_finish_event_collision = 1;
        end
        #1;
        if (!rst && dut.state == 4'd1 && dut.next_pending)
            saw_wait_catalog_pending = 1;
    end

    task tick;
        input integer count;
        integer i;
        begin
            for (i = 0; i < count; i = i + 1) @(posedge clk);
            #2;
        end
    endtask

    task check;
        input condition;
        input [8*120-1:0] label_text;
        begin
            checks = checks + 1;
            if (condition !== 1'b1) begin
                $display("FAIL %0s at %0t state=%0d pending=%0d next=%0d/%0d auto=%0d/%0d",
                         label_text, $time, dut.state, dut.next_pending,
                         next_req_toggle, next_ack_toggle,
                         auto_req_toggle, auto_ack_toggle);
                $fatal(1);
            end
        end
    endtask

    task issue_next;
        integer target;
        begin
            @(negedge clk);
            next_req_toggle = ~next_req_toggle;
            target = next_req_toggle;
            timeout_count = 0;
            while (next_ack_toggle !== target && timeout_count < 20) begin
                @(posedge clk);
                #1;
                timeout_count = timeout_count + 1;
            end
            #1;
            check(next_ack_toggle === target, "next sink acknowledges held request toggle");
            tick(2);
        end
    endtask

    task issue_auto;
        integer target;
        begin
            @(negedge clk);
            auto_req_toggle = ~auto_req_toggle;
            target = auto_req_toggle;
            timeout_count = 0;
            while (auto_ack_toggle !== target && timeout_count < 20) begin
                @(posedge clk);
                #1;
                timeout_count = timeout_count + 1;
            end
            #1;
            check(auto_ack_toggle === target, "auto sink acknowledges held request toggle");
            tick(2);
        end
    endtask

    task issue_next_with_same_edge_finish;
        integer target;
        begin
            @(negedge clk);
            next_req_toggle = ~next_req_toggle;
            target = next_req_toggle;
            // Offset the finish toggle by one source clock so its synchronized
            // pulse overlaps the sink's one-cycle next_press at the loader.
            @(negedge clk);
            display_finish_toggle = ~display_finish_toggle;
            timeout_count = 0;
            while (next_ack_toggle !== target && timeout_count < 20) begin
                @(posedge clk);
                #1;
                timeout_count = timeout_count + 1;
            end
            #1;
            check(next_ack_toggle === target, "collision request receives acknowledgement");
            tick(1);
        end
    endtask

    initial begin
        tick(4);
        check(dut.state == 4'd0 && dut.next_pending == 1'b0, "reset enters WAIT_CATALOG with empty queue");
        rst = 1'b0;
        tick(4);
        check(next_events == 0 && auto_events == 0, "release from reset creates no phantom event");

        // Requests while the catalog is unavailable are acknowledged at the
        // CDC boundary, then discarded by the existing loader qualification.
        issue_next;
        check(dut.next_pending == 1'b0, "WAIT_CATALOG ignores next event without catalog");
        check(dut.state == 4'd0, "loader remains in WAIT_CATALOG without catalog");
        issue_auto;
        check(dut.auto_enabled == 1'b0, "WAIT_CATALOG ignores auto event without catalog");

        // A request accepted in WAIT_CATALOG is retained as the state advances
        // to IDLE and then starts the first image transaction.
        bmp_count = 3'd2;
        @(negedge clk);
        next_req_toggle = ~next_req_toggle;
        target_toggle = next_req_toggle;
        timeout_count = 0;
        while (next_ack_toggle !== target_toggle && timeout_count < 20) begin
            @(posedge clk);
            #1;
            timeout_count = timeout_count + 1;
        end
        check(next_ack_toggle === target_toggle, "WAIT_CATALOG request is acknowledged");
        // Set catalog_ready after sink ACK and before the loader samples the
        // sink's one-cycle next_press, keeping the real state in WAIT_CATALOG.
        catalog_ready = 1'b1;
        tick(1);
        check(dut.state == 4'd1 && dut.next_pending == 1'b1,
              "WAIT_CATALOG retains the event while advancing to IDLE");
        tick(1);
        check(saw_wait_catalog_pending != 0, "WAIT_CATALOG event is recorded before IDLE consumes it");
        check(dut.state == 4'd2, "WAIT_CATALOG queued event starts HEADER from IDLE");

        // Return to a stable IDLE display state. The real sink event sets the
        // loader's existing one-bit pending flag; the next cycle starts load.
        @(negedge clk);
        dut.state = 4'd1;
        dut.display_valid = 1'b1;
        dut.next_pending = 1'b0;
        tick(1);
        issue_next;
        check(saw_idle_pending != 0, "IDLE observes pending request from event sink");
        check(dut.state == 4'd2, "IDLE consumes pending request and enters HEADER");

        // A busy PAYLOAD retains one pending request. Repeated next events
        // coalesce in the original single-bit queue; auto events remain live
        // and toggle the existing auto mode while loading.
        @(negedge clk);
        dut.state = 4'd5;
        dut.scale_active = 1'b1;
        dut.next_pending = 1'b0;
        dut.auto_enabled = 1'b0;
        issue_next;
        check(saw_payload_pending != 0 && dut.next_pending == 1'b1,
              "PAYLOAD retains one queued next request");
        issue_next;
        issue_next;
        check(dut.next_pending == 1'b1, "additional busy next events coalesce to one loader pending bit");
        issue_auto;
        check(dut.auto_enabled == 1'b1, "auto event toggles during PAYLOAD");
        issue_auto;
        check(dut.auto_enabled == 1'b0, "second auto event toggles independently during PAYLOAD");
        check(dut.state == 4'd5, "events do not leave PAYLOAD");

        // Deliver next_press and display_finish_pulse on the same loader edge.
        // The request must survive WAIT_DISPLAY -> IDLE and start next cycle.
        @(negedge clk);
        dut.state = 4'd9;
        dut.next_pending = 1'b0;
        dut.display_finish_sync = 3'b000;
        issue_next_with_same_edge_finish;
        check(saw_finish_event_collision != 0, "next event overlaps WAIT_DISPLAY completion");
        check(dut.state == 4'd1 && dut.next_pending == 1'b1,
              "same-edge finish preserves next request across WAIT_DISPLAY to IDLE");
        tick(1);
        check(dut.state == 4'd2 && dut.next_pending == 1'b0,
              "preserved same-edge request starts HEADER on following IDLE cycle");

        check(next_events == 7, "each held next toggle produces exactly one sink pulse");
        check(auto_events == 3, "each held auto toggle produces exactly one sink pulse");
        check(next_ack_toggle == next_req_toggle && auto_ack_toggle == auto_req_toggle,
              "both toggle channels finish rearmed with request equal to acknowledgement");
        pre_reset_next_events = next_events;
        pre_reset_auto_events = auto_events;

        // Reset both protocol endpoints while work is pending; matching reset
        // states clear queue, auto state, pulses, and both toggle pairs.
        @(negedge clk);
        dut.next_pending = 1'b1;
        rst = 1'b1;
        next_req_toggle = 1'b0;
        auto_req_toggle = 1'b0;
        next_events = 0;
        auto_events = 0;
        tick(3);
        check(dut.state == 4'd0 && dut.next_pending == 1'b0 && dut.auto_enabled == 1'b0,
              "reset clears loader state and queued work");
        check(next_ack_toggle == 1'b0 && auto_ack_toggle == 1'b0,
              "reset returns sink acknowledgements to matching zero state");
        rst = 1'b0;
        tick(6);
        check(next_events == 0 && auto_events == 0,
              "common reset release creates no stale toggle events");
        check(!error, "audit stimulus does not raise loader error");

        $display("PASS tb_loader_event checks=%0d delivered_before_reset(next=%0d auto=%0d) stale_after_reset(next=%0d auto=%0d)",
                 checks, pre_reset_next_events, pre_reset_auto_events,
                 next_events, auto_events);
        $finish;
    end

    initial begin
        #1000000;
        $fatal(1, "tb_loader_event timeout");
    end
endmodule
