"""Collect the additional real-controller and whole-top serial-pin evidence.

This is an explicitly post-run receipt. Exploratory failures remain untouched.
"""
from pathlib import Path
from datetime import datetime,timezone,timedelta
import hashlib,json,re
HERE=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
selections={
 'whole_pins_C11206':'integration/run_C11206_20261016_183637',
 'whole_pins_C11310':'integration/run_C11310_20261016_183951',
 'whole_pins_C11309':'integration/run_C11309_20261016_184314',
 'controller_basic':'memory/controller_model_20261016_183434',
 'controller_matrix':'memory/controller_model_20261016_184042',
 'controller_negative_data':'memory/controller_model_20261016_184257',
}
results=[]
for name,relative in selections.items():
 out=HERE/relative;summary=out/'summary.json'
 if not summary.exists():results.append(dict(name=name,status='PENDING',directory=str(out)));continue
 data=json.loads(summary.read_text(encoding='utf-8-sig'))
 expected='SYSTEM_MEDIA_PASS_WITH_MODEL_ASSUMPTIONS' if name.startswith('whole_') else ('NEGATIVE_DATA_DETECTED' if name=='controller_negative_data' else 'PASS_SCOPE_PIN_MODEL')
 if data['status']!=expected:raise ValueError('Selected case not qualified: '+str(summary))
 for receipt_name in ['source_receipt.json','fixture_receipt.json']:
  receipt=out/receipt_name
  if not receipt.exists():continue
  content=json.loads(receipt.read_text(encoding='utf-8-sig'))
  items=content if isinstance(content,list) else content.get('inputs',[])
  for item in items:
   path=Path(item.get('copy',item.get('path','')))
   if not path.is_file() or sha(path).lower()!=item['sha256'].lower():raise ValueError('Executed input changed: '+str(path))
  if isinstance(content,dict) and 'checkpoint' in content:
   manifest=Path(content['checkpoint'])/'manifest.json'
   if sha(manifest).lower()!=content['manifest_sha256'].lower():raise ValueError('Frozen manifest changed')
   for item in content.get('compatibility_copies',[]):
    if sha(Path(item['copy'])).lower()!=item['copy_sha256'].lower():raise ValueError('Compatibility copy changed')
 log=(out/'console.log').read_text(errors='replace');counts={}
 if re.search(r'\*\* (?:Error|Fatal)|\bFATAL\b',log):raise ValueError('Simulator error in selected case')
 if name.startswith('whole_'):
  if not data.get('serial_scoreboard') or 'SYSTEM_PIN_CONTENT_PASS' not in log:raise ValueError('Serial scoreboard absent')
  m=re.search(r'SYSTEM_PIN_RESULT rgb_sent=(\d+) rgb_checked=(\d+) rows=(\d+) pcm_sent=(\d+) pcm_checked=(\d+)',log)
  if not m:raise ValueError('Serial content counts missing')
  counts=dict(zip(['rgb_sent','rgb_checked','rows','pcm_sent','pcm_checked'],map(int,m.groups())))
  render=re.search(r'SPECTRUM_RENDER_RESULT visible_bar_pixels=(\d+)',log)
  counts['spectrum_visible_pixels']=int(render[1]) if render else None
  if data['version']!='C11206' and (not render or int(render[1])==0):raise ValueError('Spectrum visibility not verified')
 else:
  counts=dict(checked_words=data['checked_words'],mismatches=data['mismatch_count'],data_offset_cycles=data['data_offset_cycles'])
  if name=='controller_negative_data' and (data['mismatch_count']!=1 or data['first_mismatches'][0]['index']!=20):raise ValueError('Data flip not detected exactly')
 assets=[p for p in out.iterdir() if p.is_file() and p.suffix in ('.v','.vh','.mem','.json','.log','.csv','.diff','.f','.do') and p.name!='extended_evidence_receipt.json']
 receipt=out/'extended_evidence_receipt.json'
 receipt.write_text(json.dumps(dict(kind='POST_RUN_EVIDENCE_RECEIPT',files=[dict(path=str(p),sha256=sha(p)) for p in sorted(assets)]),indent=2))
 results.append(dict(name=name,status='PASS_SCOPE',directory=str(out),summary_sha256=sha(summary),evidence_receipt_sha256=sha(receipt),counts=counts,fft=data.get('fft')))
complete=all(r['status']=='PASS_SCOPE' for r in results)
report=dict(updated_beijing=datetime.now(timezone(timedelta(hours=8))).isoformat(),
 status='EXTENDED_NOMINAL_PASS_WITH_ASSUMPTIONS' if complete else 'EXTENDED_NOMINAL_PENDING',
 field_fault_reproduced=False,hardware_root_cause_confirmed=False,new_bitstream_built=False,results=results,
 limitations=['Full-top tests still use application-interface SDRAM model; real controller verified separately',
 'Controller gate is isolated synthesis, not exact whole-top placed/routed implementation',
 'PLL initialization adapter and qualified nominal edge replay; isolated FIFO count zero-extension copies',
 'Cold-start first full serial video frame excluded; remaining frames compared without resynchronization',
 'Non-nominal reset/clock/card timing, real long KEY1 and full SDF still incomplete'])
(HERE/'extended_matrix.json').write_text(json.dumps(report,indent=2))
print(report['status'],len(results),'cases',sum(r['status']=='PASS_SCOPE' for r in results),'passed')
raise SystemExit(0 if complete else 2)
