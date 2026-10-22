`timescale 1ns/1ps
module tb_controller_gate;
    reg clk = 0, shift = 0, rst = 1;
    always #10 clk = ~clk;
    initial begin #8; forever #10 shift = ~shift; end

    reg wen = 0, ren = 0;
    reg [20:0] wa = 0, ra = 0;
    reg [31:0] wd = 0;
    reg [3:0] dm = 0;
    wire init, refresh, busy, rv;
    wire [31:0] rd;
    sdram dut(.Clk(clk), .Clk_sft(shift), .Rst(rst),
        .Sdr_init_done(init), .Sdr_init_ref_vld(refresh), .Sdr_busy(busy),
        .App_wr_en(wen), .App_wr_addr(wa), .App_wr_dm(dm), .App_wr_din(wd),
        .App_rd_en(ren), .App_rd_addr(ra), .Sdr_rd_en(rv), .Sdr_rd_dout(rd));

    localparam WORDS = 768;
    localparam READ_WORDS = 8192;
    reg [20:0] addresses [0:WORDS-1];
    reg [31:0] expected_data [0:WORDS-1];
    reg [31:0] expected_by_address [0:READ_WORDS-1];
    reg expected_written [0:READ_WORDS-1];
    reg [230399:0] seen;
    integer cycles = 0, reads = 0, refreshes = 0;
    integer file, expected_file, address_file;
    integer n, my, mx, part, u, xx, yy, lane, bank_mask, row_min, row_max;
    integer first_address, address_value, max_address;

    function [31:0] pattern;
        input integer index;
        begin pattern = 32'h7a310000 ^ (index * 32'h0103070b); end
    endfunction

    always @(posedge clk) begin
        cycles = cycles + 1;
        if (refresh === 1'b1) refreshes = refreshes + 1;
        if (file != 0) $fdisplay(file, "%0d,%b,%h,%b,%h,%b,%b", cycles, ren, ra, rv, rd, busy, refresh);
        if (rv === 1'b1) reads = reads + 1;
    end

    initial begin
        file = $fopen("controller_memory.csv", "w");
        expected_file = $fopen("expected.csv", "w");
        address_file = $fopen("jpeg420_addresses.csv", "w");
        if (!file || !expected_file || !address_file) $fatal(1, "cannot open trace files");
        $display("BOUNDARY production controller gate SHA-bound, APUG011 IS42s32200 pin model, nominal clocks; no SDF");
        $display("JPEG420_MAPPING 4 MCU horizontally, 192 words per MCU, 768 unique addresses");
        seen = 0; bank_mask = 0; row_min = 2147483647; row_max = 0; max_address = 0;
        for (n = 0; n < READ_WORDS; n = n + 1) begin
            expected_by_address[n] = 32'b0;
            expected_written[n] = 1'b0;
        end
        for (n = 0; n < WORDS; n = n + 1) begin
            my = n / 7680;
            mx = (n % 7680) / 192;
            part = (n % 192) / 48;
            u = n % 48;
            xx = mx * 4 + (part % 2) * 2 + (u % 6) / 3;
            yy = my * 16 + (part / 2) * 8 + u / 6;
            lane = u % 3;
            address_value = yy * 480 + xx * 3 + lane;
            if (address_value < 0 || address_value >= 230400) $fatal(1, "address range n=%0d addr=%0d", n, address_value);
            if (seen[address_value]) $fatal(1, "duplicate address n=%0d addr=%0d", n, address_value);
            seen[address_value] = 1'b1;
            addresses[n] = address_value;
            expected_data[n] = pattern(n);
            if (address_value >= READ_WORDS) $fatal(1, "read coverage too small for address=%0d", address_value);
            expected_by_address[address_value] = expected_data[n];
            expected_written[address_value] = 1'b1;
            if (address_value > max_address) max_address = address_value;
            bank_mask = bank_mask | (1 << ((address_value >> 8) & 3));
            if ((address_value >> 10) < row_min) row_min = address_value >> 10;
            if ((address_value >> 10) > row_max) row_max = address_value >> 10;
            $fdisplay(address_file, "%0d,%0d,%0d,%0d,%0d", n, address_value, yy, xx, lane);
            $fdisplay(expected_file, "%0d,%0d,%h", n, address_value, expected_data[n]);
        end
        if (bank_mask != 15) $fatal(1, "expected all 4 banks, got mask=%0h", bank_mask);
        if (row_max <= row_min) $fatal(1, "expected multiple row regions, got %0d..%0d", row_min, row_max);

        repeat (100) @(negedge clk);
        rst = 0;
        wait (init === 1'b1);
        $display("MEM_INIT t_ns=%0.3f", $realtime);
        repeat (50) @(negedge clk);
        wait (busy === 1'b0);

        for (n = 0; n < WORDS; n = n + 1) begin
            @(negedge clk);
            wen = 1;
            wa = addresses[n];
            wd = expected_data[n];
            dm = 0;
        end
        @(negedge clk); wen = 0; dm = 0; wd = 0;
        repeat (50) @(negedge clk);
        wait (busy === 1'b0);

        for (n = 0; n < READ_WORDS; n = n + 1)
            $fdisplay(expected_file, "%0d,%b,%h", n, expected_written[n], expected_by_address[n]);
        for (n = 0; n < READ_WORDS; n = n + 1) begin
            @(negedge clk);
            ren = 1;
            ra = n;
        end
        @(negedge clk); ren = 0;
        repeat (50) @(negedge clk);
        wait (busy === 1'b0);
        repeat (4) @(negedge clk);
        $fclose(file); $fclose(expected_file); $fclose(address_file);
        if (reads != READ_WORDS || refreshes == 0) $fatal(1, "coverage reads=%0d refresh=%0d", reads, refreshes);
        $display("JPEG420_CONTROLLER_TRACE_COMPLETE jump_writes=%0d linear_reads=%0d all_addresses_unique=1 bank_mask=%0h row_range=%0d..%0d max_address=%0d refresh_cycles=%0d",
            WORDS, READ_WORDS, bank_mask, row_min, row_max, max_address, refreshes);
        $finish;
    end

    initial begin
        #10000000;
        $fatal(1, "controller timeout init=%b busy=%b reads=%0d", init, busy, reads);
    end
endmodule
