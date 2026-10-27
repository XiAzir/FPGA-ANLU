`timescale 1ns/1ps
`define SIMULATION
`include "../../player_video42_sdram100/src/user_source/hdl_source/SD/sdram.v"

// Prepared only; instantiate the production sdram.v startup gate.
module tb_startup_refresh_gate;
  reg clk = 1'b0;
  reg rst = 1'b1;
  reg raw_done = 1'b0;
  reg raw_ref_valid = 1'b0;
  wire external_done;
  wire external_ref_valid;
  wire busy;
  wire rd_en;
  wire [31:0] rd_data;
  wire sdram_clk, ras_n, cas_n, we_n;
  wire [1:0] ba;
  wire [10:0] addr;
  wire [3:0] dm;
  tri [31:0] dq;

  always #5 clk = ~clk;

  sdram dut (
    .Clk(clk), .Clk_sft(clk), .Rst(rst),
    .Sdr_init_done(external_done),
    .Sdr_init_ref_vld(external_ref_valid),
    .Sdr_busy(busy),
    .App_wr_en(1'b0), .App_wr_addr(21'b0), .App_wr_dm(4'b0),
    .App_wr_din(32'b0), .App_rd_en(1'b0), .App_rd_addr(21'b0),
    .Sdr_rd_en(rd_en), .Sdr_rd_dout(rd_data),
    .SDRAM_CLK(sdram_clk), .SDR_CKE(), .SDR_RAS(ras_n),
    .SDR_CAS(cas_n), .SDR_WE(we_n), .SDR_BA(ba), .SDR_ADDR(addr),
    .SDR_DM(dm), .SDR_DQ(dq)
  );

  task automatic tick;
    @(posedge clk);
    #1;
  endtask

  task automatic expect_done(input bit value, input [8*96-1:0] message);
    if (external_done !== value)
      $fatal(1, "%0s: external_done=%b expected=%b",
             message, external_done, value);
  endtask

  task automatic ref_pulse;
    raw_ref_valid = 1'b1;
    tick();
    raw_ref_valid = 1'b0;
    tick();
  endtask

  initial begin
    tick();
    rst = 1'b0;

    // The raw initialization-valid fall coincides with raw init-done rising.
    raw_ref_valid = 1'b1;
    tick();
    raw_done = 1'b1;
    raw_ref_valid = 1'b0;
    tick();
    tick();
    expect_done(1'b0, "initialization ref_valid fall is excluded");

    ref_pulse();
    expect_done(1'b0, "one periodic AREF completion is insufficient");

    // Reset after one completion aborts startup qualification and clears ready.
    rst = 1'b1;
    raw_done = 1'b0;
    raw_ref_valid = 1'b0;
    #1;
    expect_done(1'b0, "reset aborts partial startup qualification");
    tick();
    rst = 1'b0;

    raw_ref_valid = 1'b1;
    tick();
    raw_done = 1'b1;
    raw_ref_valid = 1'b0;
    tick();
    tick();
    expect_done(1'b0, "restarted initialization-valid fall is excluded");

    ref_pulse();
    expect_done(1'b0, "restart requires two new periodic AREF completions");
    ref_pulse();
    expect_done(1'b1, "second post-restart AREF releases external ready");

    raw_done = 1'b0;
    #1;
    if (dut.u2_ram.Sdr_init_done !== 1'b0)
      $fatal(1, "raw controller done is not passed into the SIP stub");
    expect_done(1'b1, "raw controller done remains independent after release");
    $display("TB_STARTUP_REFRESH_GATE_PASS");
    $finish;
  end
endmodule

// Stub implementation for isolated wrapper qualification only.
module sdr_as_ram #(
  parameter self_refresh_open = 1
) (
  input Sdr_clk, input Sdr_clk_sft, input Rst,
  output Sdr_init_done, output Sdr_init_ref_vld, output Sdr_busy,
  input App_ref_req, input App_wr_en,
  input [`ADDR_WIDTH-1:0] App_wr_addr,
  input [`DM_WIDTH-1:0] App_wr_dm,
  input [`DATA_WIDTH-1:0] App_wr_din,
  input App_rd_en, input [`ADDR_WIDTH-1:0] App_rd_addr,
  output Sdr_rd_en, output [`DATA_WIDTH-1:0] Sdr_rd_dout,
  output SDRAM_CLK, output SDR_RAS, output SDR_CAS, output SDR_WE,
  output [`BA_WIDTH-1:0] SDR_BA,
  output [`ROW_WIDTH-1:0] SDR_ADDR,
  output [`DM_WIDTH-1:0] SDR_DM,
  inout [`DATA_WIDTH-1:0] SDR_DQ
);
  assign Sdr_init_done = tb_startup_refresh_gate.raw_done;
  assign Sdr_init_ref_vld = tb_startup_refresh_gate.raw_ref_valid;
  assign Sdr_busy = 1'b0;
  assign Sdr_rd_en = 1'b0;
  assign Sdr_rd_dout = {`DATA_WIDTH{1'b0}};
  assign SDRAM_CLK = Sdr_clk_sft;
  assign SDR_RAS = 1'b1;
  assign SDR_CAS = 1'b1;
  assign SDR_WE = 1'b1;
  assign SDR_BA = {`BA_WIDTH{1'b0}};
  assign SDR_ADDR = {`ROW_WIDTH{1'b0}};
  assign SDR_DM = {`DM_WIDTH{1'b0}};
  assign SDR_DQ = {`DATA_WIDTH{1'bz}};
endmodule

module EG_PHY_SDRAM_2M_32 (
  input clk, input ras_n, input cas_n, input we_n,
  input [10:0] addr, input [1:0] ba, inout [31:0] dq,
  input cs_n, input dm0, input dm1, input dm2, input dm3, input cke
);
endmodule
