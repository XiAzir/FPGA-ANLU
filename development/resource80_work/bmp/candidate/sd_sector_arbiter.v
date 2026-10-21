// Sector boundaries are the only preemption points. Bound audio priority to
// two consecutive sectors while BMP is pending, including metadata requests.
module sd_sector_arbiter (
    input clk, rst,
    input bmp_read, input [31:0] bmp_addr,
    input wav_read, input [31:0] wav_addr,
    output card_read, output [31:0] card_addr,
    input [7:0] card_data, input card_valid, card_end,
    output [7:0] bmp_data, output bmp_valid, bmp_end,
    output [7:0] wav_data, output wav_valid, wav_end
);
reg [1:0] owner;
reg [1:0] gap;
reg [31:0] address;
reg [1:0] audio_streak;
assign card_read = (owner != 0);
assign card_addr = address;
assign bmp_data = card_data;
assign wav_data = card_data;
assign bmp_valid = (owner == 1) && card_valid;
assign bmp_end = (owner == 1) && card_end;
assign wav_valid = (owner == 2) && card_valid;
assign wav_end = (owner == 2) && card_end;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        owner <= 0; gap <= 0; address <= 0; audio_streak <= 0;
    end else if (owner != 0) begin
        if (card_end) begin
            owner <= 0;
            // Let the controller return to WAIT and both clients update addresses.
            gap <= 2;
        end
    end else if (gap != 0) begin
        gap <= gap - 1'b1;
    end else if (wav_read && (!bmp_read || audio_streak < 2)) begin
        owner <= 2; address <= wav_addr;
        if(audio_streak<2) audio_streak<=audio_streak+1'b1;
    end else if (bmp_read) begin
        owner <= 1; address <= bmp_addr; audio_streak<=0;
    end
end
endmodule
