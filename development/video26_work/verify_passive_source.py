from pathlib import Path
import hashlib
import json
import re
import shutil

ROOT = Path(__file__).resolve().parents[2]
p = ROOT / 'development/player_video26_runtime_diag'
base = ROOT / 'development/player_video22_audio_diag/src/user_source'
candidate = p / 'src/user_source'
sha = lambda f: hashlib.sha256(f.read_bytes()).hexdigest()


def canonical(text):
    text = re.sub(r'/\*.*?\*/|//[^\n]*', '', text, flags=re.S)
    return re.sub(r'\s+', '', text)


remove = {
    'player_adjust_control.v': [
        'outputwire[15:0]debug_state,',
        'wire[7:0]chord_hold_count_hi8=chord_hold_count>>(HOLD_W>8?HOLD_W-8:0);',
        'assigndebug_state={key0_pressed,key1_pressed,chord_active,chord_long_done,chord_hold_count_hi8,mode[1:0],next_req_busy,auto_req_busy};'],
    'SD/sd_card_sec_read_write.v': ['outputwire[4:0]debug_state,', 'assigndebug_state=state;'],
    'SD/sd_card_cmd.v': [
        ',outputwire[4:0]debug_state,outputreg[7:0]debug_last_r1',
        'assigndebug_state=state;',
        "always@(posedgesys_clkorposedgerst)beginif(rst)debug_last_r1<=8'hff;elseif(state==S_CMD&&spi_wr_ack==1'b1)debug_last_r1<=data_recv;end"],
    'SD/spi_master.v': [',outputwire[2:0]debug_state', 'assigndebug_state=state;'],
    'SD/sd_card_top.v': [
        ',outputwire[15:0]debug_state,outputwire[21:0]debug_command',
        'wire[4:0]sec_debug_state;', 'wire[4:0]cmd_debug_state;',
        'wire[2:0]spi_debug_state;', 'wire[7:0]cmd_debug_last_r1;',
        'assigndebug_command={cmd[45:40],cmd_r1,cmd_debug_last_r1};',
        'assigndebug_state={sec_debug_state,cmd_debug_state,spi_debug_state,cmd_req,cmd_req_ack,cmd_req_error};',
        '.debug_state(sec_debug_state),',
        ',.debug_state(cmd_debug_state),.debug_last_r1(cmd_debug_last_r1)',
        ',.debug_state(spi_debug_state)'],
    'top_tf_hdmi_audio.v': [
        'reg[3:0]video_mode_press_count;', 'wire[15:0]adjust_debug_state;',
        'wire[15:0]card_debug_state;', 'wire[21:0]card_command_debug;',
        'video_mode_press_count<=0;',
        "if(video_mode_press)video_mode_press_count<=video_mode_press_count+1'b1;",
        ',.debug_state(adjust_debug_state)',
        '.debug_state(card_debug_state),.debug_command(card_command_debug),',
        "wire[31:0]diag_page_b={4'hB,video_mode,key1,key2,adjust_debug_state,video_mode_press_count,media_reset_active,rst_all_reg,card_init_done,sys_pll_lock,video_pll_lock};",
        "wire[31:0]diag_page_c={4'hC,card_debug_state,card_init_done,shared_card_read,shared_card_end,shared_card_valid,sd_ncs,sd_dclk,sd_mosi,sd_miso,media_reset_active,rst_all_reg,sys_pll_lock,video_pll_lock};",
        "wire[31:0]diag_page_d={4'hD,card_command_debug[21:16],card_command_debug[15:8],card_command_debug[7:0],6'd0};"],
}


def strip_observer(name, code):
    for snippet in remove.get(name, []):
        assert code.count(snippet) == 1, (name, snippet, code.count(snippet))
        code = code.replace(snippet, '')
    if name == 'player_compact_status_pages.v':
        assert code.count("32'h00C11326") == 1
        code = code.replace("32'h00C11326", "32'h00C11322")
    if name == 'top_tf_hdmi_audio.v':
        for old, new in [('diag_page_b,', "{4'hb,wav_max_first_wait_cycles,4'd0},"),
                         ('diag_page_c,', "{4'hc,wav_fifo_lowwater,wav_fifo_level[11:0],4'd0},"),
                         ('diag_page_d,', "{4'hd,pcm_count_snapshot,4'd0},")]:
            assert code.count(old) == 1
            code = code.replace(old, new)
    return code


rows = []
changed = []
for f in sorted(candidate.rglob('*')):
    if not f.is_file():
        continue
    relative = f.relative_to(candidate)
    old_file = base / relative
    assert old_file.is_file(), relative
    a = old_file.read_text(encoding='utf-8-sig')
    b = f.read_text(encoding='utf-8-sig')
    if a != b:
        changed.append(relative.as_posix())
    name = relative.relative_to('hdl_source').as_posix() if relative.parts[0] == 'hdl_source' else ''
    stripped = strip_observer(name, canonical(b))
    assert canonical(a) == stripped, f'Control-token delta remains in {relative}'
    rows.append({'path': relative.as_posix(), 'base_sha256': sha(old_file),
                 'candidate_sha256': sha(f), 'stripped_tokens_sha256': hashlib.sha256(stripped.encode()).hexdigest()})
assert len(rows) == len([f for f in base.rglob('*') if f.is_file()])
assert len(changed) == 7
# Negative control: a real change in the media mode transition must fail this comparison.
name = 'top_tf_hdmi_audio.v'
source = canonical((candidate / 'hdl_source' / name).read_text(encoding='utf-8-sig'))
mutated = source.replace('video_mode<=~video_mode;', "video_mode<=1'b0;")
assert source != mutated
assert strip_observer(name, mutated) != canonical((base / 'hdl_source' / name).read_text(encoding='utf-8-sig'))
record = {'status': 'PASS', 'base': 'player_video22_audio_diag',
          'changed_files': changed, 'unchanged_count': len(rows) - len(changed),
          'method': 'Remove exactly declared observer tokens; require every remaining control/data token equal to C22',
          'negative_control': 'PASS: media mode-transition mutation rejected',
          'inputs': rows}
out = p / 'verification/passive_source_checks.json'
if out.exists() and not (p / 'verification/attempts/passive_source_checks_preTD.json').exists():
    (p / 'verification/attempts').mkdir(exist_ok=True)
    shutil.copy2(out, p / 'verification/attempts/passive_source_checks_preTD.json')
out.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(f'PASS token-equivalence files={len(rows)} observer_changes={len(changed)} negative_control=detected')
