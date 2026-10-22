// Simulation-only pin-model binding from Anlogic APUG011's own testbench.
// This is a bus-functional IS42s32200 reference, not a SiP silicon guarantee.
module EG_PHY_SDRAM_2M_32(input clk,ras_n,cas_n,we_n,input[10:0]addr,
 input[1:0]ba,inout[31:0]dq,input cs_n,dm0,dm1,dm2,dm3,cke);
 IS42s32200 reference_memory(.Dq(dq),.Addr(addr),.Ba(ba),.Clk(clk),.Cke(cke),
 .Cs_n(cs_n),.Ras_n(ras_n),.Cas_n(cas_n),.We_n(we_n),.Dqm({dm3,dm2,dm1,dm0}));
endmodule
