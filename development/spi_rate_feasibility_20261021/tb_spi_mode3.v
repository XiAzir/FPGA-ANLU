`timescale 1ns/1ps
module tb_spi_mode3;
 reg clk=0,rst=1,req=0,miso=0,active=0;
 reg [15:0] div=2;
 reg [7:0] tx=0,response=0,mosi_received=0;
 wire cs,sclk,mosi,ack;
 wire [7:0] rx;
 integer bit_index=0,rising_edges=0,delay_ns=0;
 integer delays[0:5];
 integer rate_case,delay_case,value,errors,mosi_errors,total_errors=0;
 integer half_ns,edge_checks=0;
 time last_edge=0,first_edge=0,previous_first=0,byte_period=0;
 always #10 clk=~clk;
 spi_master dut(.sys_clk(clk),.rst(rst),.nCS(cs),.DCLK(sclk),.MOSI(mosi),.MISO(miso),
   .CPOL(1'b1),.CPHA(1'b1),.nCS_ctrl(1'b0),.clk_div(div),.wr_req(req),
   .wr_ack(ack),.data_in(tx),.data_out(rx));
 // Mode 3 launches bit 7 on its first falling edge and samples on rising edges.
 always @(negedge sclk) if(active) begin
  if(bit_index==0) first_edge=$time;
  if(bit_index>=8) $fatal(1,"extra launch edge");
  miso <= #(delay_ns) response[7-bit_index];
  bit_index=bit_index+1;
 end
 always @(posedge sclk) if(active) begin
  mosi_received={mosi_received[6:0],mosi};
  rising_edges=rising_edges+1;
 end
 always @(sclk) if(active) begin
  if(last_edge!=0 && $time-last_edge!=half_ns) $fatal(1,"SCLK edge spacing");
  if(last_edge!=0) edge_checks=edge_checks+1;
  last_edge=$time;
 end
 task transfer(input [7:0] b);
 begin
  wait(dut.state==0);
  @(negedge clk);
  response=b;tx=~b;miso=~b[7];bit_index=0;rising_edges=0;
  mosi_received=0;last_edge=0;active=1;req=1;
  @(negedge clk);req=0;
  wait(ack);#1;
  if(rx!==b) errors=errors+1;
  if(mosi_received!==~b) mosi_errors=mosi_errors+1;
  if(bit_index!=8 || rising_edges!=8) $fatal(1,"edge count");
  if(previous_first!=0) byte_period=first_edge-previous_first;
  previous_first=first_edge;
  @(negedge clk);active=0;wait(!ack);
 end
 endtask
 initial begin
  #10000000;$fatal(1,"watchdog");
 end
 initial begin
  delays[0]=0;delays[1]=15;delays[2]=35;delays[3]=55;delays[4]=75;delays[5]=85;
  repeat(4) @(negedge clk);rst=0;
  for(rate_case=0;rate_case<2;rate_case=rate_case+1) begin
   div=rate_case==0 ? 2:0;half_ns=(div+2)*20;
   for(delay_case=0;delay_case<6;delay_case=delay_case+1) begin
    errors=0;mosi_errors=0;delay_ns=delays[delay_case];previous_first=0;
    for(value=0;value<256;value=value+1) transfer(value[7:0]);
    if(mosi_errors) $fatal(1,"MOSI mismatch");
    if(delay_ns<half_ns && errors) $fatal(1,"within-window MISO mismatch");
    if(delay_ns>half_ns && errors==0) $fatal(1,"negative-control sensitivity missing");
    total_errors=total_errors+errors;
    $display("RESULT mode=3 div=%0d half_ns=%0d sclk_MHz=%0.3f delay_ns=%0d bytes=256 MISO_errors=%0d MOSI_errors=%0d byte_period_ns=%0d",
      div,half_ns,1000.0/(2*half_ns),delay_ns,errors,mosi_errors,byte_period);
   end
  end
  $display("PASS MODE3 bytes=3072 edge_spacing_checks=%0d expected_negative_errors=%0d",edge_checks,total_errors);
  $finish;
 end
endmodule
