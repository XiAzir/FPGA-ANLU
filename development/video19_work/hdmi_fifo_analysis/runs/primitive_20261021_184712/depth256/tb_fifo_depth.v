`timescale 1ns/1ps
module tb_fifo_depth;
    parameter integer EXPECTED_DEPTH = 128;

    reg clk = 1'b0;
    reg rst = 1'b1;
    reg [95:0] di = 96'd0;
    reg re = 1'b0;
    reg we = 1'b0;
    wire [95:0] dout;
    wire empty_flag;
    wire full_flag;
    wire [10:0] rdusedw;
    wire [10:0] wrusedw;

    EG_LOGIC_RAMFIFO #(
        .DATA_WIDTH(96),
        .ADDR_WIDTH(10),
        .SHOWAHEAD(0),
        .IMPLEMENT("AUTO")
    ) dut (
        .rst(rst), .di(di), .clk(clk), .re(re), .we(we), .do(dout),
        .empty_flag(empty_flag), .full_flag(full_flag),
        .rdusedw(rdusedw), .wrusedw(wrusedw)
    );

    always #10 clk = ~clk;

    function [95:0] make_word;
        input integer n;
        begin
            make_word = {32'hA5000000 ^ n, n[31:0], 32'h5A000000 ^ ~n};
        end
    endfunction

    integer round_no;
    integer index;
    integer accepted;
    integer expected_base;

    initial begin
        repeat (4) @(posedge clk);
        @(negedge clk); rst = 1'b0;
        repeat (5) @(posedge clk);
        if (empty_flag !== 1'b1 || full_flag !== 1'b0 || wrusedw !== 0)
            $fatal(1, "reset state mismatch empty=%b full=%b used=%0d", empty_flag, full_flag, wrusedw);

        for (round_no = 0; round_no < 3; round_no = round_no + 1) begin
            expected_base = round_no * (EXPECTED_DEPTH + 19);
            accepted = 0;
            for (index = 0; index < EXPECTED_DEPTH + 8; index = index + 1) begin
                @(negedge clk);
                we = 1'b1;
                di = make_word(expected_base + accepted);
                @(posedge clk);
                if (full_flag === 1'b0)
                    accepted = accepted + 1;
                else if (accepted != EXPECTED_DEPTH)
                    $fatal(1, "early full round=%0d accepted=%0d depth=%0d", round_no, accepted, EXPECTED_DEPTH);
            end
            @(negedge clk); we = 1'b0;
            repeat (5) @(posedge clk);
            if (accepted != EXPECTED_DEPTH || full_flag !== 1'b1 || wrusedw !== EXPECTED_DEPTH)
                $fatal(1, "fill mismatch round=%0d accepted=%0d full=%b used=%0d depth=%0d",
                    round_no, accepted, full_flag, wrusedw, EXPECTED_DEPTH);

            for (index = 0; index < EXPECTED_DEPTH; index = index + 1) begin
                @(negedge clk); re = 1'b1;
                @(posedge clk); #1;
                if (empty_flag !== 1'b0 || dout !== make_word(expected_base + index))
                    $fatal(1, "read mismatch round=%0d index=%0d empty=%b got=%h expected=%h",
                        round_no, index, empty_flag, dout, make_word(expected_base + index));
            end
            @(negedge clk); re = 1'b0;
            repeat (5) @(posedge clk);
            if (empty_flag !== 1'b1 || full_flag !== 1'b0 || rdusedw !== 0)
                $fatal(1, "drain mismatch round=%0d empty=%b full=%b used=%0d",
                    round_no, empty_flag, full_flag, rdusedw);
        end

        $display("FIFO_DEPTH_PASS depth=%0d rounds=3 writes=%0d reads=%0d",
            EXPECTED_DEPTH, 3 * EXPECTED_DEPTH, 3 * EXPECTED_DEPTH);
        $finish;
    end

    initial begin
        #2000000;
        $fatal(1, "watchdog timeout depth=%0d", EXPECTED_DEPTH);
    end
endmodule
