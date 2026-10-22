from datetime import datetime
from pathlib import Path
import hashlib
import json
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
BIN = Path(r"E:\ModelsimSE\win64")
MODEL_ROOT = ROOT / "models"
TB = ROOT / "tb/tb_fifo_depth.v"
EG4 = Path(r"E:\VSCODE-project\FPGA-ANLU\development\player_spectrum_fft_recover\build\board_feedback_no_signal_20261014\modelsim\work")
HDMI = Path(r"E:\VSCODE-project\FPGA-ANLU\development\player_spectrum_fft_recover\build\board_feedback_no_signal_20261014\video_modelsim\work")
VENDOR_MODEL = Path(r"C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\sim_release\eg4\eg_logic_ramfifo.v")


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest().upper()


def execute(command: list[str], cwd: Path, log_name: str) -> dict:
    log = cwd / log_name
    with log.open("w", encoding="utf-8", errors="replace") as stream:
        proc = subprocess.Popen(command, cwd=cwd, stdout=stream, stderr=subprocess.STDOUT)
        code = proc.wait()
    return {"command": command, "exit_code": code, "log": str(log), "sha256": sha(log)}


def main() -> None:
    stamp = datetime.now().strftime("primitive_%Y%m%d_%H%M%S")
    run_root = ROOT / "runs" / stamp
    run_root.mkdir(parents=True)
    results = []
    for variant, expected_depth in (("original", 1024), ("depth128", 128), ("depth256", 256)):
        run = run_root / variant
        run.mkdir()
        model = MODEL_ROOT / variant / "eg_logic_ramfifo.v"
        shutil.copy2(model, run / "eg_logic_ramfifo.v")
        shutil.copy2(TB, run / "tb_fifo_depth.v")
        (run / "modelsim.ini").write_text(
            "[Library]\nwork = work\neg4 = " + EG4.as_posix() + "\nhdmi = " + HDMI.as_posix() +
            "\nothers = E:/ModelsimSE/modelsim.ini\n", encoding="ascii")
        (run / "run.do").write_text(
            "onerror {quit -code 2 -f}\nonbreak {quit -code 3 -f}\nrun -all\nquit -code 0 -f\n",
            encoding="ascii")
        vlib = execute([str(BIN / "vlib.exe"), "work"], run, "vlib.log")
        if vlib["exit_code"] != 0:
            results.append({"variant": variant, "status": "VLIB_FAILED", "vlib": vlib})
            continue
        vlog = execute([str(BIN / "vlog.exe"), "-modelsimini", "modelsim.ini", "-work", "work",
                        str(run / "eg_logic_ramfifo.v"), str(run / "tb_fifo_depth.v")], run, "vlog.log")
        if vlog["exit_code"] != 0:
            results.append({"variant": variant, "status": "VLOG_FAILED", "vlib": vlib, "vlog": vlog})
            continue
        vsim = execute([str(BIN / "vsim.exe"), "-modelsimini", "modelsim.ini", "-c", "-lic_noqueue",
                        "-novopt", "-suppress", "3017,3722", "-L", "work", "-L", "eg4",
                        "work.tb_fifo_depth", f"-gEXPECTED_DEPTH={expected_depth}", "-do", "run.do"],
                       run, "vsim.log")
        log = (run / "vsim.log").read_text(encoding="utf-8", errors="replace")
        passed = vsim["exit_code"] == 0 and f"FIFO_DEPTH_PASS depth={expected_depth}" in log and "** Fatal" not in log
        result = {"variant": variant, "depth": expected_depth, "status": "PASS" if passed else "FAILED",
                  "model_sha256": sha(model), "tb_sha256": sha(TB), "vlib": vlib, "vlog": vlog, "vsim": vsim}
        results.append(result)
        print(f"{variant}: {result['status']} depth={expected_depth} vlog={vlog['exit_code']} vsim={vsim['exit_code']}", flush=True)

    status = "PASS" if len(results) == 3 and all(item["status"] == "PASS" for item in results) else "FAILED"
    summary = {"status": status, "scope": "EG_LOGIC_RAMFIFO depth/full/empty/data/read-latency primitive regression",
               "vendor_model": str(VENDOR_MODEL), "vendor_model_sha256": sha(VENDOR_MODEL),
               "tb": str(TB), "tb_sha256": sha(TB), "results": results}
    (run_root / "summary.json").write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"status": status, "run": str(run_root),
                      "variants": [{"variant": x["variant"], "status": x["status"]} for x in results]}, indent=2))
    if status != "PASS":
        raise SystemExit(2)


if __name__ == "__main__":
    main()
