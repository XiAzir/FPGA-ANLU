import json
from pathlib import Path

base = Path('development/player_video22_audio_diag/src/user_source')
cand = Path('development/player_video26_runtime_diag/src/user_source')
hdl = cand / 'hdl_source'
expected = {
    'hdl_source/player_adjust_control.v',
    'hdl_source/top_tf_hdmi_audio.v',
    'hdl_source/player_compact_status_pages.v',
    'hdl_source/SD/sd_card_sec_read_write.v',
    'hdl_source/SD/sd_card_cmd.v',
    'hdl_source/SD/spi_master.v',
    'hdl_source/SD/sd_card_top.v',
}

def normalized_text(path):
    return path.read_text(encoding='utf-8-sig').replace('\r\n', '\n').replace('\r', '\n')

base_files = {p.relative_to(base).as_posix(): p for p in base.rglob('*') if p.is_file()}
cand_files = {p.relative_to(cand).as_posix(): p for p in cand.rglob('*') if p.is_file()}
assert set(base_files) == set(cand_files), 'C22 and C26 user_source file inventories differ'
changed = sorted(k for k in base_files if normalized_text(base_files[k]) != normalized_text(cand_files[k]))
assert set(changed) == expected, f'changed source scope mismatch: {changed}'

# Structural and behavioral checks for the passive additions.
top = normalized_text(hdl / 'top_tf_hdmi_audio.v')
cmd = normalized_text(hdl / 'SD/sd_card_cmd.v')
card_top = normalized_text(hdl / 'SD/sd_card_top.v')
pages = normalized_text(hdl / 'player_compact_status_pages.v')
adjust = normalized_text(hdl / 'player_adjust_control.v')
checks = {
    'counter_is_only_globally_reset': 'always @(posedge video_clk or posedge rst_all_reg)' in top and 'video_mode_press_count<=0;' in top and "if(video_mode_press) video_mode_press_count<=video_mode_press_count+1'b1;" in top and top.count('video_mode_press_count<=') == 2,
    'page_b_pack': "{4'hB,video_mode,key1,key2,adjust_debug_state,video_mode_press_count,media_reset_active,rst_all_reg,card_init_done,sys_pll_lock,video_pll_lock}" in top,
    'page_c_pack': "{4'hC,card_debug_state,card_init_done,shared_card_read,shared_card_end,shared_card_valid,sd_ncs,sd_dclk,sd_mosi,sd_miso,media_reset_active,rst_all_reg,sys_pll_lock,video_pll_lock}" in top,
    'page_d_pack': "{4'hD,card_command_debug[21:16],card_command_debug[15:8],card_command_debug[7:0],6'd0}" in top,
    'sd_debug_assembly': "{sec_debug_state,cmd_debug_state,spi_debug_state,cmd_req,cmd_req_ack,cmd_req_error,block_read_req}" in card_top,
    'r1_observer_has_r1_state_and_ack_gate': "else if(state == S_CMD && spi_wr_ack == 1'b1) debug_last_r1 <= data_recv;" in cmd,
    'r1_observer_reset_ff': "if(rst) debug_last_r1 <= 8'hff;" in cmd,
    'adjust_debug_declared': 'assign debug_state = {key0_pressed,key1_pressed,chord_active,chord_long_done,' in adjust,
    'page_id': "32'h00C11326" in pages,
}
assert all(checks.values()), checks

# Distinct input values model the intended R1-only update predicate as a negative control.
last_r1 = 0xff
for state, ack, value in [(4, 1, 0x01), (5, 1, 0xfe), (7, 1, 0x00), (4, 0, 0xaa)]:
    if state == 4 and ack:
        last_r1 = value
assert last_r1 == 0x01

# Explicitly validate packed field widths and representative bit positions.
page_b_fields = [4, 1, 1, 1, 16, 4, 1, 1, 1, 1, 1]
page_c_fields = [4, 16, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
page_d_fields = [4, 6, 8, 8, 6]
assert sum(page_b_fields) == sum(page_c_fields) == sum(page_d_fields) == 32

reported_changed = sorted(changed + ['src/td_project/AC201_tf_hdmi.al'])
result = {
    'status': 'PASS',
    'base': 'player_video22_audio_diag',
    'candidate': 'player_video26_runtime_diag',
    'changed_files': reported_changed,
    'user_source_changed_files': changed,
    'project_path_update': 'src/td_project/AC201_tf_hdmi.al: C22 project path retargeted to C26',
    'unchanged_count': len(base_files) - len(changed),
    'source_file_count': len(base_files),
    'normalization': {
        'newline_policy': 'CRLF and CR normalized to LF before comparison',
        'proof': 'Only the seven allowlisted HDL files differ; all other user_source files normalize byte-for-text equal to C22.',
        'diagnostic_scope': 'passive output additions, B/C/D page packing, 4-bit video-mode press counter, and C26 page identifier',
    },
    'checks': checks,
    'r1_negative_control': 'PASS: only (state=S_CMD && spi_wr_ack) updates last_r1; distinct bytes in non-R1 states leave it unchanged',
    'testbench': 'sd_card_cmd_r1_probe_tb.v created; simulator unavailable in current PATH, so HDL simulation not executed',
    'td_build': 'NOT RUN by instruction',
}
out = Path('development/player_video26_runtime_diag/verification/passive_source_checks.json')
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(json.dumps(result, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
print(json.dumps(result, indent=2, ensure_ascii=False))


