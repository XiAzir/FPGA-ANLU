"""Replay the established photo/audio/FFT golden against the live video19 candidate."""
from __future__ import annotations

from datetime import datetime
import argparse
import json
import re
import shutil
import sys
import xml.etree.ElementTree as ET
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
PLAYER = ROOT / "development/video19_work/diagnostics_trim"
BASE = ROOT / "development/system_verification_20261016"
INTEGRATION = BASE / "integration"
CARD = BASE / "card"
sys.path.insert(0, str(INTEGRATION))
from common import BIN, EG4, HDMI, compile_sources, execute, sha
from prepare_golden import prepare
from verify_fft_trace import verify as verify_fft


def compat_source(path: Path, run_dir: Path) -> tuple[Path, dict | None]:
    text = path.read_text(encoding="utf-8-sig")
    original = text
    if path.name in ("top_tf_hdmi_audio.v", "player_status_monitor.v"):
        pattern = (r"^\s*wire\s+bmp_write_ready\s*;[^\n]*\n" if path.name == "top_tf_hdmi_audio.v"
                   else r"^\s*reg\s+request_toggle,\s*ack_sync0,\s*ack_sync1\s*;[^\n]*\n")
        match = re.search(pattern, text, re.M)
        if match:
            text = text[:match.start()] + text[match.end():]
            anchor = text.index(";", text.index("module ")) + 1
            text = text[:anchor] + "\n" + match.group().strip() + "\n" + text[anchor:]
    if path.name == "frame_read_write.v":
        for instance, port, signal in (("frame_fifo_write_m0", "rdusedw", "rdusedw"),
                                       ("frame_fifo_read_m0", "wrusedw", "wrusedw")):
            start = text.index(instance)
            end = text.index(");", start) + 2
            block, count = re.subn(r"(\." + port + r"\s*\()\s*" + signal + r"\s*(\))",
                                   lambda m: m[1] + "{1'b0," + signal + "}" + m[2], text[start:end])
            if count != 1:
                raise RuntimeError(f"unexpected FIFO count connection in {path}")
            text = text[:start] + block + text[end:]
    if path.name == "jpeg_dht.v":
        declarations = []
        for name in ("idx_q", "total_entries_q"):
            match = re.search(r"^\s*reg\s+\[11:0\]\s+" + name + r"\s*;[^\n]*\n", text, re.M)
            if not match:
                raise RuntimeError(f"ModelSim forward declaration not found: {name}")
            declarations.append(match.group().strip())
            text = text[:match.start()] + text[match.end():]
        anchor = text.index("    // DHT tables can be combined")
        text = text[:anchor] + "\n".join(declarations) + "\n" + text[anchor:]
    if text == original:
        return path, None
    path.write_text(text, encoding="utf-8")
    return path, {"path": str(path), "copy_sha256": sha(path),
                  "change": "ModelSim declaration ordering / explicit FIFO count extension"}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--fft-only", type=Path,
                        help="run the existing FFT trace oracle and update that run's summary")
    args = parser.parse_args()
    if args.fft_only:
        run_dir = args.fft_only.resolve()
        log = (run_dir / "console.log").read_text(encoding="utf-8", errors="replace")
        fft_result = verify_fft(out=run_dir)
        summary_path = run_dir / "summary.json"
        result = json.loads(summary_path.read_text(encoding="utf-8"))
        media_pass = ("SYSTEM_MEDIA_PASS" in log and "PHOTO_MODE_GUARD_PASS" in log and
                      not re.search(r"\*\* (?:Error|Fatal)", log))
        result["fft"] = fft_result
        result["status"] = "PASS" if media_pass and fft_result.get("status") == "PASS_SCOPE" else "FAILED"
        summary_path.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
        print(json.dumps({"status": result["status"], "fft": fft_result,
                          "run_dir": str(run_dir)}, indent=2))
        if result["status"] != "PASS":
            raise SystemExit(2)
        return

    run_name = "photo_system_" + datetime.now().strftime("%Y%m%d_%H%M%S")
    run_dir = HERE / "runs" / run_name
    run_dir.mkdir(parents=True)
    td = PLAYER / "src/td_project"
    hdl = PLAYER / "src/user_source/hdl_source"
    project_text = re.sub(r"&(?!amp;|lt;|gt;|quot;|apos;)", "&amp;",
                          (td / "AC201_tf_hdmi.al").read_text(encoding="utf-8-sig"))
    project = ET.fromstring(project_text)
    excluded = {"sys_pll.v", "video_pll.v", "sdram.v",
                "sdr_as_ram.enc.v", "sdr_init_ref.enc.v", "sdr_wrrd.enc.v"}
    source_paths = []
    for entry in project.findall("Source_Files/Verilog/File"):
        attrs = {item.get("Name"): item.get("Val") for item in entry.findall("FileInfo/Attr")}
        source = (td / entry.get("Path")).resolve()
        if attrs.get("AutoExcluded") != "true" and source.name not in excluded:
            source_paths.append(source)
    source_paths.extend(hdl / "IP" / name for name in ("afifo_16_32_256.v", "afifo_32_16_256.v"))
    source_paths = list(dict.fromkeys(source_paths))

    frozen = run_dir / "frozen"
    receipt = []
    copied_sources = []
    compatibility = []
    for source in source_paths:
        destination = frozen / source.relative_to(PLAYER)
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, destination)
        receipt.append({"source": str(source), "source_sha256": sha(source),
                        "copy": str(destination), "copy_sha256": sha(destination)})
        compat, change = compat_source(destination, run_dir)
        if change:
            compatibility.append(change)
            receipt[-1]["compat_copy_sha256"] = sha(compat)
        copied_sources.append(compat)
    for source in list(hdl.rglob("*.vh")) + [hdl / "SD/video_define.v"]:
        destination = frozen / source.relative_to(PLAYER)
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, destination)
        receipt.append({"source": str(source), "source_sha256": sha(source),
                        "copy": str(destination), "copy_sha256": sha(destination)})

    replay = BASE / "memory/vendor_qualification/clock_replay"
    proof_path = replay / "summary.json"
    proof = json.loads(proof_path.read_text(encoding="utf-8-sig"))
    if proof.get("status") != "PASS_SCOPE" or sha(replay / "pll_clock_replay.v").lower() != proof["replay_sha256"].lower():
        raise RuntimeError("qualified nominal PLL replay is missing or has changed")
    for name, source in (("sys_wrapper", hdl / "IP/sys_pll.v"),
                         ("video_wrapper", hdl / "IP/video_pll.v")):
        if sha(source).lower() != proof["source_sha256"][name].lower():
            raise RuntimeError(f"PLL replay source binding changed: {name}")

    model_sources = [replay / "pll_clock_replay.v", INTEGRATION / "pll_replay_wrappers.v",
                     BASE / "memory/sdram_app_model.v", BASE / "card/sd_spi_card_model.v",
                     Path("C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_phy_glbl.v")]
    for source in model_sources:
        destination = run_dir / source.name
        shutil.copy2(source, destination)
        copied_sources.append(destination)
        receipt.append({"source": str(source), "source_sha256": sha(source),
                        "copy": str(destination), "copy_sha256": sha(destination)})

    card_manifest = json.loads((CARD / "manifest.json").read_text(encoding="utf-8"))
    if card_manifest["image_bytes"] != 64 * 1024 * 1024 or card_manifest["populated_sectors"] != 2073:
        raise RuntimeError("unexpected archived 16x16 BMP/4096-sample card fixture")
    for name in ("packed_mem.mem", "lba_map.mem", "wave_samples.mem"):
        source = CARD / name
        destination = run_dir / name
        shutil.copy2(source, destination)
        receipt.append({"source": str(source), "source_sha256": sha(source),
                        "copy": str(destination), "copy_sha256": sha(destination)})
    prepare(CARD, run_dir)
    shutil.copy2(PLAYER / "src/td_project/AC201_tf_hdmi.al", run_dir / "AC201_tf_hdmi.al")
    shutil.copy2(PROJECT_TB := INTEGRATION / "run_C11309_20261016_181233/tb_system.v",
                 run_dir / "tb_system.v")
    shutil.copy2(BASE / "integration/verify_fft_trace.py", run_dir / "verify_fft_trace.py")
    oracle = ROOT / "development/player_spectrum_fft_recover/sim/spectrum_oracle.py"
    shutil.copy2(oracle, run_dir / "spectrum_oracle.py")

    tb = run_dir / "tb_system.v"
    tb_text = tb.read_text(encoding="utf-8")
    guard = '''
always @(negedge dut.sd_card_clk) if (!dut.rst_all) begin
    if (dut.video_mode_press !== 1'b0 || dut.video_mode !== 1'b0 || dut.video_mode_sd !== 1'b0)
        $fatal(1, "photo regression left default photo mode: press=%b mode=%b sd_mode=%b",
            dut.video_mode_press, dut.video_mode, dut.video_mode_sd);
end
'''
    anchor = " always @(negedge dut.sd_card_clk)if(!dut.rst_all)begin"
    if tb_text.count(anchor) != 1:
        raise RuntimeError("legacy media scoreboard insertion point changed")
    tb_text = tb_text.replace(anchor, guard + anchor)
    tb_text = tb_text.replace('    $display("SYSTEM_MEDIA_PASS',
                              '    $display("PHOTO_MODE_GUARD_PASS video_mode=0 video_mode_press=0");\n'
                              '    $display("SYSTEM_MEDIA_PASS')
    tb.write_text(tb_text, encoding="utf-8")

    (run_dir / "modelsim.ini").write_text(
        "[Library]\nwork = work\neg4 = " + EG4.as_posix() + "\nhdmi = " + HDMI.as_posix() +
        "\nothers = E:/ModelsimSE/modelsim.ini\n", encoding="ascii"
    )
    (run_dir / "run.do").write_text(
        "onerror {quit -code 2 -f}\nonbreak {quit -code 3 -f}\nrun -all\nquit -code 0 -f\n",
        encoding="ascii",
    )
    flags = [
        "+define+HAS_FFT",
        "+incdir+" + "+".join(p.as_posix() for p in (
            frozen / "src/user_source/hdl_source",
            frozen / "src/user_source/hdl_source/include",
            frozen / "src/user_source/hdl_source/SD",
            frozen / "src/td_project",
        )),
    ]
    (run_dir / "source_receipt.json").write_text(json.dumps({
        "candidate_project": str(td / "AC201_tf_hdmi.al"),
        "candidate_project_sha256": sha(td / "AC201_tf_hdmi.al"),
        "inputs": receipt,
        "compatibility_copies": compatibility,
        "golden_tb_source": str(PROJECT_TB),
        "golden_tb_sha256": sha(PROJECT_TB),
        "run_tb_sha256": sha(tb),
        "fixture_golden": json.loads((run_dir / "golden_receipt.json").read_text()),
        "fixture_card_manifest_sha256": sha(CARD / "manifest.json"),
        "fft_oracle_sha256": sha(oracle),
        "mode": "photo default; key1/key2 held inactive; video_mode_press/video_mode/video_mode_sd asserted low",
    }, indent=2), encoding="utf-8")

    compile_result = compile_sources(run_dir, copied_sources, flags, tb)
    command = [BIN / "vsim.exe", "-modelsimini", "modelsim.ini", "-c", "-lic_noqueue",
               "-novopt", "-suppress", "3017,3722", "-L", "work", "-L", "eg4", "-L", "hdmi",
               "work.tb_system", "work.glbl", "+max_ms=200", "-do", "run.do", "-l", "run.log"]
    simulation = execute(command, run_dir, "console.log", 1800)
    log = (run_dir / "console.log").read_text(encoding="utf-8", errors="replace")
    media_pass = (simulation["exit_code"] == 0 and "SYSTEM_MEDIA_PASS" in log and
                  "PHOTO_MODE_GUARD_PASS" in log and not re.search(r"\*\* (?:Error|Fatal)", log))
    fft_result = None
    if media_pass:
        try:
            fft_result = verify_fft(out=run_dir)
        except Exception as error:
            fft_result = {"status": "FAILED", "error": str(error)}
    passed = media_pass and fft_result and fft_result.get("status") == "PASS_SCOPE"
    result = {
        "status": "PASS" if passed else "FAILED",
        "candidate": str(PLAYER),
        "photo_mode_default": True,
        "video_mode_press_injected": False,
        "compile": compile_result,
        "simulation": simulation,
        "fft": fft_result,
        "assumptions": ["qualified nominal PLL edge replay", "application-interface SDRAM model",
                        "archived 64MiB SDHC fixture with PIC.BMP and 4096-sample TEST.WAV"],
        "unverified": ["physical SDRAM timing", "SDF", "physical board behavior", "HDMI serial content"],
        "run_log": str(run_dir / "console.log"),
    }
    (run_dir / "summary.json").write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(log[-6000:], flush=True)
    print(json.dumps(result, indent=2), flush=True)
    if not passed:
        raise SystemExit(2)


if __name__ == "__main__":
    main()
