`timescale 1ns/1ps
module tb_gate_refresh;
  import gate_refresh_metrics::*;
  parameter integer CASE_C40 = 1;
  parameter integer USE_PUBLIC_INIT_DONE = 0;
  parameter integer MAX_MEASURE_CYCLES = 12000;
  parameter integer TARGET_AREFS = 10;
  parameter integer TRAFFIC = 0;
  parameter integer ACK_EDGE = 0;
  parameter integer BURST_WORDS = 4;
  parameter integer MEM_PERIOD_NS = 10;
  parameter integer SHIFT_DELAY_NS = 4;
  parameter integer EXPECT_REFRESH_CYCLES = 1562;
  parameter integer INJECT_READ_BIT_ERROR = 0;
  parameter integer CAPTURE_MODE = 2;
  parameter integer DIAGNOSE_MISSING_INIT_AREF = 0;
  parameter integer T_RC_NS = 63, T_RCD_NS = 21, T_RP_NS = 21;
  parameter integer T_RAS_NS = 42, T_WR_CYCLES = 2, T_RFC_NS = 63;
  parameter integer T_RRD_NS = 14, T_MRD_CYCLES = 2;
  logic previous_ack = 0;
  logic edge_stage0 = 0;

  logic tb_clk = 1'b0;
  logic tb_sft_clk = 1'b0;
  logic drive_wr = 1'b0;
  logic drive_rd = 1'b0;
  logic traffic_stop = 1'b0;
  integer traffic_cycle = 0;
  integer burst_left = 0;
  integer cooldown = 0;
  logic burst_write = 1;
  logic next_write = 1;
  logic [20:0] drive_wr_addr = 0;
  logic [20:0] drive_rd_addr = 0;
  logic [31:0] drive_wr_data;
  logic [31:0] expected_mem [0:65535];
  logic [31:0] expected_reads [0:65535];
  logic [31:0] raw_data_previous = 32'bx;
  integer expected_valid [0:65535];
  integer write_accepts=0, read_requests=0, read_returns=0;
  integer raw_current_matches=0, raw_previous_matches=0, capture_matches=0;
  integer last_req_cycle = -1;
  integer trace_file;
  integer init_trace_file;
  integer app_trace_file;
  integer app_write_trace_count=0, app_read_trace_count=0, app_return_trace_count=0;
  reg [1023:0] trace_path;
  reg [1023:0] init_trace_path;
  reg [1023:0] app_trace_path;
  integer init_aref_missing=0;
  logic rst_n = 1'b1;
  logic pin_check_enable = 1'b0;
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
  wire init_done;
  generate
    if(USE_PUBLIC_INIT_DONE) begin : g_public_init_done
      assign init_done = dut.\u_frame_buffer/u_legacy_frame_backend/Sdr_init_done ;
    end else begin : g_internal_init_done
      assign init_done = dut.\u_frame_buffer/u_sdram/u2_ram/u1_init_ref/init_done_reg_syn_5 ;
    end
  endgenerate
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

  function automatic [31:0] test_pattern(input [20:0] address);
    test_pattern=32'h5a39_c6e1 ^ (address * 32'h0103_070b) ^ {address[7:0],address[20:13],address[12:8],11'h35a};
  endfunction
  always_comb drive_wr_data = test_pattern(drive_wr_addr);

  always #(MEM_PERIOD_NS/2) tb_clk = ~tb_clk;
  always @(posedge tb_clk) begin
    previous_ack <= ref_ack;
    edge_stage0 <= ref_ack && !previous_ack;
  end
  always @(posedge tb_sft_clk) begin
    if(measure_active && trace_file)
      $fdisplay(trace_file,"%0d,%0t,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%h,%h",
        phy_cycle,$time,ref_req,ref_ack,ref_ack_direct,ref_ack_after_rw,ref_pending,
        rw_valid,rw_over,busy,refresh_valid,drive_wr,drive_rd,
        {dut.ras_n,dut.cas_n,dut.we_n},drive_wr_addr,drive_rd_addr);
  end
  initial begin #(SHIFT_DELAY_NS); forever #(MEM_PERIOD_NS/2) tb_sft_clk = ~tb_sft_clk; end
  initial begin
    init_trace_file=0;
    if($value$plusargs("INIT_TRACE=%s",init_trace_path)) begin
      init_trace_file=$fopen(init_trace_path,"w");
      if(init_trace_file==0) $fatal(1,"cannot open raw init pin trace");
      $fdisplay(init_trace_file,"time_ns,cycle,check_enable,cs_n,cke,ras_cas_we,ba,addr");
    end
  end
  always @(posedge dut.clk0) begin
    if(init_trace_file && !measure_active)
      $fdisplay(init_trace_file,"%0.3f,%0d,%b,%b,%b,%b,%b,%h",$realtime,phy_cycle,pin_check_enable,
        dut.cs_n,dut.cke,{dut.ras_n,dut.cas_n,dut.we_n},
        dut.\u_frame_buffer/u_sdram/sdram .ba,dut.\u_frame_buffer/u_sdram/sdram .addr);
  end
  always @(negedge tb_clk) begin
    traffic_cycle = traffic_cycle + 1;
    drive_wr = 0;
    drive_rd = 0;
    if(TRAFFIC && measure_active && !traffic_stop) begin
      if(burst_left > 0) begin
        if(burst_write) begin drive_wr = 1; drive_wr_addr = drive_wr_addr+1; end
        else begin drive_rd = 1; drive_rd_addr = drive_rd_addr+1; end
        burst_left = burst_left-1;
        if(burst_left == 0) cooldown = 16;
      end else if(cooldown > 0) cooldown = cooldown-1;
      else if(busy === 1'b0 && refresh_valid === 1'b0) begin
        burst_write = TRAFFIC == 2 ? 1 : TRAFFIC == 3 ? 0 : next_write;
        next_write = !next_write;
        burst_left = BURST_WORDS-1;
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

  wire app_wr_en = dut.\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/App_wr_en ;
  wire [20:0] app_wr_addr = dut.\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/App_wr_addr_r ;
  wire [31:0] app_wr_din = dut.\u_frame_buffer/u_sdram/u2_ram/App_wr_din ;
  wire app_rd_en = dut.\u_frame_buffer/u_sdram/u2_ram/App_rd_en ;
  wire [20:0] app_rd_addr = dut.\u_frame_buffer/u_sdram/u2_ram/App_rd_addr ;
  wire app_rd_valid = dut.\u_frame_buffer/u_legacy_frame_backend/Sdr_rd_en ;
  wire [31:0] app_rd_raw = dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/Sdr_rd_dout ;
`ifdef PRODUCTION_DATA_DELAY0
  wire [31:0] app_rd_capture = app_rd_raw;
`else
  wire [31:0] app_rd_capture = dut.\u_frame_buffer/u_legacy_frame_backend/read_capture_data ;
`endif

  initial begin
    app_trace_file=0;
    if($value$plusargs("APP_TRACE=%s",app_trace_path)) begin
      app_trace_file=$fopen(app_trace_path,"w");
      if(app_trace_file==0) $fatal(1,"cannot open app/controller pipeline trace");
      $fdisplay(app_trace_file,"time_ns,event,drive_addr,drive_data,app_wr_en,app_wr_addr,app_wr_din,addr1d,addr2d,addr3d,addr4d,din6d,app_rd_en,app_rd_addr,rd_valid,rd_raw,rd_capture,dq");
    end
  end
  always @(posedge tb_clk) begin
    if(measure_active && app_trace_file &&
       ((app_wr_en && app_write_trace_count<16) || (app_rd_en && app_read_trace_count<16) ||
        (app_rd_valid && app_return_trace_count<16))) begin
      #1ps;
      if(app_wr_en && app_write_trace_count<16) begin
        $fdisplay(app_trace_file,"%0t,WRITE,%h,%h,%b,%h,%h,%h,%h,%h,%h,%h,%b,%h,%b,%h,%h,%h",
          $time,drive_wr_addr,drive_wr_data,app_wr_en,app_wr_addr,app_wr_din,
          dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_addr_1d,
          dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_addr_2d,
          dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_addr_3d,
          dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_addr_4d,
          dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_din_6d,
          app_rd_en,app_rd_addr,app_rd_valid,app_rd_raw,app_rd_capture,
          dut.\u_frame_buffer/u_sdram/sdram .dq);
        app_write_trace_count=app_write_trace_count+1;
      end
      if(app_rd_en && app_read_trace_count<16) begin
        $fdisplay(app_trace_file,"%0t,READ_REQ,%h,%h,%b,%h,%h,%h,%h,%h,%h,%h,%b,%h,%b,%h,%h,%h",
          $time,drive_rd_addr,drive_wr_data,app_wr_en,app_wr_addr,app_wr_din,
          dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_addr_1d,
          dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_addr_2d,
          dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_addr_3d,
          dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_addr_4d,
          dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_din_6d,
          app_rd_en,app_rd_addr,app_rd_valid,app_rd_raw,app_rd_capture,
          dut.\u_frame_buffer/u_sdram/sdram .dq);
        app_read_trace_count=app_read_trace_count+1;
      end
      if(app_rd_valid && app_return_trace_count<16) begin
        $fdisplay(app_trace_file,"%0t,READ_RETURN,%h,%h,%b,%h,%h,%h,%h,%h,%h,%h,%b,%h,%b,%h,%h,%h",
          $time,drive_rd_addr,drive_wr_data,app_wr_en,app_wr_addr,app_wr_din,
          dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_addr_1d,
          dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_addr_2d,
          dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_addr_3d,
          dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_addr_4d,
          dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_din_6d,
          app_rd_en,app_rd_addr,app_rd_valid,app_rd_raw,app_rd_capture,
          dut.\u_frame_buffer/u_sdram/sdram .dq);
        app_return_trace_count=app_return_trace_count+1;
      end
    end
  end

  sdram_timing_checker #(.CLOCK_NS(MEM_PERIOD_NS), .T_RFC_NS(T_RFC_NS),
    .REQUIRE_INIT_AREF(!DIAGNOSE_MISSING_INIT_AREF),
    .T_RRD_NS(T_RRD_NS), .T_MRD_CYCLES(T_MRD_CYCLES)) pin_checker (
    .clk(dut.clk0), .cs_n(dut.cs_n), .cke(dut.cke), .ras_n(dut.ras_n),
    .cas_n(dut.cas_n), .we_n(dut.we_n),
    .ba(dut.\u_frame_buffer/u_sdram/sdram .ba),
    .addr(dut.\u_frame_buffer/u_sdram/sdram .addr), .enable(pin_check_enable)
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
        if(!CASE_C40 && last_req_cycle >= 0 && phy_cycle-last_req_cycle != EXPECT_REFRESH_CYCLES)
          $fatal(1,"mapped periodic request gap=%0d expected%0d",phy_cycle-last_req_cycle,EXPECT_REFRESH_CYCLES);
        last_req_cycle = phy_cycle;
      end
      if ((ref_ack === 1'b1) && (ack_prev === 1'b0)) ack_rises = ack_rises + 1;
      req_prev = (ref_req === 1'b1);
      ack_prev = (ref_ack === 1'b1);
    end
  end

  always @(posedge tb_clk) begin
    if (measure_active) begin
      if (app_wr_en === 1'b1) begin
        if ((^app_wr_addr === 1'bx) || (^app_wr_din === 1'bx) || app_wr_addr[20:16] != 0)
          $fatal(1,"unknown or out-of-range controller write addr=%h data=%h",app_wr_addr,app_wr_din);
        expected_mem[app_wr_addr[15:0]]=app_wr_din;
        expected_valid[app_wr_addr[15:0]]=1;
        write_accepts=write_accepts+1;
      end
      if (app_rd_en === 1'b1) begin
        if ((^app_rd_addr === 1'bx) || app_rd_addr[20:16] != 0 || expected_valid[app_rd_addr[15:0]] !== 1)
          $fatal(1,"read request precedes matching write or address is invalid addr=%h",app_rd_addr);
        expected_reads[read_requests]=expected_mem[app_rd_addr[15:0]];
        read_requests=read_requests+1;
      end
      if (app_rd_valid === 1'b1) begin
        if (read_returns >= read_requests) $fatal(1,"unexpected SDRAM read return without request");
        #1ps;
        if (read_returns < 12)
          $display("READ_WORD index=%0d expected=%h raw=%h previous=%h captured=%h dq=%h time=%0.3f",
            read_returns,expected_reads[read_returns],app_rd_raw,raw_data_previous,app_rd_capture,
            dut.\u_frame_buffer/u_sdram/sdram .dq,$realtime);
        if ((^app_rd_raw !== 1'bx) && app_rd_raw === expected_reads[read_returns])
          raw_current_matches=raw_current_matches+1;
        if ((^raw_data_previous !== 1'bx) && raw_data_previous === expected_reads[read_returns])
          raw_previous_matches=raw_previous_matches+1;
        if (INJECT_READ_BIT_ERROR && read_returns == 0)
          force dut.\u_frame_buffer/u_legacy_frame_backend/read_capture_data [0] = ~expected_reads[read_returns][0];
        if ((^app_rd_capture !== 1'bx) && app_rd_capture === expected_reads[read_returns])
          capture_matches=capture_matches+1;
        read_returns=read_returns+1;
      end
      raw_data_previous=app_rd_raw;
    end
  end

  initial begin
    if (!$value$plusargs("INJECT_REQ=%d", inject_req)) inject_req = 0;
    trace_file=0;
    if($value$plusargs("TRACE=%s",trace_path)) begin
      trace_file=$fopen(trace_path,"w");
      $fdisplay(trace_file,"cycle,time,req,ack,direct_ack,rw_ack,pending,rw_valid,rw_over,busy,refresh_valid,wr,rd,cmd,wraddr,rdaddr");
    end

    // Simulation-only clock and reset binding; gate sources remain unchanged.
    force dut.\sys_pll_m0/clk0_buf  = tb_clk;
    force dut.\u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/mem_clk  = tb_clk;
    force dut.\u_frame_buffer/u_sdram/u2_ram/Sdr_clk_sft  = tb_sft_clk;
    force dut.clk0 = tb_sft_clk;
    force dut.rst_all = 1'b1;
    if(ACK_EDGE) force dut.\u_frame_buffer/u_sdram/u2_ram/u1_init_ref/sdr_ref_ack_sft [0] = edge_stage0;
    force dut.\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/App_wr_en = drive_wr;
    force dut.\u_frame_buffer/u_sdram/u2_ram/App_wr_din = drive_wr_data;
    force dut.\u_frame_buffer/u_sdram/u2_ram/App_rd_en  = drive_rd;
    force dut.\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/App_wr_addr_r = drive_wr_addr;
    force dut.\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/jpeg_mode_latch = 1'b0;
    force dut.\u_frame_buffer/u_sdram/u2_ram/App_rd_addr  = drive_rd_addr;
    repeat (5) @(posedge tb_clk);
    force dut.rst_all = 1'b0;
    repeat (4) @(posedge tb_clk);
    pin_check_enable=1'b1;

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
    if (pin_checker.mrs_count < 1 || pin_checker.pre_all_count < 1)
      $fatal(1,"init_done before PRE ALL/MRS: pre=%0d mrs=%0d aref=%0d",
             pin_checker.pre_all_count,pin_checker.mrs_count,pin_checker.aref_count);
    if (pin_checker.aref_count < 2) begin
      init_aref_missing=1;
      $display("INIT_AREF_MISSING pre=%0d mrs=%0d aref=%0d time_ns=%0t",
        pin_checker.pre_all_count,pin_checker.mrs_count,pin_checker.aref_count,$time);
      if(!DIAGNOSE_MISSING_INIT_AREF) $fatal(1,"init_done before two AREF commands");
    end else $display("INIT_SEQUENCE_PASS pre=%0d mrs=%0d aref=%0d time_ns=%0t",
      pin_checker.pre_all_count,pin_checker.mrs_count,pin_checker.aref_count,$time);

    // Application enables stay low in the idle case; the controller determines its state.
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
    traffic_stop=1'b1;
    for(i=0;i<5000;i=i+1) begin
      @(posedge tb_clk);
      if(read_returns>=read_requests && busy===1'b0 && rw_valid===1'b0) i=5000;
    end
    if(read_returns<read_requests || busy!==1'b0 || rw_valid!==1'b0)
      $fatal(1,"application traffic did not drain reads=%0d returns=%0d busy=%b rw_valid=%b",read_requests,read_returns,busy,rw_valid);
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
    if((CASE_C40 == 0) && (req_rises-start_req != aref_count-start_aref || ack_rises-start_ack < aref_count-start_aref))
      $fatal(1,"mapped request/ack/AREF counts differ req=%0d ack=%0d aref=%0d",req_rises-start_req,ack_rises-start_ack,aref_count-start_aref);
    if(TRAFFIC == 1 && (write_count == 0 || read_count == 0)) $fatal(1,"traffic test emitted no read/write commands");
    if(TRAFFIC == 1 && (write_accepts == 0 || read_requests == 0 || read_returns == 0 || read_returns != read_requests))
      $fatal(1,"application scoreboard incomplete writes=%0d reads=%0d returns=%0d",write_accepts,read_requests,read_returns);
    if(TRAFFIC == 1) begin
      $display("READ_ALIGNMENT raw_current=%0d raw_previous=%0d production_capture=%0d total=%0d mode=%0d",
        raw_current_matches,raw_previous_matches,capture_matches,read_returns,CAPTURE_MODE);
      case(CAPTURE_MODE)
        0: if(raw_current_matches!=read_returns) $fatal(1,"strict raw-current scoreboard mismatch");
        1: if(raw_previous_matches!=read_returns) $fatal(1,"strict raw-previous scoreboard mismatch");
        2: if(capture_matches!=read_returns) $fatal(1,"strict production capture scoreboard mismatch");
        default: $fatal(1,"invalid CAPTURE_MODE=%0d",CAPTURE_MODE);
      endcase
      $display("DATA_SCOREBOARD_PASS writes=%0d reads=%0d returns=%0d",write_accepts,read_requests,read_returns);
    end
    if(TRAFFIC == 2 && write_count == 0) $fatal(1,"write test emitted no write commands");
    if(TRAFFIC == 3 && read_count == 0) $fatal(1,"read test emitted no read commands");
    $display("GATE_REFRESH_SUMMARY case=%0d inject_req=%0d traffic=%0d measured_cycles=%0d req_rises=%0d ack_rises=%0d aref_commands=%0d writes=%0d reads=%0d",
             CASE_C40, inject_req, TRAFFIC,elapsed,
             req_rises-start_req, ack_rises-start_ack, aref_count-start_aref,write_count,read_count);
    $display("GATE_REFRESH_COMPLETE");
    if(trace_file) $fclose(trace_file);
    if(init_trace_file) $fclose(init_trace_file);
    if(app_trace_file) $fclose(app_trace_file);
    $finish;
  end

  initial begin
    #1000000;
    $fatal(1, "absolute gate refresh bench timeout");
  end
endmodule

module sdram_timing_checker #(
  parameter integer CLOCK_NS=10,
  parameter integer REQUIRE_INIT_AREF=1,
  parameter integer T_RFC_NS=63,
  parameter integer T_RRD_NS=14,
  parameter integer T_MRD_CYCLES=2
) (
  input wire clk, cs_n, cke, ras_n, cas_n, we_n,
  input wire enable,
  input wire [1:0] ba,
  input wire [10:0] addr
);
  integer cycle=0, t_rfc, t_rrd, t_mrd;
  integer last_act=-1000000, last_mrs=-1000000, last_act_bank=-1;
  integer mrs_count=0, aref_count=0, act_count=0, read_count=0, write_count=0, pre_count=0;
  integer pre_all_count=0;
  integer last_aref=-1000000;
  initial begin
    t_rfc=(T_RFC_NS+CLOCK_NS-1)/CLOCK_NS;
    t_rrd=(T_RRD_NS+CLOCK_NS-1)/CLOCK_NS; t_mrd=T_MRD_CYCLES;
  end
  always @(posedge clk) begin
    cycle=cycle+1;
    if (enable && ((cs_n !== 1'b0 && cs_n !== 1'b1) || (cke !== 1'b0 && cke !== 1'b1) ||
        (ras_n !== 1'b0 && ras_n !== 1'b1) || (cas_n !== 1'b0 && cas_n !== 1'b1) ||
        (we_n !== 1'b0 && we_n !== 1'b1))) $fatal(1,"SDRAM unknown command pin cycle=%0d",cycle);
    if(enable && !cs_n && cke) begin
      case({ras_n,cas_n,we_n})
        3'b000: begin
          mrs_count=mrs_count+1;
          if(mrs_count==1 && pre_all_count<1)
            $fatal(1,"initialization MRS preceded PRE ALL");
          if((^{ba,addr}) === 1'bx) $fatal(1,"unknown MRS bank/address");
          if(!(addr[2:0]==3'b010 || addr[2:0]==3'b011 || addr[2:0]==3'b111))
            $fatal(1,"unsupported MRS burst length mode=%h",addr[2:0]);
          last_mrs=cycle;
        end
        3'b001: begin
          aref_count=aref_count+1;
          if(cycle-last_mrs<t_mrd) $fatal(1,"tMRD violation before AREF");
          if(cycle-last_aref<t_rfc) $fatal(1,"tRFC violation gap=%0d min=%0d",cycle-last_aref,t_rfc);
          last_aref=cycle;
        end
        3'b010: begin
          pre_count=pre_count+1;
          if((^{ba,addr}) === 1'bx) $fatal(1,"unknown PRE bank/address");
          if(addr[10]) pre_all_count=pre_all_count+1;
        end
        3'b011: begin
          act_count=act_count+1;
          if(cycle-last_mrs<t_mrd) $fatal(1,"tMRD violation before ACT");
          if((^{ba,addr}) === 1'bx) $fatal(1,"unknown ACT bank/address");
          if(last_act_bank>=0 && last_act_bank!=ba && cycle-last_act<t_rrd)
            $fatal(1,"tRRD violation gap=%0d min=%0d",cycle-last_act,t_rrd);
          last_act=cycle; last_act_bank=ba;
        end
        3'b100: begin
          write_count=write_count+1;
        end
        3'b101: begin
          read_count=read_count+1;
        end
        default: begin end
      endcase
    end
  end
  final begin
    if(mrs_count<1 || (REQUIRE_INIT_AREF && aref_count<2) || act_count<1 || read_count<1 || write_count<1 || pre_count<1)
      $fatal(1,"SDRAM command coverage MRS=%0d AREF=%0d ACT=%0d READ=%0d WRITE=%0d PRE=%0d",mrs_count,aref_count,act_count,read_count,write_count,pre_count);
    $display("SDRAM_PIN_SUMMARY MRS=%0d AREF=%0d ACT=%0d READ=%0d WRITE=%0d PRE=%0d",mrs_count,aref_count,act_count,read_count,write_count,pre_count);
  end
endmodule

