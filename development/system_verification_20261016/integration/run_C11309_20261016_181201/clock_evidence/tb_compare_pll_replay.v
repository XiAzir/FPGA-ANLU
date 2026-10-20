`timescale 1ns/100fs
module tb_compare_pll_replay;
 reg refclk=0;
 wire lock_s,lock_v,s0,s1,s2,pclk,serclk;
 wire rlock_s,rlock_v,r0,r1,r2,rpclk,rserclk;
 integer c_s0=0,c_s1=0,c_s2=0,c_pclk=0,c_ser=0;
 integer rc_s0=0,rc_s1=0,rc_s2=0,rc_pclk=0,rc_ser=0;
 realtime last_ref=0.0;
 sys_pll ref_sys(.refclk(refclk),.reset(1'b0),.extlock(lock_s),.clk0_out(s0),.clk1_out(s1),.clk2_out(s2));
 video_pll ref_video(.refclk(refclk),.reset(1'b0),.extlock(lock_v),.clk0_out(pclk),.clk1_out(serclk));
 pll_clock_replay replay(.refclk(refclk),.reset(1'b0),.slock(rlock_s),.vlock(rlock_v),
   .sys0(r0),.sys1(r1),.sys2(r2),.pclk(rpclk),.serclk(rser));
 always #10 refclk=~refclk;
 always @(posedge refclk) begin
   if(last_ref!=0.0 && ($realtime-last_ref)!=20.0) begin $display("FAIL refclk period=%0.4f",$realtime-last_ref); $fatal(1); end
   last_ref=$realtime;
 end
 `define CHECK(SIG,REF,REP,COUNTREF,COUNTREP) \
 always @(REF or REP) begin #0.001; if($realtime>=0.001 && $realtime<=20000.0) begin \
   if(REF !== REP) begin $display("FAIL %s edge t=%0.4f ref=%b replay=%b",SIG,$realtime,REF,REP); $fatal(1); end \
 end end \
 always @(REF) if($realtime>=0.001 && $realtime<=20000.0) COUNTREF=COUNTREF+1; \
 always @(REP) if($realtime>=0.001 && $realtime<=20000.0) COUNTREP=COUNTREP+1;
 `CHECK("sys0",s0,r0,c_s0,rc_s0)
 `CHECK("sys1",s1,r1,c_s1,rc_s1)
 `CHECK("sys2",s2,r2,c_s2,rc_s2)
 `CHECK("pclk",pclk,rpclk,c_pclk,rc_pclk)
 `CHECK("serclk",serclk,rser,c_ser,rc_ser)
 always @(lock_s or rlock_s) begin #0.001; if($realtime>=0.001 && $realtime<=20000.0 && lock_s!==rlock_s) begin $display("FAIL slock t=%0.4f",$realtime); $fatal(1); end end
 always @(lock_v or rlock_v) begin #0.001; if($realtime>=0.001 && $realtime<=20000.0 && lock_v!==rlock_v) begin $display("FAIL vlock t=%0.4f",$realtime); $fatal(1); end end
 initial begin
   #1;
   if ({lock_s,lock_v,s0,s1,s2,pclk,serclk} !== {rlock_s,rlock_v,r0,r1,r2,rpclk,rser}) begin
     $display("FAIL initial settled values differ"); $fatal(1);
   end
   #19999;
   if ({lock_s,lock_v,s0,s1,s2,pclk,serclk} !== {rlock_s,rlock_v,r0,r1,r2,rpclk,rser}) begin
     $display("FAIL final values differ at 20us"); $fatal(1);
   end
   if(lock_s!==1 || lock_v!==1 || rlock_s!==1 || rlock_v!==1) begin $display("FAIL lock at 20us"); $fatal(1); end
   if(c_s0!=rc_s0 || c_s1!=rc_s1 || c_s2!=rc_s2 || c_pclk!=rc_pclk || c_ser!=rc_ser) begin
     $display("FAIL transition counts ref=%0d/%0d/%0d/%0d/%0d replay=%0d/%0d/%0d/%0d/%0d",c_s0,c_s1,c_s2,c_pclk,c_ser,rc_s0,rc_s1,rc_s2,rc_pclk,rc_ser); $fatal(1);
   end
   $display("PASS_PLL_REPLAY 20us: five clock outputs edge/value matched, both lock transitions and final locks matched; refclk=50MHz");
   $display("edges sys0=%0d sys1=%0d sys2=%0d pclk=%0d serclk=%0d",c_s0,c_s1,c_s2,c_pclk,c_ser);
   $finish;
 end
 initial begin #30000;$display("FAIL replay comparison timeout");$fatal(1);end
endmodule

