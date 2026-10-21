`timescale 1ns/1ps
module tb_review_timeout_priority;
 reg clk=0,rst=1,bmp_read=0;
 always #5 clk=~clk;
 wire bmp_end,bmp_error,sd_read;
 wire [7:0] bmp_code;
 wire [31:0] sd_addr;
 fat32_dual_file_sector #(.WAIT_LIMIT(8)) dut(
  .clk(clk),.rst(rst),.fat_lba(32'd200),.data_lba(32'd100),.cluster_count(32'd10),.sectors_per_cluster_shift(4'd0),
  .bmp_enable(1'b1),.bmp_start_cluster(32'd2),.bmp_file_size(32'd512),.bmp_file_read(bmp_read),.bmp_file_sector(32'd0),
  .bmp_file_data(),.bmp_file_valid(),.bmp_file_end(bmp_end),.bmp_error(bmp_error),.bmp_error_code(bmp_code),
  .wav_enable(1'b0),.wav_start_cluster(32'd2),.wav_file_size(32'd512),.wav_file_read(1'b0),.wav_file_sector(32'd0),
  .wav_file_data(),.wav_file_valid(),.wav_file_end(),.wav_error(),.wav_error_code(),
  .sd_read(sd_read),.sd_addr(sd_addr),.sd_data(8'd0),.sd_valid(1'b0),.sd_end(1'b0));
 initial begin
  repeat(3) @(negedge clk); rst=0;
  bmp_read=0; repeat(2) @(negedge clk); bmp_read=1;
  wait(dut.core_state==dut.C_SETUP);
  @(negedge clk); dut.wait_count[0]=7;
  @(posedge clk); #1;
  if(!bmp_error || bmp_code!=8'h0a || dut.core_state!=dut.C_IDLE || dut.busy[0] || sd_read)
   $fatal(1,"C_SETUP timeout must dominate setup dispatch: error=%b/%h state=%0d busy=%b sd=%b",bmp_error,bmp_code,dut.core_state,dut.busy[0],sd_read);
  $display("PASS C_SETUP timeout dominates dispatch; no physical read after E_TIMEOUT");

  @(negedge clk); rst=1; bmp_read=0;
  repeat(3) @(negedge clk); rst=0;
  @(negedge clk);
  dut.active_client=1; dut.busy[0]=1; dut.queued[0]=1; dut.core_state=dut.C_IDLE; dut.wait_count[0]=7;
  @(posedge clk); #1;
  if(!bmp_error || bmp_code!=8'h0a || dut.busy[0] || dut.queued[0] || dut.core_state!=dut.C_SETUP || dut.active_client!=0 || sd_read)
   $fatal(1,"C_IDLE queued timeout/select collision unexpected: error=%b/%h state=%0d busy=%b queued=%b active=%b sd=%b",bmp_error,bmp_code,dut.core_state,dut.busy[0],dut.queued[0],dut.active_client,sd_read);
  @(posedge clk); #1;
  if(sd_read || dut.core_state!=dut.C_IDLE)
   $fatal(1,"stale queue selection must be discarded by C_SETUP: sd_read=%b state=%0d",sd_read,dut.core_state);
  $display("PASS C_IDLE timeout/selection can transiently select stale queued client, then C_SETUP drops it before SD dispatch");
  $finish;
 end
 initial begin #2000; $fatal(1,"timeout"); end
endmodule
