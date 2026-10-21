`timescale 1ns/1ps
module tb_review_timeout_6a;
 reg clk=0,rst=1,bmp_read=0; always #5 clk=~clk;
 wire err,sd_read; wire [7:0] code; wire [31:0] addr;
 fat32_dual_file_sector #(.WAIT_LIMIT(8)) dut(.clk(clk),.rst(rst),.fat_lba(32'd200),.data_lba(32'd100),.cluster_count(32'd10),.sectors_per_cluster_shift(4'd0),
 .bmp_enable(1'b1),.bmp_start_cluster(32'd2),.bmp_file_size(32'd512),.bmp_file_read(bmp_read),.bmp_file_sector(32'd0),.bmp_file_data(),.bmp_file_valid(),.bmp_file_end(),.bmp_error(err),.bmp_error_code(code),
 .wav_enable(1'b0),.wav_start_cluster(32'd2),.wav_file_size(32'd512),.wav_file_read(1'b0),.wav_file_sector(32'd0),.wav_file_data(),.wav_file_valid(),.wav_file_end(),.wav_error(),.wav_error_code(),.sd_read(sd_read),.sd_addr(addr),.sd_data(8'd0),.sd_valid(1'b0),.sd_end(1'b0));
 initial begin
  repeat(3) @(negedge clk); rst=0; repeat(2) @(negedge clk); bmp_read=1;
  wait(dut.core_state==dut.C_SETUP);
  @(negedge clk); dut.wait_count[0]=7;
  @(posedge clk); #1;
  if(!err || code!=8'h0a || dut.core_state!=dut.C_DISPATCH || sd_read) $fatal(1,"expected pre-fix setup overwrite, got err=%b/%h state=%0d sd=%b",err,code,dut.core_state,sd_read);
  @(posedge clk); #1;
  if(!sd_read || dut.core_state!=dut.C_DATA_WAIT) $fatal(1,"expected pre-fix timed-out physical dispatch, got read=%b state=%0d",sd_read,dut.core_state);
  $display("CONFIRMED 6A pre-fix: E_TIMEOUT is asserted, then C_DISPATCH starts data-sector sd_read for the timed-out request"); $finish;
 end
 initial begin #2000; $fatal(1,"timeout"); end
endmodule
