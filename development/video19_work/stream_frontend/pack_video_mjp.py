from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import struct
import zlib
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
DEFAULT_VIDEO = ROOT / "development/video_codec_trial_20261021/media/letterbox640_q95_420.mjpg"
DEFAULT_AUDIO = ROOT / "development/video_codec_trial_20261021/media/original_audio_16_36_pcm48k_mono.wav"
SECTOR = 512
WIDTH = 640
HEIGHT = 480
FPS_NUM = 15
FPS_DEN = 1
EXPECTED_FRAMES = 300
EXPECTED_SAMPLES_PER_FRAME = 3200


def split_mjpeg(blob: bytes) -> list[bytes]:
    frames: list[bytes] = []
    pos = 0
    while pos < len(blob):
        if blob[pos:pos + 2] != b"\xff\xd8":
            raise ValueError(f"expected JPEG SOI at input byte {pos}")
        end = blob.find(b"\xff\xd9", pos + 2)
        if end < 0:
            raise ValueError(f"missing JPEG EOI after input byte {pos}")
        frames.append(blob[pos:end + 2])
        pos = end + 2
    return frames


def jpeg_geometry(frame: bytes) -> tuple[int, int, tuple[int, int, int]]:
    if frame[:2] != b"\xff\xd8":
        raise ValueError("JPEG frame does not start with SOI")
    pos = 2
    while pos < len(frame):
        if frame[pos] != 0xFF:
            raise ValueError(f"invalid marker alignment at JPEG byte {pos}")
        while pos < len(frame) and frame[pos] == 0xFF:
            pos += 1
        if pos >= len(frame):
            break
        marker = frame[pos]
        pos += 1
        if marker == 0xDA:
            break
        if marker in (0xD8, 0xD9, 0x01) or 0xD0 <= marker <= 0xD7:
            continue
        if pos + 2 > len(frame):
            raise ValueError("truncated JPEG marker length")
        seg_len = int.from_bytes(frame[pos:pos + 2], "big")
        if seg_len < 2 or pos + seg_len > len(frame):
            raise ValueError("invalid JPEG marker extent")
        if marker == 0xC0:
            segment = frame[pos + 2:pos + seg_len]
            if len(segment) < 15:
                raise ValueError("short SOF0 segment")
            precision = segment[0]
            height = int.from_bytes(segment[1:3], "big")
            width = int.from_bytes(segment[3:5], "big")
            components = segment[5]
            sampling = (segment[7], segment[10], segment[13])
            if precision != 8 or components != 3 or sampling != (0x22, 0x11, 0x11):
                raise ValueError("JPEG must be 8-bit baseline YCbCr 4:2:0")
            return width, height, sampling
        pos += seg_len
    raise ValueError("JPEG has no baseline SOF0 marker before SOS")


def inspect_wav(path: Path) -> dict:
    data = path.read_bytes()
    if data[:4] != b"RIFF" or data[8:12] != b"WAVE":
        raise ValueError("audio input is not RIFF/WAVE")
    fmt = None
    pcm = None
    pos = 12
    while pos + 8 <= len(data):
        name = data[pos:pos + 4]
        size = int.from_bytes(data[pos + 4:pos + 8], "little")
        start = pos + 8
        end = start + size
        if end > len(data):
            raise ValueError("truncated WAV chunk")
        if name == b"fmt ":
            if size < 16:
                raise ValueError("short WAV fmt chunk")
            pcm = struct.unpack_from("<HHIIHH", data, start)
        elif name == b"data":
            fmt = (start, size)
        pos = end + (size & 1)
    if pcm is None or fmt is None:
        raise ValueError("WAV requires fmt and data chunks")
    audio_format, channels, sample_rate, byte_rate, block_align, bits = pcm
    data_offset, data_bytes = fmt
    if (audio_format, channels, sample_rate, block_align, bits) != (1, 1, 48000, 2, 16):
        raise ValueError("WAV must be PCM16 mono 48 kHz")
    if data_bytes != EXPECTED_FRAMES * EXPECTED_SAMPLES_PER_FRAME * 2:
        raise ValueError(f"WAV data has {data_bytes} bytes, expected 1920000")
    return {
        "file_bytes": len(data),
        "format": "PCM16 mono",
        "sample_rate_hz": sample_rate,
        "samples": data_bytes // block_align,
        "data_bytes": data_bytes,
        "data_offset": data_offset,
        "sha256": hashlib.sha256(data).hexdigest(),
    }


def make_global_header(frame_count: int) -> bytes:
    header = bytearray(SECTOR)
    header[0:4] = b"MJP1"
    struct.pack_into("<HHHHHHI", header, 4,
                     1, SECTOR, WIDTH, HEIGHT, FPS_NUM, FPS_DEN, frame_count)
    struct.pack_into("<I", header, 20, SECTOR)
    return bytes(header)


def make_frame_header(index: int, jpeg: bytes) -> bytes:
    header = bytearray(SECTOR)
    header[0:4] = b"FRM1"
    struct.pack_into("<HHIII", header, 4, 1, SECTOR, index, len(jpeg), zlib.crc32(jpeg))
    return bytes(header)


def pack(video_path: Path, audio_path: Path, output_path: Path,
         index_path: Path, audio_copy_path: Path) -> dict:
    video_blob = video_path.read_bytes()
    frames = split_mjpeg(video_blob)
    if len(frames) != EXPECTED_FRAMES:
        raise ValueError(f"expected {EXPECTED_FRAMES} JPEG frames, found {len(frames)}")
    for index, frame in enumerate(frames):
        width, height, _ = jpeg_geometry(frame)
        if (width, height) != (WIDTH, HEIGHT):
            raise ValueError(f"frame {index} is {width}x{height}, expected {WIDTH}x{HEIGHT}")

    audio_info = inspect_wav(audio_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    index_path.parent.mkdir(parents=True, exist_ok=True)
    audio_copy_path.parent.mkdir(parents=True, exist_ok=True)

    entries = []
    with output_path.open("wb") as out:
        out.write(make_global_header(len(frames)))
        for index, jpeg in enumerate(frames):
            record_offset = out.tell()
            jpeg_offset = record_offset + SECTOR
            jpeg_sectors = (len(jpeg) + SECTOR - 1) // SECTOR
            out.write(make_frame_header(index, jpeg))
            out.write(jpeg)
            out.write(bytes(jpeg_sectors * SECTOR - len(jpeg)))
            entries.append({
                "frame_index": index,
                "record_offset_bytes": record_offset,
                "record_sector": record_offset // SECTOR,
                "jpeg_offset_bytes": jpeg_offset,
                "jpeg_sector": jpeg_offset // SECTOR,
                "jpeg_length_bytes": len(jpeg),
                "jpeg_sector_count": jpeg_sectors,
                "record_next_sector": out.tell() // SECTOR,
                "jpeg_sha256": hashlib.sha256(jpeg).hexdigest(),
                "jpeg_crc32": f"{zlib.crc32(jpeg):08x}",
            })

    shutil.copyfile(audio_path, audio_copy_path)
    index_doc = {
        "format": "MJP1",
        "version": 1,
        "sector_bytes": SECTOR,
        "byte_order": "little-endian fields; JPEG bytes unchanged",
        "width": WIDTH,
        "height": HEIGHT,
        "fps_num": FPS_NUM,
        "fps_den": FPS_DEN,
        "frame_count": len(frames),
        "header_sector": 0,
        "first_frame_sector": 1,
        "video_file": output_path.name,
        "video_file_bytes": output_path.stat().st_size,
        "video_sha256": hashlib.sha256(output_path.read_bytes()).hexdigest(),
        "source_mjpg": str(video_path),
        "source_mjpg_sha256": hashlib.sha256(video_blob).hexdigest(),
        "audio_file": audio_copy_path.name,
        "audio": audio_info,
        "frames": entries,
    }
    index_path.write_text(json.dumps(index_doc, indent=2), encoding="utf-8")
    return index_doc


def main() -> None:
    parser = argparse.ArgumentParser(description="Pack 640x480/15fps JPEG frames into MJP1 sectors.")
    parser.add_argument("--video", type=Path, default=DEFAULT_VIDEO)
    parser.add_argument("--audio", type=Path, default=DEFAULT_AUDIO)
    parser.add_argument("--output", type=Path, default=HERE / "output/VIDEO.MJP")
    parser.add_argument("--index-json", type=Path, default=HERE / "output/index.json")
    parser.add_argument("--audio-copy", type=Path, default=HERE / "output/TEST.WAV")
    args = parser.parse_args()
    result = pack(args.video.resolve(), args.audio.resolve(), args.output.resolve(),
                  args.index_json.resolve(), args.audio_copy.resolve())
    print(json.dumps({
        "format": result["format"],
        "frames": result["frame_count"],
        "video_bytes": result["video_file_bytes"],
        "video_sha256": result["video_sha256"],
        "audio_bytes": result["audio"]["file_bytes"],
        "audio_sha256": result["audio"]["sha256"],
        "output": str(args.output.resolve()),
        "index": str(args.index_json.resolve()),
        "audio_copy": str(args.audio_copy.resolve()),
    }, indent=2))


if __name__ == "__main__":
    main()
