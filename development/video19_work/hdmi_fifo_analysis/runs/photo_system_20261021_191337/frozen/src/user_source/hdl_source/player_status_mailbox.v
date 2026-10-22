// Atomic status transport between the pixel monitor and system-clock 595.
// The source holds all 32 bits until the destination's acknowledgement returns.
module player_status_mailbox (
    input source_clk, destination_clk, rst,
    input [31:0] source_hex,
    output reg [31:0] destination_hex
);
reg [31:0] held_hex;
reg request_toggle, acknowledgement_toggle;
(* ASYNC_REG="TRUE" *) reg [1:0] acknowledgement_sync, request_sync;
always @(posedge source_clk or posedge rst) begin
    if(rst) begin held_hex<=0;request_toggle<=0;acknowledgement_sync<=0;end
    else begin
        acknowledgement_sync<={acknowledgement_sync[0],acknowledgement_toggle};
        if(acknowledgement_sync[1]==request_toggle) begin
            held_hex<=source_hex;
            request_toggle<=~request_toggle;
        end
    end
end
always @(posedge destination_clk or posedge rst) begin
    if(rst) begin destination_hex<=0;request_sync<=0;acknowledgement_toggle<=0;end
    else begin
        request_sync<={request_sync[0],request_toggle};
        if(request_sync[1]!=acknowledgement_toggle) begin
            destination_hex<=held_hex;
            acknowledgement_toggle<=request_sync[1];
        end
    end
end
endmodule
