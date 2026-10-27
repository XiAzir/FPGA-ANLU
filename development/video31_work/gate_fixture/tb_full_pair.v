`timescale 1ns/1ps
module tb_full_pair;
  reg aud_clk = 1'b0;
  reg rst = 1'b1;
  reg rst_n = 1'b0;
  integer cycles = 0;
  integer valid29 = 0, valid30 = 0;
  integer pcm_checked29 = 0, pcm_checked30 = 0;
  integer acr29 = 0, acr30 = 0;
  integer mismatch = 0, unknowns = 0;
  reg pcm_fail29 = 1'b0, pcm_fail30 = 1'b0;

  always #20 aud_clk = ~aud_clk;

  top29 d29u(.clk(1'b0), .key1(1'b1), .key2(1'b1), .rst_n(rst_n), .sd_miso(1'b1),
    .HDMI_CLK_P(), .HDMI_D0_P(), .HDMI_D1_P(), .HDMI_D2_P(), .led(), .sd_dclk(),
    .sd_mosi(), .sd_ncs(), .seg7_dio(), .seg7_rclk(), .seg7_sclk());
  top30 d30u(.clk(1'b0), .key1(1'b1), .key2(1'b1), .rst_n(rst_n), .sd_miso(1'b1),
    .HDMI_CLK_P(), .HDMI_D0_P(), .HDMI_D1_P(), .HDMI_D2_P(), .led(), .sd_dclk(),
    .sd_mosi(), .sd_ncs(), .seg7_dio(), .seg7_rclk(), .seg7_sclk());

  initial begin
    force d29u.video_clk = aud_clk;
    force d30u.\u_adjust_control/clk = aud_clk;
    force d29u.\u_audio_probe/tone_mode = 1'b1;
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
    force d30u.\u_audio_probe/tone_mode = 1'b1;
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
    repeat (4) @(posedge aud_clk);
    @(negedge aud_clk);
    rst = 1'b0;
    rst_n = 1'b1;
  end

  // Sample on negedge so the routed sequential outputs have settled after NBA updates.
  always @(negedge aud_clk) begin
    cycles = cycles + 1;
    if (cycles > 10) begin
      if ((^{d29u.\u_audio_probe/audio_valid , d30u.audio_valid}) === 1'bx ||
          (^{d29u.\u_audio_probe/audio_left , d30u.audio_left_data}) === 1'bx ||
          (^{d29u.\u_audio_probe/acr_n , d30u.\u_hdmi_1_4b_transmitter_core_wrapper/I_acr_n }) === 1'bx ||
          (^{d29u.\u_audio_probe/acr_cts , d30u.\u_hdmi_1_4b_transmitter_core_wrapper/I_acr_cts }) === 1'bx)
        unknowns = unknowns + 1;

      if (d29u.\u_audio_probe/audio_valid  === 1'b1) begin
        valid29 = valid29 + 1;
        if (pcm_checked29 == 0) begin
          if (d29u.\u_audio_probe/audio_left  !== 24'sd0) pcm_fail29 = 1'b1;
        end else if (d29u.\u_audio_probe/audio_left  !== 24'sd1000000 &&
                     d29u.\u_audio_probe/audio_left  !== -24'sd1000000) pcm_fail29 = 1'b1;
        pcm_checked29 = pcm_checked29 + 1;
      end
      if (d30u.audio_valid === 1'b1) begin
        valid30 = valid30 + 1;
        if (pcm_checked30 == 0) begin
          if (d30u.audio_left_data !== 24'sd0) pcm_fail30 = 1'b1;
        end else if (d30u.audio_left_data !== 24'sd1000000 &&
                     d30u.audio_left_data !== -24'sd1000000) pcm_fail30 = 1'b1;
        pcm_checked30 = pcm_checked30 + 1;
      end

      if (d29u.\u_audio_probe/audio_valid  !== d30u.audio_valid) mismatch = mismatch + 1;
      if (d29u.\u_audio_probe/audio_left  !== d30u.audio_left_data) mismatch = mismatch + 1;
      if (d29u.\u_audio_probe/acr_n  !== d30u.\u_hdmi_1_4b_transmitter_core_wrapper/I_acr_n ) mismatch = mismatch + 1;
      if (d29u.\u_audio_probe/acr_cts  !== d30u.\u_hdmi_1_4b_transmitter_core_wrapper/I_acr_cts ) mismatch = mismatch + 1;
      if (d29u.\u_audio_probe/acr_n  === 20'd6144) acr29 = acr29 + 1;
      if (d30u.\u_hdmi_1_4b_transmitter_core_wrapper/I_acr_n  === 20'd6144) acr30 = acr30 + 1;
    end

    if (cycles == 50010) begin
      if (unknowns != 0) $fatal(1, "FULL_PAIR_FAIL unknown audio/ACR observations=%0d", unknowns);
      if (mismatch != 0) $fatal(1, "FULL_PAIR_FAIL C29/C30 mismatch comparisons=%0d", mismatch);
      if (valid29 < 90 || valid29 > 100 || valid30 < 90 || valid30 > 100 || valid29 != valid30)
        $fatal(1, "FULL_PAIR_FAIL tone valid counts C29=%0d C30=%0d", valid29, valid30);
      if (pcm_fail29 || pcm_fail30 || pcm_checked29 != valid29 || pcm_checked30 != valid30)
        $fatal(1, "FULL_PAIR_FAIL tone PCM amplitude/first-zero check C29=%0d C30=%0d", pcm_fail29, pcm_fail30);
      if (acr29 < 1 || acr30 < 1) $fatal(1, "FULL_PAIR_FAIL ACR pulse counts C29=%0d C30=%0d", acr29, acr30);
      $display("FULL_PAIR_PASS cycles=%0d valid29=%0d valid30=%0d acr29=%0d acr30=%0d mismatch=%0d unknown=%0d tone29=%h tone30=%h acrN29=%h acrN30=%h acrCTS29=%h acrCTS30=%h", cycles, valid29, valid30, acr29, acr30, mismatch, unknowns, d29u.\u_audio_probe/u_tone/O_audio_left_data , d30u.\u_audio_probe/u_tone/O_audio_left_data , d29u.\u_audio_probe/acr_n , d30u.\u_hdmi_1_4b_transmitter_core_wrapper/I_acr_n , d29u.\u_audio_probe/acr_cts , d30u.\u_hdmi_1_4b_transmitter_core_wrapper/I_acr_cts );
      $finish;
    end
  end
endmodule
