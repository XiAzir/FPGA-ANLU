#!/usr/bin/env python3
"""Generate explicit PLL event replay from the 0..10 us ModelSim edge trace."""
import csv
from decimal import Decimal
from pathlib import Path

HERE=Path(__file__).resolve().parent
TRACE=HERE/'pll_trace.csv'
OUTPUT=HERE/'pll_clock_replay.v'
CLOCKS=('sys0','sys1','sys2','pclk','serclk')
LOCKS=('slock','vlock')
rows={name:[] for name in CLOCKS+LOCKS}
with TRACE.open(newline='') as f:
    for row in csv.reader(f):
        t,name,value=row
        rows[name].append((Decimal(t),value.lower()))

def emit_clock(name):
    events=[(t,v) for t,v in rows[name] if v in ('0','1') and t>0]
    if len(events)<100: raise SystemExit(f'{name} has too few captured transitions: {len(events)}')
    diffs=[events[i][0]-events[i-1][0] for i in range(len(events)-32,len(events))]
    half=sorted(diffs)[len(diffs)//2]
    lines=[f'  initial begin {name}=1\'bx;']
    prev=Decimal(0)
    for t,v in events:
        lines.append(f'    #({t-prev}); {name}=1\'b{v};')
        prev=t
    lines.append(f'    #({half}); {name}=~{name};')
    lines.append(f'    forever #({half}) {name}=~{name};')
    lines.append('  end')
    return lines,half,len(events),events[-1][0]

lines=['`timescale 1ns/100fs','// Generated from the recorded vendor-PLL model event trace.',
       '// Optional simulation acceleration only; not synthesizable or hardware evidence.',
       'module pll_clock_replay(input wire refclk,input wire reset,',
       ' output reg slock, output reg vlock,',
       ' output reg sys0, output reg sys1, output reg sys2,',
       ' output reg pclk, output reg serclk);',
       '  realtime last_ref_edge;','  initial last_ref_edge=0.0;',
       '  always @(posedge refclk) begin',
       '    if(last_ref_edge!=0.0 && ($realtime-last_ref_edge)!=20.0) begin',
       '      $display("FATAL replay reference clock period %0.4f ns",$realtime-last_ref_edge); $fatal(1); end',
       '    last_ref_edge=$realtime;',
       '    if(reset!==1\'b0) begin $display("FATAL replay reset deviated from recorded constant 0"); $fatal(1); end',
       '  end',
       '  always begin #20.1; if(($realtime-last_ref_edge)>20.0) begin $display("FATAL replay reference clock stopped/slow"); $fatal(1); end end',
       '  always @(reset) if(reset!==1\'b0) begin $display("FATAL replay reset changed"); $fatal(1); end']
meta={}
for name in CLOCKS:
    body,half,count,last=emit_clock(name); lines.extend(body); meta[name]={'transition_count_first_10us':count,'repeat_half_period_ns':str(half),'last_recorded_edge_ns':str(last)}
for name in LOCKS:
    events=[(t,v) for t,v in rows[name] if v in ('0','1')]
    lines.append(f'  initial begin {name}=1\'bx;')
    prev=Decimal(0)
    for t,v in events:
        lines.append(f'    #({t-prev}); {name}=1\'b{v};')
        prev=t
    lines.append('  end')
    meta[name]={'events':[[str(t),v] for t,v in events]}
lines.append('endmodule')
OUTPUT.write_text('\n'.join(lines)+'\n',encoding='ascii')
(HERE/'replay_meta.json').write_text(__import__('json').dumps({'trace_window_us':10,'signals':meta},indent=2)+'\n',encoding='utf-8')
print(OUTPUT)
print(__import__('json').dumps(meta,indent=2))
