from pathlib import Path
P=Path(__file__).resolve().parents[1]/'player_video19/src/user_source/hdl_source/top_tf_hdmi_audio.v'
s=P.read_text(encoding='utf-8-sig')
def sub(a,b):
    global s
    assert s.count(a)==1,(a,s.count(a))
    s=s.replace(a,b)
sub('assign rst_all = rst_all_reg;', '''// The control classifier survives a media restart so held gestures rearm once.
wire video_mode_press;
reg video_mode;
reg media_reset_active;
reg [4:0] media_reset_count;
reg [1:0] video_mode_sd_sync;
reg [1:0] video_restart_sync;
reg video_restart_seen;
reg video_restart_toggle;
wire video_next_press, video_auto_press;
wire video_key_next_ack, video_key_auto_ack;
wire photo_key_next_ack, photo_key_auto_ack;
wire video_mode_sd=video_mode_sd_sync[1];
always @(posedge video_clk or posedge rst_all_reg) begin
    if(rst_all_reg) begin
        video_mode<=0;media_reset_active<=0;media_reset_count<=0;
        video_restart_sync<=0;video_restart_seen<=0;
    end else begin
        video_restart_sync<={video_restart_sync[0],video_restart_toggle};
        if(video_mode_press || video_restart_sync[1]!=video_restart_seen) begin
            if(video_mode_press) video_mode<=~video_mode;
            video_restart_seen<=video_restart_sync[1];
            media_reset_active<=1;media_reset_count<=31;
        end else if(media_reset_active) begin
            if(media_reset_count==0) media_reset_active<=0;
            else media_reset_count<=media_reset_count-1'b1;
        end
    end
end
always @(posedge sd_card_clk or posedge rst_all_reg) begin
    if(rst_all_reg) begin video_mode_sd_sync<=0;video_restart_toggle<=0;end
    else begin
        video_mode_sd_sync<={video_mode_sd_sync[0],video_mode};
        if(video_mode_sd && video_next_press) video_restart_toggle<=~video_restart_toggle;
    end
end
assign rst_all = rst_all_reg | media_reset_active;
key_event_mailbox_sink u_video_keys (
    .clk(sd_card_clk),.rst(rst_all_reg),
    .next_req_toggle(bmp_key_next_req),.next_ack_toggle(video_key_next_ack),.next_press(video_next_press),
    .auto_req_toggle(bmp_key_auto_req),.auto_ack_toggle(video_key_auto_ack),.auto_press(video_auto_press)
);
assign bmp_key_next_ack=video_mode ? video_key_next_ack : photo_key_next_ack;
assign bmp_key_auto_ack=video_mode ? video_key_auto_ack : photo_key_auto_ack;''')
sub('    .wav_found(fs_wav_found),.wav_cluster(fs_wav_cluster),.wav_size(fs_wav_size)',
    '    .wav_found(fs_wav_found),.wav_cluster(fs_wav_cluster),.wav_size(fs_wav_size),\n    .video_found(fs_video_found),.video_cluster(fs_video_cluster),.video_size(fs_video_size)')
sub('tf_bmp_file_player #(.CLK_FREQ_HZ(50000000),','''wire fs_video_found;
wire [31:0] fs_video_cluster, fs_video_size;
wire photo_write_req, photo_write_en, photo_display_valid, photo_error;
wire [23:0] photo_write_data;
wire [1:0] photo_write_buffer,photo_display_buffer;
wire [3:0] photo_state;
wire [31:0] photo_file_cluster,photo_file_size;
wire photo_card_read;
wire [31:0] photo_card_addr;
wire video_card_read;
wire [31:0] video_card_addr;
wire [1:0] video_write_buffer,video_display_buffer;
wire video_write_req,video_display_valid,video_audio_go;
wire [3:0] video_state;
wire video_reader_start,video_reader_next,video_file_ready,video_frame_sent;
wire video_reader_error,video_core_idle,video_core_reset;
wire video_jpeg_valid,video_jpeg_accept,video_jpeg_last;
wire [31:0] video_jpeg_data;
wire [3:0] video_jpeg_strb;
wire video_pixel_valid;
wire [15:0] video_pixel_x,video_pixel_y;
wire [7:0] video_pixel_r,video_pixel_g,video_pixel_b;
reg video_paused;
always @(posedge sd_card_clk or posedge rst_all) begin
    if(rst_all) video_paused<=0;
    else if(video_mode_sd && video_auto_press) video_paused<=~video_paused;
end
assign bmp_file_cluster=video_mode_sd ? fs_video_cluster : photo_file_cluster;
assign bmp_file_size=video_mode_sd ? fs_video_size : photo_file_size;
assign bmp_card_read=video_mode_sd ? video_card_read : photo_card_read;
assign bmp_card_addr=video_mode_sd ? video_card_addr : photo_card_addr;
assign write_buf_idx=video_mode_sd ? video_write_buffer : photo_write_buffer;
assign disp_buf_idx=video_mode_sd ? video_display_buffer : photo_display_buffer;
assign sd_card_write_req=video_mode_sd ? video_write_req : photo_write_req;
assign sd_card_write_en=video_mode_sd ? (video_pixel_valid && bmp_write_ready) : photo_write_en;
assign sd_card_write_data=video_mode_sd ? {video_pixel_r,video_pixel_g,video_pixel_b} : photo_write_data;
assign display_valid=video_mode_sd ? video_display_valid : photo_display_valid;
assign bmp_error=video_mode_sd ? video_reader_error : photo_error;
assign state_code=video_mode_sd ? video_state : photo_state;
player_video_schedule u_video_schedule (
    .clk(sd_card_clk),.rst(rst_all),.enable(video_mode_sd),
    .catalog_ready(fs_ready),.video_found(fs_video_found),.wav_primed(wav_primed),
    .file_ready(video_file_ready),.reader_frame_sent(video_frame_sent),.decoder_idle(video_core_idle),
    .reader_start(video_reader_start),.reader_next(video_reader_next),.decoder_reset(video_core_reset),
    .write_finish_toggle(frame_write_toggle_mem),.display_finish_toggle(display_finish_toggle),
    .sample_take(wav_sample_take),.write_req(video_write_req),.write_req_ack(sd_card_write_req_ack),
    .write_buffer(video_write_buffer),.display_buffer(video_display_buffer),
    .display_valid(video_display_valid),.audio_go(video_audio_go),.state_code(video_state),
    .displayed_frame(),.frame_late()
);
mjp_file_reader u_video_reader (
    .clk(sd_card_clk),.rst(rst_all),.start(video_reader_start),.next_frame(video_reader_next),
    .card_read(video_card_read),.card_addr(video_card_addr),.card_data(bmp_card_data),
    .card_valid(bmp_card_valid && video_mode_sd),.card_end(bmp_card_end && video_mode_sd),
    .file_error(bmp_map_error && video_mode_sd),.file_ready(video_file_ready),.last_index(),
    .frame_ready(),.frame_index(),.frame_length(),
    .jpeg_valid(video_jpeg_valid),.jpeg_data(video_jpeg_data),.jpeg_strb(video_jpeg_strb),
    .jpeg_last(video_jpeg_last),.jpeg_accept(video_jpeg_accept),.frame_sent(video_frame_sent),
    .sequence_index(),.busy(),.error(video_reader_error)
);
jpeg_core #(.SUPPORT_WRITABLE_DHT(0)) u_jpeg_core (
    .clk_i(sd_card_clk),.rst_i(video_core_reset || !video_mode_sd),
    .inport_valid_i(video_jpeg_valid),.inport_data_i(video_jpeg_data),
    .inport_strb_i(video_jpeg_strb),.inport_last_i(video_jpeg_last),
    .outport_accept_i(bmp_write_ready),.inport_accept_o(video_jpeg_accept),
    .outport_valid_o(video_pixel_valid),.outport_width_o(),.outport_height_o(),
    .outport_pixel_x_o(video_pixel_x),.outport_pixel_y_o(video_pixel_y),
    .outport_pixel_r_o(video_pixel_r),.outport_pixel_g_o(video_pixel_g),
    .outport_pixel_b_o(video_pixel_b),.idle_o(video_core_idle)
);

tf_bmp_file_player #(.CLK_FREQ_HZ(50000000),''')
sub('    .clk(sd_card_clk),.rst(rst_all),\n    .key_next_req_toggle',
    '    .clk(sd_card_clk),.rst(rst_all || video_mode_sd),\n    .key_next_req_toggle')
sub('.key_next_ack_toggle(bmp_key_next_ack),.key_auto_ack_toggle(bmp_key_auto_ack)',
    '.key_next_ack_toggle(photo_key_next_ack),.key_auto_ack_toggle(photo_key_auto_ack)')
sub('    .file_cluster(bmp_file_cluster),.file_size(bmp_file_size),','    .file_cluster(photo_file_cluster),.file_size(photo_file_size),')
sub('    .card_read(bmp_card_read),.card_addr(bmp_card_addr),','    .card_read(photo_card_read),.card_addr(photo_card_addr),')
sub('    .write_buf_idx(write_buf_idx),.disp_buf_idx(disp_buf_idx),','    .write_buf_idx(photo_write_buffer),.disp_buf_idx(photo_display_buffer),')
sub('    .write_req(sd_card_write_req),.write_req_ack(sd_card_write_req_ack),','    .write_req(photo_write_req),.write_req_ack(sd_card_write_req_ack),')
sub('    .write_en(sd_card_write_en),.write_data(sd_card_write_data),','    .write_en(photo_write_en),.write_data(photo_write_data),')
sub('    .display_valid(display_valid),.error(bmp_error),.state_code(state_code),','    .display_valid(photo_display_valid),.error(photo_error),.state_code(photo_state),')
sub('    .source_valid(display_valid),.read_req(video_read_req),.read_req_ack(video_read_req_ack),',
    '    .source_valid(display_valid),.source_video(video_mode),.read_req(video_read_req),.read_req_ack(video_read_req_ack),')
sub(' .clk(video_clk),.rst(rst_all),.vs(vs),.key0_n(key1),.key1_n(key2),',
    ' .clk(video_clk),.rst(rst_all_reg),.vs(vs),.key0_n(key1),.key1_n(key2),')
sub(' .waveform_toggle(waveform_toggle)',' .waveform_toggle(waveform_toggle),.video_mode_press(video_mode_press)')
sub('    .write_frame_index (write_buf_idx),','    .write_frame_index (write_buf_idx),\n    .write_jpeg420     (video_mode_sd),')
sub('player_audio_probe u_audio_probe (','player_audio_probe #(.PLAY_GATE(1)) u_audio_probe (')
sub('    .tone_toggle(probe_tone_toggle),.primed(wav_primed),',
    '    .tone_toggle(probe_tone_toggle),.primed(wav_primed && (!video_mode_sd || video_audio_go)),\n    .play_enable(!video_mode_sd || (video_audio_go && !video_paused)),')
# TD requires declarations before the catalog's first named connection.
s=s.replace('wire fs_video_found;\nwire [31:0] fs_video_cluster, fs_video_size;\n','')
s=s.replace('wire fs_ready, fs_error, fs_wav_found, bmp_error;',
            'wire fs_ready, fs_error, fs_wav_found, bmp_error;\nwire fs_video_found;\nwire [31:0] fs_video_cluster, fs_video_size;')
P.write_text(s,encoding='utf-8')
print('VIDEO19_TOP_INTEGRATED')
