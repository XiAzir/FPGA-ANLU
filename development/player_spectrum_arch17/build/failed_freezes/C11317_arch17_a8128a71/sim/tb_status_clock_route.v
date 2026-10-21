`timescale 1ns/1ps

// End-to-end digital check of the production status mailbox and 595 driver.
// All observations are made at destination_hex and the three serial output
// pins. No implementation registers are forced or read hierarchically.
module tb_status_clock_route;
    reg destination_clk = 1'b0;
    wire [4:0] done;

    always #10 destination_clk = ~destination_clk; // 50 MHz, 20 ns period

    status_clock_route_case #(.PHASE_NS(0))  c0(destination_clk, done[0]);
    status_clock_route_case #(.PHASE_NS(5))  c1(destination_clk, done[1]);
    status_clock_route_case #(.PHASE_NS(10)) c2(destination_clk, done[2]);
    status_clock_route_case #(.PHASE_NS(15)) c3(destination_clk, done[3]);
    status_clock_route_case #(.PHASE_NS(19)) c4(destination_clk, done[4]);

    initial begin
        wait (&done);
        $display("PASS status clock route: 5 source/destination phases, real 25/50 MHz and 1 kHz scan");
        $display("PASS serial 16-bit setup/latch order, atomic snapshots, source pause, reset/restart");
        $finish;
    end

    initial begin
        #200000000;
        $fatal(1, "global timeout waiting for phase cases: done=%b", done);
    end
endmodule

module status_clock_route_case #(parameter integer PHASE_NS = 0)(
    input wire destination_clk,
    output reg done = 1'b0
);
    reg source_clk = 1'b0;
    reg source_run = 1'b1;
    reg rst = 1'b1;
    reg [31:0] source_hex = 32'd0;
    wire [31:0] destination_hex;
    wire seg7_dio, seg7_sclk, seg7_rclk;

    player_status_mailbox mailbox_dut (
        .source_clk(source_clk),
        .destination_clk(destination_clk),
        .rst(rst),
        .source_hex(source_hex),
        .destination_hex(destination_hex)
    );

    status_hex595 #(.CLK_HZ(50000000), .SCAN_HZ(1000)) display_dut (
        .clk(destination_clk),
        .rst(rst),
        .hex_value(destination_hex),
        .seg7_dio(seg7_dio),
        .seg7_sclk(seg7_sclk),
        .seg7_rclk(seg7_rclk)
    );

    // 25 MHz source clock; PHASE_NS sweeps its phase against the 50 MHz clock.
    initial begin
        source_clk = 1'b0;
        #(PHASE_NS);
        forever begin
            #20;
            if (source_run)
                source_clk = ~source_clk;
            else
                source_clk = 1'b0;
        end
    end

    reg [31:0] allowed [0:511];
    integer allowed_count = 0;
    reg [31:0] last_destination = 32'hxxxxxxxx;
    reg [31:0] rx_word = 16'd0;
    reg [31:0] frame_nibbles = 32'd0;
    reg [31:0] last_frame = 32'hxxxxxxxx;
    reg [7:0] frame_mask = 8'd0;
    integer bits_in_word = 0;
    integer next_digit = 0;
    integer digit_zero_count = 0;
    integer frame_count = 0;
    integer latched_words = 0;
    integer churn_updates = 0;
    integer churn_index = 0;
    reg churn_mode = 1'b0;
    time last_dio_change = 0;
    time last_sclk_rise = 0;
    integer base_frame_count;
    integer paused_frame_count;
    integer base_digit_zero_count;

    always @(negedge source_clk) begin
        if (churn_mode && !rst) begin
            case (churn_index % 3)
                0: source_hex = 32'hAAAAAAAA;
                1: source_hex = 32'h55555555;
                default: source_hex = 32'h00000000;
            endcase
            churn_index = churn_index + 1;
            churn_updates = churn_updates + 1;
        end
    end

    task add_allowed(input [31:0] value);
        begin
            if (allowed_count >= 512)
                $fatal(1, "phase %0d allowed-value table overflow", PHASE_NS);
            allowed[allowed_count] = value;
            allowed_count = allowed_count + 1;
        end
    endtask

    function is_allowed(input [31:0] value);
        integer n;
        begin
            is_allowed = 1'b0;
            for (n = 0; n < allowed_count; n = n + 1)
                if (allowed[n] === value)
                    is_allowed = 1'b1;
        end
    endfunction

    function [3:0] decode_segments(input [6:0] segments);
        begin
            case (segments)
                7'b1000000: decode_segments = 4'h0;
                7'b1111001: decode_segments = 4'h1;
                7'b0100100: decode_segments = 4'h2;
                7'b0110000: decode_segments = 4'h3;
                7'b0011001: decode_segments = 4'h4;
                7'b0010010: decode_segments = 4'h5;
                7'b0000010: decode_segments = 4'h6;
                7'b1111000: decode_segments = 4'h7;
                7'b0000000: decode_segments = 4'h8;
                7'b0010000: decode_segments = 4'h9;
                7'b0001000: decode_segments = 4'hA;
                7'b0000011: decode_segments = 4'hB;
                7'b1000110: decode_segments = 4'hC;
                7'b0100001: decode_segments = 4'hD;
                7'b0000110: decode_segments = 4'hE;
                7'b0001110: decode_segments = 4'hF;
                default: begin
                    $fatal(1, "phase %0d invalid active-low segment code %b", PHASE_NS, segments);
                    decode_segments = 4'hX;
                end
            endcase
        end
    endfunction

    task set_source(input [31:0] value);
        begin
            @(negedge source_clk);
            source_hex = value;
            add_allowed(value);
        end
    endtask

    task wait_destination(input [31:0] value);
        time started;
        begin
            started = $time;
            while (destination_hex !== value) begin
                @(posedge destination_clk);
                #1;
                if (($time - started) > 20000)
                    $fatal(1, "phase %0d mailbox timeout wanted=%08h got=%08h", PHASE_NS, value, destination_hex);
            end
        end
    endtask

    task wait_frame(input [31:0] value);
        time started;
        begin
            started = $time;
            while (!(frame_count > base_frame_count && last_frame === value)) begin
                @(posedge destination_clk);
                #1;
                if (($time - started) > 25000000)
                    $fatal(1, "phase %0d display timeout wanted=%08h got=%08h frames=%0d", PHASE_NS, value, last_frame, frame_count);
            end
            base_frame_count = frame_count;
        end
    endtask

    always @(posedge rst) begin
        rx_word = 16'd0;
        frame_nibbles = 32'd0;
        frame_mask = 8'd0;
        bits_in_word = 0;
        next_digit = 0;
        last_sclk_rise = 0;
    end

    // Observe and reconstruct the serial 595 stream only at the module pins.
    always @(seg7_dio) begin
        if (!rst) begin
            if (seg7_sclk !== 1'b0)
                $fatal(1, "phase %0d DIO changed while SCLK was high", PHASE_NS);
            last_dio_change = $time;
        end
    end

    always @(posedge seg7_sclk) begin
        if (!rst) begin
            if (($time - last_dio_change) < 20)
                $fatal(1, "phase %0d DIO setup below one 50 MHz cycle", PHASE_NS);
            if (bits_in_word > 0 && (($time - last_sclk_rise) != 1020))
                $fatal(1, "phase %0d serial bit period mismatch: %0t ns (expected 1020 ns)", PHASE_NS, ($time - last_sclk_rise));
            rx_word = {rx_word[14:0], seg7_dio};
            bits_in_word = bits_in_word + 1;
            if (bits_in_word > 16)
                $fatal(1, "phase %0d more than 16 bits before latch", PHASE_NS);
            last_sclk_rise = $time;
        end
    end

    always @(posedge seg7_rclk) begin : serial_latch_checker
        integer selected_digit;
        reg [7:0] expected_select;
        reg [7:0] next_mask;
        reg [3:0] nibble;
        if (!rst) begin
            if (seg7_sclk !== 1'b0)
                $fatal(1, "phase %0d RCLK rose while SCLK was high", PHASE_NS);
            if (bits_in_word != 16)
                $fatal(1, "phase %0d RCLK latch after %0d bits", PHASE_NS, bits_in_word);
            bits_in_word = 0;
            latched_words = latched_words + 1;
            if (rx_word === 16'hFF00) begin
                // The driver's explicit blank transfer is expected before each digit.
            end else begin
                if (rx_word[15] !== 1'b1)
                    $fatal(1, "phase %0d unexpected decimal-point bit in %04h", PHASE_NS, rx_word[15:0]);
                if (rx_word[7:0] == 0 || ((rx_word[7:0] & (rx_word[7:0] - 1'b1)) != 0))
                    $fatal(1, "phase %0d non-one-hot digit select in %04h", PHASE_NS, rx_word[15:0]);
                selected_digit = 0;
                while (selected_digit < 8 && rx_word[7:0] != (8'b1 << selected_digit))
                    selected_digit = selected_digit + 1;
                if (selected_digit >= 8)
                    $fatal(1, "phase %0d digit select outside 8 digits: %02h", PHASE_NS, rx_word[7:0]);
                if (selected_digit != next_digit)
                    $fatal(1, "phase %0d digit order mismatch expected=%0d got=%0d", PHASE_NS, next_digit, selected_digit);
                next_digit = (selected_digit + 1) % 8;
                if (selected_digit == 0)
                    digit_zero_count = digit_zero_count + 1;
                nibble = decode_segments(rx_word[14:8]);
                if (selected_digit == 0) begin
                    frame_mask = 0;
                    frame_nibbles = 0;
                end
                frame_nibbles[4*selected_digit +: 4] = nibble;
                next_mask = frame_mask | (8'b1 << selected_digit);
                frame_mask = next_mask;
                if (frame_mask == 8'hFF) begin
                    last_frame = frame_nibbles;
                    frame_count = frame_count + 1;
                    if (!is_allowed(last_frame))
                        $fatal(1, "phase %0d torn/unknown displayed snapshot %08h", PHASE_NS, last_frame);
                end
            end
        end
    end

    always @(posedge destination_clk) begin
        #1;
        if (!rst && destination_hex !== last_destination) begin
            if (!is_allowed(destination_hex))
                $fatal(1, "phase %0d torn mailbox bundle %08h", PHASE_NS, destination_hex);
            last_destination = destination_hex;
        end
        if (!rst && !source_run && destination_hex !== 32'hA5C39E61)
            $fatal(1, "phase %0d destination changed with source clock paused: %08h", PHASE_NS, destination_hex);
    end

    initial begin
        add_allowed(32'h00000000);
        base_frame_count = 0;
        #200;
        rst = 1'b0;

        set_source(32'h01234567);
        wait_destination(32'h01234567);
        wait_frame(32'h01234567);

        set_source(32'h88888888);
        wait_destination(32'h88888888);
        wait_frame(32'h88888888);

        set_source(32'hDFC11309);
        wait_destination(32'hDFC11309);
        wait_frame(32'hDFC11309);

        set_source(32'hE4000000);
        wait_destination(32'hE4000000);
        wait_frame(32'hE4000000);

        set_source(32'hF0000000);
        wait_destination(32'hF0000000);
        wait_frame(32'hF0000000);

        set_source(32'hF1000010);
        wait_destination(32'hF1000010);
        wait_frame(32'hF1000010);

        // Churn the source throughout a live display frame. Per-digit sampling
        // of the mailbox would form a mixed pattern and fail full-frame decode.
        add_allowed(32'hAAAAAAAA);
        add_allowed(32'h55555555);
        add_allowed(32'h00000000);
        base_digit_zero_count = digit_zero_count;
        while (digit_zero_count == base_digit_zero_count)
            @(posedge destination_clk);
        churn_mode = 1'b1;
        #7000000;
        churn_mode = 1'b0;
        if (churn_updates < 100000)
            $fatal(1, "phase %0d source churn too short: %0d updates", PHASE_NS, churn_updates);
        set_source(32'hA5C39E61);
        wait_destination(32'hA5C39E61);
        repeat (5) @(posedge source_clk);
        @(negedge source_clk);
        source_run = 1'b0;
        paused_frame_count = frame_count;
        wait_frame(32'hA5C39E61);
        wait_frame(32'hA5C39E61);
        if (frame_count < paused_frame_count + 2)
            $fatal(1, "phase %0d 595 did not keep scanning while source clock paused", PHASE_NS);
        if (latched_words < 16)
            $fatal(1, "phase %0d too few externally observed latch words", PHASE_NS);

        // Asynchronous reset clears both mailbox endpoints and restarts scanning.
        rst = 1'b1;
        #100;
        if (destination_hex !== 32'd0)
            $fatal(1, "phase %0d reset did not clear destination_hex: %08h", PHASE_NS, destination_hex);
        if (seg7_sclk !== 1'b0 || seg7_rclk !== 1'b0 || seg7_dio !== 1'b1)
            $fatal(1, "phase %0d display pins not in reset state", PHASE_NS);
        rst = 1'b0;
        source_run = 1'b1;
        set_source(32'h01234567);
        wait_destination(32'h01234567);
        wait_frame(32'h01234567);

        $display("PASS phase=%0d ns: pages, atomic rapid updates, 595 scan during source pause, reset/restart; observed %0d latches", PHASE_NS, latched_words);
        done = 1'b1;
    end
endmodule
