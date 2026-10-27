`timescale 1ns/1ps
module tb;
 reg clk=0; always #5 clk=~clk;
 reg rst=1,start=0,iv0=0,iv1=0,eob0=0,eob1=0,accept=1;
 reg [15:0] data0=0,data1=0; reg [5:0] idx0=0,idx1=0; reg [31:0] id0=0,id1=0;
 wire ia0,ia1,ov0,ov1; wire [31:0] od0,od1,oid0,oid1; wire [5:0] oi0,oi1;
 integer cyc=0,n0=0,n1=0,errors=0,c0=0,c1=0,max_desc=0; integer t0[0:79],t1[0:79]; reg [31:0] d0[0:8191],d1[0:8191]; reg [5:0] i0[0:8191],i1[0:8191]; reg [31:0] q0[0:8191],q1[0:8191];
 jpeg_idct base(clk,rst,start,1'b0,iv0,data0,idx0,eob0,id0,accept,ia0,ov0,od0,oi0,oid0);
 jpeg_idct_dc_fast cand(clk,rst,start,1'b0,iv1,data1,idx1,eob1,id1,accept,ia1,ov1,od1,oi1,oid1);
 always @(posedge clk) begin
  cyc<=cyc+1;
  if(cand.desc_count_q>max_desc) max_desc<=cand.desc_count_q;
  if(iv0&&ia0) begin iv0<=0;eob0<=0;end
  if(iv1&&ia1) begin iv1<=0;eob1<=0;end
  if(ov0&&accept) begin d0[n0]<=od0;i0[n0]<=oi0;q0[n0]<=oid0;n0<=n0+1;if(oi0==63) begin t0[c0]<=cyc;c0<=c0+1;end end
  if(ov1&&accept) begin d1[n1]<=od1;i1[n1]<=oi1;q1[n1]<=oid1;n1<=n1+1;if(oi1==63) begin t1[c1]<=cyc;c1<=c1+1;end end
 end
 task send(input [5:0] ix,input signed [15:0] val,input last,input [31:0] ident);
 begin
  @(negedge clk); while(!(ia0&&ia1)) @(negedge clk);
  iv0=1;iv1=1;idx0=ix;idx1=ix;data0=val;data1=val;eob0=last;eob1=last;id0=ident;id1=ident;
  while(iv0||iv1) @(negedge clk);
 end endtask
 task block(input signed [15:0] dc,input signed [15:0] ac,input ac_on,input [31:0] ident);
 begin
  send(0,dc,!ac_on,ident);
  if(ac_on) send(1,ac,1'b1,ident);
 end endtask
 integer j,k; reg [15:0] rand_dc;
 initial begin
  repeat(3) @(negedge clk);rst=0;start=1;@(negedge clk);start=0;
  accept=0;
  block(128,0,0,32'h1001);
  block(-37,0,0,32'h1011);
  block(22,0,0,32'h1012);
  block(-511,0,0,32'h1013);
  repeat(100) @(negedge clk); accept=1;
  if(ia1) $fatal(1,"candidate failed to apply queued-block backpressure");
  block(-77,43,1,32'h1002);
  block(-32768,0,0,32'h1003);
  send(0,336,0,32'h1009);send(8,18,1,32'h1009);
  block(1,0,0,32'h1004);
  block(-1,0,0,32'h1005);
  block(0,0,0,32'h1006);
  block(32767,0,0,32'h1007);
  block(-128,0,0,32'h1008);
  for(k=0;k<64;k=k+1) begin rand_dc=(k*16'd25173+16'd13849); block($signed(rand_dc),0,0,32'h2000+k); end
  // Dequantized coefficients extracted from real VIDEO.MJP frame 0, Q65.
  block(-22,0,0,32'h3000);
  send(0,-55,0,32'h3001);send(1,32,0,32'h3001);send(8,36,0,32'h3001);
  send(16,-54,0,32'h3001);send(9,-60,0,32'h3001);send(2,-32,0,32'h3001);
  send(3,10,0,32'h3001);send(10,39,0,32'h3001);send(17,68,0,32'h3001);
  send(24,40,0,32'h3001);send(25,-56,0,32'h3001);send(18,-30,0,32'h3001);
  send(11,-12,0,32'h3001);send(12,11,0,32'h3001);send(19,15,0,32'h3001);
  send(26,41,1,32'h3001);
  send(0,336,0,32'h3002);send(8,18,1,32'h3002);
  block(-60,0,0,32'h3003);
  send(0,-22,0,32'h3004);send(1,-8,1,32'h3004);
  send(0,-77,0,32'h3005);send(1,32,0,32'h3005);send(8,99,0,32'h3005);
  send(16,-126,0,32'h3005);send(9,-70,0,32'h3005);send(17,68,0,32'h3005);
  send(24,100,0,32'h3005);send(32,-78,0,32'h3005);send(25,-28,0,32'h3005);
  send(40,61,1,32'h3005);
  wait(n0==5248 && n1==5248); repeat(3) @(negedge clk);
  if(n0!=n1) begin $display("COUNT mismatch %0d %0d",n0,n1);errors=errors+1;end
  for(j=0;j<n0 && j<n1;j=j+1) if(d0[j]!==d1[j]||i0[j]!==i1[j]||q0[j]!==q1[j]) begin $display("DIFF sample %0d base=(%0d,%0d,%h) cand=(%0d,%0d,%h)",j,i0[j],$signed(d0[j]),q0[j],i1[j],$signed(d1[j]),q1[j]);errors=errors+1;end
  $display("MIXED/DC-domain/real blocks=82 samples=%0d errors=%0d max_desc=%0d cycles=%0d base_first8=%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d fast_first8=%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d",n0,errors,max_desc,cyc,t0[0],t0[1],t0[2],t0[3],t0[4],t0[5],t0[6],t0[7],t1[0],t1[1],t1[2],t1[3],t1[4],t1[5],t1[6],t1[7]);
  if(errors) $fatal(1,"mixed comparison failed");
  block(222,0,0,32'h2fff); wait(n0>=5268&&n1>=5268);
  rst=1;start=0;accept=1;iv0=0;iv1=0;eob0=0;eob1=0;repeat(3) @(negedge clk);n0=0;n1=0;c0=0;c1=0;rst=0;start=1;@(negedge clk);start=0;
  repeat(20) @(negedge clk);
  if(n0||n1) $fatal(1,"stale output survived reset");
  block(-16'sd12345,0,0,32'h3001); wait(n0==64&&n1==64); repeat(2) @(negedge clk);
  for(j=0;j<64;j=j+1) if(d0[j]!==d1[j]||i0[j]!==i1[j]||q0[j]!==q1[j]) errors=errors+1;
  $display("RESET mid-block discarded20/restart samples=64 errors=%0d",errors);
  if(errors) $fatal(1,"reset comparison failed");
  $finish;
 end
 initial begin #2000000;$fatal(1,"timeout n=%0d/%0d desc=%0d rd=%0d wr=%0d active=%b dc=%b seq=%0d y=%b beat=%0d yp=%b xr=%b xv=%b yv=%b cvalid=%b cidx=%0d ramready=%b ramstate=%d rptr=%d wptr=%d rd_idx=%d clear=%b prep=%b",n0,n1,cand.desc_count_q,cand.desc_rd_q,cand.desc_wr_q,cand.active_q,cand.active_dc_q,cand.dc_seq_q,cand.input_y_q,cand.input_beat_q,cand.y_pass_q,cand.x_reserved_q,cand.x_valid,cand.y_valid,cand.core_valid,cand.core_idx,cand.u_input.block_ready_q,cand.u_input.state_q,cand.u_input.block_rd_q,cand.u_input.block_wr_q,cand.u_input.rd_idx_q,cand.u_input.clear_active_q,cand.u_input.slot_prepared_q);end
endmodule
