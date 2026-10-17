#!/usr/bin/env python3
"""Bit-level truth audit for C11310 FFT diagnostic status pages."""
import hashlib
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
NET = ROOT / "build/board_feedback_no_signal_20261014/optimized_rtl.v"
RTL = ROOT / "src/user_source/hdl_source/player_status_monitor.v"
LIB = Path("C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/common/al_map_basic.v")
SMOKE = NET.parent / "modelsim/smoke_control_console.log"
PORT_RE = re.compile(r"\.([A-Za-z0-9_]+)\s*\(([^)]*)\)")


def norm(text):
    return re.sub(r"\s+", "", text.strip()).lstrip("\\")


def get_ports(body):
    return {m.group(1): norm(m.group(2)) for m in PORT_RE.finditer(body)}


def instances(text, kind):
    pattern = re.compile(
        r"(?ms)^\s*" + re.escape(kind)
        + r"\s+(?P<name>\\[^\s(]+|[^\s(]+)\s*\((?P<body>.*?)\)\s*;"
    )
    return [(m.group("name").lstrip("\\"), get_ports(m.group("body")))
            for m in pattern.finditer(text)]


def const_value(net):
    net = norm(net)
    m = re.fullmatch(r"(\d+)'([bBdDhHoO])([0-9a-fA-F_xXzZ]+)", net)
    if not m:
        return None
    digits = m.group(3).replace("_", "")
    if re.search(r"[xXzZ]", digits):
        raise ValueError("unknown constant: " + net)
    return int(digits, {"b": 2, "d": 10, "h": 16, "o": 8}[m.group(2).lower()])


def eval_mux(net, assigns, drivers, memo):
    net = norm(net)
    if net in memo:
        return memo[net]
    if net in assigns:
        return assigns[net]
    value = const_value(net)
    if value is not None:
        if value not in (0, 1):
            raise ValueError("non-bit constant: " + net)
        return value
    if net in ("0", "1"):
        return int(net)
    if net not in drivers:
        raise KeyError("unsupported/unassigned net: " + net)
    mux = drivers[net]
    select = eval_mux(mux["sel"], assigns, drivers, memo)
    result = eval_mux(mux["i1"] if select else mux["i0"], assigns, drivers, memo)
    memo[net] = result
    return result


def main():
    source = NET.read_text(encoding="utf-8", errors="replace")
    rtl = RTL.read_text(encoding="utf-8")
    library = LIB.read_text(encoding="utf-8", errors="replace")

    rtl_contract = [
        "13: hex_value={8'hF2,fft_progress};",
        "14: hex_value={8'hF3,fft_events};",
        "default: hex_value={8'hF4,fft_accepted};",
    ]
    missing = [entry for entry in rtl_contract if entry not in rtl]
    if missing:
        raise RuntimeError("RTL page contract changed: " + repr(missing))
    if not re.search(r"assign\s+cw_count_data\s*=\s*\{tone_mode,page,request_toggle,", rtl):
        raise RuntimeError("cw_count_data layout changed; selector mapping must be re-derived")

    module_match = re.search(r"(?ms)^module\s+binary_mux_s4_w1\b.*?^endmodule", source)
    if not module_match:
        raise RuntimeError("binary_mux_s4_w1 definition missing")
    module_body = module_match.group(0)
    mux_drivers = {}
    for _, ports in instances(module_body, "AL_MUX"):
        if not all(port in ports for port in ("i0", "i1", "sel", "o")):
            raise RuntimeError("malformed AL_MUX in binary_mux_s4_w1")
        mux_drivers[ports["o"]] = ports
    if len(mux_drivers) != 15:
        raise RuntimeError(f"expected 15 AL_MUX cells in 16:1 tree, got {len(mux_drivers)}")

    primitive = re.search(r"(?ms)^module\s+AL_MUX\b.*?^endmodule", library)
    equations = (
        "and u1 (sel_i1, sel, i1);",
        "and u2 (sel_i0, not_sel, i0);",
        "or u3 (o, sel_i1, sel_i0);",
    )
    if not primitive or not all(eq in primitive.group(0) for eq in equations):
        raise RuntimeError("vendor AL_MUX truth contract not verified")

    mux_truth_failures = []
    for selected in range(16):
        for walking_input in range(16):
            assigns = {f"i{index}": int(index == walking_input) for index in range(16)}
            assigns.update({f"sel[{bit}]": (selected >> bit) & 1 for bit in range(4)})
            got = eval_mux("o", assigns, mux_drivers, {})
            expected = int(selected == walking_input)
            if got != expected:
                mux_truth_failures.append({"select": selected, "walking_input": walking_input,
                                           "got": got, "expected": expected})
    if mux_truth_failures:
        raise RuntimeError("16:1 mux tree failed truth test: " + json.dumps(mux_truth_failures[:5]))

    found = []
    for name, ports in instances(source, "binary_mux_s4_w1"):
        output = ports.get("o", "")
        match = re.fullmatch(r"u_status_monitor/hex_value_b1\[(\d+)\]", output)
        if not match or not name.startswith("u_status_monitor/mux5_syn_"):
            continue
        inputs = {int(key[1:]): value for key, value in ports.items()
                  if re.fullmatch(r"i\d+", key)}
        if set(inputs) != set(range(16)):
            raise RuntimeError(f"{name}: expected inputs i0..i15")
        if ports.get("sel") != "u_status_monitor/cw_count_data[8:5]":
            raise RuntimeError(f"{name}: selector changed: {ports.get('sel')}")
        found.append((int(match.group(1)), name, inputs))
    found.sort(key=lambda item: item[0])
    if len(found) != 32 or [item[0] for item in found] != list(range(32)):
        raise RuntimeError(f"expected exactly one diagnostic mux for each output bit, got {len(found)}")

    buses = {13: "debug_progress", 14: "debug_events", 15: "debug_accepted"}
    prefixes = {13: 0xF2, 14: 0xF3, 15: 0xF4}
    walk_bits = {13: range(24), 14: range(16), 15: range(24)}
    failures = []
    checks = 0
    page_details = []
    for page in (13, 14, 15):
        bus = buses[page]
        # Verify each source bit reaches only its corresponding destination bit.
        for walking_bit in walk_bits[page]:
            assigns = {f"u_pcm_waveform/u_spectrum/{bus}[{bit}]": int(bit == walking_bit)
                       for bit in range(24)}
            for dest_bit, _, inputs in found:
                got = eval_mux(inputs[page], assigns, {}, {})
                # Payload bits follow the walking-one vector; prefix bits stay
                # at their fixed F2/F3/F4 values during every vector.
                expected = ((prefixes[page] >> (dest_bit - 24)) & 1
                            if dest_bit >= 24 else int(dest_bit == walking_bit))
                checks += 1
                if got != expected:
                    failures.append({"page": page, "dest_bit": dest_bit,
                                     "walking_bit": walking_bit, "got": got,
                                     "expected": expected})

        # Verify direct payload wiring and the fixed F2/F3/F4 byte.
        for dest_bit, _, inputs in found:
            source_net = inputs[page]
            if dest_bit < 24:
                if page == 14 and dest_bit >= 16:
                    try:
                        ok = const_value(source_net) == 0
                    except ValueError:
                        ok = False
                    expected_source = "constant zero (F3 upper payload byte)"
                else:
                    expected_source = f"u_pcm_waveform/u_spectrum/{bus}[{dest_bit}]"
                    ok = source_net == expected_source
                if not ok:
                    failures.append({"page": page, "dest_bit": dest_bit,
                                     "source": source_net, "expected_source": expected_source})
            else:
                expected = (prefixes[page] >> (dest_bit - 24)) & 1
                try:
                    got = const_value(source_net)
                except ValueError:
                    got = None
                if got != expected:
                    failures.append({"page": page, "prefix_bit": dest_bit,
                                     "source": source_net, "got": got, "expected": expected})
            checks += 1
        page_details.append({"page_selector": page, "bus": bus,
                             "walking_one_bits": len(list(walk_bits[page])),
                             "fixed_prefix": f"F{page - 11:X}"})

    # Preserve the separate routed vendor-model smoke evidence. This is not a
    # page-mux walking test and is deliberately reported with its stimulus limits.
    smoke_text = SMOKE.read_text(encoding="utf-8", errors="replace")
    pcm_lines = re.findall(r"(?m)^# PCM .*", smoke_text)
    result_line = re.search(r"(?m)^# RESULT smoke .*", smoke_text)
    if not result_line or not pcm_lines:
        raise RuntimeError("routed smoke evidence is missing PCM/RESULT observations")
    smoke_evidence = {
        "console": str(SMOKE),
        "console_sha256": hashlib.sha256(SMOKE.read_bytes()).hexdigest(),
        "pcm_observations": pcm_lines,
        "final_observation": result_line.group(0),
        "limitations": "Testbench forced both PLL lock inputs and tone_mode after reset distribution; no TF card or HDMI receiver model. events upper byte is zz because optimized-away constant bits are undriven in this routed simulation; treat only low16 payload as a reliable simulation observation, not as a hardware value.",
    }

    result = {
        "schema": "c11310-status-diagnostic-mux-v2",
        "status": "PASS" if not failures else "FAIL",
        "netlist": str(NET),
        "netlist_sha256": hashlib.sha256(NET.read_bytes()).hexdigest(),
        "rtl_sha256": hashlib.sha256(RTL.read_bytes()).hexdigest(),
        "diagnostic_mux_bit_count": len(found),
        "mux_primitive_cells": len(mux_drivers),
        "mux_truth_vectors": 256,
        "mux_truth_failures": len(mux_truth_failures),
        "pages_tested": [13, 14, 15],
        "selector_source": "cw_count_data[8:5] = {tone_mode,page,request_toggle,audio_count[17]}[8:5]",
        "rtl_contract": "page 13=F2+progress; page 14=F3+events; page 15/default=F4+accepted",
        "page_details": page_details,
        "walking_output_bit_checks": checks,
        "failure_count": len(failures),
        "failures": failures,
        "vendor_mux_contract": "AL_MUX = sel ? i1 : i0, verified from TD al_map_basic.v equations.",
        "supplemental_routed_vendor_model_smoke": smoke_evidence,
        "scope": "Static optimized RTL netlist check: 15-cell mux tree truth table; selectors 13/14/15; all 32 output bits; F2/F4 24-bit and F3 low-16 walking-one with high byte zero; fixed prefix wiring. Mailbox timing, routed netlist equivalence, and board behavior are not tested.",
    }
    output = ROOT / "build/audit/status_diagnostic_mux_truth.json"
    output.write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps({key: value for key, value in result.items() if key != "failures"},
                     indent=2, ensure_ascii=False))
    print("Wrote", output)
    if failures:
        print("Failure samples:", json.dumps(failures[:10], ensure_ascii=False))
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
