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
  import gate_refresh_metrics::*;
  integer diag_trace_file=0, write_command_count=0, read_command_count=0;
  integer write_data_beats=0, read_data_beats=0, dq_transitions=0;
  reg [1023:0] diag_trace_path;
  initial begin
    if($value$plusargs("SDRAM_TRACE=%s",diag_trace_path)) begin
      diag_trace_file=$fopen(diag_trace_path,"w");
      if(diag_trace_file==0) $fatal(1,"cannot open SDRAM pin/model trace");
      $fdisplay(diag_trace_file,"kind,time_ns,cycle,cmd,ba,pin_addr,dq,dm,mode,model_bank,model_row,model_col,burst_counter,data_in,data_out,cmd0,cmd1,cmd2,cmd3");
    end
  end

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

  always @(posedge clk) begin
    if(diag_trace_file && !cs_n && cke && ras_n && !cas_n && !we_n && write_command_count<8) begin
      #1ps;
      $fdisplay(diag_trace_file,"WRITE_CMD,%0t,%0d,%b,%b,%h,%h,%h,%h,%0d,%h,%h,%h,%b,%b,%h,%h,%h,%h",
        $time,phy_cycle,{ras_n,cas_n,we_n},ba,addr,dq,{dm3,dm2,dm1,dm0},
        reference_memory.Mode_reg,reference_memory.Bank,reference_memory.Row,
        reference_memory.Col,reference_memory.Burst_counter,
        reference_memory.Data_in_enable,reference_memory.Data_out_enable,
        reference_memory.Command[0],reference_memory.Command[1],reference_memory.Command[2],reference_memory.Command[3]);
      write_command_count=write_command_count+1;
    end
    if(diag_trace_file && !cs_n && cke && ras_n && !cas_n && we_n && read_command_count<8) begin
      #1ps;
      $fdisplay(diag_trace_file,"READ_CMD,%0t,%0d,%b,%b,%h,%h,%h,%h,%0d,%h,%h,%h,%b,%b,%h,%h,%h,%h",
        $time,phy_cycle,{ras_n,cas_n,we_n},ba,addr,dq,{dm3,dm2,dm1,dm0},
        reference_memory.Mode_reg,reference_memory.Bank,reference_memory.Row,
        reference_memory.Col,reference_memory.Burst_counter,
        reference_memory.Data_in_enable,reference_memory.Data_out_enable,
        reference_memory.Command[0],reference_memory.Command[1],reference_memory.Command[2],reference_memory.Command[3]);
      read_command_count=read_command_count+1;
    end
    if(diag_trace_file && (reference_memory.Data_in_enable || reference_memory.Data_out_enable)) begin
      #1ps;
      if(reference_memory.Data_in_enable && write_data_beats<8) begin
        $fdisplay(diag_trace_file,"WRITE_DQ,%0t,%0d,%b,%b,%h,%h,%h,%h,%0d,%h,%h,%h,%b,%b,%h,%h,%h,%h",
          $time,phy_cycle,{ras_n,cas_n,we_n},ba,addr,dq,{dm3,dm2,dm1,dm0},
          reference_memory.Mode_reg,reference_memory.Bank,reference_memory.Row,
          reference_memory.Col,reference_memory.Burst_counter,
          reference_memory.Data_in_enable,reference_memory.Data_out_enable,
          reference_memory.Command[0],reference_memory.Command[1],reference_memory.Command[2],reference_memory.Command[3]);
        write_data_beats=write_data_beats+1;
      end
      if(reference_memory.Data_out_enable && read_data_beats<8) begin
        $fdisplay(diag_trace_file,"READ_DQ,%0t,%0d,%b,%b,%h,%h,%h,%h,%0d,%h,%h,%h,%b,%b,%h,%h,%h,%h",
          $time,phy_cycle,{ras_n,cas_n,we_n},ba,addr,dq,{dm3,dm2,dm1,dm0},
          reference_memory.Mode_reg,reference_memory.Bank,reference_memory.Row,
          reference_memory.Col,reference_memory.Burst_counter,
          reference_memory.Data_in_enable,reference_memory.Data_out_enable,
          reference_memory.Command[0],reference_memory.Command[1],reference_memory.Command[2],reference_memory.Command[3]);
        read_data_beats=read_data_beats+1;
      end
    end
  end

  always @(dq) begin
    if(diag_trace_file && dq_transitions<32 && $time>0) begin
      $fdisplay(diag_trace_file,"DQ_EDGE,%0t,%0d,%b,%b,%h,%h,%h,%h,%0d,%h,%h,%h,%b,%b,%h,%h,%h,%h",
        $time,phy_cycle,{ras_n,cas_n,we_n},ba,addr,dq,{dm3,dm2,dm1,dm0},
        reference_memory.Mode_reg,reference_memory.Bank,reference_memory.Row,
        reference_memory.Col,reference_memory.Burst_counter,
        reference_memory.Data_in_enable,reference_memory.Data_out_enable,
        reference_memory.Command[0],reference_memory.Command[1],reference_memory.Command[2],reference_memory.Command[3]);
      dq_transitions=dq_transitions+1;
    end
  end

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
