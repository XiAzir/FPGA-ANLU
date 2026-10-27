`timescale 1ns/1ps
package gate_refresh_metrics;
  integer phy_cycle = 0;
  integer aref_count = 0;
  integer aref_last_cycle = -1;
  integer req_rises = 0;
  integer ack_rises = 0;
  integer write_count = 0;
  integer read_count = 0;
  integer command_unknown_cycles = 0;
  bit measure_active = 0;
endpackage

// Explicitly inert SDRAM behavioral shell: samples command pins and tri-states DQ.
// It does not model storage, refresh retention, timing checks, or data transactions.
module EG_PHY_SDRAM_2M_32 (
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
  import gate_refresh_metrics::*;
  assign dq = 32'hzzzz_zzzz;

  always @(posedge clk) begin
    phy_cycle = phy_cycle + 1;
    if(measure_active && !cs_n && cke && ras_n && !cas_n) begin
      if(we_n) read_count = read_count+1;
      else write_count = write_count+1;
    end
    if (measure_active &&
        ((cs_n !== 1'b0 && cs_n !== 1'b1) ||
         (cke !== 1'b0 && cke !== 1'b1) ||
         (ras_n !== 1'b0 && ras_n !== 1'b1) ||
         (cas_n !== 1'b0 && cas_n !== 1'b1) ||
         (we_n !== 1'b0 && we_n !== 1'b1))) begin
      command_unknown_cycles = command_unknown_cycles + 1;
    end
    if (measure_active && (cs_n === 1'b0) && (cke === 1'b1) &&
        (ras_n === 1'b0) && (cas_n === 1'b0) && (we_n === 1'b1)) begin
      if(aref_last_cycle >= 0 && phy_cycle-aref_last_cycle < 4)
        $fatal(1,"AREF commands separated by only %0d clocks",phy_cycle-aref_last_cycle);
      aref_count = aref_count + 1;
      if (aref_last_cycle >= 0)
        $display("PHY_AREF idx=%0d cycle=%0d gap=%0d time_ns=%0t",
                 aref_count, phy_cycle, phy_cycle-aref_last_cycle, $time);
      else
        $display("PHY_AREF idx=%0d cycle=%0d gap=NA time_ns=%0t",
                 aref_count, phy_cycle, $time);
      aref_last_cycle = phy_cycle;
    end
  end
endmodule
