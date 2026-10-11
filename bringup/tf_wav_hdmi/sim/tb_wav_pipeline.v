`timescale 1ns/1ps
module tb_wav_pipeline;
reg sd_clk=0, pixel_clk=0, rst=1;
always #10 sd_clk=~sd_clk;
always #20 pixel_clk=~pixel_clk;
wire wav_read, wav_valid, wav_end;
wire [31:0] wav_addr;
wire [7:0] wav_data;
reg bmp_read=1;
reg [31:0] bmp_addr=5000;
wire bmp_valid,bmp_end;
wire [7:0] bmp_data;
wire card_read;
wire [31:0] card_addr;
reg [7:0] card_data=0;
reg card_valid=0,card_end=0;
wire take,available,primed,error,valid,underflow,acr_valid;
wire [15:0] sample;
wire [23:0] left_data,right_data;
wire [19:0] cts,n;
tf_wav_player #(.START_SECTOR(100),.EXPECTED_DATA_BYTES(1024)) player(
 .clk(sd_clk),.rst(rst),.sd_init_done(!rst),.sd_read(wav_read),.sd_addr(wav_addr),
 .sd_data(wav_data),.sd_valid(wav_valid),.sd_end(wav_end),.sample_take(take),
 .sample_data(sample),.sample_available(available),.primed(primed),.error(error));
sd_sector_arbiter arb(
 .clk(sd_clk),.rst(rst),.bmp_read(bmp_read),.bmp_addr(bmp_addr),
 .wav_read(wav_read),.wav_addr(wav_addr),.card_read(card_read),.card_addr(card_addr),
 .card_data(card_data),.card_valid(card_valid),.card_end(card_end),
 .bmp_data(bmp_data),.bmp_valid(bmp_valid),.bmp_end(bmp_end),
 .wav_data(wav_data),.wav_valid(wav_valid),.wav_end(wav_end));
wav_pcm_bridge bridge(.pixel_clk(pixel_clk),.sd_clk(sd_clk),.rst(rst),
 .primed(primed),.sample_available(available),.sample_data(sample),.sample_take(take),
 .audio_valid(valid),.audio_left(left_data),.audio_right(right_data),.underflow(underflow));
audio_arc_calculate acr(.I_clk(pixel_clk),.I_rst(rst),.I_audio_valid(valid),
 .O_acr_valid(acr_valid),.O_acr_cts(cts),.O_acr_n(n));
function [7:0] wav_byte;
 input integer offset;
 integer idx;
 reg [15:0] value;
 begin
   wav_byte=0;
   if(offset>=44 && offset<1068) begin
     idx=(offset-44)/2;
     value=idx-256;
     wav_byte=(offset%2==0) ? value[7:0] : value[15:8];
   end else case(offset)
     0: wav_byte="R"; 1: wav_byte="I"; 2,3: wav_byte="F";
     4: wav_byte=8'h24; 5: wav_byte=8'h04;
     8: wav_byte="W"; 9: wav_byte="A"; 10: wav_byte="V"; 11: wav_byte="E";
     12: wav_byte="f"; 13: wav_byte="m"; 14: wav_byte="t"; 15: wav_byte=" ";
     16: wav_byte=16; 20,22: wav_byte=1;
     24: wav_byte=8'h80;25: wav_byte=8'hbb;
     28: wav_byte=8'h00;29: wav_byte=8'h77;30: wav_byte=1;
     32: wav_byte=2;34: wav_byte=16;
     36: wav_byte="d";37: wav_byte="a";38: wav_byte="t";39: wav_byte="a";
     41: wav_byte=4;
   endcase
 end
endfunction
integer card_state=0,byte_idx=0,delay_count=0;
reg [31:0] locked_addr;
integer bmp_sectors=0,wav_sectors=0;
always @(negedge sd_clk) begin
 card_valid=0;card_end=0;
 if(rst) begin card_state=0;byte_idx=0;delay_count=0;end
 else case(card_state)
 0: if(card_read) begin locked_addr=card_addr;byte_idx=0;delay_count=1000;card_state=1;end
 1: if(delay_count==0) begin
       card_data=(locked_addr>=100 && locked_addr<=102) ?
                 wav_byte((locked_addr-100)*512+byte_idx):8'ha5;
       card_valid=1;
       if(byte_idx==511) begin card_state=2;delay_count=32;end
       else begin byte_idx=byte_idx+1;delay_count=31;end
    end else delay_count=delay_count-1;
 2: if(delay_count==0) begin card_end=1;card_state=3;end else delay_count=delay_count-1;
 3: if(!card_read) card_state=0;
 endcase
end
always @(posedge sd_clk) if(!rst) begin
 if(bmp_valid && wav_valid) $fatal(1,"Both clients received one byte");
 if(bmp_end && wav_end) $fatal(1,"Both clients received sector end");
 if(bmp_end) begin bmp_addr<=bmp_addr+1;bmp_sectors=bmp_sectors+1;end
 if(wav_end) wav_sectors=wav_sectors+1;
end
integer samples=0,cycle=0,last_sample_cycle=0,acr_packets=0;
reg [15:0] expected;
always @(posedge pixel_clk) begin
 if(!rst) begin
  cycle=cycle+1;
  if(valid) begin
    expected=(samples%512)-256;
    if(left_data !== {expected,8'b0} || right_data!==left_data)
      $fatal(1,"Sample mismatch at %0d: %h expected %h",samples,left_data,{expected,8'b0});
    if(samples>0 && (cycle-last_sample_cycle!=520 && cycle-last_sample_cycle!=521))
      $fatal(1,"Sample cadence %0d",cycle-last_sample_cycle);
    last_sample_cycle=cycle;samples=samples+1;
    if(error || underflow) $fatal(1,"FIFO/CDC underflow");
    if(samples==2200) begin
      if(bmp_sectors<10 || wav_sectors<10 || acr_packets<20) $fatal(1,"Insufficient concurrent coverage");
      $display("PASS pipeline: samples=%0d bmp_sectors=%0d wav_sectors=%0d ACR=%0d",samples,bmp_sectors,wav_sectors,acr_packets);
      $finish;
    end
  end
  if(acr_valid) begin
    if(acr_packets>0 && (cts!=25000 || n!=6144)) $fatal(1,"ACR mismatch %0d/%0d",cts,n);
    acr_packets=acr_packets+1;
  end
 end
end
initial begin #1000; @(negedge sd_clk);rst=0; #100000000; $fatal(1,"Timeout");end
endmodule
