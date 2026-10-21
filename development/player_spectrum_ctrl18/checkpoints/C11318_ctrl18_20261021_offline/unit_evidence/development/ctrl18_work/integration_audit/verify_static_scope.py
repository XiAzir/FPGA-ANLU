#!/usr/bin/env python3
"""Independent read-only source, preservation, and integration audit for C11318.

This checker deliberately reads the C11317 parent, the already-created C11318
candidate, and the existing baseline receipts. It does not invoke TD or write
into either production project. Run from any working directory:

    py -3 development/ctrl18_work/integration_audit/verify_static_scope.py
"""

from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
PARENT = ROOT / "development/player_spectrum_arch17"
CANDIDATE = ROOT / "development/player_spectrum_ctrl18"
WORK = ROOT / "development/ctrl18_work"
BASELINE = CANDIDATE / "build/baseline"

ALLOWED_SOURCE_CHANGES = {
    "user_source/hdl_source/top_tf_hdmi_audio.v",
    "user_source/hdl_source/player_status_monitor.v",
    "user_source/hdl_source/player_adjust_control.v",
    "user_source/hdl_source/tf_bmp_file_player.v",
    "user_source/hdl_source/status_hex595.v",
    "user_source/hdl_source/player_status_mailbox.v",
    "td_project/AC201_tf_hdmi.al",
}
MAILBOX = "user_source/hdl_source/player_status_mailbox.v"
ID_ONLY = {
    "user_source/hdl_source/top_tf_hdmi_audio.v",
    "user_source/hdl_source/player_status_monitor.v",
}
PROJECT_FILE = "td_project/AC201_tf_hdmi.al"


def status_architecture_mode(top: str) -> str | None:
    normalized = re.sub(r"\s+", " ", top)
    has_mailbox = bool(re.search(r"\bplayer_status_mailbox\b|\bu_status_mailbox\b", normalized, re.I))
    direct = re.search(
        r"status_hex595\s*#\s*\(\s*\.CLK_HZ\s*\(\s*25000000\s*\)\s*\)\s*"
        r"u_status_hex\s*\((?P<ports>[^;]+?)\);", normalized, re.I
    )
    legacy = re.search(
        r"status_hex595\s*#\s*\(\s*\.CLK_HZ\s*\(\s*50000000\s*\)\s*\)\s*"
        r"u_status_hex\s*\((?P<ports>[^;]+?)\);", normalized, re.I
    )
    if direct and not has_mailbox:
        ports = direct.group("ports")
        if re.search(r"\.clk\s*\(\s*video_clk\s*\)", ports, re.I) and re.search(
            r"\.hex_value\s*\(\s*status_hex\s*\)", ports, re.I
        ):
            return "video"
    if legacy and has_mailbox:
        ports = legacy.group("ports")
        if re.search(r"\.clk\s*\(\s*sd_card_clk\s*\)", ports, re.I) and re.search(
            r"\.hex_value\s*\(\s*status_hex_system\s*\)", ports, re.I
        ):
            return "legacy"
    return None


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_json(path: Path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def fail(message: str) -> None:
    raise AssertionError(message)


def require(condition: bool, message: str) -> None:
    if not condition:
        fail(message)


def clean_rel(path: str) -> str:
    path = path.replace("\\", "/")
    return path.removeprefix("src/")


def normalized_candidate_text(parent_text: str) -> str:
    """Apply the exact naming changes made when C11318 was forked."""
    return (
        parent_text.replace("player_spectrum_arch17", "player_spectrum_ctrl18")
        .replace("spectrum_arch17.bit", "spectrum_ctrl18.bit")
        .replace(
            "C11317_arch17_20261021_offline",
            "C11318_ctrl18_20261021_offline",
        )
        .replace("C11317", "C11318")
        .replace("arch17_work", "ctrl18_work")
    )


def check_parent_anchors() -> dict:
    snapshot_path = BASELINE / "C11317_source_sha256.json"
    receipt_path = BASELINE / "receipt.json"
    manifest_path = PARENT / "checkpoints/C11317_arch17_20261021_offline/manifest.json"
    require(snapshot_path.is_file(), f"missing baseline source snapshot: {snapshot_path}")
    require(receipt_path.is_file(), f"missing baseline receipt: {receipt_path}")
    require(manifest_path.is_file(), f"missing C11317 frozen manifest: {manifest_path}")

    snapshot = read_json(snapshot_path)
    receipt = read_json(receipt_path)
    parent_files = {}
    for entry in snapshot:
        rel = entry["path"].replace("\\", "/")
        source = PARENT / rel
        require(source.is_file(), f"C11317 snapshot source missing: {rel}")
        actual = sha(source)
        require(actual == entry["sha256"].lower(), f"C11317 source snapshot SHA changed: {rel}")
        parent_files[rel] = entry["sha256"].lower()

    # Match the exact copy-time filter used by prepare_candidate.py.
    copied_files = {}
    for folder in ("src", "scripts", "sim"):
        for path in (PARENT / folder).rglob("*"):
            if path.is_file() and path.suffix.lower() not in (".db", ".vvp", ".dmp", ".pyc"):
                copied_files[path.relative_to(PARENT).as_posix()] = sha(path)
    require(
        set(parent_files) == set(copied_files),
        "C11317 source snapshot path set differs from the current parent src/scripts/sim tree",
    )
    require(
        all(parent_files[k] == copied_files[k] for k in parent_files),
        "C11317 source snapshot does not bind every current parent file",
    )

    require(
        sha(manifest_path) == receipt["parent_manifest_sha256"].lower(),
        "C11317 frozen manifest SHA does not match the C11318 baseline receipt",
    )
    manifest = read_json(manifest_path)
    frozen_entries = manifest["files"]
    require(len(frozen_entries) == 1809, f"expected 1809 frozen C11317 files, got {len(frozen_entries)}")
    for entry in frozen_entries:
        rel = entry["path"].replace("\\", "/")
        frozen_file = manifest_path.parent / rel
        require(frozen_file.is_file(), f"C11317 frozen file missing: {rel}")
        require(sha(frozen_file) == entry["sha256"].lower(), f"C11317 frozen file SHA mismatch: {rel}")

    preservation = read_json(PARENT / "build/preservation.json")
    protected_bits = dict(preservation["protected_bits"])
    protected_bits["spectrum_arch17.bit"] = receipt["parent_bit_sha256"].lower()
    require(len(protected_bits) == 7, f"expected 7 protected baseline bitstreams, got {len(protected_bits)}")
    for name, expected in protected_bits.items():
        bit = ROOT / "download" / name
        require(bit.is_file(), f"protected C11317 bitstream missing: {name}")
        require(sha(bit) == expected.lower(), f"protected bitstream SHA mismatch: {name}")

    return {
        "snapshot_files": len(snapshot),
        "frozen_files": len(frozen_entries),
        "parent_manifest_sha256": sha(manifest_path),
        "protected_bitstreams": protected_bits,
        "parent_source_sha256": parent_files,
    }


def check_candidate_scope(parent_anchor: dict) -> dict:
    selected = read_json(CANDIDATE / "build/selected_changes.json")
    selected = {clean_rel(path): record for path, record in selected.items()}
    require(
        set(selected) <= ALLOWED_SOURCE_CHANGES,
        "selected production source path outside the approved C11318 integration set: "
        + ", ".join(sorted(set(selected) - ALLOWED_SOURCE_CHANGES)),
    )

    # The synthesis input scope is the authoritative set covered by the TD
    # stage guard: all user_source files, the .al project, and generated IP.
    parent_scope_path = PARENT / "build/manual/build_source_scope.json"
    require(parent_scope_path.is_file(), f"missing C11317 source-scope evidence: {parent_scope_path}")
    parent_scope = {clean_rel(entry["path"]) for entry in read_json(parent_scope_path)}
    candidate_scope_root = CANDIDATE / "src"
    parent_source_root = PARENT / "src"
    candidate_files = {
        path.relative_to(candidate_scope_root).as_posix()
        for path in (candidate_scope_root / "user_source").rglob("*")
        if path.is_file()
    }
    candidate_files.add("td_project/AC201_tf_hdmi.al")
    candidate_files.update(
        path.relative_to(candidate_scope_root).as_posix()
        for path in (candidate_scope_root / "td_project/al_ip").rglob("*")
        if path.is_file()
    )
    parent_files = {
        path.relative_to(parent_source_root).as_posix()
        for path in (parent_source_root / "user_source").rglob("*")
        if path.is_file()
    }
    parent_files.add("td_project/AC201_tf_hdmi.al")
    parent_files.update(
        path.relative_to(parent_source_root).as_posix()
        for path in (parent_source_root / "td_project/al_ip").rglob("*")
        if path.is_file()
    )

    expected_candidate_files = set(parent_files)
    for rel, record in selected.items():
        if rel == MAILBOX and record.get("action") == "remove":
            expected_candidate_files.discard(rel)
    require(
        candidate_files == expected_candidate_files,
        "C11318 source file set differs from C11317 outside the authorized mailbox retirement; "
        f"missing={sorted(expected_candidate_files-candidate_files)}, "
        f"extra={sorted(candidate_files-expected_candidate_files)}",
    )
    require(
        {clean_rel(path) for path in parent_scope} == parent_files,
        "C11317 build_source_scope does not enumerate the full current TD source scope",
    )

    changed = []
    for rel in sorted(parent_files | candidate_files):
        parent_path = parent_source_root / rel
        candidate_path = candidate_scope_root / rel
        record = selected.get(rel)
        if record and record.get("action") == "remove":
            require(rel == MAILBOX, f"unsupported source removal: {rel}")
            require(parent_path.is_file() and not candidate_path.exists(), f"mailbox removal mismatch: {rel}")
            require(sha(parent_path) == record.get("parent_sha256", "").lower(), f"removed mailbox SHA mismatch: {rel}")
            changed.append(rel)
            continue
        require(parent_path.is_file() and candidate_path.is_file(), f"source missing during comparison: {rel}")
        if sha(parent_path) == sha(candidate_path):
            continue

        if record:
            expected = record.get("sha256", "").lower()
            require(expected and sha(candidate_path) == expected, f"selected source SHA mismatch: {rel}")
            source = Path(record["source"])
            require(source.is_file() and sha(source) == expected, f"selected source provenance mismatch: {rel}")
            changed.append(rel)
            continue

        require(rel in ALLOWED_SOURCE_CHANGES, f"unselected C11318 source change: {rel}")
        parent_text = parent_path.read_text(encoding="utf-8-sig")
        candidate_text = candidate_path.read_text(encoding="utf-8-sig")
        if rel == PROJECT_FILE or rel in ID_ONLY:
            require(
                candidate_text == normalized_candidate_text(parent_text),
                f"unselected naming/BUILD_ID adaptation contains an extra change: {rel}",
            )
            if rel in ID_ONLY:
                require("24'hC11318" in candidate_text, f"candidate BUILD_ID is missing C11318: {rel}")
        else:
            fail(f"C11318 source changed without an explicit selected-source record: {rel}")
        changed.append(rel)

    return {"changed_sources": changed, "selected_sources": selected}


def check_protected_domains() -> dict:
    parent_root = PARENT / "src"
    candidate_root = CANDIDATE / "src"
    protected_prefixes = (
        "user_source/constraints_source/",
        "td_project/al_ip/",
        "user_source/ip_source/",
        "user_source/hdl_source/IP/",
        "user_source/hdl_source/hdmi1.4b_transmitter_core/",
    )
    protected_exact = {
        "user_source/hdl_source/player_spectrum_analyzer.v",
        "user_source/hdl_source/player_spectrum_bands.vh",
        "user_source/hdl_source/rgb888_word_codec.v",
    }
    parent_hdl = parent_root / "user_source/hdl_source"
    for path in parent_hdl.rglob("*"):
        if not path.is_file():
            continue
        rel = path.relative_to(parent_root).as_posix()
        name = path.name.lower()
        if name.startswith("fat32") and path.suffix.lower() == ".v":
            protected_exact.add(rel)
        if name.startswith("spectrum_coeff_rom") or name in ("spectrum_hann.mem", "spectrum_twiddle.mem"):
            protected_exact.add(rel)

    protected = set(protected_exact)
    for path in (parent_root / "user_source").rglob("*"):
        if path.is_file():
            rel = path.relative_to(parent_root).as_posix()
            if rel.startswith(protected_prefixes):
                protected.add(rel)

    for rel in sorted(protected):
        parent_path = parent_root / rel
        candidate_path = candidate_root / rel
        require(parent_path.is_file() and candidate_path.is_file(), f"protected candidate source missing: {rel}")
        require(sha(parent_path) == sha(candidate_path), f"protected source bytes changed: {rel}")

    require((candidate_root / "user_source/constraints_source/timing.sdc").is_file(), "candidate timing.sdc missing")
    return {"protected_source_count": len(protected), "protected_sources": sorted(protected)}


def loader_main_state_bytes(path: Path) -> bytes:
    source = path.read_bytes()
    first_endmodule = source.find(b"\nendmodule")
    require(first_endmodule >= 0, f"loader module end not found: {path}")
    marker = b"always @(posedge clk or posedge rst) begin"
    starts = []
    position = 0
    while True:
        found = source.find(marker, position, first_endmodule)
        if found < 0:
            break
        starts.append(found)
        position = found + len(marker)
    require(len(starts) >= 2, f"expected failure and state sequencers in {path}")
    return source[starts[-1] : first_endmodule + len(b"\nendmodule")]


def check_event_loader_and_top() -> dict:
    parent_loader = PARENT / "src/user_source/hdl_source/tf_bmp_file_player.v"
    candidate_loader = CANDIDATE / "src/user_source/hdl_source/tf_bmp_file_player.v"
    control = CANDIDATE / "src/user_source/hdl_source/player_adjust_control.v"
    top = CANDIDATE / "src/user_source/hdl_source/top_tf_hdmi_audio.v"
    selected = read_json(CANDIDATE / "build/selected_changes.json")
    selected = {clean_rel(path): record for path, record in selected.items()}
    loader_path = "user_source/hdl_source/tf_bmp_file_player.v"
    control_path = "user_source/hdl_source/player_adjust_control.v"
    require(loader_path in selected and control_path in selected,
            "event loader/control changes must have explicit source receipts")
    require(sha(candidate_loader) == selected[loader_path]["sha256"].lower(),
            "candidate loader SHA differs from the selected source receipt")
    require(sha(control) == selected[control_path]["sha256"].lower(),
            "candidate key control SHA differs from the selected source receipt")
    require(loader_main_state_bytes(candidate_loader) == loader_main_state_bytes(parent_loader),
            "loader main state-machine body changed from C11317")

    loader_text = candidate_loader.read_text(encoding="utf-8-sig")
    control_text = control.read_text(encoding="utf-8-sig")
    top_text = top.read_text(encoding="utf-8-sig")
    require("key_next_req_toggle" in loader_text and "key_next_ack_toggle" in loader_text,
            "loader toggle request/ack ports are missing")
    require("key_event_mailbox_sink u_key_event_mailbox" in loader_text,
            "loader does not instantiate the event sink")
    require("key_press_debounce" not in loader_text,
            "legacy synthesized-level debouncers remain in the selected loader")
    require("next_ack_sync <= {next_ack_sync[0], next_ack_async};" in control_text,
            "control source does not synchronize sink acknowledgement")
    require("auto_ack_sync <= {auto_ack_sync[0], auto_ack_async};" in control_text,
            "control source does not synchronize auto acknowledgement")
    require("next_req_busy = (next_req_toggle != next_ack_sync[1])" in control_text,
            "next request is not held until synchronized acknowledgement")
    require("auto_req_busy = (auto_req_toggle != auto_ack_sync[1])" in control_text,
            "auto request is not held until synchronized acknowledgement")

    normalized_top = re.sub(r"\s+", " ", top_text)
    required_connections = (
        r"u_bmp_file_player\s*\([^;]*?\.clk\s*\(\s*sd_card_clk\s*\).*?"
        r"\.key_next_req_toggle\s*\(\s*bmp_key_next_req\s*\).*?"
        r"\.key_auto_req_toggle\s*\(\s*bmp_key_auto_req\s*\).*?"
        r"\.key_next_ack_toggle\s*\(\s*bmp_key_next_ack\s*\).*?"
        r"\.key_auto_ack_toggle\s*\(\s*bmp_key_auto_ack\s*\)"
    )
    require(re.search(required_connections, normalized_top, re.I),
            "top loader request/ack toggles are not bound to the sd_card_clk domain")
    control_ports = r"u_adjust_control\s*\([^;]*?\.clk\s*\(\s*video_clk\s*\).*?"
    control_ports += r"\.next_req_toggle\s*\(\s*bmp_key_next_req\s*\).*?"
    control_ports += r"\.next_ack_async\s*\(\s*bmp_key_next_ack\s*\).*?"
    control_ports += r"\.auto_req_toggle\s*\(\s*bmp_key_auto_req\s*\).*?"
    control_ports += r"\.auto_ack_async\s*\(\s*bmp_key_auto_ack\s*\)"
    require(re.search(control_ports, normalized_top, re.I),
            "top control request/ack toggles are not bound to the video_clk domain")

    sink = loader_text.split("module key_event_mailbox_sink", 1)[1]
    for token in (
        "reg [1:0] next_req_sync",
        "reg [1:0] auto_req_sync",
        "next_ack_toggle<=1'b0",
        "auto_ack_toggle<=1'b0",
        "next_press<=1'b0",
        "auto_press<=1'b0",
        "if(next_req_sync[1]!=next_ack_toggle)",
        "if(auto_req_sync[1]!=auto_ack_toggle)",
    ):
        require(token in sink, f"event sink reset/ack/pulse contract missing {token!r}")

    return {"status": "PASS", "loader_main_state_machine": "byte-identical to C11317"}


def check_status_architecture() -> str:
    top = (CANDIDATE / "src/user_source/hdl_source/top_tf_hdmi_audio.v").read_text(encoding="utf-8-sig")
    project = (CANDIDATE / "src/td_project/AC201_tf_hdmi.al").read_text(encoding="utf-8-sig")
    mode = status_architecture_mode(top)
    require(mode in ("video", "legacy"), "candidate status 595 clock/wiring is not a recognized single architecture")
    selected = read_json(CANDIDATE / "build/selected_changes.json")
    mailbox_change = selected.get(MAILBOX)
    mailbox_path = CANDIDATE / "src/user_source/hdl_source/player_status_mailbox.v"
    if mode == "video":
        require(mailbox_change and mailbox_change.get("action") == "remove",
                "video-domain mode requires an explicit mailbox-retirement source receipt")
        require(not mailbox_path.exists(), "video-domain mode still has mailbox source in candidate")
        require("player_status_mailbox.v" not in project, "video-domain project still compiles mailbox source")
    else:
        require(not mailbox_change or mailbox_change.get("action") != "remove",
                "legacy mode and selected mailbox removal receipt disagree")
        require(mailbox_path.is_file(), "legacy mode is missing its mailbox source")
        require("player_status_mailbox.v" in project, "legacy project does not compile mailbox source")
        require(sha(mailbox_path) == sha(PARENT / "src/user_source/hdl_source/player_status_mailbox.v"),
                "legacy mailbox source differs from C11317")
    return mode


def check_build_stage_guard() -> dict:
    # Candidate build scripts are forked from C11317 with only path/build-ID
    # substitutions. This check catches any drift in the stage evidence gates.
    compare_paths = []
    for folder in ("scripts",):
        parent_folder = PARENT / folder
        candidate_folder = CANDIDATE / folder
        for parent_path in parent_folder.rglob("*"):
            if not parent_path.is_file():
                continue
            rel = parent_path.relative_to(parent_folder).as_posix()
            candidate_path = candidate_folder / rel
            require(candidate_path.is_file(), f"candidate build script missing: {rel}")
            if sha(parent_path) == sha(candidate_path):
                continue
            parent_text = parent_path.read_text(encoding="utf-8-sig")
            candidate_text = candidate_path.read_text(encoding="utf-8-sig")
            require(
                candidate_text == normalized_candidate_text(parent_text),
                f"candidate build script has an unreviewed change: {rel}",
            )
            compare_paths.append(rel)

    build = CANDIDATE / "scripts/build_candidate.ps1"
    evidence = CANDIDATE / "scripts/build_evidence.ps1"
    build_text = build.read_text(encoding="utf-8-sig")
    evidence_text = evidence.read_text(encoding="utf-8-sig")
    for token in (
        "build_source_scope.json",
        "Start-StageEvidence",
        "Complete-StageEvidence",
        "Sources changed since synthesis",
        "do not generate bitstream",
    ):
        require(token in build_text, f"candidate stage guard is missing {token!r}")
    for token in (
        "scopeHash",
        "scriptHash",
        "gate database",
        "Assert-RouteArtifacts",
        "Timing violation remains",
    ):
        require(token in evidence_text, f"candidate stage evidence is missing {token!r}")

    return {"stage_guard_status": "preserved", "adapted_script_paths": compare_paths}


def main() -> None:
    parent = check_parent_anchors()
    scope = check_candidate_scope(parent)
    event = check_event_loader_and_top()
    status_mode = check_status_architecture()
    protected = check_protected_domains()
    guard = check_build_stage_guard()
    summary = {
        "status": "PASS",
        "audit": "C11317-to-C11318 static source scope and integration guard",
        "parent_source_files": parent["snapshot_files"],
        "parent_frozen_files": parent["frozen_files"],
        "protected_bitstream_count": len(parent["protected_bitstreams"]),
        "changed_candidate_sources": scope["changed_sources"],
        "selected_sources": sorted(scope["selected_sources"]),
        "event_loader_main_state_machine": event["loader_main_state_machine"],
        "status_architecture_mode": status_mode,
        "protected_source_count": protected["protected_source_count"],
        "stage_guard_status": guard["stage_guard_status"],
        "adapted_script_paths": guard["adapted_script_paths"],
    }
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
