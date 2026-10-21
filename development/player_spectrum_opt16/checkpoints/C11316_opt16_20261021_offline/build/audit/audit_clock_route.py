#!/usr/bin/env python3
"""Read-only audit for the C11316 serializer/global-clock routed netlist."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parents[4]
PROJECT_ROOT = REPO_ROOT / "development" / "player_spectrum_opt16"
BASELINE_ROOT = REPO_ROOT / "development" / "player_spectrum_tf_margin"
BASELINE_NETLIST = BASELINE_ROOT / "build" / "audit" / "routed_implementation.v"
BASELINE_TIMING = BASELINE_ROOT / "build" / "manual" / "AC201_tf_hdmi_pr.timing"
HDMI_PADS = {
    "HDMI_CLK_P": "HDMI_CLK_P_syn_2",
    "HDMI_D0_P": "HDMI_D0_P_syn_2",
    "HDMI_D1_P": "HDMI_D1_P_syn_2",
    "HDMI_D2_P": "HDMI_D2_P_syn_2",
}
SEG_PADS = ("seg7_dio", "seg7_sclk", "seg7_rclk")
LANE_REGS = ("sync", "load_en", "pending_data", "shift_data", "oddr_data")


@dataclass
class Cell:
    kind: str
    name: str
    params: dict[str, str]
    ports: dict[str, str]


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8-sig", errors="replace")


def canonical_net(expr: str) -> str:
    value = re.sub(r"\s+", "", expr.strip())
    value = value.replace("\\", "")
    value = re.sub(r"_dup_\d+", "", value)
    return value


def skip_space(text: str, pos: int) -> int:
    while pos < len(text) and text[pos].isspace():
        pos += 1
    return pos


def balanced(text: str, open_pos: int) -> tuple[str, int]:
    if open_pos >= len(text) or text[open_pos] != "(":
        raise ValueError("expected an opening parenthesis")
    depth = 0
    for pos in range(open_pos, len(text)):
        if text[pos] == "(":
            depth += 1
        elif text[pos] == ")":
            depth -= 1
            if depth == 0:
                return text[open_pos + 1 : pos], pos + 1
    raise ValueError("unclosed parenthesis in netlist")


def split_top_level(text: str) -> list[str]:
    parts: list[str] = []
    start = 0
    stack: list[str] = []
    pairs = {")": "(", "]": "[", "}": "{"}
    for pos, char in enumerate(text):
        if char in "([{":
            stack.append(char)
        elif char in ")]}" and stack and stack[-1] == pairs[char]:
            stack.pop()
        elif char == "," and not stack:
            parts.append(text[start:pos].strip())
            start = pos + 1
    tail = text[start:].strip()
    if tail:
        parts.append(tail)
    return parts


def named_values(body: str) -> dict[str, str]:
    values: dict[str, str] = {}
    pos = 0
    while pos < len(body):
        match = re.search(r"\.([A-Za-z_$][\w$]*)\s*\(", body[pos:])
        if not match:
            break
        name = match.group(1)
        open_pos = pos + match.end() - 1
        value, end = balanced(body, open_pos)
        values[name] = value.strip()
        pos = end
    return values


def parse_cells(text: str) -> list[Cell]:
    text = re.sub(r"/\*.*?\*/", " ", text, flags=re.S)
    text = re.sub(r"//[^\r\n]*", " ", text)
    type_re = re.compile(r"\b(?P<kind>(?:EG|EF|SF|PH1P?|DR1|AL_MAP)_[A-Z0-9_]+)\b")
    cells: list[Cell] = []
    for match in type_re.finditer(text):
        pos = skip_space(text, match.end())
        params: dict[str, str] = {}
        if pos < len(text) and text[pos] == "#":
            pos = skip_space(text, pos + 1)
            if pos >= len(text) or text[pos] != "(":
                continue
            param_body, pos = balanced(text, pos)
            params = named_values(param_body)
            pos = skip_space(text, pos)
        if pos >= len(text):
            continue
        if text[pos] == "\\":
            name_start = pos
            while pos < len(text) and not text[pos].isspace():
                pos += 1
            name = text[name_start:pos].strip()
        else:
            name_match = re.match(r"[A-Za-z_$][\w$]*", text[pos:])
            if not name_match:
                continue
            name = name_match.group(0)
            pos += name_match.end()
        pos = skip_space(text, pos)
        if pos >= len(text) or text[pos] != "(":
            continue
        try:
            port_body, _ = balanced(text, pos)
        except ValueError:
            continue
        ports = named_values(port_body)
        if ports:
            cells.append(Cell(match.group("kind"), name, params, ports))
    return cells


def pll_outputs(cells: list[Cell]) -> list[dict[str, str]]:
    result: list[dict[str, str]] = []
    for cell in cells:
        if cell.kind != "EG_PHY_PLL" or "clkc" not in cell.ports:
            continue
        expr = cell.ports["clkc"].strip()
        if expr.startswith("{") and expr.endswith("}"):
            bits = split_top_level(expr[1:-1])
            # EG4 clkc is [4:0]; concatenation operands are ordered [4]..[0].
            if len(bits) == 5:
                indexed = {4 - idx: bit for idx, bit in enumerate(bits)}
            else:
                indexed = {}
        else:
            indexed = {}
        result.append(
            {
                "instance": cell.name,
                "clkc0": indexed.get(0, ""),
                "clkc1": indexed.get(1, ""),
            }
        )
    return result


def gclk_map(cells: list[Cell]) -> list[dict[str, str]]:
    result = []
    for cell in cells:
        if cell.kind == "EG_PHY_GCLK":
            result.append(
                {
                    "instance": cell.name,
                    "clki": cell.ports.get("clki", "").strip(),
                    "clko": cell.ports.get("clko", "").strip(),
                }
            )
    return result


def output_pad_cells(cells: list[Cell]) -> dict[str, Cell]:
    pads: dict[str, Cell] = {}
    wanted = set(HDMI_PADS) | set(SEG_PADS)
    for cell in cells:
        if cell.kind != "EG_PHY_PAD":
            continue
        output = canonical_net(cell.ports.get("opad", ""))
        if output in wanted:
            pads[output] = cell
    return pads


def expected_clocks(cells: list[Cell]) -> dict[str, Any]:
    plls = pll_outputs(cells)
    video_pll = next((p for p in plls if "video_pll" in p["instance"]), None)
    system_pll = next((p for p in plls if "sys_pll" in p["instance"]), None)
    gclks = gclk_map(cells)

    def gclk_out_for(raw: str) -> str:
        if not raw:
            return ""
        for gclk in gclks:
            if canonical_net(gclk["clki"]) == canonical_net(raw):
                return gclk["clko"]
        return ""

    serial_raw = video_pll["clkc1"] if video_pll else ""
    serial_buffer = next(
        (
            g for g in gclks
            if "u_hdmi_serial_bufg" in g["instance"]
            and canonical_net(g["clki"]) == canonical_net(serial_raw)
        ),
        None,
    )
    serial = serial_buffer["clko"] if serial_buffer else serial_raw
    pixel = gclk_out_for(video_pll["clkc0"]) if video_pll else ""
    system = gclk_out_for(system_pll["clkc0"]) if system_pll else ""
    return {
        "plls": plls,
        "video_pll": video_pll,
        "system_pll": system_pll,
        "gclks": gclks,
        "serial_raw": serial_raw,
        "serial_buffer": serial_buffer,
        "serial": serial,
        "pixel": pixel,
        "system": system,
    }


def source_evidence() -> dict[str, Any]:
    build_dir = PROJECT_ROOT / "build" / "manual"
    evidence_dir = build_dir / "stage_evidence"
    source_manifest_path = build_dir / "build_source_scope.json"
    latest_path = evidence_dir / "latest_synthesis.json"
    result: dict[str, Any] = {"checks": [], "record": {}, "scope_hash": "", "gate_db_hash": ""}
    if not source_manifest_path.exists() or not latest_path.exists():
        result["checks"].append(("WARN", "缺少 C11316 source manifest 或 latest_synthesis 证据"))
        return result

    manifest = json.loads(read_text(source_manifest_path))
    normalized_scope = [
        {"path": item["path"].replace("\\", "/"), "sha256": item["sha256"].lower()}
        for item in manifest
    ]
    scope_hash = hashlib.sha256(
        json.dumps(normalized_scope, separators=(",", ":"), ensure_ascii=False).encode("utf-8")
    ).hexdigest()
    result["scope_hash"] = scope_hash

    mismatches = []
    source_root = PROJECT_ROOT / "src"
    for item in manifest:
        rel = Path(item["path"].replace("\\", "/"))
        source = source_root / rel
        actual = sha256_file(source).upper() if source.is_file() else "MISSING"
        if actual != item["sha256"].upper():
            mismatches.append(item["path"])

    latest = json.loads(read_text(latest_path))
    record_path = evidence_dir / latest.get("record", "")
    record = json.loads(read_text(record_path)) if record_path.is_file() else {}
    result["record"] = record
    result["gate_db_hash"] = record.get("gateDbHash", "")
    gate_db = build_dir / "AC201_tf_hdmi_gate.db"
    actual_db_hash = sha256_file(gate_db) if gate_db.is_file() else ""

    if record.get("scopeHash") == scope_hash and not mismatches:
        result["checks"].append(("PASS", f"source manifest 与当前源文件一致；scopeHash={scope_hash}"))
    else:
        detail = ", ".join(mismatches[:6]) if mismatches else "scopeHash 与 manifest 不一致"
        result["checks"].append(("FAIL", f"gate sourceHash/scopeHash 未绑定到当前源：{detail}"))
    if latest.get("status") == "success" and record.get("runId") == latest.get("runId"):
        result["checks"].append(("PASS", f"synthesis evidence PASS：runId={record.get('runId')}"))
    else:
        result["checks"].append(("WARN", f"synthesis evidence 当前状态={latest.get('status')}，尚不能认证 gate 归属"))
    if record.get("gateDbHash") and actual_db_hash == record.get("gateDbHash"):
        result["checks"].append(("PASS", f"gate database hash 匹配：{actual_db_hash}"))
    else:
        result["checks"].append(("FAIL", "gate database 不存在或 hash 与 synthesis evidence 不匹配"))

    physical_latest = evidence_dir / "latest_physical.json"
    if physical_latest.is_file():
        physical_pointer = json.loads(read_text(physical_latest))
        physical_path = evidence_dir / physical_pointer.get("record", "")
        physical = json.loads(read_text(physical_path)) if physical_path.is_file() else {}
        result["physical"] = physical
        result["physical_pointer"] = physical_pointer
        result["physical_record_path"] = str(physical_path.resolve())
        linked = (
            physical.get("synthesisRunId") == record.get("runId")
            and physical.get("gateDbHash") == record.get("gateDbHash")
            and physical.get("scopeHash") == record.get("scopeHash")
        )
        state = physical_pointer.get("status", "missing")
        status = "PASS" if linked else ("WARN" if state == "running" else "FAIL")
        result["checks"].append((status, f"physical evidence {state}; synthesisRunId/gateDbHash/scopeHash {'匹配' if linked else '未匹配'}"))
    return result


def check_candidate_netlist(cells: list[Cell], raw_hash: str) -> tuple[list[tuple[str, str]], dict[str, Any]]:
    checks: list[tuple[str, str]] = []
    expected = expected_clocks(cells)
    checks.append(("INFO", f"netlist SHA256={raw_hash}"))
    checks.append(("INFO", f"PLL clkc1 raw={expected['serial_raw'] or '未识别'}"))
    checks.append(("INFO", f"GCLK 数量={len(expected['gclks'])}；实例={', '.join(g['instance'] for g in expected['gclks']) or '无'}"))

    video_pll = expected["video_pll"]
    if video_pll and expected["serial_raw"]:
        checks.append(("PASS", f"EG_PHY_PLL {video_pll['instance']} 的 clkc[1] 映射为 {expected['serial_raw']}"))
    else:
        checks.append(("FAIL", "无法从 video_pll EG_PHY_PLL.clkc[1] 确认 serial raw clock"))
    if expected["serial_buffer"] and canonical_net(expected["serial_buffer"]["clko"]) == canonical_net(expected["serial"]):
        checks.append(("PASS", f"clkc1 raw → u_hdmi_serial_bufg EG_PHY_GCLK → {expected['serial']}"))
    else:
        checks.append(("FAIL", "缺少 raw PLL clkc1 到 u_hdmi_serial_bufg 的物理 GCLK 路径"))
    if len(expected["gclks"]) == 3 and expected["serial_buffer"]:
        checks.append(("PASS", "物理网表保留 3 个 EG_PHY_GCLK（含 serializer buffer）"))
    else:
        checks.append(("FAIL", f"预期 3 个 EG_PHY_GCLK，实得 {len(expected['gclks'])}"))

    pads = output_pad_cells(cells)
    pad_data: dict[str, Any] = {}
    for port, instance in HDMI_PADS.items():
        cell = pads.get(port)
        if not cell:
            checks.append(("FAIL", f"缺少 HDMI 输出 PAD {port}"))
            continue
        item = {
            "instance": cell.name,
            "ddrmode": cell.params.get("ODDRMODE", ""),
            "iotype": cell.params.get("IOTYPE", ""),
            "reset": cell.ports.get("rst", ""),
            "osclk": cell.ports.get("osclk", ""),
            "out_s_clk_mux": cell.params.get("OUTSCLKMUX", ""),
            "do": cell.ports.get("do", ""),
        }
        pad_data[port] = item
        if item["ddrmode"] == '"DDRX1"' and item["iotype"] == '"LVDS33_E"':
            checks.append(("PASS", f"{port}: ODDRMODE=DDRX1, IOTYPE=LVDS33_E"))
        else:
            checks.append(("FAIL", f"{port}: ODDRMODE={item['ddrmode']}, IOTYPE={item['iotype']}"))
        if expected["serial"] and canonical_net(item["osclk"]) == canonical_net(expected["serial"]):
            checks.append(("PASS", f"{port}.osclk={item['osclk']}（serializer GCLK 输出）"))
        else:
            checks.append(("FAIL", f"{port}.osclk={item['osclk']} 与 serializer GCLK 不一致"))

    lane_records: list[dict[str, str]] = []
    lane_class_counts = {kind: 0 for kind in LANE_REGS}
    for lane in range(4):
        matched: dict[str, list[Cell]] = {kind: [] for kind in LANE_REGS}
        token = f"u_hdmi2phy_wrapper/u{lane}_lane_lvds_8_1"
        for cell in cells:
            q = cell.ports.get("q", "")
            if not q or "clk" not in cell.ports:
                continue
            identity = canonical_net(cell.name + " " + q)
            if token not in identity:
                continue
            if re.search(r"/S_odd_even_[12]d(?:\[|\b)", canonical_net(q)):
                matched["sync"].append(cell)
            for reg_kind in ("load_en", "pending_data", "shift_data", "oddr_data"):
                if re.search(rf"/S_{reg_kind}(?:\[|\b)", canonical_net(q)):
                    matched[reg_kind].append(cell)
        for reg_kind, group in matched.items():
            if not group:
                checks.append(("INFO", f"lane{lane} {reg_kind}: 网表中无独立寄存器，可能由跨 lane 共享控制或常量数据优化消除"))
                continue
            lane_class_counts[reg_kind] += len(group)
            want_clock = expected["serial"]
            want_mux = "INV" if reg_kind == "oddr_data" else "CLK"
            mismatches = []
            mux_values = set()
            for cell in group:
                actual_clock = cell.ports.get("clk", "")
                mux = cell.params.get("CLKMUX", "").strip('"').upper()
                mux_values.add(mux or "<absent>")
                if want_clock and canonical_net(actual_clock) != canonical_net(want_clock):
                    mismatches.append(f"{cell.name}: clk={actual_clock}")
                if mux and mux != want_mux:
                    mismatches.append(f"{cell.name}: CLKMUX={mux}, expected={want_mux}")
            # INV is a legal clock selection on EG4 LSLICE/MSLICE, and is required
            # here to preserve the RTL's falling-edge ODDR-data preparation.
            cell_kinds = {cell.kind for cell in group}
            allowed = {
                "EG_PHY_LSLICE": {"CLK", "INV", "1", "0"},
                "EG_PHY_MSLICE": {"CLK", "INV", "SIG", "1", "0"},
                "AL_MAP_SEQ": {"CLK", "INV"},
            }
            for cell in group:
                mux = cell.params.get("CLKMUX", "").strip('"').upper()
                if mux and cell.kind in allowed and mux not in allowed[cell.kind]:
                    mismatches.append(f"{cell.name}: 非法 {cell.kind}.CLKMUX={mux}")
            role_ok = not mismatches and bool(want_clock)
            checks.append(("PASS" if role_ok else "FAIL", f"lane{lane} {reg_kind}: {len(group)} cell(s), CLK={want_clock or '未识别'}, CLKMUX={','.join(sorted(mux_values))}; {'有效边沿/时钟匹配' if role_ok else '; '.join(mismatches)}"))
            lane_records.extend(
                {
                    "lane": str(lane),
                    "role": reg_kind,
                    "cell": cell.name,
                    "kind": cell.kind,
                    "clock": cell.ports.get("clk", ""),
                    "clkmux": cell.params.get("CLKMUX", ""),
                }
                for cell in group
            )
    for reg_kind, count in lane_class_counts.items():
        checks.append(("PASS" if count else "FAIL", f"lane aggregate {reg_kind}: {count} explicit register cell(s)"))

    for port in SEG_PADS:
        cell = pads.get(port)
        if not cell:
            checks.append(("FAIL", f"缺少数码管 PAD {port}"))
            continue
        clock = cell.ports.get("osclk", "")
        if expected["system"] and canonical_net(clock) == canonical_net(expected["system"]):
            checks.append(("PASS", f"{port}.osclk={clock}（system PLL GCLK 输出）"))
        else:
            checks.append(("FAIL", f"{port}.osclk={clock}，预期 system GCLK={expected['system'] or '未识别'}"))

    mailbox_domains = {
        "source/video": ("held_hex", "request_toggle", "acknowledgement_sync"),
        "destination/system": ("destination_hex", "request_sync", "acknowledgement_toggle"),
    }
    for domain, names in mailbox_domains.items():
        want_clock = expected["pixel"] if domain.startswith("source") else expected["system"]
        group: list[Cell] = []
        for cell in cells:
            q = canonical_net(cell.ports.get("q", ""))
            if "u_status_mailbox/" not in q:
                continue
            if any(f"/{name}" in q for name in names):
                group.append(cell)
        wrong = [cell for cell in group if not want_clock or canonical_net(cell.ports.get("clk", "")) != canonical_net(want_clock)]
        if group and not wrong:
            checks.append(("PASS", f"mailbox {domain}: {len(group)} FF cell(s), CLK={want_clock}"))
        else:
            checks.append(("FAIL", f"mailbox {domain}: expected clock={want_clock or '未识别'}，FF={len(group)}，wrong={len(wrong)}"))

    return checks, {
        "expected": expected,
        "pads": pad_data,
        "lane_registers": lane_records,
        "gclk_count": len(expected["gclks"]),
    }


def timing_summary(path: Path, candidate: bool) -> dict[str, Any]:
    if not path.is_file():
        return {"available": False, "fresh": False, "reason": "timing summary not generated"}
    text = read_text(path)
    constraint_match = re.search(r"^Constraint File\s*:\s*(.+)$", text, flags=re.M)
    constraint = constraint_match.group(1).strip().rstrip(";") if constraint_match else ""
    if not candidate:
        fresh = True
    elif constraint:
        fresh = "player_spectrum_opt16" in constraint.lower()
    else:
        fresh = "player_spectrum_opt16" in str(path).lower()
    report_stats: dict[str, str] = {}
    for key in ("SWNS", "STNS", "HWNS", "HTNS", "Period Check WNS"):
        match = re.search(rf"\b{re.escape(key)}\s*:\s*([-+0-9.]+)\s*ns", text)
        if match:
            report_stats[key] = match.group(1)
    clock_row = None
    for line in text.splitlines():
        cols = line.split()
        if len(cols) >= 16 and cols[0].startswith("clk") and cols[1] in ("local", "global", "network") and cols[-3].isdigit():
            if cols[0] == "clk4" or "125.000" in cols:
                if "125.000" in cols or "hdmi_5x_clk" in line:
                    clock_row = {
                        "line": line.strip(),
                        "name": cols[0],
                        "frequency_mhz": cols[5],
                        "rise_ns": cols[2],
                        "fall_ns": cols[3],
                        "swns_ns": cols[8],
                        "hwns_ns": cols[10],
                        "skew_ns": cols[12],
                        "fanout": cols[13],
                    }
                    break
    path_records = []
    lines = text.splitlines()
    for idx, line in enumerate(lines):
        if not re.search(r"End Point\s*:\s*HDMI_(?:CLK|D[012])_P_syn_2\.do\[", line):
            continue
        start = idx
        while start > 0 and not re.search(r"Begin Point\s*:", lines[start]):
            start -= 1
        end = idx + 1
        while end < len(lines) and not re.search(r"Begin Point\s*:", lines[end]):
            end += 1
        block = "\n".join(lines[start:end])
        slack = re.search(r"Slack\s*:\s*([-+0-9.]+)ns", block)
        begin = re.search(r"Begin Point\s*:\s*(.+)", block)
        check = re.search(r"Check Type\s*:\s*(\w+)", block)
        skew = re.search(r"Clock Skew\s*:\s*([-+0-9.]+)ns", block)
        budget = re.search(r"Budget\s*:\s*([^\r\n]+)", block)
        path_records.append(
            {
                "endpoint": line.split(":", 1)[1].strip(),
                "slack_ns": slack.group(1) if slack else "",
                "begin": begin.group(1).strip() if begin else "",
                "check": check.group(1).lower() if check else "",
                "skew_ns": skew.group(1) if skew else "",
                "budget": budget.group(1).strip() if budget else "",
            }
        )
    return {
        "available": True,
        "fresh": fresh,
        "reason": "" if fresh else "timing report Constraint File/path points outside C11316; stale report excluded",
        "path": str(path),
        "sha256": sha256_file(path),
        "constraint": constraint,
        "report_stats": report_stats,
        "serial_clock": clock_row,
        "pad_do_paths": path_records,
    }


def baseline_summary(netlist_path: Path = BASELINE_NETLIST, timing_path: Path = BASELINE_TIMING) -> dict[str, Any]:
    result: dict[str, Any] = {"netlist": {}, "timing": {}, "evidence": {}}
    if netlist_path.is_file():
        cells = parse_cells(read_text(netlist_path))
        expected = expected_clocks(cells)
        pads = output_pad_cells(cells)
        result["netlist"] = {
            "path": str(netlist_path),
            "sha256": sha256_file(netlist_path),
            "gclk_count": len(expected["gclks"]),
            "video_pll": expected["video_pll"],
            "serial_raw": expected["serial_raw"],
            "serial": expected["serial"],
            "pads": {
                port: {
                    "ddrmode": cell.params.get("ODDRMODE", ""),
                    "iotype": cell.params.get("IOTYPE", ""),
                    "reset": cell.ports.get("rst", ""),
                    "osclk": cell.ports.get("osclk", ""),
                }
                for port, cell in pads.items()
                if port in HDMI_PADS
            },
        }
    if timing_path.is_file():
        result["timing"] = timing_summary(timing_path, candidate=False)
    evidence_dir = BASELINE_ROOT / "build" / "manual" / "stage_evidence"
    for stage in ("physical", "bitstream"):
        pointer_path = evidence_dir / f"latest_{stage}.json"
        if not pointer_path.is_file():
            continue
        pointer = json.loads(read_text(pointer_path))
        record_path = evidence_dir / pointer.get("record", "")
        record = json.loads(read_text(record_path)) if record_path.is_file() else {}
        result["evidence"][stage] = {
            "status": pointer.get("status"),
            "runId": record.get("runId"),
            "synthesisRunId": record.get("synthesisRunId"),
            "scopeHash": record.get("scopeHash"),
            "gateDbHash": record.get("gateDbHash"),
            "bitHash": record.get("bitHash"),
        }
    return result


def md_escape(value: Any) -> str:
    return str(value).replace("|", "\\|").replace("\n", " ")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--netlist", required=True, type=Path, help="C11316 gate/routed Verilog netlist")
    parser.add_argument("--timing", required=True, type=Path, help="C11316 routed timing report; pass its expected path even while pending")
    parser.add_argument("--output", required=True, type=Path, help="Markdown audit report path")
    parser.add_argument("--run-id", required=True, help="successful C11316 synthesis run ID to bind")
    parser.add_argument("--baseline-netlist", type=Path, default=BASELINE_NETLIST)
    parser.add_argument("--baseline-timing", type=Path, default=BASELINE_TIMING)
    args = parser.parse_args()

    if not args.netlist.is_file():
        parser.error(f"netlist does not exist: {args.netlist}")

    candidate_text = read_text(args.netlist)
    cells = parse_cells(candidate_text)
    candidate_hash = sha256_file(args.netlist)
    checks, netlist_detail = check_candidate_netlist(cells, candidate_hash)
    evidence = source_evidence()
    synthesis_record = evidence.get("record", {})
    if synthesis_record.get("status") != "success" or synthesis_record.get("runId") != args.run_id:
        raise SystemExit(f"latest successful synthesis record does not match requested runId {args.run_id}")
    physical_record = evidence.get("physical", {})
    if (evidence.get("physical_pointer", {}).get("status") != "success" or
        physical_record.get("synthesisRunId") != args.run_id or
        physical_record.get("gateDbHash") != synthesis_record.get("gateDbHash") or
        physical_record.get("scopeHash") != synthesis_record.get("scopeHash")):
        raise SystemExit("latest successful physical record is not linked to the requested synthesis run")
    routed_path = PROJECT_ROOT / "build" / "audit" / "routed_implementation.v"
    if args.netlist.resolve() != routed_path.resolve():
        raise SystemExit(f"routed clock audit requires the parent-exported netlist: {routed_path}")
    physical_artifacts = physical_record.get("artifacts", {})
    route_db = PROJECT_ROOT / "build" / "manual" / "AC201_tf_hdmi_pr.db"
    expected_route_db_hash = physical_artifacts.get("AC201_tf_hdmi_pr.db")
    if not expected_route_db_hash or sha256_file(route_db) != expected_route_db_hash:
        raise SystemExit("current routed database SHA does not match the successful physical record")
    if routed_path.stat().st_mtime < datetime.fromisoformat(physical_record["completedUtc"].replace("Z", "+00:00")).timestamp():
        raise SystemExit("exported routed netlist predates successful physical completion")
    checks.extend(evidence.get("checks", []))
    timing = timing_summary(args.timing, candidate=True)
    if not timing.get("available") or not timing.get("fresh"):
        raise SystemExit(f"routed timing report is absent or outside the current C11316 project scope: {args.timing}")
    baseline = baseline_summary(args.baseline_netlist, args.baseline_timing)
    physical = evidence.get("physical", {})
    timing_artifacts = physical.get("artifacts", {}) if isinstance(physical, dict) else {}
    # Native hold repair replaces the routed timing files. Bind to its current
    # certified artifacts only when it belongs to this exact synthesis run.
    hold_pointer_path = PROJECT_ROOT / 'build/manual/stage_evidence/latest_hold.json'
    if hold_pointer_path.is_file():
        hold_pointer = json.loads(read_text(hold_pointer_path))
        hold_record_path = hold_pointer_path.parent / hold_pointer.get('record', '')
        hold_record = json.loads(read_text(hold_record_path)) if hold_record_path.is_file() else {}
        if (hold_pointer.get('status') == 'success' and
            hold_record.get('synthesisRunId') == evidence.get('record', {}).get('runId') and
            hold_record.get('gateDbHash') == evidence.get('record', {}).get('gateDbHash')):
            timing_artifacts = hold_record.get('artifacts', {})
            evidence['active_hold'] = hold_record
    bound_timing_hash = timing_artifacts.get(args.timing.name)
    if timing.get("available") and bound_timing_hash:
        bound = bound_timing_hash == timing["sha256"]
        checks.append(("PASS" if bound else "FAIL", f"timing report hash {'匹配' if bound else '不匹配'} physical evidence：{args.timing.name}"))
    elif timing.get("available") and timing.get("fresh"):
        checks.append(("FAIL", f"physical evidence 未记录 timing 文件 {args.timing.name} 的 hash"))

    baseline_pads = baseline.get("netlist", {}).get("pads", {})
    for port in HDMI_PADS:
        new = netlist_detail["pads"].get(port)
        old = baseline_pads.get(port)
        if not new or not old:
            checks.append(("FAIL", f"{port}: 缺少新/基线 PAD 参数用于对比"))
            continue
        equal = (
            new["ddrmode"] == old["ddrmode"]
            and new["iotype"] == old["iotype"]
            and canonical_net(new["reset"]) == canonical_net(old["reset"])
        )
        checks.append(("PASS" if equal else "FAIL", f"{port}: DDRMODE/IOTYPE/reset 与 C11308 基线{'一致' if equal else '不同'} (reset {old['reset']} → {new['reset']})"))

    if timing["available"] and timing["fresh"]:
        checks.append(("PASS", f"timing summary 属于 C11316，SHA256={timing['sha256']}"))
    elif timing["available"]:
        checks.append(("WARN", timing["reason"]))
    else:
        checks.append(("WARN", "C11316 routed timing summary 尚未生成；未从旧 final_timing.rpt 推断新候选时序"))

    lines = [
        "# C11316 serializer clock / routed netlist audit",
        "",
        f"Synthesis run ID: `{args.run_id}`",
        f"Generated: {datetime.now().astimezone().isoformat(timespec='seconds')}",
        f"Netlist input: `{args.netlist.resolve()}`",
        f"Timing input: `{args.timing.resolve()}`",
        f"Netlist stage: {'routed' if 'routed' in args.netlist.name.lower() or 'implementation' in args.netlist.name.lower() else 'gate/unspecified' }",
        "",
        "## Checks",
        "",
    ]
    for status, detail in checks:
        lines.append(f"- **{status}** — {detail}")

    lines.extend(["", "## Clock topology", "", "| Item | C11308 baseline | C11316 input |", "|---|---|---|"])
    old_net = baseline.get("netlist", {})
    expected = netlist_detail["expected"]
    topology_rows = [
        ("Netlist SHA256", old_net.get("sha256", ""), candidate_hash),
        ("PLL clkc[1] raw", old_net.get("serial_raw", ""), expected.get("serial_raw", "")),
        ("serial clock after buffer", old_net.get("serial", ""), expected.get("serial", "")),
        ("EG_PHY_GCLK count", old_net.get("gclk_count", ""), netlist_detail.get("gclk_count", "")),
        ("pixel clock GCLK output", "see baseline netlist", expected.get("pixel", "")),
        ("system clock GCLK output", "see baseline netlist", expected.get("system", "")),
    ]
    for label, old, new in topology_rows:
        lines.append(f"| {label} | {md_escape(old)} | {md_escape(new)} |")
    lines.extend(["", "GCLK cells:", ""])
    for gclk in expected["gclks"]:
        lines.append(f"- `{gclk['instance']}`: `{gclk['clki']}` → `{gclk['clko']}`")

    lines.extend(["", "## HDMI PAD comparison", "", "| Output | Old mode/type/reset | New mode/type/reset | New osclk |", "|---|---|---|---|"])
    for port in HDMI_PADS:
        old = baseline_pads.get(port, {})
        new = netlist_detail["pads"].get(port, {})
        lines.append(
            f"| {port} | {md_escape(old.get('ddrmode',''))} / {md_escape(old.get('iotype',''))} / `{md_escape(old.get('reset',''))}` | "
            f"{md_escape(new.get('ddrmode',''))} / {md_escape(new.get('iotype',''))} / `{md_escape(new.get('reset',''))}` | `{md_escape(new.get('osclk',''))}` |"
        )

    lines.extend(["", "## Lane register clock/polarity audit", "", "Only explicit q/clk cell ports matching named lane register classes are checked; unrelated packed pins are not assumed to share one net.", "", "| Lane | Register class | Cell | CLK | CLKMUX |", "|---:|---|---|---|---|"])
    for item in netlist_detail["lane_registers"]:
        lines.append(f"| {item['lane']} | {item['role']} | `{item['kind']} {item['cell']}` | `{item['clock']}` | `{item['clkmux'] or '(default)'}` |")

    lines.extend(["", "## Routed timing summary", ""])
    def timing_metrics(summary: dict[str, Any]) -> tuple[str, str, str, str, str, str]:
        row = summary.get("serial_clock") or {}
        stats = summary.get("report_stats", {})
        paths = summary.get("pad_do_paths", [])

        def endpoint_slack(kind: str) -> str:
            values = [float(item["slack_ns"]) for item in paths if item.get("check") == kind and item.get("slack_ns")]
            return f"{min(values):.3f}" if values else "未列出"

        return (
            stats.get("SWNS", "—"),
            stats.get("HWNS", "—"),
            row.get("skew_ns", "—"),
            row.get("fanout", "—"),
            endpoint_slack("setup"),
            endpoint_slack("hold"),
        )

    old_metrics = timing_metrics(baseline.get("timing", {}))
    new_metrics = timing_metrics(timing)
    lines.extend([
        "| Report | Clock SWNS (ns) | Clock HWNS (ns) | hdmi_5x skew (ns) | Fanout | PAD do setup min slack (ns) | PAD do hold min slack (ns) |",
        "|---|---:|---:|---:|---:|---:|---:|",
        f"| C11308 baseline | {' | '.join(old_metrics)} |",
        f"| C11316 input | {' | '.join(new_metrics)} |",
        "",
        "Clock WNS/skew are routed clock-summary metrics. PAD `do[]` values include only endpoints explicitly listed by the timing report; ‘未列出’ means no such path was listed, not zero slack.",
        "",
    ])
    if timing.get("available") and timing.get("fresh"):
        lines.append(f"- Report SHA256: `{timing['sha256']}`")
        lines.append(f"- Constraint file: `{timing.get('constraint','')}`")
        lines.append(f"- Global timing: `{json.dumps(timing.get('report_stats',{}), ensure_ascii=False)}`")
        if timing.get("serial_clock"):
            lines.append(f"- hdmi_5x_clk row: `{timing['serial_clock']['line']}`")
        else:
            lines.append("- hdmi_5x_clk row: not found")
        lines.append("")
        lines.append("PAD DDR input-register paths explicitly listed in the report:")
        if timing.get("pad_do_paths"):
            for item in timing["pad_do_paths"]:
                lines.append(f"- {item['check'] or 'check?'} {item['endpoint']}; slack={item['slack_ns']} ns; skew={item['skew_ns']} ns; budget={item['budget']}; launch={item['begin']}")
        else:
            lines.append("- No HDMI PAD `.do[]` path entry found in this report.")
    else:
        lines.append(f"- {timing.get('reason','尚无 timing summary')}.")
        lines.append("- Baseline remains C11308 only; no candidate setup/hold/skew value is inferred from stale output.")

    lines.extend(["", "## Run and bit identity", ""])
    syn = evidence.get("record", {})
    lines.append(f"- C11316 synthesis: status=`{syn.get('status','unknown')}`, runId=`{syn.get('runId','')}`, scopeHash=`{syn.get('scopeHash','')}`, gateDbHash=`{syn.get('gateDbHash','')}`")
    if physical:
        lines.append(f"- C11316 physical: status=`{evidence.get('physical_pointer',{}).get('status','')}`, runId=`{physical.get('runId','')}`, synthesisRunId=`{physical.get('synthesisRunId','')}`, gateDbHash=`{physical.get('gateDbHash','')}`")
    for stage, item in baseline.get("evidence", {}).items():
        lines.append(f"- C11308 {stage}: status=`{item.get('status','')}`, runId=`{item.get('runId','')}`, synthesisRunId=`{item.get('synthesisRunId','')}`, scopeHash=`{item.get('scopeHash','')}`, gateDbHash=`{item.get('gateDbHash','')}`, bitHash=`{item.get('bitHash','')}`")
    lines.extend(["", "## Limits", "", "- This script reads existing files only. It does not invoke Tang Dynasty, regenerate a netlist, or touch hardware.", "- A gate netlist verifies synthesis mapping, not routed clock skew. Routed conclusions require the routed implementation netlist and a fresh C11316 timing report.", "- `CLKMUX=INV` is accepted as a legal EG4 clock selection and is required for the RTL falling-edge `S_oddr_data` preparation. For EG_PHY_LSLICE, legal model values include CLK/INV/1/0; for EG_PHY_MSLICE they include 0/1/INV/SIG. The script checks only explicit cell parameters and named q/clk ports.", "- No assertion is made that unrelated ports of a packed logic cell share one clock net.", ""])

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {args.output.resolve()}")
    fails = sum(status == "FAIL" for status, _ in checks)
    structured = {'status': 'FAIL' if fails else 'PASS', 'synthesis_run_id': args.run_id,
                  'physical_run_id': physical_record.get('runId'),
                  'physical_record_sha256': sha256_file(Path(evidence['physical_record_path'])),
                  'netlist': str(args.netlist.resolve()), 'netlist_sha256': candidate_hash,
                  'checks': checks, 'topology': netlist_detail,
                  'timing': timing, 'evidence': evidence,
                  'limits': 'Clock topology and reported paths only; not full electrical or reset equivalence.'}
    args.output.with_suffix('.json').write_text(json.dumps(structured, indent=2, ensure_ascii=False)+'\n', encoding='utf-8')
    print(f"Checks: {sum(status == 'PASS' for status, _ in checks)} PASS, {sum(status == 'WARN' for status, _ in checks)} WARN, {fails} FAIL")
    return 1 if fails else 0


if __name__ == "__main__":
    raise SystemExit(main())


