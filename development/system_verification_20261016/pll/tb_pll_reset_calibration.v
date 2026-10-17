`timescale 1ns/1ps
module tb_pll_reset_calibration;
  reg refclk = 0;
  reg reset = 0;
  wire slock, vlock, s0, s1, s2, pclk, serclk;
  integer pc=0, sc=0;
  realtime last_pclk=0.0, last_serclk=0.0;
  realtime period_pclk_ns=0.0, period_serclk_ns=0.0;
  reg pulse_mode;
  sys_pll spll(.refclk(refclk), .reset(reset), .extlock(slock), .clk0_out(s0), .clk1_out(s1), .clk2_out(s2));
  video_pll vpll(.refclk(refclk), .reset(reset), .extlock(vlock), .clk0_out(pclk), .clk1_out(serclk));
  always #10 refclk = ~refclk;
  always @(posedge pclk) begin
    pc = pc + 1;
    if (pc > 1) period_pclk_ns = $realtime - last_pclk;
    last_pclk = $realtime;
  end
  always @(posedge serclk) begin
    sc = sc + 1;
    if (sc > 1) period_serclk_ns = $realtime - last_serclk;
    last_serclk = $realtime;
  end
  always @(posedge slock) $display("LOCK sys at %0.3f ns", $realtime);
  always @(posedge vlock) $display("LOCK video at %0.3f ns", $realtime);

  task sample;
    input integer label;
    begin
      $display("SAMPLE us=%0d t_ns=%0.3f reset=%b slock=%b vlock=%b pc=%0d sc=%0d pclk_period_ns=%0.3f serclk_period_ns=%0.3f", label, $realtime, reset, slock, vlock, pc, sc, period_pclk_ns, period_serclk_ns);
      $display("SYS_INTERNAL pllrst_n=%b lock_cnt=%b ilock_rls=%b elock_rls=%b int_lock=%b fakelockcnt=%b refclk_toggle_smpl=%b pulse_count=%0d tmp_time_value=%0d", spll.pll_inst.pllrst_n, spll.pll_inst.lock_cnt, spll.pll_inst.ilock_rls, spll.pll_inst.elock_rls, spll.pll_inst.int_lock, spll.pll_inst.fakelockcnt, spll.pll_inst.refclk_toggle_smpl, spll.pll_inst.pulse_count, spll.pll_inst.tmp_time_value);
      $display("VID_INTERNAL pllrst_n=%b lock_cnt=%b ilock_rls=%b elock_rls=%b int_lock=%b fakelockcnt=%b refclk_toggle_smpl=%b pulse_count=%0d tmp_time_value=%0d", vpll.pll_inst.pllrst_n, vpll.pll_inst.lock_cnt, vpll.pll_inst.ilock_rls, vpll.pll_inst.elock_rls, vpll.pll_inst.int_lock, vpll.pll_inst.fakelockcnt, vpll.pll_inst.refclk_toggle_smpl, vpll.pll_inst.pulse_count, vpll.pll_inst.tmp_time_value);
    end
  endtask

  initial begin
    pulse_mode = $test$plusargs("PULSE");
    if ($test$plusargs("MODEL_ADAPTER")) $display("CASE reset_pulse=%b; source=local one-line initialization adapter", pulse_mode);
    else $display("CASE reset_pulse=%b; source=unmodified vendor EG_PHY_PLL", pulse_mode);
    if (pulse_mode) begin
      #20 reset = 1'b1;
      #100 reset = 1'b0;
    end
    #(1000-$time); sample(1);
    #99000; sample(100);
    #900000; sample(1000);
    if (slock === 1'b1 && vlock === 1'b1) $display("RESULT PASS_BOTH_LOCKED");
    else if (slock === 1'b0 && vlock === 1'b0) $display("RESULT FAIL_BOTH_UNLOCKED");
    else $display("RESULT FAIL_MIXED_LOCK");
    $finish;
  end
endmodule



