`timescale 1ns/1ps
module first4_capture_observer (
    input wire sd_card_clk, input wire rst_all,
    input wire [3:0] compact_status_page,
    input wire bmp_card_read, input wire bmp_card_valid, input wire bmp_card_end,
    input wire [31:0] bmp_card_addr, input wire [7:0] bmp_card_data,
    input wire wav_card_read, input wire wav_card_valid, input wire wav_card_end,
    input wire [31:0] wav_card_addr, input wire [7:0] wav_card_data,
    output reg [9:0] diag_bmp_byte, output reg [9:0] diag_wav_byte,
    output reg [31:0] diag_bmp_head, output reg [31:0] diag_wav_head
);
reg [3:0] diag_page_sync0,diag_page_sync1;
always @(posedge sd_card_clk or posedge rst_all) begin
    if(rst_all) begin
        diag_bmp_byte<=0;diag_wav_byte<=0;diag_bmp_head<=0;diag_wav_head<=0;
        diag_page_sync0<=0;diag_page_sync1<=0;
    end else begin
        diag_page_sync0<=compact_status_page;diag_page_sync1<=diag_page_sync0;
        if(bmp_card_end) diag_bmp_byte<=0;
        else if(bmp_card_valid) begin
            diag_bmp_byte<=diag_bmp_byte+1'b1;
            if(bmp_card_addr==0) case(diag_bmp_byte)
                0:diag_bmp_head[31:24]<=bmp_card_data;
                1:diag_bmp_head[23:16]<=bmp_card_data;
                2:diag_bmp_head[15:8]<=bmp_card_data;
                3:diag_bmp_head[7:0]<=bmp_card_data;
            endcase
        end
        if(wav_card_end) diag_wav_byte<=0;
        else if(wav_card_valid) begin
            diag_wav_byte<=diag_wav_byte+1'b1;
            if(wav_card_addr==0) case(diag_wav_byte)
                0:diag_wav_head[31:24]<=wav_card_data;
                1:diag_wav_head[23:16]<=wav_card_data;
                2:diag_wav_head[15:8]<=wav_card_data;
                3:diag_wav_head[7:0]<=wav_card_data;
            endcase
        end
    end
end
endmodule