from pathlib import Path
import hashlib
import json
import struct
import sys

RECORD = struct.Struct("<HHBBB")
PIXELS = 640 * 480

def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()

def records(path: Path):
    blob = path.read_bytes()
    if len(blob) % RECORD.size:
        raise ValueError(f"bad pixel record size: {path} ({len(blob)})")
    return list(RECORD.iter_unpack(blob))

def check_frame_coverage(frame, label):
    coords = set()
    for x, y, r, g, b in frame:
        if x >= 640 or y >= 480:
            raise ValueError(f"{label}: out of bounds ({x},{y})")
        if (x, y) in coords:
            raise ValueError(f"{label}: duplicate coordinate ({x},{y})")
        coords.add((x,y))
    if len(coords) != PIXELS:
        raise ValueError(f"{label}: coordinate coverage {len(coords)}/{PIXELS}")
    return coords

def compare(baseline: Path, candidate: Path, expected_mem: Path | None = None, frame_index: int = 1):
    a, b = records(baseline), records(candidate)
    if len(a) != len(b):
        raise SystemExit(f"record count differs: {len(a)} vs {len(b)}")
    if len(a) % PIXELS:
        raise SystemExit(f"record count {len(a)} is not an integral number of frames")
    frames = len(a)//PIXELS
    for fi in range(frames):
        fa = a[fi*PIXELS:(fi+1)*PIXELS]
        fb = b[fi*PIXELS:(fi+1)*PIXELS]
        check_frame_coverage(fa, f"baseline frame {fi}")
        check_frame_coverage(fb, f"candidate frame {fi}")
        if fa != fb:
            for i,(x,y) in enumerate(zip(fa,fb)):
                if x!=y:
                    raise SystemExit(f"pixel record mismatch frame={fi} record={i} baseline={x} candidate={y}")
    pin = None
    if expected_mem is not None:
        words = [int(line,16) for line in expected_mem.read_text(encoding="ascii").splitlines() if line.strip()]
        start = frame_index*PIXELS
        if len(words) < start+PIXELS:
            raise SystemExit(f"pin RGB reference has only {len(words)} words")
        by_coord = {(x,y):(r,g,b) for x,y,r,g,b in a}
        mismatches = []
        for y in range(480):
            for x in range(640):
                word = words[start+y*640+x]
                expected = ((word>>16)&255,(word>>8)&255,word&255)
                if by_coord[(x,y)] != expected:
                    if len(mismatches)<5:
                        mismatches.append({"x":x,"y":y,"baseline":by_coord[(x,y)],"pin":expected})
        if mismatches:
            raise SystemExit(f"pin RGB mismatches (first five): {mismatches}")
        pin = {"source":str(expected_mem),"frame_index":frame_index,"frame_pixels":PIXELS,"exact":True,"sha256":sha(expected_mem)}
    print(json.dumps({
        "baseline":str(baseline),"candidate":str(candidate),"records":len(a),"frames":frames,
        "baseline_sha256":sha(baseline),"candidate_sha256":sha(candidate),
        "record_stream_exact":True,"pin_gold":pin,
    },indent=2))

if __name__ == "__main__":
    if len(sys.argv) not in (3,5):
        raise SystemExit("usage: compare_exact.py baseline.bin candidate.bin [pin_reference.mem frame_index]")
    compare(Path(sys.argv[1]),Path(sys.argv[2]),Path(sys.argv[3]) if len(sys.argv)==5 else None,int(sys.argv[4]) if len(sys.argv)==5 else 1)
