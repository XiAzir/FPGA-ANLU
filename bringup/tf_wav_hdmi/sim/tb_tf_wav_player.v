`timescale 1ns/1ps

module tb_tf_wav_player;
    reg clk = 1'b0;
    always #10 clk = ~clk;

    reg rst = 1'b1;
    reg sd_init_done = 1'b0;
    wire sd_read;
    wire [31:0] sd_addr;
    reg [7:0] sd_data = 8'd0;
    reg sd_valid = 1'b0;
    reg sd_end = 1'b0;
    reg sample_take = 1'b0;
    wire [15:0] sample_data;
    wire sample_available;
    wire primed;
    wire error;

    tf_wav_player #(
        .START_SECTOR(32'd7),
        .EXPECTED_DATA_BYTES(32'd1024),
        .FIFO_DEPTH(512)
    ) dut (
        .clk(clk), .rst(rst), .sd_init_done(sd_init_done),
        .sd_read(sd_read), .sd_addr(sd_addr), .sd_data(sd_data),
        .sd_valid(sd_valid), .sd_end(sd_end), .sample_take(sample_take),
        .sample_data(sample_data), .sample_available(sample_available),
        .primed(primed), .error(error)
    );

    integer produced_loop;
    integer sector;
    integer byte_index;
    integer actual_gap;
    integer sample_index;
    integer received;
    integer idx;
    integer wait_count;
    integer concurrent_count;
    integer push_count;
    integer pop_count;
    reg bad_header;
    reg [7:0] byte_value;

    function [7:0] header_byte;
        input integer offset;
        begin
            case (offset)
                0: header_byte = "R";
                1: header_byte = "I";
                2: header_byte = "F";
                3: header_byte = "F";
                4: header_byte = 8'd20; // RIFF size = 36 + 1024
                5: header_byte = 8'd4;
                6: header_byte = 8'd0;
                7: header_byte = 8'd0;
                8: header_byte = "W";
                9: header_byte = "A";
                10: header_byte = "V";
                11: header_byte = "E";
                12: header_byte = "f";
                13: header_byte = "m";
                14: header_byte = "t";
                15: header_byte = " ";
                16: header_byte = 8'd16;
                20: header_byte = 8'd1;
                22: header_byte = 8'd1;
                24: header_byte = 8'h80;
                25: header_byte = 8'hbb;
                28: header_byte = 8'h00; // byte rate 96000
                29: header_byte = 8'h77;
                30: header_byte = 8'h01;
                32: header_byte = 8'd2;
                34: header_byte = 8'd16;
                36: header_byte = "d";
                37: header_byte = "a";
                38: header_byte = "t";
                39: header_byte = "a";
                40: header_byte = 8'd0;
                41: header_byte = 8'd4;
                default: header_byte = 8'd0;
            endcase
        end
    endfunction

    task make_and_send_sector;
        input integer loop_no;
        input integer sector_no;
        input integer corrupt_header;
        input integer byte_gap;
        begin
            wait (sd_read === 1'b1);
            if (sd_addr !== (32'd7 + sector_no)) begin
                $display("FAIL: sector address loop=%0d sector=%0d got=%0d", loop_no, sector_no, sd_addr);
                $fatal(1);
            end
            for (byte_index = 0; byte_index < 512; byte_index = byte_index + 1) begin
                actual_gap = byte_gap;
                // The paced case averages 32 clocks per byte while allowing
                // small interface phase variation around that rate.
                if (byte_gap == 32) begin
                    if ((byte_index % 4) == 0) actual_gap = 31;
                    else if ((byte_index % 4) == 1) actual_gap = 33;
                end
                @(negedge clk);
                sd_valid = 1'b1;
                if ((sector_no == 0) && (byte_index < 44)) begin
                    byte_value = header_byte(byte_index);
                    if (corrupt_header && (byte_index == 0)) byte_value = 8'h58;
                    sd_data = byte_value;
                end else begin
                    if (sector_no == 0)
                        sample_index = (byte_index - 44) / 2;
                    else if (sector_no == 1)
                        sample_index = 234 + byte_index / 2;
                    else
                        sample_index = 490 + byte_index / 2;
                    if (sample_index < 512) begin
                        if ((sector_no == 0) && (byte_index < 44)) begin
                            sd_data = 8'd0;
                        end else if ((sector_no == 0) && (((byte_index - 44) & 1) == 0)) begin
                            sd_data = (loop_no * 1000 + sample_index) & 8'hff;
                        end else if ((sector_no == 0)) begin
                            sd_data = ((loop_no * 1000 + sample_index) >> 8) & 8'hff;
                        end else if ((byte_index & 1) == 0) begin
                            sd_data = (loop_no * 1000 + sample_index) & 8'hff;
                        end else begin
                            sd_data = ((loop_no * 1000 + sample_index) >> 8) & 8'hff;
                        end
                    end else begin
                        sd_data = 8'd0;
                    end
                end
                @(posedge clk);
                @(negedge clk);
                sd_valid = 1'b0;
                repeat (actual_gap - 1) @(posedge clk);
            end
            @(negedge clk);
            sd_end = 1'b1;
            @(negedge clk);
            sd_end = 1'b0;
        end
    endtask

    task consume_expected_paced;
        input integer expected;
        input integer cadence;
        begin
            wait_count = 0;
            while (!sample_available && (wait_count < 200000)) begin
                @(negedge clk);
                wait_count = wait_count + 1;
            end
            if (!sample_available) begin
                $display("FAIL: paced sample timeout at index %0d", received);
                $fatal(1);
            end
            if (sample_data !== expected[15:0]) begin
                $display("FAIL: paced sample[%0d] expected=%04x got=%04x", received, expected[15:0], sample_data);
                $fatal(1);
            end
            @(negedge clk);
            sample_take = 1'b1;
            @(posedge clk);
            received = received + 1;
            @(negedge clk);
            sample_take = 1'b0;
            repeat (cadence - 1) @(posedge clk);
        end
    endtask

    task consume_expected;
        input integer expected;
        begin
            wait_count = 0;
            while (!sample_available && (wait_count < 2000)) begin
                @(negedge clk);
                wait_count = wait_count + 1;
            end
            if (!sample_available) begin
                $display("FAIL: sample timeout at index %0d", received);
                $fatal(1);
            end
            if (sample_data !== expected[15:0]) begin
                $display("FAIL: sample[%0d] expected=%04x got=%04x", received, expected[15:0], sample_data);
                $fatal(1);
            end
            @(negedge clk);
            sample_take = 1'b1;
            @(negedge clk);
            sample_take = 1'b0;
            received = received + 1;
        end
    endtask

    initial begin
        received = 0;
        concurrent_count = 0;
        push_count = 0;
        pop_count = 0;
        if ($test$plusargs("BAD_HEADER")) begin
            repeat (5) @(negedge clk);
            rst = 1'b0;
            sd_init_done = 1'b1;
            make_and_send_sector(0, 0, 1, 1);
            repeat (4) @(negedge clk);
            if (!error || sd_read || sample_available) begin
                $display("FAIL: malformed header did not halt silently");
                $fatal(1);
            end
            $display("PASS: malformed header halts with no samples");
            $finish;
        end else if ($test$plusargs("SLOW_SD")) begin
            repeat (5) @(negedge clk);
            rst = 1'b0;
            sd_init_done = 1'b1;
            fork
                begin : paced_producer
                    for (produced_loop = 0; produced_loop < 2; produced_loop = produced_loop + 1) begin
                        for (sector = 0; sector < 3; sector = sector + 1)
                            make_and_send_sector(produced_loop, sector, 0, 32);
                    end
                end
                begin : paced_checker
                    // Deliberately align the first consume with a new push.
                    while (!(dut.push_accept && sample_available)) begin
                        @(negedge clk);
                        #1;
                    end
                    if (sample_data !== 16'd0) begin
                        $display("FAIL: first simultaneous push/pop did not preserve FIFO head");
                        $fatal(1);
                    end
                    sample_take = 1'b1;
                    @(posedge clk);
                    received = 1;
                    @(negedge clk);
                    sample_take = 1'b0;
                    repeat (1040) @(posedge clk);
                    for (idx = 1; idx < 1024; idx = idx + 1)
                        consume_expected_paced((idx < 512) ? idx : (1000 + idx - 512),
                                               (received % 3 == 0) ? 1041 : 1042);
                    repeat (10) @(negedge clk);
                    if (error) begin
                        $display("FAIL: unexpected error with 32-clock SD byte gap and audio cadence");
                        $fatal(1);
                    end
                    if (concurrent_count == 0) begin
                        $display("FAIL: test did not exercise simultaneous FIFO push/pop (push=%0d pop=%0d)", push_count, pop_count);
                        $fatal(1);
                    end
                    $display("PASS: ~32-clock SD byte spacing, concurrent FIFO push/pop, and 1041/1042-clock sample takes");
                    $finish;
                end
            join
        end else begin
          repeat (5) @(negedge clk);
          rst = 1'b0;
          sd_init_done = 1'b1;

          // Good stream producer: two complete loops, each three sectors.
          fork
            begin : producer
                for (produced_loop = 0; produced_loop < 2; produced_loop = produced_loop + 1) begin
                    for (sector = 0; sector < 3; sector = sector + 1)
                        make_and_send_sector(produced_loop, sector, 0, 1);
                end
            end
            begin : check_stream
                // Let two sectors fill the FIFO to 490/512. This proves the
                // admission gate stops before a third 256-sample sector.
                wait (dut.fifo_count == 13'd490);
                if (!primed) begin
                    $display("FAIL: primed did not assert at half depth");
                    $fatal(1);
                end
                repeat (8) @(negedge clk);
                if (sd_read !== 1'b0) begin
                    $display("FAIL: reader started a sector without 256 free entries");
                    $fatal(1);
                end
                for (idx = 0; idx < 256; idx = idx + 1)
                    consume_expected(idx);
                // Remaining samples in this pass, then all 512 in loop 1.
                for (idx = 256; idx < 512; idx = idx + 1)
                    consume_expected(idx);
                for (idx = 512; idx < 1024; idx = idx + 1)
                    consume_expected(1000 + idx - 512);
                repeat (10) @(negedge clk);
                if (error) begin
                    $display("FAIL: unexpected error in good stream");
                    $fatal(1);
                end
                $display("PASS: continuous sectors, wrap loop, priming, and FIFO admission");
                $finish;
            end
          join
        end
    end

    // FIFO occupancy must never exceed its configured capacity.
    always @(posedge clk) begin
        if (!rst && dut.push_accept) push_count = push_count + 1;
        if (!rst && dut.fifo_pop) pop_count = pop_count + 1;
        if (!rst && dut.push_accept && dut.fifo_pop) concurrent_count = concurrent_count + 1;
        if (!rst && dut.fifo_count > 13'd512) begin
            $display("FAIL: FIFO overflow count=%0d", dut.fifo_count);
            $fatal(1);
        end
    end

endmodule
