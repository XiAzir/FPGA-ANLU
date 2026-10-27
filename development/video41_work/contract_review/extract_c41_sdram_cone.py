#!/usr/bin/env python3
"""Extract the verbatim mapped SDRAM controller subtree and command pads."""
from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


PREFIX = r"\u_frame_buffer/u_sdram/u2_ram/"
PAD_INSTANCES = {
    r"\u_frame_buffer/u_sdram/sdram_syn_6",
    r"\u_frame_buffer/u_sdram/sdram_syn_8",
    r"\u_frame_buffer/u_sdram/sdram_syn_9",
}
ROOTS = [
    r"\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/SDR_RAS_n",
    r"\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/SDR_CAS_n",
    r"\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/SDR_WE_n",
    r"\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/Sdr_ref_req_syn_4",
    r"\u_frame_buffer/u_sdram/u2_ram/u1_init_ref/Sdr_ref_ack",
    r"\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/ref_ack",
    r"\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/wrrd_ref_ack",
    r"\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/rw_vld",
    r"\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/ref_vld",
    r"\u_frame_buffer/u_sdram/u2_ram/u1_init_ref/init_done_reg_syn_5",
    r"\u_frame_buffer/u_sdram/u2_ram/u1_init_ref/pwr_200ms_cnt",
]
CUTS = [
    r"\sys_pll_m0/clk0_buf",
    r"\u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/mem_clk",
    r"\u_frame_buffer/u_sdram/u2_ram/Sdr_clk_sft",
    r"clk0",
    r"rst_all",
    r"\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/App_wr_en",
    r"\u_frame_buffer/u_sdram/u2_ram/App_rd_en",
    r"\u_frame_buffer/u_sdram/u2_ram/App_wr_addr",
    r"\u_frame_buffer/u_sdram/u2_ram/App_rd_addr",
    r"\u_frame_buffer/u_sdram/u2_ram/App_wr_din",
    r"\u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/App_rd_addr",
    r"\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/App_wr_addr_r",
    r"\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/App_wr_din",
    r"\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/jpeg_mode_latch",
    r"\u_frame_buffer/u_sdram/u2_ram/u1_init_ref/pwr_200ms_cnt",
    r"al_1559",
    r"al_1591",
    r"al_1688",
    r"al_172",
    r"al_1720",
    r"al_236",
    r"al_395",
    r"al_413",
    r"al_431",
    r"al_577",
    r"al_588",
    r"al_736",
    r"al_746",
    r"al_787",
    r"al_85",
    r"al_852",
    r"al_946",
]


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def net_tokens(expression: str) -> set[str]:
    return set(re.findall(r"\\[^\s,(){}]+|\b[A-Za-z_$][\w$]*\b", expression))


def output_port_names(cell_type: str, ports: list[dict[str, str]]) -> set[str]:
    if cell_type.startswith("AL_MAP_LUT"):
        return {"o"}
    if cell_type == "AL_MAP_SEQ":
        return {"q"}
    if cell_type == "buf":
        return {"$pos0"}
    if cell_type == "EG_PHY_PAD":
        return {"do"}
    return set()


def find_statement_end(text: str, start: int) -> int:
    depth = 0
    state = "code"
    i = start
    while i < len(text):
        c = text[i]
        n = text[i + 1] if i + 1 < len(text) else ""
        if state == "line":
            if c == "\n":
                state = "code"
        elif state == "block":
            if c == "*" and n == "/":
                state = "code"
                i += 1
        elif state == "string":
            if c == "\\":
                i += 1
            elif c == '"':
                state = "code"
        elif c == "/" and n == "/":
            state = "line"
            i += 1
        elif c == "/" and n == "*":
            state = "block"
            i += 1
        elif c == '"':
            state = "string"
        elif c == "(":
            depth += 1
        elif c == ")":
            depth -= 1
        elif c == ";" and depth == 0:
            return i + 1
        i += 1
    raise ValueError(f"unterminated instance starting at byte {start}")


def instance_path(statement: str) -> str:
    # The instance identifier follows the cell type and optional parameters.
    clean = re.sub(r"/\*.*?\*/|//[^\n]*", " ", statement, flags=re.S)
    type_match = re.match(r"\s*(?:AL_MAP_[A-Z0-9_]+|EG_[A-Z0-9_]+|buf)\b", clean)
    if not type_match:
        raise ValueError("cell type not found")
    pos = type_match.end()
    while pos < len(clean) and clean[pos].isspace():
        pos += 1
    if clean[pos:pos + 1] == "#":
        pos += 1
        while pos < len(clean) and clean[pos].isspace():
            pos += 1
        if clean[pos] != "(":
            raise ValueError("malformed parameter list")
        depth = 0
        while pos < len(clean):
            if clean[pos] == "(":
                depth += 1
            elif clean[pos] == ")":
                depth -= 1
                if depth == 0:
                    pos += 1
                    break
            pos += 1
    m = re.match(r"\s*(\\[^\s(]+|[A-Za-z_$][\w$]*)\s*\(", clean[pos:])
    if not m:
        raise ValueError("instance identifier not found")
    return m.group(1)


def instance_ports(statement: str) -> list[dict[str, str]]:
    path = instance_path(statement)
    instance_match = re.search(re.escape(path) + r"\s*\(", statement)
    if not instance_match:
        raise ValueError(f"port list missing for {path}")
    pos = instance_match.start() + len(path)
    while pos < len(statement) and statement[pos].isspace():
        pos += 1
    if statement[pos] != "(":
        raise ValueError(f"port list missing for {path}")
    pos += 1
    ports = []
    while pos < len(statement):
        while pos < len(statement) and (statement[pos].isspace() or statement[pos] == ","):
            pos += 1
        if statement[pos] == ")":
            break
        match = re.match(r"\.([A-Za-z_$][\w$]*)\s*\(", statement[pos:])
        if not match:
            name = f"$pos{len(ports)}"
            expr_start = pos
            depth = 0
            i = pos
            while i < len(statement):
                if statement[i] == "(":
                    depth += 1
                elif statement[i] == ")":
                    if depth == 0:
                        break
                    depth -= 1
                elif statement[i] == "," and depth == 0:
                    break
                i += 1
            ports.append({"name": name, "expression": statement[expr_start:i].strip()})
            pos = i
            continue
        else:
            name = match.group(1)
            expr_start = pos + match.end()
        depth = 1
        i = expr_start
        while i < len(statement) and depth:
            if statement[i] == "(":
                depth += 1
            elif statement[i] == ")":
                depth -= 1
            i += 1
        if depth:
            raise ValueError(f"unterminated port {name} on {path}")
        ports.append({"name": name, "expression": statement[expr_start:i - 1].strip()})
        pos = i
    return ports


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--gate", required=True, type=Path)
    ap.add_argument("--out-dir", required=True, type=Path)
    args = ap.parse_args()
    raw = args.gate.read_bytes()
    text = raw.decode("utf-8")
    starts = list(re.finditer(r"(?m)^[ \t]*(AL_MAP_[A-Z0-9_]+|EG_[A-Z0-9_]+|buf)\b", text))
    all_instances = []
    scan_char = 0
    scan_byte = 0
    scan_line = 1
    for m in starts:
        gap = text[scan_char:m.start()]
        scan_byte += len(gap.encode("utf-8"))
        scan_line += gap.count("\n")
        end = find_statement_end(text, m.start())
        statement = text[m.start():end]
        try:
            path = instance_path(statement)
        except ValueError as exc:
            line = text.count("\n", 0, m.start()) + 1
            raise ValueError(f"{exc} at source line {line}: {statement[:180]!r}") from exc
        all_instances.append({
            "start": m.start(), "end": end, "path": path, "statement": statement,
            "cell_type": m.group(1), "ports": instance_ports(statement),
            "start_byte": scan_byte, "end_byte": scan_byte + len(statement.encode("utf-8")),
            "start_line": scan_line, "end_line": scan_line + statement.count("\n"),
        })
        scan_byte += len(statement.encode("utf-8"))
        scan_line += statement.count("\n")
        scan_char = end
    selected_ids = {
        i for i, inst in enumerate(all_instances)
        if inst["path"].startswith(PREFIX) or inst["path"] in PAD_INSTANCES
    }
    drivers: dict[str, list[int]] = {}
    for i, inst in enumerate(all_instances):
        outputs = output_port_names(inst["cell_type"], inst["ports"])
        for port in inst["ports"]:
            if port["name"] in outputs:
                for net in net_tokens(port["expression"]):
                    drivers.setdefault(net, []).append(i)

    cut_tokens = set(CUTS)
    unresolved: set[str] = set()
    closure_added = []
    changed = True
    while changed:
        changed = False
        for i in list(selected_ids):
            inst = all_instances[i]
            outputs = output_port_names(inst["cell_type"], inst["ports"])
            for port in inst["ports"]:
                if port["name"] in outputs:
                    continue
                for net in net_tokens(port["expression"]):
                    if net in cut_tokens or net.startswith("open"):
                        continue
                    source_drivers = drivers.get(net, [])
                    if source_drivers:
                        for di in source_drivers:
                            if di not in selected_ids:
                                selected_ids.add(di)
                                closure_added.append({"net": net, "driver_path": all_instances[di]["path"]})
                                changed = True
                    elif net.startswith("\\") or net in {"clk0", "rst_all"}:
                        unresolved.add(net)
    selected = [all_instances[i] for i in sorted(selected_ids)]
    if not selected:
        raise SystemExit("no controller instances selected")

    args.out_dir.mkdir(parents=True, exist_ok=True)
    decls = [line for line in text.splitlines() if re.match(r"^\s*wire\b", line)]
    preamble = [
        "// Generated by extract_c41_sdram_cone.py. Mapped instances below are source-verbatim.",
        "// This is a cut-point inspection shell; external drivers are intentionally absent.",
        "module c41_sdram_cone_cut;",
        "",
        "// Original top-level wire declarations retained verbatim.",
        *decls,
        "",
        "// Required external force/cut inputs are listed in the companion manifest.",
        "// Do not infer missing drivers as constants.",
        "",
    ]
    pieces = [inst["statement"].rstrip() for inst in selected]
    out = "\n".join(preamble + pieces + ["endmodule", ""])
    out_bytes = out.encode("utf-8")
    verilog_path = args.out_dir / "c41_sdram_cone_cut.v"
    verilog_path.write_bytes(out_bytes)

    manifest = {
        "source_path": str(args.gate.resolve()),
        "source_sha256": sha256(raw),
        "source_bytes": len(raw),
        "extraction": "complete u2_ram subtree plus command PADs, recursively closed over mapped drivers until explicit cut inputs",
        "selection_prefix": PREFIX,
        "selected_pad_instances": sorted(PAD_INSTANCES),
        "selected_instance_count": len(selected),
        "wire_declaration_count": len(decls),
        "closure_added_instances": closure_added,
        "unresolved_external_nets": sorted(unresolved),
        "roots": ROOTS,
        "cut_inputs": CUTS,
        "output_path": str(verilog_path.resolve()),
        "output_sha256": sha256(out_bytes),
        "instances": [
            {
                "path": path,
                "source_start_line": inst["start_line"],
                "source_end_line": inst["end_line"],
                "source_start_byte": inst["start_byte"],
                "source_end_byte": inst["end_byte"],
                "sha256": sha256(statement.encode("utf-8")),
                "ports": instance_ports(statement),
            }
            for inst in selected
            for start, end, path, statement in [(inst["start"], inst["end"], inst["path"], inst["statement"])]
        ],
        "validation": {
            "all_selected_text_is_verbatim": True,
            "protected_source_read": False,
            "simulation_or_device_tools_run": False,
            "limitations": [
                "This is not a standalone simulation model; cut inputs need explicit force drivers.",
                "The full top-level wire declarations are retained, while unrelated instances are omitted.",
                "Command PAD output pins are open top-shell outputs for observation only.",
            ],
        },
    }
    manifest_path = args.out_dir / "c41_sdram_cone_manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    print(json.dumps({
        "instances": len(selected),
        "wires": len(decls),
        "source_sha256": manifest["source_sha256"],
        "output_sha256": manifest["output_sha256"],
        "verilog": str(verilog_path),
        "manifest": str(manifest_path),
    }, indent=2))


if __name__ == "__main__":
    main()
