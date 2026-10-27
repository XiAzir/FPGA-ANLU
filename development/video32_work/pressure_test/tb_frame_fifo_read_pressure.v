`timescale 1ns/1ps
module tb_frame_fifo_read_pressure;
  reg rst=1'b1, mem_clk=1'b0;
  always #5 mem_clk=~mem_clk;
  reg Sdr_init_done=1'b0, Sdr_init_ref_vld=1'b0, Sdr_busy=1'b0;
  reg Sdr_rd_en=1'b0, App_wr_busy=1'b0;
  reg read_req=1'b0;
  reg [20:0] read_addr_0=0, read_addr_1=21'd230400, read_addr_2=0, read_addr_3=0;
  reg [1:0] read_addr_index=0;
  reg [20:0] read_len=21'd230400;
  reg [9:0] wrusedw=10'd256;
  wire O_rd_busy, read_refill_request, App_rd_en;
  wire [20:0] App_rd_addr;
  wire read_req_ack, read_finish, fifo_aclr;
  integer app_rd_count=0;

  frame_fifo_read #(.ADDR_BITS(21),.BURST_BITS(9),.FIFO_DEPTH(512),.BURST_SIZE(256)) dut (
    .rst(rst),.mem_clk(mem_clk),.Sdr_init_done(Sdr_init_done),
    .Sdr_init_ref_vld(Sdr_init_ref_vld),.Sdr_busy(Sdr_busy),.Sdr_rd_en(Sdr_rd_en),
    .App_wr_busy(App_wr_busy),.O_rd_busy(O_rd_busy),.read_refill_request(read_refill_request),
    .App_rd_en(App_rd_en),.App_rd_addr(App_rd_addr),.read_req(read_req),
    .read_req_ack(read_req_ack),.read_finish(read_finish),
    .read_addr_0(read_addr_0),.read_addr_1(read_addr_1),.read_addr_2(read_addr_2),.read_addr_3(read_addr_3),
    .read_addr_index(read_addr_index),.read_len(read_len),.fifo_aclr(fifo_aclr),.wrusedw(wrusedw)
  );

  always @(posedge mem_clk) if (App_rd_en) app_rd_count<=app_rd_count+1;

  initial begin
    repeat(4) @(negedge mem_clk);
    rst=0; Sdr_init_done=1;
    read_req=1;
    wait(read_req_ack===1'b1);
    @(negedge mem_clk); read_req=0;
    wait(dut.state==2);
    repeat(4) @(negedge mem_clk);
    if (App_rd_en || read_refill_request) $fatal(1,"threshold must not request at wrusedw=256");

    // The write-side owner blocks refill while it is already in a burst.
    wrusedw=255; App_wr_busy=1; Sdr_busy=1; Sdr_init_ref_vld=1;
    repeat(8) @(negedge mem_clk);
    if (App_rd_en) $fatal(1,"App_wr_busy must block read burst start");

    // SDRAM busy/refresh are deliberately high. Read FSM has no gate for either.
    App_wr_busy=0;
    wait(App_rd_en===1'b1);
    if (!Sdr_busy || !Sdr_init_ref_vld) $fatal(1,"busy/ref stimulus lost");
    $display("PASS: BURST_SIZE=256 threshold is <256; at 255 words App_wr_busy blocks, then read App_rd_en starts with Sdr_busy=1 and Sdr_init_ref_vld=1; App_rd_addr=%0d",App_rd_addr);
    repeat(8) @(negedge mem_clk);
    if (app_rd_count==0) $fatal(1,"no read enable beats observed");
    $display("PASS: observed %0d App_rd_en beat(s) during SDRAM busy/refresh window",app_rd_count);
    $finish;
  end
  initial begin #200000; $fatal(1,"timeout"); end
endmodule
