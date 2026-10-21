`timescale 1ns/1ps
module tb_review_end_overlap;
 reg clk=0,rst=1;
 always #5 clk=~clk;
 reg bmp_enable=1,bmp_read=0,sd_valid=0,sd_end=0;
 reg [7:0] sd_data=8'h5a;
 wire c_read,r_read,c_valid,r_valid,c_end,r_end,c_error,r_error;
 wire [31:0] c_addr,r_addr;
 wire [7:0] c_data,r_data,c_code,r_code;
 fat32_dual_file_sector #(.WAIT_LIMIT(1000)) c(
 .clk(clk),.rst(rst),.fat_lba(32'd200),.data_lba(32'd100),.cluster_count(32'd10),.sectors_per_cluster_shift(4'd0),
 .bmp_enable(bmp_enable),.bmp_start_cluster(32'd2),.bmp_file_size(32'd1024),.bmp_file_read(bmp_read),.bmp_file_sector(32'd1),
 .bmp_file_data(c_data),.bmp_file_valid(c_valid),.bmp_file_end(c_end),.bmp_error(c_error),.bmp_error_code(c_code),
 .wav_enable(1'b0),.wav_start_cluster(32'd2),.wav_file_size(32'd512),.wav_file_read(1'b0),.wav_file_sector(32'd0),
 .wav_file_data(),.wav_file_valid(),.wav_file_end(),.wav_error(),.wav_error_code(),
 .sd_read(c_read),.sd_addr(c_addr),.sd_data(sd_data),.sd_valid(sd_valid),.sd_end(sd_end));
 fat32_file_sector #(.WAIT_LIMIT(1000),.CATALOG_GEOMETRY(1),.REQUEST_STABLE(1)) r(
 .clk(clk),.rst(rst),.enable(bmp_enable),.fat_lba(32'd200),.data_lba(32'd100),.cluster_count(32'd10),.sectors_per_cluster_shift(4'd0),
 .start_cluster(32'd2),.file_size(32'd1024),.file_read(bmp_read),.file_sector(32'd1),
 .file_data(r_data),.file_valid(r_valid),.file_end(r_end),.error(r_error),.error_code(r_code),
 .sd_read(r_read),.sd_addr(r_addr),.sd_data(sd_data),.sd_valid(sd_valid),.sd_end(sd_end));
 task reset_pair;
 begin
  @(negedge clk); rst=1; sd_valid=0; sd_end=0; bmp_read=0;
  repeat(2) @(negedge clk); rst=0; @(negedge clk);
 end endtask
 task force_data_count(input integer count);
 begin
  c.active_client=0; c.busy[0]=1; c.queued[0]=0; c.walk_initialized[0]=1; c.core_state=c.C_DATA_WAIT; c.byte_count=count; c.sd_read=1;
  r.state=r.S_DATA_WAIT; r.byte_count=count; r.sd_read=1;
 end endtask
 integer k;
 initial begin
  repeat(2) @(negedge clk); rst=0;
  reset_pair(); force_data_count(511); sd_valid=1; sd_end=1;
  @(posedge clk); #1;
  if({c_valid,c_end,c_error,c_code,c_read,c_data} !== {r_valid,r_end,r_error,r_code,r_read,r_data})
   $fatal(1,"512th valid+end public mismatch C=%b/%b/%b/%h/%b/%h R=%b/%b/%b/%h/%b/%h",c_valid,c_end,c_error,c_code,c_read,c_data,r_valid,r_end,r_error,r_code,r_read,r_data);
  if(!c_valid || !c_end || !c_error || c_code!=8'h05) $fatal(1,"expected old-count short error on final-byte/end overlap");
  $display("PASS data byte 512 and sd_end overlap: both emit byte then report E_SHORT (old count is 511)");

  reset_pair(); force_data_count(512); sd_valid=1; sd_end=1;
  @(posedge clk); #1;
  if({c_valid,c_end,c_error,c_code,c_read,c_data} !== {r_valid,r_end,r_error,r_code,r_read,r_data})
   $fatal(1,"513th valid+end public mismatch");
  if(c_valid || !c_end || !c_error || c_code!=8'h05) $fatal(1,"513th byte must fail without forwarding byte");
  $display("PASS data byte 513 and sd_end overlap: both suppress byte and report E_SHORT");

  reset_pair();
  // A FAT sector has accepted 512 bytes; a coincident 513th valid/end sets E_SHORT.
  c.active_client=0; c.busy[0]=1; c.queued[0]=0; c.walk_initialized[0]=1; c.core_state=c.C_FAT_WAIT; c.byte_count=512; c.sd_read=1;
  c.walk_index[0]=0; c.target_index[0]=1; c.current_cluster[0]=2; c.brent_anchor[0]=2; c.fat_b0=8'd3; c.fat_b1=0;c.fat_b2=0;c.fat_b3=0;
  r.state=r.S_FAT_WAIT; r.byte_count=512; r.sd_read=1; r.walk_index=0; r.target_index=1; r.current_cluster=2; r.brent_anchor=2; r.fat_b0=3;r.fat_b1=0;r.fat_b2=0;r.fat_b3=0;
  sd_valid=1;sd_end=1;
  @(posedge clk); #1; sd_valid=0;sd_end=0;
  repeat(8) @(posedge clk); #1;
  if(!c_error || !r_error || c_code!=8'h05 || r_code!=8'h05) $fatal(1,"FAT overlap missing E_SHORT C=%b/%h R=%b/%h",c_error,c_code,r_error,r_code);
  if(c_read || !r_read) $fatal(1,"expected reference-only stale walk dispatch after FAT 513th+end overlap C=%b R=%b",c_read,r_read);
  $display("OBSERVED only on malformed FAT 513th-valid+end same-edge: reference re-enters FAT walk and asserts sd_read after E_SHORT; shared candidate remains idle after E_SHORT");
  $finish;
 end
 initial begin #20000; $fatal(1,"timeout"); end
endmodule
