// Passive, one-shot prefix checks. No path back into media control/data.
// CRC-16/CCITT-FALSE over PCM16 low byte then high byte; init FFFF.
module pcm_prefix_crc #(
    parameter integer PREFIX_SAMPLES=32768,
    parameter integer SKIP_SAMPLES=65536
)(
    input clk, rst, valid,
    input [15:0] data,
    output reg [15:0] crc,
    output reg [15:0] count,
    output reg done,
    output wire capture_event
);
    localparam integer POS_BITS=(SKIP_SAMPLES+PREFIX_SAMPLES<=1)?1:$clog2(SKIP_SAMPLES+PREFIX_SAMPLES);
    reg [POS_BITS-1:0] position;
    assign capture_event=valid && !done && position>=SKIP_SAMPLES;
    function [15:0] byte_step;
        input [15:0] c; input [7:0] b;
        reg [15:0] t; integer i;
        begin
            t=c^{b,8'd0};
            for(i=0;i<8;i=i+1) t=t[15]?((t<<1)^16'h1021):(t<<1);
            byte_step=t;
        end
    endfunction
    wire [15:0] next_crc=byte_step(byte_step(crc,data[7:0]),data[15:8]);
    always @(posedge clk or posedge rst) begin
        if(rst) begin crc<=16'hFFFF;count<=0;done<=0;position<=0;end
        else if(valid && !done) begin
            position<=position+1'b1;
            if(capture_event) begin
                crc<=next_crc;count<=count+1'b1;
                if(count==PREFIX_SAMPLES-1) done<=1;
            end
        end
    end
endmodule

module player_pcm_prefix_probe #(
    parameter integer PREFIX_SAMPLES=32768,
    parameter integer SKIP_SAMPLES=65536
)(
    input sd_clk, pixel_clk, rst,
    input push_valid, input [15:0] push_data,
    input [31:0] push_high_pos, data_offset,
    input pop_valid, input [15:0] pop_data,
    input audio_valid, tone_mode,
    input [23:0] audio_left, audio_right,
    output [15:0] src_crc, fifo_crc, hdmi_crc,
    output [3:0] capture_flags,
    output reg [15:0] format_bad,
    output [15:0] hdmi_count,
    output [23:0] first_high_pos_sync, data_offset_sync
);
    wire [15:0] source_crc_sd, fifo_crc_sd, source_count_sd, fifo_count_sd;
    wire source_done_sd, fifo_done_sd, hdmi_done;
    wire source_capture,hdmi_capture;
    reg early_tone_abort;
    reg [23:0] first_high_pos;
    (* ASYNC_REG="TRUE" *) reg [2:0] source_ready, fifo_ready;
    reg [15:0] source_crc_sync0, source_crc_sync1, fifo_crc_sync0, fifo_crc_sync1;
    reg [23:0] pos_sync0,pos_sync1,offset_sync0,offset_sync1;
    wire wav_event=audio_valid && !tone_mode && !early_tone_abort;
    pcm_prefix_crc #(.PREFIX_SAMPLES(PREFIX_SAMPLES),.SKIP_SAMPLES(SKIP_SAMPLES)) u_source (
        .clk(sd_clk),.rst(rst),.valid(push_valid),.data(push_data),
        .crc(source_crc_sd),.count(source_count_sd),.done(source_done_sd),.capture_event(source_capture)
    );
    pcm_prefix_crc #(.PREFIX_SAMPLES(PREFIX_SAMPLES),.SKIP_SAMPLES(SKIP_SAMPLES)) u_fifo (
        .clk(sd_clk),.rst(rst),.valid(pop_valid),.data(pop_data),
        .crc(fifo_crc_sd),.count(fifo_count_sd),.done(fifo_done_sd),.capture_event()
    );
    pcm_prefix_crc #(.PREFIX_SAMPLES(PREFIX_SAMPLES),.SKIP_SAMPLES(SKIP_SAMPLES)) u_hdmi_input (
        .clk(pixel_clk),.rst(rst),.valid(wav_event),.data(audio_left[23:8]),
        .crc(hdmi_crc),.count(hdmi_count),.done(hdmi_done),.capture_event(hdmi_capture)
    );
    always @(posedge sd_clk or posedge rst) begin
        if(rst) first_high_pos<=0;
        else if(source_capture && source_count_sd==0)
            first_high_pos<=push_high_pos[23:0];
    end
    always @(posedge pixel_clk or posedge rst) begin
        if(rst) begin
            source_ready<=0;fifo_ready<=0;
            source_crc_sync0<=16'hFFFF;source_crc_sync1<=16'hFFFF;
            fifo_crc_sync0<=16'hFFFF;fifo_crc_sync1<=16'hFFFF;
            pos_sync0<=0;pos_sync1<=0;offset_sync0<=0;offset_sync1<=0;
            early_tone_abort<=0;format_bad<=0;
        end else begin
            // CRC/count freeze on done. Three ready stages trail the two
            // data stages; interpret results only once corresponding ready=1.
            source_ready<={source_ready[1:0],source_done_sd};
            fifo_ready<={fifo_ready[1:0],fifo_done_sd};
            source_crc_sync0<=source_crc_sd;source_crc_sync1<=source_crc_sync0;
            fifo_crc_sync0<=fifo_crc_sd;fifo_crc_sync1<=fifo_crc_sync0;
            pos_sync0<=first_high_pos;pos_sync1<=pos_sync0;
            offset_sync0<=data_offset[23:0];offset_sync1<=offset_sync0;
            if(tone_mode && !hdmi_done) early_tone_abort<=1;
            if(hdmi_capture &&
                (audio_left[7:0]!=0 || audio_right[7:0]!=0 || audio_left!=audio_right))
                if(format_bad!=16'hFFFF) format_bad<=format_bad+1'b1;
        end
    end
    assign src_crc=source_crc_sync1;
    assign fifo_crc=fifo_crc_sync1;
    assign first_high_pos_sync=pos_sync1;
    assign data_offset_sync=offset_sync1;
    assign capture_flags={early_tone_abort,source_ready[2],fifo_ready[2],hdmi_done};
endmodule
