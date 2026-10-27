`timescale 1ns/1ps
module tb_sys_pll;
  parameter integer MEM_PERIOD_NS = 10;
  parameter integer MEM_SHIFT_NS = 4;
  reg refclk=0, reset=1;
  always #10 refclk=~refclk;
  wire sdclk, memclk, shifted, locked;
  sys_pll dut(.refclk(refclk),.reset(reset),.extlock(locked),
              .clk0_out(sdclk),.clk1_out(memclk),.clk2_out(shifted));
  initial begin #200; reset=0; end
  task automatic check_period(input integer which, input realtime expected);
    realtime a,b;
    integer n;
    begin
      for(n=0;n<32;n=n+1) begin
        case(which)
          0: begin @(posedge sdclk);a=$realtime;@(negedge sdclk);b=$realtime;end
          1: begin @(posedge memclk);a=$realtime;@(negedge memclk);b=$realtime;end
          2: begin @(posedge shifted);a=$realtime;@(negedge shifted);b=$realtime;end
        endcase
        if(b-a < expected/2.0-0.002 || b-a > expected/2.0+0.002)
          $fatal(1,"PLL high width clock=%0d actual=%0f expected=%0f",which,b-a,expected/2.0);
        case(which)
          0: @(posedge sdclk);
          1: @(posedge memclk);
          2: @(posedge shifted);
        endcase
        if($realtime-a < expected-0.002 || $realtime-a > expected+0.002)
          $fatal(1,"PLL period clock=%0d actual=%0f expected=%0f",which,$realtime-a,expected);
      end
    end
  endtask
  task automatic check_phase;
    realtime origin;
    integer n;
    begin
      for(n=0;n<32;n=n+1) begin
        @(posedge memclk); origin=$realtime;
        @(posedge shifted);
        if($realtime-origin < MEM_SHIFT_NS-0.002 || $realtime-origin > MEM_SHIFT_NS+0.002)
          $fatal(1,"PLL phase actual=%0f expected=%0d",$realtime-origin,MEM_SHIFT_NS);
      end
    end
  endtask
  initial begin
    wait(locked===1'b1);
    repeat(10) @(posedge sdclk);
    fork
      check_period(0,20.0);
      check_period(1,MEM_PERIOD_NS);
      check_period(2,MEM_PERIOD_NS);
      check_phase();
    join
    $display("PLL_CLOCK_PASS sd_period=20ns mem_period=%0dns shifted_period=%0dns phase=%0dns",MEM_PERIOD_NS,MEM_PERIOD_NS,MEM_SHIFT_NS);
    $finish;
  end
  initial begin #1000000; $fatal(1,"PLL did not lock/finish"); end
endmodule
