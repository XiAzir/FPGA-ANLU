`timescale 1ns/1ps
module tb_write_backpressure;
reg clk=0; always #10 clk=~clk;
reg rst=1, write_req=0, busy=1;
wire ack,finish,clear,backend_ready;
wire ready=backend_ready && !write_req && !rst;
reg loader_valid=0;reg [23:0] loader_rgb=0;
wire pack_valid;wire [31:0] pack_data;
wire wr_en,rd_en;wire [20:0] wr_addr,rd_addr;wire [31:0] wr_data;
wire [3:0] dm;wire [31:0] unused_data;wire unused_empty,unused_clear;
rgb888_pack32 pack(.clk(clk),.rst(rst|clear),.clear(write_req),
 .pixel_en(loader_valid),.pixel_rgb(loader_rgb),.word_en(pack_valid),.word_data(pack_data));
frame_read_write #(.FRAME_WIDTH(48),.FRAME_HEIGHT(64),.WRITE_V_FLIP(0)) backend(
 .rst(rst),.mem_clk(clk),.Sdr_init_done(1'b1),.Sdr_init_ref_vld(1'b0),
 .Sdr_busy(busy),.App_rd_en(rd_en),.App_rd_addr(rd_addr),
 .Sdr_rd_en(1'b0),.Sdr_rd_dout(32'd0),.read_clk(clk),.read_req(1'b0),
 .read_req_ack(),.read_finish(),.read_addr_0(21'd0),.read_addr_1(21'd0),
 .read_addr_2(21'd0),.read_addr_3(21'd0),.read_addr_index(2'd0),
 .read_len(21'd3072),.read_en(1'b0),.read_data(unused_data),
 .read_fifo_empty(unused_empty),.read_fifo_clear(unused_clear),
 .write_fifo_clear(clear),.write_fifo_ready(backend_ready),
 .App_wr_en(wr_en),.App_wr_addr(wr_addr),.App_wr_din(wr_data),.App_wr_dm(dm),
 .write_clk(clk),.write_req(write_req),.write_req_ack(ack),.write_finish(finish),
 .write_addr_0(21'd0),.write_addr_1(21'd0),.write_addr_2(21'd0),
 .write_addr_3(21'd0),.write_addr_index(2'd0),.write_len(21'd3072),
 .write_en(pack_valid),.write_data(pack_data));
function [23:0] pixel;
 input integer i;begin pixel={8'(i/64),8'(i*5),8'(i*7)};end
endfunction
function [7:0] byte_value;
 input integer b;reg [23:0] c;begin
 c=pixel(b/3);case(b%3) 0:byte_value=c[7:0];1:byte_value=c[15:8];default:byte_value=c[23:16];endcase
end endfunction
function [31:0] word_value;
 input integer w;begin word_value={byte_value(w*4+3),byte_value(w*4+2),byte_value(w*4+1),byte_value(w*4)};end
endfunction
integer accepted=0,words=0,produced=0,clocks=0,gap=0,stalled=0,max_used=0;
reg sending=0;reg [3:0] stop_phase_mask=0;reg prev_ready=0;
integer saved_word;
always @(posedge clk) begin
 clocks=clocks+1;
 if(!rst) begin
  if(backend.write_fifo_used>max_used)max_used=backend.write_fifo_used;
  if(pack_valid && backend.write_fifo_full)$fatal(1,"write dropped by FIFO full");
  if(pack_valid)produced=produced+1;
  if(prev_ready && !ready && sending)stop_phase_mask[pack.phase]=1;
  prev_ready=ready;
  if(sending && !ready)stalled=stalled+1;
  if(wr_en)begin
   saved_word=words;
   if(wr_addr!==words)$fatal(1,"write address %0d expected %0d",wr_addr,words);
   words=words+1;
   // The inherited write FIFO is SHOW_AHEAD=1; sample the current head at
   // the command edge, before its read-pointer update exposes the next head.
   if(wr_data!==word_value(saved_word))$fatal(1,"FIFO word %0d got%h expected%h",saved_word,wr_data,word_value(saved_word));
  end
 end
end
// A mock engine acceptance stage plus the real loader's one-register stage.
// Output pause/resume emulates pixel_ready; RGB and coordinate remain pending.
always @(posedge clk)begin
 if(rst || !sending)begin loader_valid<=0;gap<=0;end
 else begin
  loader_valid<=0;
  if(gap!=0)gap<=gap-1;
  else if(ready && accepted<4096)begin
   loader_valid<=1;loader_rgb<=pixel(accepted);accepted=accepted+1;gap<=9;
  end
 end
end
initial begin
 // The inherited writer arbitrates on App_rd_busy, not Sdr_busy. Inject
 // prolonged read ownership at that boundary to stress a stopped drain.
 force backend.App_rd_busy=busy;
 repeat(6)@(negedge clk);rst=0;write_req=1;
 wait(ack);@(negedge clk);write_req=0;
 repeat(8)@(negedge clk);sending=1;
 // No write burst starts for 12000 clocks, enough to fill/stall the producer.
 repeat(12000)@(negedge clk);
 if(ready || max_used<481 || accepted>=4096)$fatal(1,"threshold did not stop producer");
 // Later drain in bounded opportunities; complete transactions stay enabled.
 while(words<3072)begin
  busy=0;repeat(600)@(negedge clk);
  busy=1;repeat(4000)@(negedge clk);
 end
 // A one-cycle finish may have occurred in a preceding service window.
 wait(backend.frame_fifo_write_m0.write_cnt==3072);
 repeat(20)@(negedge clk);sending=0;
 if(accepted!=4096 || produced!=3072 || words!=3072 || max_used>484 || stalled<1000)
  $fatal(1,"count/threshold mismatch p=%0d prod=%0d words=%0d used=%0d stalled=%0d",accepted,produced,words,max_used,stalled);
 $display("WRITE_BACKPRESSURE PASS pixels=%0d words=%0d max_used=%0d stalled=%0d phase_mask=%h",accepted,words,max_used,stalled,stop_phase_mask);
 $finish;
end
initial begin #10000000;$fatal(1,"timeout");end
endmodule
