`timescale 1ns/1ps
module tb_fat32_sd_end_edge;
    reg clk=0, rst=1, file_read=0;
    always #5 clk=~clk;
    reg [7:0] sd_data=8'h44;
    reg sd_valid=0, sd_end=0;
    wire ref_read, cand_read, ref_valid, cand_valid, ref_end, cand_end;
    wire ref_error, cand_error;
    wire [7:0] ref_code, cand_code, ref_data, cand_data;
    wire [31:0] ref_addr, cand_addr;
    reg ref_end_seen=0, cand_end_seen=0;
    integer ticks=0;

    fat32_file_sector #(.WAIT_LIMIT(1000),.CATALOG_GEOMETRY(1),.REQUEST_STABLE(1)) ref_mapper(
        .clk(clk),.rst(rst),.enable(1'b1),.fat_lba(32'd200),.data_lba(32'd100),
        .cluster_count(32'd10),.sectors_per_cluster_shift(4'd0),
        .start_cluster(32'd2),.file_size(32'd512),.file_read(file_read),.file_sector(32'd0),
        .file_data(ref_data),.file_valid(ref_valid),.file_end(ref_end),
        .error(ref_error),.error_code(ref_code),.sd_read(ref_read),.sd_addr(ref_addr),
        .sd_data(sd_data),.sd_valid(sd_valid),.sd_end(sd_end)
    );
    fat32_dual_file_sector #(.WAIT_LIMIT(1000)) candidate(
        .clk(clk),.rst(rst),.fat_lba(32'd200),.data_lba(32'd100),
        .cluster_count(32'd10),.sectors_per_cluster_shift(4'd0),
        .bmp_enable(1'b1),.bmp_start_cluster(32'd2),.bmp_file_size(32'd512),
        .bmp_file_read(file_read),.bmp_file_sector(32'd0),
        .bmp_file_data(cand_data),.bmp_file_valid(cand_valid),.bmp_file_end(cand_end),
        .bmp_error(cand_error),.bmp_error_code(cand_code),
        .wav_enable(1'b0),.wav_start_cluster(32'd0),.wav_file_size(32'd0),
        .wav_file_read(1'b0),.wav_file_sector(32'd0),.wav_file_data(),
        .wav_file_valid(),.wav_file_end(),.wav_error(),.wav_error_code(),
        .sd_read(cand_read),.sd_addr(cand_addr),.sd_data(sd_data),
        .sd_valid(sd_valid),.sd_end(sd_end)
    );

    always @(posedge clk) begin
        ticks<=ticks+1;
        if (ref_end) ref_end_seen<=1;
        if (cand_end) cand_end_seen<=1;
        if (ticks>2500) begin $display("FAIL edge timeout"); $fatal(1); end
    end

    task run_edge_case;
        input integer normal_bytes;
        begin
            repeat(3) @(negedge clk); file_read=0;
            repeat(2) @(negedge clk); file_read=1;
            wait(ref_read && cand_read);
            repeat(normal_bytes) begin @(negedge clk); sd_valid=1; sd_end=0; end
            @(negedge clk); sd_valid=1; sd_end=1;
            @(negedge clk); sd_valid=0; sd_end=0;
            wait(ref_error && cand_error && ref_end_seen && cand_end_seen);
            if (ref_code!=8'h05 || cand_code!=8'h05) begin
                $display("FAIL edge codes ref=%h candidate=%h",ref_code,cand_code); $fatal(1);
            end
            @(negedge clk); rst=1; file_read=0; ref_end_seen=0; cand_end_seen=0;
            repeat(3) @(negedge clk); rst=0;
        end
    endtask

    initial begin
        repeat(4) @(negedge clk); rst=0;
        run_edge_case(511);
        run_edge_case(512);
        $display("PASS simultaneous valid/end at counts 511 and 512 matches reference short-sector behavior");
        $finish;
    end
endmodule
