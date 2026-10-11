// Local functional approximations for the two RAM primitives left in probe_rtl.
// They are not timing/initialization models from Anlogic and do not model
// collisions, byte enables, output pipelines, or target-device RAM implementation.
module EG_LOGIC_DRAM #(
    parameter ADDR_WIDTH_R=11, ADDR_WIDTH_W=11,
    parameter DATA_DEPTH_R=2048, DATA_DEPTH_W=2048,
    parameter DATA_WIDTH_R=16, DATA_WIDTH_W=16
)(
    input [DATA_WIDTH_W-1:0] di,
    input [ADDR_WIDTH_R-1:0] raddr,
    input [ADDR_WIDTH_W-1:0] waddr,
    input wclk, input we,
    output [DATA_WIDTH_R-1:0] do
);
    reg [DATA_WIDTH_W-1:0] mem [0:DATA_DEPTH_W-1];
    always @(posedge wclk) if(we) mem[waddr] <= di;
    // Distributed FIFO RAM is modeled with asynchronous read. The synthesized
    // FIFO head register captures this value on the consumer clock edge.
    assign do = mem[raddr];
endmodule

module EG_LOGIC_BRAM #(
    parameter ADDR_WIDTH_A=9, ADDR_WIDTH_B=9,
    parameter BYTE_A=1, BYTE_B=1, BYTE_ENABLE=0,
    parameter DATA_DEPTH_A=512, DATA_DEPTH_B=512,
    parameter DATA_WIDTH_A=8, DATA_WIDTH_B=8,
    parameter DEBUGGABLE="NO", FILL_ALL="NONE", IMPLEMENT="9K",
    parameter MODE="PDPW", REGMODE_A="NOREG", REGMODE_B="NOREG",
    parameter RESETMODE="ASYNC", WRITEMODE_A="NORMAL", WRITEMODE_B="NORMAL"
)(
    input [ADDR_WIDTH_A-1:0] addra,
    input [ADDR_WIDTH_B-1:0] addrb,
    input bea, beb, cea, ceb,
    input clka, clkb,
    input [DATA_WIDTH_A-1:0] dia,
    input [DATA_WIDTH_B-1:0] dib,
    input ocea, oceb, rsta, rstb,
    input wea, web,
    output reg [DATA_WIDTH_B-1:0] dob
);
    reg [DATA_WIDTH_A-1:0] mem [0:DATA_DEPTH_A-1];
    // The observed PDPW instance has port A as sector-cache write and port B
    // as clocked read (source RTL reads sector_mem synchronously).
    always @(posedge clka) begin
        if(cea && wea) mem[addra] <= dia;
        if(ceb && web) mem[addrb] <= dib;
    end
    always @(posedge clkb or posedge rstb) begin
        if(rstb) dob <= {DATA_WIDTH_B{1'b0}};
        else if(ceb && oceb) dob <= mem[addrb];
    end
endmodule
