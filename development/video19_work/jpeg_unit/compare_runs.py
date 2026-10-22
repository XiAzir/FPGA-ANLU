from __future__ import annotations

import argparse
import json
import math
import struct
from pathlib import Path

RECORD = struct.Struct("<HHBBB")


def read_pixels(path: Path) -> dict[int, tuple[int, int, int]]:
    blob = path.read_bytes()
    if len(blob) % RECORD.size:
        raise ValueError(f"{path}: invalid pixel record length {len(blob)}")
    pixels = {}
    for x, y, r, g, b in RECORD.iter_unpack(blob):
        key = y * 640 + x
        if key in pixels:
            raise ValueError(f"{path}: duplicate coordinate ({x},{y})")
        pixels[key] = (r, g, b)
    return pixels


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("baseline", type=Path)
    parser.add_argument("candidate", type=Path)
    args = parser.parse_args()
    baseline = read_pixels(args.baseline)
    candidate = read_pixels(args.candidate)
    if baseline.keys() != candidate.keys():
        raise SystemExit(f"coordinate sets differ: baseline={len(baseline)} candidate={len(candidate)}")
    sum_sq = 0
    sum_abs = 0
    max_abs = 0
    exact_pixels = 0
    values = len(baseline) * 3
    for key, ref in baseline.items():
        got = candidate[key]
        deltas = [abs(a - b) for a, b in zip(ref, got)]
        if not any(deltas):
            exact_pixels += 1
        sum_sq += sum(d * d for d in deltas)
        sum_abs += sum(deltas)
        max_abs = max(max_abs, *deltas)
    mse = sum_sq / values
    psnr = 999.0 if mse == 0 else 10.0 * math.log10(255.0 * 255.0 / mse)
    print(json.dumps({
        "baseline": str(args.baseline), "candidate": str(args.candidate),
        "coordinates": len(baseline), "rgb_mse": mse, "rgb_psnr_db": psnr,
        "max_abs_error": max_abs, "mean_abs_error": sum_abs / values,
        "exact_pixel_fraction": exact_pixels / len(baseline),
    }, indent=2))


if __name__ == "__main__":
    main()
