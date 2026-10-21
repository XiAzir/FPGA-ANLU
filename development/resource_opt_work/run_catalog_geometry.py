#!/usr/bin/env python3
"""Compile and run the cycle-by-cycle FAT32 catalog geometry regression."""
from __future__ import annotations

import argparse
import re
import shutil
import subprocess
import sys
from pathlib import Path


REPO = Path(__file__).resolve().parents[2]
DEFAULT_REFERENCE = REPO / "development/player_spectrum_trace/src/user_source/hdl_source/fat32_catalog.v"
DEFAULT_CANDIDATE = REPO / "development/player_spectrum_resource_fit/src/user_source/hdl_source/fat32_catalog.v"
DEFAULT_TB = Path(__file__).with_name("tb_catalog_geometry.v")
DEFAULT_BIN = REPO / "bringup/tf_wav_hdmi/tools/iverilog/app/bin"


def locate_tool(explicit: str | None, name: str, bundled: Path) -> str:
    if explicit:
        return explicit
    candidate = bundled / (name + (".exe" if sys.platform == "win32" else ""))
    if candidate.is_file():
        return str(candidate)
    found = shutil.which(name)
    if found:
        return found
    raise FileNotFoundError(f"找不到 {name}；请通过参数显式指定可执行文件路径")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--reference", type=Path, default=DEFAULT_REFERENCE)
    parser.add_argument("--candidate", type=Path, default=DEFAULT_CANDIDATE)
    parser.add_argument("--testbench", type=Path, default=DEFAULT_TB)
    parser.add_argument("--iverilog", help="iverilog 可执行文件路径")
    parser.add_argument("--vvp", help="vvp 可执行文件路径")
    args = parser.parse_args()

    for path in (args.reference, args.candidate, args.testbench):
        if not path.is_file():
            raise FileNotFoundError(f"输入文件不存在：{path}")

    original = args.reference.read_text(encoding="utf-8")
    renamed, count = re.subn(r"(?m)^(\s*module\s+)fat32_catalog\b", r"\1fat32_catalog_reference", original, count=1)
    if count != 1:
        raise ValueError(f"原版中未找到唯一的 module fat32_catalog 声明：{args.reference}")

    iverilog = locate_tool(args.iverilog, "iverilog", DEFAULT_BIN)
    vvp = locate_tool(args.vvp, "vvp", DEFAULT_BIN)
    # Use stable local intermediates. The managed Windows sandbox can deny
    # access to newly created temporary directories even under the workspace.
    work = Path(__file__).resolve().parent
    ref_copy = work / ".fat32_catalog_reference.generated.v"
    image = work / ".catalog_geometry.generated.vvp"
    try:
        ref_copy.write_text(renamed, encoding="utf-8")
        compile_cmd = [iverilog, "-g2012", "-s", "tb_catalog_geometry", "-o", str(image),
                       str(args.testbench.resolve()), str(ref_copy), str(args.candidate.resolve())]
        print("Compile:", subprocess.list2cmdline(compile_cmd), flush=True)
        subprocess.run(compile_cmd, check=True)
        run_cmd = [vvp, str(image)]
        print("Run:", subprocess.list2cmdline(run_cmd), flush=True)
        subprocess.run(run_cmd, check=True)
    finally:
        for generated in (image, ref_copy):
            try:
                generated.unlink(missing_ok=True)
            except OSError:
                pass
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError, subprocess.CalledProcessError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        raise SystemExit(1)
