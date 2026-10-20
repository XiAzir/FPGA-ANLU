`timescale 1ns/1ps
// Simulation-only APPLICATION-INTERFACE model, not a physical SDRAM model.
// Assumption: read data leads valid by one Clk, matching the selected backend.
// Keep real FIFO/pack/unpack/arbiters outside this replacement.
module sdram #(
 parameter WORDS=460800, parameter INIT_CYCLES=10000
)(input Clk,Clk_sft,Rst,
 output reg Sdr_init_done, output Sdr_init_ref_vld,output Sdr_busy,
 input App_wr_en,input [20:0] App_wr_addr,input [3:0] App_wr_dm,
 input [31:0] App_wr_din,input App_rd_en,input [20:0] App_rd_addr,
 output reg Sdr_rd_en,output reg [31:0] Sdr_rd_dout);
 // Packing limits elaboration cost in old ModelSim; no initial zero-fill.
 reg [8191:0] pages[0:(WORDS+255)/256-1];
 reg previous_read;
 integer init_count,byte_index;
 integer write_count=0,read_count=0;
 assign Sdr_init_ref_vld=1'b0;
 assign Sdr_busy=!Sdr_init_done;
 always @(posedge Clk or posedge Rst)begin
  if(Rst)begin
   init_count<=0;Sdr_init_done<=0;Sdr_rd_en<=0;
   previous_read<=0;Sdr_rd_dout<=32'bx;
  end else begin
   if(!Sdr_init_done)begin
    if(init_count>=INIT_CYCLES-1)Sdr_init_done<=1;
    else init_count<=init_count+1;
   end
   Sdr_rd_en<=previous_read;
   previous_read<=App_rd_en;
   if(App_wr_en)begin
    if(!Sdr_init_done || ^App_wr_addr===1'bx || App_wr_addr>=WORDS)
     $fatal(1,"APP_MODEL invalid write address/init");
    if(^App_wr_din===1'bx || ^App_wr_dm===1'bx)
     $fatal(1,"APP_MODEL unknown write data/mask");
    for(byte_index=0;byte_index<4;byte_index=byte_index+1)
     if(!App_wr_dm[byte_index])
      pages[App_wr_addr[20:8]][App_wr_addr[7:0]*32+byte_index*8+:8]<=App_wr_din[byte_index*8+:8];
    write_count=write_count+1;
   end
   if(App_rd_en)begin
    if(!Sdr_init_done || ^App_rd_addr===1'bx || App_rd_addr>=WORDS)
     $fatal(1,"APP_MODEL invalid read address/init");
    Sdr_rd_dout<=pages[App_rd_addr[20:8]][App_rd_addr[7:0]*32+:32];
    read_count=read_count+1;
   end
  end
 end
endmodule
