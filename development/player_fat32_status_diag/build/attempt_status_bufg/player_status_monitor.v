// Passive counters. Observes HDMI inputs; does not assert packet validity.
module player_status_monitor #(
    parameter integer PIXEL_HZ=25000000,
    parameter integer SYS_HZ=50000000,
    parameter integer PAGE_SECONDS=2,
    parameter integer SHOW_SELF_TEST=1
)(
    input pixel_clk, sys_clk, rst, sys_rst,
    input [23:0] axis_rgb,
    input axis_valid, axis_user, hdmi_locked,
    input audio_valid, tone_mode, underflow,
    input [23:0] audio_pcm,
    // Status bits are independent slow observations, not a coherent FSM dump.
    input [3:0] startup_flags,
    input [7:0] file_flags, fs_code, wav_map_code,
    output reg [31:0] hex_value
);
    reg [24:0] second_count;
    reg [19:0] frame_nonzero, frame_valid, last_nonzero, last_valid;
    reg frame_seen;
    reg [23:0] audio_count, change_count, previous_pcm;
    reg pcm_seen;
    reg [91:0] mailbox;
    reg request_toggle, ack_sync0, ack_sync1;
    reg request_sync0, request_sync1, ack_toggle;
    reg [91:0] received;
    reg [3:0] startup_sync0, startup_sync1;
    reg [23:0] file_sync0, file_sync1;
    reg [27:0] page_count;
    reg [2:0] page;
    reg [1:0] self_test;
    localparam integer PAGE_CYCLES=SYS_HZ*PAGE_SECONDS;
    wire [23:0] final_samples=(audio_valid && audio_count!=24'hffffff) ?
        audio_count+1'b1 : audio_count;
    wire [23:0] final_changes=(audio_valid && pcm_seen && audio_pcm!=previous_pcm &&
        change_count!=24'hffffff) ? change_count+1'b1 : change_count;
    always @(posedge pixel_clk or posedge rst) begin
        if(rst) begin
            second_count<=0; frame_nonzero<=0; frame_valid<=0;
            last_nonzero<=0; last_valid<=0; frame_seen<=0;
            audio_count<=0; change_count<=0; previous_pcm<=0; pcm_seen<=0;
            mailbox<=0; request_toggle<=0; ack_sync0<=0; ack_sync1<=0;
        end else begin
            ack_sync0<=ack_toggle; ack_sync1<=ack_sync0;
            if(axis_valid) begin
                if(axis_user) begin
                    if(frame_seen) begin last_nonzero<=frame_nonzero; last_valid<=frame_valid; end
                    frame_seen<=1;
                    frame_valid<=1;
                    frame_nonzero<= (axis_rgb!=0) ? 20'd1 : 20'd0;
                end else begin
                    if(frame_valid!=20'hfffff) frame_valid<=frame_valid+1'b1;
                    if(axis_rgb!=0 && frame_nonzero!=20'hfffff) frame_nonzero<=frame_nonzero+1'b1;
                end
            end
            if(audio_valid) begin
                previous_pcm<=audio_pcm; pcm_seen<=1;
                if(second_count!=PIXEL_HZ-1) begin
                    if(audio_count!=24'hffffff) audio_count<=audio_count+1'b1;
                    if(pcm_seen && audio_pcm!=previous_pcm && change_count!=24'hffffff)
                        change_count<=change_count+1'b1;
                end
            end
            if(second_count==PIXEL_HZ-1) begin
                second_count<=0;
                // Include the final cycle in the one-second window.
                if(request_toggle==ack_sync1) begin
                    mailbox<={tone_mode,underflow,hdmi_locked,frame_seen,
                        last_nonzero,last_valid,
                        final_samples,final_changes};
                    request_toggle<=~request_toggle;
                end
                audio_count<=0; change_count<=0;
            end else second_count<=second_count+1'b1;
        end
    end
    always @(posedge sys_clk or posedge sys_rst) begin
        if(sys_rst) begin
            request_sync0<=0; request_sync1<=0; ack_toggle<=0; received<=0;
            startup_sync0<=0; startup_sync1<=0; file_sync0<=0; file_sync1<=0;
            page_count<=0; page<=0; self_test<=0;
        end else begin
            request_sync0<=request_toggle; request_sync1<=request_sync0;
            if(request_sync1!=ack_toggle) begin received<=mailbox; ack_toggle<=request_sync1; end
            startup_sync0<=startup_flags; startup_sync1<=startup_sync0;
            file_sync0<={file_flags,fs_code,wav_map_code}; file_sync1<=file_sync0;
            if(page_count==PAGE_CYCLES-1) begin
                page_count<=0;
                if(SHOW_SELF_TEST && self_test<2) self_test<=self_test+1'b1;
                else if(page==4) page<=0;
                else page<=page+1'b1;
            end else page_count<=page_count+1'b1;
        end
    end
    // 4 flags + 20 + 20 + 24 + 24 = 92 coherent pixel-domain snapshot bits.
    always @* begin
        if(SHOW_SELF_TEST && self_test==0) hex_value=32'h01234567;
        else if(SHOW_SELF_TEST && self_test==1) hex_value=32'h88888888;
        else case(page)
            0: hex_value={4'h1,startup_sync1,file_sync1};
            1: hex_value={4'h2,received[91:88],4'd0,received[87:68]};
            2: hex_value={4'h3,received[91:88],received[47:24]};
            3: hex_value={4'h4,received[91:88],received[23:0]};
            default: hex_value={4'h5,received[91:88],4'd0,received[67:48]};
        endcase
    end
endmodule
