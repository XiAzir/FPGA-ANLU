module player_compact_status_pages #(
    parameter integer PAGE_CYCLES = 25000000
)(
    input wire clk,
    input wire rst,
    input wire [7:0] file_flags,
    input wire [3:0] photo_state,
    input wire [3:0] video_state,
    input wire [7:0] fs_error_code,
    input wire [3:0] file_error_flags,
    input wire [15:0] sd_crc_checked,
    input wire [15:0] sd_crc_bad,
    input wire audio_underflow,
    input wire [23:0] spectrum_frames,
    output reg [31:0] hex_value,
    output reg [1:0] page_index
);

localparam integer TIMER_W = (PAGE_CYCLES <= 1) ? 1 : $clog2(PAGE_CYCLES);
reg [TIMER_W-1:0] page_timer;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        page_timer <= {TIMER_W{1'b0}};
        page_index <= 2'd0;
    end else if (page_timer == PAGE_CYCLES - 1) begin
        page_timer <= {TIMER_W{1'b0}};
        page_index <= page_index + 1'b1;
    end else begin
        page_timer <= page_timer + 1'b1;
    end
end

always @* begin
    case (page_index)
        2'd0: hex_value = 32'h00C11320;
        2'd1: hex_value = {4'h2, file_flags, photo_state, video_state,
                           fs_error_code, file_error_flags};
        2'd2: hex_value = {sd_crc_checked, sd_crc_bad};
        default: hex_value = {spectrum_frames, 4'h0, audio_underflow, 3'b000};
    endcase
end

endmodule
