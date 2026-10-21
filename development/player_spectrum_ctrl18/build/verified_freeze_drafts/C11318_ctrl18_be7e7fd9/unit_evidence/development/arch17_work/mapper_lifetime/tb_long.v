`timescale 1ns/1ps
module tb_mapper_long_specialized #(parameter integer CATALOG_GEOMETRY=1, parameter integer STATIC_FILE=0, parameter integer REQUEST_STABLE=1);
    reg clk=0, rst=1, enable=1, file_read=0;
    reg [31:0] fat_lba=10, data_lba=1000, cluster_count=65525;
    reg [3:0] sectors_per_cluster_shift=0;
    reg [31:0] start_cluster=2, file_size=4096*512, file_sector=0;
    reg [7:0] sd_data=0;
    reg sd_valid=0, sd_end=0;

    wire [7:0] ref_file_data, opt_file_data, ref_error_code, opt_error_code;
    wire ref_file_valid, opt_file_valid, ref_file_end, opt_file_end;
    wire ref_error, opt_error, ref_sd_read, opt_sd_read;
    wire [31:0] ref_sd_addr, opt_sd_addr;

    integer link_mode=0; // 0=long valid chain, 1=EOC before target, 2=late Brent cycle
    integer model_active=0, model_idx=0, model_addr=0;
    integer data_check=0, expected_addr=0, data_count=0;
    integer sector_count=0, timeout_count=0, failed=0, cycle_count=0;
    integer i;

    always #5 clk=~clk;

    fat32_file_sector_reference #(.WAIT_LIMIT(20)) reference_mapper (
        .clk(clk),.rst(rst),.enable(enable),.fat_lba(fat_lba),.data_lba(data_lba),
        .cluster_count(cluster_count),.sectors_per_cluster_shift(sectors_per_cluster_shift),
        .start_cluster(start_cluster),.file_size(file_size),.file_read(file_read),.file_sector(file_sector),
        .file_data(ref_file_data),.file_valid(ref_file_valid),.file_end(ref_file_end),
        .error(ref_error),.error_code(ref_error_code),.sd_read(ref_sd_read),.sd_addr(ref_sd_addr),
        .sd_data(sd_data),.sd_valid(sd_valid),.sd_end(sd_end)
    );

    fat32_file_sector #(.WAIT_LIMIT(20), .CATALOG_GEOMETRY(CATALOG_GEOMETRY), .STATIC_FILE(STATIC_FILE), .REQUEST_STABLE(REQUEST_STABLE)) optimized_mapper (
        .clk(clk),.rst(rst),.enable(enable),.fat_lba(fat_lba),.data_lba(data_lba),
        .cluster_count(cluster_count),.sectors_per_cluster_shift(sectors_per_cluster_shift),
        .start_cluster(start_cluster),.file_size(file_size),.file_read(file_read),.file_sector(file_sector),
        .file_data(opt_file_data),.file_valid(opt_file_valid),.file_end(opt_file_end),
        .error(opt_error),.error_code(opt_error_code),.sd_read(opt_sd_read),.sd_addr(opt_sd_addr),
        .sd_data(sd_data),.sd_valid(sd_valid),.sd_end(sd_end)
    );

    function [31:0] link_for;
        input integer c;
        begin
            case (link_mode)
                1: link_for = (c < 4096) ? c+1 : 32'h0ffffff8;
                2: link_for = (c < 4096) ? c+1 : ((c == 4096) ? 2049 : 32'h0ffffff8);
                default: link_for = (c < 4097) ? c+1 : 32'h0ffffff8;
            endcase
        end
    endfunction

    function [7:0] sector_byte;
        input integer addr;
        input integer idx;
        integer cluster, lane;
        reg [31:0] entry;
        begin
            if (addr >= fat_lba && addr < fat_lba+64) begin
                cluster=((addr-fat_lba)*128)+(idx/4);
                lane=idx%4;
                entry=link_for(cluster);
                sector_byte=(entry>>(8*lane))&8'hff;
            end else begin
                sector_byte=(addr+idx)&8'hff;
            end
        end
    endfunction

    // A normal, contiguous 512-byte sector transaction. The FAT walker must
    // request and consume all 512 bytes through its public SD handshake.
    always @(negedge clk) begin
        sd_valid <= 0;
        sd_end <= 0;
        if (ref_sd_read !== opt_sd_read || ref_sd_addr !== opt_sd_addr) begin
            $display("FAIL request divergence t=%0t ref=%b/%0d opt=%b/%0d",$time,ref_sd_read,ref_sd_addr,opt_sd_read,opt_sd_addr);
            failed <= 1;
        end
        if (!enable || !ref_sd_read) begin
            model_active <= 0;
            model_idx <= 0;
        end else if (!model_active) begin
            model_active <= 1;
            model_idx <= 0;
            model_addr <= ref_sd_addr;
        end else if (model_idx < 512) begin
            sd_valid <= 1;
            sd_data <= sector_byte(model_addr,model_idx);
            model_idx <= model_idx+1;
        end else begin
            sd_end <= 1;
            model_active <= 0;
            sector_count <= sector_count+1;
        end
    end

    // Compare every externally observable interface each cycle, then compare
    // numeric Brent states as passive coverage/equivalence observations.
    always @(posedge clk) begin
        cycle_count <= cycle_count+1;
        #1;
        if ({ref_file_data,ref_file_valid,ref_file_end,ref_error,ref_error_code,ref_sd_read,ref_sd_addr} !==
            {opt_file_data,opt_file_valid,opt_file_end,opt_error,opt_error_code,opt_sd_read,opt_sd_addr}) begin
            $display("FAIL interface divergence t=%0t data %02x/%02x valid %b/%b end %b/%b err %b:%02x/%b:%02x sd %b:%0d/%b:%0d",
                $time,ref_file_data,opt_file_data,ref_file_valid,opt_file_valid,ref_file_end,opt_file_end,
                ref_error,ref_error_code,opt_error,opt_error_code,ref_sd_read,ref_sd_addr,opt_sd_read,opt_sd_addr);
            failed <= 1;
        end
        if (reference_mapper.brent_anchor !== optimized_mapper.brent_anchor ||
            reference_mapper.brent_power !== optimized_mapper.brent_power ||
            reference_mapper.brent_length !== optimized_mapper.brent_length ||
            (reference_mapper.state==0 && reference_mapper.cache_valid && reference_mapper.cache_brent_anchor !== optimized_mapper.cache_brent_anchor) ||
            (reference_mapper.state==0 && reference_mapper.cache_valid && reference_mapper.cache_brent_power !== optimized_mapper.cache_brent_power) ||
            (reference_mapper.state==0 && reference_mapper.cache_valid && reference_mapper.cache_brent_length !== optimized_mapper.cache_brent_length)) begin
            $display("FAIL Brent numeric state divergence t=%0t",$time);
            failed <= 1;
        end
        if (data_check && ref_file_valid) begin
            if (data_count>=512 || ref_file_data!==((expected_addr+data_count)&8'hff)) begin
                $display("FAIL payload addr=%0d idx=%0d got=%02x",expected_addr,data_count,ref_file_data);
                failed <= 1;
            end
            data_count <= data_count+1;
        end
    end

    task reset_pair;
        begin
            @(negedge clk); file_read=0; enable=0; rst=1;
            repeat(4) @(negedge clk);
            rst=0; enable=1;
            repeat(4) @(negedge clk);
        end
    endtask

    task request_ok;
        input [31:0] sec;
        input [31:0] want_addr;
        input [31:0] sz;
        input integer max_cycles;
        begin
            @(negedge clk); file_read=0;
            file_sector=sec; file_size=sz; start_cluster=2;
            repeat(3) @(negedge clk);
            expected_addr=want_addr; data_count=0; data_check=1; file_read=1; timeout_count=0;
            while (!ref_file_end && timeout_count<max_cycles) begin
                @(negedge clk); timeout_count=timeout_count+1;
            end
            data_check=0; file_read=0;
            if (timeout_count>=max_cycles || ref_error || data_count!=512 || ref_sd_addr!==want_addr) begin
                $display("FAIL success sec=%0d timeout=%0d err=%b/%02x bytes=%0d addr=%0d want=%0d",
                    sec,timeout_count,ref_error,ref_error_code,data_count,ref_sd_addr,want_addr);
                failed=1;
            end
            repeat(4) @(negedge clk);
        end
    endtask

    task request_error;
        input [31:0] sec;
        input [31:0] sz;
        input [7:0] want_code;
        input integer max_cycles;
        begin
            @(negedge clk); file_read=0;
            if (STATIC_FILE) enable=0;
            file_sector=sec; file_size=sz; start_cluster=2;
            if (STATIC_FILE) begin repeat(1) @(negedge clk); enable=1; end
            repeat(3) @(negedge clk);
            file_read=1; timeout_count=0;
            while (!ref_file_end && timeout_count<max_cycles) begin
                @(negedge clk); timeout_count=timeout_count+1;
            end
            file_read=0;
            if (timeout_count>=max_cycles || !ref_error || ref_error_code!==want_code) begin
                $display("FAIL error sec=%0d timeout=%0d got=%b/%02x want=%02x",
                    sec,timeout_count,ref_error,ref_error_code,want_code);
                failed=1;
            end
            repeat(4) @(negedge clk);
        end
    endtask

    initial begin
        repeat(5) @(negedge clk); rst=0; enable=1;
            repeat(4) @(negedge clk);

        // Ordinary request, cache continuation, and backward seek all use
        // real 512-byte FAT/data sector transactions.
        link_mode=0;
        request_ok(0,1000,4096*512,3000);
        request_ok(4,1004,4096*512,3000);
        request_ok(1,1001,4096*512,3000);

        // Longest legal file: sector index 4094 from a fresh walk, then 4095
        // via the cached tracker. The latter reaches reachable Brent power 4096.
        request_ok(4094,5094,4096*512,2300000);
        request_ok(4095,5095,4096*512,10000);
        if (reference_mapper.cache_brent_power !== 13'd4096 ||
            optimized_mapper.cache_brent_power !== 13'd4096) begin
            $display("FAIL reachable Brent power boundary ref=%0d opt=%0d",
                reference_mapper.cache_brent_power,optimized_mapper.cache_brent_power);
            failed=1;
        end else $display("PASS reachable Brent power boundary: cache power=4096 after legal sector 4095");
        request_ok(0,1000,4096*512,3000);

        // A declaration requiring 4097 clusters is rejected before SD I/O.
        request_error(0,4097*512,8'h09,100);
        reset_pair();

        // Long but prematurely terminated chain: EOC reached while the legal
        // target sector 4095 is still beyond the chain end.
        link_mode=1;
        request_error(4095,4096*512,8'h07,2200000);
        reset_pair();

        // Long tail then a cycle back to the Brent anchor near its 2048-power
        // window; E_LOOP must arise from streamed FAT bytes, never forced state.
        link_mode=2;
        request_error(4095,4096*512,8'h08,2200000);

        if (failed) $fatal(1,"mapper width differential failed after %0d cycles",cycle_count);
        $display("PASS: cycle-equivalent interfaces and Brent numeric state; valid 4096-cluster max, target 4095, cache continuation/backseek, 4097-cluster E_LIMIT, long EOC and late loop; cycles=%0d sectors=%0d",cycle_count,sector_count);
        $finish;
    end

    initial begin
        #200000000;
        $fatal(1,"global timeout cycles=%0d",cycle_count);
    end
endmodule


