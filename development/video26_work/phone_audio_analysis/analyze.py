from __future__ import annotations
import hashlib, json, math, wave
from pathlib import Path
import numpy as np

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
FS = 12000
WINDOW_SEC = 0.75
HOP_SEC = 1.0
RATE_GRID = np.arange(0.996, 1.004001, 0.0005)

INPUTS = {
    "photo": ROOT / "development/video23_work/board_20261022/photo/audio.wav",
    "video": ROOT / "development/video23_work/board_20261022/video/audio.wav",
    "gold": ROOT / "development/video19_work/media_q90_trial/output/TEST.WAV",
}
RESAMPLED = {k: HERE / f"{k}_12k.wav" for k in INPUTS}


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def read_wav(path: Path):
    with wave.open(str(path), "rb") as f:
        channels, rate, width, count = f.getnchannels(), f.getframerate(), f.getsampwidth(), f.getnframes()
        data = f.readframes(count)
    if width != 2:
        raise ValueError(f"Expected 16-bit PCM: {path}")
    x = np.frombuffer(data, dtype="<i2").astype(np.float64) / 32768.0
    x = x.reshape(-1, channels)
    return rate, x


def next_pow2(n: int) -> int:
    return 1 << (n - 1).bit_length()


def bp_filter(x: np.ndarray, fs: int, low=100.0, high=5500.0) -> np.ndarray:
    """Zero-phase FFT band-limit for correlation features, not playback restoration."""
    x = np.asarray(x, dtype=np.float64)
    X = np.fft.rfft(x)
    freq = np.fft.rfftfreq(len(x), 1.0 / fs)
    X[(freq < low) | (freq > high)] = 0
    y = np.fft.irfft(X, n=len(x))
    y -= np.mean(y)
    sd = np.std(y)
    return y / sd if sd > 1e-12 else y


def corr_lag(template: np.ndarray, ref: np.ndarray, fs: int):
    """Absolute peak normalized correlation over circular 20-s reference offsets."""
    template = np.asarray(template, dtype=np.float64)
    ref = np.asarray(ref, dtype=np.float64)
    template = template - np.mean(template)
    energy_t = float(np.dot(template, template))
    nref = len(ref)
    m = len(template)
    if m >= nref or energy_t < 1e-14:
        return 0.0, 0, 0.0
    # Repeat prefix so every circular start has a full linear comparison window.
    ref2 = np.concatenate((ref, ref[:m - 1]))
    nfft = next_pow2(len(ref2) + m - 1)
    conv = np.fft.irfft(np.fft.rfft(ref2, nfft) * np.fft.rfft(template[::-1], nfft), nfft)
    dots = conv[m - 1:m - 1 + nref]
    sq = np.concatenate(([0.0], np.cumsum(ref2 * ref2)))
    sums = np.concatenate(([0.0], np.cumsum(ref2)))
    e = sq[m:m + nref] - sq[:nref] - (sums[m:m + nref] - sums[:nref]) ** 2 / m
    denom = np.sqrt(np.maximum(e, 1e-24) * energy_t)
    scores = dots / denom
    abs_scores = np.abs(scores)
    peak_idx = int(np.argmax(abs_scores))
    peak = float(scores[peak_idx])
    # Competing peak outside a generous local neighborhood helps flag periodic ambiguity.
    mask = np.ones(nref, dtype=bool)
    radius = int(0.18 * fs)
    for delta in range(-radius, radius + 1):
        mask[(peak_idx + delta) % nref] = False
    second = float(np.max(abs_scores[mask])) if np.any(mask) else 0.0
    return peak, peak_idx, second


def resample_template(x: np.ndarray, rate: float) -> np.ndarray:
    n = max(2, int(round(len(x) * rate)))
    old = np.arange(len(x), dtype=np.float64)
    new = np.linspace(0.0, len(x) - 1.0, n)
    return np.interp(new, old, x)


def match_clip(x: np.ndarray, ref: np.ndarray):
    win = int(WINDOW_SEC * FS)
    hop = int(HOP_SEC * FS)
    starts = np.arange(int(0.5 * FS), max(int(0.5 * FS) + 1, len(x) - win + 1), hop)
    starts = starts[starts + win <= len(x)]
    xbp = bp_filter(x, FS)
    gbp = bp_filter(ref, FS)
    rows = []
    for start in starts:
        seg = xbp[start:start + win]
        rates = []
        for rate in RATE_GRID:
            tpl = resample_template(seg, float(rate))
            score, lag, second = corr_lag(tpl, gbp, FS)
            rates.append((abs(score), score, lag, second, float(rate)))
        rates.sort(key=lambda z: z[0], reverse=True)
        best = rates[0]
        rows.append({
            "phone_t_s": float(start / FS),
            "gold_offset_s": float(best[2] / FS),
            "score": float(best[1]),
            "competing_peak": float(best[3]),
            "local_rate": float(best[4]),
            "rate_score_margin": float(best[0] - rates[1][0]),
        })
    # Unwrap offsets over a cyclic reference before fitting constant drift.
    offsets = np.array([r["gold_offset_s"] for r in rows], dtype=np.float64)
    unwrapped = np.unwrap(offsets * (2 * np.pi / 20.0)) * (20.0 / (2 * np.pi))
    times = np.array([r["phone_t_s"] for r in rows], dtype=np.float64)
    weights = np.maximum(np.array([abs(r["score"]) for r in rows]), 1e-4) ** 2
    coef = np.polyfit(times, unwrapped, 1, w=weights)
    pred = np.polyval(coef, times)
    residual = unwrapped - pred
    ss_res = float(np.sum(weights * residual**2))
    mean = float(np.average(unwrapped, weights=weights))
    ss_tot = float(np.sum(weights * (unwrapped - mean)**2))
    r2 = 1.0 - ss_res / ss_tot if ss_tot > 1e-15 else 0.0
    return {
        "windows": rows,
        "fit": {
            "gold_seconds_per_phone_second": float(coef[0]),
            "drift_ppm": float((coef[0] - 1.0) * 1e6),
            "gold_start_offset_s_mod_20": float(coef[1] % 20.0),
            "weighted_residual_rms_s": float(math.sqrt(ss_res / max(np.sum(weights), 1e-12))),
            "weighted_r2": float(r2),
            "median_abs_corr": float(np.median([abs(r["score"]) for r in rows])) if rows else 0.0,
            "median_peak_gap": float(np.median([abs(r["score"]) - r["competing_peak"] for r in rows])) if rows else 0.0,
        }
    }


def welch_peaks(x: np.ndarray, fs: int, nsec=1.0):
    n = int(nsec * fs)
    if len(x) < n:
        n = len(x)
    hop = n // 2
    window = np.hanning(n)
    spectra = []
    for start in range(0, len(x) - n + 1, hop):
        s = x[start:start+n]
        s = s - np.mean(s)
        p = np.abs(np.fft.rfft(s * window)) ** 2 / (np.sum(window**2) * fs)
        spectra.append(p)
    avg = np.mean(spectra, axis=0)
    f = np.fft.rfftfreq(n, 1 / fs)
    peak_rows = []
    for lo, hi, label in [(45, 65, "mains50"), (90, 110, "mains100"), (55, 65, "mains60"), (110, 130, "mains120")]:
        ids = np.where((f >= lo) & (f <= hi))[0]
        idx = int(ids[np.argmax(avg[ids])])
        neighborhood = np.where((f >= max(20, f[idx]-8)) & (f <= f[idx]+8))[0]
        neighborhood = neighborhood[np.abs(f[neighborhood] - f[idx]) > 2]
        floor = float(np.median(avg[neighborhood])) if len(neighborhood) else 1e-20
        peak_rows.append({"band": label, "peak_hz": float(f[idx]), "db_above_local_median": float(10*np.log10((avg[idx]+1e-30)/(floor+1e-30)))})
    strongest = np.argsort(avg[(f >= 30) & (f <= 1000)])[-10:]
    band_ids = np.where((f >= 30) & (f <= 1000))[0]
    top = [{"hz": float(f[band_ids[i]]), "power": float(avg[band_ids[i]])} for i in strongest[::-1]]
    return {"n_segments": len(spectra), "candidate_lines": peak_rows, "top_30_1000_hz_bins": top[:10]}


def stereo_stats(path: Path):
    rate, xx = read_wav(path)
    if xx.shape[1] == 1:
        return {"channels": 1, "fs": rate, "rms": [float(np.sqrt(np.mean(xx[:,0]**2)))], "lr_corr": None}
    l, r = xx[:,0], xx[:,1]
    return {
        "channels": 2,
        "fs": rate,
        "rms": [float(np.sqrt(np.mean(l*l))), float(np.sqrt(np.mean(r*r)))],
        "lr_corr": float(np.corrcoef(l, r)[0,1]),
        "mono_lr_rms": float(np.sqrt(np.mean(((l+r)/2)**2))),
        "side_lr_rms": float(np.sqrt(np.mean(((l-r)/2)**2))),
    }


def main():
    loaded = {}
    inputs = {}
    for key, p in INPUTS.items():
        inputs[key] = {"path": str(p), "sha256": sha256(p), "bytes": p.stat().st_size}
    for key, p in RESAMPLED.items():
        rate, data = read_wav(p)
        if rate != FS or data.shape[1] != 1:
            raise ValueError(f"Expected {FS}Hz mono derivative: {p}")
        loaded[key] = data[:,0]
        inputs[key + "_12k_derivative"] = {"path": str(p), "sha256": sha256(p), "bytes": p.stat().st_size}
    ref = loaded["gold"]
    output = {
        "method": "12kHz mono, 0.75s windows at 1s intervals; FFT bandpass 100-5500Hz; cyclic normalized cross-correlation over the 20s reference; local rate grid 0.996..1.004; drift fit from best offsets",
        "inputs": inputs,
        "source_stereo": {k: stereo_stats(v) for k,v in INPUTS.items() if k in ("photo","video")},
        "duration_s": {k: float(len(v)/FS) for k,v in loaded.items()},
        "match": {k: match_clip(loaded[k], ref) for k in ("photo","video")},
        "spectral": {k: welch_peaks(loaded[k], FS) for k in ("photo","video","gold")},
    }
    (HERE / "analysis.json").write_text(json.dumps(output, indent=2), encoding="utf-8")
    print(json.dumps({k: v["fit"] for k,v in output["match"].items()}, indent=2))
    print(json.dumps({k: v["candidate_lines"] for k,v in output["spectral"].items()}, indent=2))

if __name__ == "__main__":
    main()
