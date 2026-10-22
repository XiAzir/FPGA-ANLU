`timescale 1ns/1ps
module tb_input_gap;
 reg clk=0,rst=1,valid=0,last=0;
 reg [31:0] data=0;
 reg [3:0] strb=15;
 wire accept;
 always #10 clk=~clk;
 jpeg_input dut(.clk_i(clk),.rst_i(rst),.inport_valid_i(valid),.inport_data_i(data),
  .inport_strb_i(strb),.inport_last_i(last),.inport_accept_o(accept),
  .dqt_cfg_accept_i(1'b1),.dht_cfg_accept_i(1'b1),.data_accept_i(1'b1));
 task send;
 input [31:0] word;
 begin
  @(negedge clk);valid=1;data=word;
  @(posedge clk);while(!accept)@(posedge clk);
  @(negedge clk);valid=0;
 end
 endtask
 initial begin
  repeat(3)@(negedge clk);rst=0;
  send(32'hdaffd8ff);
  repeat(5)@(negedge clk);
  send(32'hbbaa0200);
  repeat(5)@(negedge clk);
  send(32'hff2211d9);
  if(dut.state_q!==14)$fatal(1,"expected entropy state before gap");
  repeat(5)@(negedge clk);
  if(dut.state_q!==14)$fatal(1,"inactive held word caused a false JPEG EOI marker");
  send(32'h44332200);
  repeat(5)@(negedge clk);
  if(dut.state_q!==14)$fatal(1,"stuffed entropy continuation left image state");
  send(32'h0000d9ff);
  if(dut.state_q!==0)$fatal(1,"real EOI marker did not end image");
  $display("JPEG_INPUT_GAP_PASS inactive_false_EOI_ignored=1 stuffed_FF00=1 actual_EOI=1");$finish;
 end
 initial begin #100000;$fatal(1,"timeout");end
endmodule
