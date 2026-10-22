`timescale 1ns/1ps
module tb_fat32_dual_timeout;
    reg clk=0, rst=1;
    always #5 clk=~clk;
    reg bmp_read=0, wav_read=0;
    wire bmp_end, wav_end, bmp_error, wav_error;
    wire [7:0] bmp_code, wav_code;
    wire sd_read;
    wire [31:0] sd_addr;
    fat32_dual_file_sector #(.WAIT_LIMIT(8)) dut(
        .clk(clk),.rst(rst),.fat_lba(32'd200),.data_lba(32'd100),
        .cluster_count(32'd10),.sectors_per_cluster_shift(4'd0),
        .bmp_enable(1'b1),.bmp_start_cluster(32'd2),.bmp_file_size(32'd512),
        .bmp_file_read(bmp_read),.bmp_file_sector(32'd0),.bmp_file_data(),
        .bmp_file_valid(),.bmp_file_end(bmp_end),.bmp_error(bmp_error),.bmp_error_code(bmp_code),
        .wav_enable(1'b1),.wav_start_cluster(32'd2),.wav_file_size(32'd512),
        .wav_file_read(wav_read),.wav_file_sector(32'd0),.wav_file_data(),
        .wav_file_valid(),.wav_file_end(wav_end),.wav_error(wav_error),.wav_error_code(wav_code),
        .sd_read(sd_read),.sd_addr(sd_addr),.sd_data(8'd0),.sd_valid(1'b0),.sd_end(1'b0)
    );
    integer cycle_count=0;
    always @(posedge clk) begin
        cycle_count<=cycle_count+1;
        if (cycle_count>100) begin $display("FAIL timeout watchdog stalled"); $fatal(1); end
    end
    initial begin
        repeat(3) @(negedge clk); rst=0;
        repeat(2) @(negedge clk); bmp_read=1; wav_read=1;
        wait(bmp_error && wav_error);
        if (bmp_code!=8'h0a || wav_code!=8'h0a || !sd_read) begin
            $display("FAIL timeout states code=%h/%h card_read=%b",bmp_code,wav_code,sd_read); $fatal(1);
        end
        // Reset clears both sticky errors and releases the abandoned card transaction.
        @(negedge clk); rst=1;
        repeat(2) @(negedge clk);
        if (bmp_error || wav_error || sd_read) begin $display("FAIL reset clear"); $fatal(1); end
        $display("PASS independent queued/owner timeout, sticky error and reset clear");
        $finish;
    end
endmodule
