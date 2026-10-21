`timescale 1ns/1ps
module tb_idle_select_peer_timeout;
 reg clk=0, rst=1;
 always #5 clk=~clk;
 wire bmp_end,wav_end,bmp_error,wav_error,sd_read;
 wire [7:0] bmp_code,wav_code;
 wire [31:0] sd_addr;
 fat32_dual_file_sector #(.WAIT_LIMIT(8),.AUDIO_BURST_MAX(2)) dut(
 .clk(clk),.rst(rst),.fat_lba(32'd200),.data_lba(32'd100),.cluster_count(32'd10),.sectors_per_cluster_shift(4'd0),
 .bmp_enable(1'b1),.bmp_start_cluster(32'd2),.bmp_file_size(32'd512),.bmp_file_read(1'b0),.bmp_file_sector(32'd0),
 .bmp_file_data(),.bmp_file_valid(),.bmp_file_end(bmp_end),.bmp_error(bmp_error),.bmp_error_code(bmp_code),
 .wav_enable(1'b1),.wav_start_cluster(32'd2),.wav_file_size(32'd512),.wav_file_read(1'b0),.wav_file_sector(32'd0),
 .wav_file_data(),.wav_file_valid(),.wav_file_end(wav_end),.wav_error(wav_error),.wav_error_code(wav_code),
 .sd_read(sd_read),.sd_addr(sd_addr),.sd_data(8'd0),.sd_valid(1'b0),.sd_end(1'b0));
 initial begin
  repeat(3) @(negedge clk); rst=0;
  @(negedge clk);
  // Previous owner was BMP; both clients are busy/queued, with BMP expiring
  // on the exact edge that C_IDLE selects the higher-priority WAV request.
  dut.active_client=0;
  dut.core_state=dut.C_IDLE;
  dut.audio_streak=0;
  dut.busy[0]=1; dut.queued[0]=1; dut.wait_count[0]=7;
  dut.busy[1]=1; dut.queued[1]=1; dut.wait_count[1]=0;
  @(posedge clk); #1;
  if (!bmp_error || bmp_code!=8'h0a) $fatal(1,"BMP timeout was not reported");
  if (dut.active_client!=1 || dut.core_state!=dut.C_SETUP || dut.queued[1] || !dut.busy[1])
   $fatal(1,"expected WAV C_SETUP to survive BMP timeout: active=%0d state=%0d queuedW=%b busyW=%b",dut.active_client,dut.core_state,dut.queued[1],dut.busy[1]);
  repeat(5) @(posedge clk); #1;
  if (dut.active_client!=1 || !dut.busy[1] || wav_error || !sd_read || dut.core_state!=dut.C_DATA_WAIT)
   $fatal(1,"fixed scheduler failed to launch WAV after BMP timeout: active=%0d state=%0d busy=%b wav_error=%b sd_read=%b",dut.active_client,dut.core_state,dut.busy[1],wav_error,sd_read);
  $display("PASS fix: BMP timeout retires only BMP while same-edge WAV selection advances to data-sector sd_read");  $finish;
 end
 initial begin #2000; $fatal(1,"timeout"); end
endmodule

