`timescale 1ns/1ps

// Exploratory failing harness: it deliberately omits the empty-last beat.
// Use tb_jpeg_core_profile.sv for full-frame verification.
module tb_jpeg_profile_diff;
    localparam integer JPEG_BYTES = 37704;
    localparam integer JPEG_WORDS = (JPEG_BYTES + 3) / 4;

    reg clk = 1'b0;
    reg rst = 1'b1;
    reg in_valid = 1'b0;
    reg [31:0] in_data = 32'b0;
    reg [3:0] in_strb = 4'b0;
    reg in_last = 1'b0;
    wire ref_accept, opt_accept;
    wire ref_valid, opt_valid;
    wire [15:0] ref_width, ref_height, ref_x, ref_y;
    wire [15:0] opt_width, opt_height, opt_x, opt_y;
    wire [7:0] ref_r, ref_g, ref_b, opt_r, opt_g, opt_b;
    wire ref_idle, opt_idle;
    reg [7:0] jpeg_bytes [0:JPEG_BYTES-1];
    integer word_index = 0;
    integer pixel_count = 0;
    integer cycle_count = 0;
    integer i;

    always #5 clk = ~clk;

    jpeg_core #(.SUPPORT_WRITABLE_DHT(0)) u_reference (
        .clk_i(clk), .rst_i(rst), .inport_valid_i(in_valid),
        .inport_data_i(in_data), .inport_strb_i(in_strb), .inport_last_i(in_last),
        .outport_accept_i(1'b1), .inport_accept_o(ref_accept),
        .outport_valid_o(ref_valid), .outport_width_o(ref_width),
        .outport_height_o(ref_height), .outport_pixel_x_o(ref_x),
        .outport_pixel_y_o(ref_y), .outport_pixel_r_o(ref_r),
        .outport_pixel_g_o(ref_g), .outport_pixel_b_o(ref_b), .idle_o(ref_idle)
    );

    jpeg_core #(.SUPPORT_WRITABLE_DHT(0), .FIXED_MODE(2),
                .FIXED_WIDTH(16'd640), .FIXED_HEIGHT(16'd480)) u_profile (
        .clk_i(clk), .rst_i(rst), .inport_valid_i(in_valid),
        .inport_data_i(in_data), .inport_strb_i(in_strb), .inport_last_i(in_last),
        .outport_accept_i(1'b1), .inport_accept_o(opt_accept),
        .outport_valid_o(opt_valid), .outport_width_o(opt_width),
        .outport_height_o(opt_height), .outport_pixel_x_o(opt_x),
        .outport_pixel_y_o(opt_y), .outport_pixel_r_o(opt_r),
        .outport_pixel_g_o(opt_g), .outport_pixel_b_o(opt_b), .idle_o(opt_idle)
    );

    always @* begin
        in_valid = (word_index < JPEG_WORDS) && !rst;
        in_data = 32'b0;
        in_strb = 4'b0;
        in_last = 1'b0;
        for (integer lane = 0; lane < 4; lane = lane + 1) begin
            if (word_index * 4 + lane < JPEG_BYTES) begin
                in_data[lane*8 +: 8] = jpeg_bytes[word_index * 4 + lane];
                in_strb[lane] = 1'b1;
            end
        end
        in_last = (word_index == JPEG_WORDS-1);
    end

    always @(posedge clk) begin
        if (rst) begin
            word_index <= 0;
            pixel_count <= 0;
            cycle_count <= 0;
        end else begin
            cycle_count <= cycle_count + 1;
            if (in_valid && ref_accept && opt_accept)
                word_index <= word_index + 1;
            if (ref_accept !== opt_accept) begin
                $display("FAIL: input accept differs at cycle %0d", cycle_count);
                $fatal(1);
            end
            if (ref_valid !== opt_valid) begin
                $display("FAIL: output valid differs at cycle %0d", cycle_count);
                $fatal(1);
            end
            if (ref_idle !== opt_idle) begin
                $display("FAIL: idle differs at cycle %0d", cycle_count);
                $fatal(1);
            end
            if (ref_valid) begin
                pixel_count <= pixel_count + 1;
                if ({ref_width, ref_height, ref_x, ref_y, ref_r, ref_g, ref_b} !==
                    {opt_width, opt_height, opt_x, opt_y, opt_r, opt_g, opt_b}) begin
                    $display("FAIL: output pixel differs at cycle %0d, pixel %0d", cycle_count, pixel_count);
                    $fatal(1);
                end
            end
            if (cycle_count > 2000000) begin
                $display("FAIL: timeout; bytes accepted %0d/%0d pixels %0d idle reference/profile %b/%b", word_index*4, JPEG_BYTES, pixel_count, ref_idle, opt_idle);
                $fatal(1);
            end
            if (pixel_count > 307200) begin
                $display("FAIL: too many pixels: %0d", pixel_count);
                $fatal(1);
            end
            if (word_index == JPEG_WORDS && ref_idle && opt_idle && pixel_count == 307200) begin
                $display("PASS: full JPEG profile frame matches dynamic decoder; input bytes %0d, output pixels %0d, cycles %0d", JPEG_BYTES, pixel_count, cycle_count);
                $finish;
            end
        end
    end

    initial begin
        $readmemh("frame_000.hex", jpeg_bytes);
        repeat (8) @(posedge clk);
        rst <= 1'b0;
    end
endmodule
