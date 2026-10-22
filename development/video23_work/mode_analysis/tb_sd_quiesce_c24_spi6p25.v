`timescale 1ns/1ps
module tb_sd_quiesce_integration;
  reg sd_clk=0, video_clk=0, por=1;
  reg runtime_read=0, request_toggle=0, ack_toggle=0;
  reg inject_crc_fault=0;
  reg [31:0] runtime_addr=4130;
  reg [1:0] commit_sync=0;
  reg commit_seen=0, mode=0;
  wire SD_nCS,SD_DCLK,SD_MOSI,SD_MISO,card_init_done,card_idle;
  wire [7:0] card_data;
  wire card_valid,card_end;
  wire [15:0] crc_checked,crc_bad;
  wire [31:0] command_count,read_count,last_lba;
  wire [31:0] cmd0_count;
  wire protocol_error;
  wire fs_read,fs_ready,fs_error,fs_wav_found,fs_video_found;
  wire [31:0] fs_addr,fs_fat_lba,fs_data_lba,fs_cluster_count;
  wire [3:0] fs_spc_shift;
  wire [2:0] fs_bmp_count;
  wire [127:0] fs_bmp_clusters,fs_bmp_sizes;
  wire [31:0] fs_wav_cluster,fs_wav_size,fs_video_cluster,fs_video_size;
  wire [7:0] fs_error_code;
  wire gate_new_sector,commit_toggle,busy;
  wire sd_read=fs_ready ? (runtime_read && !gate_new_sector) : fs_read;
  wire [31:0] sd_addr=fs_ready ? runtime_addr : fs_addr;
  wire physical_idle=card_init_done && !sd_read && card_idle;

  always #10 sd_clk=~sd_clk;
  always #17 video_clk=~video_clk;
  always @(posedge video_clk) begin
    if(por) begin commit_sync<=0;commit_seen<=0;end
    else commit_sync<={commit_sync[0],commit_toggle};
  end

  sd_spi_card_model #(.IMAGE_BYTES(67108864),.MAPPED_SECTORS(2073),
    .IMAGE_FILE("packed_mem.mem"),.LBA_MAP_FILE("lba_map.mem")) card_model(
    .cs_n(SD_nCS),.sck(SD_DCLK),.mosi(SD_MOSI),.miso(SD_MISO),
    .command_count(command_count),.read_count(read_count),.last_lba(last_lba),.protocol_error(protocol_error),
    .cmd0_count(cmd0_count),.inject_crc_fault(inject_crc_fault));
  sd_card_top #(.SPI_HIGH_SPEED_DIV(2)) card_controller(
    .clk(sd_clk),.rst(por),.SD_nCS(SD_nCS),.SD_DCLK(SD_DCLK),.SD_MOSI(SD_MOSI),.SD_MISO(SD_MISO),
    .sd_init_done(card_init_done),.sd_idle(card_idle),.sd_sec_read(sd_read),.sd_sec_read_addr(sd_addr),
    .sd_sec_read_data(card_data),.sd_sec_read_data_valid(card_valid),.sd_sec_read_end(card_end),
    .sd_sec_write(1'b0),.sd_sec_write_addr(32'd0),.sd_sec_write_data(8'd0),
    .sd_sec_write_data_req(),.sd_sec_write_end(),.read_crc_checked(crc_checked),.read_crc_bad(crc_bad));
  fat32_catalog catalog(
    .clk(sd_clk),.rst(por),.sd_init_done(card_init_done),.sd_read(fs_read),.sd_addr(fs_addr),
    .sd_data(card_data),.sd_valid(!fs_ready && card_valid),.sd_end(!fs_ready && card_end),
    .ready(fs_ready),.error(fs_error),.error_code(fs_error_code),
    .fat_lba(fs_fat_lba),.data_lba(fs_data_lba),.cluster_count(fs_cluster_count),
    .sectors_per_cluster_shift(fs_spc_shift),.bmp_count(fs_bmp_count),.bmp_clusters(fs_bmp_clusters),
    .bmp_sizes(fs_bmp_sizes),.wav_found(fs_wav_found),.wav_cluster(fs_wav_cluster),.wav_size(fs_wav_size),
    .video_found(fs_video_found),.video_cluster(fs_video_cluster),.video_size(fs_video_size));
  player_mode_quiesce quiesce(
    .clk(sd_clk),.rst(por),.request_toggle_async(request_toggle),.ack_toggle_async(ack_toggle),
    .physical_idle(physical_idle),.mount_ready(fs_ready),.gate_new_sector(gate_new_sector),
    .commit_toggle(commit_toggle),.busy(busy));


  time previous_runtime_edge=0;
  integer runtime_period_checks=0;
  always @(posedge SD_DCLK) begin
    if(card_controller.sd_card_cmd_m0.state==7) begin
      if(previous_runtime_edge!=0 && card_controller.spi_master_m0.clk_edge_cnt!=2) begin
        if($time-previous_runtime_edge!=160) $fatal(1,"SPI period expected160ns actual%0t",$time-previous_runtime_edge);
        runtime_period_checks=runtime_period_checks+1;
      end
      previous_runtime_edge=$time;
    end else previous_runtime_edge=0;
  end

  integer phase, target_state, target_byte, n, base_reads, base_crc, base_cmds, base_cmd0, base_bad;
  reg old_commit, hit;
  task run_phase;
    input integer p;
    begin
      case(p)
        0: begin target_state=4;target_byte=2;end
        1: begin target_state=6;target_byte=-1;end
        default: begin target_state=7;target_byte=(p==2?8:(p==3?37:(p==4?255:510)));end
      endcase
      base_reads=read_count; base_crc=crc_checked; old_commit=commit_toggle;
      runtime_addr=4130; runtime_read=1;
      n=0;
      while(card_controller.sd_card_sec_read_write_m0.state!=5'd5 && n<2000000) begin @(negedge sd_clk);n=n+1;end
      if(n>=2000000) begin $display("FAIL phase %0d runtime read not accepted",p);$fatal(1);end
      runtime_read=0;
      hit=0;n=0;
      while(!hit && n<2000000) begin
        @(negedge sd_clk);n=n+1;
        if(card_controller.sd_card_cmd_m0.state==target_state &&
           (target_byte<0 || card_controller.sd_card_cmd_m0.byte_cnt==target_byte)) hit=1;
      end
      if(!hit) begin $display("FAIL phase %0d target state=%0d byte=%0d",p,target_state,target_byte);$fatal(1);end
      $display("QUIESCE_REQUEST phase=%0d state=%0d byte=%0d cs_n=%0d",p,
        card_controller.sd_card_cmd_m0.state,card_controller.sd_card_cmd_m0.byte_cnt,SD_nCS);
      @(negedge video_clk);request_toggle=~request_toggle;
      wait(gate_new_sector);
      wait(card_end);
      wait(commit_toggle!=old_commit);
      if(!gate_new_sector || !physical_idle) begin $display("FAIL phase %0d commit before idle",p);$fatal(1);end
      if(!fs_ready || fs_error || command_count!=base_cmds+1 || cmd0_count!=base_cmd0 || card_model.protocol_error) begin
        $display("FAIL phase %0d catalog/card changed ready=%0d err=%0d code=%02x cmds=%0d/%0d protocol=%0d",
          p,fs_ready,fs_error,fs_error_code,command_count,base_cmds,card_model.protocol_error);$fatal(1);
      end
      if(read_count!=base_reads+1 || crc_checked!=base_crc+1 || crc_bad!=0) begin
        $display("FAIL phase %0d read/crc reads=%0d/%0d checked=%0d/%0d bad=%0d",p,
          read_count,base_reads,crc_checked,base_crc,crc_bad);$fatal(1);
      end
      base_cmds=command_count;
      wait(commit_sync[1]!=commit_seen);
      mode=~mode;commit_seen=commit_sync[1];
      repeat(8) @(posedge video_clk);
      ack_toggle=commit_seen;
      wait(!gate_new_sector);
      $display("PASS physical drain phase=%0d mode=%0d reads=%0d crc=%0d/%0d commands=%0d CMD0=%0d",
        p,mode,read_count,crc_checked,crc_bad,command_count,cmd0_count);
    end
  endtask

  initial begin
    #100;@(negedge sd_clk);por=0;
    n=0;while(!fs_ready && !fs_error && n<4000000)begin @(posedge sd_clk);n=n+1;end
    if(!fs_ready || fs_error)begin $display("FAIL initial mount ready=%0d err=%0d code=%02x",fs_ready,fs_error,fs_error_code);$fatal(1);end
    base_cmds=command_count;base_cmd0=cmd0_count;
    if(fs_bmp_count!=1 || fs_video_found)begin $display("FAIL fixture metadata");$fatal(1);end
    if(cmd0_count!=1)begin $display("FAIL cold CMD0 count=%0d",cmd0_count);$fatal(1);end
    $display("BASE mounted commands=%0d reads=%0d crc=%0d/%0d CMD0=%0d",command_count,read_count,crc_checked,crc_bad,cmd0_count);
    for(phase=0;phase<6;phase=phase+1) run_phase(phase);
    if(!fs_ready || fs_error || crc_bad!=0 || command_count!=base_cmds || cmd0_count!=base_cmd0 || protocol_error)begin
      $display("FAIL final ready=%0d error=%0d crc_bad=%0d commands=%0d/%0d CMD0=%0d/%0d protocol=%0d",
        fs_ready,fs_error,crc_bad,command_count,base_cmds,cmd0_count,base_cmd0,protocol_error);$fatal(1);
    end
    $display("PASS six phase drain preserved catalog/card session; cold CMD0 count=1, runtime CMD0 count unchanged");
    base_reads=read_count;base_crc=crc_checked;base_bad=crc_bad;
    inject_crc_fault=1;runtime_addr=4130;runtime_read=1;
    wait(card_controller.sd_card_sec_read_write_m0.state==5'd5);
    runtime_read=0;wait(card_end);
    if(read_count!=base_reads+1 || crc_checked!=base_crc+1 || crc_bad!=base_bad+1 || !fs_ready || fs_error)begin
      $display("FAIL single-bit CRC control read=%0d/%0d checked=%0d/%0d bad=%0d/%0d ready=%0d err=%0d",
        read_count,base_reads,crc_checked,base_crc,crc_bad,base_bad,fs_ready,fs_error);$fatal(1);
    end
    $display("PASS negative control: injected one payload bit; CRC bad incremented to %0d",crc_bad);
    if(runtime_period_checks<1000)$fatal(1,"insufficient SPI period coverage");
    $display("PASS SPI6.25 periods160ns checks=%0d",runtime_period_checks);
    $finish;
  end
endmodule


