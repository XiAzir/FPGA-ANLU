`timescale 1ns/1ps
module tb_shared;
localparam BLOCKS=48,N=BLOCKS*64;
reg clk=0,rst=1,start=0;
always #10 clk=~clk;
reg [15:0] samples[0:N-1];
integer pos_ref=0,pos_dut=0,n_ref=0,n_dut=0,cycles=0;
reg valid_ref=0,valid_dut=0,ready=0;
wire accept_ref,accept_dut,out_ref,out_dut;
wire [31:0] data_ref,data_dut,id_ref,id_dut;
wire [5:0] idx_ref,idx_dut;
reg [69:0] reference[0:N-1],candidate[0:N-1];
integer seed=72020,i,checked=0;
// A cold reference restart defines the post-abort transaction sequence.
jpeg_idct_reference ref_u(clk,rst||start,start,1'b0,valid_ref,samples[pos_ref%N],6'(pos_ref),valid_ref&&accept_ref&&pos_ref%64==63,32'(pos_ref/64),ready,accept_ref,out_ref,data_ref,idx_ref,id_ref);
jpeg_idct dut(clk,rst,start,1'b0,valid_dut,samples[pos_dut%N],6'(pos_dut),valid_dut&&accept_dut&&pos_dut%64==63,32'(pos_dut/64),ready,accept_dut,out_dut,data_dut,idx_dut,id_dut);
always @(negedge clk) begin
 if(rst||start) begin valid_ref=0;valid_dut=0;ready=0;end
 else begin
  ready=($random(seed)&3)!=0;
  if(!valid_ref||accept_ref) valid_ref=(pos_ref<N)&&(($random(seed)&7)!=0);
  if(!valid_dut||accept_dut) valid_dut=(pos_dut<N)&&(($random(seed)&7)!=0);
 end
end
always @(posedge clk) begin
 if(rst||start) begin pos_ref<=0;pos_dut<=0;n_ref<=0;n_dut<=0;checked<=0;end
 else begin
  cycles<=cycles+1;
  if(valid_ref&&accept_ref) pos_ref<=pos_ref+1;
  if(valid_dut&&accept_dut) pos_dut<=pos_dut+1;
  if(out_ref) begin
   if(n_ref>=N)$fatal(1,"reference extra output");
   reference[n_ref]<={id_ref,idx_ref,data_ref};n_ref<=n_ref+1;
  end
  if(out_dut) begin
   if(n_dut>=N)$fatal(1,"candidate extra output");
   candidate[n_dut]<={id_dut,idx_dut,data_dut};n_dut<=n_dut+1;
  end
  if(checked<n_ref && checked<n_dut) begin
   if(reference[checked]!==candidate[checked])
    $fatal(1,"SHARED_DIFF sample=%0d ref=%h got=%h",checked,reference[checked],candidate[checked]);
   checked<=checked+1;
  end
  if(checked==N)begin $display("SHARED_IDCT_PASS blocks=%0d samples=%0d cycles=%0d",BLOCKS,N,cycles);$finish;end
  if(cycles>100000)$fatal(1,"shared timeout ref=%0d dut=%0d input=%0d/%0d",n_ref,n_dut,pos_ref,pos_dut);
 end
end
initial begin
 for(i=0;i<N;i=i+1)begin
  case((i/64)%4)
   0:samples[i]=$random(seed);
   1:samples[i]=(i%64==0)?16'h7fff:0;
   2:samples[i]=(i%2)?16'h8000:16'h7fff;
   3:samples[i]=(i%11)?0:16'hffff;
  endcase
 end
 repeat(8)@(negedge clk);rst=0;start=1;
 @(negedge clk);start=0;
 repeat(300)@(negedge clk);rst=1;
 repeat(3)@(negedge clk);rst=0;start=1;
 @(negedge clk);start=0;
 repeat(600)@(negedge clk);rst=1;
 repeat(4)@(negedge clk);rst=0;start=1;
 @(negedge clk);start=0;
 for(i=0;i<12;i=i+1)begin
  repeat(80+i*29)@(negedge clk);start=1;
  @(negedge clk);start=0;
 end
end
endmodule
