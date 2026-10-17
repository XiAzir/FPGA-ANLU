`timescale 1ns/1ps
module tb_load_bench;
  wire miso;
  wire [31:0] command_count,read_count,last_lba;
  wire protocol_error;
  reg cs_n=1,sck=1,mosi=1;
  sd_spi_card_model #(.IMAGE_BYTES(67108864),.MAPPED_SECTORS(2073),
    .IMAGE_FILE("E:/VSCODE-project/FPGA-ANLU/development/system_verification_20261016/card/packed_mem.mem"),
    .LBA_MAP_FILE("E:/VSCODE-project/FPGA-ANLU/development/system_verification_20261016/card/lba_map.mem")) dut(
    .cs_n(cs_n),.sck(sck),.mosi(mosi),.miso(miso),.command_count(command_count),
    .read_count(read_count),.last_lba(last_lba),.protocol_error(protocol_error));
  initial begin
    $display("TB_BEFORE_MODEL_READY t=%0t",$time);
    #1000;
    $display("TB_AFTER_1US t=%0t reads=%0d",$time,read_count);
    $finish;
  end
  initial begin #2000; $display("TB_TIMEOUT"); $fatal(1); end
endmodule
