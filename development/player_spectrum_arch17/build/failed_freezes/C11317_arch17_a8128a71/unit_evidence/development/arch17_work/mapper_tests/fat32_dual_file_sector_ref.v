module fat32_dual_file_sector_ref #(
    parameter [31:0] WAIT_LIMIT = 32'd50000000,
    parameter integer AUDIO_BURST_MAX = 2
)(
    input wire clk, input wire rst,
    input wire [31:0] fat_lba, input wire [31:0] data_lba,
    input wire [31:0] cluster_count, input wire [3:0] sectors_per_cluster_shift,
    input wire bmp_enable, input wire [31:0] bmp_start_cluster, bmp_file_size,
    input wire bmp_file_read, input wire [31:0] bmp_file_sector,
    output wire [7:0] bmp_file_data, output wire bmp_file_valid, bmp_file_end,
    output wire bmp_error, output wire [7:0] bmp_error_code,
    input wire wav_enable, input wire [31:0] wav_start_cluster, wav_file_size,
    input wire wav_file_read, input wire [31:0] wav_file_sector,
    output wire [7:0] wav_file_data, output wire wav_file_valid, wav_file_end,
    output wire wav_error, output wire [7:0] wav_error_code,
    output wire sd_read, output wire [31:0] sd_addr,
    input wire [7:0] sd_data, input wire sd_valid, input wire sd_end
);
    wire bmp_phy_read, wav_phy_read;
    wire [31:0] bmp_phy_addr, wav_phy_addr;
    wire [7:0] bmp_phy_data, wav_phy_data;
    wire bmp_phy_valid, bmp_phy_end, wav_phy_valid, wav_phy_end;
    wire [7:0] bmp_raw_data, wav_raw_data;
    wire bmp_raw_valid, bmp_raw_end, wav_raw_valid, wav_raw_end;
    wire bmp_raw_error, wav_raw_error;
    wire [7:0] bmp_raw_error_code, wav_raw_error_code;

    fat32_file_sector #(.WAIT_LIMIT(WAIT_LIMIT), .CATALOG_GEOMETRY(1), .REQUEST_STABLE(1)) u_bmp (
        .clk(clk), .rst(rst), .enable(bmp_enable), .fat_lba(fat_lba), .data_lba(data_lba),
        .cluster_count(cluster_count), .sectors_per_cluster_shift(sectors_per_cluster_shift),
        .start_cluster(bmp_start_cluster), .file_size(bmp_file_size), .file_read(bmp_file_read), .file_sector(bmp_file_sector),
        .file_data(bmp_raw_data), .file_valid(bmp_raw_valid), .file_end(bmp_raw_end),
        .error(bmp_raw_error), .error_code(bmp_raw_error_code), .sd_read(bmp_phy_read), .sd_addr(bmp_phy_addr),
        .sd_data(bmp_phy_data), .sd_valid(bmp_phy_valid), .sd_end(bmp_phy_end)
    );
    fat32_file_sector #(.WAIT_LIMIT(WAIT_LIMIT), .CATALOG_GEOMETRY(1), .STATIC_FILE(1), .REQUEST_STABLE(1)) u_wav (
        .clk(clk), .rst(rst), .enable(wav_enable), .fat_lba(fat_lba), .data_lba(data_lba),
        .cluster_count(cluster_count), .sectors_per_cluster_shift(sectors_per_cluster_shift),
        .start_cluster(wav_start_cluster), .file_size(wav_file_size), .file_read(wav_file_read), .file_sector(wav_file_sector),
        .file_data(wav_raw_data), .file_valid(wav_raw_valid), .file_end(wav_raw_end),
        .error(wav_raw_error), .error_code(wav_raw_error_code), .sd_read(wav_phy_read), .sd_addr(wav_phy_addr),
        .sd_data(wav_phy_data), .sd_valid(wav_phy_valid), .sd_end(wav_phy_end)
    );
    sd_sector_arbiter u_arbiter (
        .clk(clk), .rst(rst), .bmp_read(bmp_phy_read), .bmp_addr(bmp_phy_addr),
        .wav_read(wav_phy_read), .wav_addr(wav_phy_addr),
        .card_read(sd_read), .card_addr(sd_addr), .card_data(sd_data), .card_valid(sd_valid), .card_end(sd_end),
        .bmp_data(bmp_phy_data), .bmp_valid(bmp_phy_valid), .bmp_end(bmp_phy_end),
        .wav_data(wav_phy_data), .wav_valid(wav_phy_valid), .wav_end(wav_phy_end)
    );
    assign bmp_file_data = bmp_raw_data;
    assign bmp_file_valid = bmp_raw_valid;
    assign bmp_file_end = bmp_raw_end;
    assign bmp_error = bmp_raw_error;
    assign bmp_error_code = bmp_raw_error_code;
    assign wav_file_data = wav_raw_data;
    assign wav_file_valid = wav_raw_valid;
    assign wav_file_end = wav_raw_end;
    assign wav_error = wav_raw_error;
    assign wav_error_code = wav_raw_error_code;
endmodule
