`timescale 1ns/1ps

module fat_probe(input clk,rst,init_done,key_next,key_auto,
input [7:0] card_data, input card_valid,card_end,sample_take,
output card_read,output [31:0] card_addr,
output write_en, output [23:0] write_data,
output primed,sample_available,output [15:0] sample_data,
output fs_ready,fs_error,bmp_error,wav_error,bmp_map_error,wav_map_error);
parameter WIDTH=640, HEIGHT=480;
parameter CARD_BYTE_CYCLES=0, AUDIO_SAMPLE_CYCLES=64;
localparam PIXELS=WIDTH*HEIGHT;


wire wav_found;
wire [7:0] fs_code;
wire [31:0] fat_lba,data_lba,cluster_count,wav_cluster,wav_size;
wire [3:0] cluster_shift;
wire [2:0] bmp_count;
wire [127:0] bmp_clusters,bmp_sizes;
wire mount_read; wire [31:0] mount_addr;


wire arb_read; wire [31:0] arb_addr;
wire bmp_phy_read,wav_phy_read;wire [31:0] bmp_phy_addr,wav_phy_addr;
wire [7:0] bmp_phy_data,wav_phy_data;
wire bmp_phy_valid,bmp_phy_end,wav_phy_valid,wav_phy_end;
wire bmp_read,wav_read;wire [31:0] bmp_addr,wav_addr;
wire [7:0] bmp_data,wav_data;wire bmp_valid,bmp_end,wav_valid,wav_end;
wire [7:0] bmp_map_code,wav_map_code;
wire [31:0] bmp_cluster,bmp_size;
wire finish_toggle=0; wire write_ack=write_req;
wire write_req;
wire [1:0] write_buf,disp_buf;wire display_valid;
wire [3:0] bmp_state;


assign card_read=fs_ready?arb_read:mount_read;
assign card_addr=fs_ready?arb_addr:mount_addr;
fat32_catalog u_cat(.clk(clk),.rst(rst),.sd_init_done(init_done),
    .sd_read(mount_read),.sd_addr(mount_addr),.sd_data(card_data),
    .sd_valid(!fs_ready&&card_valid),.sd_end(!fs_ready&&card_end),
    .ready(fs_ready),.error(fs_error),.error_code(fs_code),
    .fat_lba(fat_lba),.data_lba(data_lba),.cluster_count(cluster_count),
    .sectors_per_cluster_shift(cluster_shift),.bmp_count(bmp_count),
    .bmp_clusters(bmp_clusters),.bmp_sizes(bmp_sizes),
    .wav_found(wav_found),.wav_cluster(wav_cluster),.wav_size(wav_size));
tf_bmp_file_player #(.CLK_FREQ_HZ(20000),.FRAME_WIDTH(WIDTH),.FRAME_HEIGHT(HEIGHT),.WAIT_LIMIT(1000000))
    u_bmp(.clk(clk),.rst(rst),.key_next(key_next),.key_auto(key_auto),
    .catalog_ready(fs_ready),.bmp_count(bmp_count),.bmp_clusters(bmp_clusters),.bmp_sizes(bmp_sizes),
    .file_cluster(bmp_cluster),.file_size(bmp_size),.card_read(bmp_read),.card_addr(bmp_addr),
    .card_data(bmp_data),.card_valid(bmp_valid),.card_end(bmp_end),.file_error(bmp_map_error),
    .write_finish_toggle(finish_toggle),.write_buf_idx(write_buf),.disp_buf_idx(disp_buf),
    .write_req(write_req),.write_req_ack(write_ack),.write_en(write_en),.write_data(write_data),
    .display_valid(display_valid),.error(bmp_error),.state_code(bmp_state));
fat32_file_sector u_bmp_map(.clk(clk),.rst(rst),.enable(fs_ready),
    .fat_lba(fat_lba),.data_lba(data_lba),.cluster_count(cluster_count),.sectors_per_cluster_shift(cluster_shift),
    .start_cluster(bmp_cluster),.file_size(bmp_size),.file_read(bmp_read),.file_sector(bmp_addr),
    .file_data(bmp_data),.file_valid(bmp_valid),.file_end(bmp_end),.error(bmp_map_error),.error_code(bmp_map_code),
    .sd_read(bmp_phy_read),.sd_addr(bmp_phy_addr),.sd_data(bmp_phy_data),.sd_valid(bmp_phy_valid),.sd_end(bmp_phy_end));
fat32_file_sector u_wav_map(.clk(clk),.rst(rst),.enable(fs_ready&&wav_found),
    .fat_lba(fat_lba),.data_lba(data_lba),.cluster_count(cluster_count),.sectors_per_cluster_shift(cluster_shift),
    .start_cluster(wav_cluster),.file_size(wav_size),.file_read(wav_read),.file_sector(wav_addr),
    .file_data(wav_data),.file_valid(wav_valid),.file_end(wav_end),.error(wav_map_error),.error_code(wav_map_code),
    .sd_read(wav_phy_read),.sd_addr(wav_phy_addr),.sd_data(wav_phy_data),.sd_valid(wav_phy_valid),.sd_end(wav_phy_end));
tf_wav_file_player #(.FIFO_DEPTH(2048),.WAIT_LIMIT(1000000)) u_wav
    (.clk(clk),.rst(rst),.sd_init_done(fs_ready&&wav_found),.file_size(wav_size),.file_error(wav_map_error),
    .sd_read(wav_read),.sd_addr(wav_addr),.sd_data(wav_data),.sd_valid(wav_valid),.sd_end(wav_end),
    .sample_take(sample_take),.sample_data(sample_data),.sample_available(sample_available),.primed(primed),.error(wav_error));
sd_sector_arbiter u_arb(.clk(clk),.rst(rst||!fs_ready),
    .bmp_read(bmp_phy_read),.bmp_addr(bmp_phy_addr),.wav_read(wav_phy_read),.wav_addr(wav_phy_addr),
    .card_read(arb_read),.card_addr(arb_addr),.card_data(card_data),
    .card_valid(fs_ready&&card_valid),.card_end(fs_ready&&card_end),
    .bmp_data(bmp_phy_data),.bmp_valid(bmp_phy_valid),.bmp_end(bmp_phy_end),
    .wav_data(wav_phy_data),.wav_valid(wav_phy_valid),.wav_end(wav_phy_end));

endmodule
