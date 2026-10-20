#!/usr/bin/env python3
"""Small checker-only fixture and negative controls; no RTL simulation."""
from __future__ import annotations
import csv
from pathlib import Path
from postprocess_fft import DEFAULT_ORACLE, DEFAULT_SOURCE, load_oracle, load_source_samples, postprocess_fft

def main():
    oracle=load_oracle(DEFAULT_ORACLE)
    source,_=load_source_samples(DEFAULT_SOURCE)
    root=Path(__file__).resolve().parent
    samples_path=root/'_selftest_samples.csv'
    bands_path=root/'_selftest_bands.csv'
    def make(frames=2,unknown_sample=False,corrupt_band=False):
        with samples_path.open('w',newline='',encoding='ascii') as f:
            w=csv.writer(f); w.writerow(['frame','sample_index','pcm_signed','time_ns'])
            for fid in range(frames):
                base=(fid*1024)%len(source)
                block=[source[(base+i)%len(source)] for i in range(1024)]
                for i,v in enumerate(block):
                    val='x' if unknown_sample and fid==0 and i==17 else v
                    w.writerow([fid,i,val,i*20])
        with bands_path.open('w',newline='',encoding='ascii') as f:
            w=csv.writer(f); w.writerow(['frame','band_index','band_value','frame_done','time_ns'])
            for fid in range(frames):
                base=(fid*1024)%len(source)
                block=[source[(base+i)%len(source)] for i in range(1024)]
                vals=oracle.band_proxy(oracle.fixed_fft(block))
                for i,v in enumerate(vals):
                    w.writerow([fid,i,v+(1 if corrupt_band and fid==0 and i==7 else 0),int(i==23),i*20])
    def must_fail(label,fn):
        try: fn()
        except (ValueError,FileNotFoundError): return
        raise AssertionError(f'negative did not fail: {label}')
    make()
    result=postprocess_fft(samples_path,bands_path,DEFAULT_SOURCE,DEFAULT_ORACLE,expected_frames=2)
    assert result['status']=='PASS' and result['frames_checked']==2 and result['multi_frame_checked']
    empty=root/'_selftest_empty_samples.csv'
    empty.write_text('frame,sample_index,pcm_signed,time_ns\n',encoding='ascii')
    must_fail('zero frames',lambda:postprocess_fft(empty,bands_path,DEFAULT_SOURCE,DEFAULT_ORACLE))
    make(unknown_sample=True)
    must_fail('unknown PCM',lambda:postprocess_fft(samples_path,bands_path,DEFAULT_SOURCE,DEFAULT_ORACLE))
    make(corrupt_band=True)
    must_fail('wrong band',lambda:postprocess_fft(samples_path,bands_path,DEFAULT_SOURCE,DEFAULT_ORACLE))
    make()
    must_fail('missing samples file',lambda:postprocess_fft(root/'_selftest_missing.csv',bands_path,DEFAULT_SOURCE,DEFAULT_ORACLE))
    must_fail('wrong frame count',lambda:postprocess_fft(samples_path,bands_path,DEFAULT_SOURCE,DEFAULT_ORACLE,expected_frames=3))
    print('PASS fft_postprocess fixture_frames=2 negatives=5 (zero frames, unknown PCM, wrong band, missing input, frame-count mismatch)')

if __name__=='__main__': main()
