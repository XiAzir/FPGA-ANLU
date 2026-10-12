`timescale 1ns/1ps
module tb_status_pages;
    reg clk=0;
    reg rst=1;
    wire [31:0] hex_value;
    wire [9:0] cw_count_data;
    wire cw_count_trigger;
    always #5 clk=~clk;

    player_status_monitor #(
        .PIXEL_HZ(8), .SYS_HZ(2), .PAGE_SECONDS(2),
        .SHOW_SELF_TEST(1), .BUILD_ID(24'hC11108)
    ) dut (
        .pixel_clk(clk), .sys_clk(clk), .rst(rst), .sys_rst(rst),
        .axis_rgb(24'd0), .axis_valid(1'b0), .axis_user(1'b0),
        .hdmi_locked(1'b0), .audio_valid(1'b0), .tone_mode(1'b0),
        .underflow(1'b0), .audio_pcm(24'd0),
        .startup_flags(4'd0), .file_flags(8'd0), .fs_code(8'd0),
        .wav_map_code(8'd0),
        .packet_samples(24'h123456), .packet_count(24'h234567),
        .packet_bad_bch(24'h345678), .packet_bad_terc(24'h456789),
        .packet_tone_bad(24'h56789A), .packet_cts(24'h0ABCDE),
        .packet_n(24'h006144), .packet_flags(4'hA),
        .window_toggle_out(), .hex_value(hex_value),
        .cw_count_data(cw_count_data), .cw_count_trigger(cw_count_trigger)
    );

    task check_value;
        input [31:0] expected;
        input [255:0] label;
        begin
            #1;
            if (hex_value !== expected) begin
                $display("FAIL %0s expected=%08h actual=%08h",label,expected,hex_value);
                $fatal(1);
            end
            $display("PASS %0s %08h",label,hex_value);
        end
    endtask

    task advance_page;
        integer i;
        begin
            for(i=0;i<4;i=i+1) @(posedge clk);
            #1;
        end
    endtask

    integer i;
    reg [31:0] expected_pages [0:9];
    initial begin
        expected_pages[0]=32'h10000000;
        expected_pages[1]=32'h30000000;
        expected_pages[2]=32'h6A123456;
        expected_pages[3]=32'h7A234567;
        expected_pages[4]=32'h8A345678;
        expected_pages[5]=32'h9A456789;
        expected_pages[6]=32'hAA56789A;
        expected_pages[7]=32'hBA0ABCDE;
        expected_pages[8]=32'hCA006144;
        expected_pages[9]=32'hDFC11108;

        repeat(2) @(posedge clk);
        rst=0;
        check_value(32'h01234567,"self-test-1");
        advance_page();
        check_value(32'h88888888,"self-test-2");
        advance_page();
        for(i=0;i<10;i=i+1) begin
            check_value(expected_pages[i],"status-page");
            advance_page();
        end
        check_value(32'h10000000,"wrap-to-page-1");
        $display("PASS all status pages and wrap");
        $finish;
    end
endmodule
