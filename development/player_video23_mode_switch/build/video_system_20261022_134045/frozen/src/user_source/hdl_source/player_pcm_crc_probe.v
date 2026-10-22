// Read-only HDMI-input PCM fingerprint observer.
// One CRC bit is processed per pixel clock; audio_valid must be spaced well
// beyond the 48 clocks required to consume one stereo sample record.
module player_pcm_crc_probe (
    input  wire        clk,
    input  wire        rst,
    input  wire        audio_valid,
    input  wire [23:0] audio_left,
    input  wire [23:0] audio_right,
    output reg  [15:0] first_crc,
    output reg  [15:0] last_crc,
    output reg  [15:0] block_index,
    output reg  [23:0] sample_count
);
    reg [15:0] crc_work;
    reg [47:0] serial_bits;
    reg [5:0] bits_left;
    reg [11:0] samples_in_block;
    reg [15:0] blocks_completed;
    reg first_block_seen;
    reg block_last_sample;
    reg busy;

    wire crc_feedback = crc_work[15] ^ serial_bits[47];
    wire [15:0] crc_after_bit = {crc_work[14:0],1'b0} ^
                               (crc_feedback ? 16'h1021 : 16'h0000);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            first_crc <= 16'h0000;
            last_crc <= 16'h0000;
            block_index <= 16'h0000;
            sample_count <= 24'h000000;
            crc_work <= 16'hffff;
            serial_bits <= 48'h0;
            bits_left <= 6'h0;
            samples_in_block <= 12'h0;
            blocks_completed <= 16'h0000;
            first_block_seen <= 1'b0;
            block_last_sample <= 1'b0;
            busy <= 1'b0;
        end else begin
            if (audio_valid)
                sample_count <= sample_count + 24'd1;

            if (audio_valid) begin
                // Each 24-bit channel is serialized byte-low first, then each
                // byte is shifted MSB first by the bit engine below.
                serial_bits <= {
                    audio_left[7:0], audio_left[15:8], audio_left[23:16],
                    audio_right[7:0], audio_right[15:8], audio_right[23:16]
                };
                bits_left <= 6'd48;
                busy <= 1'b1;
                block_last_sample <= (samples_in_block == 12'd4095);
                if (samples_in_block == 12'd4095)
                    samples_in_block <= 12'd0;
                else
                    samples_in_block <= samples_in_block + 12'd1;
            end

            if (busy) begin
                crc_work <= crc_after_bit;
                serial_bits <= {serial_bits[46:0],1'b0};
                bits_left <= bits_left - 6'd1;
                if (bits_left == 6'd1) begin
                    busy <= 1'b0;
                    bits_left <= 6'd0;
                    if (block_last_sample) begin
                        last_crc <= crc_after_bit;
                        block_index <= blocks_completed;
                        blocks_completed <= blocks_completed + 16'd1;
                        if (!first_block_seen) begin
                            first_crc <= crc_after_bit;
                            first_block_seen <= 1'b1;
                        end
                        crc_work <= 16'hffff;
                    end
                end
            end
        end
    end
endmodule
