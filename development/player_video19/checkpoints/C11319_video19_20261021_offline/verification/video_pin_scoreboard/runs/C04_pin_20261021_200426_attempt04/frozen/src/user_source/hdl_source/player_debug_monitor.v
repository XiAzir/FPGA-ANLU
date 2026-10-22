// Passive SD-clock diagnostics. No signal from this module controls playback.
module player_debug_monitor #(
    parameter integer FRAME_PIXELS = 307200
) (
    input wire clk, input wire rst,
    input wire [7:0] flags,
    input wire [7:0] fs_code, bmp_map_code, wav_map_code,
    input wire write_req, write_en,
    input wire [23:0] write_rgb,
    input wire [31:0] wav_addr,
    input wire wav_valid, wav_end,
    input wire [7:0] wav_data,
    input wire wav_error,
    input wire [3:0] wav_state, wav_phase,
    input wire [31:0] wav_scan_pos,
    input wire [7:0] wav_scan_byte,
    output wire [127:0] debug_rows
);
    reg write_req_d;
    reg [18:0] pixel_count;
    reg [31:0] pixel_sum, completed_sum;
    reg [1:0] magic_count;
    reg [15:0] wav_magic;
    reg error_seen;
    reg [31:0] error_pos;
    reg [7:0] error_byte;
    reg [3:0] error_state, error_phase;

    always @(posedge clk) begin
        if (rst) begin
            write_req_d<=0; pixel_count<=0; pixel_sum<=0; completed_sum<=0;
            magic_count<=0; wav_magic<=0;
            error_seen<=0; error_pos<=0; error_byte<=0;
            error_state<=0; error_phase<=0;
        end else begin
            write_req_d <= write_req;
            if (write_req && !write_req_d) begin
                pixel_count<=0; pixel_sum<=0;
            end else if (write_en && pixel_count < FRAME_PIXELS) begin
                pixel_count<=pixel_count+1'b1;
                pixel_sum<=pixel_sum+{8'd0,write_rgb};
                if (pixel_count == FRAME_PIXELS-1)
                    completed_sum<=pixel_sum+{8'd0,write_rgb};
            end
            // Capture the first two logical WAV bytes once (RI = 16'h4952).
            if (wav_addr==0 && wav_valid && magic_count<2) begin
                if (magic_count==0) wav_magic[7:0]<=wav_data;
                else wav_magic[15:8]<=wav_data;
                magic_count<=magic_count+1'b1;
            end
            if (wav_error && !error_seen) begin
                error_seen<=1;
                error_pos<=wav_scan_pos; error_byte<=wav_scan_byte;
                error_state<=wav_state; error_phase<=wav_phase;
            end
        end
    end
    assign debug_rows = {
        flags,fs_code,bmp_map_code,wav_map_code,
        completed_sum,
        error_pos,
        error_byte,error_state,error_phase,wav_magic
    };
endmodule
