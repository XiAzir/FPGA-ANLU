`timescale 1ns/1ps
module crc_snapshot_observer(
 input wire video_clk,input wire rst_all,input wire [3:0] compact_status_page,
 input wire [15:0] pcm_last_crc,input wire [15:0] pcm_crc_block,
 input wire [23:0] pcm_observed_samples,input wire [23:0] audio_underflow_count,
 output reg [15:0] pcm_crc_snapshot,output reg [15:0] pcm_block_snapshot,
 output reg [23:0] pcm_count_snapshot,output reg [23:0] underflow_count_snapshot
);
reg [3:0] diag_page_previous;
always @(posedge video_clk or posedge rst_all) begin
    if(rst_all) begin
        diag_page_previous<=0;pcm_crc_snapshot<=0;pcm_block_snapshot<=0;
        pcm_count_snapshot<=0;underflow_count_snapshot<=0;
    end else begin
        diag_page_previous<=compact_status_page;
        if(compact_status_page==7 && diag_page_previous!=7) begin
            pcm_crc_snapshot<=pcm_last_crc;pcm_block_snapshot<=pcm_crc_block;
            pcm_count_snapshot<=pcm_observed_samples;
            underflow_count_snapshot<=audio_underflow_count;
        end
    end
end
endmodule