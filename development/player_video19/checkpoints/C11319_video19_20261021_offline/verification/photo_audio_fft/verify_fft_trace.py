"""Compare passive whole-system FFT captures with the existing independent oracle."""
from pathlib import Path
import importlib.util,json,hashlib

def verify(out,min_frames=3):
 spec=importlib.util.spec_from_file_location('isolated_spectrum_oracle',out/'spectrum_oracle.py')
 oracle=importlib.util.module_from_spec(spec);spec.loader.exec_module(oracle)
 frames={};done=[]
 for line in (out/'fft_trace.csv').read_text(encoding='ascii').splitlines():
  q=line.split(',');kind=q[0]
  if kind not in ('S','B','D'):raise ValueError('Malformed FFT trace record')
  frame=int(q[1]);entry=frames.setdefault(frame,dict(samples=[],bands=[]))
  if kind=='D':
   if len(q)!=2 or frame in done:raise ValueError('Duplicate/malformed FFT completion')
   done.append(frame)
  else:
   if len(q)!=4:raise ValueError('Malformed sample/band record')
   index=int(q[2]);value=int(q[3],16) # X/Z deliberately rejected.
   if not 0<=value<=65535:raise ValueError('Out-of-range FFT value')
   target=entry['samples' if kind=='S' else 'bands']
   if index!=len(target):raise ValueError(f'FFT {kind} sequence gap/duplicate frame {frame}: {index}/{len(target)}')
   if kind=='S' and value>=32768:value-=65536
   target.append(value)
 if len(done)<min_frames or done!=list(range(len(done))):raise ValueError('FFT completion/liveness requirement not met')
 errors=[];checks=0
 for frame,entry in frames.items():
  samples,bands=entry['samples'],entry['bands']
  if frame in done and (len(samples)!=1024 or len(bands)!=24):raise ValueError('Incomplete completed FFT frame')
  if len(samples)>1024 or len(bands)>24 or (bands and len(samples)!=1024):raise ValueError('Invalid FFT frame size')
  if bands:
   expected=oracle.band_proxy(oracle.fixed_fft(samples))
   for i,value in enumerate(bands):
    checks+=1
    if value!=expected[i]:errors.append(dict(frame=frame,band=i,got=value,expected=expected[i]))
 if errors:raise ValueError('FFT band mismatch: '+json.dumps(errors[:5]))
 report=dict(status='PASS_SCOPE',completed_frames=len(done),band_checks=checks,max_abs_error=0,
  oracle_sha256=hashlib.sha256((out/'spectrum_oracle.py').read_bytes()).hexdigest(),
  scope='Actual full-top accepted PCM captures, real ROM/FFT, independent fixed-point band reference; nominal startup/WAV case only')
 (out/'fft_scoreboard.json').write_text(json.dumps(report,indent=2))
 return report
