`timescale 1ns/1ps
module tb_lane_scoreboard;
 reg refclk=0; always #10 refclk=~refclk;
 wire pclk,sraw,lock; wire [511:0] raw_bits,buf_bits; integer raw_n,buf_n; wire done_raw,done_buf;
 video_pll pll(.refclk(refclk),.reset(1'b0),.extlock(lock),.clk0_out(pclk),.clk1_out(sraw));
 lane_capture #(.CASE_NAME("33_165_RAW"),.USE_BUFG(0)) a(pclk,sraw,raw_bits,raw_n,done_raw);
 lane_capture #(.CASE_NAME("33_165_BUFG"),.USE_BUFG(1)) b(pclk,sraw,buf_bits,buf_n,done_buf);
 initial begin wait(done_raw && done_buf); $display("ALL_CASES_DONE"); $finish; end
 initial begin #10000; $display("GLOBAL_TIMEOUT p=%b s=%b n=%0d/%0d lock=%b",pclk,sraw,raw_n,buf_n,lock); $finish; end
endmodule
module lane_capture #(parameter CASE_NAME="case",parameter USE_BUFG=1)(input pclk,input sraw,output reg [511:0] captured=0,output integer bitcount=0,output reg done=0);
 wire sclk; generate if(USE_BUFG) begin:g EG_LOGIC_BUFG sbuf(.i(sraw),.o(sclk)); end else begin:r assign sclk=sraw; end endgenerate
 reg reset=1; reg [9:0] din=0; integer drive_i=0; reg [9:0] seq[0:15]; wire dout;
 lane_lvds_10_1 #(.DEVICE("EG")) dut(.I_pixel_clk(pclk),.I_serial_clk(sclk),.I_rst(reset),.I_data_in(din),.O_serial_out(dout));
 function [9:0] rev10(input [9:0] v); integer k; begin for(k=0;k<10;k=k+1) rev10[k]=v[9-k]; end endfunction
 initial begin
  seq[0]=10'h01f;seq[1]=10'h000;seq[2]=10'h3ff;seq[3]=10'h155;seq[4]=10'h2aa;seq[5]=10'h001;seq[6]=10'h200;seq[7]=10'h3fe;
  seq[8]=10'h100;seq[9]=10'h0ff;seq[10]=10'h210;seq[11]=10'h00f;seq[12]=10'h3f0;seq[13]=10'h1ff;seq[14]=10'h201;seq[15]=10'h155;
  repeat(20) @(posedge pclk); @(negedge pclk); reset=0;
 end
 always @(negedge pclk) if(!reset && drive_i<16) begin din=rev10(seq[drive_i]); drive_i=drive_i+1; end
 always @(posedge sclk) begin #0.2; if(!reset && bitcount<512) begin captured[bitcount]=dout; bitcount=bitcount+1; end end
 always @(negedge sclk) begin #0.2; if(!reset && bitcount<512) begin captured[bitcount]=dout; bitcount=bitcount+1; end end
 initial begin
  #9000;
  begin: scan
   integer start,i,j,found; reg [9:0] got; found=0;
   for(start=0;start+160<=bitcount && !found;start=start+1) begin
    got=0; for(j=0;j<10;j=j+1) got[j]=captured[start+j];
    if(got===seq[0]) begin
     found=1; $display("%s first_word_start_bit=%0d word0=%03h",CASE_NAME,start,got);
     for(i=1;i<16;i=i+1) begin
      got=0; for(j=0;j<10;j=j+1) got[j]=captured[start+i*10+j];
      if(got!==seq[i]) begin $display("%s FIRST_MISMATCH word_index=%0d bit_index=%0d expected=%03h got=%03h",CASE_NAME,i,start+i*10,seq[i],got); done=1; disable scan; end
     end
     $display("%s PASS 16 consecutive words",CASE_NAME); done=1;
    end
   end
   if(!found) begin $display("%s FAIL seq0 not found; bits=%0d",CASE_NAME,bitcount); done=1; end
  end
 end
endmodule
