module mapper_pair_dual_ref (
    input wire clk, rst,
    input wire bmp_enable, input wire [31:0] bmp_start_cluster, bmp_file_size,
    input wire bmp_file_read, input wire [31:0] bmp_file_sector,
    output wire [7:0] bmp_file_data, output wire bmp_file_valid, bmp_file_end,
    output wire bmp_error, output wire [7:0] bmp_error_code,
    input wire wav_enable, input wire [31:0] wav_start_cluster, wav_file_size,
    input wire wav_file_read, input wire [31:0] wav_file_sector,
    output wire [7:0] wav_file_data, output wire wav_file_valid, wav_file_end,
    output wire wav_error, output wire [7:0] wav_error_code,
    input wire [31:0] fat_lba, data_lba, cluster_count,
    input wire [3:0] sectors_per_cluster_shift,
    output wire card_read, output wire [31:0] card_addr,
    input wire [7:0] card_data, input wire card_valid, card_end
);
    wire bmp_read, wav_read;
    wire [31:0] bmp_addr, wav_addr;
    wire [7:0] bmp_sd_data, wav_sd_data;
    wire bmp_sd_valid, bmp_sd_end, wav_sd_valid, wav_sd_end;
    fat32_file_sector #(.WAIT_LIMIT(32'd50000000),.CATALOG_GEOMETRY(1),.REQUEST_STABLE(1)) u_bmp(
        .clk(clk),.rst(rst),.enable(bmp_enable),.fat_lba(fat_lba),.data_lba(data_lba),
        .cluster_count(cluster_count),.sectors_per_cluster_shift(sectors_per_cluster_shift),
        .start_cluster(bmp_start_cluster),.file_size(bmp_file_size),.file_read(bmp_file_read),
        .file_sector(bmp_file_sector),.file_data(bmp_file_data),.file_valid(bmp_file_valid),
        .file_end(bmp_file_end),.error(bmp_error),.error_code(bmp_error_code),
        .sd_read(bmp_read),.sd_addr(bmp_addr),.sd_data(bmp_sd_data),
        .sd_valid(bmp_sd_valid),.sd_end(bmp_sd_end)
    );
    fat32_file_sector #(.WAIT_LIMIT(32'd50000000),.CATALOG_GEOMETRY(1),.STATIC_FILE(1),.REQUEST_STABLE(1)) u_wav(
        .clk(clk),.rst(rst),.enable(wav_enable),.fat_lba(fat_lba),.data_lba(data_lba),
        .cluster_count(cluster_count),.sectors_per_cluster_shift(sectors_per_cluster_shift),
        .start_cluster(wav_start_cluster),.file_size(wav_file_size),.file_read(wav_file_read),
        .file_sector(wav_file_sector),.file_data(wav_file_data),.file_valid(wav_file_valid),
        .file_end(wav_file_end),.error(wav_error),.error_code(wav_error_code),
        .sd_read(wav_read),.sd_addr(wav_addr),.sd_data(wav_sd_data),
        .sd_valid(wav_sd_valid),.sd_end(wav_sd_end)
    );
    sd_sector_arbiter u_arbiter(
        .clk(clk),.rst(rst),.bmp_read(bmp_read),.bmp_addr(bmp_addr),
        .wav_read(wav_read),.wav_addr(wav_addr),.card_read(card_read),.card_addr(card_addr),
        .card_data(card_data),.card_valid(card_valid),.card_end(card_end),
        .bmp_data(bmp_sd_data),.bmp_valid(bmp_sd_valid),.bmp_end(bmp_sd_end),
        .wav_data(wav_sd_data),.wav_valid(wav_sd_valid),.wav_end(wav_sd_end)
    );
endmodule

module mapper_pair_shared (
    input wire clk, rst,
    input wire bmp_enable, input wire [31:0] bmp_start_cluster, bmp_file_size,
    input wire bmp_file_read, input wire [31:0] bmp_file_sector,
    output wire [7:0] bmp_file_data, output wire bmp_file_valid, bmp_file_end,
    output wire bmp_error, output wire [7:0] bmp_error_code,
    input wire wav_enable, input wire [31:0] wav_start_cluster, wav_file_size,
    input wire wav_file_read, input wire [31:0] wav_file_sector,
    output wire [7:0] wav_file_data, output wire wav_file_valid, wav_file_end,
    output wire wav_error, output wire [7:0] wav_error_code,
    input wire [31:0] fat_lba, data_lba, cluster_count,
    input wire [3:0] sectors_per_cluster_shift,
    output wire card_read, output wire [31:0] card_addr,
    input wire [7:0] card_data, input wire card_valid, card_end
);
    fat32_dual_file_sector #(
        .WAIT_LIMIT(32'd50000000),.AUDIO_BURST_MAX(2),
        .REQUEST_STABLE(1),.WAV_STATIC_FILE(1)
    ) u_shared(
        .clk(clk),.rst(rst),.fat_lba(fat_lba),.data_lba(data_lba),
        .cluster_count(cluster_count),.sectors_per_cluster_shift(sectors_per_cluster_shift),
        .bmp_enable(bmp_enable),.bmp_start_cluster(bmp_start_cluster),
        .bmp_file_size(bmp_file_size),.bmp_file_read(bmp_file_read),.bmp_file_sector(bmp_file_sector),
        .bmp_file_data(bmp_file_data),.bmp_file_valid(bmp_file_valid),.bmp_file_end(bmp_file_end),
        .bmp_error(bmp_error),.bmp_error_code(bmp_error_code),
        .wav_enable(wav_enable),.wav_start_cluster(wav_start_cluster),
        .wav_file_size(wav_file_size),.wav_file_read(wav_file_read),.wav_file_sector(wav_file_sector),
        .wav_file_data(wav_file_data),.wav_file_valid(wav_file_valid),.wav_file_end(wav_file_end),
        .wav_error(wav_error),.wav_error_code(wav_error_code),
        .sd_read(card_read),.sd_addr(card_addr),.sd_data(card_data),
        .sd_valid(card_valid),.sd_end(card_end)
    );
endmodule
