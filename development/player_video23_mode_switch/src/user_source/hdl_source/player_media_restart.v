// Pixel-domain half of the sector-boundary media restart handshake.
// The SD peer drains the accepted physical sector before committing a request.
module player_media_restart (
    input wire clk, rst,
    input wire mode_press,
    input wire restart_toggle_async,
    input wire commit_toggle_async,
    output reg request_toggle,
    output reg ack_toggle,
    output reg video_mode,
    output reg media_reset
);
    (* async_reg = "true" *) reg [1:0] restart_sync;
    (* async_reg = "true" *) reg [1:0] commit_sync;
    reg restart_seen, commit_seen;
    reg change_mode;
    reg [4:0] reset_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            restart_sync <= 0; commit_sync <= 0;
            restart_seen <= 0; commit_seen <= 0;
            request_toggle <= 0; ack_toggle <= 0;
            video_mode <= 0; media_reset <= 0;
            change_mode <= 0; reset_count <= 0;
        end else begin
            restart_sync <= {restart_sync[0],restart_toggle_async};
            commit_sync <= {commit_sync[0],commit_toggle_async};
            restart_seen <= restart_sync[1];
            if ((mode_press || restart_sync[1] != restart_seen) &&
                request_toggle == ack_toggle) begin
                request_toggle <= ~request_toggle;
                change_mode <= mode_press;
            end
            if (commit_sync[1] != commit_seen) begin
                commit_seen <= commit_sync[1];
                if (change_mode) video_mode <= ~video_mode;
                media_reset <= 1;
                reset_count <= 31;
            end else if (media_reset) begin
                if (reset_count == 0) begin
                    media_reset <= 0;
                    ack_toggle <= commit_seen;
                end else reset_count <= reset_count - 1'b1;
            end
        end
    end
endmodule
