// PCM prefix checks on pages 6..D; legacy packet ports carry CRC/offset payloads.
module player_status_monitor #(
    parameter integer PIXEL_HZ=25000000,
    parameter integer SYS_HZ=50000000,
    parameter integer PAGE_SECONDS=2,
    parameter integer SHOW_SELF_TEST=1,
    parameter [23:0] BUILD_ID=24'hC11308
)(
    input pixel_clk, sys_clk, rst, sys_rst,
    input [23:0] axis_rgb,
    input axis_valid, axis_user, hdmi_locked,
    input audio_valid, tone_mode, underflow,
    input [23:0] audio_pcm,
    input [3:0] startup_flags,
    input [7:0] file_flags, fs_code, wav_map_code,
    input [23:0] packet_samples, packet_count, packet_bad_bch,
    input [23:0] packet_bad_terc, packet_tone_bad,
    input [23:0] packet_cts, packet_n,
    input [3:0] packet_flags,
    input [26:0] bmp_diag,
    input [31:0] sd_crc_diag,
    output wire window_toggle_out,
    output reg [31:0] hex_value,
    output wire [9:0] cw_count_data,
    output wire cw_count_trigger
);
    assign window_toggle_out=request_toggle;
    localparam integer PAGE_CYCLES=SYS_HZ*PAGE_SECONDS;
    localparam integer PAGE_BITS=(PAGE_CYCLES<=1)?1:$clog2(PAGE_CYCLES);
    localparam integer SECOND_BITS=(PIXEL_HZ<=1)?1:$clog2(PIXEL_HZ);
    reg [SECOND_BITS-1:0] second_count;
    reg frame_seen;
    reg [23:0] audio_count;
    reg [27:0] mailbox, received;
    reg request_toggle, ack_sync0, ack_sync1;
    reg request_sync0, request_sync1, ack_toggle;
    reg [3:0] startup_sync0, startup_sync1;
    reg [23:0] file_sync0, file_sync1;
    reg [PAGE_BITS-1:0] page_count;
    reg [3:0] page;
    reg [1:0] self_test;
    wire [23:0] final_samples=(audio_valid && audio_count!=24'hffffff)?audio_count+1'b1:audio_count;
    always @(posedge pixel_clk or posedge rst) begin
        if(rst) begin
            second_count<=0;frame_seen<=0;audio_count<=0;
            mailbox<=0;request_toggle<=0;ack_sync0<=0;ack_sync1<=0;
        end else begin
            ack_sync0<=ack_toggle;ack_sync1<=ack_sync0;
            if(axis_valid && axis_user) frame_seen<=1;
            if(second_count==PIXEL_HZ-1) begin
                second_count<=0;
                if(request_toggle==ack_sync1) begin
                    mailbox<={tone_mode,underflow,hdmi_locked,frame_seen,final_samples};
                    request_toggle<=~request_toggle;
                end
                audio_count<=0;
            end else begin
                second_count<=second_count+1'b1;
                if(audio_valid && audio_count!=24'hffffff) audio_count<=audio_count+1'b1;
            end
        end
    end
    // Diagnostic payloads are registered in the SAME pixel-clock domain as the
    // display in this top. Do not reuse direct packet reads across clocks.
    always @(negedge sys_clk or posedge sys_rst) begin
        if(sys_rst) begin
            request_sync0<=0;request_sync1<=0;ack_toggle<=0;received<=0;
            startup_sync0<=0;startup_sync1<=0;file_sync0<=0;file_sync1<=0;
            page_count<=0;page<=0;self_test<=0;
        end else begin
            request_sync0<=request_toggle;request_sync1<=request_sync0;
            if(request_sync1!=ack_toggle) begin received<=mailbox;ack_toggle<=request_sync1;end
            startup_sync0<=startup_flags;startup_sync1<=startup_sync0;
            file_sync0<={file_flags,fs_code,wav_map_code};file_sync1<=file_sync0;
            if(page_count==PAGE_CYCLES-1) begin
                page_count<=0;
                if(SHOW_SELF_TEST && self_test<2) self_test<=self_test+1'b1;
                else if(page==12) page<=0;
                else page<=page+1'b1;
            end else page_count<=page_count+1'b1;
        end
    end
    always @* begin
        if(SHOW_SELF_TEST && self_test==0) hex_value=32'h01234567;
        else if(SHOW_SELF_TEST && self_test==1) hex_value=32'h88888888;
        else case(page)
            0: hex_value={4'h1,startup_sync1,file_sync1};
            1: hex_value={4'h3,received[27:24],received[23:0]};
            2: hex_value={4'h6,packet_flags,packet_samples};
            3: hex_value={4'h7,packet_flags,packet_count};
            4: hex_value={4'h8,packet_flags,packet_bad_bch};
            5: hex_value={4'h9,packet_flags,packet_bad_terc};
            6: hex_value={4'hA,packet_flags,packet_tone_bad};
            7: hex_value={4'hB,packet_flags,packet_cts};
            8: hex_value={4'hC,packet_flags,packet_n};
            9: hex_value={4'hD,4'hF,BUILD_ID};
            10: hex_value={4'hE,1'b0,bmp_diag};
            11: hex_value={4'hF,4'h0,8'd0,sd_crc_diag[31:16]};
            default: hex_value={4'hF,4'h1,8'd0,sd_crc_diag[15:0]};
        endcase
    end
    // Passive observation; no path back into player control or media data.
    assign cw_count_data={tone_mode,page,request_toggle,
                          hex_value[17],received[17],mailbox[17],audio_count[17]};
    assign cw_count_trigger=request_toggle;
endmodule

