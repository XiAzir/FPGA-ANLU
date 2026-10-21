module mapper_pair_generic (
    input wire clk, rst,
    input wire bmp_enable, bmp_file_read,
    input wire [31:0] bmp_start_cluster, bmp_file_size, bmp_file_sector,
    input wire [7:0] bmp_sd_data, input wire bmp_sd_valid, bmp_sd_end,
    output wire [7:0] bmp_file_data, output wire bmp_file_valid, bmp_file_end,
    output wire bmp_error, output wire [7:0] bmp_error_code,
    output wire bmp_sd_read, output wire [31:0] bmp_sd_addr,
    input wire wav_enable, wav_file_read,
    input wire [31:0] wav_start_cluster, wav_file_size, wav_file_sector,
    input wire [7:0] wav_sd_data, input wire wav_sd_valid, wav_sd_end,
    output wire [7:0] wav_file_data, output wire wav_file_valid, wav_file_end,
    output wire wav_error, output wire [7:0] wav_error_code,
    output wire wav_sd_read, output wire [31:0] wav_sd_addr,
    input wire [31:0] fat_lba, data_lba, cluster_count,
    input wire [3:0] sectors_per_cluster_shift
);
    fat32_file_sector #(.WAIT_LIMIT(32'd50000000)) u_bmp_mapper (
        .clk(clk),.rst(rst),.enable(bmp_enable),.fat_lba(fat_lba),.data_lba(data_lba),
        .cluster_count(cluster_count),.sectors_per_cluster_shift(sectors_per_cluster_shift),
        .start_cluster(bmp_start_cluster),.file_size(bmp_file_size),
        .file_read(bmp_file_read),.file_sector(bmp_file_sector),
        .file_data(bmp_file_data),.file_valid(bmp_file_valid),.file_end(bmp_file_end),
        .error(bmp_error),.error_code(bmp_error_code),.sd_read(bmp_sd_read),.sd_addr(bmp_sd_addr),
        .sd_data(bmp_sd_data),.sd_valid(bmp_sd_valid),.sd_end(bmp_sd_end)
    );
    fat32_file_sector #(.WAIT_LIMIT(32'd50000000)) u_wav_mapper (
        .clk(clk),.rst(rst),.enable(wav_enable),.fat_lba(fat_lba),.data_lba(data_lba),
        .cluster_count(cluster_count),.sectors_per_cluster_shift(sectors_per_cluster_shift),
        .start_cluster(wav_start_cluster),.file_size(wav_file_size),
        .file_read(wav_file_read),.file_sector(wav_file_sector),
        .file_data(wav_file_data),.file_valid(wav_file_valid),.file_end(wav_file_end),
        .error(wav_error),.error_code(wav_error_code),.sd_read(wav_sd_read),.sd_addr(wav_sd_addr),
        .sd_data(wav_sd_data),.sd_valid(wav_sd_valid),.sd_end(wav_sd_end)
    );
endmodule

module mapper_pair_specialized (
    input wire clk, rst,
    input wire bmp_enable, bmp_file_read,
    input wire [31:0] bmp_start_cluster, bmp_file_size, bmp_file_sector,
    input wire [7:0] bmp_sd_data, input wire bmp_sd_valid, bmp_sd_end,
    output wire [7:0] bmp_file_data, output wire bmp_file_valid, bmp_file_end,
    output wire bmp_error, output wire [7:0] bmp_error_code,
    output wire bmp_sd_read, output wire [31:0] bmp_sd_addr,
    input wire wav_enable, wav_file_read,
    input wire [31:0] wav_start_cluster, wav_file_size, wav_file_sector,
    input wire [7:0] wav_sd_data, input wire wav_sd_valid, wav_sd_end,
    output wire [7:0] wav_file_data, output wire wav_file_valid, wav_file_end,
    output wire wav_error, output wire [7:0] wav_error_code,
    output wire wav_sd_read, output wire [31:0] wav_sd_addr,
    input wire [31:0] fat_lba, data_lba, cluster_count,
    input wire [3:0] sectors_per_cluster_shift
);
    // Top contract: catalog geometry for both readers; BMP descriptor tags
    // remain because images change while enable stays high; WAV is one fixed file.
    fat32_file_sector #(
        .WAIT_LIMIT(32'd50000000),.CATALOG_GEOMETRY(1),.REQUEST_STABLE(1)
    ) u_bmp_mapper (
        .clk(clk),.rst(rst),.enable(bmp_enable),.fat_lba(fat_lba),.data_lba(data_lba),
        .cluster_count(cluster_count),.sectors_per_cluster_shift(sectors_per_cluster_shift),
        .start_cluster(bmp_start_cluster),.file_size(bmp_file_size),
        .file_read(bmp_file_read),.file_sector(bmp_file_sector),
        .file_data(bmp_file_data),.file_valid(bmp_file_valid),.file_end(bmp_file_end),
        .error(bmp_error),.error_code(bmp_error_code),.sd_read(bmp_sd_read),.sd_addr(bmp_sd_addr),
        .sd_data(bmp_sd_data),.sd_valid(bmp_sd_valid),.sd_end(bmp_sd_end)
    );
    fat32_file_sector #(
        .WAIT_LIMIT(32'd50000000),.CATALOG_GEOMETRY(1),.STATIC_FILE(1),.REQUEST_STABLE(1)
    ) u_wav_mapper (
        .clk(clk),.rst(rst),.enable(wav_enable),.fat_lba(fat_lba),.data_lba(data_lba),
        .cluster_count(cluster_count),.sectors_per_cluster_shift(sectors_per_cluster_shift),
        .start_cluster(wav_start_cluster),.file_size(wav_file_size),
        .file_read(wav_file_read),.file_sector(wav_file_sector),
        .file_data(wav_file_data),.file_valid(wav_file_valid),.file_end(wav_file_end),
        .error(wav_error),.error_code(wav_error_code),.sd_read(wav_sd_read),.sd_addr(wav_sd_addr),
        .sd_data(wav_sd_data),.sd_valid(wav_sd_valid),.sd_end(wav_sd_end)
    );
endmodule
