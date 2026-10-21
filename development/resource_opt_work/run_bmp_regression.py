"""Prepare and optionally run isolated BMP scaler regressions.

The runner copies an explicitly selected candidate HDL tree and the existing
six-frame, malformed-input, and engine-smoke test assets into a fresh workspace
under development/resource_opt_work. It never writes to the original project
or the selected candidate. Pass --run to execute Icarus regressions; without
--run it only prepares the workspace for inspection.
"""
from __future__ import annotations

import argparse
from datetime import datetime
from pathlib import Path
import shutil
import subprocess
import sys


REPO = Path(__file__).resolve().parents[2]
RESOURCE_WORK = Path(__file__).resolve().parent
MODEL_SOURCE = REPO / "development/player_bmp_scale/build/model"
PS = shutil.which("pwsh")

MODEL_FILES = (
    "scaler_make_media.py",
    "scaler_full_loader.ps1",
    "scaler_bad_inputs.ps1",
    "scaler_write_receipt.ps1",
    "tb_scaler_full_loader.v",
    "tb_scaler_bad_inputs.v",
    "run_engine_smoke.ps1",
    "tb_engine_smoke.v",
)


def _patch_script(text: str, label: str) -> str:
    old = ". (Join-Path $PSScriptRoot '../../../../scripts/anlu_tools.ps1')"
    count = text.count(old)
    if count:
        text = text.replace(old, ". (Join-Path $PSScriptRoot 'anlu_tools.ps1')")
    return text


def _prepare(candidate_hdl: Path, run_root: Path) -> Path:
    candidate_hdl = candidate_hdl.resolve()
    if not (candidate_hdl / "bmp_scale_engine.v").is_file():
        raise FileNotFoundError(f"candidate engine missing under {candidate_hdl}")
    if not (candidate_hdl / "tf_bmp_file_player.v").is_file():
        raise FileNotFoundError(f"candidate loader missing under {candidate_hdl}")
    if run_root.exists():
        raise FileExistsError(f"refusing to reuse regression directory: {run_root}")

    model_dir = run_root / "build/model"
    hdl_dir = run_root / "src/user_source/hdl_source"
    model_dir.mkdir(parents=True)
    shutil.copytree(candidate_hdl, hdl_dir)

    for name in MODEL_FILES:
        source = MODEL_SOURCE / name
        if not source.is_file():
            raise FileNotFoundError(f"regression input missing: {source}")
        destination = model_dir / name
        content = source.read_text(encoding="utf-8-sig")
        if name.endswith(".ps1"):
            content = _patch_script(content, name)
        if name == "run_engine_smoke.ps1":
            old_root = "$ProjectRoot = (Resolve-Path (Join-Path $ModelDir '..\\..\\..\\..')).Path"
            if content.count(old_root) != 1:
                raise ValueError("run_engine_smoke.ps1 project-root line changed")
            content = content.replace(
                old_root,
                "$ProjectRoot = (Resolve-Path $CandidateProjectRoot).Path",
                1,
            )
            content = content.replace("'development\\player_bmp_scale\\src\\user_source\\hdl_source'", "'src/user_source/hdl_source'")
            content = "param([Parameter(Mandatory)][string]$CandidateProjectRoot)\n" + content
        destination.write_text(content, encoding="utf-8", newline="\n")

    helper = (REPO / "scripts/anlu_tools.ps1").read_text(encoding="utf-8-sig")
    root_assignment = "$AnluRepositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))"
    helper = helper.replace(root_assignment, f"$AnluRepositoryRoot = '{REPO.as_posix()}'", 1)
    (model_dir / "anlu_tools.ps1").write_text(helper, encoding="utf-8", newline="\n")
    return run_root


def _run(run_root: Path) -> None:
    if not PS:
        raise RuntimeError("PowerShell 7 (pwsh) is required to run these regressions")
    model_dir = run_root / "build/model"
    commands = (
        [PS, "-NoProfile", "-File", str(model_dir / "scaler_full_loader.ps1"), "-ProjectRoot", str(run_root)],
        [PS, "-NoProfile", "-File", str(model_dir / "run_engine_smoke.ps1"), "-CandidateProjectRoot", str(run_root)],
    )
    for command in commands:
        result = subprocess.run(command, cwd=model_dir, check=False)
        if result.returncode:
            raise subprocess.CalledProcessError(result.returncode, command)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--hdl-path", required=True, type=Path,
                        help="isolated candidate hdl_source directory")
    parser.add_argument("--run-root", type=Path,
                        help="new isolated workspace; defaults to a timestamped directory here")
    parser.add_argument("--run", action="store_true",
                        help="run the prepared six-image/error and engine-smoke simulations")
    args = parser.parse_args()
    tag = datetime.now().strftime("%Y%m%d_%H%M%S_%f")
    run_root = args.run_root or (RESOURCE_WORK / "bmp_regression_runs" / f"run_{tag}")
    if not run_root.is_absolute():
        run_root = (Path.cwd() / run_root).resolve()
    _prepare(args.hdl_path, run_root)
    print(f"prepared regression workspace: {run_root}")
    if args.run:
        _run(run_root)
    else:
        print("prepared only; add --run after the candidate build is ready")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f"BMP regression setup failed: {exc}", file=sys.stderr)
        raise
