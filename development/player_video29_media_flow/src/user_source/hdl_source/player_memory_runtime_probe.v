`timescale 1ns/1ps
// Passive frame-memory and pixel-path observer. All state is diagnostic only.
module player_memory_runtime_probe (
    input  wire        mem_clk,
    input  wire        pixel_clk,
    input  wire        rst,
    input  wire        mem_app_read,
    input  wire        mem_read_valid,
    input  wire [31:0] mem_read_word,
    input  wire        mem_app_write,
    input  wire [31:0] mem_write_word,
    input  wire        mem_read_ack,
    input  wire [3:0]  mem_read_state,
    input  wire        source_valid_async,
    input  wire        osd_valid,
    input  wire        read_req,
    input  wire        read_ack_async,
    input  wire        read_fifo_clear,
    input  wire        pixel_underflow,
    input  wire        pixel_de,
    input  wire [23:0] raw_rgb,
    input  wire [23:0] gated_rgb,
    output wire [31:0] page5,
    output wire [11:0] page6_tail
);
    reg mem_read_ack_d;
    wire mem_read_ack_rise = mem_read_ack && !mem_read_ack_d;
    reg [18:0] session_app_reads, session_read_returns;
    reg app_read_seen, returned_seen, nonzero_read_seen;
    reg app_write_seen, nonzero_write_seen;
    reg have_read_session;

    // One coherent low-rate mailbox: the held bundle remains stable until
    // the pixel-clock consumer returns its synchronized acknowledge toggle.
    reg [26:0] mem_bundle_held;
    reg mem_bundle_toggle;
    reg [1:0] pixel_toggle_sync;
    reg pixel_bundle_ack;
    reg [1:0] mem_ack_sync;
    reg [26:0] pixel_bundle;

    wire mem_mailbox_free = (mem_ack_sync[1] == mem_bundle_toggle);
    wire [7:0] closed_mem_flags = {
        app_read_seen, returned_seen, nonzero_read_seen,
        app_write_seen, nonzero_write_seen,
        (session_app_reads != session_read_returns), 2'b00
    };

    always @(posedge mem_clk or posedge rst) begin
        if (rst) begin
            mem_read_ack_d <= 1'b0;
            session_app_reads <= 19'd0;
            session_read_returns <= 19'd0;
            app_read_seen <= 1'b0;
            returned_seen <= 1'b0;
            nonzero_read_seen <= 1'b0;
            app_write_seen <= 1'b0;
            nonzero_write_seen <= 1'b0;
            have_read_session <= 1'b0;
            mem_bundle_held <= 27'd0;
            mem_bundle_toggle <= 1'b0;
            mem_ack_sync <= 2'b00;
        end else begin
            mem_read_ack_d <= mem_read_ack;
            mem_ack_sync <= {mem_ack_sync[0], pixel_bundle_ack};

            if (mem_read_ack_rise) begin
                if (have_read_session && mem_mailbox_free) begin
                    mem_bundle_held <= {closed_mem_flags, session_read_returns};
                    mem_bundle_toggle <= ~mem_bundle_toggle;
                end
                have_read_session <= 1'b1;
                // The ACK edge begins the next session. Count any coincident
                // beat into that session; the previous session ended before it.
                session_app_reads <= mem_app_read ? 19'd1 : 19'd0;
                session_read_returns <= mem_read_valid ? 19'd1 : 19'd0;
                app_read_seen <= mem_app_read;
                returned_seen <= mem_read_valid;
                nonzero_read_seen <= mem_read_valid && (|mem_read_word);
                app_write_seen <= mem_app_write;
                nonzero_write_seen <= mem_app_write && (|mem_write_word);
            end else begin
                if (mem_app_read) begin
                    session_app_reads <= session_app_reads + 19'd1;
                    app_read_seen <= 1'b1;
                end
                if (mem_read_valid) begin
                    session_read_returns <= session_read_returns + 19'd1;
                    returned_seen <= 1'b1;
                    if (|mem_read_word) nonzero_read_seen <= 1'b1;
                end
                if (mem_app_write) begin
                    app_write_seen <= 1'b1;
                    if (|mem_write_word) nonzero_write_seen <= 1'b1;
                end
            end
        end
    end

    always @(posedge pixel_clk or posedge rst) begin
        if (rst) begin
            pixel_toggle_sync <= 2'b00;
            pixel_bundle_ack <= 1'b0;
            pixel_bundle <= 27'd0;
        end else begin
            pixel_toggle_sync <= {pixel_toggle_sync[0], mem_bundle_toggle};
            if (pixel_toggle_sync[1] != pixel_bundle_ack) begin
                pixel_bundle <= mem_bundle_held;
                pixel_bundle_ack <= pixel_toggle_sync[1];
            end
        end
    end

    assign page5 = {4'h5, pixel_bundle[26:19], pixel_bundle[18:0], 1'b0};

    // Live synchronized state remains visible even when no frame ACK arrives.
    reg [3:0] read_state_meta, read_state_sync;
    reg source_valid_meta, source_valid_sync;
    reg read_ack_meta, read_ack_sync;
    reg fifo_clear_meta, fifo_clear_sync;
    reg pixel_underflow_seen, raw_nonzero_seen, gated_nonzero_seen;

    always @(posedge pixel_clk or posedge rst) begin
        if (rst) begin
            read_state_meta <= 4'd0;
            read_state_sync <= 4'd0;
            source_valid_meta <= 1'b0;
            source_valid_sync <= 1'b0;
            read_ack_meta <= 1'b0;
            read_ack_sync <= 1'b0;
            fifo_clear_meta <= 1'b0;
            fifo_clear_sync <= 1'b0;
            pixel_underflow_seen <= 1'b0;
            raw_nonzero_seen <= 1'b0;
            gated_nonzero_seen <= 1'b0;
        end else begin
            read_state_meta <= mem_read_state;
            read_state_sync <= read_state_meta;
            source_valid_meta <= source_valid_async;
            source_valid_sync <= source_valid_meta;
            read_ack_meta <= read_ack_async;
            read_ack_sync <= read_ack_meta;
            fifo_clear_meta <= read_fifo_clear;
            fifo_clear_sync <= fifo_clear_meta;
            if (pixel_de) begin
                if (pixel_underflow) pixel_underflow_seen <= 1'b1;
                if (|raw_rgb) raw_nonzero_seen <= 1'b1;
                if (|gated_rgb) gated_nonzero_seen <= 1'b1;
            end
        end
    end

    wire [7:0] pixel_flags = {
        osd_valid, source_valid_sync, read_req, read_ack_sync,
        fifo_clear_sync, pixel_underflow_seen,
        raw_nonzero_seen, gated_nonzero_seen
    };
    assign page6_tail = {read_state_sync, pixel_flags};
endmodule
