`timescale 1ns/1ps
module tb_mapper_edges_algorithm;
    reg clk=0, rst=1, enable=1, file_read=0;
    reg [31:0] fat_lba=10, data_lba=100, cluster_count=5000;
    reg [3:0] sectors_per_cluster_shift=0;
    reg [31:0] start_cluster=2, file_size=512, file_sector=0;
    reg [7:0] sd_data=0;
    reg sd_valid=0, sd_end=0;
    wire [7:0] ref_file_data, opt_file_data, ref_error_code, opt_error_code;
    wire ref_file_valid, opt_file_valid, ref_file_end, opt_file_end;
    wire ref_error, opt_error, ref_sd_read, opt_sd_read;
    wire [31:0] ref_sd_addr, opt_sd_addr;
    integer model_active=0, model_idx=0, model_addr=0;
    integer failed=0, cycle_count=0, timeout_count=0;
    integer link_mode=0;
    integer s;

    always #5 clk=~clk;

    fat32_file_sector_reference #(.WAIT_LIMIT(20)) reference_mapper (
        .clk(clk),.rst(rst),.enable(enable),.fat_lba(fat_lba),.data_lba(data_lba),
        .cluster_count(cluster_count),.sectors_per_cluster_shift(sectors_per_cluster_shift),
        .start_cluster(start_cluster),.file_size(file_size),.file_read(file_read),.file_sector(file_sector),
        .file_data(ref_file_data),.file_valid(ref_file_valid),.file_end(ref_file_end),
        .error(ref_error),.error_code(ref_error_code),.sd_read(ref_sd_read),.sd_addr(ref_sd_addr),
        .sd_data(sd_data),.sd_valid(sd_valid),.sd_end(sd_end)
    );
    fat32_file_sector_algorithm #(.WAIT_LIMIT(20)) optimized_mapper (
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
                1: link_for=(c<4096)?c+1:32'h0ffffff8;
                default: link_for=(c<4097)?c+1:32'h0ffffff8;
            endcase
        end
    endfunction

    function [7:0] sector_byte;
        input integer addr;
        input integer idx;
        integer cluster, lane, rel;
        reg [31:0] entry;
        begin
            rel=addr-fat_lba;
            if ((rel>=0) && (rel<64)) begin
                cluster=(rel*128)+(idx/4);
                lane=idx%4;
                entry=link_for(cluster);
                sector_byte=(entry>>(8*lane))&8'hff;
            end else begin
                sector_byte=(addr+idx)&8'hff;
            end
        end
    endfunction

    always @(negedge clk) begin
        sd_valid<=0;
        sd_end<=0;
        if ({ref_sd_read,ref_sd_addr} !== {opt_sd_read,opt_sd_addr}) begin
            $display("FAIL edge request divergence ref=%b:%08x opt=%b:%08x",ref_sd_read,ref_sd_addr,opt_sd_read,opt_sd_addr);
            failed<=1;
        end
        if (!enable || !ref_sd_read) begin
            model_active<=0;
            model_idx<=0;
        end else if (!model_active) begin
            model_active<=1;
            model_idx<=0;
            model_addr<=ref_sd_addr;
        end else if (model_idx<512) begin
            sd_valid<=1;
            sd_data<=sector_byte(model_addr,model_idx);
            model_idx<=model_idx+1;
        end else begin
            sd_end<=1;
            model_active<=0;
        end
    end

    always @(posedge clk) begin
        cycle_count<=cycle_count+1;
        #1;
        if ({ref_file_data,ref_file_valid,ref_file_end,ref_error,ref_error_code,ref_sd_read,ref_sd_addr} !==
            {opt_file_data,opt_file_valid,opt_file_end,opt_error,opt_error_code,opt_sd_read,opt_sd_addr}) begin
            $display("FAIL edge interface divergence cycle=%0d",cycle_count);
            failed<=1;
        end
    end

    task reset_pair;
        begin
            @(negedge clk); file_read=0; rst=1;
            repeat(4) @(negedge clk);
            rst=0;
            repeat(4) @(negedge clk);
        end
    endtask

    task prepare_request;
        input [3:0] shift_value;
        input [31:0] cluster_value;
        input [31:0] size_value;
        input [31:0] sector_value;
        input [31:0] count_value;
        input [31:0] fat_value;
        input [31:0] data_value;
        begin
            @(negedge clk);
            file_read=0;
            sectors_per_cluster_shift=shift_value;
            start_cluster=cluster_value;
            file_size=size_value;
            file_sector=sector_value;
            cluster_count=count_value;
            fat_lba=fat_value;
            data_lba=data_value;
            repeat(3) @(negedge clk);
            file_read=1;
            @(negedge clk);
            file_read=0;
        end
    endtask

    task await_end;
        input integer limit;
        begin
            timeout_count=0;
            while (!ref_file_end && timeout_count<limit) begin
                @(negedge clk); timeout_count=timeout_count+1;
            end
        end
    endtask

    task expect_ok;
        input [31:0] expected_addr;
        input integer limit;
        begin
            await_end(limit);
            if (timeout_count>=limit || ref_error || ref_sd_addr!==expected_addr) begin
                $display("FAIL expected success addr=%08x got err=%b/%02x addr=%08x timeout=%0d",expected_addr,ref_error,ref_error_code,ref_sd_addr,timeout_count);
                failed=1;
            end
        end
    endtask

    task expect_error;
        input [7:0] expected_code;
        input integer limit;
        begin
            await_end(limit);
            if (timeout_count>=limit || !ref_error || ref_error_code!==expected_code) begin
                $display("FAIL expected error=%02x got err=%b/%02x timeout=%0d",expected_code,ref_error,ref_error_code,timeout_count);
                failed=1;
            end
        end
    endtask

    task request_error;
        input [3:0] shift_value;
        input [31:0] cluster_value;
        input [31:0] size_value;
        input [31:0] sector_value;
        input [31:0] count_value;
        input [31:0] fat_value;
        input [31:0] data_value;
        input [7:0] expected_code;
        begin
            reset_pair();
            prepare_request(shift_value,cluster_value,size_value,sector_value,count_value,fat_value,data_value);
            expect_error(expected_code,3000);
        end
    endtask

    task request_ok;
        input [3:0] shift_value;
        input [31:0] cluster_value;
        input [31:0] size_value;
        input [31:0] sector_value;
        input [31:0] count_value;
        input [31:0] fat_value;
        input [31:0] data_value;
        input [31:0] expected_addr;
        begin
            reset_pair();
            prepare_request(shift_value,cluster_value,size_value,sector_value,count_value,fat_value,data_value);
            expect_ok(expected_addr,3000);
        end
    endtask

    task request_live_shift;
        input [3:0] selected_shift;
        input [31:0] data_base;
        input [31:0] expected_addr;
        input [7:0] expected_error;
        begin
            reset_pair();
            prepare_request(0,3,512,0,5000,10,data_base);
            while (reference_mapper.state!=2) @(negedge clk);
            sectors_per_cluster_shift=selected_shift;
            await_end(3000);
            if (timeout_count>=3000) begin
                $display("FAIL live shift %0d timed out",selected_shift); failed=1;
            end else if (expected_error==0) begin
                if (ref_error || ref_sd_addr!==expected_addr) begin
                    $display("FAIL live shift %0d expected addr=%08x got err=%b/%02x addr=%08x",selected_shift,expected_addr,ref_error,ref_error_code,ref_sd_addr); failed=1;
                end
            end else if (!ref_error || ref_error_code!==expected_error) begin
                $display("FAIL live shift %0d expected err=%02x got %b/%02x",selected_shift,expected_error,ref_error,ref_error_code); failed=1;
            end
        end
    endtask

    initial begin
        repeat(5) @(negedge clk); rst=0; repeat(4) @(negedge clk);

        // All four-bit shift values remain live in S_SELECT after S_CHECK.
        for (s=0; s<16; s=s+1)
            request_live_shift(s[3:0],32'd100,32'd100+(32'd1<<s),0);
        request_live_shift(4'd15,32'hffff7fff,32'hffffffff,0);
        request_live_shift(4'd15,32'hffff8001,32'd0,8'h04);

        // The largest accepted start cluster is count+1 = 0x0ffffff6.
        request_ok(0,32'h0ffffff6,512,0,32'h0ffffff5,10,32'hf0000000,32'hfffffff4);
        request_error(0,32'h0ffffff7,512,0,32'h0ffffff5,10,100,8'h03);

        // ceil(file_size/512) boundaries and range/cluster-count limits.
        request_error(0,2,0,0,5000,10,100,8'h01);
        request_ok(0,2,1,0,5000,10,100,100);
        request_ok(0,2,511,0,5000,10,100,100);
        request_ok(0,2,512,0,5000,10,100,100);
        request_ok(0,2,513,1,5000,10,100,101);
        request_error(0,2,1,1,5000,10,100,8'h01);
        request_error(0,2,4097*512,0,5000,10,100,8'h09);
        request_error(0,2,32'hffffffff,0,5000,10,100,8'h09);

        // FAT-LBA addition exact top result and overflow branch.
        request_ok(0,128,1024,1,5000,32'hfffffffe,100,227);
        request_error(0,256,1024,1,5000,32'hfffffffe,100,8'h04);

        if (failed) $fatal(1,"mapper edge differential failed after %0d cycles",cycle_count);
        $display("PASS: mapper edge differential; live shifts 0..15, data/FAT address limits, cluster bounds, size/limit boundaries; cycles=%0d",cycle_count);
        $finish;
    end

    initial begin
        #100000000;
        $fatal(1,"global timeout cycles=%0d",cycle_count);
    end
endmodule

