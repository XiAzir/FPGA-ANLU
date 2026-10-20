`timescale 1ns/1ps

module tb_spi_margin;
    reg sys_clk = 1'b0;
    reg rst = 1'b1;
    reg cpol = 1'b0;
    reg cpha = 1'b0;
    reg ncs_ctrl = 1'b0;
    reg [15:0] clk_div = 16'd0;
    reg wr_req = 1'b0;
    reg [7:0] data_in = 8'hA5;
    reg MISO = 1'b0;
    wire nCS, DCLK, MOSI, wr_ack;
    wire [7:0] data_out;

    integer miso_delay_ns = 0;
    integer bit_index = 0;
    integer errors;
    integer total;
    integer mode_index;
    integer delay_index;
    integer sample_index;
    integer seed = 32'h13572468;
    integer div_value;
    integer delay_value;
    integer half_period_ns;
    integer error_count;
    reg [7:0] tx_byte;
    reg [7:0] expected_bytes [0:23];
    reg slave_active = 1'b0;
    reg next_bit_value;
    integer delays [0:5];

    always #10 sys_clk = ~sys_clk;

    initial begin
        #1000000;
        $display("FAIL: simulation watchdog expired");
        $fatal(1);
    end

    spi_master dut (
        .sys_clk(sys_clk), .rst(rst), .nCS(nCS), .DCLK(DCLK), .MOSI(MOSI),
        .MISO(MISO), .CPOL(cpol), .CPHA(cpha), .nCS_ctrl(ncs_ctrl),
        .clk_div(clk_div), .wr_req(wr_req), .wr_ack(wr_ack),
        .data_in(data_in), .data_out(data_out)
    );

    task automatic update_miso_after(input reg value, input integer delay_ns);
        begin
            #(delay_ns);
            if (slave_active)
                MISO = value;
        end
    endtask

    // CPHA=0 slave behavior: bit 7 is already present before the first rising
    // edge; after each falling edge, the next bit is driven after the chosen
    // delay. This models the requested post-falling-edge MISO settling time.
    always @(negedge DCLK) begin
        if (slave_active && bit_index < 7) begin
            bit_index = bit_index + 1;
            next_bit_value = tx_byte[7-bit_index];
            fork
                update_miso_after(next_bit_value, miso_delay_ns);
            join_none
        end
    end

    task automatic transfer_byte(input reg [7:0] value);
        begin
            wait (dut.state == 3'd0);
            @(negedge sys_clk);
            tx_byte = value;
            bit_index = 0;
            MISO = value[7];
            slave_active = 1'b1;
            wr_req = 1'b1;
            @(negedge sys_clk);
            wr_req = 1'b0;
            wait (wr_ack === 1'b1);
            #1;
            total = total + 1;
            if (data_out !== value) begin
                errors = errors + 1;
                $display("MISMATCH div=%0d delay_ns=%0d expected=%02h got=%02h", clk_div, miso_delay_ns, value, data_out);
            end
            @(negedge sys_clk);
            slave_active = 1'b0;
            wait (wr_ack === 1'b0);
        end
    endtask

    initial begin
        delays[0] = 0;
        delays[1] = 15;
        delays[2] = 35;
        delays[3] = 55;
        delays[4] = 75;
        delays[5] = 85;

        expected_bytes[0] = 8'h00;
        expected_bytes[1] = 8'hFF;
        expected_bytes[2] = 8'h55;
        expected_bytes[3] = 8'hAA;
        expected_bytes[4] = 8'h01;
        expected_bytes[5] = 8'h80;
        expected_bytes[6] = 8'h3C;
        expected_bytes[7] = 8'hC3;
        for (sample_index = 8; sample_index < 24; sample_index = sample_index + 1)
            expected_bytes[sample_index] = $random(seed);

        errors = 0;
        total = 0;
        repeat (4) @(negedge sys_clk);
        rst = 1'b0;

        for (mode_index = 0; mode_index < 2; mode_index = mode_index + 1) begin
            if (mode_index == 0)
                div_value = 0;
            else
                div_value = 2;
            clk_div = div_value;
            half_period_ns = (div_value + 2) * 20;

            for (delay_index = 0; delay_index < 6; delay_index = delay_index + 1) begin
                delay_value = delays[delay_index];
                miso_delay_ns = delay_value;
                error_count = errors;
                for (sample_index = 0; sample_index < 24; sample_index = sample_index + 1)
                    transfer_byte(expected_bytes[sample_index]);

                error_count = errors - error_count;
                $display("RESULT div=%0d half_period_ns=%0d sclk_mhz=%0.3f delay_ns=%0d tested=24 errors=%0d",
                    div_value, half_period_ns, 1000.0/(2.0*half_period_ns), delay_value, error_count);

                // Delays below one half-period must be captured correctly;
                // delays above it must expose a stale-bit sampling window.
                if (delay_value < half_period_ns && error_count != 0) begin
                    $display("FAIL: unexpected errors inside half-period margin");
                    $fatal(1);
                end
                if (delay_value > half_period_ns && error_count == 0) begin
                    $display("FAIL: expected stale-bit errors beyond half-period");
                    $fatal(1);
                end
            end
        end

        $display("PASS total=%0d errors=%0d", total, errors);
        $finish;
    end
endmodule
