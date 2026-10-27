import hashlib, json, re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[4]
BASE = ROOT / 'development/player_video29_media_flow/src/user_source/hdl_source'
CAND = ROOT / 'development/player_video30_probe_prune/src/user_source/hdl_source'
OUT = Path(__file__).resolve().parent

def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def files(root): return {p.relative_to(root).as_posix(): p for p in root.rglob('*') if p.is_file()}
def norm(s):
    s = re.sub(r'/\*.*?\*/', '', s, flags=re.S)
    s = re.sub(r'//[^\n]*', '', s)
    return re.sub(r'\s+', '', s)
def extract_module(s, name):
    m = re.search(r'\bmodule\s+'+re.escape(name)+r'\b(.*?)\bendmodule\b', s, re.S)
    if not m: raise ValueError('module not found: '+name)
    return m.group(0)
def instance(src, inst):
    m = re.search(r'\b'+re.escape(inst)+r'\s*\(', src)
    if not m: raise ValueError('instance not found: '+inst)
    start = src.rfind('\n', 0, m.start()) + 1
    end = src.find(');', m.end())
    if end < 0: raise ValueError('instance terminator missing: '+inst)
    return src[start:end+2]
def block_after(src, start_pat, end_pat):
    a = re.search(start_pat, src, re.S)
    if not a: raise ValueError('start missing: '+start_pat)
    b = re.search(end_pat, src[a.end():], re.S)
    if not b: raise ValueError('end missing: '+end_pat)
    return src[a.start():a.end()+b.end()]

a = files(BASE); b = files(CAND)
added = sorted(set(b)-set(a)); deleted = sorted(set(a)-set(b))
changed = sorted(k for k in set(a)&set(b) if sha(a[k]) != sha(b[k]))
expected_added = ['player_audio_output.v']
expected_deleted = sorted([
 'hdmi_packet_monitor.v','player_audio_probe.v','player_bit17_led_probe.v',
 'player_cadence_probe.v','player_compact_status_pages.v','player_debug_monitor.v',
 'player_debug_overlay.v','player_memory_runtime_probe.v','player_pcm_crc_probe.v',
 'player_video_source_probe.v'
])
expected_changed = sorted([
 'SD/frame_fifo_read.v','SD/frame_read_write.v','SD/sd_card_cmd.v',
 'SD/sd_card_top.v','frame_buffer_rgb888.v','top_tf_hdmi_audio.v'
])
if added != expected_added: raise SystemExit('added-file set differs from reviewed set: '+repr(added))
if deleted != expected_deleted: raise SystemExit('deleted-file set differs from reviewed set: '+repr(deleted))
if changed != expected_changed: raise SystemExit('changed-file set differs from reviewed set: '+repr(changed))
manifest = {
    'baseline_root': str(BASE.relative_to(ROOT)).replace('\\','/'),
    'candidate_root': str(CAND.relative_to(ROOT)).replace('\\','/'),
    'baseline_file_count': len(a), 'candidate_file_count': len(b),
    'added': [{'path': k, 'sha256': sha(b[k])} for k in added],
    'deleted': [{'path': k, 'sha256': sha(a[k])} for k in deleted],
    'changed': [{'path': k, 'baseline_sha256': sha(a[k]), 'candidate_sha256': sha(b[k])} for k in changed],
    'all_files': {
        'baseline': [{'path': k, 'sha256': sha(a[k])} for k in sorted(a)],
        'candidate': [{'path': k, 'sha256': sha(b[k])} for k in sorted(b)]
    }
}
(OUT/'source_hash_manifest.json').write_text(json.dumps(manifest, indent=2), encoding='utf-8')

# Baseline audio probe with LED-only observations removed must retain exactly
# the candidate audio mux, WAV bridge, tone generator, ACR instance and tone state.
old_audio = (BASE/'player_audio_probe.v').read_text(encoding='utf-8-sig')
new_audio = (CAND/'player_audio_output.v').read_text(encoding='utf-8-sig')

def parse_audio_tone_control(src, module_name):
    core = re.sub(r'/\*.*?\*/', '', extract_module(src, module_name), flags=re.S)
    core = re.sub(r'//[^\n]*', '', core)
    alwayses=list(re.finditer(r'always\s*@\s*\(([^)]*)\)\s*begin', core))
    always=next((m for m in alwayses if norm(m.group(1)).lower()=='posedgepixel_clkorposedgerst'),None)
    if not always: raise ValueError(module_name+' pixel-clock tone always process missing')
    sensitivity = norm(always.group(1)).lower()

    # Parse nested begin/end and if/else scopes, retaining simple statements.
    body_start = always.end()
    pos = body_start
    def ws():
        nonlocal pos
        while pos < len(core) and core[pos].isspace(): pos += 1
    def word(w):
        nonlocal pos
        ws()
        m=re.match(re.escape(w)+r'\b',core[pos:])
        if not m: return False
        pos += len(m.group(0)); return True
    def paren_expr():
        nonlocal pos
        ws()
        if pos>=len(core) or core[pos]!='(': raise ValueError('expected condition paren')
        start=pos+1; depth=1; pos+=1
        while pos<len(core) and depth:
            if core[pos]=='(': depth+=1
            elif core[pos]==')': depth-=1
            pos+=1
        if depth: raise ValueError('unclosed condition paren')
        return norm(core[start:pos-1])
    def stmt():
        nonlocal pos
        ws()
        if word('begin'):
            items=[]
            while True:
                ws()
                if word('end'): break
                if pos>=len(core): raise ValueError('unclosed begin block')
                items.append(stmt())
            return ('block',items)
        if word('if'):
            cond=paren_expr(); then=stmt(); ws(); other=stmt() if word('else') else None
            return ('if',cond,then,other)
        start=pos
        while pos<len(core) and core[pos]!=';': pos+=1
        if pos>=len(core): raise ValueError('unterminated statement')
        out=core[start:pos+1]; pos+=1
        return ('simple',norm(out))
    tree=stmt()
    assignments=[]
    def walk(node,conditions):
        if node[0]=='block':
            for child in node[1]: walk(child,conditions)
        elif node[0]=='if':
            walk(node[2],conditions+[(node[1],True)])
            if node[3] is not None: walk(node[3],conditions+[(node[1],False)])
        elif re.search(r'\btone_mode<=',node[1]):
            m=re.search(r'\btone_mode<=([^;]+);',node[1])
            rhs=m.group(1)
            if rhs=='0': rhs="1'b0"
            assignments.append((conditions,rhs))
    walk(tree,[])
    expected=[([('rst',True)],"1'b0"),([('rst',False),('tone_toggle',True)],'~tone_mode')]
    if assignments!=expected:
        raise ValueError(module_name+' tone_mode scoped transitions changed: '+repr(assignments))
    return {'sensitivity':sensitivity,'transitions':assignments}

def audio_core(s, module_name):
    core = extract_module(s, module_name)
    transitions=parse_audio_tone_control(s,module_name)
    parts = [
        instance(core, 'u_bridge'), instance(core, 'u_tone'), instance(core, 'u_acr'),
        *re.findall(r'assign\s+audio_(?:valid|left|right)\s*=.*?;', core, re.S),
        json.dumps(transitions,sort_keys=True)
    ]
    return norm('\n'.join(parts))
audio_old_core = audio_core(old_audio, 'player_audio_probe')
audio_new_core = audio_core(new_audio, 'player_audio_output')
if audio_old_core != audio_new_core:
    raise SystemExit('audio functional-core token mismatch')
shared_audio_files = ['wav_pcm_bridge.v','hdmi_audio_tone_pcm_scale.v','audio_arc_calculate.v']
shared_audio_sha = {n: {'baseline':sha(BASE/n),'candidate':sha(CAND/n),'equal':sha(BASE/n)==sha(CAND/n)} for n in shared_audio_files}
if not all(x['equal'] for x in shared_audio_sha.values()):
    raise SystemExit('audio bridge/tone/ACR source changed')

# Remove only the SD read-CRC observer from C29's source before token compare.
old_sd = (BASE/'SD/sd_card_cmd.v').read_text(encoding='utf-8-sig')
new_sd = (CAND/'SD/sd_card_cmd.v').read_text(encoding='utf-8-sig')
def strip_sd_crc(s):
    s = re.sub(r'^\s*output\s+reg\[15:0\]\s+read_crc_checked,.*?\n\s*output\s+reg\[15:0\]\s+read_crc_bad,.*?\n', '\n', s, flags=re.M)
    s = re.sub(r'^\s*reg\[15:0\]\s+read_crc16;\s*\n\s*reg\[7:0\]\s+read_crc_hi;\s*\n', '\n', s, flags=re.M)
    s = re.sub(r'function\s*\[15:0\]\s*crc16_ccitt_byte\s*;.*?endfunction', '', s, flags=re.S)
    s = re.sub(r'// Passive CRC-16/CCITT.*?\nend\s*\n(?=endmodule)', '', s, flags=re.S)
    return s
sd_equal = norm(strip_sd_crc(old_sd)) == norm(new_sd)
if not sd_equal: raise SystemExit('SD command/R1 tokens differ after CRC observer removal')
old_sd_top=(BASE/'SD/sd_card_top.v').read_text(encoding='utf-8-sig')
new_sd_top=(CAND/'SD/sd_card_top.v').read_text(encoding='utf-8-sig')
def strip_sd_top_crc(s):
    s = re.sub(r'^\s*output\[15:0\]\s+read_crc_checked,.*?\n\s*output\[15:0\]\s+read_crc_bad,.*?\n', '\n', s, flags=re.M)
    s = re.sub(r'^\s*\.read_crc_checked\s*\(read_crc_checked\s*\),\s*\n\s*\.read_crc_bad\s*\(read_crc_bad\s*\),\s*\n', '', s, flags=re.M)
    return s
sd_top_equal=norm(strip_sd_top_crc(old_sd_top))==norm(new_sd_top)
if not sd_top_equal: raise SystemExit('sd_card_top differs beyond CRC port/call stripping')

# C29 memory additions were diagnostic-only taps. Removing those exact
# ports/assignments/child connections must reduce each file to C30 tokens.
memory_strips={
 'SD/frame_fifo_read.v': [
  r'^\s*output\s+wire\s*\[3:0\]\s+debug_read_state\s*,?\s*\n',
  r'^\s*assign\s+debug_read_state\s*=\s*state;\s*\n'],
 'SD/frame_read_write.v': [
  r'^\s*output\s+wire\s*\[3:0\]\s+debug_read_state\s*,?\s*\n',
  r'^\s*output\s+wire\s+debug_read_valid\s*,?\s*\n',
  r'^\s*output\s+wire\s*\[MEM_DATA_BITS-1:0\]\s+debug_read_word\s*,?\s*\n',
  r'^\s*assign\s+debug_read_valid\s*=\s*read_capture_valid;\s*\n',
  r'^\s*assign\s+debug_read_word\s*=\s*read_capture_data;\s*\n',
  r'^\s*\.debug_read_state\s*\(debug_read_state\)\s*,?\s*\n'],
 'frame_buffer_rgb888.v': [
  r'^\s*output\s+wire\s+debug_app_read,\s*debug_read_valid,\s*debug_app_write,\s*\n',
  r'^\s*output\s+wire\s*\[31:0\]\s+debug_read_word,\s*debug_write_word,\s*\n',
  r'^\s*output\s+wire\s*\[3:0\]\s+debug_read_state,\s*\n',
  r'^\s*output\s+wire\s+debug_fifo_clear,\s*debug_underflow,\s*\n',
  r'^\s*assign\s+debug_app_read\s*=\s*app_read_en;\s*\n',
  r'^\s*assign\s+debug_app_write\s*=\s*app_write_en;\s*\n',
  r'^\s*assign\s+debug_write_word\s*=\s*mem_write_word;\s*\n',
  r'^\s*assign\s+debug_fifo_clear\s*=\s*read_fifo_clear;\s*\n',
  r'^\s*assign\s+debug_underflow\s*=\s*read_underflow;\s*\n',
  r'^\s*\.debug_read_state\s*\(debug_read_state\)\s*,\s*\.debug_read_valid\s*\(debug_read_valid\)\s*,\s*\n\s*\.debug_read_word\s*\(debug_read_word\)\s*,?\s*\n']
}
memory_port_equal={}
for name, patterns in memory_strips.items():
    source=(BASE/name).read_text(encoding='utf-8-sig')
    for pat in patterns: source=re.sub(pat,'',source,flags=re.M)
    memory_port_equal[name]=norm(source)==norm((CAND/name).read_text(encoding='utf-8-sig'))
if not all(memory_port_equal.values()): raise SystemExit('memory debug-port-only stripping mismatch: '+repr([k for k,v in memory_port_equal.items() if not v]))

# Control/media modules that should remain byte-identical at C29->C30.
keep_modules = [
 'player_adjust_control.v','player_adjust_osd.v','player_osd_state.v','player_osd.v',
 'player_rgb_adjust.v','player_dynamic_text.v','player_video_schedule.v',
 'tf_bmp_file_player.v','tf_wav_file_player.v','wav_pcm_bridge.v',
 'hdmi_audio_tone_pcm_scale.v','audio_arc_calculate.v','mjp_file_reader.v','fat32_catalog.v',
 'fat32_dual_file_sector.v','jpeg420_word_address.v'
]
keep_hashes = {n:{'baseline':sha(BASE/n),'candidate':sha(CAND/n),'equal':sha(BASE/n)==sha(CAND/n)} for n in keep_modules}
if not all(v['equal'] for v in keep_hashes.values()):
    raise SystemExit('one or more retained media/control source hashes changed: '+repr([k for k,v in keep_hashes.items() if not v['equal']]))

base_top=(BASE/'top_tf_hdmi_audio.v').read_text(encoding='utf-8-sig')
cand_top=(CAND/'top_tf_hdmi_audio.v').read_text(encoding='utf-8-sig')
# Stable media selectors and control instances are compared as exact normalized source tokens.
assign_names=['bmp_file_cluster','bmp_file_size','bmp_card_read','bmp_card_addr','write_buf_idx','disp_buf_idx','sd_card_write_req','sd_card_write_en','sd_card_write_data','display_valid','bmp_error','state_code']
def assignments(src):
    out={}
    for name in assign_names:
        m=re.search(r'assign\s+'+name+r'\s*=.*?;',src,re.S)
        if not m: raise ValueError('top assignment missing: '+name)
        out[name]=norm(m.group(0))
    return out
assign_base=assignments(base_top); assign_cand=assignments(cand_top)
def control_tokens_equal(left,right,name): return left.get(name)==right.get(name)
control_instances=['u_video_schedule','u_video_reader','u_video_keys','u_wav_player','u_osd_state']
control_instances += ['u_bmp_file_player','u_adjust_control']
def strip_debug_ports(s): return re.sub(r',?\s*\.(?:debug_\w+|underflow_event|failure_detail|led)\s*\([^)]*\)', '', s)
inst_eq={n:norm(strip_debug_ports(instance(base_top,n)))==norm(strip_debug_ports(instance(cand_top,n))) for n in control_instances}
audio_inst_base=strip_debug_ports(instance(base_top,'u_audio_probe')).replace('player_audio_probe','player_audio_output')
audio_inst_cand=strip_debug_ports(instance(cand_top,'u_audio_probe'))
inst_eq['u_audio_probe_after_module_rename']=norm(audio_inst_base)==norm(audio_inst_cand)
if any(not control_tokens_equal(assign_base,assign_cand,n) for n in assign_names): raise SystemExit('top media selector assignment token mismatch')
mutated_assign=dict(assign_cand)
mutated_assign['sd_card_write_en']=mutated_assign['sd_card_write_en'].replace('video_mode_sd?','!video_mode_sd?',1)
control_bit_negative_detected=not control_tokens_equal(assign_base,mutated_assign,'sd_card_write_en')
if not control_bit_negative_detected: raise SystemExit('control-bit mutation negative control escaped checker')
if not all(inst_eq.values()): raise SystemExit('top media/control instance token mismatch: '+repr([n for n,v in inst_eq.items() if not v]))

# Source-specific assumptions used by the dynamic TB are asserted against both tops.
if not re.search(r'key0_n_async\s*\(\s*1\'b1\s*\)',instance(base_top,'u_video_source_probe')):
    raise SystemExit('C29 top key0_n_async no longer has the audited constant-high tie')
for signal,expr in {
 'probe_mode':r"assign\s+probe_mode\s*=\s*1'b0\s*;",
 'probe_tone_toggle':r'assign\s+probe_tone_toggle\s*=\s*debug_tone_press\s*;',
 'vout_data_base':r"assign\s+vout_data_base\s*=\s*osd_frame_valid\s*\?\s*vout_data_raw\s*:\s*24'd0\s*;"
}.items():
    if not re.search(expr,cand_top): raise SystemExit('C30 source-probe reduction changed: '+signal)
if not re.search(r"assign\s+led\s*=\s*~\s*\{\s*video_mode\s*,\s*debug_tone_mode\s*,\s*display_valid\s*,\s*fs_ready\s*\}\s*;",cand_top):
    raise SystemExit('C30 live LED semantics changed')

def top_video_mode_control(src):
    m=re.search(r'always\s*@\(posedge\s+video_clk\s+or\s+posedge\s+rst_all_reg\).*?(?=\n\s*always)',src,re.S)
    if not m: raise ValueError('video_mode control process missing')
    block=re.sub(r'if\s*\(video_mode_press\)\s*video_mode_press_count\s*<=.*?;', '', m.group(0))
    block=re.sub(r'video_mode_press_count\s*<=.*?;', '', block)
    return norm(block)
mode_control_equal=top_video_mode_control(base_top)==top_video_mode_control(cand_top)
if not mode_control_equal: raise SystemExit('video_mode control process changed after diagnostic counter removal')

# The key classifier file is retained; its only changed diagnostic port is checked via exact hash plus top instance.
control_hash = {'player_adjust_control.v': {'baseline':sha(BASE/'player_adjust_control.v'),'candidate':sha(CAND/'player_adjust_control.v'),'equal':sha(BASE/'player_adjust_control.v')==sha(CAND/'player_adjust_control.v')}}
if not control_hash['player_adjust_control.v']['equal']: raise SystemExit('key control classifier changed')

result={
 'status':'PASS',
 'source_counts': {'baseline':len(a),'candidate':len(b)},
 'added_files':added,'deleted_files':deleted,'changed_files':changed,
 'reviewed_file_sets_exact': {'added':added==expected_added,'deleted':deleted==expected_deleted,'changed':changed==expected_changed},
 'expected_observer_deletions_present': all(n in deleted for n in ['player_video_source_probe.v','player_memory_runtime_probe.v','player_pcm_crc_probe.v','hdmi_packet_monitor.v','player_compact_status_pages.v']),
 'control_core_hashes':keep_hashes,
 'all_retained_control_core_hashes_equal': all(v['equal'] for v in keep_hashes.values()),
 'top_media_assignments_equal':assign_base,
 'top_media_control_instance_equal':inst_eq,
 'video_mode_control_equal_after_press_counter_removal':mode_control_equal,
 'sd_card_top_tokens_equal_after_CRC_port_removal': sd_top_equal,
 'memory_three_file_debug_port_strip_equal': memory_port_equal,
 'top_diagnostic_port_strip': 'debug_* / failure_detail instrumentation, underflow_event counter tap, and legacy audio-module LED port removed before normalized instance comparison',
 'audio_functional_tokens_equal_after_LED_observation_removal': True,
 'audio_tone_mode_scoped_transition_equal': {
   'baseline':parse_audio_tone_control(old_audio,'player_audio_probe'),
   'candidate':parse_audio_tone_control(new_audio,'player_audio_output')
 },
 'audio_bridge_tone_acr_sources':shared_audio_sha,
 'sd_cmd_tokens_equal_after_only_CRC_observer_removal': sd_equal,
 'control_bit_negative_control': {'mutated_assignment':'sd_card_write_en: video_mode_sd -> !video_mode_sd','detected':control_bit_negative_detected},
 'source_probe_constant_reduction': {
   'C29_top_tie': 'u_video_source_probe.key0_n_async=1\'b1',
   'old_logic_after_settle': 'key0_sync=1, key0_active=0, probe_request=0, tone_toggle=tone_press, probe_mode remains reset-low',
   'C30_top': 'probe_mode=0; probe_tone_toggle=debug_tone_press; vout_data_base=osd_frame_valid ? vout_data_raw : 24\'d0',
   'dynamic_equivalence_test': 'tb_video_source_ablation.v',
   'negative_control': 'opposite valid gate must mismatch on generated valid/RGB stream'
 },
 'led_semantics_candidate': {'D3':'video_mode','D2':'tone_mode','D1':'display_valid','D0':'fs_ready','active_low':True},
 'note': 'Hash/token and bounded unit evidence only; no full top simulation or new synthesis was run.'
}
(OUT/'source_ablation_summary.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
print('PASS reviewed file-set assertions: added=1 deleted=10 changed=6')
print('PASS all retained media/control core file hashes match')
print('PASS audio always-scope comparison: sensitivity, reset condition/value, and tone_toggle else condition/value match')
print('PASS control-bit negative control: mutated sd_card_write_en mode-select detected')
print(json.dumps({k:result[k] for k in ['status','source_counts','added_files','deleted_files','changed_files','expected_observer_deletions_present','top_media_control_instance_equal','audio_functional_tokens_equal_after_LED_observation_removal','sd_cmd_tokens_equal_after_only_CRC_observer_removal']},indent=2))
