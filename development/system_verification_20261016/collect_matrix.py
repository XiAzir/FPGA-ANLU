"""Seal selected completed evidence; never reinterpret an exploratory failure as DUT failure."""
from pathlib import Path
from datetime import datetime,timezone,timedelta
import hashlib,json,re
HERE=Path(__file__).resolve().parent
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
selections={
 'media_C11206':'integration/run_C11206_20261016_180507',
 'media_C11309':'integration/run_C11309_20261016_181233',
 'media_C11310':'integration/run_C11310_20261016_181233',
 'framebuffer_icarus':'memory/framebuffer_20261016_174140',
 'framebuffer_modelsim_overlap':'memory/framebuffer_modelsim_20261016_180602',
 'hdmi_C11206_dynamic':'hdmi/period_C11206_positive_20261016_181443',
 'hdmi_C11310_dynamic':'hdmi/period_C11310_positive_20261016_181646',
 'hdmi_rgb_negative':'hdmi/period_C11206_negative_rgb_20261016_181645',
 'hdmi_audio_negative':'hdmi/period_C11206_negative_audio_20261016_181646',
 'hdmi_C11310_ordered_stereo':'hdmi/period_C11310_positive_20261016_181940',
 'hdmi_C11310_ordered_stereo_negative':'hdmi/period_C11310_negative_audio_20261016_181940',
 'fft_checker_guards':'integration/fft_checker_selftest_20261016_181200',
}
results=[]
for name,relative in selections.items():
 out=HERE/relative;summary=out/'summary.json'
 if not summary.exists():
  results.append(dict(name=name,status='PENDING',directory=str(out)));continue
 data=json.loads(summary.read_text(encoding='utf-8-sig'))
 if data['status'] not in ('PASS_SCOPE','SYSTEM_MEDIA_PASS_WITH_MODEL_ASSUMPTIONS'):
  raise RuntimeError('Selected case did not pass: '+str(summary))
 checks=list(data.get('inputs',[]))
 for receipt in ['source_receipt.json','fixture_receipt.json']:
  file=out/receipt
  if file.exists():
   content=json.loads(file.read_text(encoding='utf-8-sig'))
   if isinstance(content,list):checks+=content
   else:
    checks+=content.get('inputs',[])
    cp=Path(content['checkpoint'])/'manifest.json'
    if sha(cp).lower()!=content['manifest_sha256'].lower():raise ValueError('Frozen manifest changed')
    checks += [dict(path=c['copy'],sha256=c['copy_sha256']) for c in content.get('compatibility_copies',[])]
 for item in checks:
  p=Path(item['path'])
  if not p.exists() or sha(p).lower()!=item['sha256'].lower():raise ValueError('Evidence input changed: '+str(p))
 if 'testbench_sha256' in data and sha(out/'tb_system.v').lower()!=data['testbench_sha256'].lower():raise ValueError('TB changed')
 logs=[p for p in out.glob('*.log') if p.name in ('console.log','positive.log','negative.log')]
 if name.startswith('media_'):
  text=(out/'console.log').read_text(errors='replace')
  marker=re.search(r'SYSTEM_MEDIA_PASS PCM_push=(\d+) PCM_consume=(\d+) BMP_pixels=(\d+) read_pixels=(\d+) frames=(\d+)',text)
  if not marker:raise ValueError('Missing full-top content/count marker')
  counts=dict(zip(['pcm_push','pcm_consume','bmp_pixels','read_pixels','read_frames'],map(int,marker.groups())))
 else:counts=None
 # A post-run receipt includes fixture files that the first runner revision
 # did not yet place in its start-time receipt. It is explicitly post-run.
 assets=[p for p in out.iterdir() if p.is_file() and p.suffix in ('.v','.mem','.json','.log','.csv','.diff','.f','.do') and p.name!='collected_input_receipt.json']
 digest_receipt=[dict(path=str(p),sha256=sha(p)) for p in sorted(assets)]
 (out/'collected_input_receipt.json').write_text(json.dumps(dict(kind='POST_RUN_EVIDENCE_RECEIPT',files=digest_receipt),indent=2))
 results.append(dict(name=name,status='PASS_SCOPE',directory=str(out),summary_sha256=sha(summary),counts=counts,fft=data.get('fft'),verified_start_input_records=len(checks),evidence_receipt_sha256=sha(out/'collected_input_receipt.json')))
complete=all(r['status']=='PASS_SCOPE' for r in results)
report=dict(updated_beijing=datetime.now(timezone(timedelta(hours=8))).isoformat(),
 status='NOMINAL_OFFLINE_SUITE_PASS_WITH_ASSUMPTIONS' if complete else 'NOMINAL_SUITE_PENDING',
 field_fault_reproduced=False,hardware_root_cause_confirmed=False,new_bitstream_built=False,
 assumptions=['PLL initialization adapter and qualified edge replay under fixed 50MHz/reset0','Explicit zero extension at two FIFO count input ports in isolated simulation copies','Application-interface SDRAM model with data-leading-valid; physical SDRAM controller/model not qualified','Generated BMP and 4096-sample real-WAV excerpt, not original TF image or complete song'],
 unverified=['Complete SDF/physical timing','Non-nominal reset/clock/card-delay matrix','Long KEY1 source switching in whole top','All original TF contents and long runtime','Actual board HDMI/FFT field-failure reproduction'],results=results)
(HERE/'nominal_matrix.json').write_text(json.dumps(report,indent=2))
print(report['status']);print('cases',len(results),'passed',sum(r['status']=='PASS_SCOPE' for r in results))
raise SystemExit(0 if complete else 2)
