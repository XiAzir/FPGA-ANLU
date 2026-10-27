`timescale 1ns/1ps
module tb_yuv420_scan_cache;
    localparam integer W=32, H=32, FRAME_WORDS=384;
    reg mem_clk=0, pixel_clk=0;
    always #5 mem_clk=~mem_clk;
    initial begin #3; forever #15 pixel_clk=~pixel_clk; end
    reg mem_rst=1,pixel_rst=1;
    reg frame_start_mem=0,frame_start_pixel=0;
    reg [20:0] frame_base_word=0;
    wire rd_cmd_valid;
    reg rd_cmd_ready=0;
    wire [20:0] rd_cmd_addr;
    reg rd_valid=0;
    reg [31:0] rd_data=0;
    wire frame_done_mem;
    reg [15:0] in_pixel_x=0,in_pixel_y=0;
    reg in_pixel_de=0;
    wire [15:0] out_pixel_x,out_pixel_y;
    wire out_pixel_de;
    wire [7:0] out_y,out_cb,out_cr;
    wire out_bank_ready;
    wire [1:0] pixel_bank_ready;
    wire pixel_underflow;

    yuv420_scan_cache #(.FRAME_WIDTH(W),.FRAME_HEIGHT(H),.ADDR_BITS(21)) dut(
        .mem_clk(mem_clk),.mem_rst(mem_rst),.frame_start_mem(frame_start_mem),
        .frame_base_word(frame_base_word),.rd_cmd_valid(rd_cmd_valid),
        .rd_cmd_ready(rd_cmd_ready),.rd_cmd_addr(rd_cmd_addr),.rd_valid(rd_valid),
        .rd_data(rd_data),.frame_done_mem(frame_done_mem),
        .pixel_clk(pixel_clk),.pixel_rst(pixel_rst),.frame_start_pixel(frame_start_pixel),
        .in_pixel_x(in_pixel_x),.in_pixel_y(in_pixel_y),.in_pixel_de(in_pixel_de),
        .out_pixel_x(out_pixel_x),.out_pixel_y(out_pixel_y),.out_pixel_de(out_pixel_de),
        .out_y(out_y),.out_cb(out_cb),.out_cr(out_cr),.out_bank_ready(out_bank_ready),
        .pixel_bank_ready(pixel_bank_ready),.pixel_underflow(pixel_underflow));

    integer mem_cycles=0, cmd_count=0, return_count=0, pixel_count=0, underflows=0, done_count=0;
    integer mem_frame=0, pixel_frame=0;
    reg model_busy=0;
    reg [20:0] model_addr=0;
    integer model_delay=0, model_beat=0, model_gap=0;
    reg held_cmd=0;
    reg [20:0] held_cmd_addr=0;

    function [31:0] encoded_word;
        input [20:0] word_addr;
        integer lane;
        integer byte_address;
        reg [7:0] byte_value;
        begin
            encoded_word=32'd0;
            for(lane=0;lane<4;lane=lane+1) begin
                byte_address=word_addr*4+lane;
                byte_value=(byte_address*37+11)&255;
                encoded_word[lane*8 +: 8]=byte_value;
            end
        end
    endfunction

    always @* rd_cmd_ready = ((mem_cycles % 4) != 0) && !model_busy;
    always @(posedge mem_clk) begin
        if(mem_rst) begin
            mem_cycles<=0;rd_valid<=0;rd_data<=0;model_busy<=0;
            model_addr<=0;model_delay<=0;model_beat<=0;model_gap<=0;
            cmd_count<=0;return_count<=0;
            held_cmd<=0;held_cmd_addr<=0;
        end else begin
            mem_cycles<=mem_cycles+1;
            rd_valid<=0;
            if(rd_cmd_valid && model_busy)
                $fatal(1,"new command valid while previous BL4 is returning");
            if(held_cmd && (!rd_cmd_valid || rd_cmd_addr !== held_cmd_addr))
                $fatal(1,"command changed while waiting for cmd_ready");
            held_cmd <= rd_cmd_valid && !rd_cmd_ready;
            if(rd_cmd_valid && !rd_cmd_ready) held_cmd_addr<=rd_cmd_addr;
            if(rd_valid && !dut.outstanding_mem)
                $fatal(1,"return word observed without an outstanding command");
            if(frame_done_mem) done_count<=done_count+1;
            if(rd_cmd_valid && rd_cmd_ready) begin
                if(model_busy) $fatal(1,"more than one BL4 command outstanding");
                model_busy<=1;model_addr<=rd_cmd_addr;model_beat<=0;
                model_delay<=1+(cmd_count%3);model_gap<=0;
                $display("CMD %0d %0d %0d",mem_frame,cmd_count,rd_cmd_addr);
                cmd_count<=cmd_count+1;
            end else if(model_busy) begin
                if(model_delay>0)
                    model_delay<=model_delay-1;
                else if(model_beat==2 && !model_gap) begin
                    model_gap<=1;
                end else begin
                    rd_valid<=1;
                    rd_data<=encoded_word(model_addr+model_beat);
                    return_count<=return_count+1;
                    model_beat<=model_beat+1;
                    model_gap<=0;
                    if(model_beat==3)
                        model_busy<=0;
                end
            end
        end
    end

    always @(posedge pixel_clk) begin
        if(!pixel_rst && out_pixel_de) begin
            $display("PIX %0d %0d %0d %0d %0d %0d %0d %0d",
                     pixel_frame,out_pixel_x,out_pixel_y,out_y,out_cb,out_cr,
                     out_bank_ready,pixel_underflow);
            pixel_count<=pixel_count+1;
            if(pixel_underflow) underflows<=underflows+1;
        end
    end

    task automatic begin_frame;
        input integer frame_id;
        input integer base;
        begin
            pixel_frame=frame_id;mem_frame=frame_id;
            @(negedge pixel_clk);frame_start_pixel=1;in_pixel_de=0;
            @(negedge pixel_clk);frame_start_pixel=0;
            repeat(2) @(posedge pixel_clk);
            @(negedge mem_clk);frame_base_word=base;frame_start_mem=1;
            @(negedge mem_clk);frame_start_mem=0;
        end
    endtask

    task automatic wait_bank;
        input integer bank;
        integer timeout;
        begin
            timeout=0;
            while(!pixel_bank_ready[bank] && timeout<100000) begin
                @(posedge pixel_clk);timeout=timeout+1;
            end
            if(timeout>=100000) $fatal(1,"timeout waiting for bank %0d",bank);
        end
    endtask

    task automatic scan_frame;
        integer y,x,g;
        begin
            for(g=0;g<H/4;g=g+1) begin
                wait_bank(g&1);
                for(y=g*4;y<g*4+4;y=y+1) begin
                    for(x=0;x<W;x=x+1) begin
                        @(negedge pixel_clk);in_pixel_x=x;in_pixel_y=y;in_pixel_de=1;
                    end
                end
                @(negedge pixel_clk);in_pixel_de=0;
            end
            repeat(3) @(posedge pixel_clk);
        end
    endtask

    initial begin
        #31; @(negedge mem_clk);mem_rst=0;
        @(negedge pixel_clk);pixel_rst=0;
        begin_frame(0,0);
        scan_frame();
        repeat(5) @(posedge mem_clk);
        begin_frame(1,FRAME_WORDS);
        scan_frame();
        repeat(6) @(posedge mem_clk);
        if(cmd_count != 192) $fatal(1,"commands=%0d expected=192",cmd_count);
        if(return_count != 768) $fatal(1,"returns=%0d expected=768",return_count);
        if(done_count != 2) $fatal(1,"frame-done pulses=%0d expected=2",done_count);
        if(pixel_count != 2*W*H) $fatal(1,"pixels=%0d expected=%0d",pixel_count,2*W*H);
        if(underflows != 0) $fatal(1,"pixel underflows=%0d",underflows);
        $display("DONE commands=%0d returns=%0d pixels=%0d underflows=%0d",
                 cmd_count,return_count,pixel_count,underflows);
        $finish;
    end
    initial begin #10000000; $fatal(1,"global timeout"); end
endmodule
