#!/usr/bin/env python3
"""Build independent bitwise CRC references from the canonical 48 kHz WAV."""
from __future__ import annotations

import csv
import hashlib
import json
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
SOURCE = ROOT / "deliverables/video20_c11320_20261021/TEST.WAV"
OUT = Path(__file__).resolve().parent
SAMPLES_PER_LOOP = 960_000
SAMPLES_PER_BLOCK = 4096
TWO_PASS_SAMPLES = 2 * SAMPLES_PER_LOOP


def parse_wav(path: Path) -> tuple[bytes, int, int]:
    raw = path.read_bytes()
    if raw[:4] != b"RIFF" or raw[8:12] != b"WAVE":
        raise ValueError("input is not RIFF/WAVE")
    fmt = None
    data_offset = data_size = None
    pos = 12
    while pos + 8 <= len(raw):
        chunk_id = raw[pos : pos + 4]
        chunk_size = struct.unpack_from("<I", raw, pos + 4)[0]
        body = pos + 8
        end = body + chunk_size
        if end > len(raw):
            raise ValueError(f"chunk {chunk_id!r} exceeds file length")
        if chunk_id == b"fmt ":
            fmt = raw[body:end]
        elif chunk_id == b"data":
            data_offset, data_size = body, chunk_size
            break
        pos = end + (chunk_size & 1)
    if fmt is None or data_offset is None or data_size is None:
        raise ValueError("missing fmt or data chunk")
    if len(fmt) < 16:
        raise ValueError("short fmt chunk")
    audio_format, channels, sample_rate, _, block_align, bits = struct.unpack_from("<HHIIHH", fmt)
    if (audio_format, channels, sample_rate, block_align, bits) != (1, 1, 48_000, 2, 16):
        raise ValueError(f"unsupported WAV fmt: {audio_format, channels, sample_rate, block_align, bits}")
    if data_size != SAMPLES_PER_LOOP * 2:
        raise ValueError(f"expected {SAMPLES_PER_LOOP} PCM samples, got {data_size // 2}")
    return raw[data_offset : data_offset + data_size], data_offset, len(raw)


def crc16_ccitt(payload: bytes, initial: int = 0xFFFF) -> int:
    crc = initial
    for value in payload:
        crc ^= value << 8
        for _ in range(8):
            crc = ((crc << 1) ^ 0x1021) & 0xFFFF if crc & 0x8000 else (crc << 1) & 0xFFFF
    return crc


def sample_payload(sample: int, flip_left_pcm_lsb: bool = False) -> bytes:
    left_sample = sample ^ 1 if flip_left_pcm_lsb else sample
    left24 = (left_sample << 8) & 0xFFFFFF
    right24 = (sample << 8) & 0xFFFFFF
    channels = (left24, right24)
    return bytes(byte for word in channels for byte in (word & 0xFF, (word >> 8) & 0xFF, (word >> 16) & 0xFF))


def block_crc(pcm: bytes, start: int, count: int, *, flip_first_left_lsb: bool = False) -> int:
    crc = 0xFFFF
    for offset in range(count):
        loop_index = (start + offset) % SAMPLES_PER_LOOP
        sample = struct.unpack_from("<H", pcm, loop_index * 2)[0]
        crc = crc16_ccitt(sample_payload(sample, flip_left_pcm_lsb=(flip_first_left_lsb and offset == 0)), crc)
    return crc


def main() -> None:
    pcm, data_offset, file_bytes = parse_wav(SOURCE)
    digest = hashlib.sha256(SOURCE.read_bytes()).hexdigest()
    rows: list[dict[str, int | str]] = []
    total_blocks = (TWO_PASS_SAMPLES + SAMPLES_PER_BLOCK - 1) // SAMPLES_PER_BLOCK
    first_crc = None
    for index in range(total_blocks):
        start = index * SAMPLES_PER_BLOCK
        count = min(SAMPLES_PER_BLOCK, TWO_PASS_SAMPLES - start)
        value = block_crc(pcm, start, count)
        if first_crc is None:
            first_crc = value
        rows.append({
            "block_index": index,
            "sample_start": start,
            "sample_end_exclusive": start + count,
            "sample_count": count,
            "wav_loop_start": start % SAMPLES_PER_LOOP,
            "wav_loop_end_exclusive": (start + count) % SAMPLES_PER_LOOP,
            "wraps_source_loop": int(start // SAMPLES_PER_LOOP != (start + count - 1) // SAMPLES_PER_LOOP),
            "crc16_ccitt": f"{value:04X}",
            "first_crc": f"{first_crc:04X}",
        })

    common = {
        "source_path": str(SOURCE),
        "source_sha256": digest,
        "file_bytes": file_bytes,
        "data_offset": data_offset,
        "data_bytes": len(pcm),
        "sample_rate_hz": 48000,
        "pcm_bits": 16,
        "channels": 1,
        "samples_per_source_loop": SAMPLES_PER_LOOP,
        "samples_per_block": SAMPLES_PER_BLOCK,
        "pass_count": 2,
        "boundary_rule": "sample_index % 960000",
        "crc": {
            "name": "CRC-16/CCITT-FALSE",
            "polynomial": "0x1021",
            "initial": "0xFFFF",
            "reflected": False,
            "byte_order": ["L[7:0]", "L[15:8]", "L[23:16]", "R[7:0]", "R[15:8]", "R[23:16]"],
            "bit_order": "MSB-first per byte",
            "sample_to_channel_word": "{pcm16,8'h00}",
        },
        "total_samples": TWO_PASS_SAMPLES,
        "total_blocks": total_blocks,
        "blocks": rows,
    }
    (OUT / "canonical_crc_two_pass.json").write_text(json.dumps(common, indent=2) + "\n", encoding="utf-8")
    with (OUT / "canonical_crc_two_pass.csv").open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)
    first80 = {**common, "blocks": rows[:80], "total_blocks_in_table": 80}
    (OUT / "canonical_crc_first80.json").write_text(json.dumps(first80, indent=2) + "\n", encoding="utf-8")
    with (OUT / "canonical_crc_first80.csv").open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows[:80])

    # Three-block RTL fixture and independent positive/negative references.
    first_three = [struct.unpack_from("<H", pcm, i * 2)[0] for i in range(3 * SAMPLES_PER_BLOCK)]
    (OUT / "samples_3blocks.mem").write_text("".join(f"{sample:04X}\n" for sample in first_three), encoding="ascii")
    (OUT / "expected_3blocks.mem").write_text("".join(f"{int(row['crc16_ccitt'], 16):04X}\n" for row in rows[:3]), encoding="ascii")
    negative = block_crc(pcm, 0, SAMPLES_PER_BLOCK, flip_first_left_lsb=True)
    if negative == int(rows[0]["crc16_ccitt"], 16):
        raise AssertionError("single-bit negative control did not change CRC")
    (OUT / "expected_negative.mem").write_text(f"{negative:04X}\n", encoding="ascii")
    (OUT / "golden_inputs.json").write_text(json.dumps({
        "source_sha256": digest,
        "data_offset": data_offset,
        "source_loop_samples": SAMPLES_PER_LOOP,
        "fixture_samples": len(first_three),
        "expected_first_three_blocks": [row["crc16_ccitt"] for row in rows[:3]],
        "expected_negative_first_block_flip_left_pcm_lsb": f"{negative:04X}",
    }, indent=2) + "\n", encoding="utf-8")
    print(f"PASS golden: source_sha256={digest} offset={data_offset} samples={SAMPLES_PER_LOOP} two_pass_blocks={total_blocks}")
    print(f"RTL fixture blocks={len(first_three) // SAMPLES_PER_BLOCK} expected={[row['crc16_ccitt'] for row in rows[:3]]} negative_first={negative:04X}")


if __name__ == "__main__":
    main()
