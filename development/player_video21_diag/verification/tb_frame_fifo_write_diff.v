`timescale 1ns/1ps
module tb_frame_fifo_write_diff;
    reg mem_clk=0;
    always #5 mem_clk=~mem_clk;
    reg rst=1;
    reg Sdr_init_done=0, Sdr_init_ref_vld=0, Sdr_busy=0, App_rd_busy=0;
    reg write_req=0, write_jpeg420=0;
    reg [20:0] write_addr_0=21'd100, write_addr_1=21'd200;
    reg [20:0] write_addr_2=21'd300, write_addr_3=21'd400;
    reg [1:0] write_addr_index=0;
    reg [20:0] write_len=0;
    reg [9:0] rdusedw=0;

    wire dut_busy, dut_en, dut_ack, dut_finish, dut_fifo_aclr;
    wire [20:0] dut_addr;
    wire [3:0] dut_state;
    wire dut_req_sync;
    wire ref_busy, ref_en, ref_ack, ref_finish, ref_fifo_aclr;
    wire [20:0] ref_addr;

    frame_fifo_write #(.BURST_BITS(3),.BURST_SIZE(4),.WRITE_V_FLIP(0),
        .FRAME_WIDTH(4),.FRAME_HEIGHT(2)) dut (
        .rst(rst),.mem_clk(mem_clk),.Sdr_init_done(Sdr_init_done),
        .Sdr_init_ref_vld(Sdr_init_ref_vld),.Sdr_busy(Sdr_busy),.App_rd_busy(App_rd_busy),
        .O_wr_busy(dut_busy),.App_wr_en(dut_en),.App_wr_addr(dut_addr),
        .write_req(write_req),.write_jpeg420(write_jpeg420),
        .debug_state(dut_state),.debug_req_sync(dut_req_sync),
        .write_req_ack(dut_ack),.write_finish(dut_finish),
        .write_addr_0(write_addr_0),.write_addr_1(write_addr_1),
        .write_addr_2(write_addr_2),.write_addr_3(write_addr_3),
        .write_addr_index(write_addr_index),.write_len(write_len),
        .fifo_aclr(dut_fifo_aclr),.rdusedw(rdusedw)
    );

    frame_fifo_write_c20_reference #(.BURST_BITS(3),.BURST_SIZE(4),.WRITE_V_FLIP(0),
        .FRAME_WIDTH(4),.FRAME_HEIGHT(2)) ref_dut (
        .rst(rst),.mem_clk(mem_clk),.Sdr_init_done(Sdr_init_done),
        .Sdr_init_ref_vld(Sdr_init_ref_vld),.Sdr_busy(Sdr_busy),.App_rd_busy(App_rd_busy),
        .O_wr_busy(ref_busy),.App_wr_en(ref_en),.App_wr_addr(ref_addr),
        .write_req(write_req),.write_jpeg420(write_jpeg420),
        .write_req_ack(ref_ack),.write_finish(ref_finish),
        .write_addr_0(write_addr_0),.write_addr_1(write_addr_1),
        .write_addr_2(write_addr_2),.write_addr_3(write_addr_3),
        .write_addr_index(write_addr_index),.write_len(write_len),
        .fifo_aclr(ref_fifo_aclr),.rdusedw(rdusedw)
    );

    integer cycles=0;
    always @(negedge mem_clk) begin
        if (!rst) begin
            cycles=cycles+1;
            if ({dut_busy,dut_en,dut_addr,dut_ack,dut_finish,dut_fifo_aclr} !==
                {ref_busy,ref_en,ref_addr,ref_ack,ref_finish,ref_fifo_aclr}) begin
                $display("FAIL diff cycle=%0d dut state=%0d reqsync=%b ref state=%0d reqsync=%b",cycles,dut_state,dut_req_sync,ref_dut.state,ref_dut.write_req_d2);
                $display(" DUT busy/en/addr/ack/finish/aclr=%b %b %05x %b %b %b",dut_busy,dut_en,dut_addr,dut_ack,dut_finish,dut_fifo_aclr);
                $display(" REF busy/en/addr/ack/finish/aclr=%b %b %05x %b %b %b",ref_busy,ref_en,ref_addr,ref_ack,ref_finish,ref_fifo_aclr);
                $fatal(1);
            end
            if (dut_state !== dut.state || dut_req_sync !== dut.write_req_d2) begin
                $display("FAIL debug taps cycle=%0d state=%0d/%0d req=%b/%b",cycles,dut_state,dut.state,dut_req_sync,dut.write_req_d2);
                $fatal(1);
            end
        end
    end

    task wait_ack;
        integer n;
        begin
            n=0;
            while (!dut_ack && n<32) begin @(negedge mem_clk); n=n+1; end
            if (!dut_ack) begin $display("FAIL request ack timeout"); $fatal(1); end
            @(negedge mem_clk);
            write_req=0;
        end
    endtask

    task wait_finished;
        integer n;
        begin
            n=0;
            while (!dut_finish && n<100) begin @(negedge mem_clk); n=n+1; end
            if (!dut_finish) begin $display("FAIL write finish timeout"); $fatal(1); end
            repeat (3) @(negedge mem_clk);
        end
    endtask

    task run_request(input bit jpeg_mode,input [1:0] addr_index,input [20:0] length);
        begin
            write_jpeg420=jpeg_mode;
            write_addr_index=addr_index;
            write_len=length;
            rdusedw=10'd900;
            write_req=1;
            wait_ack();
            wait_finished();
        end
    endtask

    initial begin
        @(posedge mem_clk); @(negedge mem_clk);
        rst=0;
        // A pending request must remain unacknowledged until SDRAM init.
        write_req=1; write_len=8; rdusedw=10'd900;
        repeat (6) @(negedge mem_clk);
        if (dut_ack || dut_state!=0) begin $display("FAIL acknowledged before SDR init"); $fatal(1); end
        Sdr_init_done=1;
        wait_ack();
        wait_finished();

        // Run both frame-address modes with distinct base indices.
        run_request(1'b0,2'd1,21'd8);
        run_request(1'b1,2'd0,21'd16);

        // Reset while a request is synchronized but init is withheld.
        Sdr_init_done=0; write_req=1; write_jpeg420=0; write_len=8;
        repeat (5) @(negedge mem_clk);
        rst=1;
        @(posedge mem_clk); @(negedge mem_clk);
        if (dut_state!=0 || dut_req_sync!=0 || dut_ack || dut_en || dut_finish || dut_fifo_aclr) begin
            $display("FAIL reset did not clear diagnostics/outputs"); $fatal(1);
        end
        write_req=0; rst=0;
        repeat (5) @(negedge mem_clk);

        // Re-arm after reset, delay init again, then exercise JPEG mode.
        write_req=1; write_jpeg420=1; write_addr_index=2'd0; write_len=16; rdusedw=10'd900;
        repeat (5) @(negedge mem_clk);
        if (dut_ack) begin $display("FAIL acknowledged before second SDR init"); $fatal(1); end
        Sdr_init_done=1;
        wait_ack();
        wait_finished();
        $display("PASS frame_fifo_write: debug taps and C20 differential, init delay, RGB/JPEG modes, reset");
        $finish;
    end
endmodule
