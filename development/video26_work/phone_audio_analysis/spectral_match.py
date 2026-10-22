from pathlib import Path
import json
import wave
import numpy as np

HERE = Path(__file__).resolve().parent
FS, HOP, WIN = 12000, 240, 512
DT = HOP / FS


def features(name):
    with wave.open(str(HERE / f'{name}_12k.wav')) as f:
        assert f.getframerate() == FS and f.getnchannels() == 1 and f.getsampwidth() == 2
        x = np.frombuffer(f.readframes(f.getnframes()), '<i2').astype(float)
    x = np.pad(x, (WIN // 2, WIN // 2), mode='reflect')
    frames = np.lib.stride_tricks.sliding_window_view(x, WIN)[::HOP]
    power = abs(np.fft.rfft(frames * np.hanning(WIN), axis=1)) ** 2
    freq = np.fft.rfftfreq(WIN, 1 / FS)
    edges = np.geomspace(150, 5500, 25)
    bands = np.stack([np.log1p(power[:, (freq >= a) & (freq < b)].mean(axis=1))
                      for a, b in zip(edges[:-1], edges[1:])], axis=1)
    bands = bands - np.mean(bands, axis=0)
    bands /= np.maximum(np.std(bands, axis=0), 1e-12)
    return bands


def match(phone, gold):
    # Acoustic gain/phase variation is absorbed by per-band normalization.
    # This is a content-alignment search; the fitted rate needs an unambiguous peak.
    phone = phone[13:-13]
    original_t = np.arange(len(phone)) * DT
    extended = np.concatenate([gold, gold], axis=0)
    energies = np.r_[0.0, np.cumsum((extended ** 2).sum(axis=1))]
    best = []
    for rate in np.arange(0.90, 1.1001, 0.002):
        new_t = np.arange(0, original_t[-1], DT / rate)
        template = np.stack([np.interp(new_t, original_t, phone[:, j])
                             for j in range(phone.shape[1])], axis=1)
        template -= np.mean(template, axis=0)
        n, size = len(template), 1 << (len(extended) + len(template) - 1).bit_length()
        conv = np.fft.irfft(np.sum(np.fft.rfft(extended, n=size, axis=0) *
                                  np.fft.rfft(template[::-1], n=size, axis=0), axis=1), n=size)
        corr = conv[n - 1:n - 1 + len(gold)]
        norm = np.sqrt((template ** 2).sum() * (energies[n:n + len(gold)] - energies[:len(gold)]))
        score = corr / np.maximum(norm, 1e-12)
        i = int(np.argmax(score))
        far = np.abs(np.arange(len(gold)) - i) > 25
        best.append({'score': float(score[i]), 'gold_offset_s': i * DT,
                     'rate': float(rate), 'other_phase_peak': float(np.max(score[far]))})
    return sorted(best, key=lambda row: row['score'], reverse=True)[:5]


gold = features('gold')[:1000]
out = {'method': '24 log-energy bands 150..5500Hz, 20ms hop; normalized spectral content; rate search0.90..1.10',
       'qualification': 'Phone capture, AGC, room response and ambient sound remain; no raw FPGA PCM comparison'}
for name in ['photo', 'video']:
    phone = features(name)
    out[name] = {'candidates': match(phone, gold),
                 'time_reversed_reference_negative': match(phone, gold[::-1])[:1]}
(HERE / 'spectral_match.json').write_text(json.dumps(out, indent=2) + '\n', encoding='utf-8')
print(json.dumps(out, indent=2))
