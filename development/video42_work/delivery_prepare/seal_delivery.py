"""Seal C42 only after offline-check/source/hold-route binding is complete."""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import shutil
import zipfile

ROOT = Path(__file__).resolve().parents[3]
WORK = Path(__file__).resolve().parent
PROJECT = ROOT / "development/player_video42_sdram100"
VERIFY = PROJECT / "verification"
BUILD = PROJECT / "build/manual"
DOWNLOAD = ROOT / "download"
PACKAGE = ROOT / "deliverables/video42_sdram100_20261027"
BASELINE_SHA256 = "f572afe5baa74dc61df58132c172298690c92171d5c631630fec6b02d3c6b7ac"
BIT_NAME = "AC201_player_video42_sdram100.bit"


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def save(path: Path, data: dict) -> None:
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def require_file(path: Path) -> Path:
    if not path.is_file():
        raise RuntimeError(f"Required delivery evidence is missing: {path}")
    return path


def require_hash(path: Path, expected: str, label: str) -> None:
    actual = sha(path)
    if actual.lower() != expected.lower():
        raise RuntimeError(f"{label} hash mismatch: expected {expected}, got {actual}")


def verify_refs(items: list, label: str) -> None:
    for item in items:
        relative = Path(item["path"])
        path = relative if relative.is_absolute() else ROOT / relative
        path = path.resolve()
        if ROOT.resolve() not in path.parents:
            raise RuntimeError(f"{label} path escapes the workspace: {item['path']}")
        require_hash(path, item["sha256"], f"{label} {item['path']}")


def main() -> None:
    offline_path = require_file(VERIFY / "offline_checks.json")
    binding_path = require_file(VERIFY / "final_stage_binding.json")
    route_netlist = require_file(VERIFY / "final_routed.v")
    prep_path = require_file(VERIFY / "preparation.json")
    audit_path = require_file(VERIFY / "source_audit.json")
    offline = load(offline_path)
    binding = load(binding_path)
    prep = load(prep_path)
    audit = load(audit_path)
    if audit.get("status") != "PASS" or audit.get("baseline_bit_sha256") != BASELINE_SHA256:
        raise RuntimeError("Final source audit must pass against the pinned C41 baseline")
    if offline.get("status") != "PASS":
        raise RuntimeError("offline_checks.json status must be PASS before sealing")
    if binding.get("status") != "PASS":
        raise RuntimeError("final_stage_binding.json status must be PASS")

    stages = binding["stages"]
    synthesis = stages["synthesis"]
    hold = stages["hold"]
    bitstream = stages["bitstream"]
    if hold.get("stage") != "hold" or hold.get("status") != "success":
        raise RuntimeError("Final hold-stage evidence is required")
    if bitstream.get("status") != "success" or bitstream.get("routeStage") != "hold":
        raise RuntimeError("Bitstream must be bound to the final hold route")
    for stage in (hold, bitstream):
        if stage.get("synthesisRunId") != synthesis.get("runId"):
            raise RuntimeError("Stage records do not share one synthesis run")
        if stage.get("gateDbHash") != synthesis.get("gateDbHash"):
            raise RuntimeError("Stage records do not share one gate database")

    bit = require_file(BUILD / BIT_NAME)
    require_hash(bit, bitstream["bitHash"], "C42 bitstream")
    for name, digest in hold["artifacts"].items():
        require_hash(BUILD / name, digest, f"hold artifact {name}")
    route_db_sha = hold["artifacts"]["AC201_tf_hdmi_pr.db"]
    route_netlist_sha = sha(route_netlist)
    source_scope_hash = binding["scopeHash"]
    if offline.get("source_scope_hash") != source_scope_hash:
        raise RuntimeError("offline checks are bound to a different source scope")
    if offline.get("final_routed_netlist_sha256") != route_netlist_sha:
        raise RuntimeError("offline checks are bound to a different final routed netlist")
    if offline.get("final_routed_db_sha256") != route_db_sha:
        raise RuntimeError("offline checks are bound to a different final routed database")
    if offline.get("final_bit_sha256") != sha(bit):
        raise RuntimeError("offline checks are bound to a different bitstream")
    checks = offline.get("checks")
    if not isinstance(checks, list) or not checks:
        raise RuntimeError("offline_checks.json must list its checked scopes")
    routed_memory_pass = False
    for check in checks:
        if check.get("status") != "PASS":
            raise RuntimeError(f"Offline check did not pass: {check.get('name', '<unnamed>')}")
        if not check.get("scope") or not check.get("inputs") or not check.get("evidence"):
            raise RuntimeError(f"Offline check scope, inputs, and evidence are required: {check.get('name')}")
        verify_refs(check["inputs"], f"{check.get('name')} input")
        verify_refs(check["evidence"], f"{check.get('name')} evidence")
        if check.get("source_kind") == "final_routed_gate":
            if check.get("final_routed_netlist_sha256") != route_netlist_sha:
                raise RuntimeError(f"Routed gate netlist mismatch: {check.get('name')}")
            if check.get("final_routed_db_sha256") != route_db_sha:
                raise RuntimeError(f"Routed gate database mismatch: {check.get('name')}")
            if check.get("name") == "routed_memory_data":
                routed_memory_pass = True
    if not routed_memory_pass:
        raise RuntimeError("A passing final-routed memory-data check bound to the final route is required")
    for ablation in offline.get("ablations", []):
        if ablation.get("status") != "EXPECTED_FAILURE":
            raise RuntimeError(f"Ablation must be recorded as EXPECTED_FAILURE: {ablation.get('name')}")
        if not ablation.get("scope") or not ablation.get("inputs") or not ablation.get("evidence"):
            raise RuntimeError(f"Ablation scope, inputs, and evidence are required: {ablation.get('name')}")
        verify_refs(ablation["inputs"], f"{ablation.get('name')} ablation input")
        verify_refs(ablation["evidence"], f"{ablation.get('name')} ablation evidence")

    if prep.get("baseline_bit_sha256") != BASELINE_SHA256:
        raise RuntimeError("Preparation record has an unexpected C41 rollback hash")
    baseline = require_file(DOWNLOAD / "video41_refresh.bit")
    require_hash(baseline, BASELINE_SHA256, "C41 rollback bitstream")
    baseline_info = require_file(DOWNLOAD / "video41_refresh.info.json")
    baseline_feedback = require_file(DOWNLOAD / "video41_refresh.board_feedback.json")
    hold_pointer = require_file(BUILD / "stage_evidence/latest_hold.json")
    hold_latest = load(hold_pointer)
    if hold_latest.get("status") != "success" or hold_latest.get("runId") != hold.get("runId"):
        raise RuntimeError("latest_hold.json does not identify the bound final hold run")
    hold_record_path = require_file(hold_pointer.parent / hold_latest["record"])
    hold_record = load(hold_record_path)
    if hold_record.get("runId") != hold.get("runId") or hold_record.get("artifacts") != hold.get("artifacts"):
        raise RuntimeError("Final hold record differs from final_stage_binding.json")
    timing_path = require_file(BUILD / "AC201_tf_hdmi_phy.ts")
    area_path = require_file(BUILD / "AC201_tf_hdmi_phy.area")
    check_timing_path = require_file(BUILD / "AC201_tf_hdmi_chk.timing")
    exception_timing_path = require_file(BUILD / "AC201_tf_hdmi_exception.timing")
    if PACKAGE.exists() or (DOWNLOAD / "video42_sdram100.bit").exists() or (DOWNLOAD / "video42_sdram100.info.json").exists():
        raise RuntimeError("A C42 delivery target already exists; preserve it and review before continuing")
    if PACKAGE.with_suffix(".zip").exists():
        raise RuntimeError("A C42 delivery ZIP already exists; preserve it and review before continuing")
    if (VERIFY / "delivery_receipt.json").exists():
        raise RuntimeError("A prior delivery receipt exists; preserve it and review before continuing")

    source_inputs = {item["path"].replace("\\", "/"): item["sha256"] for item in binding["inputs"]}
    for relative, digest in source_inputs.items():
        require_hash(PROJECT / relative, digest, f"bound source {relative}")
    changed_sources = {}
    for change in audit["changes"]:
        relative = "src/user_source/" + change["path"].replace("\\", "/")
        source = require_file(PROJECT / relative)
        require_hash(source, change["after"], f"changed source {relative}")
        if source_inputs.get(relative) != change["after"]:
            raise RuntimeError(f"Changed source is outside the final source binding: {relative}")
        changed_sources[f"source/{change['path'].replace(chr(92), '/')}"] = source

    timing_summary = timing_path.read_text(encoding="utf-8", errors="replace")
    timing_match = re.search(
        r"SWNS:\s*([+-]?[\d.]+)ns,\s*STNS:\s*([+-]?[\d.]+)ns\.\s*"
        r"HWNS:\s*([+-]?[\d.]+)ns,\s*HTNS:\s*([+-]?[\d.]+)ns\.",
        timing_summary,
    )
    if not timing_match:
        raise RuntimeError("Final routed timing summary could not be parsed")
    setup_wns, setup_tns, hold_wns, hold_tns = map(float, timing_match.groups())
    if min(setup_wns, hold_wns) < 0 or setup_tns != 0 or hold_tns != 0:
        raise RuntimeError("Final routed setup/hold timing is not closed")

    area_text = area_path.read_text(encoding="utf-8", errors="replace")
    resources = {
        "lut": int(re.search(r"^#lut\s+(\d+)", area_text, re.M)[1]),
        "reg": int(re.search(r"^#reg\s+(\d+)", area_text, re.M)[1]),
        "logic_elements": int(re.search(r"^#le\s+(\d+)", area_text, re.M)[1]),
        "bram": int(re.search(r"^#bram\s+(\d+)", area_text, re.M)[1]),
        "dsp": int(re.search(r"^#dsp\s+(\d+)", area_text, re.M)[1]),
    }
    qor_path=require_file(VERIFY / "final_route.qor")
    qor_text=qor_path.read_text(encoding="utf-8",errors="replace")
    slices=int(re.search(r"#slices\s*\|\s*(\d+)",qor_text)[1])
    resources["slices"]=slices
    resources["slice_percent"]=slices/9800*100

    timestamp = datetime.now(timezone.utc).isoformat()
    info = {
        "status": "OFFLINE_VERIFIED_BOARD_PENDING",
        "build_id": "00C11342",
        "created_utc": timestamp,
        "filename": "video42_sdram100.bit",
        "bit_sha256": sha(bit),
        "bit_bytes": bit.stat().st_size,
        "purpose": "SDRAM升至100MHz，按8ns转发相位对齐读数据；补齐初始化刷新就绪条件，简化FIFO写入仲裁。",
        "board_result": "PENDING",
        "clocks_hz": {"tf_spi_data": 25_000_000, "sd_logic": 50_000_000, "sdram": 100_000_000,
                       "pixel": 25_000_000, "serializer": 125_000_000},
        "sdram_forward_phase_ns":8,
        "sdram_read_data_delay_cycles":0,
        "timing_ns": {"setup_wns": setup_wns, "setup_tns": setup_tns,
                      "hold_wns": hold_wns, "hold_tns": hold_tns},
        "resources": resources,
        "timing_scope": "Final routed hold-stage evidence; board I/O behavior and full media playback require separate confirmation.",
        "runtime_pages": {"00C11342": "版本", "C000xxxx": "TF已校验扇区计数", "E000xxxx": "TF CRC不一致扇区计数"},
        "source_scope_hash": source_scope_hash,
        "final_routed_netlist_sha256": route_netlist_sha,
        "final_routed_db_sha256": route_db_sha,
        "offline_checks_sha256": sha(offline_path),
        "final_stage_binding_sha256": sha(binding_path),
        "rollback_bit_sha256": BASELINE_SHA256,
        "outstanding": ["C42整机实板图片、视频、音频与模式切换验证", "冷启动与长期运行验证"],
    }

    # All gating checks complete before any delivery artifact is written.
    download_bit = DOWNLOAD / "video42_sdram100.bit"
    download_info = DOWNLOAD / "video42_sdram100.info.json"
    save_info = json.dumps(info, ensure_ascii=False, indent=2) + "\n"
    shutil.copy2(bit, download_bit)
    download_info.write_text(save_info, encoding="utf-8")
    PACKAGE.mkdir(parents=True, exist_ok=False)
    payloads = {
        "00_START_HERE.md":require_file(WORK / "00_START_HERE.md"),
        "反馈模板.txt":require_file(WORK / "反馈模板.txt"),
        "video42_sdram100.bit": download_bit,
        "video42_sdram100.info.json": download_info,
        "rollback/video41_refresh.bit": baseline,
        "rollback/video41_refresh.info.json": baseline_info,
        "rollback/video41_refresh.board_feedback.json": baseline_feedback,
        "evidence/offline_checks.json": offline_path,
        "evidence/final_stage_binding.json": binding_path,
        "evidence/preparation.json": prep_path,
        "evidence/source_audit.json": audit_path,
        "evidence/final_route.qor":qor_path,
        "evidence/final_hold_stage.json": hold_pointer,
        "evidence/final_hold_record.json": hold_record_path,
        "evidence/physical_sta.timing": timing_path,
        "evidence/physical_sta.area": area_path,
        "evidence/check_timing.timing": check_timing_path,
        "evidence/exception_timing.timing": exception_timing_path,
    }
    payloads.update(changed_sources)
    # Include the result logs referenced by the summary, preserving their
    # workspace-relative paths so the package is reviewable on another PC.
    for check in offline["checks"] + offline.get("ablations", []):
        for item in check["evidence"]:
            source = Path(item["path"])
            source = source if source.is_absolute() else ROOT / source
            relative = source.relative_to(ROOT).as_posix()
            payloads["evidence/referenced/" + relative] = source
    for name, source in payloads.items():
        target = PACKAGE / name
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, target)

    manifest = {
        path.relative_to(PACKAGE).as_posix(): {"sha256": sha(path), "bytes": path.stat().st_size}
        for path in sorted(PACKAGE.rglob("*")) if path.is_file()
    }
    save(PACKAGE / "manifest.json", {"created_utc": timestamp, "files": manifest})
    zip_path = PACKAGE.with_suffix(".zip")
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for path in sorted(PACKAGE.rglob("*")):
            if path.is_file():
                archive.write(path, path.relative_to(PACKAGE).as_posix())
    with zipfile.ZipFile(zip_path) as archive:
        if archive.testzip() is not None:
            raise RuntimeError("ZIP CRC verification failed")
        for name, item in manifest.items():
            if hashlib.sha256(archive.read(name)).hexdigest() != item["sha256"]:
                raise RuntimeError(f"ZIP payload hash mismatch: {name}")
        if archive.read("video42_sdram100.bit") != bit.read_bytes():
            raise RuntimeError("ZIP C42 bitstream differs from the bound routed bitstream")
        if archive.read("rollback/video41_refresh.bit") != baseline.read_bytes():
            raise RuntimeError("ZIP rollback bit differs from the pinned C41 bitstream")

    receipt = {
        "status": "PACKAGE_HASH_VERIFIED_BOARD_PENDING",
        "created_utc": timestamp,
        "zip": zip_path.relative_to(ROOT).as_posix(),
        "zip_sha256": sha(zip_path),
        "zip_bytes": zip_path.stat().st_size,
        "payload_files_checked": len(manifest),
        "bit_sha256": sha(bit),
        "rollback_bit_sha256": sha(baseline),
        "source_scope_hash": source_scope_hash,
        "final_routed_netlist_sha256": route_netlist_sha,
        "final_routed_db_sha256": route_db_sha,
    }
    save(VERIFY / "delivery_receipt.json", receipt)
    print(json.dumps(receipt, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
