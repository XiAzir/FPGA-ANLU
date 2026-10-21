`timescale 1ns/1ps
module tb_mapper_sd_edge;
    reg clk=0, rst=1, enable=1, file_read=0;
    reg [31:0] fat_lba=100, data_lba=1000, cluster_count=4;
    reg [3:0] sectors_per_cluster_shift=0;
    reg [31:0] start_cluster=2, file_size=512, file_sector=0;
    reg [7:0] sd_data=0;
    reg sd_valid=0, sd_end=0;
    wire [7:0] c_file_data, r_file_data, c_error_code, r_error_code;
    wire c_file_valid, r_file_valid, c_file_end, r_file_end;
    wire c_error, r_error, c_sd_read, r_sd_read;
    wire [31:0] c_sd_addr, r_sd_addr;
    integer errors=0, candidate_bytes=0, reference_bytes=0;
    integer candidate_ends=0, reference_ends=0;
    integer scenario=0, cycle_count=0;
    integer n;

    always #5 clk=~clk;

    fat32_file_sector_candidate #(.WAIT_LIMIT(100)) candidate (
        .clk(clk),.rst(rst),.enable(enable),.fat_lba(fat_lba),.data_lba(data_lba),
        .cluster_count(cluster_count),.sectors_per_cluster_shift(sectors_per_cluster_shift),
        .start_cluster(start_cluster),.file_size(file_size),.file_read(file_read),.file_sector(file_sector),
        .file_data(c_file_data),.file_valid(c_file_valid),.file_end(c_file_end),
        .error(c_error),.error_code(c_error_code),.sd_read(c_sd_read),.sd_addr(c_sd_addr),
        .sd_data(sd_data),.sd_valid(sd_valid),.sd_end(sd_end)
    );

    fat32_file_sector_reference #(.WAIT_LIMIT(100)) reference_dut (
        .clk(clk),.rst(rst),.enable(enable),.fat_lba(fat_lba),.data_lba(data_lba),
        .cluster_count(cluster_count),.sectors_per_cluster_shift(sectors_per_cluster_shift),
        .start_cluster(start_cluster),.file_size(file_size),.file_read(file_read),.file_sector(file_sector),
        .file_data(r_file_data),.file_valid(r_file_valid),.file_end(r_file_end),
        .error(r_error),.error_code(r_error_code),.sd_read(r_sd_read),.sd_addr(r_sd_addr),
        .sd_data(sd_data),.sd_valid(sd_valid),.sd_end(sd_end)
    );

    always @(negedge clk) begin
        if (!rst) begin
            if ({c_file_data,c_file_valid,c_file_end,c_error,c_error_code,c_sd_read,c_sd_addr} !==
                {r_file_data,r_file_valid,r_file_end,r_error,r_error_code,r_sd_read,r_sd_addr}) begin
                $display("DIFF scenario=%0d cycle=%0d output candidate=%h/%b/%b/%b/%h/%b/%h ref=%h/%b/%b/%b/%h/%b/%h",
                    scenario,cycle_count,c_file_data,c_file_valid,c_file_end,c_error,c_error_code,c_sd_read,c_sd_addr,
                    r_file_data,r_file_valid,r_file_end,r_error,r_error_code,r_sd_read,r_sd_addr);
                errors=errors+1;
            end
            if (candidate.walk_count !== reference_dut.walk_count ||
                candidate.cache_walk_count !== reference_dut.cache_walk_count ||
                {4'd0,candidate.current_cluster} !== reference_dut.current_cluster ||
                {4'd0,candidate.cache_cluster} !== reference_dut.cache_cluster ||
                {4'd0,candidate.brent_anchor} !== reference_dut.brent_anchor ||
                {4'd0,candidate.cache_brent_anchor} !== reference_dut.cache_brent_anchor ||
                candidate.brent_power !== reference_dut.brent_power ||
                candidate.cache_brent_power !== reference_dut.cache_brent_power ||
                {1'b0,candidate.byte_count} !== reference_dut.byte_count) begin
                $display("DIFF scenario=%0d cycle=%0d internal invariant state",scenario,cycle_count);
                errors=errors+1;
            end
            if (c_file_valid) candidate_bytes=candidate_bytes+1;
            if (r_file_valid) reference_bytes=reference_bytes+1;
            if (c_file_end) candidate_ends=candidate_ends+1;
            if (r_file_end) reference_ends=reference_ends+1;
            cycle_count=cycle_count+1;
        end
    end

    task reset_request(input integer request_sector, input integer request_size);
        begin
            @(negedge clk); rst=1; enable=1; file_read=0; sd_valid=0; sd_end=0;
            file_sector=request_sector; file_size=request_size;
            repeat(3) @(negedge clk);
            rst=0;
            repeat(2) @(negedge clk);
            file_read=1;
            @(negedge clk); file_read=0;
        end
    endtask

    task wait_state(input integer wanted);
        integer k;
        begin
            k=0;
            while(candidate.state != wanted && k<1000) begin @(negedge clk); k=k+1; end
            if (candidate.state != wanted || reference_dut.state != wanted) begin
                $display("FAIL state wait scenario=%0d wanted=%0d candidate=%0d reference=%0d",scenario,wanted,candidate.state,reference_dut.state);
                errors=errors+1;
            end
        end
    endtask

    task send_bytes(input integer count, input integer end_with_last, input integer fat_mode);
        integer k;
        begin
            for(k=0;k<count;k=k+1) begin
                @(negedge clk); sd_valid=1;
                if (fat_mode && k==8) sd_data=8'd3;
                else if (fat_mode && k>=9 && k<=11) sd_data=8'd0;
                else sd_data=8'h5a;
                sd_end=(end_with_last && k==count-1);
            end
            @(negedge clk); sd_valid=0; sd_end=0;
        end
    endtask

    task end_sector;
        begin @(negedge clk); sd_valid=0; sd_end=1; @(negedge clk); sd_end=0; end
    endtask

    task expect_short(input integer which, input integer count, input integer simultaneous);
        begin
            scenario=which;
            reset_request(which<4 ? 0 : 1, which<4 ? 512 : 1024);
            wait_state(which<4 ? 4 : 3);
            send_bytes(count,simultaneous,which>=4);
            if (!simultaneous && count<=512) end_sector();
            repeat(3) @(negedge clk);
            if (!c_error || !r_error || c_error_code!=8'h05 || r_error_code!=8'h05 || c_sd_read || r_sd_read) begin
                $display("FAIL short/overlong scenario=%0d count=%0d same_end=%0d errors=%b/%b codes=%h/%h",
                    which,count,simultaneous,c_error,r_error,c_error_code,r_error_code);
                errors=errors+1;
            end
        end
    endtask

    task expect_full;
        integer k;
        begin
            scenario=7; candidate_bytes=0; reference_bytes=0; candidate_ends=0; reference_ends=0;
            reset_request(1,1024);
            wait_state(3);
            send_bytes(512,0,1);
            end_sector();
            wait_state(4);
            for(k=0;k<512;k=k+1) begin
                @(negedge clk); sd_valid=1; sd_end=0; sd_data=k[7:0];
            end
            end_sector();
            repeat(3) @(negedge clk);
            if (c_error || r_error || candidate_ends!=1 || reference_ends!=1 ||
                candidate_bytes!=512 || reference_bytes!=512) begin
                $display("FAIL full FAT/data candidate error=%b reference error=%b ends=%b/%b output_bytes=%0d/%0d",
                    c_error,r_error,candidate_ends,reference_ends,candidate_bytes,reference_bytes);
                errors=errors+1;
            end
        end
    endtask

    initial begin
        // Data short, data same-cycle final byte/end, data overlong.
        expect_short(1,511,0);
        expect_short(2,512,1);
        expect_short(3,513,0);
        // FAT short, FAT same-cycle final byte/end, FAT overlong.
        expect_short(4,511,0);
        expect_short(5,512,1);
        expect_short(6,513,0);
        // Complete FAT sector proves offsets 8..11 were captured; then full data.
        expect_full();
        if (errors==0) $display("PASS: mapper SD edge differential checks");
        else $display("FAIL: mapper SD edge checks errors=%0d",errors);
        $finish;
    end
endmodule
