#!/usr/bin/env python3
"""Independent mathematical and fixed-point oracle for player_spectrum_analyzer.

The direct DFT is the mathematical reference. The integer radix-2 model follows
only the published arithmetic contract and is intentionally separate from RTL.
"""
from __future__ import annotations
import argparse, cmath, hashlib, json, math, random
from pathlib import Path

N = 1024
BINS = N // 2 + 1
EDGES = [1,2,3,4,5,6,7,9,11,14,18,23,29,37,47,60,76,97,124,158,201,256,326,415,513]
CASES = [("tone_low", 5, 8192), ("tone_mid", 48, 8192), ("tone_high", 400, 8192),
         ("tone_low_half", 5, 4096), ("two_tone", (48, 300), 7000),
         ("silence", None, 0), ("dc_positive", 12000, "dc"),
         ("fullscale_positive", 32767, "dc"), ("fullscale_negative", -32768, "dc"),
         ("fullscale_sine", 160, "full"), ("nyquist_alternating", None, None),
         ("impulse", None, None), ("wideband_random", None, None)]
def hann_q15(n: int) -> int:
    x = 0.5 - 0.5 * math.cos(2.0 * math.pi * n / (N - 1))
    return min(32767, max(0, int(round(x * 32767.0))))

WINDOW = [hann_q15(n) for n in range(N)]

def sat16(x: int) -> int:
    return min(32767, max(-32768, x))

def inputs(name: str, tone, amp) -> list[int]:
    if name == "silence": return [0] * N
    if amp == "dc": return [int(tone)] * N
    if amp == "full": return [sat16(round(32767*math.sin(2*math.pi*tone*n/N+math.pi/4))) for n in range(N)]
    if name == "nyquist_alternating": return [32767 if n%2==0 else -32768 for n in range(N)]
    if name == "impulse": return [32767 if n==N//2 else 0 for n in range(N)]
    if name == "wideband_random":
        rng=random.Random(0xA11CE1024)
        return [rng.randint(-32768,32767) for _ in range(N)]
    freqs = tone if isinstance(tone, tuple) else (tone,)
    scale = int(amp / len(freqs))
    return [sat16(round(sum(scale * math.sin(2*math.pi*k*n/N) for k in freqs))) for n in range(N)]
def windowed(samples: list[int]) -> list[int]:
    # The stated datapath truncates signed products with arithmetic >> 15.
    return [sat16((int(x) * w) >> 15) for x, w in zip(samples, WINDOW)]

def twiddle_q15(k: int) -> tuple[int,int]:
    angle = -2.0 * math.pi * k / N
    return (sat16(round(math.cos(angle) * 32767.0)), sat16(round(math.sin(angle) * 32767.0)))

def fixed_fft(samples: list[int]) -> list[tuple[int,int]]:
    """Scaled Q15 radix-2 DIT FFT, bit-reversed input, 16-bit stage storage."""
    a = windowed(samples)
    re = [0]*N; im = [0]*N
    for i, x in enumerate(a):
        j = int(f"{i:010b}"[::-1], 2)
        re[j] = x
    span = 2
    while span <= N:
        half = span//2
        for base in range(0,N,span):
            for j in range(half):
                wr, wi = twiddle_q15(j * N // span)
                i0 = base+j; i1=i0+half
                tr = (re[i1]*wr - im[i1]*wi) >> 15
                ti = (re[i1]*wi + im[i1]*wr) >> 15
                ar, ai = re[i0], im[i0]
                re[i0] = sat16((ar+tr) >> 1); im[i0] = sat16((ai+ti) >> 1)
                re[i1] = sat16((ar-tr) >> 1); im[i1] = sat16((ai-ti) >> 1)
        span *= 2
    return list(zip(re[:BINS], im[:BINS]))

def direct_dft(samples: list[int]) -> list[complex]:
    # Real-input bins 0..512; no external FFT package or RTL-derived code.
    x = [samples[n] * (WINDOW[n] / 32767.0) for n in range(N)]
    return [sum(x[n] * cmath.exp(-2j*math.pi*k*n/N) for n in range(N)) / N for k in range(BINS)]

def band_proxy(spectrum) -> list[int]:
    return [max((max(abs(int(spectrum[k][0])), abs(int(spectrum[k][1]))) for k in range(EDGES[b],EDGES[b+1])), default=0) for b in range(24)]

def band_float(spectrum) -> list[float]:
    return [max((max(abs(spectrum[k].real), abs(spectrum[k].imag)) for k in range(EDGES[b],EDGES[b+1])), default=0.0) for b in range(24)]

def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()

def check_roms() -> dict:
    hdl = Path(__file__).resolve().parents[1] / 'src' / 'user_source' / 'hdl_source'
    hann_file = hdl / 'spectrum_hann.mem'
    twiddle_file = hdl / 'spectrum_twiddle.mem'
    hann_words = [int(line, 16) for line in hann_file.read_text(encoding='ascii').split()]
    twiddle_words = [int(line, 16) for line in twiddle_file.read_text(encoding='ascii').split()]
    expected_twiddle = [((twiddle_q15(k)[0] & 0xffff) << 16) | (twiddle_q15(k)[1] & 0xffff) for k in range(N // 2)]
    assert len(hann_words) == N and hann_words == WINDOW, 'Hann ROM disagrees with independent formula'
    assert len(twiddle_words) == N//2 and twiddle_words == expected_twiddle, 'twiddle ROM disagrees with independent formula'
    return {'hann_words':len(hann_words),'twiddle_words':len(twiddle_words),'hann_sha256':sha(hann_file),'twiddle_sha256':sha(twiddle_file)}
def main():
    rom_check=check_roms()
    p=argparse.ArgumentParser(); p.add_argument('--vectors', type=Path, default=Path(__file__).with_name('vectors')); p.add_argument('--emit', action='store_true'); args=p.parse_args()
    args.vectors.mkdir(parents=True,exist_ok=True)
    result=[]
    for name,tone,amp in CASES:
        samples=inputs(name,tone,amp)
        fixed=band_proxy(fixed_fft(samples)); floating=band_float(direct_dft(samples))
        # A tone's band is determined by the contract's half-open bin edges.
        expected_band = None
        if (name.startswith('tone_') or name=='fullscale_sine') and isinstance(tone,int):
            expected_band = next(b for b in range(24) if EDGES[b] <= tone < EDGES[b+1])
            observed=max(range(24),key=lambda b:fixed[b])
            assert observed==expected_band, (name,expected_band,observed,fixed)
        if name=='silence': assert not any(fixed)
        if name=='dc_positive': assert fixed[0] > 100 * max(fixed[1:]), 'DC bin must be excluded and Hann sidelobes stay bounded'
        if args.emit:
            with (args.vectors/f'{name}.hex').open('w',encoding='ascii',newline='\n') as f:
                f.writelines(f'{x & 0xffff:04x}\n' for x in samples)
        float_error=max(abs(fixed[i]-floating[i]) for i in range(24))
        assert float_error <= 16.0, (name,'direct DFT quantization error',float_error)
        result.append({'name':name,'tone_bins':tone if isinstance(tone,tuple) else ([tone] if isinstance(tone,int) and (name.startswith('tone_') or name=='fullscale_sine') else None),
                       'expected_peak_band':expected_band,'fixed_bands':fixed,
                       'float_bands_rounded':[round(v,3) for v in floating],
                       'max_fixed_float_abs_error':round(float_error,3)})
    if args.emit:
        with (args.vectors/'all_samples.mem').open('w',encoding='ascii',newline='\n') as f:
            for name,tone,amp in CASES:
                f.writelines(f'{x & 0xffff:04x}\n' for x in inputs(name,tone,amp))
        with (args.vectors/'all_expected.mem').open('w',encoding='ascii',newline='\n') as f:
            for item in result: f.writelines(f'{x:04x}\n' for x in item['fixed_bands'])
        (args.vectors/'oracle.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
    by_name={row['name']:row for row in result}
    full=by_name['tone_low']['fixed_bands'][4]; half=by_name['tone_low_half']['fixed_bands'][4]
    assert abs(full-2*half) <= 12, ('amplitude proportionality',full,half)
    assert by_name['two_tone']['fixed_bands'][14] > 500 and by_name['two_tone']['fixed_bands'][21] > 500
    print(json.dumps({'n':N,'fs_hz':48000,'bin_hz':48000/N,'edges':EDGES,'window':'symmetric Hann round(Q1.15), product arithmetic shift 15',
                      'fft':'radix-2 DIT, bit-reversed input, Q1.15 twiddle, each butterfly stage arithmetic shift right 1',
                      'output':'max(abs(re),abs(im)); bands max over half-open bin ranges; exclude DC', 'rom_check':rom_check, 'cases':result},indent=2))
if __name__=='__main__': main()










