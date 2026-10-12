from pathlib import Path
import hashlib, re, sys

ROOT = Path(r'E:\VSCODE-project\FPGA-ANLU')
OUT = ROOT / r'development\player_dynamic_text_cadence_probe\build\board_feedback_20261011\mapped_status_model'
NET = ROOT / r'development\player_dynamic_text_cadence_probe\build\audit\final_pr_routed.v'
RTL = ROOT / r'development\player_dynamic_text_cadence_probe\src\user_source\hdl_source\player_status_monitor.v'
LIB = Path(r'C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\sim_release\eg4')

net = NET.read_text(encoding='utf-8', errors='replace')

def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()
def cell(kind, name):
    inst = re.search(rf'\\?{re.escape(name)}\s*\(', net)
    if not inst: raise RuntimeError(f'cannot locate instance {name}')
    start = net.rfind(kind + ' #(', 0, inst.start())
    if start < 0: raise RuntimeError(f'cannot locate preceding {kind} for {name}')
    end = net.find(';', inst.end())
    if end < 0: raise RuntimeError(f'cannot locate end of instance {name}')
    return net[start:end + 1]
def bit_param(block, name):
    m = re.search(rf'\.{name}\s*\(\s*16\s*\x27[bB]([01xXzZ]+)\s*\)', block)
    if not m: raise RuntimeError(f'missing {name}')
    return int(m.group(1), 2)
def comment_expr(block, key):
    m = re.search(rf'//\.{key}\("([^"]+)"\)', block)
    if not m: raise RuntimeError(f'missing comment {key}')
    return m.group(1)
def init_eval(value, a, b, c, d):
    # EG INIT bit address is {D,C,B,A}, with A at bit 0.
    return (value >> (a | (b << 1) | (c << 2) | (d << 3))) & 1

def norm_expr(expr):
    return re.sub(r'\s+', '', expr)

count = cell('EG_PHY_MSLICE', 'u_status_monitor/audio_count_reg[15]_syn_4')
mb = cell('EG_PHY_MSLICE', 'u_status_monitor/mailbox_reg[17]_syn_4')
sel = cell('EG_PHY_LSLICE', 'rst_all_reg_reg_syn_217')

mb_init = bit_param(mb, 'INIT_LUT1')
mb_expr = norm_expr(comment_expr(mb, 'LUT1'))
sel_init = bit_param(sel, 'INIT_LUTF0')
sel_expr = norm_expr(comment_expr(sel, 'LUTF0'))
expected_mb = '(C*~(B)*~(D)+C*B*~(D)+~(C)*B*D+C*B*D)'
expected_sel = '(D*~(C*B*A))'
if mb_expr != expected_mb or sel_expr != expected_sel:
    raise RuntimeError(f'Unexpected mapped expressions: mailbox={mb_expr}; selector={sel_expr}')

# Exhaustively compare the actual INIT parameters with the truth expressions
# printed beside those exact final-netlist instances.
for a in range(2):
  for b in range(2):
    for c in range(2):
      for d in range(2):
        mb_expected = int((c and not b and not d) or (c and b and not d) or (not c and b and d) or (c and b and d))
        if init_eval(mb_init, a, b, c, d) != mb_expected:
          raise RuntimeError(f'mailbox INIT/comment mismatch at A{a}B{b}C{c}D{d}')
        sel_expected = int(d and not (c and b and a))
        if init_eval(sel_init, a, b, c, d) != sel_expected:
          raise RuntimeError(f'selector INIT/comment mismatch at A{a}B{b}C{c}D{d}')

# No-audio boundary: the mapped selector LUT has D=audio_valid on input D[0].
# D=0 makes its actual output 0 for every A/B/C combination.
sel_no_audio = [init_eval(sel_init, a, b, c, 0) for a in range(2) for b in range(2) for c in range(2)]
assert sel_no_audio == [0] * 8

# Mailbox LUT1: B=sum[17], C=count[17], D=audio_count_b1_n selector.
# Verify no-audio select=0 gives count[17] for both possible sum bits.
rows = []
for a in range(2):
  for sum17 in range(2):
    for count17 in range(2):
      actual = init_eval(mb_init, a, sum17, count17, 0)
      assert actual == count17
      rows.append(f'A={a} sum17={sum17} count17={count17} selector=0 -> mapped f17={actual}')

required = {
  'count reg instance': ('REG0_REGSET("RESET")' in count and 'SRMODE("ASYNC")' in count and '.sr(\\u_status_monitor/startup_flags[1]_dup_4336 )' in count and '.d({\\u_status_monitor/audio_count_b1 [15],\\u_status_monitor/audio_count_b1 [17]})' in count and '.q({\\u_status_monitor/audio_count [15],\\u_status_monitor/audio_count [17]})' in count),
  'mailbox instance': ('CEMUX("CE")' in mb and 'REG1_REGSET("RESET")' in mb and 'SRMODE("ASYNC")' in mb and '.ce(\\u_status_monitor/mux5_syn_2 [27])' in mb and '.sr(\\u_status_monitor/startup_flags[1]_dup_4336 )' in mb and '.q({\\u_status_monitor/mailbox [17],\\u_status_monitor/mailbox [19]})' in mb),
  'selector producer': ('audio_valid' in sel and 'audio_count_b1_n' in sel and 'INIT_LUTF0(16\'b0111111100000000)' in sel),
}
if not all(required.values()): raise RuntimeError(f'connectivity check failed: {required}')

# Write exact extracted cell text. Port boundary nets remain the names from final_pr_routed.v.
(OUT / 'extracted_instances.v.txt').write_text(
  '// Exact instance parameter/connection text extracted from final_pr_routed.v.\n'
  '// Text only; this is not a standalone simulation or a complete combinational cone.\n\n'
  + '// --- audio_count_reg[15]_syn_4 ---\n' + count + '\n\n'
  + '// --- mailbox_reg[17]_syn_4 ---\n' + mb + '\n\n'
  + '// --- rst_all_reg_reg_syn_217: audio_count_b1_n selector producer ---\n' + sel + '\n', encoding='utf-8')

hashes = [NET, RTL, LIB/'eg_phy_mslice.v', LIB/'eg_phy_lslice.v', LIB/'eg_phy_glbl.v', LIB/'eg_phy_dff.v']
lines = ['SHA256  FILE'] + [f'{sha(p)}  {p}' for p in hashes]
(OUT / 'sourcehashes.txt').write_text('\n'.join(lines)+'\n', encoding='utf-8')

report = [
 'Mapped status bit-17 local audit',
 'Scope: final_pr_routed.v exact parameter/port extraction plus exhaustive Boolean decoding of two actual INIT LUTs.',
 'Classification: mapped-netlist parameter audit; NOT a behavioral simulation of the original full netlist or official EG primitive model.',
 '',
 f'Netlist SHA256: {sha(NET)}', f'RTL SHA256: {sha(RTL)}',
 f'Official MSLICE model SHA256: {sha(LIB/"eg_phy_mslice.v")}',
 '',
 'Extracted instances:',
  '  audio_count_reg[15]_syn_4: q[0] = audio_count[17], d[0] = audio_count_b1[17], async SR input startup_flags[1]_dup_4336, REG*_REGSET RESET.',
  '  mailbox_reg[17]_syn_4: LUT1 INIT=0xCCF0, f[1]=audio_count_b1[17], q[1]=mailbox[17], CE=mux5_syn_2[27], async SR=startup_flags[1]_dup_4336.',
 '  rst_all_reg_reg_syn_217: LUTF0 INIT=0x7F00, d[0]=audio_valid, f[0]=audio_count_b1_n.',
 '',
 f'  mailbox LUT truth/comment exhaustive match: 16/16 inputs; comment={mb_expr}; INIT=0x{mb_init:04X}.',
 f'  selector LUT truth/comment exhaustive match: 16/16 inputs; comment={sel_expr}; INIT=0x{sel_init:04X}.',
 f'  no-audio selector boundary D=audio_valid=0: output 0 for all A/B/C combinations ({len(sel_no_audio)}/8).',
 '  selector=0 no-audio bit-17 mux truth: sum17 x count17 x unused A, 8/8 combinations yield f17=count17.',
 '  At 48,000 samples, count17=0; 48,001 also has bit17=0. This local mapped LUT therefore does not introduce bit17=1 when selector is held at no-audio value 0.',
 '', 'Exhaustive no-audio rows:', *rows,
 '',
 'Sequential boundary evidence (connectivity only):',
 '  Count FF receives mapped f17 via audio_count_b1[17]; async reset parameter says RESET and reset pin is connected. This script does not simulate FF behavior.',
 '  Mailbox FF CE and SR pins plus q17 connectivity were extracted. This script does not simulate CE/hold/reset behavior.',
 '',
 'Limitations:',
 '  Tang Dynasty official eg_phy_mslice.v and eg_phy_lslice.v contain protected functional model blocks. Icarus cannot provide an official-model primitive simulation from those encrypted internals; stripping protect blocks would remove behavior and is not accepted as validation.',
 '  The full final netlist is not compiled (known Icarus crash not retried). This is an actual mapped INIT/connection audit, not an RTL-copy verification and not a full mapped-netlist simulation.',
 '  No root/central development record modified.',
]
(OUT / 'report.txt').write_text('\n'.join(report)+'\n', encoding='utf-8')
print('\n'.join(report))
