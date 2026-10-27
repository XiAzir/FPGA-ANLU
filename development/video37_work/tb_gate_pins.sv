`timescale 1ns/1ps
module tb_gate_pins;
    parameter integer MAX_WORDS = 30000;
    reg clk = 0;
    always #10 clk = ~clk;
    reg rst_n = 0;
    wire [3:0] led;
    wire clock_pin, pin0, pin1, pin2, dio, sclk, rclk;
    hdmi_open_gate dut(
        .clk(clk), .rst_n(rst_n), .led(led),
        .seg7_dio(dio), .seg7_sclk(sclk), .seg7_rclk(rclk),
        .HDMI_CLK_P(clock_pin), .HDMI_D0_P(pin0),
        .HDMI_D1_P(pin1), .HDMI_D2_P(pin2)
    );
    wire serial_clock = dut.\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ;
    reg [9:0] clock_shift = 0, lane0 = 0, lane1 = 0, lane2 = 0;
    integer words = 0;
    integer stream;
    reg [4095:0] out_path;
    initial begin
        if (!$value$plusargs("OUT=%s",out_path)) $fatal(1,"OUT required");
        stream = $fopen(out_path,"w");
        if (!stream) $fatal(1,"stream open failed");
        // The official PLL model leaves fakelockcnt X without an input reset;
        // tb_pll_lock_model independently reproduces this. Give the primitive
        // a 200ns model power-on reset, then release its original tied-low pin.
        force dut.\u_video_pll/pll_inst .reset = 1'b1;
        // Accelerate the 30ms post-lock startup wait. Clock generation and the
        // TX, serializer and pads then use the unchanged mapped netlist.
        force dut.startup_count = 20'd999999;
        #200 release dut.\u_video_pll/pll_inst .reset;
        #1800 rst_n = 1;
        #(MAX_WORDS*50+200000);
        $fatal(1,"PIN_CAPTURE_TIMEOUT words=%0d led=%b",words,led);
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
                if (words == MAX_WORDS) begin
                    $fclose(stream);
                    $display("OPEN_TX_PIN_CAPTURE_COMPLETE words=%0d led=%b",words,led);
                    $finish;
                end
            end
        end
    end
endmodule
