`timescale 1ps/1ps

module tb_phy_official_oddr;
    reg pixel_clk = 1'b0;
    reg serial_clk = 1'b0;
    reg rst = 1'b1;
    reg [9:0] ch0 = 10'd0;
    reg [9:0] ch1 = 10'd0;
    reg [9:0] ch2 = 10'd0;
    reg [9:0] chclk = 10'b1111100000;
    wire [3:0] serial_out;

    integer serial_phase_ps = 0;
    integer epoch = 1;
    integer source_index = 0;
    integer history_length = 0;
    reg [9:0] history [0:2][0:511];
    reg [9:0] windows [0:2];
    integer sample_count [0:2];
    integer live_run [0:2][0:9];
    integer last_index [0:2][0:9];
    integer last_tick [0:2][0:9];
    integer last_latency [0:2][0:9];
    integer best_run [0:1][0:2];
    integer best_latency [0:1][0:2];

    reg [9:0] clock_reference [0:1];
    integer clock_sample_count = 0;
    integer serial_samples_since_reset = 0;
    integer clock_mismatch [0:1];
    integer clock_pattern_checked [0:1];
    integer clock_ones [0:1];
    integer clock_transitions [0:1];
    integer clock_restart_checks = 0;
    integer i;
    integer j;
    integer compile_error = 0;

    hdmi_phy_wrapper #(.DEVICE("EG")) dut (
        .I_pixel_clk(pixel_clk),
        .I_serial_clk(serial_clk),
        .I_rst(rst),
        .I_tmds_channel_0(ch0),
        .I_tmds_channel_1(ch1),
        .I_tmds_channel_2(ch2),
        .I_tmds_channel_clk(chclk),
        .O_tmds_ch0_p(serial_out[0]),
        .O_tmds_ch1_p(serial_out[1]),
        .O_tmds_ch2_p(serial_out[2]),
        .O_tmds_clk_p(serial_out[3])
    );

    always #20000 pixel_clk = ~pixel_clk;

    initial begin
        if (!$value$plusargs("phase_ps=%d", serial_phase_ps)) serial_phase_ps = 0;
        #(serial_phase_ps);
        forever begin
            serial_clk = 1'b1;
            #4000 serial_clk = 1'b0;
            #4000;
        end
    end

    function [9:0] source_word;
        input integer n;
        input integer lane;
        begin
            source_word = (n * 73 + lane * 251) & 10'h3ff;
        end
    endfunction

    task reset_scoreboard;
        integer lane;
        integer phase;
        begin
            source_index = 0;
            history_length = 0;
            clock_sample_count = 0;
            serial_samples_since_reset = 0;
            for (lane = 0; lane < 3; lane = lane + 1) begin
                windows[lane] = 10'd0;
                sample_count[lane] = 0;
                for (phase = 0; phase < 10; phase = phase + 1) begin
                    live_run[lane][phase] = 0;
                    last_index[lane][phase] = -1;
                    last_tick[lane][phase] = -1;
                    last_latency[lane][phase] = -1;
                end
            end
        end
    endtask

    task score_data_bit;
        input integer lane;
        input reg serial_bit;
        integer phase;
        integer found;
        integer hist_index;
        integer latency;
        reg [9:0] next_window;
        begin
            next_window = {serial_bit, windows[lane][9:1]};
            windows[lane] = next_window;
            sample_count[lane] = sample_count[lane] + 1;
            if (sample_count[lane] >= 10) begin
                phase = sample_count[lane] % 10;
                found = -1;
                for (hist_index = 1; hist_index <= history_length; hist_index = hist_index + 1)
                    if (history[lane][hist_index] === next_window) found = hist_index;
                if (found >= 0) begin
                    latency = (serial_samples_since_reset / 10) - found;
                    if (last_tick[lane][phase] == sample_count[lane] - 10 &&
                        last_index[lane][phase] == found - 1 &&
                        last_latency[lane][phase] == latency)
                        live_run[lane][phase] = live_run[lane][phase] + 1;
                    else
                        live_run[lane][phase] = 1;
                    last_tick[lane][phase] = sample_count[lane];
                    last_index[lane][phase] = found;
                    last_latency[lane][phase] = latency;
                    if (epoch >= 1 && epoch <= 2 &&
                        live_run[lane][phase] > best_run[epoch-1][lane]) begin
                        best_run[epoch-1][lane] = live_run[lane][phase];
                        best_latency[epoch-1][lane] = latency;
                    end
                end else begin
                    live_run[lane][phase] = 0;
                    last_tick[lane][phase] = sample_count[lane];
                    last_index[lane][phase] = -1;
                    last_latency[lane][phase] = -1;
                end
            end
        end
    endtask

    task score_clock_bit;
        input reg serial_bit;
        integer sample_no;
        integer ones;
        integer transitions;
        integer k;
        begin
            sample_no = clock_sample_count;
            if (sample_no < 10) begin
                clock_reference[epoch-1][sample_no] = serial_bit;
                if (sample_no == 9) begin
                    ones = 0;
                    transitions = 0;
                    for (k = 0; k < 10; k = k + 1) begin
                        if (clock_reference[epoch-1][k]) ones = ones + 1;
                        if (clock_reference[epoch-1][k] != clock_reference[epoch-1][(k+9)%10])
                            transitions = transitions + 1;
                    end
                    clock_ones[epoch-1] = ones;
                    clock_transitions[epoch-1] = transitions;
                    clock_pattern_checked[epoch-1] = 1;
                end
            end else if (serial_bit !== clock_reference[epoch-1][sample_no % 10]) begin
                clock_mismatch[epoch-1] = clock_mismatch[epoch-1] + 1;
            end
            clock_sample_count = clock_sample_count + 1;
        end
    endtask

    task sample_outputs;
        begin
            if (!rst && epoch <= 2) begin
                serial_samples_since_reset = serial_samples_since_reset + 1;
                if (serial_samples_since_reset > 60) begin
                    score_data_bit(0, serial_out[0]);
                    score_data_bit(1, serial_out[1]);
                    score_data_bit(2, serial_out[2]);
                    score_clock_bit(serial_out[3]);
                end
            end
        end
    endtask

    always @(negedge pixel_clk) begin
        if (!rst && source_index < 511) begin
            source_index = source_index + 1;
            ch0 = source_word(source_index, 0);
            ch1 = source_word(source_index, 1);
            ch2 = source_word(source_index, 2);
            history[0][source_index] = ch0;
            history[1][source_index] = ch1;
            history[2][source_index] = ch2;
            history_length = source_index;
        end
    end

    always @(posedge rst) begin
        if (epoch == 1) begin
            clock_restart_checks = clock_restart_checks +
                ((clock_pattern_checked[0] == 1 && clock_ones[0] == 5 &&
                  clock_transitions[0] == 2 && clock_mismatch[0] == 0) ? 1 : 0);
        end
        epoch = epoch + 1;
        if (epoch <= 2) reset_scoreboard();
    end

    always @(posedge serial_clk) begin
        #500 sample_outputs();
    end

    always @(negedge serial_clk) begin
        #500 sample_outputs();
    end

    initial begin
        for (i = 0; i < 2; i = i + 1) begin
            clock_mismatch[i] = 0;
            clock_pattern_checked[i] = 0;
            clock_ones[i] = 0;
            clock_transitions[i] = 0;
            for (j = 0; j < 3; j = j + 1) begin
                best_run[i][j] = 0;
                best_latency[i][j] = -999;
            end
        end
        reset_scoreboard();
        #100000 rst = 1'b0;
        #1800000 rst = 1'b1;
        #200000 rst = 1'b0;
        #2200000;
        if (clock_pattern_checked[1] != 1 || clock_ones[1] != 5 ||
            clock_transitions[1] != 2 || clock_mismatch[1] != 0)
            $fatal(1, "clock lane duty/period failed epoch2 ones=%0d transitions=%0d period_errors=%0d",
                clock_ones[1], clock_transitions[1], clock_mismatch[1]);
        if (clock_restart_checks != 1)
            $fatal(1, "clock lane restart check failed (%0d)", clock_restart_checks);
        if (best_run[0][0] < 12 || best_run[0][1] < 12 || best_run[0][2] < 12 ||
            best_run[1][0] < 12 || best_run[1][1] < 12 || best_run[1][2] < 12)
            $fatal(1, "LSB-first sequence streak too short: e1=%0d/%0d/%0d e2=%0d/%0d/%0d",
                best_run[0][0], best_run[0][1], best_run[0][2],
                best_run[1][0], best_run[1][1], best_run[1][2]);
        if (best_latency[0][0] == -999 || best_latency[0][0] != best_latency[1][0] ||
            best_latency[0][1] != best_latency[1][1] || best_latency[0][2] != best_latency[1][2])
            $fatal(1, "fixed latency changed across reset: e1=%0d/%0d/%0d e2=%0d/%0d/%0d",
                best_latency[0][0], best_latency[0][1], best_latency[0][2],
                best_latency[1][0], best_latency[1][1], best_latency[1][2]);
        $display("OFFICIAL_ODDR_PASS phase_ps=%0d epochs=2 lsb_streaks=%0d/%0d/%0d,%0d/%0d/%0d fixed_latency=%0d/%0d/%0d clock_duty=5:5 clock_transitions=2 restart_checks=%0d",
            serial_phase_ps, best_run[0][0], best_run[0][1], best_run[0][2],
            best_run[1][0], best_run[1][1], best_run[1][2],
            best_latency[0][0], best_latency[0][1], best_latency[0][2], clock_restart_checks);
        $finish;
    end
endmodule
