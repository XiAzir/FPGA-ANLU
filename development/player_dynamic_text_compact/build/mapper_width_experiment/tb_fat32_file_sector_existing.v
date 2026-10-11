`timescale 1ns/1ps
module tb_fat32_file_sector_existing;
 reg clk=0,rst=1,enable=1,file_read=0,sd_valid=0,sd_end=0;
 reg [31:0] fat_lba=10,data_lba=100,cluster_count=1000,start_cluster=2,file_size=200000,file_sector=0;
 reg [3:0] sectors_per_cluster_shift=0;
 reg [7:0] sd_data=0;
 wire [7:0] file_data; wire file_valid,file_end,error,sd_read; wire [7:0] error_code; wire [31:0] sd_addr;
 integer mode=0; integer suppress_sd=0; integer data_count=0; integer expected_addr=0; integer expected_bytes=0; integer err_ends=0; integer timeout; integer j;
 reg checking=0; reg failed=0;
 reg model_active=0; integer model_idx=0; integer model_gap=0; integer model_addr=0;
 always #5 clk=~clk;
 fat32_file_sector_original #(.WAIT_LIMIT(20)) dut(.clk(clk),.rst(rst),.enable(enable),.fat_lba(fat_lba),.data_lba(data_lba),.cluster_count(cluster_count),.sectors_per_cluster_shift(sectors_per_cluster_shift),.start_cluster(start_cluster),.file_size(file_size),.file_read(file_read),.file_sector(file_sector),.file_data(file_data),.file_valid(file_valid),.file_end(file_end),.error(error),.error_code(error_code),.sd_read(sd_read),.sd_addr(sd_addr),.sd_data(sd_data),.sd_valid(sd_valid),.sd_end(sd_end));
 function [31:0] link_for(input integer c);
 begin
  case(mode)
   1: link_for=(c==2)?0:32'h0fffffff;
   2: link_for=(c==2)?5:((c==5)?2:32'h0fffffff);
   3: link_for=(c==2)?5:((c==5)?32'h0ffffff8:32'h0fffffff);
   4: link_for=(c==2)?5:((c==5)?9:((c==9)?11:((c==11)?10:((c==10)?11:32'h0ffffff8))));
   5: link_for=(c==20)?21:((c==21)?22:((c==22)?21:32'h0fffffff));
   default: link_for=(c==2)?5:((c==5)?9:((c==9)?11:32'h0ffffff8));
  endcase
 end endfunction
 function [7:0] phys_byte(input integer a,input integer n);
 integer cl, lane; reg [31:0] v;
 begin
  if(a>=fat_lba && a<fat_lba+64) begin cl=((a-fat_lba)*128)+(n/4); lane=n%4; v=link_for(cl); phys_byte=(v>>(8*lane))&8'hff; end
  else phys_byte=(a+n)&255;
 end endfunction
 always @(negedge clk) begin
  sd_valid<=0; sd_end<=0;
  if(suppress_sd || !enable || !sd_read) begin model_active<=0; model_idx<=0; model_gap<=0; end
  else begin
   if(!model_active) begin model_active<=1; model_idx<=0; model_gap<=0; model_addr<=sd_addr; end
   else if(model_idx<512) begin
    if(model_gap==3) begin sd_valid<=1; sd_data<=phys_byte(model_addr,model_idx); model_idx<=model_idx+1; model_gap<=0; end
    else model_gap<=model_gap+1;
   end else begin sd_end<=1; model_active<=0; end
  end
 end
 always @(posedge clk) begin
  if(file_valid && checking) begin
   if(data_count>=expected_bytes || file_data!==((expected_addr+data_count)&255)) begin
    $display("FAIL payload addr=%0d idx=%0d got=%02x",expected_addr,data_count,file_data); failed<=1;
   end
   data_count<=data_count+1;
  end
  if(file_end && error) err_ends<=err_ends+1;
 end
 task request_ok(input [31:0] sec,input [31:0] expected,input [31:0] st,input [31:0] sz);
 begin
  @(negedge clk); file_read=0; start_cluster=st; file_size=sz; file_sector=sec;
  repeat(4) @(negedge clk);
  expected_addr=expected; expected_bytes=512; data_count=0; checking=1; file_read=1;
  timeout=0;
  while(!file_end && timeout<30000) begin @(negedge clk); timeout=timeout+1; end
  repeat(8) @(negedge clk);
  if (sd_read || data_count!=512) begin $display("FAIL held request reaccepted"); failed=1; end
  checking=0; file_read=0;
  if(timeout>=30000 || error || data_count!=512) begin $display("FAIL success req sec=%0d err=%b code=%02x n=%0d",sec,error,error_code,data_count); failed=1; end
  repeat(4) @(negedge clk);
 end endtask
 task request_err(input [31:0] sec,input [31:0] st,input [31:0] sz,input [7:0] code);
 begin
  @(negedge clk); file_read=0; start_cluster=st; file_size=sz; file_sector=sec;
  repeat(4) @(negedge clk); file_read=1; timeout=0;
  while(!file_end && timeout<30000) begin @(negedge clk); timeout=timeout+1; end
  file_read=0;
  if(timeout>=30000 || !error || error_code!=code) begin $display("FAIL error req sec=%0d err=%b code=%02x want=%02x",sec,error,error_code,code); failed=1; end
  repeat(3) @(negedge clk); rst=1; repeat(3) @(negedge clk); rst=0; repeat(3) @(negedge clk);
 end endtask
 initial begin
  repeat(5) @(negedge clk); rst=0; repeat(3) @(negedge clk);
  // SPC=1: fragmented forward mapping, cache hit, and backwards seek.
  request_ok(0,100,2,200000); request_ok(1,103,2,200000); request_ok(2,107,2,200000); request_ok(0,100,2,200000);
  // Descriptor change resets traversal; a standalone start cluster is valid.
  request_ok(0,105,7,200000);
  // SPC=8 and SPC=64 exercise cluster-index arithmetic and sector-in-cluster bits.
  sectors_per_cluster_shift=3; request_ok(8,124,2,200000); request_ok(24,172,2,200000);
  sectors_per_cluster_shift=6; request_ok(64,292,2,200000); request_ok(192,676,2,200000);
  // EOF / invalid link / real short cycle / premature EOC.
  sectors_per_cluster_shift=0;
  request_err(400,2,200000,8'h01);
  mode=1; request_err(1,2,200000,8'h06);
  mode=2; request_err(3,2,200000,8'h08);
  mode=3; request_err(2,2,200000,8'h07);
  // Carry Brent state across successful requests and detect a later cycle.
  mode=4; request_ok(0,100,2,200000); request_ok(1,103,2,200000);
  request_ok(2,107,2,200000); request_ok(0,100,2,200000);
  request_ok(1,103,2,200000); request_ok(2,107,2,200000);
  request_ok(3,109,2,200000); request_ok(4,108,2,200000);
  request_err(5,2,200000,8'h08);
  // Descriptor changes start a fresh tracker; this cycle is found after sector 2.
  mode=0; request_ok(0,100,2,200000);
  mode=5; request_ok(0,118,20,200000); request_ok(1,119,20,200000); request_ok(2,120,20,200000);
  request_err(3,20,200000,8'h08);
  // A silent SD interface times out. A WAV-style backwards seek to zero remains valid.
  suppress_sd=1; request_err(0,7,200000,8'h0a); suppress_sd=0;
  mode=0; request_ok(0,100,2,200000); request_ok(1,103,2,200000); request_ok(0,100,2,200000);
  if(failed) $fatal(1,"mapper simulation failed");
  $display("PASS: mapper SPC1/8/64, fragmentation, cache, backward/descriptor reset, EOF, invalid/free, cross-request cycles, SD timeout, byte gaps"); $finish;
 end
 initial begin #100000000; $fatal(1,"global timeout"); end
endmodule





