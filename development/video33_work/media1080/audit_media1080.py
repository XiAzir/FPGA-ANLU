from __future__ import annotations

import hashlib
import json
import struct
import zlib
from pathlib import Path

HERE = Path(__file__).resolve().parent
SECTOR = 512
FPS = 15
AUDIO_BPS = 96_000
OTHER_BPS = 20_000


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def verify_jpeg(blob: bytes, width: int, height: int) -> None:
    if blob[:2] != b"\xff\xd8" or blob[-2:] != b"\xff\xd9":
        raise ValueError("JPEG SOI/EOI mismatch")
    pos = 2
    while pos < len(blob):
        if blob[pos] != 255:
            raise ValueError("JPEG marker alignment error")
        marker = blob[pos + 1]
        pos += 2
        if marker == 0xDA:
            break
        size = int.from_bytes(blob[pos:pos + 2], "big")
        data = blob[pos + 2:pos + size]
        if marker == 0xC0:
            w, h = int.from_bytes(data[3:5], "big"), int.from_bytes(data[1:3], "big")
            if w != width or h != height or data[0] != 8 or data[5] != 3:
                raise ValueError(f"unexpected SOF0 dimensions/profile {w}x{h}")
            if (data[7], data[10], data[13]) != (0x22, 0x11, 0x11):
                raise ValueError("unexpected JPEG sampling factors")
            return
        pos += size
    raise ValueError("JPEG has no SOF0 before SOS")


def main() -> None:
    manifest_path = HERE / "manifest.json"
    index_path = HERE / "media_index.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    index = json.loads(index_path.read_text(encoding="utf-8"))
    stats = manifest["quality_statistics"]
    manifest["encoder"]["script_file"] = "prepare_media1080.py"
    manifest["encoder"]["script_sha256"] = sha256((HERE / "prepare_media1080.py").read_bytes())
    manifest["encoder"]["audit_script_file"] = "audit_media1080.py"
    manifest["encoder"]["audit_script_sha256"] = sha256(Path(__file__).read_bytes())
    video = (HERE / "VIDEO.MJP").read_bytes()
    if video[:4] != b"MJP1" or struct.unpack_from("<HHHHHHI", video, 4) != (1, 512, 1920, 1080, 15, 1, 300):
        raise ValueError("MJP1 global header mismatch")
    if struct.unpack_from("<I", video, 20)[0] != 512:
        raise ValueError("MJP first frame sector mismatch")
    if sha256(video) != index["video_sha256"] or len(video) != index["video_file_bytes"]:
        raise ValueError("MJP global hash/length mismatch")
    sector_end = SECTOR
    selected_frame_stream_bytes = []
    for i, frame in enumerate(index["frames"]):
        off = frame["record_offset_bytes"]
        header = video[off:off + SECTOR]
        if header[:4] != b"FRM1":
            raise ValueError(f"frame {i} record tag mismatch")
        version, header_bytes, frame_no, jpeg_len, crc = struct.unpack_from("<HHIII", header, 4)
        if (version, header_bytes, frame_no, jpeg_len) != (1, 512, i, frame["jpeg_length_bytes"]):
            raise ValueError(f"frame {i} header mismatch")
        jpeg_off = off + SECTOR
        jpeg = video[jpeg_off:jpeg_off + jpeg_len]
        verify_jpeg(jpeg, 1920, 1080)
        if sha256(jpeg) != frame["jpeg_sha256"] or zlib.crc32(jpeg) != crc:
            raise ValueError(f"frame {i} JPEG checksum mismatch")
        next_sector = jpeg_off + ((jpeg_len + SECTOR - 1) // SECTOR) * SECTOR
        if any(video[jpeg_off + jpeg_len:next_sector]):
            raise ValueError(f"frame {i} padding is nonzero")
        if next_sector != frame["record_next_sector"] * SECTOR:
            raise ValueError(f"frame {i} sector extent mismatch")
        selected_frame_stream_bytes.append(next_sector - off)
        sector_end = next_sector
    if sector_end != len(video):
        raise ValueError("trailing bytes after final MJP frame")
    wav = (HERE / "TEST.WAV").read_bytes()
    if sha256(wav) != index["audio"]["sha256"] or len(wav) != index["audio"]["file_bytes"]:
        raise ValueError("PCM WAV copy mismatch")

    q_windows = {}
    for q, row in stats.items():
        jpegs = [r["jpeg_length_bytes"] for r in row["frames_manifest"]]
        if len(jpegs) != 300:
            raise ValueError(f"quality {q} frame count mismatch")
        frame_bytes = [SECTOR + ((size + SECTOR - 1) // SECTOR) * SECTOR for size in jpegs]
        windows = {}
        for k in (1, 3, 15):
            peak = max(sum(frame_bytes[j:j + k]) for j in range(300 - k + 1))
            bps = peak * FPS / k
            windows[str(k)] = {
                "max_mjp_bytes_per_window": peak,
                "mjp_Mbps": bps * 8 / 1_000_000,
                "mjp_plus_pcm_Mbps": (bps + AUDIO_BPS) * 8 / 1_000_000,
                "mjp_plus_pcm_and_other_Mbps": (bps + AUDIO_BPS + OTHER_BPS) * 8 / 1_000_000,
                "below_80pct_spi_reserve": (bps + AUDIO_BPS + OTHER_BPS) <= 0.8 * manifest["spi_budget"]["historical_service_Bps"],
                "below_full_spi_service": (bps + AUDIO_BPS + OTHER_BPS) <= manifest["spi_budget"]["historical_service_Bps"],
            }
        row["mjp_window_peak"] = windows
        row["mjp_average_Bps"] = row["mjp_file_bytes_if_packed"] / 20
        row["mjp_average_plus_pcm_and_other_Bps"] = row["mjp_average_Bps"] + AUDIO_BPS + OTHER_BPS
        q_windows[q] = windows

    manifest["selected_quality_statistics"] = stats[str(manifest["selected_quality"])]
    manifest["verification"] = {
        "status": "PASS", "mjp_header": "MJP1 1920x1080 15/1 300 frames",
        "checked_frames": 300, "jpeg_sha256_crc32_dimensions_sector_padding": "PASS",
        "wav_copy_sha256_length": "PASS", "video_sha256": sha256(video),
        "audio_sha256": sha256(wav), "spi_window_peaks_include_mjp_padding_and_pcm": q_windows,
    }
    resource_path = HERE / "resource_usage.json"
    if resource_path.is_file():
        manifest["resource_usage"] = json.loads(resource_path.read_text(encoding="utf-8"))
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    (HERE / "audit.json").write_text(json.dumps(manifest["verification"], ensure_ascii=False, indent=2), encoding="utf-8")
    summary = {q: {
        "video_Mbps": row["video_Mbps"], "mjp_average_plus_pcm_and_other_Bps": row["mjp_average_plus_pcm_and_other_Bps"],
        "mjp_average_fits_80pct_reserve": row["total_media_fits_80pct_spi_reserve"],
        "mjp_window_peak": row["mjp_window_peak"], "PSNR_RGB_dB": row["full_frame_PSNR_RGB_dB"],
    } for q, row in stats.items()}
    print(json.dumps({"verified_frames": 300, "mjp_bytes": len(video), "quality_summary": summary}, indent=2))


if __name__ == "__main__":
    main()
