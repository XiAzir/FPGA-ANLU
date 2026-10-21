`timescale 1ns/1ps

module scaler_asset_fullcheck #(
    parameter NAME = "asset",
    parameter SOURCE_MEM = "",
    parameter GOLD_MEM = "",
    parameter integer SOURCE_BYTES = 1
)(
    input wire clk,
    input wire rst,
    output reg finished = 0
);
    localparam integer FRAME_WIDTH = 640;
    localparam integer FRAME_HEIGHT = 480;
    localparam integer PIXELS = FRAME_WIDTH * FRAME_HEIGHT;
    reg [7:0] source_bytes [0:SOURCE_BYTES-1];
    reg [23:0] expected [0:PIXELS-1];

    reg key_next = 0, key_auto = 0, catalog_ready = 0;
    reg [2:0] bmp_count = 1;
    reg [127:0] bmp_clusters = 0, bmp_sizes = 0;
    wire [31:0] file_cluster, file_size;
    wire card_read;
    wire [31:0] card_addr;
    reg [7:0] card_data = 0;
    reg card_valid = 0, card_end = 0, file_error = 0;
    reg write_finish_toggle = 0, display_finish_toggle = 0;
    wire [1:0] write_buf_idx, disp_buf_idx;
    wire write_req, write_en, display_valid, error, auto_mode;
    reg write_req_ack = 0, write_ready = 1;
    wire [23:0] write_data;
    wire [3:0] state_code;
    wire [1:0] current_image_index;

    tf_bmp_file_player #(
        .CLK_FREQ_HZ(1000), .FRAME_WIDTH(FRAME_WIDTH), .FRAME_HEIGHT(FRAME_HEIGHT),
        .WAIT_LIMIT(50000000)
    ) dut (
        .clk(clk), .rst(rst), .key_next(key_next), .key_auto(key_auto),
        .catalog_ready(catalog_ready), .bmp_count(bmp_count),
        .bmp_clusters(bmp_clusters), .bmp_sizes(bmp_sizes),
        .file_cluster(file_cluster), .file_size(file_size), .card_read(card_read), .card_addr(card_addr),
        .card_data(card_data), .card_valid(card_valid), .card_end(card_end), .file_error(file_error),
        .write_finish_toggle(write_finish_toggle), .display_finish_toggle(display_finish_toggle),
        .write_buf_idx(write_buf_idx), .disp_buf_idx(disp_buf_idx), .write_req(write_req),
        .write_req_ack(write_req_ack), .write_ready(write_ready),
        .write_en(write_en), .write_data(write_data), .display_valid(display_valid),
        .error(error), .state_code(state_code), .current_image_index(current_image_index), .auto_mode(auto_mode)
    );

    integer accepted_words = 0;
    integer drained_words = 0;
    integer drain_pipe0 = 0, drain_pipe1 = 0;
    integer card_sector_count = 0;
    integer low_ready_cycles = 0, longest_low_ready = 0, low_run = 0;
    integer cycle_count = 0;
    integer pixel_index;
    integer k, addr_base, gap_count;
    reg [23:0] want_rgb;
    reg [31:0] requests_before_wait;
    integer total_card_requests = 0;

    initial begin
        $readmemh(SOURCE_MEM, source_bytes, 0, SOURCE_BYTES-1);
        $readmemh(GOLD_MEM, expected, 0, PIXELS-1);
        bmp_sizes[31:0] = SOURCE_BYTES;
    end

    // Model frame-writer readiness, including a long stall and periodic stalls.
    always @(posedge clk) begin
        if (rst) cycle_count <= 0;
        else cycle_count <= cycle_count + 1;
    end
    always @(negedge clk) begin
        if (rst) begin
            write_ready = 1;
            low_run = 0;
        end else begin
            if ((cycle_count >= 12000 && cycle_count < 12300) || ((cycle_count % 113) < 23)) begin
                write_ready = 0;
                low_ready_cycles = low_ready_cycles + 1;
                low_run = low_run + 1;
                if (low_run > longest_low_ready) longest_low_ready = low_run;
            end else begin
                write_ready = 1;
                low_run = 0;
            end
        end
    end

    // Capture the loader's accepted output word stream and compare every pixel.
    // write_en is the loader's registered valid&&ready acceptance; sample it
    // without re-gating against the later value of write_ready.
    always @(negedge clk) begin
        if (!rst && write_en) begin
            if (accepted_words >= PIXELS) begin
                $display("FAIL %0s extra output word index=%0d", NAME, accepted_words);
                $fatal(1);
            end
            want_rgb = expected[accepted_words];
            if (write_data !== want_rgb) begin
                $display("FAIL %0s pixel=%0d stream_xy=(%0d,%0d) got=%06x want=%06x state=%0d",
                         NAME, accepted_words, accepted_words%FRAME_WIDTH,
                         accepted_words/FRAME_WIDTH, write_data, want_rgb, state_code);
                $display("DETAIL engine_state=%0d out=(%0d,%0d) off=(%0d,%0d) size=(%0d,%0d) line_black=%b rowtag=%0d physrow=%0d xsrc=%0d rowq=%06x rgb=%06x phase=(%0d,%0d)",
                         dut.u_scale.state,dut.u_scale.out_x,dut.u_scale.out_y,
                         dut.u_scale.offx,dut.u_scale.offy,dut.u_scale.dw,dut.u_scale.dh,
                         dut.u_scale.line_black,dut.u_scale.row_tag,dut.u_scale.physical_row,
                         dut.u_scale.x_src,dut.u_scale.row_q,dut.u_scale.pixel_rgb,
                         dut.u_scale.x_phase,dut.u_scale.y_phase);
                $fatal(1);
            end
            accepted_words = accepted_words + 1;
            drain_pipe0 = drain_pipe0 + 1;
        end
        if (drain_pipe1 != 0) begin
            drained_words = drained_words + drain_pipe1;
            drain_pipe1 = 0;
        end
        drain_pipe1 = drain_pipe0;
        drain_pipe0 = 0;
    end

    // Sector-level card model: exact 512 valid bytes per sector, variable
    // inter-byte gaps, delayed first byte, and a separate card_end after byte 512.
    initial begin : sector_responder
        integer sector_addr;
        integer byte_no;
        integer source_pos;
        forever begin
            wait(card_read === 1'b1);
            @(negedge clk);
            sector_addr = card_addr;
            total_card_requests = total_card_requests + 1;
            repeat (4) @(negedge clk);
            byte_no = 0;
            while (byte_no < 512) begin
                if ((byte_no % 37) == 11) repeat (2) @(negedge clk);
                source_pos = sector_addr * 512 + byte_no;
                card_data = (source_pos < SOURCE_BYTES) ? source_bytes[source_pos] : 8'h00;
                card_valid = 1;
                @(negedge clk);
                card_valid = 0;
                byte_no = byte_no + 1;
            end
            card_end = 1;
            card_sector_count = card_sector_count + 1;
            @(negedge clk);
            card_end = 0;
            card_data = 0;
            wait(card_read === 1'b0);
        end
    end

    initial begin : write_ack_responder
        forever begin
            wait(write_req === 1'b1);
            repeat (7) @(negedge clk);
            write_req_ack = 1;
            @(negedge clk);
            write_req_ack = 0;
            wait(write_req === 1'b0);
        end
    end

    initial begin
        repeat (5) @(negedge clk);
        catalog_ready = 1;
        wait(accepted_words == PIXELS);
        wait(state_code == 4'd7); // COMMIT only follows engine done.
        wait(drained_words == PIXELS);
        repeat (300) @(negedge clk);
        if (accepted_words != PIXELS || drained_words != PIXELS || longest_low_ready < 250) begin
            $display("FAIL %0s drain/backpressure coverage accepted=%0d drained=%0d longest_low=%0d",
                     NAME, accepted_words, drained_words, longest_low_ready);
            $fatal(1);
        end
        write_finish_toggle = ~write_finish_toggle;
        wait(state_code == 4'd9 && display_valid);
        if (error || accepted_words != PIXELS) begin
            $display("FAIL %0s commit/error error=%b words=%0d", NAME, error, accepted_words);
            $fatal(1);
        end
        requests_before_wait = total_card_requests;

        // Queue NEXT while WAIT_DISPLAY is active. The loader must not begin a
        // second read until the actual display-finish toggle returns.
        catalog_ready = 0;
        key_next = 1;
        repeat (80) @(negedge clk);
        key_next = 0;
        repeat (80) @(negedge clk);
        if (state_code != 4'd9 || total_card_requests != requests_before_wait) begin
            $display("FAIL %0s WAIT_DISPLAY advanced before real toggle state=%0d req=%0d/%0d",
                     NAME, state_code, total_card_requests, requests_before_wait);
            $fatal(1);
        end
        display_finish_toggle = ~display_finish_toggle;
        wait(state_code == 4'd1);
        if (accepted_words != PIXELS || error || !display_valid) begin
            $display("FAIL %0s final ownership state=%0d valid=%b err=%b", NAME, state_code, display_valid, error);
            $fatal(1);
        end
        $display("SCALER_ASSET PASS name=%0s pixels=%0d sectors=%0d low_ready=%0d longest_low=%0d",
                 NAME, accepted_words, card_sector_count, low_ready_cycles, longest_low_ready);
        finished = 1;
    end
endmodule

module tb_scaler_full_loader;
    reg clk = 0, rst = 1;
    always #5 clk = ~clk;
    wire [5:0] done;

    scaler_asset_fullcheck #(.NAME("320x240_bottomup"),
        .SOURCE_MEM("E:/VSCODE-project/FPGA-ANLU/development/resource80_work/catalog/stride_experiment/test_media/bmp_320x240_bottomup_source_bytes.mem"),
        .GOLD_MEM("E:/VSCODE-project/FPGA-ANLU/development/resource80_work/catalog/stride_experiment/test_media/bmp_320x240_bottomup_expected_bottomup_rgb24.mem"),
        .SOURCE_BYTES(230454)) a320 (clk, rst, done[0]);
    scaler_asset_fullcheck #(.NAME("800x600_bottomup"),
        .SOURCE_MEM("E:/VSCODE-project/FPGA-ANLU/development/resource80_work/catalog/stride_experiment/test_media/bmp_800x600_bottomup_source_bytes.mem"),
        .GOLD_MEM("E:/VSCODE-project/FPGA-ANLU/development/resource80_work/catalog/stride_experiment/test_media/bmp_800x600_bottomup_expected_bottomup_rgb24.mem"),
        .SOURCE_BYTES(1440054)) a800 (clk, rst, done[1]);
    scaler_asset_fullcheck #(.NAME("191x321_topdown_padding3"),
        .SOURCE_MEM("E:/VSCODE-project/FPGA-ANLU/development/resource80_work/catalog/stride_experiment/test_media/bmp_191x321_topdown_source_bytes.mem"),
        .GOLD_MEM("E:/VSCODE-project/FPGA-ANLU/development/resource80_work/catalog/stride_experiment/test_media/bmp_191x321_topdown_expected_bottomup_rgb24.mem"),
        .SOURCE_BYTES(184950)) a191 (clk, rst, done[2]);
    scaler_asset_fullcheck #(.NAME("512x128_letterbox"),
        .SOURCE_MEM("E:/VSCODE-project/FPGA-ANLU/development/resource80_work/catalog/stride_experiment/test_media/bmp_512x128_bottomup_source_bytes.mem"),
        .GOLD_MEM("E:/VSCODE-project/FPGA-ANLU/development/resource80_work/catalog/stride_experiment/test_media/bmp_512x128_bottomup_expected_bottomup_rgb24.mem"),
        .SOURCE_BYTES(196662)) a512 (clk, rst, done[3]);
    scaler_asset_fullcheck #(.NAME("native_640x480"),
        .SOURCE_MEM("E:/VSCODE-project/FPGA-ANLU/development/resource80_work/catalog/stride_experiment/test_media/scaler_native_640x480_source_bytes.mem"),
        .GOLD_MEM("E:/VSCODE-project/FPGA-ANLU/development/resource80_work/catalog/stride_experiment/test_media/scaler_native_640x480_expected_bottomup_rgb24.mem"),
        .SOURCE_BYTES(921654)) native_asset (clk, rst, done[4]);
    scaler_asset_fullcheck #(.NAME("odd_vertical_800x599"),
        .SOURCE_MEM("E:/VSCODE-project/FPGA-ANLU/development/resource80_work/catalog/stride_experiment/test_media/scaler_odd_vertical_800x599_source_bytes.mem"),
        .GOLD_MEM("E:/VSCODE-project/FPGA-ANLU/development/resource80_work/catalog/stride_experiment/test_media/scaler_odd_vertical_800x599_expected_bottomup_rgb24.mem"),
        .SOURCE_BYTES(1437654)) odd_vertical (clk, rst, done[5]);

    initial begin
        repeat (8) @(negedge clk);
        rst = 0;
        wait(&done);
        $display("SCALER_INTEGRATION PASS images=6 pixels=1843200 full_loader=1 native=1 odd_vertical=1");
        $finish;
    end
    initial begin
        #900000000;
        $display("FAIL tb_scaler_full_loader global timeout");
        $fatal(1);
    end
endmodule
