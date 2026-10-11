#!/usr/bin/env python3
"""Generate the canonical 8-second mono PCM WAV used by the TF/HDMI bring-up."""

from __future__ import annotations

import math
import struct
import wave
from pathlib import Path


SAMPLE_RATE = 48_000
CHANNELS = 1
SAMPLE_WIDTH = 2
TONE_SECONDS = 0.75
SILENCE_SECONDS = 0.25
FREQUENCIES = (262, 294, 330, 349, 392, 440, 494, 523)
PEAK = 6_000
FADE_SECONDS = 0.010
OUTPUT = Path(__file__).with_name("TEST.WAV")


def build_samples() -> bytes:
    tone_samples = round(TONE_SECONDS * SAMPLE_RATE)
    silence_samples = round(SILENCE_SECONDS * SAMPLE_RATE)
    fade_samples = round(FADE_SECONDS * SAMPLE_RATE)
    frames = bytearray()

    for frequency in FREQUENCIES:
        for index in range(tone_samples):
            envelope = min(1.0, index / fade_samples, (tone_samples - 1 - index) / fade_samples)
            sample = round(PEAK * envelope * math.sin(2.0 * math.pi * frequency * index / SAMPLE_RATE))
            frames.extend(struct.pack("<h", sample))
        frames.extend(b"\x00\x00" * silence_samples)
    return bytes(frames)


def main() -> None:
    pcm = build_samples()
    expected_data_bytes = 768_000
    if len(pcm) != expected_data_bytes:
        raise RuntimeError(f"Unexpected PCM size: {len(pcm)} != {expected_data_bytes}")

    with wave.open(str(OUTPUT), "wb") as wav:
        wav.setnchannels(CHANNELS)
        wav.setsampwidth(SAMPLE_WIDTH)
        wav.setframerate(SAMPLE_RATE)
        wav.writeframes(pcm)

    content = OUTPUT.read_bytes()
    if len(content) != 768_044 or content[:4] != b"RIFF" or content[8:12] != b"WAVE":
        raise RuntimeError("Output is not the expected 44-byte-header canonical WAV")
    if struct.unpack_from("<I", content, 4)[0] != 768_036:
        raise RuntimeError("Unexpected RIFF size")
    if content[12:16] != b"fmt " or struct.unpack_from("<IHHIIHH", content, 16) != (
        16, 1, CHANNELS, SAMPLE_RATE, SAMPLE_RATE * CHANNELS * SAMPLE_WIDTH,
        CHANNELS * SAMPLE_WIDTH, SAMPLE_WIDTH * 8,
    ):
        raise RuntimeError("Unexpected PCM format chunk")
    if content[36:40] != b"data" or struct.unpack_from("<I", content, 40)[0] != expected_data_bytes:
        raise RuntimeError("Unexpected data chunk")
    print(f"Generated {OUTPUT} ({len(content)} bytes)")


if __name__ == "__main__":
    main()
