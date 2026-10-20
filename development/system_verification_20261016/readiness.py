"""Report verification coverage; intentionally refuse an unsupported system PASS."""
from pathlib import Path
from datetime import datetime,timezone,timedelta
import json,hashlib

HERE=Path(__file__).resolve().parent
stages=[]
latest=HERE/'startup/latest.json'
if latest.exists():
 ref=json.loads(latest.read_text(encoding='utf-8'))
 result=json.loads(Path(ref['summary']).read_text(encoding='utf-8'))
 ok=len(result['results'])==3 and all(x['status']=='PASS' for x in result['results'])
 stages.append(dict(id='original_reset_wait',status='PASS_SCOPE' if ok else 'FAIL',
  evidence=ref['summary'],scope='Three archived controllers, original million-clock wait; explicit lock stimuli.'))
else:stages.append(dict(id='original_reset_wait',status='NOT_RUN'))
pll=HERE/'pll/summary.json'
pll_data=json.loads(pll.read_text(encoding='utf-8-sig')) if pll.exists() else {}
raw_status=pll_data.get('status','UNCLASSIFIED' if pll.exists() else 'NOT_RUN')
stages.append(dict(id='vendor_pll_cold_start',status='MODEL_GAP' if raw_status=='MODEL_CALIBRATION_FAILED' else raw_status,
 evidence=str(pll) if pll.exists() else None,
 scope='Unmodified vendor model under original top reset=0 must match known-good hardware startup before whole-system validation.'))
adapter=pll_data.get('adapter',{})
adapter_status=adapter.get('status',pll_data.get('adapter_status','NOT_RUN'))
stages.append(dict(id='pll_simulation_initialization_adapter',status=adapter_status,
 evidence=str(pll) if adapter or 'adapter_status' in pll_data else None,
 scope='Simulation-only model initialization, if present, is an explicit assumption and never a production PLL change.'))
sd_receipt=HERE/'card/modelsim_summary.json'
sd_ok=False
if sd_receipt.exists():
 sd=json.loads(sd_receipt.read_text(encoding='utf-8-sig'))
 sd_ok=sd.get('status')=='PASS_SCOPE'
 for name,digest in sd.get('all_sha256',{}).items():
  path=(HERE.parents[1]/name) if name.startswith('development/') else (HERE/'card'/name)
  sd_ok=sd_ok and path.exists() and hashlib.sha256(path.read_bytes()).hexdigest().lower()==digest.lower()
 if not sd.get('all_sha256'):sd_ok=False
stages.append(dict(id='sd_pin_model_unit',status='PASS_SCOPE' if sd_ok else 'NOT_QUALIFIED',
 evidence=str(sd_receipt),scope='Exact two-sector data, CRC and CS-interruption recovery through real SD controller; not full FAT32/BMP/WAV integration.'))
matrix_path=HERE/'nominal_matrix.json'
matrix=json.loads(matrix_path.read_text(encoding='utf-8')) if matrix_path.exists() else {}
matrix_ok=matrix.get('status')=='NOMINAL_OFFLINE_SUITE_PASS_WITH_ASSUMPTIONS'
for case in matrix.get('results',[]):
 directory=Path(case['directory'])
 for filename,key in [('summary.json','summary_sha256'),('collected_input_receipt.json','evidence_receipt_sha256')]:
  file=directory/filename
  matrix_ok=matrix_ok and file.exists() and hashlib.sha256(file.read_bytes()).hexdigest().lower()==case.get(key,'').lower()
if not matrix.get('results'):matrix_ok=False
extended_path=HERE/'extended_matrix.json'
extended=json.loads(extended_path.read_text(encoding='utf-8')) if extended_path.exists() else {}
extended_cases={}
for case in extended.get('results',[]):
 directory=Path(case['directory']);ok=case.get('status')=='PASS_SCOPE'
 for filename,key in [('summary.json','summary_sha256'),('extended_evidence_receipt.json','evidence_receipt_sha256')]:
  path=directory/filename
  ok=ok and path.exists() and hashlib.sha256(path.read_bytes()).hexdigest().lower()==case.get(key,'').lower()
 if ok:
  receipt=json.loads((directory/'extended_evidence_receipt.json').read_text())
  for asset in receipt['files']:
   path=Path(asset['path'])
   ok=ok and path.exists() and hashlib.sha256(path.read_bytes()).hexdigest().lower()==asset['sha256'].lower()
 extended_cases[case['name']]=ok
pin_ready=all(extended_cases.get('whole_pins_'+version,False) for version in ['C11206','C11309','C11310'])
controller_ready=all(extended_cases.get(name,False) for name in ['controller_basic','controller_matrix','controller_negative_data'])
stages.append(dict(id='nominal_full_top_fft_matrix',status='PASS_SCOPE' if matrix_ok else 'NOT_QUALIFIED',evidence=str(matrix_path),
 scope='C11206/C11309/C11310 nominal TF/FAT32/BMP/WAV/framebuffer; latter two each three real FFT frames and 72 exact bands; explicit model/port-width assumptions.'))
stages.extend([
 dict(id='tf_pin_model_to_real_media_consumers',status='PASS_SCOPE' if matrix_ok else 'NOT_INTEGRATED',scope='Nominal SD pin/FAT32/BMP/WAV route, original startup wait; no direct PCM injection; short test fixtures only.'),
 dict(id='sdram_data_and_read_timing',status='PASS_SCOPE_APPLICATION_MODEL' if matrix_ok else 'NOT_INTEGRATED',scope='Actual framebuffer/FIFO/codec with independent full-frame gold; physical SDRAM controller/model remains unqualified.'),
 dict(id='vendor_sdram_controller_model',status='PASS_SCOPE_ISOLATED_GATE' if controller_ready else 'MODEL_GAP',evidence=str(extended_path),scope='Unchanged production controller independently synthesized to gate, native PADs and APUG011 pin model; 1024 words/four banks/masks/post-refresh and exact one-bit negative. Whole-top still uses application model; not routed SiP timing.'),
 dict(id='hdmi_serial_receiver_and_payload_scoreboard',status='PASS_SCOPE' if pin_ready else ('PASS_SCOPE_STANDALONE' if matrix_ok else 'NOT_INTEGRATED'),evidence=str(extended_path),scope='Three archived whole tops through SD/media/real core/PHY pins; strict 1536000 RGB pixels after first cold frame, ordered real-WAV stereo; FFT and visible bars in spectrum versions. Explicit model assumptions remain.'),
 dict(id='whole_top_startup_reset_key_source_matrix',status='NOMINAL_ONLY' if matrix_ok else 'NOT_INTEGRATED',scope='Nominal whole top verified; long KEY1 and non-nominal clock/reset/card timing matrix incomplete.'),
 dict(id='complete_sdf_and_constraint_coverage',status='INCOMPLETE',scope='Do not silently omit unsupported cells or timing checks.'),
 dict(id='physical_io_power_receiver',status='HARDWARE_FINAL_ACCEPTANCE',scope='Electrical behavior and actual external devices require final hardware acceptance.'),
])
acceptable={'PASS_SCOPE','MODEL_CALIBRATION_PASS','MODEL_INIT_ADAPTER_FUNCTIONAL_PASS'}
required=[s for s in stages if s['id'] not in ('physical_io_power_receiver',
 'vendor_pll_cold_start','pll_simulation_initialization_adapter')]
clock_ready=any(s['status'] in acceptable for s in stages if s['id'] in (
 'vendor_pll_cold_start','pll_simulation_initialization_adapter'))
ready=clock_ready and all(s['status'] in acceptable for s in required)
report=dict(updated_beijing=datetime.now(timezone(timedelta(hours=8))).isoformat(),
 system_simulation_ready=ready,status='SYSTEM_SIMULATION_READY' if ready else 'NOT_READY_FOR_SYSTEM_PASS',stages=stages)
(HERE/'readiness.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
for item in stages:print(item['id']+': '+item['status'])
print(report['status']+': component tests do not constitute full-system verification.')
# Coverage gaps are not a production RTL failure; nonzero prevents a false CI green.
raise SystemExit(0 if ready else 2)
