`timescale 1ns/100fs
module tb_startup_clock;
  reg clk = 1'b0;
  reg rst_n = 1'b0;
  reg lock_enable = 1'b0;
  wire sys_lock_nominal, video_lock_nominal;
  wire sys50, mem50, mem50_shift, video_clk, serial_clk;
  wire sys_lock = sys_lock_nominal & lock_enable;
  wire video_lock = video_lock_nominal & lock_enable;
  wire [19:0] old_count, new_count;
  wire old_reset, new_reset;
  reg full_run = 1'b0;
  integer old_edges = 0;
  integer new_edges = 0;
  reg old_done = 1'b0;
  reg new_done = 1'b0;

  always #10 clk = ~clk;

  sys_pll sys_pll_m0(.refclk(clk),.reset(1'b0),.extlock(sys_lock_nominal),
    .clk0_out(sys50),.clk1_out(mem50),.clk2_out(mem50_shift));
  video_pll video_pll_m0(.refclk(clk),.reset(1'b0),.extlock(video_lock_nominal),
    .clk0_out(video_clk),.clk1_out(serial_clk));

  startup_old u_old(.clk(clk),.sd_card_clk(sys50),.rst_n(rst_n),
    .sys_pll_lock(sys_lock),.video_pll_lock(video_lock),
    .rst_cnt_o(old_count),.rst_all_reg_o(old_reset));
  startup_new u_new(.clk(clk),.sd_card_clk(sys50),.rst_n(rst_n),
    .sys_pll_lock(sys_lock),.video_pll_lock(video_lock),
    .rst_cnt_o(new_count),.rst_all_reg_o(new_reset));

  always @(posedge clk) begin
    if (full_run && !old_done) begin
      old_edges = old_edges + 1;
      #0.001;
      if (old_edges <= 1000000 && old_reset !== 1'b1)
        $fatal(1,"old reset released early at edge %0d count=%0d",old_edges,old_count);
      if (old_edges == 1000001) begin
        if (old_reset !== 1'b0 || old_count !== 20'd1000000)
          $fatal(1,"old release mismatch edge=%0d reset=%b count=%0d",old_edges,old_reset,old_count);
        old_done = 1'b1;
      end
    end
  end

  always @(posedge sys50) begin
    if (full_run && !new_done) begin
      new_edges = new_edges + 1;
      #0.001;
      if (new_edges <= 1000000 && new_reset !== 1'b1)
        $fatal(1,"new reset released early at edge %0d count=%0d",new_edges,new_count);
      if (new_edges == 1000001) begin
        if (new_reset !== 1'b0 || new_count !== 20'd1000000)
          $fatal(1,"new release mismatch edge=%0d reset=%b count=%0d",new_edges,new_reset,new_count);
        new_done = 1'b1;
      end
    end
  end

  task begin_full_count;
    begin
      old_edges = 0;
      new_edges = 0;
      old_done = 1'b0;
      new_done = 1'b0;
      @(negedge clk);
      full_run = 1'b1;
      lock_enable = 1'b1;
      wait(old_done && new_done);
      full_run = 1'b0;
      #0.01;
      $display("FULL_COUNT_PASS old_edges=%0d new_edges=%0d old_cnt=%0d new_cnt=%0d",
        old_edges,new_edges,old_count,new_count);
    end
  endtask

  initial begin
    wait(sys_lock_nominal && video_lock_nominal);
    repeat (3) @(posedge clk);
    #0.01;
    if (old_count !== 0 || new_count !== 0 || old_reset !== 1'b1 || new_reset !== 1'b1)
      $fatal(1,"external reset did not hold initial state");

    @(negedge clk); rst_n = 1'b1;
    repeat (5) @(posedge sys50);
    #0.01;
    if (old_count !== 0 || new_count !== 0 || old_reset !== 1'b1 || new_reset !== 1'b1)
      $fatal(1,"counter advanced while PLL lock gate was low");

    @(negedge clk); lock_enable = 1'b1;
    repeat (100) @(posedge clk);
    @(negedge clk); lock_enable = 1'b0;
    repeat (3) @(posedge clk);
    repeat (3) @(posedge sys50);
    #0.01;
    if (old_count !== 0 || new_count !== 0 || old_reset !== 1'b1 || new_reset !== 1'b1)
      $fatal(1,"loss of lock before qualification did not clear startup count");
    $display("UNSTABLE_LOCK_CLEAR_PASS old_cnt=%0d new_cnt=%0d",old_count,new_count);

    begin_full_count();

    @(negedge clk); rst_n = 1'b0; lock_enable = 1'b0;
    repeat (3) @(posedge clk);
    repeat (3) @(posedge sys50);
    #0.01;
    if (old_count !== 0 || new_count !== 0 || old_reset !== 1'b1 || new_reset !== 1'b1)
      $fatal(1,"runtime reset did not restart both startup controllers");
    @(negedge clk); rst_n = 1'b1;
    begin_full_count();

    @(negedge clk); lock_enable = 1'b0;
    repeat (3) @(posedge clk);
    repeat (3) @(posedge sys50);
    #0.01;
    if (old_reset !== 1'b0 || new_reset !== 1'b0 ||
        old_count !== 20'd1000000 || new_count !== 20'd1000000)
      $fatal(1,"post-release lock drop changed sticky released state");
    $display("POST_RELEASE_LOCK_DROP_PASS old_reset=%b new_reset=%b",old_reset,new_reset);
    $display("STARTUP_CLOCK_UNIT_PASS nominal_locks=%b/%b sys50=%0.3f video=%0.3f serial=%0.3f",
      sys_lock_nominal,video_lock_nominal,sys50,video_clk,serial_clk);
    $finish;
  end
endmodule
