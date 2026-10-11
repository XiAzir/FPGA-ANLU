`timescale 1ns/1ps
module tb_fat_arbiter;
reg clk=0,rst=1,bmp_read=1,wav_read=1;
always #10 clk=~clk;
reg [31:0] bmp_addr=100,wav_addr=200;
reg [7:0] card_data=0;
reg card_valid=0,card_end=0;
wire card_read;wire [31:0] card_addr;
wire [7:0] bmp_data,wav_data;wire bmp_valid,bmp_end,wav_valid,wav_end;
integer transaction,byte_index,owner,streak=0,bmp_count=0,wav_count=0;
sd_sector_arbiter dut(.clk(clk),.rst(rst),.bmp_read(bmp_read),.bmp_addr(bmp_addr),
 .wav_read(wav_read),.wav_addr(wav_addr),.card_read(card_read),.card_addr(card_addr),
 .card_data(card_data),.card_valid(card_valid),.card_end(card_end),
 .bmp_data(bmp_data),.bmp_valid(bmp_valid),.bmp_end(bmp_end),
 .wav_data(wav_data),.wav_valid(wav_valid),.wav_end(wav_end));
initial begin
 repeat(5) @(negedge clk);rst=0;
 for(transaction=0;transaction<18;transaction=transaction+1) begin
  wait(card_read);@(negedge clk);
  owner=dut.owner;
  if(owner==2) begin
   if(card_addr!==wav_addr) $fatal(1,"WAV address");
   wav_count=wav_count+1;streak=streak+1;
   if(streak>2) $fatal(1,"BMP starvation: audio grants exceeded two");
  end else if(owner==1) begin
   if(card_addr!==bmp_addr) $fatal(1,"BMP address");
   bmp_count=bmp_count+1;streak=0;
  end else $fatal(1,"No owner");
  for(byte_index=0;byte_index<512;byte_index=byte_index+1) begin
   card_valid=1;card_data=byte_index;
   #1;
   if(dut.owner!==owner || !card_read) $fatal(1,"Owner changed within sector");
   if(owner==1 && (!bmp_valid || wav_valid || bmp_data!==card_data)) $fatal(1,"BMP routing");
   if(owner==2 && (!wav_valid || bmp_valid || wav_data!==card_data)) $fatal(1,"WAV routing");
   @(negedge clk);
  end
  card_valid=0;card_end=1;#1;
  if(owner==1 && (!bmp_end || wav_end)) $fatal(1,"BMP end routing");
  if(owner==2 && (!wav_end || bmp_end)) $fatal(1,"WAV end routing");
  @(negedge clk);card_end=0;
  // Both clients submit another sector after observing their completion.
  if(owner==1) begin bmp_read=0;bmp_addr=bmp_addr+1;end
  else begin wav_read=0;wav_addr=wav_addr+1;end
  repeat(2) begin
   if(card_read) $fatal(1,"Missing physical request gap");
   @(negedge clk);
  end
  bmp_read=1;wav_read=1;
 end
 if(bmp_count!=6 || wav_count!=12) $fatal(1,"Grant distribution %0d/%0d",bmp_count,wav_count);
 $display("PASS fat_arbiter: 18 sectors, exclusive routing, 2:1 bounded audio priority");
 $finish;
end
initial begin #1000000; $fatal(1,"Arbiter timeout");end
endmodule
