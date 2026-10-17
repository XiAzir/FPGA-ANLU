#!/usr/bin/env python3
"""Compare TD EG_PHY_BRAM INIT parameters with the spectrum coefficient ROMs.

This parser handles EG4 9-bit and 18-bit BRAM data/parity packing. It does not
change project sources or synthesis outputs.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
DEFAULT_GATE = ROOT / "build/manual/AC201_tf_hdmi_gate.v"
HDL = ROOT / "src/user_source/hdl_source"


def parse_bram_blocks(text: str) -> list[dict]:
    lines = text.splitlines()
    blocks = []
    for i, line in enumerate(lines):
        meta = re.search(
            r"// address_offset=(\d+);data_offset=(\d+);depth=(\d+);width=(\d+);",
            line,
        )
        if not meta or i + 2 >= len(lines):
            continue
        if "ramread" not in lines[i + 1] or "EG_PHY_BRAM #(" not in lines[i + 2]:
            continue
        ram_name = lines[i + 1].strip("/ ")
        end = i + 3
        while end < len(lines) and not re.search(r"^\s*\\?[^;]+\s+\($", lines[end]):
            end += 1
        block_text = "\n".join(lines[i + 2 : end + 1])
        init = {
            int(index, 16): int(value, 16)
            for index, value in re.findall(
                r"\.INIT_([0-9A-F]{2})\(256'h([0-9A-Fa-f]{64})\)", block_text
            )
        }
        initp = {
            int(index, 16): int(value, 16)
            for index, value in re.findall(
                r"\.INITP_([0-9A-F]{2})\(256'h([0-9A-Fa-f]{64})\)", block_text
            )
        }
        blocks.append(
            {
                "ram": ram_name,
                "address_offset": int(meta.group(1)),
                "data_offset": int(meta.group(2)),
                "depth": int(meta.group(3)),
                "width": int(meta.group(4)),
                "init": init,
                "initp": initp,
            }
        )
    return blocks


def decode_word(block: dict, address: int) -> int:
    """Decode a logical lane word from EG_PHY_BRAM INIT/INITP bit planes."""
    width = block["width"]
    if width <= 9:
        data_bits, parity_bits = 8, 1
    else:
        data_bits, parity_bits = 16, 2

    words_per_init = 256 // data_bits
    words_per_initp = 256 // parity_bits
    data = (block["init"][address // words_per_init] >> ((address % words_per_init) * data_bits))
    data &= (1 << data_bits) - 1
    parity = block["initp"][address // words_per_initp]
    parity >>= (address % words_per_initp) * parity_bits
    parity &= (1 << parity_bits) - 1

    if width <= 9:
        # One parity bit extends each 8-bit data byte to a 9-bit RAM word.
        value = data | (parity << 8)
    else:
        # EG4 stores each 18-bit word as 2x8 data bits + parity at bit 8,
        # then 8 data bits at 9..16 and the second parity bit at bit 17.
        value = (data & 0xFF) | ((parity & 1) << 8)
        value |= ((data >> 8) & ((1 << (width - 9)) - 1)) << 9
        if width == 18:
            value |= ((parity >> 1) & 1) << 17
    return value & ((1 << width) - 1)


def read_mem(path: Path) -> list[int]:
    return [int(token, 16) for token in path.read_text(encoding="ascii").split()]


def audit_one(blocks: list[dict], gate_name: str, mem_path: Path) -> dict:
    lanes = [b for b in blocks if b["ram"] == gate_name]
    if not lanes:
        raise ValueError(f"No BRAM lanes found for {gate_name}")
    expected = read_mem(mem_path)
    depth = lanes[0]["depth"]
    if len(expected) != depth or any(b["depth"] != depth for b in lanes):
        raise ValueError(f"Depth mismatch for {gate_name}: gate={depth}, mem={len(expected)}")
    actual = [0] * depth
    for lane in lanes:
        for address in range(depth):
            actual[address] |= decode_word(lane, address) << lane["data_offset"]
    mismatches = [
        {"address": i, "expected": f"{expected[i]:08x}", "actual": f"{actual[i]:08x}"}
        for i in range(depth)
        if expected[i] != actual[i]
    ]
    return {
        "gate_memory": gate_name,
        "coefficient_file": str(mem_path),
        "depth": depth,
        "width": max((b["data_offset"] + b["width"] for b in lanes), default=0),
        "bram_lanes": [
            {"data_offset": b["data_offset"], "width": b["width"]} for b in lanes
        ],
        "compared_words": depth,
        "mismatches": len(mismatches),
        "first_mismatches": mismatches[:8],
        "expected_sha256": hashlib.sha256(
            b"".join(x.to_bytes(4, "big") for x in expected)
        ).hexdigest(),
        "gate_reconstructed_sha256": hashlib.sha256(
            b"".join(x.to_bytes(4, "big") for x in actual)
        ).hexdigest(),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--gate-verilog", type=Path, default=DEFAULT_GATE)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    blocks = parse_bram_blocks(args.gate_verilog.read_text(encoding="utf-8", errors="replace"))
    result = {
        "gate_verilog": str(args.gate_verilog.resolve()),
        "gate_verilog_sha256": hashlib.sha256(args.gate_verilog.read_bytes()).hexdigest(),
        "coefficient_roms": [
            audit_one(blocks, "u_pcm_waveform/u_spectrum/ramread6_syn_4_1024x16", HDL / "spectrum_hann.mem"),
            audit_one(blocks, "u_pcm_waveform/u_spectrum/ramread4_syn_4_512x32", HDL / "spectrum_twiddle.mem"),
        ],
    }
    result["all_match"] = all(item["mismatches"] == 0 for item in result["coefficient_roms"])
    report = json.dumps(result, indent=2)
    if args.output:
        args.output.write_text(report + "\n", encoding="utf-8")
    print(report)
    return 0 if result["all_match"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
