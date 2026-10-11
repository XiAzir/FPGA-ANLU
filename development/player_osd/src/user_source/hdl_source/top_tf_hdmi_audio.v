
module top(
    input                       clk,
    input                       rst_n,
    input                       key1,           // 手动下一张
    input                       key2,           // 自动播放 开/关

    output [3:0]                led,
    output seg7_dio, seg7_sclk, seg7_rclk,

    // HDMI TMDS
    output                      HDMI_CLK_P,
    output                      HDMI_D2_P,
    output                      HDMI_D1_P,
    output                      HDMI_D0_P,

    // TF card SPI
    output                      sd_ncs,
    output                      sd_dclk,
    output                      sd_mosi,
    input                       sd_miso
);

localparam DISPLAY_WIDTH = 640;
localparam DISPLAY_HEIGHT = 480;


wire sd_card_clk;
wire ext_mem_clk;
wire ext_mem_clk_sft;
wire video_clk;
wire hdmi_5x_clk;

wire hs;
wire vs;
wire de;

wire [23:0] vout_data_raw;
wire [23:0] vout_data;
wire [23:0] vout_data_base;
wire        display_valid;

wire [3:0]  state_code;

wire        video_read_req;
wire        video_read_req_ack;
wire        video_read_req_osd;
wire        video_read_en;
wire [23:0] video_read_data;

wire        sd_card_write_en;
wire [23:0] sd_card_write_data;
wire        sd_card_write_req;
wire        sd_card_write_req_ack;
wire        frame_write_finish;
reg         frame_write_toggle_mem;

wire [1:0]  write_buf_idx;
wire [1:0]  disp_buf_idx;
wire [1:0]  current_image_index, osd_buffer_idx, osd_image_index;
wire [2:0]  osd_image_count;
wire        bmp_auto_mode, osd_auto_mode, osd_frame_valid;

wire hs_0;
wire vs_0;
wire de_0;

wire bmp_card_read, bmp_card_valid, bmp_card_end;
wire [31:0] bmp_card_addr;
wire [7:0] bmp_card_data;
wire wav_card_read, wav_card_valid, wav_card_end;
wire [31:0] wav_card_addr;
wire [7:0] wav_card_data;
wire shared_card_read, shared_card_valid, shared_card_end, card_init_done;
wire [31:0] shared_card_addr;
wire [7:0] shared_card_data;
wire wav_sample_take, wav_sample_available, wav_primed, wav_error;
wire [15:0] wav_sample_data;
wire audio_underflow;
wire fs_ready, fs_error, fs_wav_found, bmp_error;
wire [7:0] fs_error_code, bmp_map_error_code, wav_map_error_code;
wire [31:0] fs_fat_lba, fs_data_lba, fs_cluster_count;
wire [3:0] fs_cluster_shift;
wire [2:0] fs_bmp_count;
wire [127:0] fs_bmp_clusters, fs_bmp_sizes;
wire [31:0] fs_wav_cluster, fs_wav_size, bmp_file_cluster, bmp_file_size;
wire fs_read, bmp_phy_read, wav_phy_read, bmp_map_error, wav_map_error;
wire [31:0] fs_addr, bmp_phy_addr, wav_phy_addr;
wire [7:0] bmp_phy_data, wav_phy_data;
wire bmp_phy_valid, bmp_phy_end, wav_phy_valid, wav_phy_end;
wire arb_card_read, arb_card_valid, arb_card_end;
wire [31:0] arb_card_addr;
// Declare diagnostic buses before their first connection (TD rejects implicit
// vector redeclarations with critical warnings).
wire [3:0] debug_wav_state, debug_wav_phase;
wire [31:0] debug_wav_pos;
wire [7:0] debug_wav_byte;
wire [127:0] debug_rows_sd;
// Stereo PCM and HDMI audio clock regeneration, all in the pixel clock domain.
wire        audio_valid;
wire [23:0] audio_left_data;
wire [23:0] audio_right_data;
wire        acr_valid;
wire [19:0] acr_cts;
wire [19:0] acr_n;
// HDMI 1.4b 相关
wire        axis_s_user;
wire        axis_s_valid;
wire        axis_s_last;
wire [23:0] axis_s_data;
wire        axis_s_ready;
wire        hdmi_video_locked;
wire [31:0] status_hex;
wire [23:0] packet_samples, packet_count, packet_bad_bch, packet_bad_terc, packet_tone_bad;
wire [19:0] packet_cts, packet_n;
wire [3:0] packet_flags;
// Display uses the running pixel clock, independently of playback reset.
wire status_clk = video_clk;
reg [1:0] status_reset_pipe=2'b11;
always @(posedge status_clk or negedge rst_n) begin
    if(!rst_n) status_reset_pipe<=2'b11;
    else status_reset_pipe<={status_reset_pipe[0],1'b0};
end
wire status_sys_rst=status_reset_pipe[1];


wire [9:0]  tmds_ch0_data;
wire [9:0]  tmds_ch1_data;
wire [9:0]  tmds_ch2_data;
wire [9:0]  tmds_clk_data;

// 统一复位：TF 图像链路 + HDMI 链路
wire sys_pll_lock;
wire video_pll_lock;
wire rst_all;

reg [19:0] rst_cnt = 20'd0;
reg rst_all_reg = 1'b1;

always @(posedge clk) begin
    if (!rst_n) begin
        rst_cnt <= 20'd0;
        rst_all_reg <= 1'b1;
    end else if (!rst_all_reg) begin
        // 一旦复位释放，忽略后续微小的 PLL 抖动，防止系统在使用时随机复位
        rst_all_reg <= 1'b0;
    end else if (sys_pll_lock && video_pll_lock) begin
        // 等待 PLL 连续稳定 20ms @ 50MHz
        if (rst_cnt < 20'd1_000_000) begin
            rst_cnt <= rst_cnt + 1'b1;
            rst_all_reg <= 1'b1;
        end else begin
            rst_all_reg <= 1'b0;
        end
    end else begin
        rst_cnt <= 20'd0;
        rst_all_reg <= 1'b1;
    end
end

assign rst_all = rst_all_reg;

// 保持你原来的 TF / SDRAM / video 时钟
sys_pll sys_pll_m0(
    .refclk     (clk),
    .reset      (1'b0),
    .extlock    (sys_pll_lock),
    .clk0_out   (sd_card_clk),
    .clk1_out   (ext_mem_clk),
    .clk2_out   (ext_mem_clk_sft)
);

video_pll video_pll_m0(
    .refclk     (clk),
    .reset      (1'b0),
    .extlock    (video_pll_lock),
    .clk0_out   (video_clk),
    .clk1_out   (hdmi_5x_clk)
);

// mem_clk 域把 write_finish 单拍转成 toggle，供 sd_card_clk 域可靠同步
always @(posedge ext_mem_clk or posedge rst_all) begin
    if (rst_all)
        frame_write_toggle_mem <= 1'b0;
    else if (frame_write_finish)
        frame_write_toggle_mem <= ~frame_write_toggle_mem;
end

// Mount owns the card at startup. Runtime clients request logical file sectors.
fat32_catalog u_catalog (
    .clk(sd_card_clk),.rst(rst_all),.sd_init_done(card_init_done),
    .sd_read(fs_read),.sd_addr(fs_addr),.sd_data(shared_card_data),
    .sd_valid(!fs_ready && shared_card_valid),.sd_end(!fs_ready && shared_card_end),
    .ready(fs_ready),.error(fs_error),.error_code(fs_error_code),
    .fat_lba(fs_fat_lba),.data_lba(fs_data_lba),.cluster_count(fs_cluster_count),
    .sectors_per_cluster_shift(fs_cluster_shift),.bmp_count(fs_bmp_count),
    .bmp_clusters(fs_bmp_clusters),.bmp_sizes(fs_bmp_sizes),
    .wav_found(fs_wav_found),.wav_cluster(fs_wav_cluster),.wav_size(fs_wav_size)
);
tf_bmp_file_player #(.CLK_FREQ_HZ(50000000),
    .FRAME_WIDTH(DISPLAY_WIDTH),.FRAME_HEIGHT(DISPLAY_HEIGHT)) u_bmp_file_player (
    .clk(sd_card_clk),.rst(rst_all),.key_next(key1),.key_auto(key2),
    .catalog_ready(fs_ready),.bmp_count(fs_bmp_count),
    .bmp_clusters(fs_bmp_clusters),.bmp_sizes(fs_bmp_sizes),
    .file_cluster(bmp_file_cluster),.file_size(bmp_file_size),
    .card_read(bmp_card_read),.card_addr(bmp_card_addr),
    .card_data(bmp_card_data),.card_valid(bmp_card_valid),.card_end(bmp_card_end),
    .file_error(bmp_map_error),.write_finish_toggle(frame_write_toggle_mem),
    .write_buf_idx(write_buf_idx),.disp_buf_idx(disp_buf_idx),
    .write_req(sd_card_write_req),.write_req_ack(sd_card_write_req_ack),
    .write_en(sd_card_write_en),.write_data(sd_card_write_data),
    .display_valid(display_valid),.error(bmp_error),.state_code(state_code),
    .current_image_index(current_image_index),.auto_mode(bmp_auto_mode)
);
fat32_file_sector u_bmp_file_mapper (
    .clk(sd_card_clk),.rst(rst_all),.enable(fs_ready && !fs_error),
    .fat_lba(fs_fat_lba),.data_lba(fs_data_lba),.cluster_count(fs_cluster_count),
    .sectors_per_cluster_shift(fs_cluster_shift),
    .start_cluster(bmp_file_cluster),.file_size(bmp_file_size),
    .file_read(bmp_card_read),.file_sector(bmp_card_addr),
    .file_data(bmp_card_data),.file_valid(bmp_card_valid),.file_end(bmp_card_end),
    .error(bmp_map_error),.error_code(bmp_map_error_code),
    .sd_read(bmp_phy_read),.sd_addr(bmp_phy_addr),
    .sd_data(bmp_phy_data),.sd_valid(bmp_phy_valid),.sd_end(bmp_phy_end)
);
fat32_file_sector u_wav_file_mapper (
    .clk(sd_card_clk),.rst(rst_all),.enable(fs_ready && fs_wav_found && !fs_error),
    .fat_lba(fs_fat_lba),.data_lba(fs_data_lba),.cluster_count(fs_cluster_count),
    .sectors_per_cluster_shift(fs_cluster_shift),
    .start_cluster(fs_wav_cluster),.file_size(fs_wav_size),
    .file_read(wav_card_read),.file_sector(wav_card_addr),
    .file_data(wav_card_data),.file_valid(wav_card_valid),.file_end(wav_card_end),
    .error(wav_map_error),.error_code(wav_map_error_code),
    .sd_read(wav_phy_read),.sd_addr(wav_phy_addr),
    .sd_data(wav_phy_data),.sd_valid(wav_phy_valid),.sd_end(wav_phy_end)
);

// AC201 has four active-low LEDs and a serial segment-display interface.
// Show the reader state while loading; all four LEDs light after a frame commit.
// Probe build: four independent, active-low observations, usable without HDMI.
// D3: mounted; D2: full source-frame sum matches one of the unchanged card BMPs;
// D1: first two logical WAV bytes are RI; D0: audio primed with no WAV fault.
wire debug_source_sum_matches = (debug_rows_sd[95:64] == 32'hfb167260) ||
    (debug_rows_sd[95:64] == 32'hc3ebce2e) ||
    (debug_rows_sd[95:64] == 32'h0b94a9db) ||
    (debug_rows_sd[95:64] == 32'h98df6a9e);
// LED meanings in this audio probe are owned by u_audio_probe below.

// ===================== 原图像时序与帧缓存 =====================
video_timing_data video_timing_data_m0(
    .video_clk         (video_clk),
    .rst               (rst_all),
    .read_req          (video_read_req),
    .read_req_ack      (video_read_req_ack),
    .hs                (hs_0),
    .vs                (vs_0),
    .de                (de_0)
);

video_delay video_delay_m0(
    .video_clk         (video_clk),
    .rst               (rst_all),
    .read_en           (video_read_en),
    .read_data         (video_read_data),
    .hs                (hs_0),
    .vs                (vs_0),
    .de                (de_0),
    .hs_r              (hs),
    .vs_r              (vs),
    .de_r              (de),
    .vout_data         (vout_data_raw)
);

// 首图提交前黑屏；提交后一直显示当前显示缓冲区内容
assign vout_data_base = osd_frame_valid ? vout_data_raw : 24'd0;

// Select a frame and its OSD label atomically before issuing the memory read.
// A commit during active video is presented on the next read-frame boundary.
player_osd_state u_osd_state (
    .sd_clk(sd_card_clk),.pixel_clk(video_clk),.rst(rst_all),
    .source_buffer(disp_buf_idx),.source_image(current_image_index),
    .source_count(fs_bmp_count),.source_auto(bmp_auto_mode),
    .source_valid(display_valid),.read_req(video_read_req),
    .read_req_out(video_read_req_osd),.frame_buffer(osd_buffer_idx),
    .frame_image(osd_image_index),.frame_count(osd_image_count),
    .frame_auto(osd_auto_mode),.frame_valid(osd_frame_valid)
);

// RGB888 pixel API; SDRAM word layout is owned by the frame buffer.
frame_buffer_rgb888 #(
    .FRAME_WIDTH       (DISPLAY_WIDTH),
    .FRAME_HEIGHT      (DISPLAY_HEIGHT),
    .WRITE_V_FLIP      (1)
) u_frame_buffer (
    .rst               (rst_all),
    .mem_clk           (ext_mem_clk),
    .mem_clk_shift     (ext_mem_clk_sft),
    .write_clk         (sd_card_clk),
    .write_req         (sd_card_write_req),
    .write_req_ack     (sd_card_write_req_ack),
    .write_frame_index (write_buf_idx),
    .write_pixel_en    (sd_card_write_en),
    .write_pixel_rgb   (sd_card_write_data),
    .write_finish      (frame_write_finish),
    .read_clk          (video_clk),
    .read_req          (video_read_req_osd),
    .read_req_ack      (video_read_req_ack),
    .read_frame_index  (osd_buffer_idx),
    .read_pixel_en     (video_read_en),
    .read_pixel_rgb    (video_read_data)
);

// Parse the actual RIFF data region of the root-directory TEST.WAV.
tf_wav_file_player #(
    .FIFO_DEPTH          (2048)
) u_wav_player (
    .clk(sd_card_clk), .rst(rst_all), .sd_init_done(fs_ready && fs_wav_found),
    .file_size(fs_wav_size),.file_error(wav_map_error),
    .sd_read(wav_card_read), .sd_addr(wav_card_addr),
    .sd_data(wav_card_data), .sd_valid(wav_card_valid), .sd_end(wav_card_end),
    .sample_take(wav_sample_take), .sample_data(wav_sample_data),
    .sample_available(wav_sample_available), .primed(wav_primed), .error(wav_error),
    .debug_state(debug_wav_state), .debug_phase(debug_wav_phase),
    .debug_scan_pos(debug_wav_pos), .debug_scan_byte(debug_wav_byte)
);

// Diagnostic-only build: monitor source pixels and freeze the first WAV fault.
wire [7:0] debug_flags = {fs_ready,display_valid,fs_wav_found,wav_primed,
    wav_error,(bmp_error || bmp_map_error),wav_map_error,audio_underflow};
player_debug_monitor u_debug_monitor (
    .clk(sd_card_clk),.rst(rst_all),.flags(debug_flags),
    .fs_code(fs_error_code),.bmp_map_code(bmp_map_error_code),
    .wav_map_code(wav_map_error_code),
    .write_req(sd_card_write_req),.write_en(sd_card_write_en),
    .write_rgb(sd_card_write_data),.wav_addr(wav_card_addr),
    .wav_valid(wav_card_valid),.wav_end(wav_card_end),.wav_data(wav_card_data),
    .wav_error(wav_error),.wav_state(debug_wav_state),.wav_phase(debug_wav_phase),
    .wav_scan_pos(debug_wav_pos),.wav_scan_byte(debug_wav_byte),
    .debug_rows(debug_rows_sd)
);
// Combinational RGB-only overlay: existing VS/DE and video latency are retained.
player_osd u_osd (
    .clk(video_clk),.rst(rst_all),.vs(vs),.de(de),.rgb_in(vout_data_base),
    .image_index(osd_image_index),.image_count(osd_image_count),
    .auto_mode(osd_auto_mode),.image_valid(osd_frame_valid),.rgb_out(vout_data)
);

wire debug_tone_press, debug_tone_mode;
key_press_debounce #(.CLK_FREQ_HZ(25000000),.DEBOUNCE_MS(1500)) u_tone_key (
    .clk(video_clk),.rst(rst_all),.button_in(key2),.press_pulse(debug_tone_press)
);
player_audio_probe u_audio_probe (
    .pixel_clk(video_clk),.sd_clk(sd_card_clk),.rst(rst_all),
    .tone_toggle(debug_tone_press),.primed(wav_primed),
    .sample_available(wav_sample_available),.sample_data(wav_sample_data),
    .sample_take(wav_sample_take),.underflow(audio_underflow),
    .audio_valid(audio_valid),.audio_left(audio_left_data),.audio_right(audio_right_data),
    .acr_valid(acr_valid),.acr_cts(acr_cts),.acr_n(acr_n),
    .led(led),.tone_mode(debug_tone_mode)
);

sd_sector_arbiter u_card_arbiter (
    .clk(sd_card_clk), .rst(rst_all || !fs_ready),
    .bmp_read(bmp_phy_read), .bmp_addr(bmp_phy_addr),
    .wav_read(wav_phy_read), .wav_addr(wav_phy_addr),
    .card_read(arb_card_read), .card_addr(arb_card_addr),
    .card_data(shared_card_data), .card_valid(arb_card_valid), .card_end(arb_card_end),
    .bmp_data(bmp_phy_data), .bmp_valid(bmp_phy_valid), .bmp_end(bmp_phy_end),
    .wav_data(wav_phy_data), .wav_valid(wav_phy_valid), .wav_end(wav_phy_end)
);
assign shared_card_read=fs_ready ? arb_card_read : fs_read;
assign shared_card_addr=fs_ready ? arb_card_addr : fs_addr;
assign arb_card_valid=fs_ready && shared_card_valid;
assign arb_card_end=fs_ready && shared_card_end;

sd_card_top u_shared_card (
    .clk(sd_card_clk), .rst(rst_all),
    .SD_nCS(sd_ncs), .SD_DCLK(sd_dclk), .SD_MOSI(sd_mosi), .SD_MISO(sd_miso),
    .sd_init_done(card_init_done),
    .sd_sec_read(shared_card_read), .sd_sec_read_addr(shared_card_addr),
    .sd_sec_read_data(shared_card_data), .sd_sec_read_data_valid(shared_card_valid),
    .sd_sec_read_end(shared_card_end),
    .sd_sec_write(1'b0), .sd_sec_write_addr(32'd0), .sd_sec_write_data(8'd0),
    .sd_sec_write_data_req(), .sd_sec_write_end()
);
// ===================== RGB/DE 转 AXIS 视频 =====================
video_rgb_to_axis_640x480 u_video_rgb_to_axis_640x480(
    .I_clk         (video_clk),
    .I_rst         (rst_all),
    .I_vs          (vs),
    .I_de          (de),
    .I_rgb         (vout_data),
    .O_video_user  (axis_s_user),
    .O_video_valid (axis_s_valid),
    .O_video_last  (axis_s_last),
    .O_video_data  (axis_s_data)
);

// AC201 does not connect HDMI DDC to the FPGA. Use fixed 640x480 timing.

// ===================== HDMI 1.4b 发射 =====================
hdmi_1_4b_transmitter_core_wrapper #(
    .DEVICE                 ( "EG"       ),
    .HTOTAL                 ( 800        ),
    .HSA                    ( 96         ),
    .HFP                    ( 16         ),
    .HBP                    ( 48         ),
    .HACTIVE                ( 640        ),
    .VTOTAL                 ( 525        ),
    .VSA                    ( 2          ),
    .VFP                    ( 10         ),
    .VBP                    ( 33         ),
    .VACTIVE                ( 480        ),
    .VIDEO_VIC              ( 1          ),
    .VIDEO_TPG              ( "Disable"  ),
    .VIDEO_FORMAT           ( "RGB"      ),
    .AUDIO_SAMPLE_RATE      ( "48K"      ),
    .IIC_SCL_DIV            ( 250        )
) u_hdmi_1_4b_transmitter_core_wrapper(
    .I_pixel_clk        (video_clk),
    .I_rst              (rst_all),
    .I_edid_read_trig   (1'b0),
    .O_edid_read_valid  (),
    .O_edid_read_data   (),

    .I_axis_s_user      (axis_s_user),
    .I_axis_s_valid     (axis_s_valid),
    .I_axis_s_last      (axis_s_last),
    .I_axis_s_data      (axis_s_data),
    .O_axis_s_ready     (axis_s_ready),

    .I_audio_valid      (audio_valid),
    .I_audio_left_data  (audio_left_data),
    .I_audio_right_data (audio_right_data),
    .I_acr_valid        (acr_valid),
    .I_acr_cts          (acr_cts),
    .I_acr_n            (acr_n),

    .O_video_locked     (hdmi_video_locked),
    .O_ddc_scl          (),
    .IO_ddc_sda         (),

    .O_ch0_tmds_data    (tmds_ch0_data),
    .O_ch1_tmds_data    (tmds_ch1_data),
    .O_ch2_tmds_data    (tmds_ch2_data),
    .O_clk_tmds_data    (tmds_clk_data)
);

hdmi_phy_wrapper #(
    .DEVICE ( "EG" )
) u_hdmi2phy_wrapper(
    .I_pixel_clk        (video_clk),
    .I_serial_clk       (hdmi_5x_clk),
    .I_rst              (rst_all),
    .I_tmds_channel_0   (tmds_ch0_data),
    .I_tmds_channel_1   (tmds_ch1_data),
    .I_tmds_channel_2   (tmds_ch2_data),
    .I_tmds_channel_clk (tmds_clk_data),
    .O_tmds_ch0_p       (HDMI_D0_P),
    .O_tmds_ch1_p       (HDMI_D1_P),
    .O_tmds_ch2_p       (HDMI_D2_P),
    .O_tmds_clk_p       (HDMI_CLK_P)
);

// Passive branch from the transmitter's parallel outputs; never feeds PHY.
hdmi_packet_monitor u_packet_monitor (
    .clk(video_clk),.rst(rst_all),.tone_mode(debug_tone_mode),
    .ch0(tmds_ch0_data),.ch1(tmds_ch1_data),.ch2(tmds_ch2_data),
    .audio_samples_sec(packet_samples),.audio_packets_sec(packet_count),
    .bad_bch_sec(packet_bad_bch),.bad_terc_sec(packet_bad_terc),
    .tone_bad_sec(packet_tone_bad),.acr_cts_last(packet_cts),.acr_n_last(packet_n),
    .probe_flags(packet_flags)
);
// Passive status display; original playback and LED paths remain connected.
player_status_monitor #(.SYS_HZ(25000000)) u_status_monitor (
    .pixel_clk(video_clk),.sys_clk(status_clk),.rst(rst_all),.sys_rst(status_sys_rst),
    .axis_rgb(axis_s_data),.axis_valid(axis_s_valid),.axis_user(axis_s_user),
    .hdmi_locked(hdmi_video_locked),.audio_valid(audio_valid),
    .tone_mode(debug_tone_mode),.underflow(audio_underflow),.audio_pcm(audio_left_data),
    .startup_flags({sys_pll_lock,video_pll_lock,rst_all,card_init_done}),
    .file_flags({fs_ready,fs_error,display_valid,bmp_error,wav_primed,wav_error,bmp_map_error,wav_map_error}),
    .fs_code(fs_error_code),.wav_map_code(wav_map_error_code),.hex_value(status_hex),
    .packet_samples(packet_samples),.packet_count(packet_count),
    .packet_bad_bch(packet_bad_bch),.packet_bad_terc(packet_bad_terc),
    .packet_tone_bad(packet_tone_bad),.packet_cts(packet_cts),.packet_n(packet_n),
    .packet_flags(packet_flags)
);
status_hex595 #(.CLK_HZ(25000000)) u_status_hex (
    .clk(status_clk),.rst(status_sys_rst),.hex_value(status_hex),
    .seg7_dio(seg7_dio),.seg7_sclk(seg7_sclk),.seg7_rclk(seg7_rclk)
);
endmodule







