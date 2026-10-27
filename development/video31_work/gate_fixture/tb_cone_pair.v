`timescale 1ns/1ps
module tb_cone_pair;
 reg clk=0, rst=1;
 integer cycles=0, valid29=0, valid30=0, acr29=0, acr30=0, mismatch=0, unknowns=0;
 always #20 clk=~clk;
 audio_cone29 d29u(.clk(clk),.key1(1'b1),.key2(1'b1),.rst_n(~rst),.sd_miso(1'b1),.HDMI_CLK_P(),.HDMI_D0_P(),.HDMI_D1_P(),.HDMI_D2_P(),.led(),.sd_dclk(),.sd_mosi(),.sd_ncs(),.seg7_dio(),.seg7_rclk(),.seg7_sclk());
 audio_cone30 d30u(.clk(clk),.key1(1'b1),.key2(1'b1),.rst_n(~rst),.sd_miso(1'b1),.HDMI_CLK_P(),.HDMI_D0_P(),.HDMI_D1_P(),.HDMI_D2_P(),.led(),.sd_dclk(),.sd_mosi(),.sd_ncs(),.seg7_dio(),.seg7_rclk(),.seg7_sclk());
 initial begin
   force d29u.video_clk = clk;
   force d30u.\u_adjust_control/clk = clk;
   force d29u.\u_audio_probe/tone_mode = 1'b1;
   force d30u.\u_audio_probe/tone_mode = 1'b1;
   force d29u.\u_audio_probe/audio_valid = d29u.\u_audio_probe/tone_valid ;
   force d30u.audio_valid = d30u.\u_audio_probe/tone_valid ;
   force d29u.\u_audio_probe/audio_left = d29u.\u_audio_probe/u_tone/O_audio_left_data ;
   force d30u.audio_left_data = d30u.\u_audio_probe/u_tone/O_audio_left_data ;
   force d29u.rst_all_dup_102 = rst;
   force d29u.rst_all_dup_104 = rst;
   force d29u.rst_all_dup_107 = rst;
   force d29u.rst_all_dup_112 = rst;
   force d29u.rst_all_dup_114 = rst;
   force d29u.rst_all_dup_116 = rst;
   force d29u.rst_all_dup_119 = rst;
   force d29u.rst_all_dup_124 = rst;
   force d29u.rst_all_dup_125 = rst;
   force d29u.rst_all_dup_127 = rst;
   force d29u.rst_all_dup_128 = rst;
   force d29u.rst_all_dup_14 = rst;
   force d29u.rst_all_dup_24 = rst;
   force d29u.rst_all_dup_27 = rst;
   force d29u.rst_all_dup_49 = rst;
   force d29u.rst_all_dup_53 = rst;
   force d29u.rst_all_dup_92 = rst;
   force d29u.rst_all_dup_93 = rst;
   force d29u.rst_all_dup_94 = rst;
   force d30u.\u_file_mapper/rst_dup_101 = rst;
   force d30u.\u_file_mapper/rst_dup_102 = rst;
   force d30u.\u_file_mapper/rst_dup_15 = rst;
   force d30u.\u_file_mapper/rst_dup_24 = rst;
   force d30u.\u_file_mapper/rst_dup_26 = rst;
   force d30u.\u_file_mapper/rst_dup_27 = rst;
   force d30u.\u_file_mapper/rst_dup_58 = rst;
   force d30u.\u_file_mapper/rst_dup_59 = rst;
   force d30u.\u_file_mapper/rst_dup_67 = rst;
   force d30u.\u_file_mapper/rst_dup_68 = rst;
   force d30u.\u_file_mapper/rst_dup_73 = rst;
   force d30u.\u_file_mapper/rst_dup_79 = rst;
   force d30u.\u_file_mapper/rst_dup_86 = rst;
   force d30u.\u_file_mapper/rst_dup_93 = rst;
   repeat (4) @(posedge clk); rst=0;
 end
 always @(posedge clk) begin
   cycles=cycles+1;
   if (cycles>10) begin
     if (d29u.\u_audio_probe/tone_valid  === 1'b1) valid29=valid29+1;
     if (d30u.\u_audio_probe/tone_valid  === 1'b1) valid30=valid30+1;
     if (d29u.\u_audio_probe/tone_valid  === 1'bx || d30u.\u_audio_probe/tone_valid  === 1'bx) unknowns=unknowns+1;
     if (d29u.\u_audio_probe/tone_valid  !== d30u.\u_audio_probe/tone_valid ) mismatch=mismatch+1;
     if (d29u.\u_audio_probe/u_tone/O_audio_left_data  !== d30u.\u_audio_probe/u_tone/O_audio_left_data ) mismatch=mismatch+1;
   end
   if (cycles==50010) begin
     $display("CONE_RESULT cycles=%0d valid29=%0d valid30=%0d mismatch=%0d unknown=%0d tone29=%h tone30=%h",cycles,valid29,valid30,mismatch,unknowns,d29u.\u_audio_probe/u_tone/O_audio_left_data ,d30u.\u_audio_probe/u_tone/O_audio_left_data );
     $finish;
   end
 end
endmodule
