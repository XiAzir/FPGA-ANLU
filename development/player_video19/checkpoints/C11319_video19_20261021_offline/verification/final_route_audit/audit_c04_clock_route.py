#!/usr/bin/env python3
"""Read-only C04 routed clock topology and STA clock-fanout audit."""
from __future__ import annotations

import hashlib
import json
import re
from datetime import datetime
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
PROJECT = ROOT / "development/player_video19"
BUILD = PROJECT / "build/manual"
EVIDENCE = BUILD / "stage_evidence"
NETLIST = HERE / "AC201_tf_hdmi_c04_pr_routed.v"
TIMING = BUILD / "AC201_tf_hdmi_pr.timing"
SDC = PROJECT / "src/user_source/constraints_source/timing.sdc"
RECEIPT = HERE / "route_export_receipt.json"
ROM_PROOF = HERE / "routed_rom_control_proof.json"
OUT_JSON = HERE / "routed_clock_audit.json"
OUT_MD = HERE / "routed_clock_audit.md"
RUNS = {
    "synthesis": "0c69ff10-3139-4672-acea-5a38d730eef0",
    "physical": "b5370f50-01db-423e-86d9-407bff967274",
    "hold": "387033ad-cf55-48fa-8c26-507e0577472e",
    "bitstream": "bb977f9e-fce9-4d85-aca2-71693525de70",
}


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def canonical(value: str) -> str:
    return re.sub(r"\s+", "", value).replace("\\", "").rstrip(")")


def balanced(text: str, at: int) -> tuple[str, int]:
    if text[at] != "(":
        raise ValueError("expected opening parenthesis")
    depth = 0
    for pos in range(at, len(text)):
        if text[pos] == "(":
            depth += 1
        elif text[pos] == ")":
            depth -= 1
            if depth == 0:
                return text[at + 1:pos], pos + 1
    raise ValueError("unterminated cell expression")


def top_parts(body: str) -> list[str]:
    out: list[str] = []
    start = 0
    stack: list[str] = []
    close = {")": "(", "]": "[", "}": "{"}
    for i, ch in enumerate(body):
        if ch in "([{":
            stack.append(ch)
        elif ch in ")]}":
            if stack and stack[-1] == close[ch]:
                stack.pop()
        elif ch == "," and not stack:
            out.append(body[start:i].strip())
            start = i + 1
    tail = body[start:].strip()
    if tail:
        out.append(tail)
    return out


def named(body: str) -> dict[str, str]:
    result: dict[str, str] = {}
    pos = 0
    while pos < len(body):
        m = re.search(r"\.([A-Za-z_$][\w$]*)\s*\(", body[pos:])
        if not m:
            break
        key = m.group(1)
        at = pos + m.end() - 1
        value, pos = balanced(body, at)
        result[key] = value.strip()
    return result


def cells_of(text: str) -> list[dict[str, object]]:
    text = re.sub(r"/\*.*?\*/", " ", text, flags=re.S)
    text = re.sub(r"//[^\r\n]*", " ", text)
    result = []
    for m in re.finditer(r"\b(EG_PHY_PLL|EG_PHY_GCLK)\b", text):
        pos = m.end()
        while pos < len(text) and text[pos].isspace():
            pos += 1
        params: dict[str, str] = {}
        if pos < len(text) and text[pos] == "#":
            pos += 1
            while pos < len(text) and text[pos].isspace():
                pos += 1
            param_body, pos = balanced(text, pos)
            params = named(param_body)
        while pos < len(text) and text[pos].isspace():
            pos += 1
        start = pos
        if pos < len(text) and text[pos] == "\\":
            while pos < len(text) and not text[pos].isspace():
                pos += 1
            inst = text[start:pos].strip().lstrip("\\").rstrip()
        else:
            im = re.match(r"[A-Za-z_$][\w$]*", text[pos:])
            if not im:
                continue
            inst = im.group()
            pos += im.end()
        while pos < len(text) and text[pos].isspace():
            pos += 1
        port_body, _ = balanced(text, pos)
        result.append({"kind": m.group(1), "instance": inst, "params": params, "ports": named(port_body)})
    return result


def clock_rows(text: str) -> dict[str, dict[str, object]]:
    section = text.split("Clock Summary", 1)[1].split("Name            Type", 1)[0]
    rows: dict[str, dict[str, object]] = {}
    for line in section.splitlines():
        m = re.match(r"\s*(clk\d+):\s*([0-9.]+)\s+([0-9]+)\s+([A-Za-z0-9_]+)\s*$", line)
        if m:
            rows[m.group(4)] = {"clock_id": m.group(1), "frequency_mhz": float(m.group(2)), "fanout": int(m.group(3)), "raw": line.strip()}
    return rows


def main() -> int:
    # Resolve and hash all lifecycle artifacts before interpreting topology.
    receipt = json.loads(RECEIPT.read_text(encoding="utf-8-sig"))
    proof = json.loads(ROM_PROOF.read_text(encoding="utf-8-sig"))
    paths = {
        "synthesis_record": Path(receipt["synthesis_record"]["path"]) if "path" in receipt["synthesis_record"] else EVIDENCE / f"synthesis_{RUNS['synthesis']}.json",
        "physical_record": EVIDENCE / f"physical_{RUNS['physical']}.json",
        "hold_record": EVIDENCE / f"hold_{RUNS['hold']}.json",
        "bitstream_record": EVIDENCE / f"bitstream_{RUNS['bitstream']}.json",
        "route_db": Path(receipt["route_db"]["path"]),
        "timing_report": Path(receipt["timing_report"]["path"]),
        "source_scope": Path(receipt["source_scope"]["path"]),
        "netlist": NETLIST,
        "sdc": SDC,
        "rom_proof": ROM_PROOF,
    }
    hashes = {key: sha(path) for key, path in paths.items()}
    failures: list[str] = []
    checks: list[dict[str, str]] = []

    def check(ok: bool, label: str, detail: str) -> None:
        checks.append({"status": "PASS" if ok else "FAIL", "label": label, "detail": detail})
        if not ok:
            failures.append(f"{label}: {detail}")

    syn = json.loads(paths["synthesis_record"].read_text(encoding="utf-8-sig"))
    phy = json.loads(paths["physical_record"].read_text(encoding="utf-8-sig"))
    hold = json.loads(paths["hold_record"].read_text(encoding="utf-8-sig"))
    bit = json.loads(paths["bitstream_record"].read_text(encoding="utf-8-sig"))
    check(syn.get("runId") == RUNS["synthesis"] and syn.get("status") == "success", "synthesis-record", "C04 synthesis success record is selected")
    check(phy.get("runId") == RUNS["physical"] and phy.get("synthesisRunId") == RUNS["synthesis"], "physical-link", "physical route links to selected synthesis")
    check(hold.get("runId") == RUNS["hold"] and hold.get("synthesisRunId") == RUNS["synthesis"], "hold-link", "final hold-repaired route links to selected synthesis")
    check(bit.get("runId") == RUNS["bitstream"] and bit.get("routeStage") == "hold" and bit.get("synthesisRunId") == RUNS["synthesis"], "bitstream-link", "successful bitstream links to the hold-repaired route")
    check(hold.get("artifacts", {}).get("AC201_tf_hdmi_pr.db") == hashes["route_db"], "final-route-db", f"final PR DB SHA256={hashes['route_db']}")
    check(hold.get("artifacts", {}).get("AC201_tf_hdmi_pr.timing") == hashes["timing_report"], "routed-timing", f"routed timing SHA256={hashes['timing_report']}")
    check(receipt.get("exported_netlist", {}).get("sha256", "").lower() == hashes["netlist"], "netlist-export", f"exported routed netlist SHA256={hashes['netlist']}")
    check(phy.get("scopeHash") == syn.get("scopeHash") == hold.get("scopeHash") == bit.get("scopeHash"), "source-scope", f"common scopeHash={syn.get('scopeHash')}")
    check(proof.get("status") == "PASS" and proof.get("route_database_sha256") == hashes["route_db"] and proof.get("timing_report_sha256") == hashes["timing_report"], "rom-proof-binding", "ROM truth proof PASS bound to this PR DB and timing report")

    netlist_text = NETLIST.read_text(encoding="utf-8", errors="replace")
    found = cells_of(netlist_text)
    plls = [c for c in found if c["kind"] == "EG_PHY_PLL"]
    gclks = [c for c in found if c["kind"] == "EG_PHY_GCLK"]
    sys_pll = next((c for c in plls if "sys_pll_m0" in str(c["instance"])), None)
    video_pll = next((c for c in plls if "video_pll_m0" in str(c["instance"])), None)
    check(len(plls) == 2 and sys_pll is not None and video_pll is not None, "pll-cells", f"found {len(plls)} routed PLLs; sys/video instances present")
    check(len(gclks) == 3, "gclk-cells", f"found {len(gclks)} routed EG_PHY_GCLK cells")

    def pll_output(cell: dict[str, object] | None, bit_index: int) -> str:
        if not cell:
            return ""
        expr = str(cell["ports"].get("clkc", ""))
        if not (expr.startswith("{") and expr.endswith("}")):
            return ""
        # Concatenation lists CLKC[4] first and CLKC[0] last.
        parts = top_parts(expr[1:-1])
        if len(parts) != 5:
            return ""
        return canonical(parts[4 - bit_index])

    gclk_by_in = {canonical(str(c["ports"].get("clki", ""))): c for c in gclks}
    sys0 = pll_output(sys_pll, 0)
    sys1 = pll_output(sys_pll, 1)
    sys2 = pll_output(sys_pll, 2)
    video0 = pll_output(video_pll, 0)
    video1 = pll_output(video_pll, 1)
    sys_buf = gclk_by_in.get(sys0)
    video_buf = gclk_by_in.get(video0)
    serial_buf = next((c for c in gclks if "u_hdmi_serial_bufg" in str(c["instance"])), None)
    serial_source_matches = bool(serial_buf and canonical(str(serial_buf["ports"].get("clki", ""))) == video1)
    check(sys_buf is not None and "u_jpeg_core/u_jpeg_output/u_ram_y/u_ram/clk1_i" in canonical(str(sys_buf["ports"].get("clko", ""))), "sys-pll-gclk", f"sys CLKC[0] {sys0} buffered to JPEG/core clock")
    check(video_buf is not None and "u_adjust_control/clk" in canonical(str(video_buf["ports"].get("clko", ""))), "video-pll-gclk", f"video CLKC[0] {video0} buffered to pixel/control clock")
    check(serial_source_matches, "hdmi-serial-gclk", f"video CLKC[1] {video1} buffered to HDMI serializer clock")

    sdc_text = SDC.read_text(encoding="utf-8-sig")
    names = set(re.findall(r"rename_clock\s+-name\s+\{([^}]+)\}", sdc_text))
    rename_sources = {
        m.group(1): m.group(2)
        for m in re.finditer(r"rename_clock\s+-name\s+\{([^}]+)\}.*?\[get_pins\s+\{([^}]+)\}\]", sdc_text)
    }
    create = re.search(r"create_clock\s+-name\s+(\w+)\s+-period\s+([0-9.]+)", sdc_text)
    clocks = clock_rows(TIMING.read_text(encoding="utf-8", errors="replace"))
    expected_names = {"clk", "sd_card_clk", "video_clk", "ext_mem_clk", "hdmi_5x_clk", "ext_mem_clk_sft"}
    check(create is not None and create.group(1) == "clk" and float(create.group(2)) == 20.0, "sdc-root-clock", "50 MHz input clk is constrained at 20 ns")
    check(names == expected_names - {"clk"}, "sdc-renamed-clocks", f"declared PLL clocks={sorted(names)}")
    check(set(clocks) == expected_names, "sta-clock-summary", f"routed timing contains exactly six declared clocks: {sorted(clocks)}")

    expected_routes = {
        "sd_card_clk": ("sys_pll_m0/pll_inst.clkc[0]", 50.0),
        "ext_mem_clk": ("sys_pll_m0/pll_inst.clkc[1]", 50.0),
        "ext_mem_clk_sft": ("sys_pll_m0/pll_inst.clkc[2]", 50.0),
        "video_clk": ("video_pll_m0/pll_inst.clkc[0]", 25.0),
        "hdmi_5x_clk": ("video_pll_m0/pll_inst.clkc[1]", 125.0),
        "clk": ("clk", 50.0),
    }
    routed_outputs = {
        "sys_pll_m0/pll_inst.clkc[0]": sys0,
        "sys_pll_m0/pll_inst.clkc[1]": sys1,
        "sys_pll_m0/pll_inst.clkc[2]": sys2,
        "video_pll_m0/pll_inst.clkc[0]": video0,
        "video_pll_m0/pll_inst.clkc[1]": video1,
    }
    for name, (pin, _) in expected_routes.items():
        if name == "clk":
            continue
        actual_pin = rename_sources.get(name, "")
        routed_net = routed_outputs.get(pin, "")
        check(actual_pin == pin and bool(routed_net), "sdc-route:" + name, f"SDC pin={actual_pin or 'missing'}; routed PLL output={routed_net or 'missing'}")
    for name, (pin, freq) in expected_routes.items():
        row = clocks.get(name)
        check(row is not None and row["frequency_mhz"] == freq and int(row["fanout"]) > 0, "clock-row:" + name, f"source={pin}, STA frequency={row.get('frequency_mhz') if row else 'missing'} MHz, true report fanout={row.get('fanout') if row else 'missing'}")

    topology = {
        "pll_count": len(plls),
        "gclk_count": len(gclks),
        "pll_outputs": {
            "sys_pll_m0": {"clkc0": sys0, "clkc1": sys1, "clkc2": sys2},
            "video_pll_m0": {"clkc0": video0, "clkc1": video1},
        },
        "global_clock_buffers": [
            {"instance": c["instance"], "clki": c["ports"].get("clki", ""), "clko": c["ports"].get("clko", "")}
            for c in gclks
        ],
        "timing_report_clock_rows": clocks,
        "sdc_rename_clock_names": sorted(names),
        "sdc_rename_clock_sources": rename_sources,
        "constraints_note": "SDC exposes clk + five renamed PLL output clocks; reported fanout is taken directly from the final hold-routed STA Clock Summary.",
    }
    status = "PASS" if not failures else "FAIL"
    result = {
        "schema": "c04-routed-clock-static-audit-v1",
        "status": status,
        "generated": datetime.now().astimezone().isoformat(timespec="seconds"),
        "run_ids": RUNS,
        "hashes": hashes,
        "db_and_timing_sha256": {"route_db": hashes["route_db"], "timing_report": hashes["timing_report"], "routed_netlist": hashes["netlist"]},
        "checks": checks,
        "topology": topology,
        "failures": failures,
        "limits": "Read-only static topology and report audit. Frequencies/fanouts are routed STA report fields; this does not establish board-level SPI delays or analog clock quality.",
    }
    OUT_JSON.write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    lines = [
        "# C04 最终 routed 时钟静态审查", "",
        f"**结果：{status}**；run：synthesis `{RUNS['synthesis']}`，hold `{RUNS['hold']}`，bitstream `{RUNS['bitstream']}`。", "",
        "审查绑定 hold 修复后的最终 PR DB、其 routed timing、冻结导出的 routed 网表、源 scope 与 ROM truth proof。报告中 fanout 直接取 routed STA 的 Clock Summary。", "",
        "## Routed clock summary", "",
        "| 时钟 | SDC来源 | 频率 (MHz) | routed fanout |", "|---|---|---:|---:|",
    ]
    for name in ("sd_card_clk", "video_clk", "ext_mem_clk", "hdmi_5x_clk", "clk", "ext_mem_clk_sft"):
        row = clocks.get(name, {})
        lines.append(f"| `{name}` | `{expected_routes.get(name, ('', 0))[0]}` | {row.get('frequency_mhz', '缺失')} | {row.get('fanout', '缺失')} |")
    lines.extend(["", "## Routed topology", "", f"- sys PLL: CLKC[0] `{sys0}` → GCLK `{(sys_buf or {}).get('ports', {}).get('clko', '缺失')}`；CLKC[1] `{sys1}`；CLKC[2] `{sys2}`。", f"- video PLL: CLKC[0] `{video0}` → GCLK `{(video_buf or {}).get('ports', {}).get('clko', '缺失')}`；CLKC[1] `{video1}` → HDMI serializer GCLK `{(serial_buf or {}).get('ports', {}).get('clko', '缺失')}`。", "", "## 生命周期与哈希绑定", ""])
    for key in ("synthesis_record", "physical_record", "hold_record", "bitstream_record", "route_db", "timing_report", "source_scope", "netlist", "sdc", "rom_proof"):
        lines.append(f"- `{key}` SHA-256 `{hashes[key]}`")
    lines.extend(["", "## Assertions", ""])
    for item in checks:
        lines.append(f"- **{item['status']}** — {item['label']}: {item['detail']}")
    if failures:
        lines.extend(["", "失败项:", ""] + [f"- {failure}" for failure in failures])
    lines.extend(["", "范围说明：PLL/GCLK 静态连线与 STA 报告时钟行完整性已核对；板级 SPI I/O delay 仍按工程 SDC 注释未表征。", ""])
    OUT_MD.write_text("\n".join(lines), encoding="utf-8")
    print(json.dumps({"status": status, "checks": len(checks), "failed": failures, "clock_fanouts": {k: v.get("fanout") for k, v in clocks.items()}}, ensure_ascii=False))
    return 0 if status == "PASS" else 1


if __name__ == "__main__":
    raise SystemExit(main())
