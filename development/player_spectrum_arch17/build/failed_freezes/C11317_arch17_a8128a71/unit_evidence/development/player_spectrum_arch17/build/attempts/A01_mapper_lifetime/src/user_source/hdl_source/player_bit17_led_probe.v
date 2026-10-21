module player_bit17_led_probe (
    input  wire       video_clk,
    input  wire       rst,
    input  wire       tone_mode,
    input  wire [9:0] cw_count_data,
    output wire [3:0] led
);
    reg [3:0] flags;

    always @(posedge video_clk or posedge rst) begin
        if (rst) begin
            flags <= 4'b0000;
        end else if (!tone_mode) begin
            flags <= 4'b0000;
        end else begin
            if (cw_count_data[0]) flags[0] <= 1'b1; // audio_count[17]
            if (cw_count_data[1]) flags[1] <= 1'b1; // mailbox[17]
            if (cw_count_data[2]) flags[2] <= 1'b1; // received[17]
            if ((cw_count_data[8:5] == 4'd1) && cw_count_data[3])
                flags[3] <= 1'b1;                  // hex_value[17], display page 3
        end
    end

    assign led = ~flags;
endmodule
