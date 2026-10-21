// Byte-aligned reservoir: one response appends four bytes, one pixel
// consumes three. A pending response is admitted only with at most four
// resident bytes, so insertion has exactly five fixed wiring positions.
module rgb888_unpack32_byte (
    input clk, input rst, input clear, input pixel_en,
    output reg [23:0] pixel_rgb,
    input word_empty, output word_pop, input [31:0] word_data,
    output reg underflow
);
    reg [63:0] reservoir;
    reg [3:0] byte_count;
    reg pop_pending;
    reg [63:0] merged;
    reg [3:0] merged_count;
    reg have_pixel;
    reg [23:0] selected_pixel;
    always @* begin
        merged=reservoir;
        merged_count=byte_count;
        if(pop_pending) begin
            case(byte_count)
                0: merged={32'd0,word_data};
                1: merged={24'd0,word_data,reservoir[7:0]};
                2: merged={16'd0,word_data,reservoir[15:0]};
                3: merged={8'd0,word_data,reservoir[23:0]};
                4: merged={word_data,reservoir[31:0]};
                default: merged=reservoir;
            endcase
            merged_count=byte_count+4'd4;
        end
        have_pixel=(merged_count>=4'd3);
        selected_pixel=merged[23:0];
        if(pixel_en && have_pixel) begin
            merged=merged>>24;
            merged_count=merged_count-4'd3;
        end
    end
    assign word_pop=!(rst || clear || word_empty || (merged_count>4'd4));
    always @(posedge clk) begin
        if(rst || clear) begin
            reservoir<=0;byte_count<=0;pop_pending<=0;
            pixel_rgb<=0;underflow<=0;
        end else begin
            reservoir<=merged;byte_count<=merged_count;
            pop_pending<=word_pop;
            if(pixel_en) begin
                if(have_pixel) pixel_rgb<=selected_pixel;
                else begin pixel_rgb<=0;underflow<=1;end
            end else pixel_rgb<=0;
        end
    end
endmodule
