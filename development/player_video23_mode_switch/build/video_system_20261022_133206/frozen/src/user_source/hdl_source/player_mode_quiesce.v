`timescale 1ns/1ps
// SD-domain drain handshake for a media-mode change.
// request_toggle_async and ack_toggle_async are level toggles from the media
// clock domain. physical_idle is true only after the accepted physical sector
// has ended and the SD command/SPI engines are idle. mount_ready is owned by
// the persistent catalog and remains asserted across mode changes.
module player_mode_quiesce(
    input  wire clk,
    input  wire rst,
    input  wire request_toggle_async,
    input  wire ack_toggle_async,
    input  wire physical_idle,
    input  wire mount_ready,
    output reg  gate_new_sector,
    output reg  commit_toggle,
    output wire busy
);
localparam ST_IDLE       = 2'd0;
localparam ST_WAIT_MOUNT = 2'd1;
localparam ST_DRAIN      = 2'd2;
localparam ST_WAIT_ACK   = 2'd3;

(* ASYNC_REG = "TRUE" *) (* async_reg = "true" *) reg [1:0] req_sync;
(* ASYNC_REG = "TRUE" *) (* async_reg = "true" *) reg [1:0] ack_sync;
reg req_seen;
reg [1:0] state;

assign busy = (state != ST_IDLE);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        req_sync <= 2'b00;
        ack_sync <= 2'b00;
    end else begin
        req_sync <= {req_sync[0], request_toggle_async};
        ack_sync <= {ack_sync[0], ack_toggle_async};
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        req_seen <= 1'b0;
        gate_new_sector <= 1'b0;
        commit_toggle <= 1'b0;
        state <= ST_IDLE;
    end else begin
        case (state)
            ST_IDLE: begin
                gate_new_sector <= 1'b0;
                if (req_sync[1] != req_seen) begin
                    req_seen <= req_sync[1];
                    if (mount_ready) begin
                        gate_new_sector <= 1'b1;
                        state <= ST_DRAIN;
                    end else begin
                        state <= ST_WAIT_MOUNT;
                    end
                end
            end
            ST_WAIT_MOUNT: begin
                if (mount_ready) begin
                    gate_new_sector <= 1'b1;
                    state <= ST_DRAIN;
                end
            end
            ST_DRAIN: begin
                gate_new_sector <= 1'b1;
                if (mount_ready && physical_idle) begin
                    commit_toggle <= ~commit_toggle;
                    state <= ST_WAIT_ACK;
                end
            end
            ST_WAIT_ACK: begin
                gate_new_sector <= 1'b1;
                if (ack_sync[1] == commit_toggle) begin
                    gate_new_sector <= 1'b0;
                    state <= ST_IDLE;
                end
            end
            default: begin
                gate_new_sector <= 1'b1;
                state <= ST_DRAIN;
            end
        endcase
    end
end
endmodule
