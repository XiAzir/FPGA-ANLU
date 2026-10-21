`timescale 1ns/1ps
module tb_mapper_specialize #(
    parameter integer CATALOG_GEOMETRY=0,
    parameter integer STATIC_FILE=0,
    parameter integer REQUEST_STABLE=0
);
    reg clk=0, rst=1, enable=0, file_read=0;
    reg [31:0] fat_lba=100, data_lba=1000, cluster_count=65525;
    reg [3:0] sectors_per_cluster_shift=0;
    reg [31:0] start_cluster=2, file_size=512, file_sector=0;
    reg [7:0] sd_data=0;
    reg sd_valid=0, sd_end=0;
    wire [7:0] g_file_data, c_file_data, g_error_code, c_error_code;
    wire g_file_valid, c_file_valid, g_file_end, c_file_end;
    wire g_error, c_error, g_sd_read, c_sd_read;
    wire [31:0] g_sd_addr, c_sd_addr;
    integer errors=0, cycle_no=0, payload_outputs=0, expected_index=0, file_ends=0;
    integer scenario=0, check_payload=0;
    integer k;

    always #5 clk=~clk;

    fat32_file_sector_generic #(.WAIT_LIMIT(48)) generic_ref (
        .clk(clk),.rst(rst),.enable(enable),.fat_lba(fat_lba),.data_lba(data_lba),
        .cluster_count(cluster_count),.sectors_per_cluster_shift(sectors_per_cluster_shift),
        .start_cluster(start_cluster),.file_size(file_size),.file_read(file_read),.file_sector(file_sector),
        .file_data(g_file_data),.file_valid(g_file_valid),.file_end(g_file_end),
        .error(g_error),.error_code(g_error_code),.sd_read(g_sd_read),.sd_addr(g_sd_addr),
        .sd_data(sd_data),.sd_valid(sd_valid),.sd_end(sd_end)
    );

    fat32_file_sector #(
        .WAIT_LIMIT(48),.CATALOG_GEOMETRY(CATALOG_GEOMETRY),
        .STATIC_FILE(STATIC_FILE),.REQUEST_STABLE(REQUEST_STABLE)
    ) specialized (
        .clk(clk),.rst(rst),.enable(enable),.fat_lba(fat_lba),.data_lba(data_lba),
        .cluster_count(cluster_count),.sectors_per_cluster_shift(sectors_per_cluster_shift),
        .start_cluster(start_cluster),.file_size(file_size),.file_read(file_read),.file_sector(file_sector),
        .file_data(c_file_data),.file_valid(c_file_valid),.file_end(c_file_end),
        .error(c_error),.error_code(c_error_code),.sd_read(c_sd_read),.sd_addr(c_sd_addr),
        .sd_data(sd_data),.sd_valid(sd_valid),.sd_end(sd_end)
    );

    always @(negedge clk) begin
        if (!rst) begin
            if ({c_file_data,c_file_valid,c_file_end,c_error,c_error_code,c_sd_read,c_sd_addr} !==
                {g_file_data,g_file_valid,g_file_end,g_error,g_error_code,g_sd_read,g_sd_addr}) begin
                $display("DIFF mode=%0d%0d%0d scenario=%0d cycle=%0d outputs c=%h/%b/%b/%b/%h/%b/%h g=%h/%b/%b/%b/%h/%b/%h",
                    CATALOG_GEOMETRY,STATIC_FILE,REQUEST_STABLE,scenario,cycle_no,
                    c_file_data,c_file_valid,c_file_end,c_error,c_error_code,c_sd_read,c_sd_addr,
                    g_file_data,g_file_valid,g_file_end,g_error,g_error_code,g_sd_read,g_sd_addr);
                errors=errors+1;
            end
            if (c_file_valid) begin
                if (check_payload && c_file_data !== expected_index[7:0]) begin
                    $display("DATA DIFF scenario=%0d index=%0d candidate=%02h expected=%02h",scenario,expected_index,c_file_data,expected_index[7:0]);
                    errors=errors+1;
                end
                payload_outputs=payload_outputs+1;
                expected_index=expected_index+1;
            end
            if (c_file_end) file_ends=file_ends+1;
            cycle_no=cycle_no+1;
        end
    end

    task reset_request(input [31:0] sect, size, cluster);
        begin
            @(negedge clk); rst=1; enable=0; file_read=0; sd_valid=0; sd_end=0;
            file_sector=sect; file_size=size; start_cluster=cluster;
            repeat(3) @(negedge clk);
            rst=0; enable=1;
            repeat(2) @(negedge clk);
            file_read=1;
            @(negedge clk); file_read=0;
        end
    endtask

    task wait_state(input integer wanted);
        integer t;
        begin
            t=0;
            while(specialized.state!=wanted && t<1000) begin @(negedge clk); t=t+1; end
            if (specialized.state!=wanted || generic_ref.state!=wanted) begin
                $display("STATE WAIT FAIL scenario=%0d wanted=%0d c=%0d g=%0d",scenario,wanted,specialized.state,generic_ref.state);
                errors=errors+1;
            end
        end
    endtask

    task send_stream(input integer count, input integer end_same_last, input integer fat_payload);
        integer i;
        begin
            for(i=0;i<count;i=i+1) begin
                @(negedge clk); sd_valid=1;
                if (fat_payload && i==8) sd_data=8'd3;
                else if (fat_payload && i>=9 && i<=11) sd_data=8'd0;
                else sd_data=fat_payload ? 8'd0 : i[7:0];
                sd_end=(end_same_last && i==count-1);
            end
            @(negedge clk); sd_valid=0; sd_end=0;
        end
    endtask

    task end_sector;
        begin @(negedge clk); sd_valid=0; sd_end=1; @(negedge clk); sd_end=0; end
    endtask

    task expect_error(input integer which, input [31:0] sect,size,cluster,
                      input [31:0] cc, input [3:0] shift, input [31:0] flba,dlba,
                      input [7:0] code);
        integer t;
        begin
            scenario=which; check_payload=0;
            reset_request(sect,size,cluster);
            cluster_count=cc; sectors_per_cluster_shift=shift; fat_lba=flba; data_lba=dlba;
            t=0;
            while(!c_error && t<1000) begin @(negedge clk); t=t+1; end
            if (!c_error || !g_error || c_error_code!=code || g_error_code!=code || c_sd_read || g_sd_read) begin
                $display("ERROR EXPECT FAIL scenario=%0d c=%b/%h g=%b/%h",which,c_error,c_error_code,g_error,g_error_code);
                errors=errors+1;
            end
        end
    endtask

    task expect_sd_error(input integer which, input integer count,
                         input integer same_end, input integer fat_mode);
        integer t;
        begin
            scenario=which; check_payload=0;
            reset_request(fat_mode ? 1 : 0,fat_mode ? 1024 : 512,2);
            cluster_count=65525; sectors_per_cluster_shift=0; fat_lba=100; data_lba=1000;
            wait_state(fat_mode ? 3 : 4);
            send_stream(count,same_end,fat_mode);
            if (!same_end && count<=512) end_sector();
            t=0; while(!c_error && t<1000) begin @(negedge clk); t=t+1; end
            if (!c_error || !g_error || c_error_code!=8'h05 || g_error_code!=8'h05 || c_sd_read || g_sd_read) begin
                $display("SD ERROR EXPECT FAIL scenario=%0d count=%0d same=%0d fat=%0d c=%b/%h g=%b/%h",
                    which,count,same_end,fat_mode,c_error,c_error_code,g_error,g_error_code);
                errors=errors+1;
            end
        end
    endtask

    task full_fat_then_data;
        integer t;
        begin
            scenario=20; payload_outputs=0; expected_index=0; file_ends=0; check_payload=0;
            reset_request(1,1024,2);
            cluster_count=65525; sectors_per_cluster_shift=0; fat_lba=100; data_lba=1000;
            wait_state(3);
            send_stream(512,0,1); end_sector();
            wait_state(4);
            check_payload=1;
            send_stream(512,0,0); end_sector();
            t=0; while(!c_file_end && t<1000) begin @(negedge clk); t=t+1; end
            repeat(2) @(negedge clk);
            check_payload=0;
            if (c_error || g_error || payload_outputs!=512 || expected_index!=512 || file_ends!=1) begin
                $display("FULL TRANSACTION FAIL errors=%b/%b bytes=%0d index=%0d ends=%0d",
                    c_error,g_error,payload_outputs,expected_index,file_ends);
                errors=errors+1;
            end
        end
    endtask

    task descriptor_switch;
        integer n;
        begin
            if (!STATIC_FILE) begin
                scenario=21; check_payload=0;
                reset_request(0,512,2);
                wait_state(4); send_stream(512,0,0); end_sector();
                n=0; while(!c_file_end && n<1000) begin @(negedge clk); n=n+1; end
                repeat(5) @(negedge clk);
                // A new image descriptor is allowed between requests. Keep it
                // fixed from file_read through the next file_end pulse.
                start_cluster=3; file_size=1024; file_sector=0;
                repeat(3) @(negedge clk);
                file_read=1; @(negedge clk); file_read=0;
                wait_state(4); send_stream(512,0,0); end_sector();
                n=0; while(!c_file_end && n<1000) begin @(negedge clk); n=n+1; end
                repeat(2) @(negedge clk);
                if (c_error || g_error) begin $display("DESCRIPTOR SWITCH FAIL"); errors=errors+1; end
            end
        end
    endtask

    task enable_abort_and_resume;
        integer t;
        begin
            scenario=22; check_payload=0;
            reset_request(0,512,2);
            wait_state(4);
            send_stream(17,0,0);
            @(negedge clk); enable=0; sd_valid=0; sd_end=0;
            repeat(4) @(negedge clk);
            if (c_error || g_error || c_sd_read || g_sd_read) begin
                $display("ENABLE ABORT FAIL c=%b/%b g=%b/%b",c_error,c_sd_read,g_error,g_sd_read);
                errors=errors+1;
            end
            // Re-enable after an idle low interval, then verify a fresh request.
            @(negedge clk); enable=1; file_read=0;
            repeat(2) @(negedge clk);
            file_read=1; @(negedge clk); file_read=0;
            wait_state(4);
            send_stream(512,0,0); end_sector();
            t=0; while(!c_file_end && t<1000) begin @(negedge clk); t=t+1; end
            if (c_error || g_error) begin $display("ENABLE RESUME FAIL"); errors=errors+1; end
        end
    endtask

    task reset_abort_and_resume;
        integer t;
        begin
            scenario=23; check_payload=0;
            reset_request(0,512,2);
            wait_state(4);
            send_stream(9,0,0);
            // reset_request asserts asynchronous reset while a sector is active.
            reset_request(1,1024,2);
            wait_state(3);
            send_stream(512,0,1); end_sector();
            wait_state(4);
            send_stream(512,0,0); end_sector();
            t=0; while(!c_file_end && t<1000) begin @(negedge clk); t=t+1; end
            if (c_error || g_error) begin $display("RESET RESUME FAIL"); errors=errors+1; end
        end
    endtask

    task generic_snapshot_and_live_geometry;
        integer t;
        begin
            if (!CATALOG_GEOMETRY && !STATIC_FILE && !REQUEST_STABLE) begin
                scenario=24; check_payload=0;
                reset_request(0,512,2);
                // The accepted file request is already captured. These fields
                // change before S_CHECK and therefore must not replace its snapshot.
                file_sector=9; file_size=0; start_cluster=77;
                wait_state(2);
                // Geometry inputs remain live through S_SELECT in generic mode.
                data_lba=1001;
                wait_state(4);
                if (c_sd_addr!=1001 || g_sd_addr!=1001) begin
                    $display("GENERIC LIVE LBA FAIL c=%0d g=%0d",c_sd_addr,g_sd_addr);
                    errors=errors+1;
                end
                send_stream(512,0,0); end_sector();
                t=0; while(!c_file_end && t<1000) begin @(negedge clk); t=t+1; end
                if (c_error || g_error) begin $display("GENERIC SNAPSHOT FAIL"); errors=errors+1; end
            end
        end
    endtask

    task geometry_errors;
        begin
            if (!CATALOG_GEOMETRY) begin
                expect_error(30,0,512,2,0,0,100,1000,8'h02); // zero cluster count: geometry error precedes cluster error
                expect_error(31,0,512,2,65525,8,100,1000,8'h02); // unsupported geometry
                expect_error(32,0,512,2,65525,0,32'hffffffff,1000,8'h02);
                expect_error(33,0,512,2,32'h0ffffff6,0,100,1000,8'h03);
            end
        end
    endtask

    initial begin
        // Catalog-derived geometry shared with the top. Keep it valid even for
        // generic mode so file-level checks remain comparable.
        cluster_count=65525; sectors_per_cluster_shift=0; fat_lba=100; data_lba=1000;
        expect_error(1,0,0,2,65525,0,100,1000,8'h01);
        expect_error(2,1,512,2,65525,0,100,1000,8'h01);
        expect_error(3,0,512,1,65525,0,100,1000,8'h03);
        expect_error(4,0,2097153,2,65525,0,100,1000,8'h09);
        expect_sd_error(5,511,0,0); // short data sector
        expect_sd_error(6,512,1,0); // final data byte and end together
        expect_sd_error(7,513,0,0); // overlong data sector
        expect_sd_error(8,511,0,1); // short FAT sector
        expect_sd_error(9,512,1,1); // final FAT byte and end together
        expect_sd_error(10,513,0,1); // overlong FAT sector
        geometry_errors();
        full_fat_then_data();
        descriptor_switch();
        enable_abort_and_resume();
        reset_abort_and_resume();
        generic_snapshot_and_live_geometry();
        if (errors==0) $display("PASS: mapper specialization contract differential %0d%0d%0d",
            CATALOG_GEOMETRY,STATIC_FILE,REQUEST_STABLE);
        else $display("FAIL: mapper specialization errors=%0d",errors);
        $finish;
    end
endmodule
