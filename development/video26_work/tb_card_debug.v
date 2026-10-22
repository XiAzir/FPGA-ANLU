`timescale 1ns/1ps
module tb_card_debug;
reg clk=0,rst=1;
wire [15:0] debug_state; wire [21:0] debug_command;
always #5 clk=~clk;
sd_card_top dut(.clk(clk),.rst(rst),.SD_MISO(1'b1),
.sd_sec_read(1'b0),.sd_sec_read_addr(32'd0),
.sd_sec_write(1'b0),.sd_sec_write_addr(32'd0),.sd_sec_write_data(8'd0),
.debug_state(debug_state),.debug_command(debug_command));
initial begin
  repeat(2) @(negedge clk);rst=0;
  force dut.sd_card_sec_read_write_m0.state=5'd17;
  force dut.sd_card_cmd_m0.state=5'd17;
  force dut.spi_master_m0.state=3'd5;
  #1;
  if(debug_state[15:11]!==17 || debug_state[10:6]!==17 || debug_state[5:3]!==5)
    $fatal(1,"full-width SD layer states lost");
  force dut.sd_card_sec_read_write_m0.state=5'd18;#1;
  if(debug_state[15:11]!==18) $fatal(1,"CMD16 state truncated");
  force dut.cmd={8'd17,32'h12345678,8'hff};
  force dut.cmd_r1=8'h01;
  force dut.sd_card_cmd_m0.debug_last_r1=8'h04;#1;
  if(debug_command!=={6'd17,8'h01,8'h04}) $fatal(1,"command/R1 observation wiring");
  $display("PASS_CARD_DEBUG complete SD states17/18 and command/expected/received R1");
  $finish;
end
endmodule
