from __future__ import annotations

import hashlib
import io
import json
import math
import struct
import subprocess
import sys
import time
import wave
import zlib
from pathlib import Path

import numpy as np
from PIL import Image, __version__ as pillow_version

HERE = Path(__file__).resolve().parent
SOURCE = Path(r"C:\Users\PENGYUHAO\Downloads\只因你太美（鸡你太美）原版.mp4")
FFMPEG = Path(r"E:\JianyingPro\11.2.0.14339\ffmpeg.exe")
W, H, FPS, COUNT = 1920, 1080, 15, 300
QUALITIES = (65, 75, 85, 90)
SECTOR = 512
SERVICE_BPS = 1_353_638
PCM_BPS = 96_000
OTHER_BPS = 20_000
RESERVED_BPS = int(0.8 * SERVICE_BPS)
VIDEO_BUDGET_BPS = RESERVED_BPS - PCM_BPS - OTHER_BPS


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        while block := f.read(1024 * 1024):
            h.update(block)
    return h.hexdigest()


def jpeg_profile(blob: bytes) -> dict:
    pos = 2
    markers, dqt, dht, sof = [], [], [], None
    while pos < len(blob):
        if blob[pos] != 255:
            raise ValueError(f"bad JPEG marker at byte {pos}")
        marker = blob[pos + 1]
        pos += 2
        if marker == 0xD9:
            break
        length = int.from_bytes(blob[pos:pos + 2], "big")
        data = blob[pos + 2:pos + length]
        markers.append(marker)
        if marker == 0xDB:
            dqt.append(data.hex())
        elif marker == 0xC4:
            dht.append(data.hex())
        elif marker == 0xC0:
            sof = {"precision": data[0], "height": int.from_bytes(data[1:3], "big"),
                   "width": int.from_bytes(data[3:5], "big"), "components": data[5],
                   "sampling": [data[7], data[10], data[13]]}
        elif marker == 0xDA:
            break
        pos += length
    if sof is None or sof["sampling"] != [0x22, 0x11, 0x11]:
        raise ValueError("JPEG does not match baseline YCbCr 4:2:0")
    return {"markers": [f"0x{x:02x}" for x in markers], "sof0": sof,
            "dqt_sha256": sha256(json.dumps(dqt).encode()),
            "dht_sha256": sha256(json.dumps(dht).encode()),
            "restart_interval_marker": 0xDD in markers}


def exact_read(stream, count: int) -> bytes:
    parts = []
    left = count
    while left:
        part = stream.read(left)
        if not part:
            break
        parts.append(part)
        left -= len(part)
    return b"".join(parts)


def make_mjp_header(frame_count: int) -> bytes:
    b = bytearray(SECTOR)
    b[:4] = b"MJP1"
    struct.pack_into("<HHHHHHI", b, 4, 1, SECTOR, W, H, FPS, 1, frame_count)
    struct.pack_into("<I", b, 20, SECTOR)
    return bytes(b)


def make_frame_header(index: int, jpeg: bytes) -> bytes:
    b = bytearray(SECTOR)
    b[:4] = b"FRM1"
    struct.pack_into("<HHIII", b, 4, 1, SECTOR, index, len(jpeg), zlib.crc32(jpeg))
    return bytes(b)


def main() -> None:
    if not SOURCE.is_file() or not FFMPEG.is_file():
        raise FileNotFoundError("source video or ffmpeg missing")
    frame_bytes = W * H * 3
    ffmpeg_args = [str(FFMPEG), "-hide_banner", "-loglevel", "error", "-nostdin", "-threads", "1",
                   "-ss", "16", "-i", str(SOURCE), "-t", "20", "-map", "0:v:0", "-an",
                   "-vf", "fps=15,scale=1920:1080:flags=lanczos,format=rgb24", "-frames:v", str(COUNT),
                   "-threads", "1", "-f", "rawvideo", "-pix_fmt", "rgb24", "pipe:1"]
    started = time.time()
    frame_records = {q: [] for q in QUALITIES}
    sizes = {q: [] for q in QUALITIES}
    sse = {q: 0 for q in QUALITIES}
    worst_psnr = {q: 999.0 for q in QUALITIES}
    profile_blobs = {}
    streams = {q: (HERE / f"frames_q{q}.mjpg").open("wb") for q in QUALITIES}
    proc = subprocess.Popen(ffmpeg_args, stdout=subprocess.PIPE, stderr=subprocess.PIPE, bufsize=0)
    try:
        assert proc.stdout is not None
        for i in range(COUNT):
            raw = exact_read(proc.stdout, frame_bytes)
            if len(raw) != frame_bytes:
                raise RuntimeError(f"ffmpeg returned {len(raw)} bytes for frame {i}, expected {frame_bytes}")
            src = np.frombuffer(raw, dtype=np.uint8).reshape(H, W, 3)
            im = Image.frombytes("RGB", (W, H), raw)
            for q in QUALITIES:
                buf = io.BytesIO()
                im.save(buf, format="JPEG", quality=q, subsampling=2,
                        optimize=False, progressive=False)
                jpg = buf.getvalue()
                streams[q].write(jpg)
                sizes[q].append(len(jpg))
                frame_records[q].append({"frame_index": i, "time_s": i / FPS,
                                         "jpeg_length_bytes": len(jpg), "jpeg_sha256": sha256(jpg),
                                         "jpeg_crc32": f"{zlib.crc32(jpg):08x}"})
                if q not in profile_blobs:
                    profile_blobs[q] = jpg
                decoded = np.asarray(Image.open(io.BytesIO(jpg)), dtype=np.uint8)
                diff = decoded.astype(np.int16) - src.astype(np.int16)
                frame_sse = int(np.sum(diff.astype(np.int32) ** 2, dtype=np.int64))
                mse = frame_sse / diff.size
                sse[q] += frame_sse
                psnr = 10 * math.log10(255 * 255 / mse) if mse else 999.0
                worst_psnr[q] = min(worst_psnr[q], psnr)
            if (i + 1) % 25 == 0:
                print(f"encoded {i+1}/{COUNT} frames", flush=True)
    finally:
        for f in streams.values():
            f.close()
        if proc.stdout:
            proc.stdout.close()
    stderr = proc.stderr.read().decode("utf-8", errors="replace") if proc.stderr else ""
    rc = proc.wait()
    if rc:
        raise RuntimeError(f"ffmpeg video extraction failed ({rc}): {stderr}")

    wav_path = HERE / "original_audio_16_36_pcm48k_mono.wav"
    wav_args = [str(FFMPEG), "-hide_banner", "-loglevel", "error", "-nostdin", "-threads", "1",
                "-ss", "16", "-i", str(SOURCE), "-t", "20", "-map", "0:a:0", "-vn", "-ar", "48000",
                "-ac", "1", "-c:a", "pcm_s16le", "-y", str(wav_path)]
    run = subprocess.run(wav_args, capture_output=True, text=True)
    if run.returncode:
        raise RuntimeError(f"ffmpeg audio extraction failed: {run.stderr}")
    with wave.open(str(wav_path), "rb") as wf:
        audio = {"format": "PCM16 mono", "sample_rate_hz": wf.getframerate(),
                 "channels": wf.getnchannels(), "sample_width_bytes": wf.getsampwidth(),
                 "samples": wf.getnframes(), "file_bytes": wav_path.stat().st_size,
                 "data_bytes": wf.getnframes() * wf.getnchannels() * wf.getsampwidth(),
                 "sha256": sha_file(wav_path)}
    if audio["data_bytes"] != 1_920_000 or audio["samples"] != 960_000:
        raise ValueError(f"unexpected audio length: {audio}")

    stats = {}
    for q in QUALITIES:
        a = np.asarray(sizes[q], dtype=np.int64)
        total = int(a.sum())
        windows = {str(k): int(max(sum(sizes[q][j:j+k]) for j in range(COUNT-k+1)))
                   for k in (1, 3, 15)}
        # MJP stores one 512-byte frame header and sector-aligns each JPEG.
        padded = sum(((n + SECTOR - 1) // SECTOR) * SECTOR + SECTOR for n in sizes[q]) + SECTOR
        stats[str(q)] = {
            "quality": q, "jpeg_subsampling": "4:2:0", "huffman": "standard fixed tables",
            "progressive": False, "frames": COUNT, "fps": FPS, "duration_s": 20,
            "mean_frame_bytes": float(a.mean()), "p95_frame_bytes": float(np.percentile(a, 95)),
            "max_frame_bytes": int(a.max()), "max_frame_index": int(a.argmax()),
            "min_frame_bytes": int(a.min()), "jpeg_total_bytes": total,
            "video_Mbps": total * 8 / 20 / 1_000_000,
            "video_plus_pcm_Mbps": total * 8 / 20 / 1_000_000 + PCM_BPS * 8 / 1_000_000,
            "mean_total_stream_Mbps_including_mjp_pcm": padded * 8 / 20 / 1_000_000 + PCM_BPS * 8 / 1_000_000,
            "max_one_frame_Mbps": int(a.max()) * 8 * FPS / 1_000_000,
            "max_3_frame_window_Mbps": windows["3"] * 8 * FPS / 3 / 1_000_000,
            "max_15_frame_window_Mbps": windows["15"] * 8 * FPS / 15 / 1_000_000,
            "max_window_jpeg_bytes": windows,
            "mjp_file_bytes_if_packed": padded,
            "mjp_container_overhead_bytes": padded - total,
            "mjp_overhead_percent_of_jpeg": (padded - total) / total * 100,
            "full_frame_PSNR_RGB_dB": 10 * math.log10(255 * 255 / (sse[q] / (COUNT * W * H * 3))),
            "worst_frame_PSNR_RGB_dB": worst_psnr[q],
            "video_budget_Bps_after_audio_and_other": VIDEO_BUDGET_BPS,
            "average_video_fits_budget": total / 20 <= VIDEO_BUDGET_BPS,
            "total_media_fits_80pct_spi_reserve": (padded + audio["data_bytes"]) / 20 <= RESERVED_BPS,
            "profile": jpeg_profile(profile_blobs[q]),
            "frames_manifest": frame_records[q],
        }

    # Candidate choice: highest tested quality that fits historical 80% service reserve.
    eligible = [q for q in QUALITIES if stats[str(q)]["total_media_fits_80pct_spi_reserve"]]
    selected = max(eligible) if eligible else min(QUALITIES, key=lambda q: stats[str(q)]["mean_total_stream_Mbps_including_mjp_pcm"])
    src_hash = sha_file(SOURCE)
    src_path = HERE / f"frames_q{selected}.mjpg"
    mjp_path = HERE / "VIDEO.MJP"
    entries = []
    with src_path.open("rb") as inp, mjp_path.open("wb") as out:
        out.write(make_mjp_header(COUNT))
        for i, rec in enumerate(frame_records[selected]):
            jpeg = exact_read(inp, rec["jpeg_length_bytes"])
            if len(jpeg) != rec["jpeg_length_bytes"] or sha256(jpeg) != rec["jpeg_sha256"]:
                raise ValueError(f"encoded frame data mismatch at {i}")
            offset = out.tell()
            sectors = (len(jpeg) + SECTOR - 1) // SECTOR
            out.write(make_frame_header(i, jpeg)); out.write(jpeg)
            out.write(bytes(sectors * SECTOR - len(jpeg)))
            entries.append({**rec, "record_offset_bytes": offset,
                            "record_sector": offset // SECTOR,
                            "jpeg_offset_bytes": offset + SECTOR,
                            "jpeg_sector": (offset + SECTOR) // SECTOR,
                            "jpeg_sector_count": sectors,
                            "record_next_sector": out.tell() // SECTOR})
    audio_copy = HERE / "TEST.WAV"
    audio_copy.write_bytes(wav_path.read_bytes())
    index = {"format": "MJP1", "version": 1, "sector_bytes": SECTOR,
             "byte_order": "little-endian fields; JPEG bytes unchanged", "width": W, "height": H,
             "fps_num": FPS, "fps_den": 1, "frame_count": COUNT,
             "header_sector": 0, "first_frame_sector": 1, "video_file": mjp_path.name,
             "video_file_bytes": mjp_path.stat().st_size, "video_sha256": sha_file(mjp_path),
             "source_mjpg": src_path.name, "source_mjpg_sha256": sha_file(src_path),
             "audio_file": audio_copy.name, "audio": audio,
             "selected_quality": selected, "frames": entries}
    (HERE / "media_index.json").write_text(json.dumps(index, ensure_ascii=False, indent=2), encoding="utf-8")

    preview_blob = exact_read(src_path.open("rb"), frame_records[selected][0]["jpeg_length_bytes"])
    Image.open(io.BytesIO(preview_blob)).save(HERE / "preview_frame_000.png")
    manifest = {"status": "MATERIALS_READY", "source": {"path": str(SOURCE), "sha256": src_hash,
                "bytes": SOURCE.stat().st_size, "video_native": "1280x720 H.264, 30fps, yuv420p, BT.709",
                "audio_native": "48kHz mono AAC", "upscale_note": "1920x1080 is Lanczos enlargement from 1280x720; no extra source detail is created"},
                "selection": {"start_s": 16, "end_s": 36, "fps": FPS, "frames": COUNT,
                              "duration_s": 20, "resampling": "fps=15,scale=1920:1080:flags=lanczos,format=rgb24"},
                "encoder": {"library": "Pillow/libjpeg", "pillow_version": pillow_version,
                            "quality_settings": list(QUALITIES), "subsampling": "4:2:0",
                            "optimize": False, "progressive": False, "ffmpeg": str(FFMPEG),
                            "ffmpeg_arguments_video": ffmpeg_args, "ffmpeg_arguments_audio": wav_args,
                            "threads": 1},
                "spi_budget": {"historical_service_Bps": SERVICE_BPS, "reserve_fraction": 0.8,
                               "reserved_Bps": RESERVED_BPS, "pcm_Bps": PCM_BPS, "other_Bps": OTHER_BPS,
                               "video_budget_Bps": VIDEO_BUDGET_BPS},
                "audio": audio, "quality_statistics": stats,
                "selected_quality": selected, "selected_reason": "Highest tested JPEG quality whose MJP1 video plus PCM average fits the historical 80% SPI service reserve; compare burst windows separately.",
                "mjp": {"path": str(mjp_path), "bytes": mjp_path.stat().st_size,
                        "sha256": sha_file(mjp_path), "frame_header_bytes": SECTOR,
                        "sector_padding": "JPEG payload rounded up to 512-byte sector per frame",
                        "index": str(HERE / "media_index.json")},
                "artifacts": []}
    for p in [mjp_path, audio_copy, wav_path, HERE / "media_index.json", HERE / "preview_frame_000.png"]:
        manifest["artifacts"].append({"path": p.name, "bytes": p.stat().st_size, "sha256": sha_file(p)})
    (HERE / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps({"selected_quality": selected,
                      "quality_summary": {q: {k: v for k, v in stats[str(q)].items() if k != "frames_manifest"}
                                          for q in QUALITIES},
                      "audio": audio, "mjp_bytes": mjp_path.stat().st_size,
                      "elapsed_s": round(time.time() - started, 1), "manifest": str(HERE / "manifest.json")},
                     ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
