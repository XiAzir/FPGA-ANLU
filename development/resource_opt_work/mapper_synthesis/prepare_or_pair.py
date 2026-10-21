"""Prepare latest combined and combined-OR standalone TD projects."""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from mapper_proposal import apply as apply_combined
from mapper_aligned_proposal import apply as apply_combined_or
from prepare_variants import make_al


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit("usage: prepare_or_pair.py SOURCE.v OUTPUT_DIR")
    source_path, output = map(Path, sys.argv[1:])
    source = source_path.read_text(encoding="utf-8-sig")
    variants = {"combined": apply_combined, "combined_or": apply_combined_or}
    manifest = {
        "source_path": str(source_path.resolve()),
        "source_sha256": digest(source_path),
        "device": "EG4S20BG256",
        "clock_constraint_ns": 20,
        "variants": {},
    }
    output.mkdir(parents=True, exist_ok=True)
    for name, patch in variants.items():
        folder = output / name
        project_dir = folder / "td_project"
        project_dir.mkdir(parents=True, exist_ok=True)
        hdl = folder / "fat32_file_sector.v"
        hdl.write_text(source, encoding="utf-8")
        patch(hdl)
        sdc = folder / "mapper.sdc"
        sdc.write_text(
            "create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]\n",
            encoding="ascii",
        )
        project_file = project_dir / f"mapper_{name}.al"
        project_file.write_text(make_al(project_file, f"mapper_{name}"), encoding="utf-8")
        (folder / "run_syn.tcl").write_text(
            "set variant_root [file normalize [file join [file dirname [info script]] .]]\n"
            "set project_dir [file join $variant_root td_project]\n"
            "set report_dir [file join $variant_root reports]\n"
            "set area_file [file join $report_dir gate.area]\n"
            "file mkdir $report_dir\n"
            f"set project_file mapper_{name}.al\n"
            "cd $project_dir\n"
            "if {[catch {\n"
            "    import_device eagle_s20.db -package EG4S20BG256\n"
            "    open_project $project_file -single_run\n"
            "    load_run_param -run syn_1\n"
            "    elaborate -top fat32_file_sector\n"
            "    read_sdc ../mapper.sdc\n"
            "    commit_param -step rtl\n"
            "    optimize_rtl\n"
            "    commit_param -step gate\n"
            "    puts \"AREA_OUTPUT=$area_file\"\n"
            "    optimize_gate -packarea $area_file\n"
            "} message]} {\n"
            "    puts \"BUILD_ERROR: $message\"\n"
            "    exit 1\n"
            "}\n"
            "puts SYNTHESIS_COMPLETE\n"
            "close_project\n"
            "exit\n",
            encoding="ascii",
        )
        manifest["variants"][name] = {
            "hdl_sha256": digest(hdl),
            "sdc_sha256": digest(sdc),
            "hdl": str(hdl.resolve()),
            "al": str(project_file.resolve()),
        }
    (output / "input_manifest.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    print(f"Prepared {len(variants)} isolated projects under {output.resolve()}")


if __name__ == "__main__":
    main()
