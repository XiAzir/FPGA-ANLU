#!/usr/bin/env python3
"""Select two measured 1024-sample windows from the supplied real WAV and gold them."""
from __future__ import annotations
import hashlib,json,math,struct,wave
from pathlib import Path
import spectrum_oracle as oracle

WAV=Path(__file__).resolve().parents[3] / 'deliverables' / 'real_music_20261008' / 'card' / 'TEST.WAV'
OUT=Path(__file__).with_name('vectors')

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    with wave.open(str(WAV),'rb') as f:
        channels,rate,width,count=f.getnchannels(),f.getframerate(),f.getsampwidth(),f.getnframes()
        assert (channels,rate,width)==(1,48000,2),(channels,rate,width)
        raw=f.readframes(count)
    samples=list(struct.unpack(f'<{count}h',raw))
    candidates=[]
    for start in range(0,len(samples)-oracle.N+1,oracle.N):
        block=samples[start:start+oracle.N]
        rms=math.sqrt(sum(int(v)*int(v) for v in block)/oracle.N)
        if rms>=200:candidates.append((rms,start,block))
    assert len(candidates)>10,'not enough non-silent source windows'
    candidates.sort(key=lambda r:r[0])
    selected=[]
    for quantile,name in [(0.25,'music_moderate'),(0.90,'music_loud')]:
        row=candidates[round((len(candidates)-1)*quantile)]
        if row[1] in {x[1] for x in selected}:
            row=next(r for r in candidates if r[1] not in {x[1] for x in selected})
        selected.append(row)
    OUT.mkdir(parents=True,exist_ok=True)
    with (OUT/'real_music_samples.mem').open('w',encoding='ascii',newline='\n') as f:
        for _,_,block in selected:
            f.writelines(f'{v&0xffff:04x}\n' for v in block)
    result=[];max_dft_error=0.0
    for i,(rms,start,block) in enumerate(selected):
        fixed=oracle.band_proxy(oracle.fixed_fft(block));floats=oracle.band_float(oracle.direct_dft(block))
        err=max(abs(fixed[j]-floats[j]) for j in range(24));max_dft_error=max(max_dft_error,err)
        assert err<=16.0,(i,err)
        result.append({'id':i,'name':['music_moderate','music_loud'][i],'start_sample':start,
          'start_seconds':start/rate,'rms':round(rms,3),'peak':max(abs(v) for v in block),
          'fixed_bands':fixed,'direct_dft_max_abs_error':round(err,3),
          'largest_band':max(range(24),key=lambda b:fixed[b]),'nonzero_bands':sum(v>16 for v in fixed)})
    with (OUT/'real_music_expected.mem').open('w',encoding='ascii',newline='\n') as f:
        for item in result:f.writelines(f'{v:04x}\n' for v in item['fixed_bands'])
    report={'source_path':str(WAV),'source_sha256':sha(WAV),'source_bytes':len(raw),
      'sample_rate_hz':rate,'channels':channels,'sample_width_bits':width*8,'frames':count,
      'window_samples':oracle.N,'selection':'non-overlapping 1024-sample windows with RMS>=200; nearest 25th and 90th percentiles',
      'max_direct_dft_quantization_error':round(max_dft_error,3),'direct_dft_bound':16,'windows':result}
    (OUT/'real_music_windows.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
    print(json.dumps(report,indent=2))
if __name__=='__main__':main()
