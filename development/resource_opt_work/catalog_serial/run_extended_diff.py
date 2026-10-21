"""Run 511 geometry and 175 directory-name test cases independently, comparing traces."""
from __future__ import annotations

import hashlib
import itertools
import json
import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent
BUILD = ROOT / "build"
PROJECT = ROOT.parents[2]
REFERENCE = PROJECT / "development/player_spectrum_resource_fit/src/user_source/hdl_source/fat32_catalog.v"
CANDIDATE = ROOT / "fat32_catalog.v"
GEOMETRY_TB = PROJECT / "development/resource_opt_work/tb_catalog_geometry.v"
NAMES_TB_SOURCE = PROJECT / "development/player_fat32_probe/sim/tb_fat32_catalog.v"


def digest(path: pathlib.Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def trace_geometry_tb(source: str) -> str:
    source = source.replace("fat32_catalog #(", "fat32_catalog_reference #(")
    source = source.replace(
        "if (!serving && sd_read_ref) begin serving=1; pos=0; this_lba=sd_addr_ref; end",
        'if (!serving && sd_read_ref) begin $display("TRACE REQ case=%0d lba=%08x",case_id,sd_addr_ref); serving=1; pos=0; this_lba=sd_addr_ref; end',
    )
    source = source.replace(
        "compared_cases=compared_cases+1;",
        '$display("TRACE END case=%0d state=%0d read=%b/%08x ready=%b error=%b code=%02x fat=%08x data=%08x clusters=%08x shift=%0d bmpcount=%0d bmp0=%08x/%08x wav=%b/%08x/%08x",case_id,ref_dut.state,sd_read_ref,sd_addr_ref,ready_ref,error_ref,error_code_ref,fat_lba_ref,data_lba_ref,cluster_count_ref,shift_ref,bmp_count_ref,bmp_clusters_ref[31:0],bmp_sizes_ref[31:0],wav_found_ref,wav_cluster_ref,wav_size_ref);\n      compared_cases=compared_cases+1;',
    )
    if "TRACE REQ" not in source or "TRACE END" not in source:
        raise ValueError("could not instrument geometry testbench")
    return source


def names_tb() -> str:
    source = NAMES_TB_SOURCE.read_text(encoding="utf-8")
    output_widths = {
        "sd_read": 1, "sd_addr": 32, "ready": 1, "error": 1, "error_code": 8,
        "fat_lba": 32, "data_lba": 32, "cluster_count": 32, "spc_shift": 4,
        "bmp_count": 3, "bmp_clusters": 128, "bmp_sizes": 128,
        "wav_found": 1, "wav_cluster": 32, "wav_size": 32,
    }
    match = re.search(r"fat32_catalog #\(.*?\);", source, re.S)
    if not match:
        raise ValueError("directory testbench DUT instance not found")
    ref_inst = match.group().replace("fat32_catalog #", "fat32_catalog_reference #").replace(" dut(", " reference(")
    for signal in output_widths:
        ref_inst = re.sub(r"\(" + signal + r"\)", "(" + signal + "_ref)", ref_inst)
    declarations = "\n".join(
        "wire " + ("" if width == 1 else f"[{width-1}:0] ") + name + "_ref;"
        for name, width in output_widths.items()
    )
    left = ",".join(output_widths)
    right = ",".join(name + "_ref" for name in output_widths)
    checker = f"\n{declarations}\n{ref_inst}\nalways @(negedge clk) if({{{left}}} !== {{{right}}}) $fatal(1,\"directory output mismatch mode=%0d\",mode);\n"
    source = source[:match.end()] + checker + source[match.end():]
    needle = """  end
 end
endfunction

function [7:0] sector_byte;"""
    replacement = """  end
  if(mode>=100) begin
    if((mode-100)%20<11 && off==(mode-100)%20) entry_byte=entry_byte^8'h01;
    if((mode-100)%20==11 && off==0) entry_byte=0;
    if((mode-100)%20==12 && off==0) entry_byte=8'he5;
    if((mode-100)%20>=13 && (mode-100)%20<=16 && off==11)
      entry_byte=((mode-100)%20==13)?8'h0f:((mode-100)%20==14)?8'h08:((mode-100)%20==15)?8'h10:8'h37;
    if((mode-100)%20==17 && off==26) entry_byte=0;
    if((mode-100)%20==18 && off>=28) entry_byte=0;
  end
 end
endfunction

function [7:0] sector_byte;"""
    if needle not in source:
        raise ValueError("directory entry mutation insertion point missing")
    source = source.replace(needle, replacement, 1)
    source = source.replace("initial begin\n reset_case(0);", "integer k;\ninitial begin\n for(k=0;k<160;k=k+1) begin reset_case(100+k); wait_terminal(); tests=tests+1; end\n reset_case(0);")
    source = source.replace("fat32_catalog #(", "fat32_catalog_reference #(")
    source = source.replace(
        "if(!serving && sd_read && !prev_read) begin serving<=1; serving_lba<=sd_addr;",
        'if(!serving && sd_read && !prev_read) begin $display("TRACE REQ mode=%0d lba=%08x",mode,sd_addr); serving<=1; serving_lba<=sd_addr;',
    )
    source = source.replace(
        "if(t>=300000) $fatal(1,\"timeout mode=%0d state=%0d addr=%0d\",mode,dut.state,sd_addr);",
        "if(t>=300000) $fatal(1,\"timeout mode=%0d state=%0d addr=%0d\",mode,dut.state,sd_addr);\n  $display(\"TRACE END mode=%0d ready=%b error=%b code=%02x fat=%08x data=%08x clusters=%08x shift=%0d bmpcount=%0d bmp0=%08x/%08x wav=%b/%08x/%08x\",mode,ready,error,error_code,fat_lba,data_lba,cluster_count,spc_shift,bmp_count,bmp_clusters[31:0],bmp_sizes[31:0],wav_found,wav_cluster,wav_size);",
    )
    if "TRACE REQ" not in source or "TRACE END" not in source or "for(k=0;k<160" not in source:
        raise ValueError("directory testbench instrumentation/insertion failed")
    return source


def run_case(tag: str, label: str, hdl: pathlib.Path, tb: pathlib.Path, iv: str, vvp: str) -> list[str]:
    image = BUILD / f"{tag}_{label}.vvp"
    log = BUILD / f"{tag}_{label}.log"
    # Both testbench instances bind to the same variant; the built-in directed
    # assertions remain active while independent runs compare observable traces.
    compiled = subprocess.run([iv, "-g2001", "-s", "tb_catalog_geometry" if tag == "geometry" else "tb_fat32_catalog", "-o", str(image), str(hdl), str(tb)], capture_output=True, text=True)
    if compiled.returncode:
        log.write_text(compiled.stdout + compiled.stderr, encoding="utf-8")
        raise RuntimeError(f"{tag}/{label}: compile failed; see {log}")
    result = subprocess.run([vvp, str(image)], capture_output=True, text=True)
    log.write_text(result.stdout + result.stderr, encoding="utf-8")
    if result.returncode:
        raise RuntimeError(f"{tag}/{label}: simulation failed; see {log}")
    return [line.strip() for line in (result.stdout + result.stderr).splitlines() if line.startswith("TRACE ")]


def compare(tag: str, base: list[str], cand: list[str]) -> int:
    if base == cand:
        print(f"PASS {tag}: trace_records={len(base)}")
        return 0
    for index, (a, b) in enumerate(itertools.zip_longest(base, cand), 1):
        if a != b:
            print(f"FAIL {tag}: trace line {index}\nreference={a}\ncandidate={b}")
            return 1
    return 1


def main() -> int:
    if len(sys.argv) != 3:
        raise SystemExit("usage: run_extended_diff.py <iverilog.exe> <vvp.exe>")
    iv, vvp = sys.argv[1:]
    BUILD.mkdir(exist_ok=True)
    source_text = REFERENCE.read_text(encoding="utf-8")
    source_ref = re.sub(r"(?m)^\s*module\s+fat32_catalog\b", "module fat32_catalog_reference", source_text, count=1)
    source_cand = re.sub(r"(?m)^\s*module\s+fat32_catalog\b", "module fat32_catalog_reference", CANDIDATE.read_text(encoding="utf-8"), count=1)
    ref_hdl = BUILD / "fat32_catalog_variant.v"
    cand_hdl = BUILD / "fat32_catalog_variant_candidate.v"
    ref_hdl.write_text(source_ref, encoding="utf-8")
    cand_hdl.write_text(source_cand, encoding="utf-8")

    geometry_tb = BUILD / "tb_catalog_geometry_trace.v"
    geometry_tb.write_text(trace_geometry_tb(GEOMETRY_TB.read_text(encoding="utf-8")), encoding="utf-8")
    name_tb = BUILD / "tb_catalog_names_trace.v"
    name_tb.write_text(names_tb(), encoding="utf-8")

    results = {}
    failures = 0
    for tag, tb in (("geometry", geometry_tb), ("names", name_tb)):
        ref_trace = run_case(tag, "reference", ref_hdl, tb, iv, vvp)
        cand_trace = run_case(tag, "shared36", cand_hdl, tb, iv, vvp)
        failures += compare(tag, ref_trace, cand_trace)
        results[tag] = {
            "trace_records": len(ref_trace),
            "trace_sha256": hashlib.sha256("\n".join(ref_trace).encode()).hexdigest(),
            "equal": ref_trace == cand_trace,
            "reference_log": f"build/{tag}_reference.log",
            "candidate_log": f"build/{tag}_shared36.log",
        }
    manifest = {
        "reference_source": str(REFERENCE), "reference_sha256": digest(REFERENCE),
        "candidate_source": str(CANDIDATE), "candidate_sha256": digest(CANDIDATE),
        "geometry_testbench": str(GEOMETRY_TB), "geometry_testbench_sha256": digest(GEOMETRY_TB),
        "names_testbench_source": str(NAMES_TB_SOURCE), "results": results,
    }
    (BUILD / "extended_diff_result.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
