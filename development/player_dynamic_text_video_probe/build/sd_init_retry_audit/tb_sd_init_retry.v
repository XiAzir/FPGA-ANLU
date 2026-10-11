`timescale 1ns/1ps
module tb_sd_init_retry;
    reg clk = 0;
    reg rst = 1;
    always #5 clk = ~clk;

    wire sd_init_done;
    wire [15:0] spi_clk_div;
    wire cmd_req;
    wire cmd_req_ack;
    wire cmd_req_error;
    wire [47:0] cmd;
    wire [7:0] cmd_r1;
    wire [15:0] cmd_data_len;
    wire block_read_req;
    wire block_read_valid;
    wire [7:0] block_read_data;
    wire block_read_req_ack;
    wire block_write_req;
    wire [7:0] block_write_data;
    wire block_write_data_rd;
    wire block_write_req_ack;
    wire sd_sec_read_end;
    wire sd_sec_write_end;
    wire [7:0] sd_sec_read_data;
    wire sd_sec_read_data_valid;
    wire nCS_ctrl;
    wire [15:0] clk_div;
    wire spi_wr_req;
    wire spi_wr_ack;
    wire [7:0] spi_data_in;
    wire [7:0] spi_data_out;

    sd_card_sec_read_write #(.SPI_LOW_SPEED_DIV(0), .SPI_HIGH_SPEED_DIV(0)) dut_rw (
        .clk(clk), .rst(rst), .sd_init_done(sd_init_done),
        .sd_sec_read(1'b0), .sd_sec_read_addr(32'd0),
        .sd_sec_read_data(sd_sec_read_data), .sd_sec_read_data_valid(sd_sec_read_data_valid),
        .sd_sec_read_end(sd_sec_read_end), .sd_sec_write(1'b0), .sd_sec_write_addr(32'd0),
        .sd_sec_write_data(8'd0), .sd_sec_write_data_req(), .sd_sec_write_end(sd_sec_write_end),
        .spi_clk_div(spi_clk_div), .cmd_req(cmd_req), .cmd_req_ack(cmd_req_ack),
        .cmd_req_error(cmd_req_error), .cmd(cmd), .cmd_r1(cmd_r1), .cmd_data_len(cmd_data_len),
        .block_read_req(block_read_req), .block_read_valid(block_read_valid),
        .block_read_data(block_read_data), .block_read_req_ack(block_read_req_ack),
        .block_write_req(block_write_req), .block_write_data(block_write_data),
        .block_write_data_rd(block_write_data_rd), .block_write_req_ack(block_write_req_ack)
    );

    sd_card_cmd dut_cmd (
        .sys_clk(clk), .rst(rst), .spi_clk_div(spi_clk_div), .cmd_req(cmd_req),
        .cmd_req_ack(cmd_req_ack), .cmd_req_error(cmd_req_error), .cmd(cmd),
        .cmd_r1(cmd_r1), .cmd_data_len(cmd_data_len), .block_read_req(block_read_req),
        .block_read_valid(block_read_valid), .block_read_data(block_read_data),
        .block_read_req_ack(block_read_req_ack), .block_write_req(block_write_req),
        .block_write_data(block_write_data), .block_write_data_rd(block_write_data_rd),
        .block_write_req_ack(block_write_req_ack), .nCS_ctrl(nCS_ctrl), .clk_div(clk_div),
        .spi_wr_req(spi_wr_req), .spi_wr_ack(spi_wr_ack), .spi_data_in(spi_data_in),
        .spi_data_out(spi_data_out)
    );

    reg spi_ack = 0;
    reg [7:0] spi_rx = 8'hff;
    reg busy = 0;
    reg [7:0] held_rx = 8'hff;
    integer transfer_index = 0;
    integer current_cmd = -1;
    integer fail_cmd = -1;
    integer injected = 0;
    integer fail_count = 0;
    integer cmd0_count = 0;
    integer cmd8_count = 0;
    integer cmd55_count = 0;
    integer cmd41_count = 0;
    integer cmd16_count = 0;
    integer run_cycles = 0;

    assign spi_wr_ack = spi_ack;
    assign spi_data_out = spi_rx;

    // Byte-level SPI card stub: capture actual MOSI bytes while CS is active,
    // return R1 at byte 6, and optionally corrupt the first R1 for CMD0/CMD8.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            spi_ack <= 1'b0;
            spi_rx <= 8'hff;
            busy <= 1'b0;
            held_rx <= 8'hff;
            transfer_index <= 0;
            current_cmd <= -1;
            injected <= 0;
            fail_count <= 0;
            cmd0_count <= 0;
            cmd8_count <= 0;
            cmd55_count <= 0;
            cmd41_count <= 0;
            cmd16_count <= 0;
        end else if (spi_ack) begin
            // The DUT consumes this acknowledgment on this edge.
            spi_ack <= 1'b0;
            busy <= 1'b0;
        end else if (busy) begin
            spi_ack <= 1'b1;
            spi_rx <= held_rx;
        end else if (spi_wr_req) begin
            busy <= 1'b1;
            held_rx <= 8'hff;
            if (!nCS_ctrl) begin
                if (transfer_index == 0) begin
                    current_cmd <= spi_data_in[5:0];
                    case (spi_data_in[5:0])
                        0:  cmd0_count <= cmd0_count + 1;
                        8:  cmd8_count <= cmd8_count + 1;
                        55: cmd55_count <= cmd55_count + 1;
                        41: cmd41_count <= cmd41_count + 1;
                        16: cmd16_count <= cmd16_count + 1;
                        default: ;
                    endcase
                    $display("CARD CMD%0d start at cycle %0d", spi_data_in[5:0], run_cycles);
                end else if (transfer_index == 6) begin
                    if ((current_cmd == fail_cmd) && !injected) begin
                        held_rx <= 8'h04; // illegal R1: bit7=0, unequal expected R1
                        injected <= 1;
                        fail_count <= fail_count + 1;
                        $display("CARD CMD%0d inject illegal R1=04 at cycle %0d", current_cmd, run_cycles);
                    end else if ((current_cmd == 0) || (current_cmd == 8) || (current_cmd == 55)) begin
                        held_rx <= 8'h01;
                    end else begin
                        held_rx <= 8'h00;
                    end
                    $display("CARD CMD%0d R1 poll at cycle %0d", current_cmd, run_cycles);
                end
                transfer_index <= transfer_index + 1;
            end else begin
                transfer_index <= 0;
                current_cmd <= -1;
            end
        end
    end

    always @(posedge clk) begin
        if (!rst && dut_cmd.state == 5'd16) $display("CMD state=S_ERR cmd=%0d req=%0d ack=%0d err=%0d cycle=%0d", cmd[47:40], cmd_req, cmd_req_ack, cmd_req_error, run_cycles);
        if (!rst && cmd_req_ack) $display("CMD state=S_END handshake req=%0d ack=%0d err=%0d cycle=%0d", cmd_req, cmd_req_ack, cmd_req_error, run_cycles);
    end
    initial begin
        if (!$value$plusargs("fail_cmd=%d", fail_cmd)) fail_cmd = -1;
        $display("RUN fail_cmd=%0d", fail_cmd);
        repeat (5) @(posedge clk);
        rst <= 0;
        repeat (200000) begin
            @(posedge clk);
            run_cycles = run_cycles + 1;
            if (sd_init_done && dut_rw.state == 5'd17) begin
                // Allow nonblocking counters from the final command-start to settle.
                @(posedge clk);
                $display("COUNTS CMD0=%0d CMD8=%0d CMD55=%0d CMD41=%0d CMD16=%0d injected=%0d failures=%0d",
                         cmd0_count, cmd8_count, cmd55_count, cmd41_count, cmd16_count, injected, fail_count);
                if (cmd0_count != ((fail_cmd == 0) ? 2 : 1)) $fatal(1, "unexpected CMD0 count");
                if (cmd8_count != ((fail_cmd == 8) ? 2 : 1)) $fatal(1, "unexpected CMD8 count");
                if (cmd55_count != ((fail_cmd == 41) ? 2 : 1) || cmd41_count != ((fail_cmd == 41) ? 2 : 1) || cmd16_count != 1) $fatal(1, "unexpected command count");
                if ((fail_cmd == 0 || fail_cmd == 8 || fail_cmd == 41) && (!injected || fail_count != 1)) $fatal(1, "injection did not occur exactly once");
                if (fail_cmd == -1 && (injected || fail_count != 0)) $fatal(1, "baseline unexpectedly injected failure");
                $display("PASS fail_cmd=%0d: initialization reached WAIT_READ_WRITE", fail_cmd);
                $finish;
            end
        end
        $fatal(1, "TIMEOUT: init did not recover; state=%0d cmd_req=%0d ack=%0d error=%0d cmd=%0d",
               dut_rw.state, cmd_req, cmd_req_ack, cmd_req_error, cmd[47:40]);
    end
endmodule



