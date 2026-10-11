`timescale 1ns/1ps
module tb_player_osd_state;
    reg sd_clk=0, pixel_clk=0, rst=1, read_req=0;
    always #13 sd_clk=~sd_clk; // Deliberately not harmonic to the pixel clock.
    always #20 pixel_clk=~pixel_clk;
    reg [1:0] source_buffer=0, source_image=0;
    reg [2:0] source_count=0;
    reg source_auto=0, source_valid=0;
    wire read_req_out, frame_auto, frame_valid;
    wire [1:0] frame_buffer, frame_image;
    wire [2:0] frame_count;
    wire [8:0] frame={frame_valid,frame_buffer,frame_image,frame_count,frame_auto};
    integer assertions=0, i;
    reg [8:0] expected;
    player_osd_state dut(.*);

    task check;
        input condition;
        input [255:0] label;
        begin
            assertions=assertions+1;
            if(condition !== 1'b1) $fatal(1,"FAIL %0s frame=%h expected=%h",label,frame,expected);
        end
    endtask
    task publish;
        input [8:0] data;
        begin
            @(negedge sd_clk);
            {source_valid,source_buffer,source_image,source_count,source_auto}=data;
        end
    endtask
    task request_and_hold;
        input [8:0] data;
        begin
            expected=data;
            @(negedge pixel_clk); read_req=1;
            #1; check(!read_req_out,"request has one-cycle delay");
            @(posedge pixel_clk); #1;
            check(read_req_out,"delayed request high");
            check(frame===expected,"complete selected bundle");
            // Source changes while the memory request is held; the selected
            // buffer, its number, count, validity, and mode must stay together.
            publish(~data);
            repeat(15) begin
                @(posedge pixel_clk); #1;
                check(frame===expected,"no mid-request status change");
                check(read_req_out,"request remains high until ACK");
            end
            @(negedge pixel_clk); read_req=0;
            #1; check(read_req_out,"deassert also delayed");
            @(posedge pixel_clk); #1;
            check(!read_req_out,"delayed request released");
            repeat(3) begin
                @(posedge pixel_clk); #1; check(frame===expected,"held through active frame");
            end
        end
    endtask

    initial begin
        repeat(3) @(posedge pixel_clk);
        @(negedge pixel_clk); rst=0;
        repeat(14) @(posedge pixel_clk);
        check(frame==0,"startup invalid frame");
        request_and_hold(9'd0);
        for(i=0;i<20;i=i+1) begin
            expected={1'b1,i[0],1'b0,i[1:0],3'd4,i[0]};
            // The two buffer bits are intentional independent bus stress.
            publish(expected);
            repeat(14) @(posedge pixel_clk);
            request_and_hold(expected);
        end
        @(negedge pixel_clk); rst=1;
        #1; check(frame==0 && !read_req_out,"asynchronous reset clears state");
        @(negedge pixel_clk); rst=0;
        publish({1'b1,2'd1,2'd1,3'd2,1'b1});
        repeat(14) @(posedge pixel_clk);
        request_and_hold({1'b1,2'd1,2'd1,3'd2,1'b1});
        $display("PASS coherent dual-clock mailbox and frame selection: %0d assertions",assertions);
        $finish;
    end
    initial begin #1000000; $fatal(1,"timeout"); end
endmodule
