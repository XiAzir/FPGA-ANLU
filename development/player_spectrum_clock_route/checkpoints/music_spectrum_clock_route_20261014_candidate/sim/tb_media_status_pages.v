`timescale 1ns/1ps
module tb_media_status_pages;
reg clk=0,rst=1;
always #10 clk=~clk;
wire [31:0] value;
player_status_monitor #(.PIXEL_HZ(10),.SYS_HZ(10),.PAGE_SECONDS(1),.SHOW_SELF_TEST(0)) dut(
 .pixel_clk(clk),.sys_clk(clk),.rst(rst),.sys_rst(rst),
 .axis_rgb(24'd0),.axis_valid(1'b0),.axis_user(1'b0),.hdmi_locked(1'b0),
 .audio_valid(1'b0),.tone_mode(1'b0),.underflow(1'b0),.audio_pcm(24'd0),
 .startup_flags(4'd0),.file_flags(8'd0),.fs_code(8'd0),.wav_map_code(8'd0),
 .packet_samples(24'd0),.packet_count(24'd0),.packet_bad_bch(24'd0),
 .packet_bad_terc(24'd0),.packet_tone_bad(24'd0),.packet_cts(24'h123456),
 .packet_n(24'hFE035F),.packet_flags(4'h7),
 .bmp_diag({3'd4,24'h020001}),.sd_crc_diag(32'h000500AA),.hex_value(value),
 .window_toggle_out(),.cw_count_data(),.cw_count_trigger());
initial begin
 #35 rst=0;
 wait(value===32'hB7123456);
 wait(value===32'hC7FE035F);
 wait(value===32'hDFC11309);
 wait(value===32'hE4020001);
 wait(value===32'hF0000005);
 wait(value===32'hF10000AA);
 wait(value===32'h10000000);
 $display("PASS media_status_pages B/C/D/E/F0/F1 and cycle wrap");$finish;
end
initial begin #10000;$fatal(1,"status page timeout value=%h",value);end
endmodule
