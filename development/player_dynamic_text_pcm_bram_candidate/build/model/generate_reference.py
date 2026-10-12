#!/usr/bin/env python3
"""Generate a small fragmented RIFF/WAVE image and independent CRC references.

Run from this directory.  The testbench reads input.hex and reference.hex;
reference.json is a human-readable copy of the same expected values.
"""

from __future__ import annotations

import binascii
import json
import struct
from pathlib import Path


PREFIX_SAMPLES = 1024
SKIP_SAMPLES = 512
PAYLOAD_SAMPLES = 300
FAULT_SAMPLE = 123
FAULT_MASK = 0x0001
IMAGE_BYTES = 2048
REAL_SKIP_SAMPLES = 65536
REAL_PREFIX_SAMPLES = 32768
REAL_INPUT = Path(__file__).resolve().parents[4] / "deliverables" / "real_music_20261008" / "card" / "TEST.WAV"


def chunk(tag: bytes, payload: bytes) -> bytes:
    if len(tag) != 4:
        raise ValueError("RIFF chunk tags must be four bytes")
    return tag + len(payload).to_bytes(4, "little") + payload + (b"\0" if len(payload) & 1 else b"")


def pcm_sample(index: int) -> int:
    # Deterministic, nonconstant sequence with transitions in both bytes.
    return ((index * 0x2D3B) ^ (index << 7) ^ 0xA55A) & 0xFFFF


def crc_pcm(samples: list[int]) -> int:
    raw = bytearray()
    for sample in samples:
        raw.extend((sample & 0xFF, (sample >> 8) & 0xFF))
    return binascii.crc_hqx(raw, 0xFFFF)


def build_wave() -> tuple[bytes, int, list[int]]:
    fmt = (
        (1).to_bytes(2, "little")
        + (1).to_bytes(2, "little")
        + (48000).to_bytes(4, "little")
        + (96000).to_bytes(4, "little")
        + (2).to_bytes(2, "little")
        + (16).to_bytes(2, "little")
        + (0xC111).to_bytes(2, "little")  # fmt extension bytes, skipped by player
    )
    junk = bytes((0x80 + i) & 0xFF for i in range(489))
    samples = [pcm_sample(i) for i in range(PAYLOAD_SAMPLES)]
    pcm = b"".join(value.to_bytes(2, "little") for value in samples)
    body = b"WAVE" + chunk(b"JUNK", junk) + chunk(b"fmt ", fmt) + chunk(b"data", pcm)
    riff = b"RIFF" + len(body).to_bytes(4, "little") + body

    data_offset = riff.index(b"data") + 8
    fmt_offset = riff.index(b"fmt ")
    assert fmt_offset == 510, f"fmt header should straddle sector 0/1, got {fmt_offset}"
    assert data_offset == 544, f"unexpected data offset {data_offset}"
    assert data_offset + len(pcm) > 1024, "PCM payload must cross a sector boundary"
    assert len(riff) <= IMAGE_BYTES
    return riff, data_offset, samples


def extract_pcm16_mono(path: Path) -> tuple[bytes, int, list[int]]:
    raw = path.read_bytes()
    if raw[:4] != b"RIFF" or raw[8:12] != b"WAVE":
        raise ValueError(f"not a RIFF/WAVE file: {path}")
    fmt = None
    data_offset = None
    data_size = None
    pos = 12
    while pos + 8 <= len(raw):
        tag = raw[pos : pos + 4]
        size = int.from_bytes(raw[pos + 4 : pos + 8], "little")
        payload = pos + 8
        end = payload + size
        if end > len(raw):
            raise ValueError(f"truncated {tag!r} chunk in {path}")
        if tag == b"fmt ":
            if size < 16:
                raise ValueError("WAV fmt chunk is shorter than 16 bytes")
            fmt = struct.unpack_from("<HHIIHH", raw, payload)
        elif tag == b"data":
            data_offset, data_size = payload, size
            break
        pos = end + (size & 1)
    if fmt is None or data_offset is None or data_size is None:
        raise ValueError("WAV is missing fmt or data chunk")
    audio_format, channels, rate, byte_rate, align, bits = fmt
    if (audio_format, channels, rate, byte_rate, align, bits) != (1, 1, 48000, 96000, 2, 16):
        raise ValueError(f"unexpected WAV format tuple: {fmt}")
    if data_size & 1:
        raise ValueError("PCM16 data chunk has an odd byte length")
    pcm_bytes = raw[data_offset : data_offset + data_size]
    samples = [int.from_bytes(pcm_bytes[i : i + 2], "little") for i in range(0, len(pcm_bytes), 2)]
    return raw, data_offset, samples


def main() -> None:
    check = binascii.crc_hqx(b"123456789", 0xFFFF)
    assert check == 0x29B1, f"CRC-16/CCITT-FALSE check vector failed: {check:04X}"

    riff, data_offset, payload = build_wave()
    image = bytearray([0xE7] * IMAGE_BYTES)
    image[: len(riff)] = riff

    window = [payload[(i + SKIP_SAMPLES) % len(payload)] for i in range(PREFIX_SAMPLES)]
    expected_crc = crc_pcm(window)
    faulted = window.copy()
    faulted[FAULT_SAMPLE] ^= FAULT_MASK
    fault_crc = crc_pcm(faulted)

    model_dir = Path(__file__).resolve().parent
    (model_dir / "input.hex").write_text(
        "".join(f"{byte:02X}\n" for byte in image), encoding="ascii"
    )
    # $readmemh loads 16-bit words in ascending index order.
    ref_words = [
        data_offset,
        data_offset + 2 * (SKIP_SAMPLES % len(payload)) + 1,
        len(payload),
        PREFIX_SAMPLES,
        expected_crc,
        fault_crc,
        FAULT_SAMPLE,
        FAULT_MASK,
        len(riff),
        SKIP_SAMPLES,
    ]
    (model_dir / "reference.hex").write_text(
        "".join(f"{word & 0xFFFF:04X}\n" for word in ref_words), encoding="ascii"
    )
    document = {
        "crc_standard_check_123456789": f"{check:04X}",
        "crc_order": "PCM low byte then high byte; CRC-16/CCITT init FFFF, poly 1021, no xorout",
        "prefix_samples": PREFIX_SAMPLES,
        "skip_samples": SKIP_SAMPLES,
        "payload_samples_per_loop": len(payload),
        "data_offset": data_offset,
        "first_high_byte_absolute_offset": data_offset + 2 * (SKIP_SAMPLES % len(payload)) + 1,
        "riff_file_size": len(riff),
        "prefix_crc16": f"{expected_crc:04X}",
        "fault_sample_zero_based": FAULT_SAMPLE,
        "fault_xor_mask": f"{FAULT_MASK:04X}",
        "fault_prefix_crc16": f"{fault_crc:04X}",
        "loop_count_before_prefix": SKIP_SAMPLES // len(payload),
        "loop_offset_at_prefix": SKIP_SAMPLES % len(payload),
        "loop_count_in_window": (SKIP_SAMPLES % len(payload) + PREFIX_SAMPLES) // len(payload),
        "window_tail_samples": (SKIP_SAMPLES % len(payload) + PREFIX_SAMPLES) % len(payload),
    }
    (model_dir / "reference.json").write_text(
        json.dumps(document, indent=2) + "\n", encoding="utf-8"
    )

    real_raw, real_data_offset, real_samples = extract_pcm16_mono(REAL_INPUT)
    real_needed = REAL_SKIP_SAMPLES + REAL_PREFIX_SAMPLES
    if len(real_samples) < real_needed:
        raise ValueError(f"real WAV has {len(real_samples)} samples; need {real_needed}")
    real_window = real_samples[REAL_SKIP_SAMPLES:real_needed]
    real_crc = crc_pcm(real_window)
    if real_crc != 0xF485:
        raise ValueError(f"real WAV window CRC mismatch: expected F485, got {real_crc:04X}")
    (model_dir / "real_stream.hex").write_text(
        "".join(f"{sample:04X}\n" for sample in real_samples[:real_needed]), encoding="ascii"
    )
    (model_dir / "real_reference.hex").write_text(
        f"{real_crc:04X}\n{real_data_offset:04X}\n"
        f"{(real_data_offset + 2 * REAL_SKIP_SAMPLES + 1) & 0xFFFF:04X}\n"
        f"{(real_data_offset + 2 * REAL_SKIP_SAMPLES + 1) >> 16:04X}\n"
        f"{REAL_SKIP_SAMPLES & 0xFFFF:04X}\n{REAL_PREFIX_SAMPLES:04X}\n",
        encoding="ascii",
    )
    document["real_wav"] = {
        "path": str(REAL_INPUT),
        "samples": len(real_samples),
        "data_offset": real_data_offset,
        "skip_samples": REAL_SKIP_SAMPLES,
        "prefix_samples": REAL_PREFIX_SAMPLES,
        "first_high_byte_absolute_offset": real_data_offset + 2 * REAL_SKIP_SAMPLES + 1,
        "prefix_crc16": f"{real_crc:04X}",
        "window_nonzero_samples": sum(sample != 0 for sample in real_window),
        "first_98304_nonzero_samples": sum(sample != 0 for sample in real_samples[:real_needed]),
    }
    (model_dir / "reference.json").write_text(
        json.dumps(document, indent=2) + "\n", encoding="utf-8"
    )
    print(json.dumps(document, indent=2))


if __name__ == "__main__":
    main()
