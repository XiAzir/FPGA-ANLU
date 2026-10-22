`timescale 1ns/1ps
module sd_card_cmd_r1_probe_tb;
  reg sys_clk=0, rst=1;
  reg [15:0] spi_clk_div=0;
  reg cmd_req=0, block_read_req=0, block_write_req=0;
  reg [47:0] cmd=0;
  reg [7:0] cmd_r1=0, block_write_data=0, spi_data_out=8'hff;
  reg [15:0] cmd_data_len=0;
  reg spi_wr_ack=0;
  wire cmd_req_ack, cmd_req_error, block_read_valid;
  wire [7:0] block_read_data, spi_data_in;
  wire block_read_req_ack, block_write_data_rd, block_write_req_ack;
  wire nCS_ctrl, spi_wr_req;
  wire [15:0] clk_div, read_crc_checked, read_crc_bad;
  wire [4:0] debug_state;
  wire [7:0] debug_last_r1;
  always #5 sys_clk=~sys_clk;

  sd_card_cmd dut (
    .sys_clk(sys_clk), .rst(rst), .spi_clk_div(spi_clk_div),
    .cmd_req(cmd_req), .cmd_req_ack(cmd_req_ack), .cmd_req_error(cmd_req_error),
    .cmd(cmd), .cmd_r1(cmd_r1), .cmd_data_len(cmd_data_len),
    .block_read_req(block_read_req), .block_read_valid(block_read_valid),
    .block_read_data(block_read_data), .block_read_req_ack(block_read_req_ack),
    .block_write_req(block_write_req), .block_write_data(block_write_data),
    .block_write_data_rd(block_write_data_rd), .block_write_req_ack(block_write_req_ack),
    .nCS_ctrl(nCS_ctrl), .clk_div(clk_div), .spi_wr_req(spi_wr_req),
    .spi_wr_ack(spi_wr_ack), .spi_data_in(spi_data_in), .spi_data_out(spi_data_out),
    .read_crc_checked(read_crc_checked), .read_crc_bad(read_crc_bad),
    .debug_state(debug_state), .debug_last_r1(debug_last_r1)
  );

  initial begin
    repeat (2) @(posedge sys_clk); #1 rst=0;
    if (debug_last_r1 !== 8'hff) $fatal(1,"R1 diagnostic reset value");

    // R1 response byte in S_CMD: observer captures the byte on SPI ack.
    force dut.state=5'd4;
    spi_data_out=8'h01; spi_wr_ack=1;
    @(posedge sys_clk); #1;
    if (debug_last_r1 !== 8'h01) $fatal(1,"R1 byte not captured");

    // A different byte in non-R1 data state must leave the R1 observation intact.
    force dut.state=5'd5;
    spi_data_out=8'hfe;
    @(posedge sys_clk); #1;
    if (debug_last_r1 !== 8'h01) $fatal(1,"non-R1 byte changed observation");

    // A different byte during sector read must also leave it intact.
    force dut.state=5'd7;
    spi_data_out=8'h00;
    @(posedge sys_clk); #1;
    if (debug_last_r1 !== 8'h01) $fatal(1,"read payload changed R1 observation");
    $display("PASS: R1 observer captures only S_CMD acknowledgements");
    $finish;
  end
endmodule
