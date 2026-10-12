`timescale 1ns/1ps
module tb_wipe_backend;
    localparam integer FRAME_WORDS = 640/4*3*480;
    localparam integer LINE_WORDS = 640/4*3;
    localparam integer BURST_WORDS = 256;

    reg mem_clk=0, pixel_clk=0, sd_clk=0;
    always #10 mem_clk=~mem_clk;       // 50 MHz backend
    always #20 pixel_clk=~pixel_clk;   // 25 MHz pixel domain
    initial begin #3; forever #20 sd_clk=~sd_clk; end // 25 MHz, phase-offset mailbox domain

    reg rst=1;
    reg [1:0] source_buffer=0, source_image=0;
    reg [2:0] source_count=0;
    reg source_auto=0, source_valid=0;
    reg timing_read_req=0;
    wire backend_read_req, backend_read_ack, read_finish;
    wire [1:0] frame_buffer, frame_image;
    wire [2:0] frame_count;
    wire frame_auto, frame_valid;
    wire wipe_active;
    wire [8:0] wipe_rows;
    wire [1:0] wipe_new_buffer;
    wire display_finish_toggle;

    player_osd_state #(.FRAME_HEIGHT(480),.WIPE_STEP_ROWS(8)) u_osd (
        .sd_clk(sd_clk),.pixel_clk(pixel_clk),.rst(rst),
        .source_buffer(source_buffer),.source_image(source_image),
        .source_count(source_count),.source_auto(source_auto),.source_valid(source_valid),
        .read_req(timing_read_req),.read_req_ack(backend_read_ack),
        .read_req_out(backend_read_req),.frame_buffer(frame_buffer),.frame_image(frame_image),
        .frame_count(frame_count),.frame_auto(frame_auto),.frame_valid(frame_valid),
        .wipe_active(wipe_active),.wipe_rows(wipe_rows),.wipe_new_buffer(wipe_new_buffer),
        .display_finish_toggle(display_finish_toggle)
    );

    wire app_rd_en, backend_busy, fifo_aclr;
    wire [20:0] app_rd_addr, mapped_addr;
    reg [9:0] fifo_wrusedw=0;
    reg init_done=1, init_ref_valid=0, sdr_busy=0, sdr_rd_en=0, app_wr_busy=0;
    frame_fifo_read #(.ADDR_BITS(21),.BURST_BITS(9),.FIFO_DEPTH(512),.BURST_SIZE(256)) u_fifo_read (
        .rst(rst),.mem_clk(mem_clk),.Sdr_init_done(init_done),.Sdr_init_ref_vld(init_ref_valid),
        .Sdr_busy(sdr_busy),.Sdr_rd_en(sdr_rd_en),.App_wr_busy(app_wr_busy),
        .O_rd_busy(backend_busy),.App_rd_en(app_rd_en),.App_rd_addr(app_rd_addr),
        .read_req(backend_read_req),.read_req_ack(backend_read_ack),.read_finish(read_finish),
        .read_addr_0(21'd0),.read_addr_1(FRAME_WORDS),.read_addr_2(21'd0),.read_addr_3(21'd0),
        .read_addr_index(frame_buffer),.read_len(FRAME_WORDS),.fifo_aclr(fifo_aclr),
        .wrusedw(fifo_wrusedw)
    );

    player_wipe_address #(.FRAME_WIDTH(640),.FRAME_HEIGHT(480),.ADDR_BITS(21)) u_router (
        .clk(mem_clk),.rst(rst),.frame_ack(backend_read_ack),
        .wipe_active_async(wipe_active),.wipe_rows_async(wipe_rows),
        .old_buffer_async(frame_buffer),.new_buffer_async(wipe_new_buffer),
        .linear_addr(app_rd_addr),.mapped_addr(mapped_addr)
    );

    integer stream_active=0, stream_count=0, stream_base=0;
    integer stream_old=0, stream_new=0, stream_rows=0, stream_wipe=0;
    integer expected_linear, expected_mapped, stream_id=0;
    integer app_total=0, finish_toggle_count=0, stream_errors=0;
    integer pending_mode=0, pending_trigger_count=0, pending_ack_count=0;
    integer pending_linear_before, pending_expected_linear;
    reg [20:0] linear_at_trigger;
    reg prev_finish_toggle=0;

    always @(posedge mem_clk) begin
        if (!rst && app_rd_en) begin
            app_total=app_total+1;
            if (stream_active) begin
                expected_linear=stream_base+stream_count;
                expected_mapped=expected_linear;
                if (stream_wipe && stream_count < stream_rows*LINE_WORDS)
                    expected_mapped=stream_new*FRAME_WORDS+stream_count;
                if (app_rd_addr !== expected_linear[20:0]) begin
                    $display("BACKEND_LINEAR_FAIL stream=%0d n=%0d got=%0d expected=%0d",stream_id,stream_count,app_rd_addr,expected_linear);
                    stream_errors=stream_errors+1;
                    $fatal(1,"backend linear address mismatch");
                end
                if (mapped_addr !== expected_mapped[20:0]) begin
                    $display("BACKEND_ROUTE_FAIL stream=%0d n=%0d rows=%0d active=%0d got=%0d expected=%0d",stream_id,stream_count,stream_rows,stream_wipe,mapped_addr,expected_mapped);
                    stream_errors=stream_errors+1;
                    $fatal(1,"router address mismatch");
                end
                stream_count=stream_count+1;
            end
            if (pending_mode && !pending_ack_count) begin
                // A new frame request may wait during an old burst. Until the
                // subsequent S_ACK edge the captured routing context is immutable.
                if (mapped_addr !== app_rd_addr)
                    $fatal(1,"router changed context before pending request ACK");
                pending_trigger_count=pending_trigger_count+1;
            end
        end
        if (!rst && backend_read_ack && !pending_ack_count && pending_mode) begin
            pending_ack_count=1;
        end
        if (!rst && display_finish_toggle != prev_finish_toggle) begin
            finish_toggle_count=finish_toggle_count+1;
            prev_finish_toggle=display_finish_toggle;
        end
    end

    task wait_pixel; input integer n; integer k; begin for(k=0;k<n;k=k+1) @(negedge pixel_clk); end endtask
    task wait_sd; input integer n; integer k; begin for(k=0;k<n;k=k+1) @(negedge sd_clk); end endtask
    task reset_all; begin
        rst=1; timing_read_req=0; stream_active=0;
        repeat(6) @(negedge mem_clk);
        rst=0; repeat(8) @(negedge pixel_clk);
        finish_toggle_count=0; prev_finish_toggle=display_finish_toggle;
        stream_id=0; stream_count=0;
    end endtask
    task publish_source; input [1:0] bufid; input [1:0] imageid; begin
        source_buffer=bufid; source_image=imageid; source_valid=1;
        source_count=source_count+1'b1; source_auto=1;
        wait_sd(10); wait_pixel(12);
        if (!u_osd.latest_pixel[8] || u_osd.latest_pixel[7:6] !== bufid)
            $fatal(1,"source mailbox did not settle buf=%0d latest=%h",bufid,u_osd.latest_pixel);
    end endtask
    task start_request; begin
        @(negedge pixel_clk); timing_read_req=1;
        @(posedge pixel_clk); #1;
    end endtask
    task release_request_on_ack; begin
        wait(backend_read_ack===1'b1);
        @(negedge pixel_clk); timing_read_req=0;
        wait(backend_read_ack===1'b0);
        wait_pixel(4);
    end endtask
    task wait_backend_finish; integer timeout; begin
        timeout=0;
        while (read_finish!==1'b1 && timeout<600000) begin @(negedge mem_clk); timeout=timeout+1; end
        if (timeout>=600000) $fatal(1,"backend read_finish timeout");
        @(negedge mem_clk); // S_END is a one-cycle completion indication
    end endtask
    task full_frame; input integer expected_old; input integer expected_new; input integer expected_rows; input integer expected_active; begin
        stream_id=stream_id+1; stream_count=0; stream_base=expected_old*FRAME_WORDS;
        stream_old=expected_old; stream_new=expected_new; stream_rows=expected_rows; stream_wipe=expected_active;
        stream_active=1;
        start_request();
        if (frame_buffer!==expected_old[1:0]) $fatal(1,"frame buffer mismatch %0d expected %0d",frame_buffer,expected_old);
        release_request_on_ack();
        wait_backend_finish();
        stream_active=0;
        if (stream_count!=FRAME_WORDS)
            $fatal(1,"frame %0d address count %0d expected %0d",stream_id,stream_count,FRAME_WORDS);
        $display("BACKEND_FRAME PASS id=%0d old=%0d new=%0d active=%0d rows=%0d words=%0d",stream_id,expected_old,expected_new,expected_active,expected_rows,stream_count);
    end endtask

    integer dir, step, pre_count, delta_count, pending_timeout, expected_toggles;
    integer saved_old, saved_new, saved_rows, saved_active;
    initial begin
        // Directed overlap case: request a new frame while an older 256-word
        // burst is active. Its address stream must drain to the burst boundary;
        // the router may latch the new wipe bundle only with the later ACK.
        reset_all();
        publish_source(0,0);
        start_request();
        release_request_on_ack();
        wait(app_rd_en===1'b1);
        repeat(80) @(negedge mem_clk);
        if (u_fifo_read.state!==4'd3 || u_fifo_read.burst_cnt<80 || u_fifo_read.burst_cnt>=256)
            $fatal(1,"directed overlap did not land inside an active burst");
        publish_source(1,1);
        @(negedge pixel_clk); timing_read_req=1;
        @(posedge pixel_clk); #1;
        pre_count=app_total;
        linear_at_trigger=app_rd_addr;
        pending_mode=1; pending_trigger_count=0; pending_ack_count=0;
        pending_timeout=0;
        while (!backend_read_ack && pending_timeout<1000) begin @(negedge mem_clk); pending_timeout=pending_timeout+1; end
        if (!backend_read_ack) $fatal(1,"pending read request ACK timeout");
        delta_count=app_total-pre_count;
        // At the ACK observation edge S_ACK is active and the in-flight burst
        // counter is exactly 256: the request cannot relatch midway through it.
        if (delta_count<1 || delta_count>BURST_WORDS ||
            u_fifo_read.state!==4'd1 || u_fifo_read.burst_cnt!==BURST_WORDS)
            $fatal(1,"pending ACK boundary mismatch delta=%0d state=%0d burst_cnt=%0d",delta_count,u_fifo_read.state,u_fifo_read.burst_cnt);
        pending_ack_count=1;
        pending_mode=0;
        stream_id=1; stream_count=0; stream_base=0; stream_old=0; stream_new=1; stream_rows=8; stream_wipe=1; stream_active=1;
        @(negedge pixel_clk); timing_read_req=0;
        wait(backend_read_ack===1'b0); wait_pixel(5);
        saved_old=frame_buffer; saved_new=wipe_new_buffer; saved_rows=wipe_rows; saved_active=wipe_active;
        if (saved_old!=0 || saved_new!=1 || saved_rows!=8 || saved_active!=1)
            $fatal(1,"pending frame context wrong old=%0d new=%0d rows=%0d active=%0d",saved_old,saved_new,saved_rows,saved_active);
        wait_backend_finish();
        stream_active=0;
        if (stream_count != FRAME_WORDS) $fatal(1,"overlap follow-up words=%0d expected=%0d",stream_count,FRAME_WORDS);
        $display("PENDING_BURST PASS trigger_count=%0d ack_delta=%0d new_context=old0_new1_rows8",pending_trigger_count,delta_count);

        // Start the production cadence from a clean reset: first complete image,
        // then 60 real 8-row frame reads in each alternating buffer direction.
        reset_all();
        source_buffer=0; source_image=0; source_count=0; source_auto=0; source_valid=0;
        wait_pixel(4); publish_source(0,0);
        full_frame(0,0,0,0);
        if (finish_toggle_count!=1) $fatal(1,"initial complete image should release once, got %0d",finish_toggle_count);
        for (dir=0;dir<2;dir=dir+1) begin
            if (dir==0) begin publish_source(1,1); saved_old=0; saved_new=1; end
            else begin publish_source(0,2); saved_old=1; saved_new=0; end
            for (step=1;step<=60;step=step+1) begin
                if (step<60) begin
                    saved_rows=step*8; saved_active=1;
                    full_frame(saved_old,saved_new,saved_rows,saved_active);
                end else begin
                    // On row 480 player_osd_state commits target buffer as the
                    // displayed frame and disables remapping; it still reads a
                    // full new-buffer frame, checked independently as passthrough.
                    saved_rows=0; saved_active=0;
                    full_frame(saved_new,saved_new,0,0);
                end
            end
            expected_toggles=dir+2;
            if (finish_toggle_count!=expected_toggles)
                $fatal(1,"direction %0d release toggles=%0d expected=%0d",dir,finish_toggle_count,expected_toggles);
        end
        if (stream_errors!=0 || app_total<FRAME_WORDS*121)
            $fatal(1,"coverage totals errors=%0d app_reads=%0d",stream_errors,app_total);
        $display("WIPE_BACKEND PASS streams=%0d production_frames=121 direction_changes=2 words_per_frame=%0d app_reads=%0d release_toggles=%0d pending_burst=%0d",stream_id,FRAME_WORDS,app_total,finish_toggle_count,pending_trigger_count);
        $finish;
    end
    initial begin #2000000000; $fatal(1,"global timeout"); end
endmodule
