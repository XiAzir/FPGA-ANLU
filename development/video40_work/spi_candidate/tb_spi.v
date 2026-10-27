`timescale 1ns/1ps
module tb_spi;
  parameter FAST = 0;
  parameter BYPASS = 0;
  reg sys_clk=0, rst=1, cpol=1, cpha=1, csctrl=1, wr_req=0;
  reg [15:0] clk_div=0;
  reg [7:0] data_in=0;
  reg miso=0;
  wire nCS,DCLK,MOSI,wr_ack;
  wire [7:0] data_out;
  wire [2:0] debug_state;
  integer tod_ns=0;
  reg [7:0] rx_byte=8'h00, exp_tx=0;
  integer miso_bit=0, tx_count=0, tx_bytes=0, inject_bit=-1;
  reg [7:0] tx_shift=0, random_tx=0;
  realtime last_edge=0, half_min=1.0e9, half_max=0, byte_start=0, last_ack=0;
  integer edge_num=0;
  spi_master #(.FAST_DIV0(FAST),.FAST_ACK_WAIT_BYPASS(BYPASS)) dut(sys_clk,rst,nCS,DCLK,MOSI,miso,cpol,cpha,csctrl,clk_div,wr_req,wr_ack,data_in,data_out,debug_state);
  always #10 sys_clk=~sys_clk;
  always @(posedge rst) last_edge=0;
  always @(posedge wr_ack) last_ack=$realtime;
  always #1 if (nCS!==csctrl) $fatal(1,"nCS passthrough mismatch");
  always @(negedge nCS) begin miso_bit=0; tx_count=0; end
  always @(negedge DCLK) begin
    if (!nCS && !rst) begin
      #(tod_ns);
      if (miso_bit < 8) miso = rx_byte[7-miso_bit];
      else miso = rx_byte[7-(miso_bit%8)];
      miso_bit=miso_bit+1;
    end
  end
  always @(DCLK) begin
    if (!nCS && !rst) begin
      if (last_edge!=0) begin
        if (($realtime-last_edge)<half_min) half_min=$realtime-last_edge;
        if (($realtime-last_edge)>half_max) half_max=$realtime-last_edge;
      end
      last_edge=$realtime; edge_num=edge_num+1;
      if (edge_num==1) begin
        byte_start=$realtime;
        if (last_ack!=0) $display("CONSUMER_GAP_NS=%0.1f",$realtime-last_ack);
      end
      if (edge_num==16) begin $display("PIN_BYTE_TIMING div=%0d edge_span_ns=%0.1f full_byte_ns=%0.1f",clk_div,$realtime-byte_start,$realtime-byte_start+(clk_div==0 ? (FAST ? 20 : 40) : 5000)); edge_num=0; end
      if (DCLK===1'b1) begin
        tx_shift={tx_shift[6:0],MOSI ^ ((inject_bit>=0 && tx_count==inject_bit) ? 1'b1 : 1'b0)}; tx_count=tx_count+1;
        if (tx_count==8) begin
          $display("PIN_TX byte=%02x t=%0t",tx_shift,$time);
          if (tx_shift!==exp_tx) $fatal(1,"PIN MOSI mismatch expected=%02x observed=%02x",exp_tx,tx_shift);
          tx_bytes=tx_bytes+1; tx_count=0; tx_shift=0;
        end
      end
    end
  end
  task transact;
    input [7:0] tx;
    input [7:0] rx;
    input integer divval;
    integer timeout;
    begin
      rx_byte=rx; exp_tx=tx; clk_div=divval; data_in=tx; edge_num=0; wr_req=1;
      @(negedge sys_clk);
      timeout=0;
      while (!wr_ack && timeout<100000) begin @(negedge sys_clk); timeout=timeout+1; end
      if (!wr_ack) $fatal(1,"ACK timeout tx=%02x div=%0d",tx,divval);
      if (data_out!==rx) $fatal(1,"RX mismatch tx=%02x expected=%02x got=%02x",tx,rx,data_out);
      if (tx_count!=0) $fatal(1,"partial pin byte count=%0d",tx_count);
      $display("BYTE_PASS tx=%02x rx=%02x div=%0d ack=%0t",tx,data_out,divval,$time);
      wr_req=0;
      @(negedge sys_clk);
      while (wr_ack) @(negedge sys_clk);
    end
  endtask
  task abort_mid_reset;
    begin
      rx_byte=8'ha5; exp_tx=8'hc7; clk_div=0; data_in=8'hc7; wr_req=1;
      @(negedge sys_clk);
      repeat (4) @(posedge DCLK);
      @(negedge sys_clk); rst=1; wr_req=0;
      repeat (2) @(negedge sys_clk);
      if (wr_ack) $fatal(1,"ACK asserted during asynchronous reset");
      rst=0;
      repeat (2) @(negedge sys_clk);
      if (wr_ack) $fatal(1,"ACK remained asserted after reset");
      tx_count=0; tx_shift=0; edge_num=0; last_edge=0; miso_bit=0;
      $display("ABORT_RESET_PASS nCS=%b DCLK=%b",nCS,DCLK);
    end
  endtask
  initial begin
    if (!$value$plusargs("TOD=%d",tod_ns)) tod_ns=0;
    if (!$value$plusargs("INJECT=%d",inject_bit)) inject_bit=-1;
    #45; rst=0; repeat(3) @(negedge sys_clk);
    csctrl=0; repeat(2) @(negedge sys_clk);
    transact(8'h00,8'h00,0);
    transact(8'hff,8'hff,0);
    transact(8'ha5,8'h5a,0);
    transact(8'h5a,8'ha5,0);
    transact(8'h3c,8'hc3,0);
    transact(8'h96,8'h69,248);
    repeat (8) begin random_tx=$random; transact(random_tx,random_tx ^ 8'h5a,0); end
    abort_mid_reset;
    csctrl=1;
    repeat(3) @(negedge sys_clk);
    $display("METRIC fast=%0d tod_ns=%0d half_min_ns=%0.1f half_max_ns=%0.1f tx_bytes=%0d",FAST,tod_ns,half_min,half_max,tx_bytes);
    if (tx_bytes!=14) $fatal(1,"expected 14 pin bytes, observed %0d",tx_bytes);
    $display("PASS"); $finish;
  end
  initial begin #100000000; $fatal(1,"global timeout"); end
endmodule



