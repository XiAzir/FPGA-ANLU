module catalog_dual_pair (
    input wire clk, input wire rst, input wire sd_init_done,
    input wire [7:0] catalog_sd_data, input wire catalog_sd_valid, input wire catalog_sd_end,
    output wire catalog_sd_read, output wire [31:0] catalog_sd_addr,
    input wire [7:0] mapper_sd_data, input wire mapper_sd_valid, input wire mapper_sd_end,
    output wire mapper_sd_read, output wire [31:0] mapper_sd_addr,
    input wire bmp_enable, input wire [31:0] bmp_start_cluster, input wire [31:0] bmp_file_size,
    input wire bmp_file_read, input wire [31:0] bmp_file_sector,
    output wire [7:0] bmp_file_data, output wire bmp_file_valid, output wire bmp_file_end,
    output wire bmp_error, output wire [7:0] bmp_error_code,
    input wire wav_file_read, input wire [31:0] wav_file_sector,
    output wire [7:0] wav_file_data, output wire wav_file_valid, output wire wav_file_end,
    output wire wav_error, output wire [7:0] wav_error_code,
    output wire catalog_ready, output wire catalog_error, output wire [7:0] catalog_error_code,
    output wire [31:0] catalog_fat_lba, catalog_data_lba, catalog_cluster_count,
    output wire [3:0] catalog_spc_shift, output wire [2:0] catalog_bmp_count,
    output wire [127:0] catalog_bmp_clusters, catalog_bmp_sizes,
    output wire catalog_wav_found, output wire [31:0] catalog_wav_cluster, catalog_wav_size,
    output wire catalog_video_found, output wire [31:0] catalog_video_cluster, catalog_video_size
);
    fat32_catalog u_catalog (
        .clk(clk),.rst(rst),.sd_init_done(sd_init_done),.sd_read(catalog_sd_read),.sd_addr(catalog_sd_addr),
        .sd_data(catalog_sd_data),.sd_valid(catalog_sd_valid),.sd_end(catalog_sd_end),
        .ready(catalog_ready),.error(catalog_error),.error_code(catalog_error_code),
        .fat_lba(catalog_fat_lba),.data_lba(catalog_data_lba),.cluster_count(catalog_cluster_count),
        .sectors_per_cluster_shift(catalog_spc_shift),.bmp_count(catalog_bmp_count),
        .bmp_clusters(catalog_bmp_clusters),.bmp_sizes(catalog_bmp_sizes),
        .wav_found(catalog_wav_found),.wav_cluster(catalog_wav_cluster),.wav_size(catalog_wav_size),
        .video_found(catalog_video_found),.video_cluster(catalog_video_cluster),.video_size(catalog_video_size)
    );
    fat32_dual_file_sector #(.REQUEST_STABLE(1),.WAV_STATIC_FILE(1)) u_mapper (
        .clk(clk),.rst(rst),.fat_lba(catalog_fat_lba),.data_lba(catalog_data_lba),
        .cluster_count(catalog_cluster_count),.sectors_per_cluster_shift(catalog_spc_shift),
        .bmp_enable(bmp_enable),.bmp_start_cluster(bmp_start_cluster),.bmp_file_size(bmp_file_size),
        .bmp_file_read(bmp_file_read),.bmp_file_sector(bmp_file_sector),
        .bmp_file_data(bmp_file_data),.bmp_file_valid(bmp_file_valid),.bmp_file_end(bmp_file_end),
        .bmp_error(bmp_error),.bmp_error_code(bmp_error_code),
        .wav_enable(catalog_ready && catalog_wav_found && !catalog_error),
        .wav_start_cluster(catalog_wav_cluster),.wav_file_size(catalog_wav_size),
        .wav_file_read(wav_file_read),.wav_file_sector(wav_file_sector),
        .wav_file_data(wav_file_data),.wav_file_valid(wav_file_valid),.wav_file_end(wav_file_end),
        .wav_error(wav_error),.wav_error_code(wav_error_code),
        .sd_read(mapper_sd_read),.sd_addr(mapper_sd_addr),
        .sd_data(mapper_sd_data),.sd_valid(mapper_sd_valid),.sd_end(mapper_sd_end)
    );
endmodule
