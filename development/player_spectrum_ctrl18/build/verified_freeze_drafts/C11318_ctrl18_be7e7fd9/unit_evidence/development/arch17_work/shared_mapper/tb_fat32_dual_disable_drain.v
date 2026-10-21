`timescale 1ns/1ps
module tb_fat32_dual_disable_drain;
    reg clk=0, rst=1, bmp_enable=1, bmp_read=0;
    always #5 clk=~clk;
    reg [7:0] sd_data=0;
    reg sd_valid=0, sd_end=0;
    wire sd_read;
    wire [31:0] sd_addr;
    wire bmp_valid, bmp_end, bmp_error;
    wire [7:0] bmp_data, bmp_error_code;
    integer count=0, cycle_count=0;
    reg saw_end=0, monitor_new=0;

    fat32_dual_file_sector #(.WAIT_LIMIT(3000)) dut(
        .clk(clk),.rst(rst),.fat_lba(32'd200),.data_lba(32'd100),
        .cluster_count(32'd10),.sectors_per_cluster_shift(4'd0),
        .bmp_enable(bmp_enable),.bmp_start_cluster(32'd2),.bmp_file_size(32'd512),
        .bmp_file_read(bmp_read),.bmp_file_sector(32'd0),
        .bmp_file_data(bmp_data),.bmp_file_valid(bmp_valid),.bmp_file_end(bmp_end),
        .bmp_error(bmp_error),.bmp_error_code(bmp_error_code),
        .wav_enable(1'b0),.wav_start_cluster(32'd0),.wav_file_size(32'd0),
        .wav_file_read(1'b0),.wav_file_sector(32'd0),.wav_file_data(),
        .wav_file_valid(),.wav_file_end(),.wav_error(),.wav_error_code(),
        .sd_read(sd_read),.sd_addr(sd_addr),.sd_data(sd_data),
        .sd_valid(sd_valid),.sd_end(sd_end)
    );

    always @(posedge clk) begin
        cycle_count<=cycle_count+1;
        if (bmp_valid && monitor_new) begin
            if (bmp_data!=8'h5a) begin $display("FAIL stale-sector byte leaked: %h",bmp_data); $fatal(1); end
            count<=count+1;
        end
        if (bmp_end) saw_end<=1;
        if (cycle_count>4000) begin $display("FAIL disable drain timeout"); $fatal(1); end
    end

    initial begin
        repeat(3) @(negedge clk); rst=0;
        repeat(2) @(negedge clk); bmp_read=1;
        wait(sd_read); // old physical sector has started
        repeat(4) begin @(negedge clk); sd_valid=1; sd_data=8'h11; end
        @(negedge clk); sd_valid=0; bmp_enable=0;
        @(negedge clk); bmp_enable=1; bmp_read=0; monitor_new=1;
        repeat(2) @(negedge clk); bmp_read=1;
        repeat(8) begin @(negedge clk); sd_valid=1; sd_data=8'hee; end
        @(negedge clk); sd_valid=0; sd_end=1;
        @(negedge clk); sd_end=0;
        wait(sd_read); // deferred request starts only after the old end
        repeat(512) begin @(negedge clk); sd_valid=1; sd_data=8'h5a; end
        @(negedge clk); sd_valid=0; sd_end=1;
        @(negedge clk); sd_end=0;
        wait(saw_end); repeat(2) @(negedge clk);
        if (count!=512 || bmp_error) begin
            $display("FAIL count=%0d error=%b code=%h",count,bmp_error,bmp_error_code); $fatal(1);
        end
        $display("PASS disable drains old sector and defers re-armed request");
        $finish;
    end
endmodule
