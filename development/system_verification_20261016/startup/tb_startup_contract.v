`timescale 1ns/1ps
module tb_startup_contract;
 reg clk=0,rst_n=0,sys_lock=0,video_lock=0;
 wire rst_all;
 wire [19:0] count;
 startup_contract dut(.clk(clk),.rst_n(rst_n),.sys_pll_lock(sys_lock),
  .video_pll_lock(video_lock),.rst_all(rst_all),.count(count));
 always #10 clk=~clk;
 integer checks=0,ready_edges=0,releases=0,wait_edges;
 reg expected_hold=1;
 reg was_hold=1;
 always @(posedge clk)begin
  if(!rst_n)begin expected_hold=1;ready_edges=0;end
  else if(expected_hold)begin
   if(sys_lock===1'b1 && video_lock===1'b1)begin
    ready_edges=ready_edges+1;
    if(ready_edges==1000001)expected_hold=0;
   end else ready_edges=0;
  end
  #1;
  checks=checks+1;
  if(rst_all!==expected_hold)
   $fatal(1,"reset contract mismatch cycle=%0d lock=%b%b edges=%0d got=%b expected=%b count=%h",checks,sys_lock,video_lock,ready_edges,rst_all,expected_hold,count);
  if(was_hold && !rst_all)begin
   releases=releases+1;
   $display("RESET_RELEASE n=%0d cycles=%0d consecutive_lock_edges=%0d count=%0d",releases,checks,ready_edges,count);
  end
  was_hold=rst_all;
 end
 task await_release;
  begin
   wait_edges=0;
   while(rst_all!==1'b0 && wait_edges<1000020)begin
    @(negedge clk);wait_edges=wait_edges+1;
   end
   if(rst_all!==1'b0)$fatal(1,"reset failed to release");
  end
 endtask
 initial begin
  $display("BOUNDARY archived original 1000000-cycle controller, no counter force or shortened wait; lock inputs are explicit test stimuli, PLL/media/HDMI not included");
  repeat(5)@(negedge clk);rst_n=1;
  repeat(100)@(negedge clk);
  if(rst_all!==1)$fatal(1,"released without PLL locks");
  sys_lock=1;
  repeat(100)@(negedge clk);
  if(rst_all!==1)$fatal(1,"released with only one PLL locked");
  video_lock=1;
  await_release;
  $display("CASE normal_cold_start PASS");
  sys_lock=0;video_lock=0;
  repeat(25)@(negedge clk);
  if(rst_all!==0)$fatal(1,"post-start lock glitch violated archived latch policy");
  $display("CASE post_start_lock_drop_preserves_existing_policy PASS");
  rst_n=0;
  repeat(5)@(negedge clk);rst_n=1;
  sys_lock=1;video_lock=1;
  repeat(1000)@(negedge clk);video_lock=0;
  repeat(7)@(negedge clk);
  if(count!==0 || rst_all!==1)$fatal(1,"pre-start lock loss did not restart wait");
  video_lock=1;
  await_release;
  $display("CASE lock_loss_during_start_restarts_full_wait PASS");
  rst_n=0;
  repeat(5)@(negedge clk);rst_n=1;
  await_release;
  $display("CASE external_reset_repeats_full_wait PASS");
  if(releases!=3)$fatal(1,"wrong release count=%0d",releases);
  $display("PASS startup_contract scenarios=5 releases=3 minimum_full_lock_edges=1000001 checks=%0d",checks);
  $finish;
 end
 initial begin #65000000;$fatal(1,"startup contract timeout");end
endmodule
