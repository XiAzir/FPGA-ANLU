`timescale 1ns/1ps
module tb_review_disable_drain;
 reg clk=0,rst=1,bmp_enable=1,bmp_read=0;
 reg [7:0] sd_data=0; reg sd_valid=0,sd_end=0;
 always #5 clk=~clk;
 wire sd_read,bmp_valid,bmp_end,bmp_error; wire [31:0] sd_addr; wire [7:0] bmp_data,bmp_code;
 integer pre_disable_valid=0,post_disable_valid=0;
 fat32_dual_file_sector #(.WAIT_LIMIT(10000)) dut(
 .clk(clk),.rst(rst),.fat_lba(32'd200),.data_lba(32'd100),.cluster_count(32'd10),.sectors_per_cluster_shift(4'd0),
 .bmp_enable(bmp_enable),.bmp_start_cluster(32'd2),.bmp_file_size(32'd1024),.bmp_file_read(bmp_read),.bmp_file_sector(32'd0),
 .bmp_file_data(bmp_data),.bmp_file_valid(bmp_valid),.bmp_file_end(bmp_end),.bmp_error(bmp_error),.bmp_error_code(bmp_code),
 .wav_enable(1'b0),.wav_start_cluster(32'd2),.wav_file_size(32'd512),.wav_file_read(1'b0),.wav_file_sector(32'd0),
 .wav_file_data(),.wav_file_valid(),.wav_file_end(),.wav_error(),.wav_error_code(),
 .sd_read(sd_read),.sd_addr(sd_addr),.sd_data(sd_data),.sd_valid(sd_valid),.sd_end(sd_end));
 task send_valid_byte(input [7:0] x);
 begin @(negedge clk); sd_data=x; sd_valid=1; @(posedge clk); #1; sd_valid=0; end
 endtask
 integer k;
 initial begin
  repeat(3) @(negedge clk); rst=0;
  repeat(2) @(negedge clk); bmp_read=1;
  wait(dut.core_state==dut.C_DATA_WAIT && sd_read);
  for(k=0;k<10;k=k+1) begin send_valid_byte(k); if(bmp_valid) pre_disable_valid=pre_disable_valid+1; end
  if(dut.byte_count!=10 || pre_disable_valid!=10) $fatal(1,"setup bytes failed count=%0d valid=%0d",dut.byte_count,pre_disable_valid);
  @(negedge clk); bmp_enable=0; bmp_read=0; sd_valid=0;
  @(posedge clk); #1;
  if(dut.core_state!=dut.C_DRAIN || !sd_read) $fatal(1,"disable did not drain active sector state=%0d read=%b",dut.core_state,sd_read);
  @(negedge clk); bmp_enable=1; bmp_read=0;
  @(posedge clk); #1;
  @(negedge clk); bmp_read=1;
  for(k=10;k<512;k=k+1) begin
   send_valid_byte(k[7:0]);
   if(bmp_valid) post_disable_valid=post_disable_valid+1;
  end
  if(post_disable_valid!=0 || dut.byte_count!=10) $fatal(1,"drain leaked old-sector bytes valid=%0d count=%0d",post_disable_valid,dut.byte_count);
  @(negedge clk); sd_valid=0; sd_end=1;
  @(posedge clk); #1; sd_end=0;
  if(dut.core_state!=dut.C_IDLE || sd_read) $fatal(1,"drain did not finish cleanly");
  repeat(5) @(posedge clk);
  if(!dut.queued[0] && !dut.busy[0]) $fatal(1,"held new request was not accepted after drain");
  wait(dut.core_state==dut.C_DATA_WAIT && sd_read);
  if(sd_addr!=100) $fatal(1,"new request data address=%0d expected=100",sd_addr);
  $display("PASS disable drain: old sector suffix discarded across re-enable; held request starts a fresh data sector at LBA 100");
  $finish;
 end
 initial begin #20000; $fatal(1,"timeout"); end
endmodule
