import argparse
import hashlib
import json
import sys
from pathlib import Path


SIM_DIR = Path(__file__).resolve().parent
VIDEO_WORK = SIM_DIR.parents[2]
sys.path.insert(0, str(VIDEO_WORK / "stream_frontend"))

from pack_video_mjp import DEFAULT_VIDEO, split_mjpeg


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("indices", nargs="+", type=int)
    args = parser.parse_args()
    frames = split_mjpeg(DEFAULT_VIDEO.read_bytes())
    if len(frames) != 300:
        raise SystemExit(f"expected 300 JPEG frames, found {len(frames)}")
    result = []
    for index in args.indices:
        if index < 0 or index >= len(frames):
            raise SystemExit(f"frame index out of range: {index}")
        path = SIM_DIR / f"frame_{index:03d}.jpg"
        data = frames[index]
        path.write_bytes(data)
        result.append({
            "index": index,
            "path": str(path),
            "bytes": len(data),
            "sha256": hashlib.sha256(data).hexdigest(),
        })
    print(json.dumps({"source": str(DEFAULT_VIDEO), "frame_count": len(frames), "frames": result}, indent=2))


if __name__ == "__main__":
    main()
