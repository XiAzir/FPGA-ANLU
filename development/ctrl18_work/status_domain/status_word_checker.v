`timescale 1ns/1ps

// Receives the real DIO/SCLK/RCLK pins, reconstructs each 16-bit latch word,
// and checks the blank/data pair and eight-digit frame against the input value
// sampled at the digit-zero slot boundary.
module status_word_checker #(
    parameter integer ID = 0
)(
    input wire clk,
    input wire rst,
    input wire dio,
    input wire sclk,
    input wire rclk,
    input wire [31:0] hex_value,
    input wire frame_start,
    output integer frame_count,
    output integer digit3_events,
    output reg [31:0] frame_value_0,
    output reg [31:0] frame_value_1,
    output reg [31:0] last_frame_value,
    output integer min_high_ns,
    output integer max_high_ns,
    output integer min_low_ns,
    output integer max_low_ns,
    output integer min_setup_ns,
    output integer max_rise_period_ns,
    output integer min_rise_period_ns,
    output integer min_rclk_high_ns,
    output integer max_rclk_high_ns,
    output integer min_blank_data_ns,
    output integer max_blank_data_ns,
    output integer min_blank_slot_ns,
    output integer max_blank_slot_ns,
    output integer min_frame_period_ns,
    output integer max_frame_period_ns
);
    reg [31:0] pending_frame;
    reg pending_valid;
    reg [31:0] expected_frame;
    reg expect_blank;
    integer digit_position;
    reg [15:0] rx_shift;
    integer rx_bits;

    time last_rise_time;
    time last_fall_time;
    time last_dio_change_time;
    time last_rclk_rise_time;
    time last_blank_time;
    time last_frame_done_time;
    reg have_rise;
    reg have_fall;
    reg have_dio_change;
    reg have_rclk_rise;
    reg have_blank;
    reg have_frame_done;
    reg measured_frame_period;

    integer measured;
    reg [3:0] nibble;
    reg [15:0] wanted_word;

    function [6:0] decode_hex;
        input [3:0] value;
        begin
            case (value)
                4'h0: decode_hex = 7'b1000000;
                4'h1: decode_hex = 7'b1111001;
                4'h2: decode_hex = 7'b0100100;
                4'h3: decode_hex = 7'b0110000;
                4'h4: decode_hex = 7'b0011001;
                4'h5: decode_hex = 7'b0010010;
                4'h6: decode_hex = 7'b0000010;
                4'h7: decode_hex = 7'b1111000;
                4'h8: decode_hex = 7'b0000000;
                4'h9: decode_hex = 7'b0010000;
                4'hA: decode_hex = 7'b0001000;
                4'hB: decode_hex = 7'b0000011;
                4'hC: decode_hex = 7'b1000110;
                4'hD: decode_hex = 7'b0100001;
                4'hE: decode_hex = 7'b0000110;
                4'hF: decode_hex = 7'b0001110;
                default: decode_hex = 7'b1111111;
            endcase
        end
    endfunction

    function [15:0] display_word;
        input [31:0] value;
        input integer index;
        reg [3:0] d;
        begin
            d = (value >> (index * 4)) & 4'hF;
            display_word = {1'b1, decode_hex(d), (8'b00000001 << index)};
        end
    endfunction

    initial begin
        frame_count = 0;
        digit3_events = 0;
        frame_value_0 = 0;
        frame_value_1 = 0;
        last_frame_value = 0;
        pending_frame = 0;
        pending_valid = 0;
        expected_frame = 0;
        expect_blank = 1;
        digit_position = 0;
        rx_shift = 0;
        rx_bits = 0;
        have_rise = 0;
        have_fall = 0;
        have_dio_change = 0;
        have_rclk_rise = 0;
        have_blank = 0;
        have_frame_done = 0;
        measured_frame_period = 0;
        min_high_ns = 2147483647;
        max_high_ns = 0;
        min_low_ns = 2147483647;
        max_low_ns = 0;
        min_setup_ns = 2147483647;
        min_rise_period_ns = 2147483647;
        max_rise_period_ns = 0;
        min_rclk_high_ns = 2147483647;
        max_rclk_high_ns = 0;
        min_blank_data_ns = 2147483647;
        max_blank_data_ns = 0;
        min_blank_slot_ns = 2147483647;
        max_blank_slot_ns = 0;
        min_frame_period_ns = 2147483647;
        max_frame_period_ns = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pending_frame = 0;
            pending_valid = 0;
        end else if (frame_start === 1'b1) begin
            pending_frame = hex_value;
            pending_valid = 1;
        end
    end

    always @(dio or posedge rst) begin
        if (rst) begin
            have_dio_change = 0;
        end else begin
            last_dio_change_time = $time;
            have_dio_change = 1;
        end
    end

    always @(posedge sclk or posedge rst) begin
        if (rst) begin
            rx_shift = 0;
            rx_bits = 0;
            have_rise = 0;
            have_fall = 0;
        end else begin
            if (have_fall && rx_bits > 0) begin
                measured = $time - last_fall_time;
                if (measured < 10000) begin
                    if (measured < min_low_ns) min_low_ns = measured;
                    if (measured > max_low_ns) max_low_ns = measured;
                end
            end
            if (have_rise && rx_bits > 0) begin
                measured = $time - last_rise_time;
                if (measured < 10000) begin
                    if (measured < min_rise_period_ns) min_rise_period_ns = measured;
                    if (measured > max_rise_period_ns) max_rise_period_ns = measured;
                end
            end
            if (have_dio_change) begin
                measured = $time - last_dio_change_time;
                if (measured < min_setup_ns) min_setup_ns = measured;
            end
            last_rise_time = $time;
            have_rise = 1;
            rx_shift = {rx_shift[14:0], dio};
            rx_bits = rx_bits + 1;
        end
    end

    always @(negedge sclk or posedge rst) begin
        if (rst) begin
            have_fall = 0;
        end else begin
            if (have_rise) begin
                measured = $time - last_rise_time;
                if (measured < min_high_ns) min_high_ns = measured;
                if (measured > max_high_ns) max_high_ns = measured;
            end
            last_fall_time = $time;
            have_fall = 1;
        end
    end

    always @(posedge rclk or posedge rst) begin
        if (rst) begin
            rx_shift = 0;
            rx_bits = 0;
            expect_blank = 1;
            digit_position = 0;
            expected_frame = 0;
            have_blank = 0;
            have_rclk_rise = 0;
            have_frame_done = 0;
        end else begin
            if (rx_bits != 16)
                $fatal(1, "ID%0d RCLK arrived after %0d serial bits at %0t ns", ID, rx_bits, $time);
            rx_bits = 0;
            if (expect_blank) begin
                if (rx_shift !== 16'hFF00)
                    $fatal(1, "ID%0d blank word[%0d] got %04h at %0t ns", ID, digit_position, rx_shift, $time);
                if (digit_position == 0) begin
                    if (!pending_valid)
                        $fatal(1, "ID%0d digit-zero frame start was not captured", ID);
                    expected_frame = pending_frame;
                    pending_valid = 0;
                end
                if (have_blank) begin
                    measured = $time - last_blank_time;
                    if (measured < min_blank_slot_ns) min_blank_slot_ns = measured;
                    if (measured > max_blank_slot_ns) max_blank_slot_ns = measured;
                end
                last_blank_time = $time;
                have_blank = 1;
                expect_blank = 0;
            end else begin
                wanted_word = display_word(expected_frame, digit_position);
                if (rx_shift !== wanted_word)
                    $fatal(1, "ID%0d data word[%0d] got %04h expected %04h frame=%08h at %0t ns", ID, digit_position, rx_shift, wanted_word, expected_frame, $time);
                measured = $time - last_blank_time;
                if (measured < min_blank_data_ns) min_blank_data_ns = measured;
                if (measured > max_blank_data_ns) max_blank_data_ns = measured;
                if (digit_position == 3) digit3_events = digit3_events + 1;
                expect_blank = 1;
                if (digit_position == 7) begin
                    last_frame_value = expected_frame;
                    if (frame_count == 0) frame_value_0 = expected_frame;
                    if (frame_count == 1) frame_value_1 = expected_frame;
                    if (have_frame_done) begin
                        measured = $time - last_frame_done_time;
                        if (!measured_frame_period) begin
                            min_frame_period_ns = measured;
                            max_frame_period_ns = measured;
                            measured_frame_period = 1;
                        end else begin
                            if (measured < min_frame_period_ns) min_frame_period_ns = measured;
                            if (measured > max_frame_period_ns) max_frame_period_ns = measured;
                        end
                    end else if (!measured_frame_period) begin
                        min_frame_period_ns = 0;
                        max_frame_period_ns = 0;
                    end
                    last_frame_done_time = $time;
                    have_frame_done = 1;
                    frame_count = frame_count + 1;
                    $display("FRAME id=%0d index=%0d value=%08h time=%0t ns", ID, frame_count - 1, expected_frame, $time);
                    digit_position = 0;
                end else begin
                    digit_position = digit_position + 1;
                end
            end
            rx_shift = 0;
            last_rclk_rise_time = $time;
            have_rclk_rise = 1;
        end
    end

    always @(negedge rclk or posedge rst) begin
        if (rst) begin
            have_rclk_rise = 0;
        end else begin
            if (have_rclk_rise) begin
                measured = $time - last_rclk_rise_time;
                if (measured < min_rclk_high_ns) min_rclk_high_ns = measured;
                if (measured > max_rclk_high_ns) max_rclk_high_ns = measured;
            end
        end
    end

    task report;
        begin
            $display("METRIC id=%0d sclk_high_ns=%0d..%0d sclk_low_ns=%0d..%0d rise_period_ns=%0d..%0d dio_setup_min_ns=%0d rclk_high_ns=%0d..%0d blank_to_data_ns=%0d..%0d blank_to_blank_slot_ns=%0d..%0d frame_period_ns=%0d..%0d frames=%0d",
                ID, min_high_ns, max_high_ns, min_low_ns, max_low_ns,
                min_rise_period_ns, max_rise_period_ns, min_setup_ns,
                min_rclk_high_ns, max_rclk_high_ns,
                min_blank_data_ns, max_blank_data_ns,
                min_blank_slot_ns, max_blank_slot_ns,
                min_frame_period_ns, max_frame_period_ns, frame_count);
        end
    endtask
endmodule
