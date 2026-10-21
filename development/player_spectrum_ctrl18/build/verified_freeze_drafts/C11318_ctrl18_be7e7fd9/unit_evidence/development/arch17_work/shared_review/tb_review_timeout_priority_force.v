`timescale 1ns/1ps
module tb_review_timeout_priority_force;
 reg clk=0,rst=1; always #5 clk=~clk;
 wire err,sd_read; wire [7:0] code; wire [31:0] addr;
 fat32_dual_file_sector #(.WAIT_LIMIT(8)) dut(.clk(clk),.rst(rst),.fat_lba(32'd200),.data_lba(32'd100),.cluster_count(32'd10),.sectors_per_cluster_shift(0),
 .bmp_enable(1'b1),.bmp_start_cluster(32'd2),.bmp_file_size(32'd512),.bmp_file_read(1'b0),.bmp_file_sector(32'd0),.bmp_file_data(),.bmp_file_valid(),.bmp_file_end(),.bmp_error(err),.bmp_error_code(code),
 .wav_enable(1'b0),.wav_start_cluster(32'd2),.wav_file_size(32'd512),.wav_file_read(1'b0),.wav_file_sector(32'd0),.wav_file_data(),.wav_file_valid(),.wav_file_end(),.wav_error(),.wav_error_code(),.sd_read(sd_read),.sd_addr(addr),.sd_data(0),.sd_valid(0),.sd_end(0));
 initial begin
 repeat(2) @(negedge clk); rst=0;
 @(negedge clk); dut.active_client=0; dut.busy[0]=1; dut.queued[0]=0; dut.core_state=dut.C_SETUP; dut.walk_initialized[0]=0; dut.wait_count[0]=7; dut.sd_read=0; dut.target_index[0]=0; dut.current_cluster[0]=0; dut.cache_valid[0]=0;
 @(posedge clk); #1; $display("state=%0d busy=%b err=%b code=%h",dut.core_state,dut.busy[0],err,code);
 @(posedge clk); #1; $display("state2=%0d sd_read=%b",dut.core_state,sd_read);
 $finish;
 end
endmodule
