"""Extract the unchanged routed mailbox-destination -> three 595 PAD cone.

Reuses the audited lane-aware parser; this does not synthesize new logic.
External boundaries: ideal 50 MHz clock, global reset copies and 32 input bits.
Unobserved co-packed lanes may have floating inputs; observed closure is checked.
"""
from pathlib import Path
import sys, json

ROOT = Path(__file__).resolve().parents[4]
parser = ROOT / 'development/regression_failed_releases_20261016/fft_netlist/extract_fft.py'
source = ROOT / 'development/player_spectrum_trace/build/audit/routed_implementation.v'
out = Path(__file__).resolve().parent / 'display_cone'
original = parser.read_text(encoding='utf-8')
prefix = original[:original.index("clock='u_status_monitor/sys_clk'")]
prefix = prefix.replace("'EG_PHY_MULT18'):", "'EG_PHY_MULT18','EG_PHY_PAD'):")
sys.argv = [str(parser), '--source', str(source), '--out', str(out), '--routed']
scope = {}
exec(compile(prefix, str(parser), 'exec'), scope)
widths = scope['widths']
bounds = {'u_bmp_file_mapper/clk': 'clk'}
for name in widths:
    if name.startswith('u_status_monitor/startup_flags[1]_dup_'):
        bounds[name] = 'rst'
if 'u_status_monitor/startup_flags' in widths:
    bounds['u_status_monitor/startup_flags [1]'] = 'rst'
bounds['u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst'] = 'rst'
for i in range(32):
    bounds[f'u_status_mailbox/destination_hex [{i}]'] = f'hex_value[{i}]'
targets = ['seg7_dio', 'seg7_sclk', 'seg7_rclk']
scope.update(bounds=bounds, targets=targets)
closure = original[original.index('todo=sum('):original.index("summary=dict(")]
exec(compile(closure, str(parser), 'exec'), scope)
tail = original[original.index('summary=dict('):]
tail = tail[:tail.index("body=['`timescale")]
exec(compile(tail, str(parser), 'exec'), scope)
body = ['`timescale 1ns/1ps',
        'module display_cone(input clk,rst,input [31:0] hex_value,output seg7_dio,seg7_sclk,seg7_rclk);']
body += scope['decls']
for name in scope['cut_wires']:
    body.append('wire ' + name + ';')
for original_net, replacement in bounds.items():
    name = '\\' + original_net if '/' in original_net else original_net
    body.append(f'assign {name} = {replacement};')
for i in sorted(scope['selected']):
    body.append(scope['cells'][i]['raw'])
body.append('endmodule')
(out / 'display_cone.v').write_text('\n'.join(body) + '\n', encoding='utf-8')
pin_nets = {}
for i in scope['selected']:
    c = scope['cells'][i]
    if c['typ'] in ('assign', 'buf'):
        continue
    pins = {}
    for pin, expr in c['p'].items():
        bb = scope['bits'](expr, True)
        for n, net in enumerate(reversed(bb)):
            pins[pin + (f'[{n}]' if len(bb) > 1 else '')] = net
    pin_nets[c['name']] = pins
(out / 'pin_nets.json').write_text(json.dumps(pin_nets, indent=2), encoding='utf-8')
