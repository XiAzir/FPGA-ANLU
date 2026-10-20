`timescale 1ns/1ps
module tb_missing_file;
 wire miso; wire [31:0] command_count,read_count,last_lba; wire protocol_error;
 reg cs_n=1,sck=1,mosi=1;
 sd_spi_card_model #(.IMAGE_BYTES(67108864),.MAPPED_SECTORS(2073),
   .IMAGE_FILE("missing_packed_mem.mem"),
   .LBA_MAP_FILE("E:/VSCODE-project/FPGA-ANLU/development/system_verification_20261016/card/lba_map.mem")) dut(
   .cs_n(cs_n),.sck(sck),.mosi(mosi),.miso(miso),.command_count(command_count),
   .read_count(read_count),.last_lba(last_lba),.protocol_error(protocol_error));
 initial begin #1000; $display("FAIL missing image did not stop simulation"); $finish; end
endmodule
