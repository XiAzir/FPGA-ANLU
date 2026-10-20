`timescale 1ns/1ps
module tb_hdmi_serial_receiver;
    reg pixel_clk=0, serial_clk=0, rst=1;
    reg [9:0] in0=0,in1=0,in2=0,inclk=10'b1111100000;
    wire out0,out1,out2,outclk;
    reg corrupt_enable=0, corrupt_active=0;
    wire rx_d0 = out0 ^ corrupt_active;
    wire symbol_valid,alignment_locked;
    wire [9:0] ch0,ch1,ch2,chclk;
    wire [31:0] malformed_words;
    wire adapter_locked;
    wire [31:0] adapter_malformed;
    wire [23:0] adapter_samples,adapter_packets,adapter_bad_bch,adapter_bad_terc,adapter_tone_bad;
    wire [19:0] adapter_cts,adapter_n;
    wire [3:0] adapter_flags;
    integer phase_ps=0;
    integer sent=0, received=0, errors=0, k;
    reg [9:0] exp0[0:511], exp1[0:511], exp2[0:511];
    integer seed=32'h7351a29d;
    reg [31:0] randword;
    integer first_index=-1;

    always #4 serial_clk=~serial_clk;
    initial begin
        if (!$value$plusargs("phase_ps=%d",phase_ps)) phase_ps=0;
        if ($test$plusargs("corrupt")) corrupt_enable=1;
        #phase_ps;
        forever #20 pixel_clk=~pixel_clk;
    end

    hdmi_phy_wrapper #(.DEVICE("EG")) dut (
        .I_pixel_clk(pixel_clk), .I_serial_clk(serial_clk), .I_rst(rst),
        .I_tmds_channel_0(in0), .I_tmds_channel_1(in1),
        .I_tmds_channel_2(in2), .I_tmds_channel_clk(inclk),
        .O_tmds_ch0_p(out0), .O_tmds_ch1_p(out1), .O_tmds_ch2_p(out2),
        .O_tmds_clk_p(outclk)
    );
    hdmi_serial_receiver rx (
        .serial_clk(serial_clk), .pixel_clk(pixel_clk), .rst(rst),
        .tmds_clk(outclk), .tmds_d0(rx_d0), .tmds_d1(out1), .tmds_d2(out2),
        .symbol_valid(symbol_valid), .ch0(ch0), .ch1(ch1), .ch2(ch2), .chclk(chclk),
        .alignment_locked(alignment_locked), .malformed_words(malformed_words)
    );
    hdmi_serial_packet_monitor monitor_from_pins (
        .serial_clk(serial_clk), .pixel_clk(pixel_clk), .rst(rst),
        .tmds_clk(outclk), .tmds_d0(rx_d0), .tmds_d1(out1), .tmds_d2(out2), .tone_mode(1'b0),
        .alignment_locked(adapter_locked), .malformed_words(adapter_malformed),
        .audio_samples_sec(adapter_samples), .audio_packets_sec(adapter_packets),
        .bad_bch_sec(adapter_bad_bch), .bad_terc_sec(adapter_bad_terc), .tone_bad_sec(adapter_tone_bad),
        .acr_cts_last(adapter_cts), .acr_n_last(adapter_n), .probe_flags(adapter_flags)
    );

    always @(negedge pixel_clk) begin
        if (!rst && sent < 220) begin
            randword=$random(seed); in0=randword[9:0]; exp0[sent]=in0;
            randword=$random(seed); in1=randword[9:0]; exp1[sent]=in1;
            randword=$random(seed); in2=randword[9:0]; exp2[sent]=in2;
            sent=sent+1;
        end
    end

    always @(posedge symbol_valid) begin
        if (alignment_locked) begin
            if (chclk !== 10'b1111100000) begin
                $display("ERROR: malformed clock symbol at rx index %0d: %03x",received,chclk);
                errors=errors+1;
            end
            if (received>0) begin
                if ((first_index+received) < sent &&
                    (ch0 !== exp0[first_index+received] ||
                    ch1 !== exp1[first_index+received] ||
                    ch2 !== exp2[first_index+received])) begin
                    $display("ERROR: data mismatch rx=%0d expected-index=%0d got=%03x/%03x/%03x expected=%03x/%03x/%03x",
                      received,first_index+received,ch0,ch1,ch2,
                      exp0[first_index+received],exp1[first_index+received],exp2[first_index+received]);
                    errors=errors+1;
                end
            end else begin
                for (k=0;k<sent;k=k+1) begin
                    if (first_index<0 && ch0===exp0[k] && ch1===exp1[k] && ch2===exp2[k])
                        first_index=k;
                end
                if (first_index<0) begin
                    $display("ERROR: first recovered word did not match any transmitted word: %03x/%03x/%03x",ch0,ch1,ch2);
                    errors=errors+1;
                end
            end
            received=received+1;
        end
    end

    initial begin
        if (corrupt_enable) begin
            wait(alignment_locked);
            @(negedge serial_clk);
            corrupt_active=1;
            #0.01;
            corrupt_active=0;
        end
    end

    initial begin
        repeat (12) @(posedge serial_clk);
        rst=0;
        wait(sent>=220);
        repeat (3) @(posedge pixel_clk);
        $display("SUMMARY phase_ps=%0d sent=%0d received=%0d first_index=%0d locked=%0b malformed=%0d errors=%0d",
          phase_ps,sent,received,first_index,alignment_locked,malformed_words,errors);
        if (!alignment_locked || !adapter_locked || received<200 || malformed_words!=0 || adapter_malformed!=0)
            $fatal(1,"receiver test FAILED: lock/count/clock lane");
        if (corrupt_enable) begin
            if (errors==0) $fatal(1,"negative control FAILED: injected serial bit flip was not detected");
            $display("PASS: injected physical serial bit flip detected");
        end else begin
            if (errors!=0) $fatal(1,"receiver test FAILED: data mismatch");
            $display("PASS: receiver reconstructed the real EG ODDR PHY serial stream");
        end
        $finish;
    end

    initial begin #200000; $fatal(1,"timeout"); end
endmodule
