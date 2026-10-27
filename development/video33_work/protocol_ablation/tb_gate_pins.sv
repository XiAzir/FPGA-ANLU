`timescale 1ns/1ps
module tb_gate_pins;
    parameter integer MAX_WORDS = 20000;
    reg clk = 0;
    always #10 clk = ~clk;
    reg rst_n = 0;
    wire [3:0] led;
    wire clock_pin, pin0, pin1, pin2;
    wire dio, sclk, rclk;
    hdmi_diag_gate dut(.clk(clk), .rst_n(rst_n), .led(led),
            .seg7_dio(dio), .seg7_sclk(sclk), .seg7_rclk(rclk),
            .HDMI_CLK_P(clock_pin), .HDMI_D0_P(pin0),
            .HDMI_D1_P(pin1), .HDMI_D2_P(pin2));

    wire serial_clock = dut.\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ;
    reg [9:0] clock_shift = 0;
    reg [9:0] lane0 = 0, lane1 = 0, lane2 = 0;
    integer words = 0, unknown_after_lock = 0, locked_words = 0;
    integer stream;
    integer source_pixels = 0, source_sofs = 0, encoder_pixels = 0;
    reg [4095:0] out_path;

    always @(posedge dut.pixel_clk) begin
        if (rst_n) begin
            if (dut.\u_hdmi_core/I_axis_s_valid  === 1'b1)
                source_pixels = source_pixels + 1;
            if (dut.\u_hdmi_core/I_axis_s_user  === 1'b1)
                source_sofs = source_sofs + 1;
            if (dut.\u_hdmi_core/u_hdmi_tx_controller_wrapper/S_video_valid  === 1'b1)
                encoder_pixels = encoder_pixels + 1;
        end
    end

    initial begin
        if (!$value$plusargs("OUT=%s",out_path)) $fatal(1,"OUT argument required");
        stream = $fopen(out_path,"w");
        if (!stream) $fatal(1,"Cannot open word stream");
        // Accelerate only the diagnostic's 30ms startup timer. Core, PLL,
        // serializer, IO pads and their resets use the original netlist.
        force dut.startup_count = 20'd999999;
        #2000 rst_n = 1;
        #(MAX_WORDS*50+200000);
        $display("GATE_PIN_TIMEOUT words=%0d locked=%0d led=%b startup=%b",words,locked_words,led,dut.startup_done);
        $fatal(1,"Clock alignment or word-count deadline not reached");
    end

    always @(posedge serial_clock or negedge serial_clock) begin
        #0.001;
        if (rst_n) begin
            clock_shift = {clock_pin,clock_shift[9:1]};
            lane0 = {pin0,lane0[9:1]};
            lane1 = {pin1,lane1[9:1]};
            lane2 = {pin2,lane2[9:1]};
            if (clock_shift === 10'h01f) begin
                words = words + 1;
                $fwrite(stream,"%0d %.6f %03h %03h %03h %b\n",words,$realtime,lane0,lane1,lane2,led);
                if (led[1] === 1'b0) begin
                    locked_words = locked_words + 1;
                    if ((^{lane0,lane1,lane2}) === 1'bx)
                        unknown_after_lock = unknown_after_lock + 1;
                end
                if (words == MAX_WORDS) begin
                    $fclose(stream);
                    $display("GATE_PIN_CAPTURE_COMPLETE words=%0d locked_words=%0d unknown_after_lock=%0d led=%b",words,locked_words,unknown_after_lock,led);
                    $display("GATE_SOURCE_OBSERVATIONS source_pixels=%0d source_sofs=%0d encoder_pixels=%0d source_h=%0d source_v=%0d",source_pixels,source_sofs,encoder_pixels,dut.\u_colorbars/h_count ,dut.\u_colorbars/v_count );
                    $finish;
                end
            end
        end
    end
endmodule
