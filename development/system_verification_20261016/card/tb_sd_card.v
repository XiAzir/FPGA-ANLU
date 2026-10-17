`timescale 1ns/1ps
module tb_sd_card;
  reg clk=0, rst=1, sd_sec_read=0;
  reg [31:0] sd_sec_read_addr=0;
  wire SD_nCS,SD_DCLK,SD_MOSI,SD_MISO,sd_init_done;
  wire [7:0] sd_sec_read_data;
  wire sd_sec_read_data_valid,sd_sec_read_end;
  wire [15:0] read_crc_checked,read_crc_bad;
  wire [31:0] command_count,read_count,last_lba;
  wire protocol_error;
  reg m_cs=1,m_sck=1,m_mosi=1;
  wire m_miso;
  wire [31:0] m_command_count,m_read_count,m_last_lba;
  wire m_protocol_error;
  integer got,expected_lba,idx,timeout_count;
  reg [7:0] unused;
  reg [7:0] expected_bytes [0:1023];
  reg [31:0] expected [0:1];
  always #5 clk=~clk;

  sd_spi_card_model #(.IMAGE_BYTES(67108864),.MAPPED_SECTORS(2073),.IMAGE_FILE("packed_mem.mem"),.LBA_MAP_FILE("lba_map.mem")) card(
    .cs_n(SD_nCS),.sck(SD_DCLK),.mosi(SD_MOSI),.miso(SD_MISO),
    .command_count(command_count),.read_count(read_count),.last_lba(last_lba),
    .protocol_error(protocol_error));
  sd_spi_card_model #(.IMAGE_BYTES(67108864),.MAPPED_SECTORS(2073),.IMAGE_FILE("packed_mem.mem"),.LBA_MAP_FILE("lba_map.mem")) manual_card(
    .cs_n(m_cs),.sck(m_sck),.mosi(m_mosi),.miso(m_miso),
    .command_count(m_command_count),.read_count(m_read_count),.last_lba(m_last_lba),
    .protocol_error(m_protocol_error));
  sd_card_top dut(.clk(clk),.rst(rst),.SD_nCS(SD_nCS),.SD_DCLK(SD_DCLK),.SD_MOSI(SD_MOSI),.SD_MISO(SD_MISO),
    .sd_init_done(sd_init_done),.sd_sec_read(sd_sec_read),.sd_sec_read_addr(sd_sec_read_addr),
    .sd_sec_read_data(sd_sec_read_data),.sd_sec_read_data_valid(sd_sec_read_data_valid),.sd_sec_read_end(sd_sec_read_end),
    .sd_sec_write(1'b0),.sd_sec_write_addr(32'd0),.sd_sec_write_data(8'd0),
    .sd_sec_write_data_req(),.sd_sec_write_end(),.read_crc_checked(read_crc_checked),.read_crc_bad(read_crc_bad));

  always @(posedge clk) if (!rst && sd_sec_read_data_valid) begin
    if (idx>=512) begin $display("FAIL: extra read byte"); $fatal(1); end
    if (sd_sec_read_data !== expected_bytes[(expected_lba==0 ? 0 : 512)+idx]) begin
      $display("FAIL: LBA %0d byte %0d got %02x expected %02x",expected_lba,idx,sd_sec_read_data,expected_bytes[(expected_lba==0 ? 0 : 512)+idx]);
      $fatal(1);
    end
    idx=idx+1;
  end

  task read_sector;
    input [31:0] lba;
    begin
      expected_lba=lba; idx=0; sd_sec_read_addr=lba; sd_sec_read=1;
      timeout_count=0;
      while (!sd_sec_read_end && timeout_count<8000000) begin @(posedge clk); timeout_count=timeout_count+1; end
      sd_sec_read=0;
      if (timeout_count>=8000000) begin $display("FAIL timeout LBA %0d",lba); $fatal(1); end
      repeat(8) @(posedge clk);
      if (idx!=512) begin $display("FAIL: LBA %0d only %0d bytes",lba,idx); $fatal(1); end
      if (last_lba!==lba) begin $display("FAIL: card LBA %0d expected %0d",last_lba,lba); $fatal(1); end
    end
  endtask

  task m_transfer;
    input [7:0] tx;
    output [7:0] rx;
    integer n;
    begin
      rx=0;
      for (n=7;n>=0;n=n-1) begin
        #1 m_mosi=tx[n]; m_sck=0; #1; m_sck=1; #1;
        rx={rx[6:0],m_miso};
      end
    end
  endtask

  task m_command;
    input [5:0] index;
    input [31:0] arg;
    input [7:0] crc_byte;
    output [7:0] r1;
    reg [7:0] unused;
    begin
      m_cs=0; m_sck=1;
      m_transfer(8'hff,unused);
      m_transfer({2'b01,index},unused);
      m_transfer(arg[31:24],unused); m_transfer(arg[23:16],unused);
      m_transfer(arg[15:8],unused); m_transfer(arg[7:0],unused);
      m_transfer(crc_byte,unused); m_transfer(8'hff,r1);
      m_cs=1; #2;
    end
  endtask

  initial begin
    $readmemh("expected_sectors.mem",expected_bytes);
    expected[0]=0; expected[1]=4130;
    #100; @(negedge clk); rst=0;
    timeout_count=0;
    while ((!sd_init_done || command_count<5) && timeout_count<8000000) begin @(posedge clk); timeout_count=timeout_count+1; end
    if (!sd_init_done) begin $display("FAIL: init timeout"); $fatal(1); end
    $display("SD init complete commands=%0d",command_count);
    read_sector(expected[0]); read_sector(expected[1]);
    if (read_count!=2 || command_count<7 || protocol_error!==0) begin
      $display("FAIL counters cmd=%0d read=%0d err=%0d",command_count,read_count,protocol_error); $fatal(1);
    end
    if (read_crc_checked!=2 || read_crc_bad!=0) begin
      $display("FAIL CRC checked=%0d bad=%0d",read_crc_checked,read_crc_bad); $fatal(1);
    end
    // Independently initialize a second card at pin level, interrupt CMD17
    // after its R1/token wait, then prove a fresh command recovers.
    m_command(0,0,8'h95,unused); // CMD0
    m_command(8,32'h000001aa,8'h87,unused); // CMD8
    m_command(55,0,8'hff,unused); // CMD55
    m_command(41,32'h40000000,8'hff,unused); // ACMD41
    m_command(16,512,8'hff,unused); // CMD16
    m_cs=0; m_sck=1; m_transfer(8'hff,unused);
    m_transfer(8'h51,unused); m_transfer(0,unused); m_transfer(0,unused);
    m_transfer(0,unused); m_transfer(0,unused); m_transfer(8'hff,unused);
    m_transfer(8'hff,unused); // read R1
    if (unused!==8'h00) begin $display("FAIL manual CMD17 R1=%02x",unused); $fatal(1); end
    m_transfer(8'hff,unused); m_transfer(8'hff,unused); m_transfer(8'hff,unused);
    if (unused!==8'hfe) begin $display("FAIL manual CMD17 token=%02x",unused); $fatal(1); end
    m_cs=1; #2; // deliberate CS interruption before any payload byte
    m_cs=0; m_sck=1; m_transfer(8'hff,unused);
    m_transfer(8'h51,unused); m_transfer(8'h00,unused); m_transfer(8'h00,unused);
    m_transfer(8'h10,unused); m_transfer(8'h22,unused); m_transfer(8'hff,unused);
    m_transfer(8'hff,unused);
    if (unused!==8'h00) begin $display("FAIL recovery CMD17 R1=%02x",unused); $fatal(1); end
    m_cs=0; m_sck=1;
    m_transfer(8'hff,unused); m_transfer(8'hff,unused); m_transfer(8'hff,unused);
    if (unused!==8'hfe) begin $display("FAIL recovered token=%02x",unused); $fatal(1); end
    m_cs=1;
    if (m_protocol_error!==0 || m_read_count!=2 || m_last_lba!=4130) begin
      $display("FAIL manual recovery err=%0d reads=%0d lba=%0d",m_protocol_error,m_read_count,m_last_lba); $fatal(1);
    end
    $display("PASS init + two production CMD17 sectors + CRC + pin-level CS interruption recovery");
    $display("production: commands=%0d reads=%0d checked=%0d bad=%0d; manual recovery reads=%0d",command_count,read_count,read_crc_checked,read_crc_bad,m_read_count);
    $finish;
  end
endmodule
