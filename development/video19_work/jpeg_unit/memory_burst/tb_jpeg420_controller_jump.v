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
    integer file, expected_file, address_file, command_file, write_trace_file;
    integer n, my, mx, part, u, xx, yy, lane;
    integer first_address, address_value, max_address, format565, target_words, sub, block_row, word_col;
    integer burst_words, gap_cycles, data_lag;

    function [31:0] pattern;
        input integer index;
        begin pattern = 32'h7a310000 ^ (index * 32'h0103070b); end
    endfunction

    always @(posedge clk) begin
        cycles = cycles + 1;
        if (refresh === 1'b1) refreshes = refreshes + 1;
        if (file != 0) $fdisplay(file, "%0d,%b,%h,%b,%h,%b,%b", cycles, ren, ra, rv, rd, busy, refresh);
        if (write_trace_file != 0 && (wen || busy))
            $fdisplay(write_trace_file, "%0d,%b,%h,%h,%b", cycles, wen, wa, wd, busy);
        if (rv === 1'b1) reads = reads + 1;
    end

    always @(posedge dut.sdram.clk) begin
        if (command_file != 0 && dut.sdram.cs_n === 1'b0 && dut.sdram.cke === 1'b1 &&
            {dut.sdram.ras_n, dut.sdram.cas_n, dut.sdram.we_n} !== 3'b111)
            $fdisplay(command_file, "%0.3f,%b,%b,%b,%b,%h,%h,%b,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h",
                $realtime, dut.sdram.ras_n, dut.sdram.cas_n, dut.sdram.we_n,
                dut.sdram.ba, dut.sdram.addr, dut.sdram.dq,
                wen, wa, wd,
                dut.\u2_ram/u2_wrrd/app_wr_addr_1d , dut.\u2_ram/u2_wrrd/app_wr_addr_2d ,
                dut.\u2_ram/u2_wrrd/app_wr_addr_3d , dut.\u2_ram/u2_wrrd/app_wr_addr_4d ,
                dut.\u2_ram/u2_wrrd/app_wr_din_1d , dut.\u2_ram/u2_wrrd/app_wr_din_2d ,
                dut.\u2_ram/u2_wrrd/app_wr_din_3d , dut.\u2_ram/u2_wrrd/app_wr_din_4d ,
                dut.\u2_ram/u2_wrrd/app_wr_din_5d , dut.\u2_ram/u2_wrrd/app_wr_din_6d ,
                dut.\u2_ram/u2_wrrd/active_ba , dut.\u2_ram/u2_wrrd/active_row ,
                dut.\u2_ram/u2_wrrd/active_col );
    end

    initial begin
        file = $fopen("controller_memory.csv", "w");
        expected_file = $fopen("expected.csv", "w");
        address_file = $fopen("jpeg420_addresses.csv", "w");
        command_file = $fopen("sdram_commands.csv", "w");
        write_trace_file = $fopen("app_write_trace.csv", "w");
        if (!file || !expected_file || !address_file || !command_file || !write_trace_file) $fatal(1, "cannot open trace files");
        format565 = $test$plusargs("RGB565");
        if (!$value$plusargs("BURST_WORDS=%d", burst_words)) burst_words = 128;
        if (!$value$plusargs("GAP_CYCLES=%d", gap_cycles)) gap_cycles = 50;
        if (!$value$plusargs("DATA_LAG=%d", data_lag)) data_lag = 0;
        if (burst_words < 1 || burst_words > 128) $fatal(1, "BURST_WORDS must be 1..128");
        if (data_lag < 0 || data_lag > 1) $fatal(1, "DATA_LAG must be 0 or 1");
        target_words = format565 ? 512 : WORDS;
        $display("BOUNDARY production controller gate SHA-bound, APUG011 IS42s32200 pin model, nominal clocks; no SDF");
        if (format565)
            $display("RGB565_MAPPING 4 MCU horizontally, 128 words per MCU, 512 unique addresses; four words per 8-pixel block row");
        else
            $display("RGB888_MAPPING 4 MCU horizontally, 192 words per MCU, 768 unique addresses; six words per 8-pixel block row");
        seen = 0; max_address = 0;
        for (n = 0; n < READ_WORDS; n = n + 1) begin
            expected_by_address[n] = 32'b0;
            expected_written[n] = 1'b0;
        end
        for (n = 0; n < target_words; n = n + 1) begin
            if (format565) begin
                mx = n / 128;
                sub = n % 128;
                part = sub / 32;
                block_row = (sub % 32) / 4;
                word_col = sub % 4;
                xx = mx * 16 + (part % 2) * 8 + word_col * 2;
                yy = (part / 2) * 8 + block_row;
                lane = word_col;
                address_value = yy * 320 + xx / 2;
            end else begin
                my = n / 7680;
                mx = (n % 7680) / 192;
                part = (n % 192) / 48;
                u = n % 48;
                xx = mx * 4 + (part % 2) * 2 + (u % 6) / 3;
                yy = my * 16 + (part / 2) * 8 + u / 6;
                lane = u % 3;
                address_value = yy * 480 + xx * 3 + lane;
            end
            if (address_value < 0 || address_value >= 230400) $fatal(1, "address range n=%0d addr=%0d", n, address_value);
            if (seen[address_value]) $fatal(1, "duplicate address n=%0d addr=%0d", n, address_value);
            seen[address_value] = 1'b1;
            addresses[n] = address_value;
            expected_data[n] = pattern(n);
            if (address_value >= READ_WORDS) $fatal(1, "read coverage too small for address=%0d", address_value);
            expected_by_address[address_value] = expected_data[n];
            expected_written[address_value] = 1'b1;
            if (address_value > max_address) max_address = address_value;
            $fdisplay(address_file, "%0d,%0d,%0d,%0d,%0d", n, address_value, yy, xx, lane);
        end

        repeat (100) @(negedge clk);
        rst = 0;
        wait (init === 1'b1);
        $display("MEM_INIT t_ns=%0.3f", $realtime);
        repeat (50) @(negedge clk);
        wait (busy === 1'b0);

        for (n = 0; n < target_words; n = n + 1) begin
            @(negedge clk);
            wen = 1;
            wa = addresses[n];
            wd = expected_data[(data_lag && n > 0) ? n-1 : n];
            dm = 0;
            if ((n%burst_words == burst_words-1) || n == target_words-1) begin
                @(negedge clk);wen=0;
                wait(busy===1'b1);
                repeat(gap_cycles) @(negedge clk);
                wait(busy===1'b0);
            end
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
            if (n%128 == 127) begin
                @(negedge clk);ren=0;
                repeat(50) @(negedge clk);
                wait(busy===1'b0);
            end
        end
        @(negedge clk); ren = 0;
        repeat (50) @(negedge clk);
        wait (busy === 1'b0);
        repeat (4) @(negedge clk);
        $fclose(file); $fclose(expected_file); $fclose(address_file); $fclose(command_file); $fclose(write_trace_file);
        if (reads != READ_WORDS || refreshes == 0) $fatal(1, "coverage reads=%0d refresh=%0d", reads, refreshes);
        $display("JPEG420_CONTROLLER_TRACE_COMPLETE format565=%0d jump_writes=%0d linear_reads=%0d all_addresses_unique=1 max_address=%0d refresh_cycles=%0d burst_words=%0d gap_cycles=%0d data_lag=%0d",
            format565, target_words, READ_WORDS, max_address, refreshes, burst_words, gap_cycles, data_lag);
        $finish;
    end

    initial begin
        #10000000;
        $fatal(1, "controller timeout init=%b busy=%b reads=%0d", init, busy, reads);
    end
endmodule
