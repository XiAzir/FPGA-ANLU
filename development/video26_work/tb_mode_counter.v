`timescale 1ns/1ps
module tb_mode_counter;
reg clk=0,rst=1,press=0,restart=0;
wire mode,media_reset; wire [3:0] count;
always #5 clk=~clk;
mode_counter_probe dut(clk,rst,press,restart,mode,media_reset,count);
task mode_event;
begin @(negedge clk);press=1;@(negedge clk);press=0;#1;end
endtask
integer i;
initial begin
  repeat(2) @(negedge clk);rst=0;
  mode_event;
  if(count!==1 || !mode || !media_reset) $fatal(1,"mode event observation failed");
  repeat(40) @(negedge clk);
  if(count!==1 || media_reset) $fatal(1,"media reset changed persistent event count");
  restart=1;repeat(8) @(negedge clk);
  if(count!==1 || !media_reset) $fatal(1,"same-mode restart changed mode-event count");
  repeat(40) @(negedge clk);
  for(i=0;i<15;i=i+1) mode_event;
  if(count!==0) $fatal(1,"4-bit event count did not wrap");
  @(negedge clk);rst=1;#1;
  if(count!==0 || mode!==0) $fatal(1,"cold reset did not clear count/mode");
  $display("PASS_MODE_COUNTER media-reset persistence, restart exclusion, modulo16 and cold reset");
  $finish;
end
endmodule
