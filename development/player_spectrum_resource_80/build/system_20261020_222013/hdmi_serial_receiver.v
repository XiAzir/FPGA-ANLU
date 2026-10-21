`timescale 1ns/1ps
// Reconstruct 10-bit TMDS words by sampling the four physical serial outputs.
// The clock lane's repeated 1111100000 character establishes the word phase.
module hdmi_serial_receiver #(parameter [9:0] CLOCK_WORD = 10'b1111100000) (
    input  wire       serial_clk,
    input  wire       pixel_clk,
    input  wire       rst,
    input  wire       tmds_clk,
    input  wire       tmds_d0,
    input  wire       tmds_d1,
    input  wire       tmds_d2,
    output reg        symbol_valid,
    output reg [9:0]  ch0,
    output reg [9:0]  ch1,
    output reg [9:0]  ch2,
    output reg [9:0]  chclk,
    output reg        alignment_locked,
    output reg [31:0] malformed_words
);


    reg [9:0] hist_clk, hist0, hist1, hist2;
    reg [3:0] phase;
    reg [3:0] warmup;

    // Called after either serial edge. Blocking assignments preserve a single
    // chronological sample stream; #1ps in the edge handlers avoids ODDR delta races.
    task sample_edge;
        input sclk, s0, s1, s2;
        begin
            symbol_valid = 1'b0;
            hist_clk = {sclk, hist_clk[9:1]};
            hist0    = {s0,    hist0[9:1]};
            hist1    = {s1,    hist1[9:1]};
            hist2    = {s2,    hist2[9:1]};
            if (warmup < 10)
                warmup = warmup + 1'b1;

            if (!alignment_locked) begin
                if ((warmup >= 9) && (hist_clk == CLOCK_WORD)) begin
                    alignment_locked = 1'b1;
                    phase = 0;
                    chclk = hist_clk;
                    ch0 = hist0;
                    ch1 = hist1;
                    ch2 = hist2;
                    symbol_valid = 1'b1;
                end
            end else if (phase == 9) begin
                phase = 0;
                chclk = hist_clk;
                ch0 = hist0;
                ch1 = hist1;
                ch2 = hist2;
                symbol_valid = 1'b1;
                if (hist_clk != CLOCK_WORD)
                    malformed_words = malformed_words + 1;
            end else begin
                phase = phase + 1'b1;
            end
        end
    endtask

    always @(posedge serial_clk) begin
        if (rst) begin
            hist_clk = 0; hist0 = 0; hist1 = 0; hist2 = 0;
            phase = 0; warmup = 0;
            symbol_valid = 0; alignment_locked = 0;
            malformed_words = 0;
            chclk = 0; ch0 = 0; ch1 = 0; ch2 = 0;
        end else begin
            #0.001;
            sample_edge(tmds_clk, tmds_d0, tmds_d1, tmds_d2);
        end
    end

    always @(negedge serial_clk) begin
        if (!rst) begin
            #0.001;
            sample_edge(tmds_clk, tmds_d0, tmds_d1, tmds_d2);
        end
    end

    // pixel_clk is part of the testbench-facing interface for convenient
    // binding, but word recovery intentionally uses only the sampled serial pins.
    wire unused_pixel_clk = pixel_clk;
endmodule
