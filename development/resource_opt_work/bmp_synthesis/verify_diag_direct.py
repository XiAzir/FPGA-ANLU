"""Run the public 21-case failure_detail regression on a temporary diag-direct copy."""
from __future__ import annotations

import hashlib
import json
from datetime import datetime
from pathlib import Path
import os
import shutil
import subprocess
import sys


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
ACTIVE = ROOT / "development/player_spectrum_trace"
ACTIVE_HDL = ACTIVE / "src/user_source/hdl_source"
TB = ACTIVE / "sim/tb_tf_bmp_failure_detail.v"
PROPOSAL = ROOT / "development/resource_opt_work/bmp_proposal.py"


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def tools() -> tuple[Path, Path]:
    path = os.environ.get("ANLU_IVERILOG_BIN")
    if path:
        folder = Path(path)
        return folder / "iverilog.exe", folder / "vvp.exe"
    first, second = shutil.which("iverilog"), shutil.which("vvp")
    if first and second:
        return Path(first), Path(second)
    folder = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin"
    return folder / "iverilog.exe", folder / "vvp.exe"


def main() -> None:
    tag = datetime.now().strftime("%Y%m%d_%H%M%S_%f")
    run = HERE / "diag_verify" / f"run_{tag}"
    hdl = run / "src/user_source/hdl_source"
    sim = run / "sim"
    model = run / "build/model"
    hdl.mkdir(parents=True)
    (hdl / "SD").mkdir()
    sim.mkdir()
    model.mkdir(parents=True)
    for name in ("bmp_scale_engine.v", "tf_bmp_file_player.v"):
        shutil.copy2(ACTIVE_HDL / name, hdl / name)
    shutil.copy2(ACTIVE_HDL / "SD/sd_card_bmp.v", hdl / "SD/sd_card_bmp.v")
    shutil.copy2(TB, sim / TB.name)

    ns: dict[str, object] = {}
    text = PROPOSAL.read_text(encoding="utf-8-sig")
    exec(compile(text, str(PROPOSAL), "exec"), ns)
    (ns["apply"])(hdl, widths=False, diagnostic_direct=True)

    iverilog, vvp = tools()
    image = model / "bmp_failure_detail.vvp"
    compile_log = model / "compile.log"
    run_log = model / "run.log"
    sources = [hdl / "tf_bmp_file_player.v", hdl / "bmp_scale_engine.v",
               hdl / "SD/sd_card_bmp.v", sim / TB.name]
    with compile_log.open("w", encoding="utf-8", newline="\n") as output:
        result = subprocess.run([str(iverilog), "-g2012", "-Wall", "-s",
                                 "tb_tf_bmp_failure_detail", "-o", str(image),
                                 *(str(path) for path in sources)],
                                cwd=model, stdout=output, stderr=subprocess.STDOUT,
                                check=False)
    if result.returncode:
        raise RuntimeError(f"Icarus compile failed; see {compile_log}")
    with run_log.open("w", encoding="utf-8", newline="\n") as output:
        result = subprocess.run([str(vvp), str(image)], cwd=model, stdout=output,
                                stderr=subprocess.STDOUT, check=False, timeout=120)
    output = run_log.read_text(encoding="utf-8", errors="replace")
    marker = "BMP_FAILURE_DETAIL PASS cases=21 "
    if result.returncode or marker not in output or any(line.startswith("FAIL") for line in output.splitlines()):
        raise RuntimeError(f"21-case failure_detail model failed; see {run_log}\n{output[-3000:]}")
    report = {
        "status": "PASS",
        "pass_marker": next(line for line in output.splitlines() if line.startswith(marker)),
        "source_sha256": {
            "original_engine": sha(ACTIVE_HDL / "bmp_scale_engine.v"),
            "diag_direct_loader": sha(hdl / "tf_bmp_file_player.v"),
            "key_debounce_source": sha(hdl / "SD/sd_card_bmp.v"),
            "public_tb": sha(sim / TB.name),
        },
        "compile_log": str(compile_log),
        "run_log": str(run_log),
        "variant": "original bmp_scale_engine + diag-direct tf_bmp_file_player + original key_press_debounce",
    }
    (model / "verification.json").write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(report["pass_marker"])
    print(f"BMP_DIAG_DIRECT PASS run={run}")
    print(f"compile={compile_log}")
    print(f"simulation={run_log}")


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        print(f"diag-direct verification failed: {exc}", file=sys.stderr)
        raise
