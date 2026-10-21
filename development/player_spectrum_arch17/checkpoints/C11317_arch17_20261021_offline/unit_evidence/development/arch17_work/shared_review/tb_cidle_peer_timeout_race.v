`timescale 1ns/1ps
module tb_cidle_peer_timeout_race #(parameter EXPECT_FIXED=0);
 reg clk=0, rst=1, bmp_read=0, wav_read=0;
 always #5 clk=~clk;
 wire bmp_end,wav_end,bmp_error,wav_error,sd_read;
 wire [7:0] bmp_code,wav_code;
 wire [31:0] sd_addr;
 fat32_dual_file_sector #(.WAIT_LIMIT(8),.AUDIO_BURST_MAX(2)) dut(
 .clk(clk),.rst(rst),.fat_lba(32'd200),.data_lba(32'd100),.cluster_count(32'd10),.sectors_per_cluster_shift(4'd0),
 .bmp_enable(1'b1),.bmp_start_cluster(32'd2),.bmp_file_size(32'd512),.bmp_file_read(bmp_read),.bmp_file_sector(32'd0),
 .bmp_file_data(),.bmp_file_valid(),.bmp_file_end(bmp_end),.bmp_error(bmp_error),.bmp_error_code(bmp_code),
 .wav_enable(1'b1),.wav_start_cluster(32'd2),.wav_file_size(32'd512),.wav_file_read(wav_read),.wav_file_sector(32'd0),
 .wav_file_data(),.wav_file_valid(),.wav_file_end(wav_end),.wav_error(wav_error),.wav_error_code(wav_code),
 .sd_read(sd_read),.sd_addr(sd_addr),.sd_data(8'd0),.sd_valid(1'b0),.sd_end(1'b0));
 initial begin
  repeat(3) @(negedge clk); rst=0;
  // Natural per-client arming and request acceptance from reset.
  repeat(2) @(negedge clk);
  bmp_read=1; wav_read=1;
  @(posedge clk); #1;
  if (!dut.busy[0] || !dut.queued[0] || !dut.busy[1] || !dut.queued[1] || dut.core_state!=dut.C_IDLE || dut.active_client!=0)
   $fatal(1,"real dual request acceptance failed");
  // Deposit only the queued previous-owner watchdog age. Client ownership,
  // queued/busy state, FSM state and both file_read acceptances are natural.
  @(negedge clk); dut.wait_count[0]=7;
  @(posedge clk); #1;
  if (!bmp_error || bmp_code!=8'h0a || !dut.busy[1] || dut.queued[1] || dut.active_client!=1)
   $fatal(1,"race setup mismatch: bmp=%b/%h busyW=%b queuedW=%b active=%0d",bmp_error,bmp_code,dut.busy[1],dut.queued[1],dut.active_client);
  if (EXPECT_FIXED != 0) begin
   repeat(5) @(posedge clk); #1;
   if (dut.core_state!=dut.C_DATA_WAIT || !sd_read || wav_error || !dut.busy[1])
    $fatal(1,"WAV did not advance after old-owner timeout: state=%0d sd_read=%b busy=%b wav_error=%b",dut.core_state,sd_read,dut.busy[1],wav_error);
   $display("PASS fix after natural arm/accept + old-owner timeout: WAV reaches data sector at LBA %0d",sd_addr);
  end else begin
   repeat(5) @(posedge clk); #1;
   if (dut.core_state!=dut.C_IDLE || dut.busy[1]!=1 || dut.queued[1]!=0 || sd_read)
    $fatal(1,"B9 did not retain expected orphan state: state=%0d busy=%b queued=%b sd=%b",dut.core_state,dut.busy[1],dut.queued[1],sd_read);
   $display("CONFIRMED B9: real dual arm/accept plus aged BMP watchdog leaves WAV orphaned in C_IDLE");
  end  $finish;
 end
 initial begin #3000; $fatal(1,"timeout"); end
endmodule

