from pathlib import Path
import re
import shutil

root = Path(__file__).resolve().parents[2]
src = root / 'development/player_video29_media_flow/src'
hdl = src / 'user_source/hdl_source'

def edit(path, old, new):
    text = path.read_text(encoding='utf-8-sig')
    assert text.count(old) == 1, (path, old, text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')

edit(hdl/'SD/frame_fifo_read.v', 'output read_refill_request,',
     'output read_refill_request,\n    output wire [3:0] debug_read_state,')
edit(hdl/'SD/frame_fifo_read.v', 'assign App_rd_addr =',
     'assign debug_read_state = state;\nassign App_rd_addr =')
edit(hdl/'SD/frame_read_write.v', 'output wire [3:0]                debug_write_state,',
     'output wire [3:0]                debug_write_state,\n    output wire [3:0] debug_read_state,\n    output wire debug_read_valid,\n    output wire [MEM_DATA_BITS-1:0] debug_read_word,')
edit(hdl/'SD/frame_read_write.v', '//instantiate an asynchronous FIFO \nwfifo_32_32_512',
     'assign debug_read_valid = read_capture_valid;\nassign debug_read_word = read_capture_data;\n\n//instantiate an asynchronous FIFO \nwfifo_32_32_512')
edit(hdl/'SD/frame_read_write.v', '.read_refill_request        (read_refill_request      ),',
     '.read_refill_request        (read_refill_request      ),\n    .debug_read_state(debug_read_state),')
edit(hdl/'frame_buffer_rgb888.v', 'output wire [15:0] debug_memory,',
     '''output wire [15:0] debug_memory,
    output wire debug_app_read, debug_read_valid, debug_app_write,
    output wire [31:0] debug_read_word, debug_write_word,
    output wire [3:0] debug_read_state,
    output wire debug_fifo_clear, debug_underflow,''')
edit(hdl/'frame_buffer_rgb888.v', 'wire app_read_en, app_write_en, mem_read_valid;',
     '''assign debug_app_read = app_read_en;
    assign debug_app_write = app_write_en;
    assign debug_write_word = mem_write_word;
    assign debug_fifo_clear = read_fifo_clear;
    assign debug_underflow = read_underflow;
    wire app_read_en, app_write_en, mem_read_valid;''')
edit(hdl/'frame_buffer_rgb888.v', '.debug_write_state(debug_write_state),.debug_write_req_sync(debug_write_req_sync),',
     '''.debug_write_state(debug_write_state),.debug_write_req_sync(debug_write_req_sync),
        .debug_read_state(debug_read_state),.debug_read_valid(debug_read_valid),
        .debug_read_word(debug_read_word),''')

top = hdl/'top_tf_hdmi_audio.v'
edit(top, 'wire [23:0] photo_progress;\nwire [31:0] hdmi_probe_page_e,hdmi_probe_page_f;\nwire hdmi_clock_bit_probe;',
     '''wire [31:0] memory_probe_page5;
wire [11:0] memory_probe_page6_tail;
wire memory_app_read,memory_read_valid,memory_app_write;
wire [31:0] memory_read_word,memory_write_word;
wire [3:0] memory_read_state;
wire memory_fifo_clear,memory_underflow;
wire [23:0] packet_samples,packet_bch,packet_terc,packet_tone;
wire [19:0] packet_cts,packet_n;
wire [3:0] packet_flags;
wire [7:0] packet_bch_sat=(|packet_bch[23:8])?8'hff:packet_bch[7:0];
wire [7:0] packet_terc_sat=(|packet_terc[23:8])?8'hff:packet_terc[7:0];
wire [7:0] packet_tone_sat=(|packet_tone[23:8])?8'hff:packet_tone[7:0];''')
edit(top, '.failure_detail(photo_failure_detail),.debug_progress(photo_progress)',
     '.failure_detail(photo_failure_detail)')
edit(top, '.debug_memory(debug_memory)', '''.debug_memory(debug_memory),
    .debug_app_read(memory_app_read),.debug_read_valid(memory_read_valid),
    .debug_read_word(memory_read_word),.debug_app_write(memory_app_write),
    .debug_write_word(memory_write_word),.debug_read_state(memory_read_state),
    .debug_fifo_clear(memory_fifo_clear),.debug_underflow(memory_underflow)''')
edit(top, '.O_tmds_clk_p       (HDMI_CLK_P),\n    .O_clock_bit_probe  (hdmi_clock_bit_probe)',
     '.O_tmds_clk_p       (HDMI_CLK_P)')
edit(top, "{4'h5,(photo_error ? photo_failure_detail : photo_progress),video_reader_error,wav_error,display_valid,video_mode_sd}", "32'd0")
edit(top, '.audio_underflow(audio_underflow),.spectrum_frames(spectrum_debug_frames),',
     ".diag3({4'h3,packet_n,packet_bch_sat}),")
edit(top, '.diag4(diag_sd_sync1),.diag5(diag_sd_sync1),',
     '.diag4(diag_sd_sync1),.diag5(memory_probe_page5),')
edit(top, ".diag6({4'h6,diag_mem_sync1,12'd0}),.diag7(diag_sd_sync1),",
     ".diag6({4'h6,diag_mem_sync1,memory_probe_page6_tail}),.diag7(diag_sd_sync1),")
edit(top, '.diag14(hdmi_probe_page_e),.diag15(hdmi_probe_page_f),',
     ".diag14({4'hE,packet_flags,packet_samples[15:0],packet_terc_sat}),\n    .diag15({4'hF,packet_cts,packet_tone_sat}),")
text=top.read_text(encoding='utf-8')
text,n=re.subn(r'player_hdmi_runtime_probe u_hdmi_runtime_probe \(.*?\n\);', '''player_memory_runtime_probe u_memory_runtime_probe (
    .mem_clk(ext_mem_clk),.pixel_clk(video_clk),.rst(rst_all),
    .mem_app_read(memory_app_read),.mem_read_valid(memory_read_valid),
    .mem_read_word(memory_read_word),.mem_app_write(memory_app_write),
    .mem_write_word(memory_write_word),.mem_read_ack(video_read_req_ack),
    .mem_read_state(memory_read_state),.source_valid_async(display_valid),
    .osd_valid(osd_frame_valid),.read_req(video_read_req_osd),
    .read_ack_async(video_read_req_ack),.read_fifo_clear(memory_fifo_clear),
    .pixel_underflow(memory_underflow),.pixel_de(de),
    .raw_rgb(vout_data_raw),.gated_rgb(vout_data_probe),
    .page5(memory_probe_page5),.page6_tail(memory_probe_page6_tail)
);
hdmi_packet_monitor #(.CLK_HZ(25000000),.TONE_AMP(24'd1000000)) u_packet_monitor (
    .clk(video_clk),.rst(rst_all),.tone_mode(debug_tone_mode),
    .ch0(tmds_ch0_data),.ch1(tmds_ch1_data),.ch2(tmds_ch2_data),
    .audio_samples_sec(packet_samples),.audio_packets_sec(),
    .bad_bch_sec(packet_bch),.bad_terc_sec(packet_terc),.tone_bad_sec(packet_tone),
    .acr_cts_last(packet_cts),.acr_n_last(packet_n),.probe_flags(packet_flags)
);''',text,flags=re.S)
assert n==1
top.write_text(text,encoding='utf-8')
pages=hdl/'player_compact_status_pages.v'
edit(pages, 'input wire audio_underflow,\n    input wire [23:0] spectrum_frames,', 'input wire [31:0] diag3,')
edit(pages, '00C11328', '00C11329')
edit(pages, "{spectrum_frames, 4'h0, audio_underflow, 3'b000}", 'diag3')
al=src/'td_project/AC201_tf_hdmi.al'
edit(al, 'hdl_source/player_hdmi_runtime_probe.v', 'hdl_source/player_memory_runtime_probe.v')
(hdl/'player_hdmi_runtime_probe.v').unlink()
print('C29 passive wiring integrated; memory probe copy pending verified helper')
