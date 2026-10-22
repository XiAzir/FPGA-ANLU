`timescale 1ns/1ps
module tb_command_boundary;
reg clk=0,rst=1,cmd_req=0;
reg [47:0] cmd;
reg [7:0] expected;
reg [15:0] data_len;
reg ack=0;
reg [7:0] miso_byte=8'hff;
wire request,done,error;wire [7:0] mosi_byte,last_r1;wire [4:0] state;
wire cs;wire [15:0] divider;
integer slot,noise,number,reply,position,phase,command_bytes,response_bytes,extra_bytes,cycles,errors;
reg [7:0] sent[0:5];
reg [7:0] planned_response;
always #5 clk=~clk;
sd_card_cmd dut(.sys_clk(clk),.rst(rst),.spi_clk_div(16'd0),
.cmd_req(cmd_req),.cmd_req_ack(done),.cmd_req_error(error),.cmd(cmd),.cmd_r1(expected),.cmd_data_len(data_len),
.block_read_req(1'b0),.block_write_req(1'b0),.block_write_data(8'd0),
.nCS_ctrl(cs),.clk_div(divider),.spi_wr_req(request),.spi_wr_ack(ack),.spi_data_in(mosi_byte),.spi_data_out(miso_byte),
.debug_state(state),.debug_last_r1(last_r1));

// Byte-level SPI service. Incoming bits during command transmission are
// deliberately distinct from the following response; no DUT internals forced.
always @(negedge clk) begin
  if(rst) begin phase=0;ack=0;command_bytes=0;response_bytes=0;extra_bytes=0;end
  else case(phase)
    0: if(request) begin
      planned_response=8'hff;
      if(state==4) begin
        if(command_bytes<6) begin
          sent[command_bytes]=mosi_byte;
          if(command_bytes==slot) planned_response=noise[7:0];
          command_bytes=command_bytes+1;
        end else begin
          response_bytes=response_bytes+1;
          if(response_bytes>=3) planned_response=reply<0 ? expected : reply[7:0];
        end
      end else if(state==5) begin
        extra_bytes=extra_bytes+1;
        case(extra_bytes) 1:planned_response=0;2:planned_response=0;3:planned_response=1;4:planned_response=8'haa;endcase
      end
      phase=1;
    end
    1: begin miso_byte=planned_response;ack=1;phase=2;end
    2: begin ack=0;phase=3;end
    3: phase=4;
    4: phase=0;
  endcase
end
initial begin
  slot=99;noise=1;number=8;reply=-1;
  if($value$plusargs("SLOT=%d",slot)) begin end
  if($value$plusargs("NOISE=%d",noise)) begin end
  if($value$plusargs("CMD=%d",number)) begin end
  if($value$plusargs("REPLY=%d",reply)) begin end
  expected=number==17 ? 8'h00 : 8'h01;
  data_len=number==8 ? 16'd4 : 16'd0;
  cmd={number[7:0],32'h000001aa,(number==8 ? 8'h87 : 8'h95)};
  repeat(3) @(posedge clk);#1 rst=0;
  wait(state==1);@(posedge clk);#1 cmd_req=1;
  cycles=0;
  while(!done && cycles<5000) begin @(posedge clk);#1;cycles=cycles+1;end
  errors=0;
  if(reply>=0 && reply!=expected) begin
    if(!done || !error || command_bytes!=6 || response_bytes!=3 || extra_bytes!=0) errors=errors+1;
  end else if(!done || error || command_bytes!=6 || response_bytes!=3 || extra_bytes!=data_len) errors=errors+1;
  for(position=0;position<6;position=position+1)
    if(sent[position] !== (position==0 ? (cmd[47:40]|8'h40) : ((cmd >> ((5-position)*8)) & 8'hff))) errors=errors+1;
  if(last_r1!==(reply<0 ? expected : reply[7:0])) errors=errors+1;
  if(errors) begin
    $display("BOUNDARY_FAIL CMD=%0d slot=%0d noise=%02x bytes=%0d response=%0d extra=%0d error=%b last=%02x",number,slot,noise,command_bytes,response_bytes,extra_bytes,error,last_r1);
    $fatal(1,"command phase interpreted as R1");
  end
  $display("BOUNDARY_PASS CMD=%0d slot=%0d noise=%02x bytes=%0d response=%0d extra=%0d error=%b",number,slot,noise,command_bytes,response_bytes,extra_bytes,error);
  $finish;
end
endmodule
