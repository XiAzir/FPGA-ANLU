`timescale 1ns/1ps
module tb_pll_duty;
 reg refclk=0; always #10 refclk=~refclk;
 wire pclk,sclk,lock;
 video_pll dut(.refclk(refclk),.reset(1'b0),.extlock(lock),.clk0_out(pclk),.clk1_out(sclk));
 initial begin #5000000; fork measure_pixel; measure_serial; join $finish; end
 task measure_pixel;
 integer k; realtime rise,fall,next_rise,hi,lo,per,minhi,maxhi,minlo,maxlo,sumper;
 begin minhi=1.0e9;maxhi=0;minlo=1.0e9;maxlo=0;sumper=0; @(posedge pclk); rise=$realtime;
  for(k=0;k<20;k=k+1) begin @(negedge pclk);fall=$realtime;hi=fall-rise;@(posedge pclk);next_rise=$realtime;lo=next_rise-fall;per=next_rise-rise;sumper=sumper+per;if(hi<minhi)minhi=hi;if(hi>maxhi)maxhi=hi;if(lo<minlo)minlo=lo;if(lo>maxlo)maxlo=lo;rise=next_rise;end
  $display("PIXEL avg_period=%0.6f high=%0.6f..%0.6f low=%0.6f..%0.6f",sumper/20.0,minhi,maxhi,minlo,maxlo);
 end endtask
 task measure_serial;
 integer k; realtime rise,fall,next_rise,hi,lo,per,minhi,maxhi,minlo,maxlo,sumper;
 begin minhi=1.0e9;maxhi=0;minlo=1.0e9;maxlo=0;sumper=0; @(posedge sclk); rise=$realtime;
  for(k=0;k<40;k=k+1) begin @(negedge sclk);fall=$realtime;hi=fall-rise;@(posedge sclk);next_rise=$realtime;lo=next_rise-fall;per=next_rise-rise;sumper=sumper+per;if(hi<minhi)minhi=hi;if(hi>maxhi)maxhi=hi;if(lo<minlo)minlo=lo;if(lo>maxlo)maxlo=lo;rise=next_rise;end
  $display("SERIAL avg_period=%0.6f high=%0.6f..%0.6f low=%0.6f..%0.6f",sumper/40.0,minhi,maxhi,minlo,maxlo);
 end endtask
 initial begin #5100000; $display("duty timeout"); $finish; end
endmodule

