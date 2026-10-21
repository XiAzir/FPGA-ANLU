module rgb888_unpack32_base (
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
