#!/usr/bin/env python3
"""Extract mapped EG4 cells tagged as audio-output/ACR RTL from final routed tops."""
from pathlib import Path
import re
import sys

CELL = re.compile(r"\bEG_PHY_[A-Za-z0-9_]+\b")
FILES = (
    "player_audio_output.v",
    "player_audio_probe.v",
    "hdmi_audio_tone_pcm_scale.v",
    "wav_pcm_bridge.v",
    "audio_arc_calculate.v",
)


def match_paren(src: str, open_at: int) -> int:
    depth = 0
    i = open_at
    quote = False
    while i < len(src):
        c = src[i]
        if quote:
            if c == "\\":
                i += 2
                continue
            if c == '"':
                quote = False
        elif c == '"':
            quote = True
        elif src.startswith("//", i):
            nl = src.find("\n", i + 2)
            i = len(src) if nl < 0 else nl + 1
            continue
        elif src.startswith("/*", i):
            end = src.find("*/", i + 2)
            i = len(src) if end < 0 else end + 2
            continue
        elif c == "(":
            depth += 1
        elif c == ")":
            depth -= 1
            if depth == 0:
                return i
        i += 1
    raise ValueError(f"unclosed parenthesis at byte {open_at}")


def cells(src: str):
    for m in CELL.finditer(src):
        # Cell declaration only; skip occurrences inside comments and quoted LUT text.
        line_start = src.rfind("\n", 0, m.start()) + 1
        prefix = src[line_start:m.start()]
        if "//" in prefix or "/*" in prefix:
            continue
        p = m.end()
        while p < len(src) and src[p].isspace():
            p += 1
        if src.startswith("#", p):
            p += 1
            while p < len(src) and src[p].isspace():
                p += 1
            if src[p] != "(":
                continue
            p = match_paren(src, p) + 1
        while p < len(src) and src[p].isspace():
            p += 1
        name_start = p
        while p < len(src) and not src[p].isspace() and src[p] != "(":
            p += 1
        name = src[name_start:p]
        while p < len(src) and src[p].isspace():
            p += 1
        if not name or p >= len(src) or src[p] != "(":
            continue
        end_conn = match_paren(src, p)
        semi = src.find(";", end_conn)
        if semi < 0:
            continue
        end = semi + 1
        line_end = src.find("\n", end)
        line_end = len(src) if line_end < 0 else line_end
        trailer = src[end:line_end]
        yield (m.start(), end, m.group(0), name, trailer)


def extract(path: Path, out: Path, module_name: str):
    src = path.read_text(encoding="ascii", errors="replace")
    first_cell = next(CELL.finditer(src)).start()
    header_end = src.find("\n", first_cell)
    prefix = src[:first_cell]
    # The first primitive occurs after all net declarations. Keep module header and declarations.
    selected = []
    counts = {k: 0 for k in FILES}
    for start, end, celltype, inst, trailer in cells(src):
        tag = next((f for f in FILES if f in trailer), None)
        if tag:
            selected.append(src[start:end])
            counts[tag] += 1
    # Replace only top module's name in the declaration, retain net declarations verbatim.
    prefix = re.sub(r"(?m)^module\s+top\b", f"module {module_name}", prefix, count=1)
    out.write_text(prefix + "\n".join(selected) + "\nendmodule\n", encoding="ascii")
    return counts, len(selected), len(src), len(prefix)


if __name__ == "__main__":
    root = Path(__file__).resolve().parents[3]
    dst = Path(__file__).resolve().parent
    for ver, folder in (("29", "player_video29_media_flow"), ("30", "player_video30_probe_prune")):
        inp = root / "development" / folder / "verification" / "final_routed.v"
        counts, n, src_size, prefix_size = extract(inp, dst / f"audio_cone{ver}.v", f"audio_cone{ver}")
        print(f"C{ver}: source={src_size:,} bytes prefix={prefix_size:,} cells={n:,} by_rtl={counts}")
