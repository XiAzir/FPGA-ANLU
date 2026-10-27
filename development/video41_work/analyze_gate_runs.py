"""Summarize actual command traces and binding hashes from selected gate runs."""
import argparse
import csv
import hashlib
import json
from pathlib import Path
import re

parser=argparse.ArgumentParser()
parser.add_argument('runs',nargs='+',type=Path)
parser.add_argument('--out',required=True,type=Path)
args=parser.parse_args()
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
records=[]
for run in args.runs:
    binding=json.loads((run/'source_binding.json').read_text(encoding='utf-8-sig'))
    log=(run/'run.log').read_text(encoding='utf-8-sig')
    rows=list(csv.DictReader((run/'command_trace.csv').open()))
    command_cycles=[int(r['cycle']) for r in rows if r['cmd']=='001']
    gaps=[b-a for a,b in zip(command_cycles,command_cycles[1:])]
    summary=re.search(r'GATE_REFRESH_SUMMARY[^\r\n]*',log)
    records.append({'run':str(run),'source_gate_sha256':binding['original_gate_sha256'],
      'gate_copy_sha256':binding['simulation_gate_copy_sha256'],
      'bench_sha256':binding['bench_sha256'],'device_shell_sha256':binding['device_shell_sha256'],
      'complete':'GATE_REFRESH_COMPLETE' in log,'summary':summary[0] if summary else None,
      'AREF_count_trace':len(command_cycles),'gaps_clocks':gaps,
      'minimum_gap_clocks':min(gaps) if gaps else None,'maximum_gap_clocks':max(gaps) if gaps else None,
      'trace_sha256':sha(run/'command_trace.csv'),'log_sha256':sha(run/'run.log'),
      'traffic':binding['traffic'],'simulation_ack_edge_override':binding['simulation_ack_stage0_edge_override'],
      'simulation_scope':'Original mapped controller commands; forced clocks/reset and external app inputs, inert device observer, no SDF or data retention.'})
args.out.write_text(json.dumps({'runs':records},ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(records,ensure_ascii=False,indent=2))
