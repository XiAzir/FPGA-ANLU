#!/usr/bin/env python3
"""Extract frame 0 and the largest Q65 frame from the validated MJP asset."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
MEDIA = ROOT / "development/video33_work/media1080"
OUT = Path(__file__).resolve().parent
index = json.loads((MEDIA / "media_index.json").read_text(encoding="utf-8"))
mjp = (MEDIA / index["video_file"]).read_bytes()
frames = index["frames"]
chosen = {
    "frame000": frames[0],
    "frame108_max": max(frames, key=lambda f: f["jpeg_length_bytes"]),
}
receipt = {"media_sha256": index["video_sha256"], "width": index["width"],
           "height": index["height"], "fps": [index["fps_num"], index["fps_den"]],
           "selected": {}}
for name, entry in chosen.items():
    start = entry["jpeg_offset_bytes"]
    blob = mjp[start:start + entry["jpeg_length_bytes"]]
    sha = hashlib.sha256(blob).hexdigest()
    if sha != entry["jpeg_sha256"] or blob[:2] != b"\xff\xd8" or blob[-2:] != b"\xff\xd9":
        raise SystemExit(f"frame integrity check failed: {name}")
    (OUT / f"{name}.jpg").write_bytes(blob)
    (OUT / f"{name}.hex").write_text("".join(f"{b:02x}\n" for b in blob), encoding="ascii")
    receipt["selected"][name] = {"frame_index": entry["frame_index"],
        "jpeg_bytes": len(blob), "jpeg_sha256": sha,
        "time_s": entry["time_s"], "data_words": (len(blob)+3)//4,
        "source_words_with_empty_last_tail": (len(blob)+3)//4+1,
        "input_gap_cycles_at_100mhz_1p22mbps": 328}
mini_src = ROOT / "development/video34_work/native/fixture_blocks.jpg"
if mini_src.exists():
    mini = mini_src.read_bytes()
    if mini[:2] != b"\xff\xd8" or mini[-2:] != b"\xff\xd9":
        raise SystemExit("native 16x16 fixture is not a complete JPEG")
    (OUT / "mini16.jpg").write_bytes(mini)
    (OUT / "mini16.hex").write_text("".join(f"{b:02x}\n" for b in mini), encoding="ascii")
    receipt["mini16_test_fixture"]={"source":str(mini_src.relative_to(ROOT)),
        "jpeg_bytes":len(mini),"sha256":hashlib.sha256(mini).hexdigest(),
        "data_words":(len(mini)+3)//4,"source_words_with_empty_last_tail":(len(mini)+3)//4+1}
(OUT / "fixtures.json").write_text(json.dumps(receipt, indent=2), encoding="utf-8")
print(json.dumps(receipt, indent=2))
