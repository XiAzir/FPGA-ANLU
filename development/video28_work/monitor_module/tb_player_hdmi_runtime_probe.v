`timescale 1ns/1ps
module tb_player_hdmi_runtime_probe;
    reg pixel_clk=0;
    always #20 pixel_clk=~pixel_clk; // 25 MHz

    reg serial_clk=0;
    reg serial_clk_run=1;
    always begin
        #4;
        if (serial_clk_run) serial_clk=~serial_clk;
        else serial_clk=0;
    end // 125 MHz while enabled

    reg serial_clock_out=0;
    reg serial_out_run=1;
    always begin
        #20;
        if (serial_out_run) serial_clock_out=~serial_clock_out;
        else serial_clock_out=0;
    end // 25 MHz output, 256 transitions per 128-pixel window

    reg cold_rst=1, media_rst=0;
    reg locked=0, axis_ready=1, axis_valid=0, axis_user=0;
    reg hs=0, vs=0, de=0;
    reg [9:0] tmds_clock_word=10'h2d5;
    wire [31:0] page_e, page_f;
    integer line, checked_lines=0;

    player_hdmi_runtime_probe dut(
        .pixel_clk(pixel_clk),.serial_clk(serial_clk),.cold_rst(cold_rst),.media_rst(media_rst),
        .locked(locked),.axis_ready(axis_ready),.axis_valid(axis_valid),.axis_user(axis_user),
        .hs(hs),.vs(vs),.de(de),.serial_clock_out(serial_clock_out),
        .tmds_clock_word(tmds_clock_word),.page_e(page_e),.page_f(page_f)
    );

    task wait_windows;
        input integer n;
        begin repeat(n*128+4) @(posedge pixel_clk); end
    endtask

    task send_line;
        input is_sof;
        begin
            @(negedge pixel_clk);
            axis_valid=1; axis_user=is_sof; axis_ready=1; de=1; hs=0; vs=0;
            @(negedge pixel_clk);
            axis_valid=0; axis_user=0; de=0; hs=1;
        end
    endtask

    initial begin
        repeat(6) @(negedge pixel_clk);
        cold_rst=0;
        locked=1;
        wait_windows(5);
        if(page_e[31:28]!==4'hE || page_f[31:28]!==4'hF) $fatal(1,"page tag");
        if(page_e[27]!==1'b1 || page_e[26]!==1'b1 || page_e[25]!==1'b0) $fatal(1,"initial lock flags %h",page_e[27:24]);
        if(page_f[27:18]!==tmds_clock_word) $fatal(1,"TMDS word mismatch %h",page_f[27:18]);
        if(page_f[7:0]!==8'd0) $fatal(1,"F tail must stay fixed at zero");
        if(page_f[17:8]<10'd254 || page_f[17:8]>10'd258) $fatal(1,"continuous activity delta=%0d",page_f[17:8]);

        // Sticky ready/de evidence.
        @(negedge pixel_clk); axis_valid=1; axis_ready=0; de=1;
        @(negedge pixel_clk); axis_valid=0; axis_ready=1; de=0;
        repeat(2) @(posedge pixel_clk);
        if(page_e[1:0]!==2'b11) $fatal(1,"sticky ready/de flags %b",page_e[1:0]);

        // Media reset must clear row tracking without inventing lock loss.
        media_rst=1; locked=1;
        repeat(4) @(posedge pixel_clk);
        locked=0;
        repeat(4) @(posedge pixel_clk);
        media_rst=0;
        repeat(3) @(posedge pixel_clk);
        if(page_e[25]!==1'b0) $fatal(1,"media reset caused lock_lost");
        if(page_e[26]!==1'b1) $fatal(1,"lock_seen lost across media reset");

        // An observed post-reset lock falling edge must set sticky lock_lost.
        locked=1; repeat(3) @(posedge pixel_clk);
        locked=0; repeat(3) @(posedge pixel_clk);
        if(page_e[25]!==1'b1) $fatal(1,"real lock loss not recorded");

        // One complete 480-line frame followed by the next SOF commits 480.
        for(line=0;line<480;line=line+1) send_line(line==0);
        send_line(1'b1);
        repeat(2) @(posedge pixel_clk);
        if(page_e[23:16]!==8'd2) $fatal(1,"SOF count=%0d",page_e[23:16]);
        if(page_e[15:6]!==10'd480) $fatal(1,"last-frame lines=%0d",page_e[15:6]);
        if(dut.line_count!==10'd1) $fatal(1,"SOF line inclusion count=%0d",dut.line_count);
        checked_lines=page_e[15:6];

        // Row statistics reset on media reset; cold-reset sticky SOF count persists.
        media_rst=1; repeat(3) @(posedge pixel_clk); media_rst=0;
        repeat(2) @(posedge pixel_clk);
        if(page_e[23:16]!==8'd2 || page_e[15:6]!==10'd0) $fatal(1,"media reset counters %h",page_e[23:6]);

        // Stop only the logical output clock. The measured edge delta must fall to zero.
        serial_out_run=0;
        wait_windows(4);
        if(page_f[17:8]!==10'd0) $fatal(1,"stopped output delta=%0d",page_f[17:8]);
        serial_out_run=1;
        wait_windows(4);
        if(page_f[17:8]<10'd254 || page_f[17:8]>10'd258) $fatal(1,"output restart delta=%0d",page_f[17:8]);

        // Stop the sampling clock with the output still toggling; delta must also fall to zero.
        serial_clk_run=0;
        wait_windows(4);
        if(page_f[17:8]!==10'd0) $fatal(1,"stopped serial_clk delta=%0d",page_f[17:8]);
        serial_clk_run=1;
        wait_windows(4);
        if(page_f[17:8]<10'd254 || page_f[17:8]>10'd258) $fatal(1,"serial_clk restart delta=%0d",page_f[17:8]);

        if(page_f[7:0]!==8'd0) $fatal(1,"F tail changed from zero");
        $display("HDMI_PROBE_PASS sof=%0d lines_checked=%0d lines_after_reset=%0d lock_seen=%b lock_lost=%b ready_wait=%b de_seen=%b delta=%0d timer=%0d tail=%h tmds=%h",
            page_e[23:16],checked_lines,page_e[15:6],page_e[26],page_e[25],page_e[1],page_e[0],page_f[17:8],dut.window_timer,page_f[7:0],page_f[27:18]);
        cold_rst=1;
        repeat(2) @(posedge pixel_clk);
        if(page_e[26]!==1'b0 || page_e[25]!==1'b0 || page_e[23:6]!==18'd0 || page_e[1:0]!==2'b00)
            $fatal(1,"cold reset did not clear sticky/frame state E=%h",page_e);
        if(page_f[17:0]!==18'd0) $fatal(1,"cold reset did not clear serial window F=%h",page_f);
        $display("COLD_RESET_PASS sticky=0 sof=0 lines=0 delta=0 window=0");
        $finish;
    end

    initial begin
        #1000000;
        $fatal(1,"test timeout E=%h F=%h",page_e,page_f);
    end
endmodule
