`timescale 1ns/1ps

module tb_status_hex595;
    reg clk = 1'b0;
    reg rst = 1'b1;
    reg [31:0] hex_value = 32'h01234567;
    wire seg7_dio;
    wire seg7_sclk;
    wire seg7_rclk;

    parameter [31:0] TEST_CLK_HZ = 25000000;
    localparam [31:0] TEST_SCAN_HZ = 1000;

    localparam real HALF_NS = 500000000.0 / TEST_CLK_HZ;
    always #(HALF_NS) clk = ~clk;

    status_hex595 #(.CLK_HZ(TEST_CLK_HZ), .SCAN_HZ(TEST_SCAN_HZ)) dut (
        .clk(clk), .rst(rst), .hex_value(hex_value),
        .seg7_dio(seg7_dio), .seg7_sclk(seg7_sclk), .seg7_rclk(seg7_rclk)
    );

    // Behavioral model of the physical two-chip chain:
    // every SHCP rising edge shifts one serial bit, and STCP rising copies
    // the completed 16-bit shift register to the output latch.
    reg [15:0] external_shift = 16'd0;
    reg [15:0] external_latch = 16'd0;
    integer shifted_bits = 0;
    integer latch_events = 0;
    integer active_events = 0;
    integer expected_digit = 0;
    integer need_blank = 1;
    integer frame_starts = 0;
    integer last_frame_time_ns = -1;
    integer frame_interval_ns = 0;
    reg [31:0] expected_input = 32'h01234567;
    reg [31:0] latched_frame = 32'h01234567;
    integer last_sclk_time_ns = -1;
    integer sclk_period_ns = 0;

    function [6:0] expected_decode;
        input [3:0] value;
        begin
            case (value)
                4'h0: expected_decode = 7'b1000000;
                4'h1: expected_decode = 7'b1111001;
                4'h2: expected_decode = 7'b0100100;
                4'h3: expected_decode = 7'b0110000;
                4'h4: expected_decode = 7'b0011001;
                4'h5: expected_decode = 7'b0010010;
                4'h6: expected_decode = 7'b0000010;
                4'h7: expected_decode = 7'b1111000;
                4'h8: expected_decode = 7'b0000000;
                4'h9: expected_decode = 7'b0010000;
                4'hA: expected_decode = 7'b0001000;
                4'hB: expected_decode = 7'b0000011;
                4'hC: expected_decode = 7'b1000110;
                4'hD: expected_decode = 7'b0100001;
                4'hE: expected_decode = 7'b0000110;
                4'hF: expected_decode = 7'b0001110;
                default: expected_decode = 7'b1111111;
            endcase
        end
    endfunction

    function [3:0] expected_nibble;
        input [31:0] value;
        input integer index;
        begin
            expected_nibble = (value >> (index * 4)) & 4'hF;
        end
    endfunction

    always @(posedge seg7_sclk) begin
        if (!rst) begin
            external_shift = {external_shift[14:0], seg7_dio};
            shifted_bits = shifted_bits + 1;
            if (shifted_bits > 16)
                $fatal(1, "more than 16 SCLK rising edges before latch");
            if (last_sclk_time_ns >= 0) begin
                sclk_period_ns = $time - last_sclk_time_ns;
                if (sclk_period_ns < 1000)
                    $fatal(1, "SCLK exceeds 1 MHz: rising-edge period %0d ns", sclk_period_ns);
            end
            last_sclk_time_ns = $time;
        end
    end

    always @(posedge seg7_rclk) begin
        if (!rst) begin
            if (seg7_sclk !== 1'b0)
                $fatal(1, "RCLK asserted while SCLK is high");
            if (shifted_bits != 16)
                $fatal(1, "RCLK latch after %0d bits, expected exactly 16", shifted_bits);

            external_latch = external_shift;
            latch_events = latch_events + 1;
            shifted_bits = 0;
            external_shift = 16'd0;

            if (need_blank) begin
                if (external_latch !== 16'hFF00)
                    $fatal(1, "digit %0d blank word was %04h, expected FF00",
                           expected_digit, external_latch);
                if (external_latch[7:0] !== 8'h00)
                    $fatal(1, "digit select was not blank during segment update");
                if (expected_digit == 0)
                    latched_frame = expected_input;
                need_blank = 0;
            end else begin
                if (external_latch[7:0] !== (8'b00000001 << expected_digit))
                    $fatal(1, "digit %0d select was %02h, expected onehot %02h",
                           expected_digit, external_latch[7:0],
                           (8'b00000001 << expected_digit));
                if ((external_latch[15:8] !==
                     {1'b1, expected_decode(expected_nibble(latched_frame, expected_digit))}))
                    $fatal(1, "digit %0d segment byte %02h did not match nibble %h of %08h",
                           expected_digit, external_latch[15:8],
                           expected_nibble(latched_frame, expected_digit), latched_frame);

                active_events = active_events + 1;
                if (expected_digit == 0) begin
                    if (last_frame_time_ns >= 0) begin
                        frame_interval_ns = $time - last_frame_time_ns;
                        if (frame_interval_ns > 10000000)
                            $fatal(1, "full-frame refresh slower than 100 Hz: %0d ns",
                                   frame_interval_ns);
                    end
                    last_frame_time_ns = $time;
                    frame_starts = frame_starts + 1;
                end

                expected_digit = (expected_digit == 7) ? 0 : expected_digit + 1;
                need_blank = 1;
            end
        end
    end

    initial begin : test_sequence
        fork : watchdog
            begin
                #100000000;
                $fatal(1, "watchdog: did not complete both 8-digit patterns");
            end
            begin
                repeat (4) @(negedge clk);
                rst = 1'b0;

                // The external model independently checks all 8 active words
                // and the blank-before-data sequence for 01234567.
                wait (active_events >= 24);
                @(negedge clk);
                hex_value = 32'h89ABCDEF;
                expected_input = 32'h89ABCDEF;

                // The next complete frame must show 89ABCDEF, including A-F.
                wait (active_events >= 64);
                @(negedge clk);
                if (latch_events < 128)
                    $fatal(1, "expected at least 128 16-bit latch transactions");
                if (frame_starts < 3 || frame_interval_ns == 0)
                    $fatal(1, "insufficient full-frame refresh observations");
                if (sclk_period_ns < 1000)
                    $fatal(1, "no measurable SCLK period");

                $display("PASS: external 595 model checked %0d latches, %0d active digits; SCLK=%0.3f MHz, frame=%0.3f Hz",
                         latch_events, active_events,
                         1000.0 / sclk_period_ns,
                         1000000000.0 / frame_interval_ns);
                $finish;
            end
        join_any
        disable watchdog;
    end
endmodule

