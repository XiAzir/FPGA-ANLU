`timescale 1ns/1ps
module tb_yuv420_cache;
    localparam integer FRAME_WORDS = 783360;
    reg clk=0;
    always #5 clk=~clk;
    reg rst=1;
    reg frame_start=0;
    reg [20:0] frame_base=0;
    reg sample_valid=0;
    wire sample_ready;
    reg [1:0] sample_plane=0;
    reg [6:0] mcu_x=0, mcu_y=0;
    reg [1:0] y_block=0;
    reg [5:0] sample_index=0;
    reg signed [31:0] sample_centered=0;
    wire write_valid;
    reg write_ready=0;
    wire [20:0] write_word_addr;
    wire [31:0] write_data;

    yuv420_cache_write_packer dut_pack(
        .clk(clk),.rst(rst),.frame_start(frame_start),.frame_base_word(frame_base),
        .sample_valid(sample_valid),.sample_ready(sample_ready),.sample_plane(sample_plane),
        .mcu_x(mcu_x),.mcu_y(mcu_y),.y_block(y_block),.sample_index(sample_index),
        .sample_centered(sample_centered),.write_valid(write_valid),.write_ready(write_ready),
        .write_word_addr(write_word_addr),.write_data(write_data));

    reg [15:0] pix_x=0,pix_y=0;
    wire [20:0] y_addr,cb_addr,cr_addr;
    wire [1:0] y_lane,cb_lane,cr_lane;
    yuv420_pixel_address dut_addr(
        .frame_base_word(frame_base),.pixel_x(pix_x),.pixel_y(pix_y),
        .y_word_addr(y_addr),.y_lane(y_lane),.cb_word_addr(cb_addr),.cb_lane(cb_lane),
        .cr_word_addr(cr_addr),.cr_lane(cr_lane));

    reg rgb_in_valid=0;
    wire rgb_in_ready;
    reg [15:0] rgb_in_x=0,rgb_in_y=0;
    reg [7:0] rgb_y=0,rgb_cb=128,rgb_cr=128;
    wire rgb_out_valid;
    reg rgb_out_ready=0;
    wire [15:0] rgb_out_x,rgb_out_y;
    wire [7:0] rgb_r,rgb_g,rgb_b;
    yuv420_to_rgb888 dut_rgb(
        .clk(clk),.rst(rst),.in_valid(rgb_in_valid),.in_ready(rgb_in_ready),
        .in_x(rgb_in_x),.in_y(rgb_in_y),.in_y_sample(rgb_y),.in_cb_sample(rgb_cb),
        .in_cr_sample(rgb_cr),.out_valid(rgb_out_valid),.out_ready(rgb_out_ready),
        .out_x(rgb_out_x),.out_y(rgb_out_y),.out_r(rgb_r),.out_g(rgb_g),.out_b(rgb_b));

    reg [3:0] throttle=0;
    always @(posedge clk) throttle <= throttle + 1'b1;
    always @* write_ready = (throttle[1:0] != 2'b01);
    always @* rgb_out_ready = (throttle[2:1] != 2'b01);

    integer writes=0, rgb_outputs=0;
    always @(posedge clk) begin
        if (write_valid && write_ready) begin
            $display("WRITE %0d %08x", write_word_addr, write_data);
            writes <= writes + 1;
        end
        if (rgb_out_valid && rgb_out_ready) begin
            $display("RGB %0d %0d %0d %0d %0d", rgb_out_x, rgb_out_y, rgb_r, rgb_g, rgb_b);
            rgb_outputs <= rgb_outputs + 1;
        end
    end

    task automatic send_sample;
        input [1:0] plane;
        input [6:0] mx,my;
        input [1:0] block_id;
        input [5:0] idx;
        input signed [31:0] value;
        begin
            @(negedge clk);
            sample_plane=plane; mcu_x=mx; mcu_y=my; y_block=block_id;
            sample_index=idx; sample_centered=value; sample_valid=1;
            @(posedge clk);
            while (!sample_ready) @(posedge clk);
            @(negedge clk); sample_valid=0;
        end
    endtask

    task automatic start_frame;
        input [20:0] base;
        begin
            @(negedge clk); frame_base=base; frame_start=1;
            @(posedge clk);
            @(negedge clk); frame_start=0;
        end
    endtask

    task automatic send_rgb;
        input integer id;
        input [7:0] yy,cb,cr;
        begin
            @(negedge clk);
            rgb_in_x=100+id; rgb_in_y=200+id;
            rgb_y=yy; rgb_cb=cb; rgb_cr=cr; rgb_in_valid=1;
            @(posedge clk);
            while (!rgb_in_ready) @(posedge clk);
            @(negedge clk); rgb_in_valid=0;
        end
    endtask

    task automatic print_pixel;
        input [20:0] base;
        input [15:0] x,y;
        begin
            @(negedge clk); frame_base=base; pix_x=x; pix_y=y; #1;
            $display("PIX %0d %0d %0d %0d %0d %0d %0d %0d",x,y,y_addr,y_lane,cb_addr,cb_lane,cr_addr,cr_lane);
        end
    endtask

    integer p,b,i;
    integer signed v;
    initial begin
        #22; @(negedge clk); rst=0;
        print_pixel(0,0,0); print_pixel(0,3,1); print_pixel(0,4,0);
        print_pixel(0,7,7); print_pixel(0,8,8); print_pixel(0,15,15);
        print_pixel(0,16,0); print_pixel(0,1919,0); print_pixel(0,0,15);
        print_pixel(0,0,16); print_pixel(0,1919,1079); print_pixel(0,1918,1078);
        print_pixel(FRAME_WORDS,0,0); print_pixel(FRAME_WORDS,1919,1079);

        // Store every sample in the 1088-row padded allocation, including
        // the final MCU's padded bottom Y/chroma rows.
        start_frame(FRAME_WORDS);
        for (b=0;b<4;b=b+1)
            for (i=0;i<64;i=i+1) begin
                if (i==0) v=-300;
                else if (i==1) v=300;
                else v=i + b*11 - 40;
                send_sample(0,119,67,b[1:0],i[5:0],v);
            end
        for (p=1;p<=2;p=p+1)
            for (i=0;i<64;i=i+1) begin
                if (i==0) v=-300;
                else if (i==1) v=300;
                else v=i + p*37 - 90;
                send_sample(p[1:0],119,67,0,i[5:0],v);
            end

        // A frame restart discards a partial word and selects frame 0.
        for (i=0;i<3;i=i+1)
            send_sample(0,0,0,0,i[5:0],i-20);
        start_frame(0);
        for (i=0;i<64;i=i+1) begin
            if (i==0) v=-300;
            else if (i==1) v=300;
            else v=i-32;
            send_sample(0,0,0,0,i[5:0],v);
        end

        send_rgb(0,8'd16,8'd128,8'd128);
        send_rgb(1,8'd235,8'd128,8'd128);
        send_rgb(2,8'd128,8'd0,8'd255);
        send_rgb(3,8'd0,8'd255,8'd0);
        send_rgb(4,8'd255,8'd0,8'd0);
        send_rgb(5,8'd0,8'd0,8'd255);
        send_rgb(6,8'd128,8'd255,8'd255);
        send_rgb(7,8'd64,8'd127,8'd129);

        wait (rgb_outputs == 8);
        repeat (8) @(posedge clk);
        $display("DONE writes=%0d rgb=%0d",writes,rgb_outputs);
        $finish;
    end
endmodule
