`timescale 1ns/1ps
module tb_jpeg420_geometry;
    parameter WIDTH = 640;
    parameter HEIGHT = 480;
    parameter RGB565 = 1;
    parameter OLD_SOURCE = 0;
    localparam PIXEL_BYTES = RGB565 ? 2 : 3;
    localparam ROW_WORDS = RGB565 ? 4 : 6;
    localparam FRAME_WORDS = WIDTH * HEIGHT * PIXEL_BYTES / 4;
    reg clk = 0;
    always #5 clk = ~clk;
    reg rst = 1;
    reg start = 0;
    reg word_take = 0;
    reg [20:0] frame_base = 0;
    wire [20:0] word_address;
    generate if (OLD_SOURCE) begin
        jpeg420_word_address #(.RGB565(RGB565)) dut (
            .clk(clk),.rst(rst),.start(start),.frame_base(frame_base),
            .word_take(word_take),.word_address(word_address));
    end else begin
        jpeg420_word_address #(.RGB565(RGB565),.FRAME_WIDTH(WIDTH),.FRAME_HEIGHT(HEIGHT)) dut (
            .clk(clk),.rst(rst),.start(start),.frame_base(frame_base),
            .word_take(word_take),.word_address(word_address));
    end endgenerate
    integer checked = 0;
    integer f, my, mx, block_part, y, x, pixel_y, pixel_x, expected;
    task accept_word;
        input integer wanted;
        begin
            @(negedge clk);
            if (word_address !== wanted[20:0]) begin
                $display("ADDRESS_MISMATCH checked=%0d actual=%0d expected=%0d",checked,word_address,wanted);
                $fatal(1);
            end
            if (checked % 13 == 0) begin
                word_take = 0;
                repeat (2) @(negedge clk);
                if (word_address !== wanted[20:0]) $fatal(1,"STALL_CHANGED_ADDRESS");
            end
            word_take = 1;
            checked = checked + 1;
        end
    endtask
    task begin_frame;
        input integer base;
        begin
            @(negedge clk);
            word_take = 0; frame_base = base; start = 1;
            @(negedge clk);
            start = 0;
        end
    endtask
    initial begin
        repeat (3) @(negedge clk);
        rst = 0;
        begin_frame(37);
        for (x = 0; x < ROW_WORDS; x = x+1) accept_word(37+x);
        @(negedge clk); word_take = 0; rst = 1;
        @(negedge clk); rst = 0;
        for (f = 0; f < 2; f = f+1) begin
            begin_frame(f * FRAME_WORDS);
            for (my = 0; my < (HEIGHT+15)/16; my = my+1)
                for (mx = 0; mx < WIDTH/16; mx = mx+1)
                    for (block_part = 0; block_part < 4; block_part = block_part+1)
                        for (y = 0; y < 8; y = y+1)
                            for (x = 0; x < ROW_WORDS; x = x+1) begin
                                pixel_y = my * 16 + (block_part/2)*8 + y;
                                pixel_x = mx * 16 + (block_part%2)*8;
                                if (pixel_y < HEIGHT) begin
                                    expected = f*FRAME_WORDS +
                                        (pixel_y*WIDTH+pixel_x)*PIXEL_BYTES/4 + x;
                                    accept_word(expected);
                                end
                            end
        end
        @(negedge clk); word_take = 0;
        $display("PASS geometry=%0dx%0d rgb565=%0d old=%0d checked=%0d",WIDTH,HEIGHT,RGB565,OLD_SOURCE,checked);
        $finish;
    end
endmodule
