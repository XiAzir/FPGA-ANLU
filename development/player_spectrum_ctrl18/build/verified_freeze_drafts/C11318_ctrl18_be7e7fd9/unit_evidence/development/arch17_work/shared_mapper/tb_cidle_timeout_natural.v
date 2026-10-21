`timescale 1ns/1ps
module tb_cidle_timeout_natural #(parameter integer LIMIT=1);
    reg clk=0, rst=1, bmp_read=0, wav_read=0;
    always #5 clk=~clk;
    wire sd_read, bmp_error, wav_error;
    wire [7:0] bmp_code, wav_code;
    wire [31:0] sd_addr;
    fat32_dual_file_sector #(.WAIT_LIMIT(LIMIT)) dut(
        .clk(clk),.rst(rst),.fat_lba(32'd200),.data_lba(32'd100),
        .cluster_count(32'd10),.sectors_per_cluster_shift(4'd0),
        .bmp_enable(1'b1),.bmp_start_cluster(32'd2),.bmp_file_size(32'd512),
        .bmp_file_read(bmp_read),.bmp_file_sector(32'd0),.bmp_file_data(),.bmp_file_valid(),
        .bmp_file_end(),.bmp_error(bmp_error),.bmp_error_code(bmp_code),
        .wav_enable(1'b1),.wav_start_cluster(32'd2),.wav_file_size(32'd512),
        .wav_file_read(wav_read),.wav_file_sector(32'd0),.wav_file_data(),.wav_file_valid(),
        .wav_file_end(),.wav_error(wav_error),.wav_error_code(wav_code),
        .sd_read(sd_read),.sd_addr(sd_addr),.sd_data(8'd0),.sd_valid(1'b0),.sd_end(1'b0)
    );
    initial begin
        repeat(3) @(negedge clk); rst=0;
        repeat(2) @(negedge clk); bmp_read=1; wav_read=1;
        repeat(20) @(negedge clk);
        if (dut.busy[1] && !dut.queued[1] && dut.core_state==dut.C_IDLE) begin
            $display("ORPHAN limit=%0d active=%b errors=%b/%b",LIMIT,dut.active_client,bmp_error,wav_error);
            $fatal(1);
        end
        $display("PASS natural limit=%0d busy/queued=%b%b/%b%b errors=%b/%b read=%b",LIMIT,dut.busy[1],dut.busy[0],dut.queued[1],dut.queued[0],bmp_error,wav_error,sd_read);
        $finish;
    end
endmodule
