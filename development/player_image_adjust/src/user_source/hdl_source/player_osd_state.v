// Coherent status mailbox: SD-domain metadata is held until pixel-domain ACK.
// The frame buffer choice and its label are latched together at each read start.
// read_req_out is delayed one pixel cycle so the chosen buffer is stable first.
// No RGB, audio, clocks, or SDRAM word-format pipelines are changed here.
module player_osd_state (
    input sd_clk, pixel_clk, rst,
    input [1:0] source_buffer, source_image,
    input [2:0] source_count,
    input source_auto, source_valid,
    input read_req,
    output reg read_req_out,
    output [1:0] frame_buffer, frame_image,
    output [2:0] frame_count,
    output frame_auto, frame_valid
);
    // {valid, buffer[1:0], image[1:0], count[2:0], auto}
    reg [8:0] held_sd;
    reg request_sd, acknowledge_pixel;
    reg [1:0] ack_sync_sd, req_sync_pixel;
    reg [8:0] latest_pixel, frame_pixel;
    reg read_req_prev;

    always @(posedge sd_clk or posedge rst) begin
        if (rst) begin
            held_sd <= 9'd0;
            request_sd <= 1'b0;
            ack_sync_sd <= 2'b00;
        end else begin
            ack_sync_sd <= {ack_sync_sd[0], acknowledge_pixel};
            // Publish only when the previous entire bundle has been consumed.
            if (ack_sync_sd[1] == request_sd) begin
                held_sd <= {source_valid, source_buffer, source_image,
                            source_count, source_auto};
                request_sd <= ~request_sd;
            end
        end
    end

    always @(posedge pixel_clk or posedge rst) begin
        if (rst) begin
            req_sync_pixel <= 2'b00;
            acknowledge_pixel <= 1'b0;
            latest_pixel <= 9'd0;
            frame_pixel <= 9'd0;
            read_req_prev <= 1'b0;
            read_req_out <= 1'b0;
        end else begin
            req_sync_pixel <= {req_sync_pixel[0], request_sd};
            if (req_sync_pixel[1] != acknowledge_pixel) begin
                // held_sd has settled before the synchronized toggle arrives,
                // and cannot be changed until this ACK returns to sd_clk.
                latest_pixel <= held_sd;
                acknowledge_pixel <= req_sync_pixel[1];
            end
            read_req_prev <= read_req;
            read_req_out <= read_req;
            if (read_req && !read_req_prev)
                frame_pixel <= latest_pixel;
        end
    end

    assign {frame_valid, frame_buffer, frame_image, frame_count, frame_auto}
        = frame_pixel;
endmodule
