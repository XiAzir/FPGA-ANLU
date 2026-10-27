`timescale 1ns/1ps
module tb_card25;
  parameter FAST = 1;
  parameter integer MISO_DELAY_NS = 0;
  parameter integer INJECT_DATA_BIT = 0;
  reg clk=0, rst=1, read_req=0;
  reg [31:0] read_lba=0;
  wire cs_n, sck, mosi, miso, card_miso, init_done, byte_valid, read_end;
  wire [7:0] data_byte;
  wire [15:0] debug_state;
  wire [15:0] crc_checked_dut, crc_bad_dut;
  wire [31:0] command_count, read_count, last_lba;
  wire protocol_error;
  reg [7:0] gold [0:1023];
  integer received=0, data_errors=0, sectors_done=0, limit_count=0;
  integer mon_bit=0, mon_command_bytes=0, mon_command=0;
  integer mon_phase=0, mon_data_index=0, crc_checked=0, crc_bad=0;
  reg [7:0] mon_tx=0, mon_rx=0, crc_high=0;
  reg [15:0] mon_crc=0;
  realtime begin_ns, end_ns, elapsed_ns;
  wire inject_now = INJECT_DATA_BIT && mon_phase==1 && mon_data_index==123 && mon_bit==3;
  assign #(MISO_DELAY_NS) miso = card_miso ^ inject_now;
  always #10 clk=~clk;

  sd_card_top #(.SPI_FAST_DIV0(FAST)) dut(
    .clk(clk),.rst(rst),.SD_nCS(cs_n),.SD_DCLK(sck),.SD_MOSI(mosi),.SD_MISO(miso),
    .sd_init_done(init_done),.sd_sec_read(read_req),.sd_sec_read_addr(read_lba),
    .sd_sec_read_data(data_byte),.sd_sec_read_data_valid(byte_valid),.sd_sec_read_end(read_end),
    .sd_sec_write(1'b0),.sd_sec_write_addr(32'b0),.sd_sec_write_data(8'b0),
    .sd_sec_write_data_req(),.sd_sec_write_end(),.debug_state(debug_state),.debug_command(),
    .read_crc_checked(crc_checked_dut),.read_crc_bad(crc_bad_dut));

  sd_spi_card_model #(.IMAGE_BYTES(67108864),.MAPPED_SECTORS(2073),
    .IMAGE_FILE("packed_mem.mem"),.LBA_MAP_FILE("lba_map.mem")) card(
    .cs_n(cs_n),.sck(sck),.mosi(mosi),.miso(card_miso),
    .command_count(command_count),.read_count(read_count),.last_lba(last_lba),.protocol_error(protocol_error));

  function [15:0] crc_byte;
    input [15:0] value;
    input [7:0] b;
    reg [15:0] c;
    integer n;
    begin
      c=value ^ {b,8'b0};
      for(n=0;n<8;n=n+1) c=c[15] ? (c<<1)^16'h1021 : c<<1;
      crc_byte=c;
    end
  endfunction

  // Independent byte and CMD17/CRC recovery, using only the external SPI pins.
  always @(posedge sck or posedge cs_n) begin
    if(cs_n) begin
      mon_bit=0; mon_tx=0; mon_rx=0; mon_command_bytes=0; mon_command=0;
      mon_phase=0; mon_data_index=0; mon_crc=0; crc_high=0;
    end else begin
      mon_tx={mon_tx[6:0],mosi}; mon_rx={mon_rx[6:0],miso};
      mon_bit=mon_bit+1;
      if(mon_bit==8) begin
        mon_bit=0;
        if(mon_phase==1) begin
          if(mon_data_index<512) mon_crc=crc_byte(mon_crc,mon_rx);
          else if(mon_data_index==512) crc_high=mon_rx;
          else begin
            crc_checked=crc_checked+1;
            if({crc_high,mon_rx} !== mon_crc) crc_bad=crc_bad+1;
            mon_phase=0;
          end
          mon_data_index=mon_data_index+1;
        end else if(mon_phase==2 && mon_rx==8'hfe) begin
          mon_phase=1; mon_data_index=0; mon_crc=0;
        end
        if(mon_command_bytes==0) begin
          if(mon_tx[7:6]==2'b01) begin
            mon_command=mon_tx[5:0]; mon_command_bytes=1;
          end
        end else if(mon_command_bytes==5) begin
          mon_command_bytes=0;
          if(mon_command==17) mon_phase=2;
        end else mon_command_bytes=mon_command_bytes+1;
      end
    end
  end

  always @(posedge clk) if(!rst && byte_valid) begin
    if(received>=512) $fatal(1,"extra payload byte");
    if(data_byte !== gold[(read_lba==0 ? 0 : 512)+received]) begin
      data_errors=data_errors+1;
      if(!INJECT_DATA_BIT) $fatal(1,"LBA=%0d byte=%0d got=%02x want=%02x",read_lba,received,data_byte,gold[(read_lba==0 ? 0 : 512)+received]);
    end
    received=received+1;
  end

  task read_sector;
    input [31:0] lba;
    begin
      @(negedge clk); read_lba=lba; received=0; read_req=1;
      limit_count=0;
      while(!read_end && limit_count<500000) begin @(negedge clk); limit_count=limit_count+1; end
      if(!read_end) $fatal(1,"read timeout state=%04x",debug_state);
      read_req=0;
      if(received!=512 || last_lba!==lba) $fatal(1,"sector count/LBA mismatch");
      sectors_done=sectors_done+1;
      repeat(8) @(negedge clk);
    end
  endtask

  integer n;
  initial begin
    $readmemh("expected_sectors.mem",gold);
    #100; @(negedge clk); rst=0;
    limit_count=0;
    while((!init_done || debug_state[15:11]!=17) && limit_count<2000000) begin
      @(negedge clk); limit_count=limit_count+1;
    end
    if(!init_done || debug_state[15:11]!=17) $fatal(1,"initialization timeout %04x",debug_state);
    $display("INIT_DONE FAST=%0d delay=%0d time_ns=%0t",FAST,MISO_DELAY_NS,$time);
    begin_ns=$realtime;
    for(n=0;n<16;n=n+1) begin
      read_sector(0); read_sector(4130);
    end
    end_ns=$realtime; elapsed_ns=end_ns-begin_ns;
    if(protocol_error!==0 || read_count!=32 || crc_checked!=32 || crc_checked_dut!=32) $fatal(1,"protocol/read/CRC count %0d/%0d/%0d/%0d",protocol_error,read_count,crc_checked,crc_checked_dut);
    if(INJECT_DATA_BIT) begin
      if(data_errors==0 || crc_bad==0 || crc_bad_dut==0) $fatal(1,"negative control failed to detect corruption");
      $display("CARD25_NEGATIVE_PASS data_errors=%0d crc_bad=%0d crc_bad_dut=%0d",data_errors,crc_bad,crc_bad_dut);
    end else begin
      if(data_errors!=0 || crc_bad!=0 || crc_bad_dut!=0) $fatal(1,"payload/CRC errors %0d/%0d/%0d",data_errors,crc_bad,crc_bad_dut);
      $display("CARD25_PASS FAST=%0d delay=%0d sectors=%0d bytes=%0d elapsed_ns=%0.0f throughput_Bps=%0.3f crc_checked=%0d crc_bad=%0d",FAST,MISO_DELAY_NS,sectors_done,sectors_done*512,elapsed_ns,sectors_done*512.0*1.0e9/elapsed_ns,crc_checked,crc_bad);
    end
    $finish;
  end
endmodule
