`timescale 1ns/1ps
module tb_gate_refresh;
  import gate_refresh_metrics::*;
  parameter integer CASE_C40 = 1;
  parameter integer MAX_MEASURE_CYCLES = 12000;
  parameter integer TARGET_AREFS = 10;
  parameter integer TRAFFIC = 0;

  logic tb_clk = 1'b0;
  logic tb_sft_clk = 1'b0;
  logic drive_wr = 1'b0;
  logic drive_rd = 1'b0;
  integer traffic_cycle = 0;
  integer burst_left = 0;
  integer cooldown = 0;
  logic burst_write = 1;
  logic next_write = 1;
  logic [20:0] drive_wr_addr = 0;
  logic [20:0] drive_rd_addr = 21'h1000;
  integer last_req_cycle = -1;
  integer trace_file;
  reg [1023:0] trace_path;
  logic rst_n = 1'b1;
  integer measure_start_cycle;
  integer start_aref;
  integer start_req;
  integer start_ack;
  integer elapsed;
  integer inject_req;
  integer i;
  integer req_unknown_cycles = 0;
  integer ack_unknown_cycles = 0;
  logic req_prev = 1'b0;
  logic ack_prev = 1'b0;
  wire ref_req = dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/Sdr_ref_req_syn_4 ;
  wire ref_ack = dut.\u_frame_buffer/u_sdram/u2_ram/u1_init_ref/Sdr_ref_ack ;
  wire init_done = dut.\u_frame_buffer/u_sdram/u2_ram/u1_init_ref/init_done_reg_syn_5 ;
  wire busy = dut.\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/Sdr_busy ;
  wire refresh_valid = dut.\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/Sdr_init_ref_vld ;
  wire ref_ack_direct = dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/ref_ack ;
  wire ref_ack_after_rw = dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/wrrd_ref_ack ;
  wire ref_pending = dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/ref_vld ;
  wire rw_valid = dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/rw_vld ;
  wire rw_over = dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/sdr_op_over ;
  wire [2:0] init_command = {dut.\u_frame_buffer/u_sdram/u2_ram/u1_init_ref/Sdr_init_ref_ras ,
      dut.\u_frame_buffer/u_sdram/u2_ram/u1_init_ref/Sdr_init_ref_cas ,
      dut.\u_frame_buffer/u_sdram/u2_ram/u1_init_ref/Sdr_init_ref_we };
  wire [2:0] rw_command = {dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/ras ,
      dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/cas ,
      dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/we };

  always #10 tb_clk = ~tb_clk;
  always @(posedge tb_sft_clk) begin
    if(measure_active && trace_file)
      $fdisplay(trace_file,"%0d,%0t,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%h,%h",
        phy_cycle,$time,ref_req,ref_ack,ref_ack_direct,ref_ack_after_rw,ref_pending,
        rw_valid,rw_over,busy,refresh_valid,drive_wr,drive_rd,
        {dut.ras_n,dut.cas_n,dut.we_n},drive_wr_addr,drive_rd_addr);
  end
  initial begin #8; forever #10 tb_sft_clk = ~tb_sft_clk; end
  always @(negedge tb_clk) begin
    traffic_cycle = traffic_cycle + 1;
    drive_wr = 0;
    drive_rd = 0;
    if(TRAFFIC && measure_active) begin
      if(burst_left > 0) begin
        if(burst_write) begin drive_wr = 1; drive_wr_addr = drive_wr_addr+1; end
        else begin drive_rd = 1; drive_rd_addr = drive_rd_addr+1; end
        burst_left = burst_left-1;
        if(burst_left == 0) cooldown = 16;
      end else if(cooldown > 0) cooldown = cooldown-1;
      else if(busy === 1'b0 && refresh_valid === 1'b0) begin
        burst_write = TRAFFIC == 2 ? 1 : TRAFFIC == 3 ? 0 : next_write;
        next_write = !next_write;
        burst_left = 3;
        if(burst_write) begin
          drive_wr_addr = (drive_wr_addr+4) & 21'h1ffffc;
          drive_wr = 1;
        end else begin
          drive_rd_addr = (drive_rd_addr+4) & 21'h1ffffc;
          drive_rd = 1;
        end
      end
    end
  end

  gate_refresh_top dut (
    .clk(tb_clk), .key1(1'b1), .key2(1'b1), .rst_n(rst_n), .sd_miso(1'b1),
    .HDMI_CLK_P(), .HDMI_D0_P(), .HDMI_D1_P(), .HDMI_D2_P(), .led(),
    .sd_dclk(), .sd_mosi(), .sd_ncs(), .seg7_dio(), .seg7_rclk(), .seg7_sclk()
  );

  always @(posedge tb_clk) begin
    #1ps;
    if (measure_active) begin
      if (ref_req !== 1'b0 && ref_req !== 1'b1)
        req_unknown_cycles = req_unknown_cycles + 1;
      if (ref_ack !== 1'b0 && ref_ack !== 1'b1)
        ack_unknown_cycles = ack_unknown_cycles + 1;
      if ((ref_req === 1'b1) && (req_prev === 1'b0)) begin
        req_rises = req_rises + 1;
        if(!CASE_C40 && last_req_cycle >= 0 && phy_cycle-last_req_cycle != 781)
          $fatal(1,"mapped periodic request gap=%0d expected781",phy_cycle-last_req_cycle);
        last_req_cycle = phy_cycle;
      end
      if ((ref_ack === 1'b1) && (ack_prev === 1'b0)) ack_rises = ack_rises + 1;
      req_prev = (ref_req === 1'b1);
      ack_prev = (ref_ack === 1'b1);
    end
  end

  initial begin
    if (!$value$plusargs("INJECT_REQ=%d", inject_req)) inject_req = 0;
    trace_file=0;
    if($value$plusargs("TRACE=%s",trace_path)) begin
      trace_file=$fopen(trace_path,"w");
      $fdisplay(trace_file,"cycle,time,req,ack,direct_ack,rw_ack,pending,rw_valid,rw_over,busy,refresh_valid,wr,rd,cmd,wraddr,rdaddr");
    end

    // Simulation-only clock binding. The functional clock model and physical SDRAM
    // clock input are driven at the same 20ns period used by the C40 project.
    force dut.\sys_pll_m0/clk0_buf  = tb_clk;
    force dut.\u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/mem_clk  = tb_clk;
    force dut.\u_frame_buffer/u_sdram/u2_ram/Sdr_clk_sft  = tb_sft_clk;
    force dut.clk0 = tb_sft_clk;
    force dut.rst_all = 1'b1;
    force dut.\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/App_wr_en  = drive_wr;
    force dut.\u_frame_buffer/u_sdram/u2_ram/App_rd_en  = drive_rd;
    force dut.\u_frame_buffer/u_sdram/u2_ram/App_wr_addr  = drive_wr_addr;
    force dut.\u_frame_buffer/u_sdram/u2_ram/App_rd_addr  = drive_rd_addr;
    force dut.\u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/App_rd_addr  = drive_rd_addr;
    force dut.\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/App_wr_addr_r  = drive_wr_addr;
    repeat (5) @(posedge tb_clk);
    force dut.rst_all = 1'b0;
    repeat (4) @(posedge tb_clk);

    // Skip only the 200ms power-up counter; let the mapped production init sequence run.
    force dut.\u_frame_buffer/u_sdram/u2_ram/u1_init_ref/pwr_200ms_cnt  = 18'h20000;
    repeat (4) @(posedge tb_clk);
    release dut.\u_frame_buffer/u_sdram/u2_ram/u1_init_ref/pwr_200ms_cnt ;

    for (i = 0; i < 4000; i = i + 1) begin
      @(posedge tb_clk);
      #1ps;
      if (init_done === 1'b1) i = 4000;
    end
    if (init_done !== 1'b1) $fatal(1, "gate SDRAM init_done timeout");

    // Keep the controller idle so only init and refresh commands reach the device shell.
    if(!TRAFFIC) force dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/rw_vld  = 1'b0;
    repeat (32) @(posedge tb_clk);

    measure_active = 1'b1;
    measure_start_cycle = phy_cycle;
    start_aref = aref_count;
    start_req = req_rises;
    start_ack = ack_rises;

    if ((CASE_C40 != 0) && (inject_req != 0)) begin
      // C40's mapped producer net is tied low; this one-cycle force injects one
      // scheduler request without altering the gate file or its constant driver.
      @(negedge tb_clk);
      force dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/Sdr_ref_req  = 1'b1;
      @(negedge tb_clk);
      release dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/Sdr_ref_req ;
    end

    elapsed = 0;
    while ((elapsed < MAX_MEASURE_CYCLES) &&
           ((aref_count-start_aref) < TARGET_AREFS || TARGET_AREFS <= 0)) begin
      @(posedge tb_clk);
      elapsed = elapsed + 1;
    end
    repeat (20) @(posedge tb_clk);
    measure_active = 1'b0;
    if (command_unknown_cycles != 0 || req_unknown_cycles != 0 || ack_unknown_cycles != 0)
      $fatal(1, "unknown command/request/ack samples: cmd=%0d req=%0d ack=%0d",
             command_unknown_cycles, req_unknown_cycles, ack_unknown_cycles);
    if ((CASE_C40 != 0) && (inject_req == 0) &&
        ((aref_count-start_aref) != 0 || (req_rises-start_req) != 0 || (ack_rises-start_ack) != 0))
      $fatal(1, "C40 no-injection control observed refresh activity");
    if ((CASE_C40 != 0) && (inject_req != 0) &&
        ((req_rises-start_req) != 1 || (ack_rises-start_ack) < 1 || (aref_count-start_aref) < 1))
      $fatal(1, "C40 one-request injection did not produce request, ack, and AREF");
    if ((CASE_C40 == 0) && ((aref_count-start_aref) < TARGET_AREFS))
      $fatal(1, "C41 target AREF command count was not reached");
    if((CASE_C40 == 0) && (req_rises-start_req != aref_count-start_aref || ack_rises-start_ack != aref_count-start_aref))
      $fatal(1,"mapped request/ack/AREF counts differ req=%0d ack=%0d aref=%0d",req_rises-start_req,ack_rises-start_ack,aref_count-start_aref);
    if(TRAFFIC == 1 && (write_count == 0 || read_count == 0)) $fatal(1,"traffic test emitted no read/write commands");
    if(TRAFFIC == 2 && write_count == 0) $fatal(1,"write test emitted no write commands");
    if(TRAFFIC == 3 && read_count == 0) $fatal(1,"read test emitted no read commands");
    $display("GATE_REFRESH_SUMMARY case=%0d inject_req=%0d traffic=%0d measured_cycles=%0d req_rises=%0d ack_rises=%0d aref_commands=%0d writes=%0d reads=%0d",
             CASE_C40, inject_req, TRAFFIC,elapsed,
             req_rises-start_req, ack_rises-start_ack, aref_count-start_aref,write_count,read_count);
    $display("GATE_REFRESH_COMPLETE");
    $finish;
  end

  initial begin
    #1000000;
    $fatal(1, "absolute gate refresh bench timeout");
  end
endmodule

