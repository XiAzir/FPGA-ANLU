`timescale 1ns/1ps
// Reconnect the established parallel-word packet monitor to the recovered
// physical HDMI pins. symbol_valid acts as a one-event-per-TMDS-word clock.
module hdmi_serial_packet_monitor #(
    parameter integer CLK_HZ = 25000000,
    parameter [23:0] TONE_AMP = 24'd1000000,
    parameter [9:0] CLOCK_WORD = 10'b1111100000
)(
    input wire serial_clk, input wire pixel_clk, input wire rst,
    input wire tmds_clk, input wire tmds_d0, input wire tmds_d1, input wire tmds_d2,
    input wire tone_mode,
    output wire alignment_locked,
    output wire [31:0] malformed_words,
    output wire [23:0] audio_samples_sec, output wire [23:0] audio_packets_sec,
    output wire [23:0] bad_bch_sec, output wire [23:0] bad_terc_sec,
    output wire [23:0] tone_bad_sec,
    output wire [19:0] acr_cts_last, output wire [19:0] acr_n_last,
    output wire [3:0] probe_flags
);
    wire symbol_valid;
    reg event_clk = 1'b0;
    wire monitor_clk = event_clk | rst;
    wire [9:0] ch0,ch1,ch2,chclk;

    hdmi_serial_receiver #(.CLOCK_WORD(CLOCK_WORD)) receiver (
        .serial_clk(serial_clk), .pixel_clk(pixel_clk), .rst(rst),
        .tmds_clk(tmds_clk), .tmds_d0(tmds_d0), .tmds_d1(tmds_d1), .tmds_d2(tmds_d2),
        .symbol_valid(symbol_valid), .ch0(ch0), .ch1(ch1), .ch2(ch2), .chclk(chclk),
        .alignment_locked(alignment_locked), .malformed_words(malformed_words)
    );

    // The event follows the receiver's blocking word updates, so the monitor
    // observes a complete recovered 10-bit triple on each posedge.
    always @(posedge symbol_valid) begin
        if (!rst) begin
            #0.001 event_clk=1'b1;
            #0.001 event_clk=1'b0;
        end
    end

    hdmi_packet_monitor #(.CLK_HZ(CLK_HZ), .TONE_AMP(TONE_AMP)) packet_monitor (
        .clk(monitor_clk), .rst(rst), .tone_mode(tone_mode),
        .ch0(ch0), .ch1(ch1), .ch2(ch2),
        .audio_samples_sec(audio_samples_sec), .audio_packets_sec(audio_packets_sec),
        .bad_bch_sec(bad_bch_sec), .bad_terc_sec(bad_terc_sec), .tone_bad_sec(tone_bad_sec),
        .acr_cts_last(acr_cts_last), .acr_n_last(acr_n_last), .probe_flags(probe_flags)
    );

    // Prevent unused-clock optimization warnings while keeping the recovered
    // word/event clocks independent from the testbench's pixel clock.
    wire unused_pixel_clk = pixel_clk;
    wire unused_chclk = ^chclk;
endmodule
