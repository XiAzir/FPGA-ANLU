"""Reproduce the 63-frame phase recurrence and byte-linear decode estimate."""
from __future__ import annotations

import csv
import hashlib
import json
import math
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
INDEX = ROOT / "development/video19_work/hdmi_fifo_analysis/stream_loop/runs/stream_loop_20261021_192205_098862/input/index.json"
OUT_CSV = HERE / "phase_budget_analysis.csv"
OUT_JSON = HERE / "phase_budget_analysis.json"
REF_DECODE_MS = 52.48111
REF_BYTES = 43231
SAMPLE_TICKS = 5
SAMPLES_PER_FRAME = 3200
REFRESH_TICKS = 4032
# Phase origin 128 yields the preliminary frame 62/63 windows reported by
# the parent. The real boot/phase is independently exercised by full-system
# AUDIO_PHASE runs and can move this mapping.
START_PHASE_TICKS = 128


def main() -> None:
    blob = INDEX.read_bytes()
    source = json.loads(blob.decode("utf-8-sig"))
    frames = source["frames"]
    if len(frames) != 300:
        raise SystemExit(f"expected 300 indexed frames, found {len(frames)}")
    period = SAMPLE_TICKS * SAMPLES_PER_FRAME
    # The abstract clock represents one frame refresh in 4032 ticks. Therefore
    # one tick equals 16.8ms/4032; use exact proportional conversion here.
    reference_cycles = math.ceil(REF_DECODE_MS / (16.8 * period / REFRESH_TICKS) * period)
    rows = []
    for idx, frame in enumerate(frames[1:], start=1):
        phase = (START_PHASE_TICKS + idx * period) % REFRESH_TICKS
        wait = 0 if phase == 0 else REFRESH_TICKS - phase
        budget = period - wait
        scaled = math.ceil(reference_cycles * frame["jpeg_length_bytes"] / REF_BYTES)
        rows.append({
            "frame_index": idx,
            "jpeg_bytes": frame["jpeg_length_bytes"],
            "due_phase_ticks": phase,
            "wait_to_next_refresh_ticks": wait,
            "available_decode_ticks": budget,
            "available_decode_ms": round(budget * 16.8 / REFRESH_TICKS, 6),
            "byte_scaled_decode_ticks": scaled,
            "byte_scaled_decode_ms": round(scaled * 16.8 / REFRESH_TICKS, 6),
            "margin_ticks_before_cascade": budget - scaled,
            "would_meet_deadline_if_prior_frames_on_time": scaled <= budget,
        })
    with OUT_CSV.open("w", newline="", encoding="utf-8") as out:
        writer = csv.DictWriter(out, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)
    gcd = math.gcd(period, REFRESH_TICKS)
    summary = {
        "schema": "video19-cadence-phase-analysis-v1",
        "classification": "integer phase model + byte-linear decode estimate; not a decoder simulation",
        "source_index": str(INDEX),
        "source_index_sha256": hashlib.sha256(blob).hexdigest(),
        "frame_count": len(frames),
        "samples_per_content_frame": SAMPLES_PER_FRAME,
        "abstract_ticks_per_sample": SAMPLE_TICKS,
        "content_period_ticks": period,
        "refresh_ticks": REFRESH_TICKS,
        "refresh_period_ms": 16.8,
        "phase_origin_ticks": START_PHASE_TICKS,
        "phase_origin_provenance": "selected to reproduce preliminary parent budget frame62≈50.95ms/frame63≈50.42ms; absolute hardware phase is run-dependent",
        "phase_step_ticks": period % REFRESH_TICKS,
        "phase_cycle_frames": REFRESH_TICKS // gcd,
        "max_wait_ticks": max(row["wait_to_next_refresh_ticks"] for row in rows),
        "min_available_decode_ticks": min(row["available_decode_ticks"] for row in rows),
        "min_available_decode_ms": min(row["available_decode_ms"] for row in rows),
        "reference_decode_ms": REF_DECODE_MS,
        "reference_max_jpeg_bytes": REF_BYTES,
        "reference_byte_scaled_decode_ticks": reference_cycles,
        "pre_cascade_estimated_miss_indices": [r["frame_index"] for r in rows if not r["would_meet_deadline_if_prior_frames_on_time"]],
        "frame62": next(row for row in rows if row["frame_index"] == 62),
        "frame63": next(row for row in rows if row["frame_index"] == 63),
        "q90": {
            "max_jpeg_bytes": 31115,
            "byte_scaled_decode_ticks": math.ceil(reference_cycles * 31115 / REF_BYTES),
            "byte_scaled_decode_ms": round(math.ceil(reference_cycles * 31115 / REF_BYTES) * 16.8 / REFRESH_TICKS, 6),
            "margin_at_minimum_window_ms": round(min(row["available_decode_ticks"] for row in rows) * 16.8 / REFRESH_TICKS - math.ceil(reference_cycles * 31115 / REF_BYTES) * 16.8 / REFRESH_TICKS, 6),
        },
        "phase_csv": str(OUT_CSV),
    }
    OUT_JSON.write_text(json.dumps(summary, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps({k: summary[k] for k in ("source_index_sha256", "content_period_ticks", "phase_step_ticks", "phase_cycle_frames", "min_available_decode_ms", "frame62", "frame63", "pre_cascade_estimated_miss_indices", "q90")}, ensure_ascii=False))


if __name__ == "__main__":
    main()
