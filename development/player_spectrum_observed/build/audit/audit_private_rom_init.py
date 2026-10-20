#!/usr/bin/env python3
"""Decode EG_PHY_BRAM INIT/INITP from the independent TD probe gate netlist."""
from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


def read_words(path: Path) -> list[int]:
    return [int(word, 16) for word in path.read_text(encoding="ascii").split()]


def extract_blocks(gate: str) -> dict[str, dict[str, dict[int, int]]]:
    result = {}
    for match in re.finditer(r"EG_PHY_BRAM\s*#\((.*?)\)\s+\\(\S+)\s*\(", gate, re.S):
        name_match = re.search(r"(?:^|/)u_(hann_low|hann_high|twiddle_low|twiddle_high)$", match.group(2))
        if name_match is None:
            continue
        name = name_match.group(1)
        if name in result:
            raise ValueError(f"Duplicate coefficient bank {name}")
        block = match.group(1)
        planes: dict[str, dict[int, int]] = {"init": {}, "initp": {}}
        pattern = re.compile(r"\.INIT(P?)_([0-9A-F]{2})\s*\(\s*256'b([01\s]+)\s*\)|\.INIT(P?)_([0-9A-F]{2})\s*\(\s*256'h([0-9A-Fa-f\s]+)\s*\)", re.S)
        for m in pattern.finditer(block):
            if m.group(1) is not None:
                p, idx, bits = m.group(1), m.group(2), re.sub(r"\s+", "", m.group(3))
                value = int(bits, 2)
            else:
                p, idx, bits = m.group(4), m.group(5), re.sub(r"\s+", "", m.group(6))
                value = int(bits, 16)
            planes["initp" if p else "init"][int(idx, 16)] = value
        result[name] = planes
    return result


def decode(planes: dict[str, dict[int, int]], depth: int, width: int) -> list[int]:
    data_bits, parity_bits = (8, 1) if width <= 9 else (16, 2)
    out = []
    for address in range(depth):
        d = planes["init"][address // (256 // data_bits)] >> ((address % (256 // data_bits)) * data_bits)
        d &= (1 << data_bits) - 1
        p = planes["initp"][address // (256 // parity_bits)] >> ((address % (256 // parity_bits)) * parity_bits)
        p &= (1 << parity_bits) - 1
        if width <= 9:
            value = d | (p << 8)
        else:
            upper_bits = 8 if width == 18 else width - 9
            value = (d & 0xFF) | ((p & 1) << 8)
            value |= ((d >> 8) & ((1 << upper_bits) - 1)) << 9
            if width == 18:
                value |= ((p >> 1) & 1) << 17
        out.append(value & ((1 << width) - 1))
    return out


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--gate", type=Path, default=Path(__file__).parents[1] / "build/spectrum_coeff_rom_probe_gate.v")
    ap.add_argument("--hann", type=Path, default=Path(__file__).with_name("spectrum_hann.mem"))
    ap.add_argument("--twiddle", type=Path, default=Path(__file__).with_name("spectrum_twiddle.mem"))
    ap.add_argument("--output", type=Path, default=Path(__file__).parents[1] / "build/probe_gate_init_audit.json")
    ap.add_argument("--log", type=Path, default=Path(__file__).parents[1] / "build/synthesis_console.log")
    args = ap.parse_args()
    log = args.log.read_text(encoding="utf-8", errors="replace")
    effective = re.findall(r"start command \"set_param (?:-run syn_1 )?gate eram_init (on|off)\"", log)
    complete = ("SYNTHESIS_COMPLETE_WITH_GATE_DATABASE" in log or
                "ROM_PROBE_SYNTHESIS_COMPLETE_ERAM_INIT_OFF" in log)
    if ("Update param syn_1 gate::eram_init::off succeed." not in log or
            not effective or effective[-1] != "off" or not complete):
        raise SystemExit("TD synthesis log does not prove successful eram_init off probe completion")
    blocks = extract_blocks(args.gate.read_text(encoding="utf-8", errors="replace"))
    if set(blocks) != {"hann_low", "hann_high", "twiddle_low", "twiddle_high"}:
        raise SystemExit(f"Expected four coefficient BRAMs; found {sorted(blocks)}")
    hann, twiddle = read_words(args.hann), read_words(args.twiddle)
    lanes = {
        "hann_low": (hann, 1024, 9, lambda w: w & 0x1FF),
        "hann_high": (hann, 1024, 9, lambda w: (w >> 9) & 0x7F),
        "twiddle_low": (twiddle, 512, 18, lambda w: w & 0x3FFFF),
        "twiddle_high": (twiddle, 512, 18, lambda w: (w >> 18) & 0x3FFF),
    }
    result = {"gate": str(args.gate.resolve()), "gate_sha256": hashlib.sha256(args.gate.read_bytes()).hexdigest(),
              "synthesis_log": str(args.log.resolve()), "synthesis_log_sha256": hashlib.sha256(args.log.read_bytes()).hexdigest(),
              "eram_init_off": True, "lanes": {}}
    reconstructed = {}
    for name, (source, depth, width, select) in lanes.items():
        actual = decode(blocks[name], depth, width)
        expected = [select(w) for w in source]
        mismatches = [i for i, (a, e) in enumerate(zip(actual, expected)) if a != e]
        reconstructed[name] = actual
        result["lanes"][name] = {"depth": depth, "width": width, "nonzero_words": sum(bool(v) for v in actual),
                                 "mismatches": len(mismatches), "first_mismatch_addresses": mismatches[:8],
                                 "sha256": hashlib.sha256(b"".join(v.to_bytes(4, "big") for v in actual)).hexdigest()}
    actual_hann = [reconstructed["hann_low"][i] | (reconstructed["hann_high"][i] << 9) for i in range(1024)]
    actual_twiddle = [reconstructed["twiddle_low"][i] | (reconstructed["twiddle_high"][i] << 18) for i in range(512)]
    result["combined_roms"] = {
        "hann": {"words": len(actual_hann), "nonzero_words": sum(bool(v) for v in actual_hann),
                 "mismatches": sum(a != e for a, e in zip(actual_hann, hann)),
                 "sha256": hashlib.sha256(b"".join(v.to_bytes(4, "big") for v in actual_hann)).hexdigest()},
        "twiddle": {"words": len(actual_twiddle), "nonzero_words": sum(bool(v) for v in actual_twiddle),
                    "mismatches": sum(a != e for a, e in zip(actual_twiddle, twiddle)),
                    "sha256": hashlib.sha256(b"".join(v.to_bytes(4, "big") for v in actual_twiddle)).hexdigest()},
    }
    result["all_match"] = all(v["mismatches"] == 0 for v in result["lanes"].values()) and all(v["mismatches"] == 0 for v in result["combined_roms"].values())
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))
    return 0 if result["all_match"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
