`timescale 1ns/1ps
module tb_equiv;
  reg rst=1, mem_clk=0, Sdr_init_done=0, Sdr_init_ref_vld=0, Sdr_busy=0;
  reg App_rd_busy=0, write_req=0, write_jpeg420=0;
  reg [20:0] write_addr_0=21'd100, write_addr_1=21'd200, write_addr_2=21'd300, write_addr_3=21'd400;
  reg [1:0] write_addr_index=0;
  reg [20:0] write_len=0;
  reg [9:0] rdusedw=0;
  wire [3:0] state_o, state_c;
  wire req_sync_o, req_sync_c, ack_o, ack_c, finish_o, finish_c;
  wire [20:0] addr_o, addr_c;
  wire aclr_o, aclr_c, en_o, en_c, busy_o, busy_c;
  frame_fifo_write_original #(.BURST_SIZE(256)) original (
    .rst(rst), .mem_clk(mem_clk), .Sdr_init_done(Sdr_init_done), .Sdr_init_ref_vld(Sdr_init_ref_vld),
    .Sdr_busy(Sdr_busy), .App_rd_busy(App_rd_busy), .O_wr_busy(busy_o), .App_wr_en(en_o), .App_wr_addr(addr_o),
    .write_req(write_req), .write_jpeg420(write_jpeg420), .debug_state(state_o), .debug_req_sync(req_sync_o),
    .write_req_ack(ack_o), .write_finish(finish_o), .write_addr_0(write_addr_0), .write_addr_1(write_addr_1),
    .write_addr_2(write_addr_2), .write_addr_3(write_addr_3), .write_addr_index(write_addr_index),
    .write_len(write_len), .fifo_aclr(aclr_o), .rdusedw(rdusedw));
  frame_fifo_write_candidate #(.BURST_SIZE(256)) candidate (
    .rst(rst), .mem_clk(mem_clk), .Sdr_init_done(Sdr_init_done), .Sdr_init_ref_vld(Sdr_init_ref_vld),
    .Sdr_busy(Sdr_busy), .App_rd_busy(App_rd_busy), .O_wr_busy(busy_c), .App_wr_en(en_c), .App_wr_addr(addr_c),
    .write_req(write_req), .write_jpeg420(write_jpeg420), .debug_state(state_c), .debug_req_sync(req_sync_c),
    .write_req_ack(ack_c), .write_finish(finish_c), .write_addr_0(write_addr_0), .write_addr_1(write_addr_1),
    .write_addr_2(write_addr_2), .write_addr_3(write_addr_3), .write_addr_index(write_addr_index),
    .write_len(write_len), .fifo_aclr(aclr_c), .rdusedw(rdusedw));
  always #5 mem_clk=~mem_clk;
  integer cycles=0;
  always @(posedge mem_clk) begin
    if (!rst && candidate.state == 3 && candidate.wr_burst_finish &&
        candidate.remaining_words < candidate.active_burst_size)
      $fatal(1,"illegal frame contract: remaining_words smaller than active burst");
  end
  always @(posedge mem_clk) begin
    #1;
    if ({state_o,req_sync_o,ack_o,finish_o,addr_o,aclr_o,en_o,busy_o} !==
        {state_c,req_sync_c,ack_c,finish_c,addr_c,aclr_c,en_c,busy_c}) begin
      $display("MISMATCH cycle=%0d len=%0d jpeg=%0d fifo=%0d state=%0d/%0d en=%0b/%0b",cycles,write_len,write_jpeg420,rdusedw,state_o,state_c,en_o,en_c);
      $fatal(1);
    end
    cycles=cycles+1;
  end
  task automatic tick;
    begin @(negedge mem_clk); end
  endtask
  task automatic run_frame(input integer length, input integer jpeg);
    integer timeout;
    begin
      if (length % (jpeg ? 4 : 256) != 0) $fatal(1,"frame length violates burst contract");
      write_len=length; write_jpeg420=jpeg; write_req=1;
      timeout=0;
      while (!ack_o && timeout<12) begin tick(); timeout=timeout+1; end
      if (!ack_o) $fatal(1,"ACK timeout");
      write_req=0; rdusedw=0;
      timeout=0;
      while (!finish_o && timeout<length*3+400) begin
        tick();
        if (!aclr_o && rdusedw<500) rdusedw=rdusedw+((cycles%5)==0 ? 4 : 1);
        if (en_o && rdusedw!=0) rdusedw=rdusedw-1;
        App_rd_busy=(cycles%13==0);
        Sdr_busy=(jpeg && cycles%19<3);
        Sdr_init_ref_vld=(jpeg && cycles%29==0);
        timeout=timeout+1;
      end
      if (!finish_o) $fatal(1,"finish timeout len=%0d jpeg=%0d",length,jpeg);
      tick(); tick();
      App_rd_busy=0; Sdr_busy=0; Sdr_init_ref_vld=0; rdusedw=0;
    end
  endtask
  task automatic reset_during_burst;
    integer timeout;
    integer k;
    begin
      write_len=1024; write_jpeg420=0; write_req=1;
      timeout=0;
      while (!ack_o && timeout<12) begin tick(); timeout=timeout+1; end
      if (!ack_o) $fatal(1,"mid-reset setup ACK timeout");
      write_req=0; rdusedw=0;
      timeout=0;
      while (state_o != 3 && timeout<400) begin
        tick();
        if (!aclr_o && rdusedw<500) rdusedw=rdusedw+1;
        if (en_o && rdusedw!=0) rdusedw=rdusedw-1;
        timeout=timeout+1;
      end
      if (state_o != 3) $fatal(1,"mid-reset setup burst timeout");
      for (k=0;k<8;k=k+1) begin
        tick();
        if (rdusedw<500) rdusedw=rdusedw+1;
        if (en_o && rdusedw!=0) rdusedw=rdusedw-1;
      end
      @(negedge mem_clk); rst=1; write_req=0; rdusedw=0;
      repeat (3) tick();
      rst=0; Sdr_init_done=1;
      repeat (3) tick();
      run_frame(256,0);
    end
  endtask
  initial begin
    repeat (3) tick(); rst=0; Sdr_init_done=1;
    run_frame(256,0); run_frame(512,0); run_frame(1024,0);
    run_frame(4,1); run_frame(12,1); run_frame(320,1);
    reset_during_burst();
    run_frame(512,0); run_frame(12,1);
    $display("PASS: original/candidate outputs match, cycles=%0d",cycles);
    $finish;
  end
endmodule
