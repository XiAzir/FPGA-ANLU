`timescale 1ns/1ps

// Converts a continuous LSB-first RGB888 pixel stream to 32-bit words.
// Frame and row lengths must be multiples of four pixels; clear discards any
// partial word at a frame boundary.
module rgb888_pack32 (
    input         clk,
    input         rst,
    input         clear,
    input         pixel_en,
    input  [23:0] pixel_rgb,
    output reg    word_en,
    output reg [31:0] word_data
);
    reg [1:0] phase;
    reg [23:0] carry;

    always @(posedge clk) begin
        if (rst || clear) begin
            phase <= 2'd0;
            carry <= 24'b0;
            word_en <= 1'b0;
            word_data <= 32'b0;
        end else begin
            word_en <= 1'b0;
            if (pixel_en) begin
                case (phase)
                    2'd0: begin
                        carry <= pixel_rgb;
                        phase <= 2'd1;
                    end
                    2'd1: begin
                        word_en <= 1'b1;
                        word_data <= {pixel_rgb[7:0], carry};
                        carry <= {8'b0, pixel_rgb[23:8]};
                        phase <= 2'd2;
                    end
                    2'd2: begin
                        word_en <= 1'b1;
                        word_data <= {pixel_rgb[15:0], carry[15:0]};
                        carry <= {16'b0, pixel_rgb[23:16]};
                        phase <= 2'd3;
                    end
                    2'd3: begin
                        word_en <= 1'b1;
                        word_data <= {pixel_rgb, carry[7:0]};
                        carry <= 24'b0;
                        phase <= 2'd0;
                    end
                endcase
            end
        end
    end
endmodule


// Unpacks 32-bit FIFO words into registered RGB888 pixels. word_pop requests
// a FIFO read whose data appears one rising edge later, matching the normal
// (non-show-ahead) FIFO interface. The 64-bit reservoir includes capacity
// reserved for a read already in flight and for the next requested read.
module rgb888_unpack32 (
    input         clk,
    input         rst,
    input         clear,
    input         pixel_en,
    output reg [23:0] pixel_rgb,
    input         word_empty,
    output        word_pop,
    input  [31:0] word_data,
    output reg    underflow
);
    reg [63:0] reservoir;
    reg [6:0] bit_count;
    reg        pop_pending;

    reg [63:0] merged;
    reg [6:0] merged_count;
    reg        have_pixel;
    reg [23:0] selected_pixel;

    // Predict occupancy after this edge. A pop is allowed only when its
    // one-cycle-later response will fit, including a response arriving now.
    always @* begin
        merged = reservoir;
        merged_count = bit_count;
        if (pop_pending) begin
            merged = reservoir | ({32'b0, word_data} << bit_count);
            merged_count = bit_count + 7'd32;
        end

        have_pixel = (merged_count >= 7'd24);
        selected_pixel = merged[23:0];
        if (pixel_en && have_pixel) begin
            merged = merged >> 24;
            merged_count = merged_count - 7'd24;
        end
    end

    assign word_pop = !(rst || clear || word_empty || (merged_count > 7'd32));

    always @(posedge clk) begin
        if (rst || clear) begin
            reservoir <= 64'b0;
            bit_count <= 7'b0;
            pop_pending <= 1'b0;
            pixel_rgb <= 24'b0;
            underflow <= 1'b0;
        end else begin
            pop_pending <= word_pop;
            reservoir <= merged;
            bit_count <= merged_count;

            if (pixel_en) begin
                if (have_pixel)
                    pixel_rgb <= selected_pixel;
                else begin
                    pixel_rgb <= 24'b0;
                    underflow <= 1'b1;
                end
            end else begin
                pixel_rgb <= 24'b0;
            end
        end
    end
endmodule
