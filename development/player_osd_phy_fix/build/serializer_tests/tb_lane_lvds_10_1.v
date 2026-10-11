`timescale 1ps/1ps
`ifdef CANDIDATE
`define AUDIT_LOAD_STROBE dut.S_load_en_2d
`define AUDIT_SAMPLE_STROBE dut.S_load_en_1d
`define AUDIT_WORD dut.S_pending_data
`else
`define AUDIT_LOAD_STROBE dut.S_load_en_2d
`define AUDIT_SAMPLE_STROBE dut.S_load_en_2d
`define AUDIT_WORD data_in
`endif
module EG_LOGIC_ODDR(input wire clk, input wire rst, input wire d1, input wire d0, output reg q);
    always @(posedge clk or posedge rst) begin
        if (rst) q <= 1'b0;
        else q <= d0;
    end
    always @(negedge clk or posedge rst) begin
        if (rst) q <= 1'b0;
        else q <= d1;
    end
endmodule

module tb_lane;
    reg pixel_clk = 0;
    reg serial_clk = 0;
    reg rst = 0;
    reg [9:0] data_in = 10'h155;
    wire serial_out;
    integer phase_ps = 0;
    integer skew_ps = 0;
    integer serial_phase_ps;
    integer pix_index = 0;
    integer update_index = 0;
    integer load_offset_ps;
    integer min_load_offset_ps = 40000;
    integer max_load_offset_ps = 0;
    integer load_count = 0;
    integer out_count = 0;
    integer started = 0;
    integer sequence_errors = 0;
    integer boundary_mismatches = 0;
    integer latest_load_index = -1;
    integer start_load_index = -1;
    integer expected_index;
    reg [9:0] load_words [0:255];
    reg [9:0] out_word = 0;
    integer bit_count = 0;

    lane_lvds_10_1 #(.DEVICE("EG")) dut(
        .I_pixel_clk(pixel_clk), .I_serial_clk(serial_clk), .I_rst(rst),
        .I_data_in(data_in), .O_serial_out(serial_out)
    );

    always #20000 pixel_clk = ~pixel_clk;

    initial begin
        if (!$value$plusargs("phase=%d", phase_ps)) phase_ps = 0;
        if (!$value$plusargs("skew=%d", skew_ps)) skew_ps = 0;
        serial_phase_ps = phase_ps;
        #(serial_phase_ps);
        forever begin
            serial_clk = 1;
            #4000 serial_clk = 0;
            #4000;
        end
    end

    always @(posedge pixel_clk) begin
        pix_index = pix_index + 1;
        fork
            begin
                #(skew_ps);
                data_in = pattern(pix_index);
                update_index = pix_index;
            end
        join_none
    end

    function [9:0] pattern(input integer n);
        reg [15:0] x;
        begin
            x = n * 16'h2d3b + 16'h1937;
            x = x ^ (x >> 5) ^ (x << 7);
            pattern = x[9:0];
        end
    endfunction

    initial begin
        #1 rst = 1;
        #4999 rst = 0;
        #4000000;
        $display("SUMMARY phase_ps=%0d skew_ps=%0d loads=%0d output_words=%0d seq_errors=%0d boundary_mismatches=%0d min_load_offset_ps=%0d max_load_offset_ps=%0d", phase_ps, skew_ps, load_count, out_count, sequence_errors, boundary_mismatches, min_load_offset_ps, max_load_offset_ps);
        $finish;
    end

    // Capture each full serialized 10-bit word from the actual ODDR output.
    always @(posedge serial_clk) begin
        if (!rst && `AUDIT_SAMPLE_STROBE) begin
            load_offset_ps = ($time - 20000) % 40000;
            if (load_offset_ps < min_load_offset_ps) min_load_offset_ps = load_offset_ps;
            if (load_offset_ps > max_load_offset_ps) max_load_offset_ps = load_offset_ps;
        end
        if (!rst && `AUDIT_LOAD_STROBE) begin
            if (load_count < 256) load_words[load_count] = `AUDIT_WORD;
            if (`AUDIT_WORD !== pattern(load_count + 1)) begin
                boundary_mismatches = boundary_mismatches + 1;
                if (boundary_mismatches <= 4)
                    $display("BOUNDARY_MISMATCH phase_ps=%0d skew_ps=%0d load_n=%0d got=%03x expected=%03x", phase_ps, skew_ps, load_count, `AUDIT_WORD, pattern(load_count + 1));
            end
            latest_load_index = load_count;
            load_count = load_count + 1;
        end
        #1;
        if (!rst) begin
            out_word = {out_word[8:0], serial_out};
            bit_count = bit_count + 1;
            if (bit_count == 10) begin
                bit_count = 0;
                out_count = out_count + 1;
                if (out_count > 4) begin
                    if (!started) begin
                        for (integer j=0; j<load_count; j=j+1) begin
                            if (load_words[j] === out_word && !started) begin
                                started = 1;
                                start_load_index = j;
                                $display("ALIGN phase_ps=%0d skew_ps=%0d output_word=%03x load_index=%0d", phase_ps, skew_ps, out_word, j);
                            end
                        end
                    end else begin
                        expected_index = start_load_index + out_count - 5;
                        if (expected_index >= 0 && expected_index < load_count && out_word !== load_words[expected_index]) begin
                            sequence_errors = sequence_errors + 1;
                            if (sequence_errors <= 8)
                                $display("WORD_MISMATCH phase_ps=%0d skew_ps=%0d out_n=%0d got=%03x expected=%03x load_index=%0d", phase_ps, skew_ps, out_count, out_word, load_words[expected_index], expected_index);
                        end
                    end
                end
            end
        end
    end

    always @(negedge serial_clk) begin
        #1;
        if (!rst) begin
            out_word = {out_word[8:0], serial_out};
            bit_count = bit_count + 1;
            if (bit_count == 10) begin
                bit_count = 0;
                out_count = out_count + 1;
                if (out_count > 4) begin
                    if (!started) begin
                        for (integer j=0; j<load_count; j=j+1) begin
                            if (load_words[j] === out_word && !started) begin
                                started = 1;
                                start_load_index = j;
                                $display("ALIGN phase_ps=%0d skew_ps=%0d output_word=%03x load_index=%0d", phase_ps, skew_ps, out_word, j);
                            end
                        end
                    end else begin
                        expected_index = start_load_index + out_count - 5;
                        if (expected_index >= 0 && expected_index < load_count && out_word !== load_words[expected_index]) begin
                            sequence_errors = sequence_errors + 1;
                            if (sequence_errors <= 8)
                                $display("WORD_MISMATCH phase_ps=%0d skew_ps=%0d out_n=%0d got=%03x expected=%03x load_index=%0d", phase_ps, skew_ps, out_count, out_word, load_words[expected_index], expected_index);
                        end
                    end
                end
            end
        end
    end

endmodule
