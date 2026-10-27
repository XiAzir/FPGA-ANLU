`timescale 1ns/1ps

`ifndef SDRAM_T_DPL_NS
`define SDRAM_T_DPL_NS 20
`endif

package gate_refresh_metrics;
  integer phy_cycle=0, aref_count=0, req_rises=0, ack_rises=0;
  integer write_count=0, read_count=0, command_unknown_cycles=0;
  bit measure_active=0;
endpackage

// Simulation binding for the official APUG011 IS42s32200 bus-functional model.
// Timing parameters are overrideable after confirming the EM638325 speed grade.
module EG_PHY_SDRAM_2M_32 #(
  parameter real T_AC = 5.4,
  parameter real T_HZ = 5.4,
  parameter real T_OH = 2.5,
  parameter real T_MRD = 2.0,
  parameter real T_RAS = 42.0,
  parameter real T_RC = 63.0,
  parameter real T_RCD = 21.0,
  parameter real T_RP = 21.0,
  parameter real T_RRD = 14.0,
  parameter real T_DPL = `SDRAM_T_DPL_NS,
  parameter integer MEM_WORDS_PER_BANK = 524288
) (
  input wire [10:0] addr,
  input wire [1:0] ba,
  input wire cas_n,
  input wire cke,
  input wire clk,
  input wire cs_n,
  input wire dm0, dm1, dm2, dm3,
  input wire ras_n,
  input wire we_n,
  inout wire [31:0] dq
);
  IS42s32200 #(
    .mem_sizes(MEM_WORDS_PER_BANK),
    .tAC(T_AC), .tHZ(T_HZ), .tOH(T_OH), .tMRD(T_MRD),
    .tRAS(T_RAS), .tRC(T_RC), .tRCD(T_RCD), .tRP(T_RP),
    .tRRD(T_RRD), .tDPL(T_DPL)
  ) reference_memory (
    .Dq(dq), .Addr(addr), .Ba(ba), .Clk(clk), .Cke(cke),
    .Cs_n(cs_n), .Ras_n(ras_n), .Cas_n(cas_n), .We_n(we_n),
    .Dqm({dm3, dm2, dm1, dm0})
  );

  import gate_refresh_metrics::*;
  always @(posedge clk) begin
    phy_cycle=phy_cycle+1;
    if(measure_active) begin
      if ((cs_n !== 1'b0 && cs_n !== 1'b1) || (cke !== 1'b0 && cke !== 1'b1) ||
          (ras_n !== 1'b0 && ras_n !== 1'b1) || (cas_n !== 1'b0 && cas_n !== 1'b1) ||
          (we_n !== 1'b0 && we_n !== 1'b1)) command_unknown_cycles=command_unknown_cycles+1;
      if(!cs_n && cke && ras_n && !cas_n) begin
        if(we_n) read_count=read_count+1;
        else write_count=write_count+1;
      end
      if(!cs_n && cke && !ras_n && !cas_n && we_n) aref_count=aref_count+1;
    end
  end
endmodule
