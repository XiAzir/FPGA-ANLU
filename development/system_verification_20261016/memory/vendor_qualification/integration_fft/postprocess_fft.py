#!/usr/bin/env python3
"""Post-process passive full-top FFT input/output CSVs with the C11310 oracle."""
from __future__ import annotations
import argparse, csv, hashlib, importlib.util, json, math, struct, sys
from collections import defaultdict
from pathlib import Path

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[4]
DEFAULT_ORACLE=ROOT/'development/player_spectrum_fft_recover/checkpoints/music_spectrum_fft_recover_20261014_candidate/sim/spectrum_oracle.py'
DEFAULT_SOURCE=ROOT/'development/system_verification_20261016/card/wave_samples.mem'
SAMPLE_FIELDS={'frame','sample_index','pcm_signed','time_ns'}
BAND_FIELDS={'frame','band_index','band_value','frame_done','time_ns'}

def sha(path:Path)->str:
    return hashlib.sha256(path.read_bytes()).hexdigest()

def load_oracle(path:Path):
    if not path.is_file(): raise ValueError(f'missing independent FFT oracle: {path}')
    spec=importlib.util.spec_from_file_location('c11310_spectrum_oracle',path)
    if spec is None or spec.loader is None: raise ValueError(f'cannot load oracle: {path}')
    mod=importlib.util.module_from_spec(spec); spec.loader.exec_module(mod)
    for name in ('N','fixed_fft','band_proxy','direct_dft','band_float'):
        if not hasattr(mod,name): raise ValueError(f'oracle lacks required function/constant {name}')
    if mod.N!=1024: raise ValueError(f'oracle N must be 1024, got {mod.N}')
    return mod

def load_source_samples(path:Path):
    if not path.is_file(): raise ValueError(f'missing source PCM fixture: {path}')
    tokens=path.read_text(encoding='ascii').split()
    if not tokens: raise ValueError('source PCM fixture is empty')
    raw=bytearray()
    for i,t in enumerate(tokens):
        if len(t)!=2:
            raise ValueError(f'source PCM byte {i} must be two hex digits, got {t!r}')
        try: b=int(t,16)
        except ValueError as e: raise ValueError(f'unknown/invalid source PCM byte at index {i}: {t!r}') from e
        if not 0<=b<=255: raise ValueError(f'source PCM byte out of range at index {i}')
        raw.append(b)
    if len(raw)%2: raise ValueError(f'PCM byte count must be even, got {len(raw)}')
    samples=list(struct.unpack('<%dh'%(len(raw)//2),raw))
    if len(samples)<1024: raise ValueError(f'source fixture has fewer than 1024 samples: {len(samples)}')
    return samples,bytes(raw)

def _read_csv(path:Path,required:set[str]):
    if not path.is_file(): raise ValueError(f'missing observation CSV: {path}')
    if path.stat().st_size==0: raise ValueError(f'observation CSV is empty: {path}')
    with path.open(newline='',encoding='utf-8-sig') as f:
        reader=csv.DictReader(f)
        if reader.fieldnames is None or not required.issubset(set(reader.fieldnames)):
            raise ValueError(f'{path.name} missing columns {sorted(required-set(reader.fieldnames or []))}')
        rows=[]
        for line,row in enumerate(reader,2):
            if None in row or any(row.get(k) is None or row[k].strip()=='' for k in required):
                raise ValueError(f'{path.name}:{line}: incomplete row')
            rows.append(row)
    if not rows: raise ValueError(f'observation CSV has zero records: {path}')
    return rows

def _integer(row,key,path,line,lo=None,hi=None):
    value=row.get(key,'').strip()
    try: result=int(value,10)
    except (ValueError,TypeError) as e: raise ValueError(f'{path.name}:{line}: invalid/unknown {key}={value!r}') from e
    if lo is not None and result<lo or hi is not None and result>hi:
        raise ValueError(f'{path.name}:{line}: {key}={result} outside [{lo},{hi}]')
    return result

def postprocess_fft(samples_csv:Path,bands_csv:Path,source_mem:Path=DEFAULT_SOURCE,
                    oracle_path:Path=DEFAULT_ORACLE,report_path:Path|None=None,
                    expected_frames:int|None=None)->dict:
    samples_csv=Path(samples_csv); bands_csv=Path(bands_csv)
    source_mem=Path(source_mem); oracle_path=Path(oracle_path)
    oracle=load_oracle(oracle_path)
    rom_check=oracle.check_roms() if hasattr(oracle,'check_roms') else None
    source_samples,source_raw=load_source_samples(source_mem)
    sample_rows=_read_csv(samples_csv,SAMPLE_FIELDS)
    band_rows=_read_csv(bands_csv,BAND_FIELDS)
    frames=defaultdict(list)
    for line,row in enumerate(sample_rows,2):
        fid=_integer(row,'frame',samples_csv,line,0)
        idx=_integer(row,'sample_index',samples_csv,line,0,1023)
        pcm=_integer(row,'pcm_signed',samples_csv,line,-32768,32767)
        frames[fid].append((idx,pcm))
        try: float(row['time_ns'])
        except ValueError as e: raise ValueError(f'{samples_csv.name}:{line}: invalid time_ns') from e
    if not frames: raise ValueError('zero complete FFT input frames observed')
    frame_ids=sorted(frames)
    if frame_ids!=list(range(len(frame_ids))): raise ValueError(f'frame ids must be contiguous from 0, got {frame_ids[:12]}')
    if expected_frames is not None and len(frame_ids)!=expected_frames:
        raise ValueError(f'expected {expected_frames} sample frames, observed {len(frame_ids)}')
    input_frames=[]
    for fid in frame_ids:
        rows=frames[fid]
        rows.sort()
        if len(rows)!=1024: raise ValueError(f'frame {fid} must contain 1024 accepted samples, got {len(rows)}')
        if [i for i,_ in rows]!=list(range(1024)): raise ValueError(f'frame {fid} has missing/duplicate/out-of-order sample indices')
        block=[v for _,v in rows]
        base=(fid*1024)%len(source_samples)
        expected_source=[source_samples[(base+i)%len(source_samples)] for i in range(1024)]
        if block!=expected_source:
            mismatch=next(i for i,(a,b) in enumerate(zip(block,expected_source)) if a!=b)
            raise ValueError(f'frame {fid} accepted PCM differs from WAV test window at sample {mismatch}: got={block[mismatch]} source={expected_source[mismatch]}')
        input_frames.append(block)

    bands=defaultdict(list)
    for line,row in enumerate(band_rows,2):
        fid=_integer(row,'frame',bands_csv,line,0)
        idx=_integer(row,'band_index',bands_csv,line,0,23)
        value=_integer(row,'band_value',bands_csv,line,0,65535)
        done=_integer(row,'frame_done',bands_csv,line,0,1)
        try: float(row['time_ns'])
        except ValueError as e: raise ValueError(f'{bands_csv.name}:{line}: invalid time_ns') from e
        bands[fid].append((idx,value,done))
    if sorted(bands)!=frame_ids: raise ValueError(f'band frame IDs {sorted(bands)} do not match sampled frames {frame_ids}')

    reports=[];errors=[]
    for fid,block in zip(frame_ids,input_frames):
        observed=bands[fid]
        if len(observed)!=24:
            raise ValueError(f'frame {fid} must emit exactly 24 bands, got {len(observed)}')
        observed.sort(key=lambda x:x[0])
        if [r[0] for r in observed]!=list(range(24)):
            raise ValueError(f'frame {fid} band indices are not exactly ordered 0..23')
        if [r[2] for r in observed]!=[0]*23+[1]:
            raise ValueError(f'frame {fid} frame_done must be high only on band 23')
        expected=oracle.band_proxy(oracle.fixed_fft(block))
        actual=[r[1] for r in observed]
        dft=oracle.band_float(oracle.direct_dft(block))
        dft_error=max(abs(expected[i]-dft[i]) for i in range(24))
        if dft_error>16.0: errors.append({'frame':fid,'issue':'fixed oracle vs direct DFT bound','max_abs_error':dft_error})
        mismatch=[{'band':i,'actual':actual[i],'expected':expected[i],'abs_error':abs(actual[i]-expected[i])}
                  for i in range(24) if actual[i]!=expected[i]]
        if mismatch: errors.append({'frame':fid,'issue':'band mismatch','mismatches':mismatch})
        reports.append({'frame':fid,'sample_count':len(block),'band_count':len(actual),
            'exact_match':not mismatch,'max_abs_error':max((m['abs_error'] for m in mismatch),default=0),
            'actual_bands':actual,'expected_bands':expected,'direct_dft_max_abs_error':dft_error})
    if errors: raise ValueError(json.dumps({'errors':errors,'frames':reports},ensure_ascii=False))
    result={
      'status':'PASS','frames_checked':len(reports),'first_frame_checked':reports[0]['frame'],
      'multi_frame_checked':len(reports)>1,'accepted_samples':sum(len(b) for b in input_frames),
      'emitted_bands':sum(len(bands[f]) for f in frame_ids),'all_24_bands_exact':True,
      'source_pcm_samples':len(source_samples),'source_pcm_sha256':hashlib.sha256(source_raw).hexdigest(),
      'sample_csv_sha256':sha(samples_csv),'bands_csv_sha256':sha(bands_csv),'oracle_path':str(oracle_path),
      'oracle_sha256':sha(oracle_path),'oracle_rom_check':rom_check,'frames':reports}
    if report_path is not None:
        Path(report_path).write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
    return result

def main(argv=None):
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--samples',type=Path,default=Path('fft_samples.csv'))
    p.add_argument('--bands',type=Path,default=Path('fft_bands.csv'))
    p.add_argument('--source',type=Path,default=DEFAULT_SOURCE)
    p.add_argument('--oracle',type=Path,default=DEFAULT_ORACLE)
    p.add_argument('--report',type=Path,default=Path('fft_postprocess.json'))
    p.add_argument('--expected-frames',type=int)
    args=p.parse_args(argv)
    try:
        report=postprocess_fft(args.samples,args.bands,args.source,args.oracle,args.report,args.expected_frames)
    except Exception as e:
        print(json.dumps({'status':'FAIL','error':str(e)},ensure_ascii=False),file=sys.stderr)
        return 1
    print(json.dumps({k:v for k,v in report.items() if k!='frames'},ensure_ascii=False,indent=2))
    return 0

if __name__=='__main__': raise SystemExit(main())
