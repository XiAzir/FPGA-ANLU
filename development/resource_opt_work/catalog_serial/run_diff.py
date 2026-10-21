"""Run isolated reference/candidate catalog regressions and compare observable traces."""
from __future__ import annotations

import hashlib
import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent
BUILD = ROOT / "build"
TB_SOURCE = ROOT / "tb_fat32_catalog_legacy.v"
TB_TRACE = BUILD / "tb_fat32_catalog_trace.v"


def sha256(path: pathlib.Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(label: str, hdl: pathlib.Path, iverilog: str, vvp_bin: str) -> tuple[list[str], str]:
    vvp = BUILD / f"{label}.vvp"
    log = BUILD / f"{label}_trace.log"
    subprocess.run([iverilog, "-g2001", "-s", "tb_fat32_catalog", "-o", str(vvp), str(hdl), str(TB_TRACE)], check=True)
    result = subprocess.run([vvp_bin, str(vvp)], check=True, capture_output=True, text=True)
    log.write_text(result.stdout + result.stderr, encoding="utf-8")
    lines = [line.strip() for line in (result.stdout + result.stderr).splitlines() if line.startswith("TRACE ")]
    if "PASS fat32_catalog cases=15" not in result.stdout:
        raise RuntimeError(f"{label}: legacy regression did not pass; see {log}")
    return lines, result.stdout + result.stderr


def main() -> int:
    BUILD.mkdir(exist_ok=True)
    tb = TB_SOURCE.read_text(encoding="utf-8")
    # Compare SD request transaction order/addresses and terminal output snapshots.
    tb = tb.replace("if(!serving && sd_read && !prev_read) begin serving<=1; serving_lba<=sd_addr;",
                    "if(!serving && sd_read && !prev_read) begin $display(\"TRACE REQ mode=%0d lba=%08x\",mode,sd_addr); serving<=1; serving_lba<=sd_addr;")
    tb = tb.replace("if(t>=300000) $fatal(1,\"timeout mode=%0d state=%0d addr=%0d\",mode,dut.state,sd_addr);",
                    "if(t>=300000) $fatal(1,\"timeout mode=%0d state=%0d addr=%0d\",mode,dut.state,sd_addr);\n  $display(\"TRACE END mode=%0d ready=%b error=%b code=%02x fat=%08x data=%08x clusters=%08x shift=%0d bmpcount=%0d bmp0=%08x/%08x wav=%b/%08x/%08x\",mode,ready,error,error_code,fat_lba,data_lba,cluster_count,spc_shift,bmp_count,bmp_clusters[31:0],bmp_sizes[31:0],wav_found,wav_cluster,wav_size);")
    TB_TRACE.write_text(tb, encoding="utf-8")

    ref = ROOT / "fat32_catalog_reference.v"
    cand = ROOT / "fat32_catalog.v"
    if len(sys.argv) != 3:
        raise SystemExit("usage: run_diff.py <iverilog.exe> <vvp.exe>")
    ref_lines, _ = run("reference", ref, sys.argv[1], sys.argv[2])
    cand_lines, _ = run("serial", cand, sys.argv[1], sys.argv[2])
    if ref_lines != cand_lines:
        import itertools
        for index, (a, b) in enumerate(itertools.zip_longest(ref_lines, cand_lines), 1):
            if a != b:
                print(f"TRACE_MISMATCH line={index}\nreference={a}\ncandidate={b}")
                break
        return 1
    trace_hash = hashlib.sha256("\n".join(ref_lines).encode()).hexdigest()
    report = [
        "PASS: independent catalog regressions have identical SD transactions and terminal outputs.",
        f"trace_records={len(ref_lines)}",
        f"reference_sha256={sha256(ref)}",
        f"candidate_sha256={sha256(cand)}",
        f"trace_sha256={trace_hash}",
        "reference_log=build/reference_trace.log",
        "candidate_log=build/serial_trace.log",
    ]
    (BUILD / "diff_result.txt").write_text("\n".join(report) + "\n", encoding="utf-8")
    print("\n".join(report))
    return 0


if __name__ == "__main__":
    sys.exit(main())
