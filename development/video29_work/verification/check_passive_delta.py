"""Check C27 -> C29 source hashes and the declared passive-observation delta."""
from __future__ import annotations

import difflib
import hashlib
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
BASE = ROOT / "development/player_video27_command_boundary/src/user_source"
CAND = ROOT / "development/player_video29_media_flow/src/user_source"
OUT = Path(__file__).resolve().parent

EXPECTED_CHANGED = {
    "hdl_source/top_tf_hdmi_audio.v",
    "hdl_source/frame_buffer_rgb888.v",
    "hdl_source/SD/frame_read_write.v",
    "hdl_source/SD/frame_fifo_read.v",
    "hdl_source/player_compact_status_pages.v",
}
EXPECTED_ADDED = {"hdl_source/player_memory_runtime_probe.v"}


def sha_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha(path: Path) -> str:
    return sha_bytes(path.read_bytes())


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8-sig")


def exact_replace(text: str, old: str, new: str, count: int = 1) -> str:
    actual = text.count(old)
    assert actual == count, f"expected {count} occurrences of {old!r}; found {actual}"
    return text.replace(old, new)


def remove_exact_lines(text: str, lines: list[str]) -> str:
    for line in lines:
        text = exact_replace(text, line, "")
    return text


def strip_observation(name: str, text: str, candidate: bool) -> str:
    """Remove only audited observation-only additions, with exact anchors."""
    if name == "top_tf_hdmi_audio.v":
        if candidate:
            text = remove_exact_lines(text, [
                "wire [31:0] memory_probe_page5;\n",
                "wire [11:0] memory_probe_page6_tail;\n",
                "wire memory_app_read,memory_read_valid,memory_app_write;\n",
                "wire [31:0] memory_read_word,memory_write_word;\n",
                "wire [3:0] memory_read_state;\n",
                "wire memory_fifo_clear,memory_underflow;\n",
                "wire [23:0] packet_samples,packet_bch,packet_terc,packet_tone;\n",
                "wire [19:0] packet_cts,packet_n;\n",
                "wire [3:0] packet_flags;\n",
                "wire [7:0] packet_bch_sat=(|packet_bch[23:8])?8'hff:packet_bch[7:0];\n",
                "wire [7:0] packet_terc_sat=(|packet_terc[23:8])?8'hff:packet_terc[7:0];\n",
                "wire [7:0] packet_tone_sat=(|packet_tone[23:8])?8'hff:packet_tone[7:0];\n",
            ])
            text = exact_replace(
                text,
                ".debug_memory(debug_memory),\n"
                "    .debug_app_read(memory_app_read),.debug_read_valid(memory_read_valid),\n"
                "    .debug_read_word(memory_read_word),.debug_app_write(memory_app_write),\n"
                "    .debug_write_word(memory_write_word),.debug_read_state(memory_read_state),\n"
                "    .debug_fifo_clear(memory_fifo_clear),.debug_underflow(memory_underflow)",
                ".debug_memory(debug_memory)",
            )
        # This marker spans only the page display, passive snapshots, and probe
        # instances. It ends at the independent seven-segment display instance.
        text, n = re.subn(
            r"// Passive board diagnostics\. These registers have no consumer in media control\..*?(?=status_hex595 #)",
            "/* audited passive diagnostics removed */\n",
            text,
            flags=re.S,
        )
        assert n == 1, f"{name}: expected one passive diagnostic block; found {n}"
        text, n = re.subn(
            r"status_hex595 #\(\.CLK_HZ\(25000000\)\) u_status_hex \(.*?\n\);",
            "",
            text,
            flags=re.S,
        )
        assert n == 1, f"{name}: expected one seven-segment diagnostic instance; found {n}"

    elif candidate and name == "frame_buffer_rgb888.v":
        text = exact_replace(
            text,
            "    output wire [15:0] debug_memory,\n"
            "    output wire debug_app_read, debug_read_valid, debug_app_write,\n"
            "    output wire [31:0] debug_read_word, debug_write_word,\n"
            "    output wire [3:0] debug_read_state,\n"
            "    output wire debug_fifo_clear, debug_underflow,",
            "    output wire [15:0] debug_memory,",
        )
        text = remove_exact_lines(text, [
            "    assign debug_app_read = app_read_en;\n",
            "    assign debug_app_write = app_write_en;\n",
            "    assign debug_write_word = mem_write_word;\n",
            "    assign debug_fifo_clear = read_fifo_clear;\n",
            "    assign debug_underflow = read_underflow;\n",
        ])
        text = exact_replace(
            text,
            "        .debug_write_state(debug_write_state),.debug_write_req_sync(debug_write_req_sync),\n"
            "        .debug_read_state(debug_read_state),.debug_read_valid(debug_read_valid),\n"
            "        .debug_read_word(debug_read_word),\n",
            "        .debug_write_state(debug_write_state),.debug_write_req_sync(debug_write_req_sync),\n",
        )

    elif candidate and name == "frame_read_write.v":
        text = remove_exact_lines(text, [
            "    output wire [3:0] debug_read_state,\n",
            "    output wire debug_read_valid,\n",
            "    output wire [MEM_DATA_BITS-1:0] debug_read_word,\n",
            "assign debug_read_valid = read_capture_valid;\n",
            "assign debug_read_word = read_capture_data;\n",
            "    .debug_read_state(debug_read_state),\n",
        ])

    elif candidate and name == "frame_fifo_read.v":
        text = remove_exact_lines(text, [
            "    output wire [3:0] debug_read_state,\n",
            "assign debug_read_state = state;\n",
        ])

    # This entire module is a diagnostic page formatter. Its source hashes,
    # exact diff, version marker, and page mapping are retained in the receipt.
    return text


def control_tokens(name: str, text: str, candidate: bool) -> str:
    if name == "player_compact_status_pages.v":
        raise ValueError("diagnostic-only module is audited by full-file diff and page map")
    text = strip_observation(name, text, candidate)
    text = re.sub(r"/\*.*?\*/|//[^\n]*", "", text, flags=re.S)
    return re.sub(r"\s+", "", text)


def page_mapping(text: str) -> dict[str, str]:
    mapping: dict[str, str] = {}
    for m in re.finditer(r"4'd(\d+):\s*hex_value\s*=\s*(.*?);", text, flags=re.S):
        mapping[f"page{m.group(1)}"] = re.sub(r"\s+", "", m.group(2))
    default = re.search(r"default:\s*hex_value\s*=\s*(.*?);", text, flags=re.S)
    if default:
        mapping["page15_default"] = re.sub(r"\s+", "", default.group(1))
    return mapping


def top_page_input_mapping(text: str) -> dict[str, str]:
    """Record the exact diagnostic-page inputs at the formatter instance."""
    m = re.search(
        r"player_compact_status_pages\s*#\(.*?\)\s*u_status_pages\s*\((.*?)\n\);",
        text,
        flags=re.S,
    )
    assert m, "status formatter instance missing"
    body = m.group(1)
    result: dict[str, str] = {}
    for page in range(3, 16):
        key = f"diag{page}"
        start = re.search(rf"\.{key}\s*\(", body)
        if not start:
            continue
        pos = start.end()
        depth = 1
        while pos < len(body) and depth:
            if body[pos] == "(":
                depth += 1
            elif body[pos] == ")":
                depth -= 1
            pos += 1
        assert depth == 0, f"unbalanced {key} port"
        result[f"page{page}"] = re.sub(r"\s+", "", body[start.end():pos - 1])
    if "page3" not in result:
        result["page3"] = re.sub(
            r"\s+", "", "{spectrum_debug_frames,4'h0,audio_underflow,3'b000}"
        )
    return result


base_files = {p.relative_to(BASE).as_posix(): p for p in BASE.rglob("*") if p.is_file()}
cand_files = {p.relative_to(CAND).as_posix(): p for p in CAND.rglob("*") if p.is_file()}
missing = sorted(set(base_files) - set(cand_files))
added = sorted(set(cand_files) - set(base_files))
assert not missing, f"candidate missing source files: {missing}"
assert set(added) == EXPECTED_ADDED, f"unexpected source additions: {added}"

entries = []
changed = []
diffs = []
control_results = {}
for rel in sorted(base_files):
    bp, cp = base_files[rel], cand_files[rel]
    same = sha(bp) == sha(cp)
    entry = {
        "path": rel,
        "baseline_sha256": sha(bp),
        "candidate_sha256": sha(cp),
        "byte_identical": same,
    }
    entries.append(entry)
    if same:
        continue
    changed.append(rel)
    btext, ctext = read(bp), read(cp)
    diff = "".join(difflib.unified_diff(
        btext.splitlines(keepends=True), ctext.splitlines(keepends=True),
        fromfile=f"C27/{rel}", tofile=f"C29/{rel}"))
    diff_name = rel.replace("/", "__") + ".diff"
    (OUT / diff_name).write_text(diff, encoding="utf-8")
    diffs.append({"path": diff_name, "sha256": sha(OUT / diff_name)})

    if rel == "hdl_source/player_compact_status_pages.v":
        # Status formatter is wholly diagnostic; retain full source diff/mapping.
        entry["scope"] = "diagnostic_only_full_file_audit"
    else:
        module_name = Path(rel).name
        base_tokens = control_tokens(module_name, btext, False)
        cand_tokens = control_tokens(module_name, ctext, True)
        assert base_tokens == cand_tokens, f"non-diagnostic control tokens differ: {rel}"
        control_results[rel] = {"status": "IDENTICAL_AFTER_EXPLICIT_OBSERVATION_STRIP"}

assert set(changed) == EXPECTED_CHANGED, f"changed-file set differs: {changed}"

# Negative control: invert exactly one boolean selector in ordinary media
# control, then ensure the same normalization detects a real control change.
control_rel = "hdl_source/top_tf_hdmi_audio.v"
base_top = read(base_files[control_rel])
mutant_top = read(cand_files[control_rel])
mutant_top, n = re.subn(
    r"assign sd_card_write_en=video_mode_sd \?",
    "assign sd_card_write_en=!video_mode_sd ?",
    mutant_top,
    count=1,
)
assert n == 1, "negative-control selector not found exactly once"
neg_control_detected = control_tokens("top_tf_hdmi_audio.v", base_top, False) != control_tokens(
    "top_tf_hdmi_audio.v", mutant_top, True)
assert neg_control_detected, "single-bit boolean inversion escaped the control-token check"

base_status = read(base_files["hdl_source/player_compact_status_pages.v"])
cand_status = read(cand_files["hdl_source/player_compact_status_pages.v"])

receipt = {
    "status": "PASS",
    "check": "C27/C29 SHA inventory plus explicit passive-strip control-token equivalence",
    "baseline": "development/player_video27_command_boundary/src/user_source",
    "candidate": "development/player_video29_media_flow/src/user_source",
    "changed": changed,
    "added": added,
    "removed": missing,
    "byte_identical_count": sum(item["byte_identical"] for item in entries),
    "source_file_count": len(entries),
    "inputs": entries,
    "added_file_hashes": [
        {"path": rel, "candidate_sha256": sha(cand_files[rel])}
        for rel in added
    ],
    "control_equivalence": control_results,
    "observation_strips": {
        "top_tf_hdmi_audio.v": [
            "exact C29 memory/packet observation wire declarations",
            "exact frame-buffer debug-port connection group",
            "the named Passive board diagnostics block through the status formatter, including old/new display-page collectors and probe instances",
            "the exact seven-segment status display instance",
        ],
        "frame_buffer_rgb888.v": ["exact added debug output declarations, assigns, and backend connections"],
        "SD/frame_read_write.v": ["exact added debug outputs/assigns and reader-state connection"],
        "SD/frame_fifo_read.v": ["exact debug_read_state output and state assign"],
        "player_compact_status_pages.v": ["entire file audited as diagnostic-only; full SHA and diff retained"],
    },
    "diagnostic_logic_diff_inventory": [
        "Top adds memory-probe and HDMI-packet observation signals and passive module instances.",
        "Top adds frame-buffer connections for app-read/read-valid/read-word/app-write/write-word/reader-state/FIFO-clear/underflow observations.",
        "Top removes the old passive BMP/WAV first-byte counters and header collectors, replacing their old page words with zero.",
        "Top changes the previous photo/error detail word to zero in the SD diagnostic word bank; page 5 is now sourced from the pixel-clock memory-session mailbox.",
        "Top appends memory-reader state and pixel-path flags to page 6 while retaining the existing upper memory diagnostic bits.",
        "Top maps page 3 to packet N and BCH counts, page 14 to packet flags/sample/TERC counts, and page 15 to CTS/tone-error counts.",
        "Status formatter changes build id C11327 to C11329 and replaces the page-3 spectrum/underflow inputs with diag3; pages 1/2 retain their previous mappings.",
        "The full status formatter diff and page 0-15 input mappings are retained in the receipt and diff artifact.",
    ],
    "status_page_mapping": {
        "baseline_version": page_mapping(base_status).get("page0"),
        "candidate_version": page_mapping(cand_status).get("page0"),
        "baseline": page_mapping(base_status),
        "candidate": page_mapping(cand_status),
        "baseline_top_inputs": top_page_input_mapping(read(base_files["hdl_source/top_tf_hdmi_audio.v"])),
        "candidate_top_inputs": top_page_input_mapping(read(cand_files["hdl_source/top_tf_hdmi_audio.v"])),
    },
    "negative_control": {
        "mutation": "Invert the single-bit video_mode_sd selector in assign sd_card_write_en.",
        "detected": neg_control_detected,
        "result": "PASS: normalized media/control tokens differ after the inversion.",
    },
    "diffs": diffs,
    "limits": [
        "This check establishes source-token equivalence outside the explicitly listed diagnostics; it does not prove synthesis reachability or physical behavior.",
        "The page formatter is diagnostic-only and reviewed as a complete source file via recorded SHA-256 and diff.",
    ],
}
(OUT / "passive_delta.json").write_text(json.dumps(receipt, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
print(json.dumps({key: receipt[key] for key in ("status", "changed", "added", "byte_identical_count", "source_file_count", "negative_control")}, ensure_ascii=False))

