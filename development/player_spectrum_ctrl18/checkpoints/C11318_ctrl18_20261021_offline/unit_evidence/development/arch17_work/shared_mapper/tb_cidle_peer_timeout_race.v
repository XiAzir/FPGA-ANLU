`timescale 1ns/1ps
module tb_cidle_peer_timeout_race;
    reg clk=0, rst=1, bmp_read=0, wav_read=0;
    always #5 clk=~clk;
    wire sd_read, bmp_error, wav_error;
    wire [31:0] sd_addr;
    wire [7:0] bmp_code, wav_code;
    fat32_dual_file_sector #(.WAIT_LIMIT(8)) dut(
        .clk(clk),.rst(rst),.fat_lba(32'd200),.data_lba(32'd100),
        .cluster_count(32'd10),.sectors_per_cluster_shift(4'd0),
        .bmp_enable(1'b1),.bmp_start_cluster(32'd2),.bmp_file_size(32'd512),
        .bmp_file_read(bmp_read),.bmp_file_sector(32'd0),
        .bmp_file_data(),.bmp_file_valid(),.bmp_file_end(),.bmp_error(bmp_error),.bmp_error_code(bmp_code),
        .wav_enable(1'b1),.wav_start_cluster(32'd2),.wav_file_size(32'd512),
        .wav_file_read(wav_read),.wav_file_sector(32'd0),
        .wav_file_data(),.wav_file_valid(),.wav_file_end(),.wav_error(wav_error),.wav_error_code(wav_code),
        .sd_read(sd_read),.sd_addr(sd_addr),.sd_data(8'd0),.sd_valid(1'b0),.sd_end(1'b0)
    );

    initial begin
        repeat(3) @(negedge clk); rst=0;
        repeat(2) @(negedge clk); bmp_read=1; wav_read=1;
        // Both clients are accepted from real read/arm handshakes. The reset
        // value naturally leaves active_client on BMP; only its timer is forced.
        @(posedge clk); #1;
        if (!dut.busy[0] || !dut.queued[0] || !dut.busy[1] || !dut.queued[1]) begin
            $display("FAIL requests were not naturally queued"); $fatal(1);
        end
        dut.wait_count[0]=32'd7;
        @(posedge clk); #1;
        if (bmp_error && (bmp_code==8'h0a) && dut.active_client &&
            dut.busy[1] && !dut.queued[1] && dut.core_state==dut.C_IDLE && !sd_read) begin
            $display("REPRO pre-fix: timed-out queued BMP canceled WAV dispatch; WAV remains busy with no queue");
            $finish;
        end
        wait(sd_read);
        if (!bmp_error || bmp_code!=8'h0a || !dut.active_client || !dut.busy[1]) begin
            $display("FAIL post-fix state bmp_error=%b/%h active=%b wav_busy=%b",bmp_error,bmp_code,dut.active_client,dut.busy[1]); $fatal(1);
        end
        $display("PASS idle peer timeout retires only BMP and WAV dispatch proceeds");
        $finish;
    end
endmodule
