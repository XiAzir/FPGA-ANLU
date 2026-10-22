module tb_waitcount_width #(parameter [31:0] LIMIT=50000000);
    reg clk=0, rst=1;
    always #5 clk=~clk;
    fat32_dual_file_sector #(.WAIT_LIMIT(LIMIT)) dut(
        .clk(clk),.rst(rst),.fat_lba(32'd0),.data_lba(32'd0),.cluster_count(32'd0),
        .sectors_per_cluster_shift(4'd0),
        .bmp_enable(1'b0),.bmp_start_cluster(32'd0),.bmp_file_size(32'd0),.bmp_file_read(1'b0),
        .bmp_file_sector(32'd0),.bmp_file_data(),.bmp_file_valid(),.bmp_file_end(),.bmp_error(),.bmp_error_code(),
        .wav_enable(1'b0),.wav_start_cluster(32'd0),.wav_file_size(32'd0),.wav_file_read(1'b0),
        .wav_file_sector(32'd0),.wav_file_data(),.wav_file_valid(),.wav_file_end(),.wav_error(),.wav_error_code(),
        .sd_read(),.sd_addr(),.sd_data(8'd0),.sd_valid(1'b0),.sd_end(1'b0));
    initial begin
        $display("WAIT_LIMIT=%0d WAIT_COUNT_BITS=%0d",LIMIT,$bits(dut.wait_count[0]));
        $finish;
    end
endmodule
