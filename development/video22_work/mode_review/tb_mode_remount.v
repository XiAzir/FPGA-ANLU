`timescale 1ns/1ps
module tb_mode_remount;
  reg sd_clk=0, video_clk=0, por=1, media_reset=0;
  reg run_read=0;
  reg [31:0] run_addr=0;
  wire rst=por|media_reset;
  wire SD_nCS,SD_DCLK,SD_MOSI,SD_MISO,card_init_done;
  wire [7:0] card_data;
  wire card_valid,card_end;
  wire [15:0] crc_checked,crc_bad;
  wire [31:0] command_count,read_count,last_lba;
  wire protocol_error;
  wire fs_read,fs_ready,fs_error,fs_wav_found,fs_video_found;
  wire [31:0] fs_addr,fs_fat_lba,fs_data_lba,fs_cluster_count;
  wire [3:0] fs_spc_shift;
  wire [2:0] fs_bmp_count;
  wire [127:0] fs_bmp_clusters,fs_bmp_sizes;
  wire [31:0] fs_wav_cluster,fs_wav_size,fs_video_cluster,fs_video_size;
  wire [7:0] fs_error_code;
  wire shared_read=fs_ready ? run_read : fs_read;
  wire [31:0] shared_addr=fs_ready ? run_addr : fs_addr;
  always #10 sd_clk=~sd_clk;
  always #20 video_clk=~video_clk;

  sd_spi_card_model #(.IMAGE_BYTES(67108864),.MAPPED_SECTORS(2073),
    .IMAGE_FILE("packed_mem.mem"),.LBA_MAP_FILE("lba_map.mem")) card_model(
    .cs_n(SD_nCS),.sck(SD_DCLK),.mosi(SD_MOSI),.miso(SD_MISO),
    .command_count(command_count),.read_count(read_count),.last_lba(last_lba),.protocol_error(protocol_error));
  sd_card_top #(.SPI_HIGH_SPEED_DIV(0)) card_controller(
    .clk(sd_clk),.rst(rst),.SD_nCS(SD_nCS),.SD_DCLK(SD_DCLK),.SD_MOSI(SD_MOSI),.SD_MISO(SD_MISO),
    .sd_init_done(card_init_done),.sd_sec_read(shared_read),.sd_sec_read_addr(shared_addr),
    .sd_sec_read_data(card_data),.sd_sec_read_data_valid(card_valid),.sd_sec_read_end(card_end),
    .sd_sec_write(1'b0),.sd_sec_write_addr(32'd0),.sd_sec_write_data(8'd0),
    .sd_sec_write_data_req(),.sd_sec_write_end(),.read_crc_checked(crc_checked),.read_crc_bad(crc_bad));
  fat32_catalog catalog(
    .clk(sd_clk),.rst(rst),.sd_init_done(card_init_done),.sd_read(fs_read),.sd_addr(fs_addr),
    .sd_data(card_data),.sd_valid(!fs_ready && card_valid),.sd_end(!fs_ready && card_end),
    .ready(fs_ready),.error(fs_error),.error_code(fs_error_code),
    .fat_lba(fs_fat_lba),.data_lba(fs_data_lba),.cluster_count(fs_cluster_count),
    .sectors_per_cluster_shift(fs_spc_shift),.bmp_count(fs_bmp_count),.bmp_clusters(fs_bmp_clusters),
    .bmp_sizes(fs_bmp_sizes),.wav_found(fs_wav_found),.wav_cluster(fs_wav_cluster),.wav_size(fs_wav_size),
    .video_found(fs_video_found),.video_cluster(fs_video_cluster),.video_size(fs_video_size));

  integer timeout_count, phase, want_state, want_byte, old_commands, old_reads;
  reg [31:0] base_fat_lba,base_data_lba,base_clusters,base_bmp_cluster,base_bmp_size;
  reg [31:0] base_wav_cluster,base_wav_size,base_video_cluster,base_video_size;
  reg [2:0] base_bmp_count;
  reg base_wav_found,base_video_found;

  task wait_mounted;
    integer n;
    begin
      n=0;
      while (!fs_ready && !fs_error && n<4000000) begin @(posedge sd_clk); n=n+1; end
      if (fs_error) begin $display("FAIL mount error=%02x",fs_error_code); $fatal(1); end
      if (!fs_ready) begin $display("FAIL remount timeout init=%0d",card_init_done); $fatal(1); end
      repeat(8) @(posedge sd_clk);
    end
  endtask

  task save_or_compare;
    input integer save_base;
    begin
      if (save_base) begin
        base_fat_lba=fs_fat_lba; base_data_lba=fs_data_lba; base_clusters=fs_cluster_count;
        base_bmp_count=fs_bmp_count; base_bmp_cluster=fs_bmp_clusters[31:0]; base_bmp_size=fs_bmp_sizes[31:0];
        base_wav_found=fs_wav_found; base_wav_cluster=fs_wav_cluster; base_wav_size=fs_wav_size;
        base_video_found=fs_video_found; base_video_cluster=fs_video_cluster; base_video_size=fs_video_size;
        if (fs_bmp_count!=1 || fs_bmp_clusters[31:0]!=21 || fs_bmp_sizes[31:0]!=822 ||
            !fs_wav_found || fs_wav_cluster!=4 || fs_wav_size!=8236 || fs_video_found) begin
          $display("FAIL unexpected fixture catalog bmp=%0d bmp0=%0d/%0d wav=%0d %0d/%0d video=%0d %0d/%0d",
            fs_bmp_count,fs_bmp_clusters[31:0],fs_bmp_sizes[31:0],fs_wav_found,fs_wav_cluster,fs_wav_size,
            fs_video_found,fs_video_cluster,fs_video_size); $fatal(1);
        end
      end else if (fs_fat_lba!==base_fat_lba || fs_data_lba!==base_data_lba || fs_cluster_count!==base_clusters ||
          fs_bmp_count!==base_bmp_count || fs_bmp_clusters[31:0]!==base_bmp_cluster || fs_bmp_sizes[31:0]!==base_bmp_size ||
          fs_wav_found!==base_wav_found || fs_wav_cluster!==base_wav_cluster || fs_wav_size!==base_wav_size ||
          fs_video_found!==base_video_found || fs_video_cluster!==base_video_cluster || fs_video_size!==base_video_size) begin
        $display("FAIL metadata changed phase=%0d bmp=%0d %0d/%0d wav=%0d %0d/%0d video=%0d %0d/%0d",
          phase,fs_bmp_count,fs_bmp_clusters[31:0],fs_bmp_sizes[31:0],fs_wav_found,fs_wav_cluster,fs_wav_size,
          fs_video_found,fs_video_cluster,fs_video_size); $fatal(1);
      end
    end
  endtask

  task interrupt_runtime_read;
    input integer p;
    input integer target_byte;
    integer n;
    reg hit;
    begin
      phase=p; want_byte=target_byte; run_addr=4130; run_read=1;
      case (p)
        0: begin want_state=4; want_byte=2; end // CMD17 argument bytes
        1: begin want_state=6; want_byte=-1; end // token wait
        default: begin want_state=7; end // payload byte index
      endcase
      n=0; hit=0;
      while (!hit && n<2000000) begin
        @(negedge sd_clk); n=n+1;
        if (card_controller.sd_card_cmd_m0.state==want_state &&
            (want_byte<0 || card_controller.sd_card_cmd_m0.byte_cnt==want_byte)) hit=1;
      end
      if (!hit) begin
        $display("FAIL phase %0d target state=%0d byte=%0d observed state=%0d byte=%0d",
          p,want_state,want_byte,card_controller.sd_card_cmd_m0.state,card_controller.sd_card_cmd_m0.byte_cnt); $fatal(1);
      end
      old_commands=command_count; old_reads=read_count;
      $display("INTERRUPT phase=%0d at t=%0t controller_state=%0d byte=%0d cs_n=%0d model_cmd=%0d model_reads=%0d",
        p,$time,card_controller.sd_card_cmd_m0.state,card_controller.sd_card_cmd_m0.byte_cnt,SD_nCS,command_count,read_count);
      @(negedge video_clk); media_reset=1; run_read=0;
      repeat(32) @(posedge video_clk);
      @(negedge video_clk); media_reset=0;
      wait_mounted;
      save_or_compare(0);
      if (protocol_error!==0) begin $display("FAIL card protocol error phase=%0d",p); $fatal(1); end
      if (!card_init_done || command_count<=old_commands) begin
        $display("FAIL card did not reinitialize phase=%0d init=%0d cmds=%0d before=%0d",p,card_init_done,command_count,old_commands); $fatal(1);
      end
      $display("PASS remount phase=%0d command_count=%0d read_count=%0d crc=%0d/%0d",
        p,command_count,read_count,crc_checked,crc_bad);
    end
  endtask

  initial begin
    $display("MODEL_RESET_PORT_ABSENT: model ports are pins + counters only; FPGA rst never reaches model.");
    #100; @(negedge sd_clk); por=0;
    wait_mounted; save_or_compare(1);
    $display("BASE ready bmp=%0d cluster=%0d size=%0d wav=%0d %0d/%0d video=%0d fat=%0d data=%0d clusters=%0d",
      fs_bmp_count,fs_bmp_clusters[31:0],fs_bmp_sizes[31:0],fs_wav_found,fs_wav_cluster,fs_wav_size,
      fs_video_found,fs_fat_lba,fs_data_lba,fs_cluster_count);
    interrupt_runtime_read(0,2);
    interrupt_runtime_read(1,-1);
    interrupt_runtime_read(2,8);
    interrupt_runtime_read(3,37);
    interrupt_runtime_read(4,255);
    interrupt_runtime_read(5,510);
    if (protocol_error!==0 || crc_bad!=0) begin $display("FAIL final model/CRC err=%0d bad=%0d",protocol_error,crc_bad); $fatal(1); end
    $display("PASS six runtime reset phases preserved complete catalog metadata; commands=%0d reads=%0d checked=%0d bad=%0d",
      command_count,read_count,crc_checked,crc_bad);
    $finish;
  end
endmodule
