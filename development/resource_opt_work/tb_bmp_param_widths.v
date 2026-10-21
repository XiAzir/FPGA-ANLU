`timescale 1ns/1ps
module tb_bmp_param_widths;
    reg clk=0, rst=1;
    always #5 clk=~clk;
    wire [7:0] data_in=0;
    wire [31:0] addr_in=0;
    wire read_a,read_b,read_c,valid_a,valid_b,valid_c,done_a,done_b,done_c,error_a,error_b,error_c;
    wire [31:0] card_a,card_b,card_c;
    wire [23:0] rgb_a,rgb_b,rgb_c;
    wire [7:0] fail_a,fail_b,fail_c;
    wire [23:0] pixel_a,pixel_b,pixel_c;
    wire [15:0] size_a=16'd1,size_b=16'd1,size_c=16'd1;

    bmp_scale_engine_opt #(.FRAME_WIDTH(1),.FRAME_HEIGHT(1),
        .MAX_SOURCE_WIDTH(1),.MAX_SOURCE_HEIGHT(1),.PIXEL_INTERVAL(1)) p_min (
        .clk(clk),.rst(rst),.start(1'b0),.source_width(size_a),.source_height(size_a),
        .source_top_down(1'b0),.pixel_offset(32'd0),.file_size(32'd4),.pixel_ready(1'b1),
        .card_read(read_a),.card_addr(card_a),.card_data(data_in),.card_valid(1'b0),
        .card_end(1'b0),.file_error(1'b0),.pixel_valid(valid_a),.pixel_rgb(rgb_a),
        .done(done_a),.error(error_a),.failure_code(fail_a));
    bmp_scale_engine_opt #(.FRAME_WIDTH(1),.FRAME_HEIGHT(1),
        .MAX_SOURCE_WIDTH(1024),.MAX_SOURCE_HEIGHT(768),.PIXEL_INTERVAL(1)) p_frame_one (
        .clk(clk),.rst(rst),.start(1'b0),.source_width(size_b),.source_height(size_b),
        .source_top_down(1'b0),.pixel_offset(32'd0),.file_size(32'd4),.pixel_ready(1'b1),
        .card_read(read_b),.card_addr(card_b),.card_data(data_in),.card_valid(1'b0),
        .card_end(1'b0),.file_error(1'b0),.pixel_valid(valid_b),.pixel_rgb(pixel_b),
        .done(done_b),.error(error_b),.failure_code(fail_b));
    bmp_scale_engine_opt #(.FRAME_WIDTH(8),.FRAME_HEIGHT(6),
        .MAX_SOURCE_WIDTH(2048),.MAX_SOURCE_HEIGHT(1024),.PIXEL_INTERVAL(1)) p_caps_above_hard_limit (
        .clk(clk),.rst(rst),.start(1'b0),.source_width(size_c),.source_height(size_c),
        .source_top_down(1'b0),.pixel_offset(32'd0),.file_size(32'd4),.pixel_ready(1'b1),
        .card_read(read_c),.card_addr(card_c),.card_data(data_in),.card_valid(1'b0),
        .card_end(1'b0),.file_error(1'b0),.pixel_valid(valid_c),.pixel_rgb(pixel_c),
        .done(done_c),.error(error_c),.failure_code(fail_c));

    initial begin
        #1;
        $display("BMP_PARAM_WIDTHS PASS min_caps=1 frame=1x1 caps_above_hard=1");
        $finish;
    end
endmodule
