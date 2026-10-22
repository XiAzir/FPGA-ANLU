`timescale 1ns/1ps
module tb_c23_cold_mount;
  reg clk=0,rst=1;
  reg inject_cmd16_error_once=0;
  wire SD_nCS,SD_DCLK,SD_MOSI,SD_MISO,card_init_done,card_idle;
  wire [7:0] card_data;
  wire card_valid,card_end,fs_read,fs_ready,fs_error;
  wire [31:0] fs_addr,fs_fat_lba,fs_data_lba,fs_clusters;
  wire [3:0] spc_shift;
  wire [2:0] bmp_count;
  wire [127:0] bmp_clusters,bmp_sizes;
  wire wav_found,video_found;
  wire [31:0] wav_cluster,wav_size,video_cluster,video_size;
  wire [7:0] fs_error_code;
  wire [31:0] command_count,read_count,last_lba;
  wire protocol_error;
  wire [31:0] cmd16_count,cmd55_count,cmd41_count;
  wire sd_read=fs_ready ? 1'b0 : fs_read;
  wire [31:0] sd_addr=fs_addr;
  integer n;
  reg saw_init_done_before_idle=0;

  always #10 clk=~clk;
  always @(posedge clk) if(card_init_done && !card_idle) saw_init_done_before_idle<=1;

  sd_spi_card_model #(.IMAGE_BYTES(67108864),.MAPPED_SECTORS(2073),
    .IMAGE_FILE("packed_mem.mem"),.LBA_MAP_FILE("lba_map.mem")) card_model(
    .cs_n(SD_nCS),.sck(SD_DCLK),.mosi(SD_MOSI),.miso(SD_MISO),
    .command_count(command_count),.read_count(read_count),.last_lba(last_lba),
    .protocol_error(protocol_error),.cmd16_count(cmd16_count),.cmd55_count(cmd55_count),
    .cmd41_count(cmd41_count),.inject_cmd16_error_once(inject_cmd16_error_once));
  sd_card_top #(.SPI_HIGH_SPEED_DIV(0)) u_card(
    .clk(clk),.rst(rst),.SD_nCS(SD_nCS),.SD_DCLK(SD_DCLK),.SD_MOSI(SD_MOSI),.SD_MISO(SD_MISO),
    .sd_init_done(card_init_done),.sd_idle(card_idle),.sd_sec_read(sd_read),.sd_sec_read_addr(sd_addr),
    .sd_sec_read_data(card_data),.sd_sec_read_data_valid(card_valid),.sd_sec_read_end(card_end),
    .sd_sec_write(1'b0),.sd_sec_write_addr(32'd0),.sd_sec_write_data(8'd0),
    .sd_sec_write_data_req(),.sd_sec_write_end(),.read_crc_checked(),.read_crc_bad());
  fat32_catalog #(.SECTOR_TIMEOUT_CYCLES(20000)) u_catalog(
    .clk(clk),.rst(rst),.sd_init_done(card_init_done),.sd_read(fs_read),.sd_addr(fs_addr),
    .sd_data(card_data),.sd_valid(!fs_ready && card_valid),.sd_end(!fs_ready && card_end),
    .ready(fs_ready),.error(fs_error),.error_code(fs_error_code),
    .fat_lba(fs_fat_lba),.data_lba(fs_data_lba),.cluster_count(fs_clusters),
    .sectors_per_cluster_shift(spc_shift),.bmp_count(bmp_count),.bmp_clusters(bmp_clusters),
    .bmp_sizes(bmp_sizes),.wav_found(wav_found),.wav_cluster(wav_cluster),.wav_size(wav_size),
    .video_found(video_found),.video_cluster(video_cluster),.video_size(video_size));

  initial begin
    if($test$plusargs("CMD16_FAULT")) inject_cmd16_error_once=1;
    #100;@(negedge clk);rst=0;
    n=0;
    while(!fs_ready && !fs_error && n<4000000)begin @(posedge clk);n=n+1;end
    if(n>=4000000)begin $display("FAIL watchdog init=%0d state=%0d",card_init_done,u_card.sd_card_sec_read_write_m0.state);$fatal(1);end
    if($test$plusargs("SKIP_CMD16")) begin
      if(!fs_ready || fs_error || !card_init_done || cmd16_count!=0 || cmd55_count!=1 ||
         cmd41_count!=1 || read_count==0 || protocol_error || !saw_init_done_before_idle) begin
        $display("FAIL skip-CMD16 case ready=%0d error=%0d init=%0d CMD16/55/41=%0d/%0d/%0d reads=%0d protocol=%0d early_init=%0d",
          fs_ready,fs_error,card_init_done,cmd16_count,cmd55_count,cmd41_count,read_count,protocol_error,saw_init_done_before_idle);$fatal(1);
      end
      $display("PASS skip-CMD16 cold mount: CMD16=%0d, CMD17 reads=%0d; one-shot CMD16 fault is never issued",cmd16_count,read_count);
    end else if($test$plusargs("CMD16_FAULT")) begin
      if(!fs_error || fs_ready || fs_error_code!=8'h08 || !card_init_done ||
         cmd16_count!=1 || cmd55_count<2 || cmd41_count!=1 || read_count!=0 || protocol_error) begin
        $display("FAIL injected case fs_error=%0d code=%02x ready=%0d init=%0d CMD16/55/41=%0d/%0d/%0d reads=%0d protocol=%0d state=%0d cmd=%0d expected=%02x",
          fs_error,fs_error_code,fs_ready,card_init_done,cmd16_count,cmd55_count,cmd41_count,read_count,protocol_error,
          u_card.sd_card_sec_read_write_m0.state,u_card.sd_card_cmd_m0.state,u_card.sd_card_sec_read_write_m0.cmd_r1);$fatal(1);
      end
      $display("PASS injected CMD16 rejection: catalog times out E_TIMEOUT after early init_done; CMD55 R1 mismatch loop observed CMD55=%0d",cmd55_count);
    end else begin
      if(!fs_ready || fs_error || !card_init_done || cmd16_count!=1 || cmd55_count!=1 ||
         cmd41_count!=1 || read_count==0 || protocol_error || !saw_init_done_before_idle) begin
        $display("FAIL normal case ready=%0d error=%0d init=%0d CMD16/55/41=%0d/%0d/%0d reads=%0d protocol=%0d early_init=%0d",
          fs_ready,fs_error,card_init_done,cmd16_count,cmd55_count,cmd41_count,read_count,protocol_error,saw_init_done_before_idle);$fatal(1);
      end
      $display("PASS normal cold mount: CMD16 succeeds, catalog ready, reads=%0d; init_done precedes card_idle transiently",read_count);
    end
    $finish;
  end
endmodule
