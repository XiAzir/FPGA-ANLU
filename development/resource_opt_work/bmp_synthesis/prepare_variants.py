"""Prepare isolated standalone BMP synthesis experiments; does not launch TD."""
from __future__ import annotations

import hashlib
import json
from datetime import datetime, timezone
from pathlib import Path
import re
import sys


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
ACTIVE_HDL = ROOT / "development/player_spectrum_trace/src/user_source/hdl_source"
PROPOSAL = ROOT / "development/resource_opt_work/bmp_proposal.py"
RUNS = HERE / "runs"


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def project_xml(project_file: Path, name: str, top: str, sources: list[str]) -> str:
    files = []
    for index, source in enumerate(sources, 1):
        files.append(f'''            <File Path="../hdl_source/{source}">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&amp;R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="{index}"/>
                </FileInfo>
            </File>''')
    return f'''<?xml version="1.0" encoding="UTF-8"?>
<Project Version="3" Minor="2" Path="{project_file.parent.resolve().as_posix()}">
    <Project_Created_Time></Project_Created_Time>
    <TD_Version>6.2.178840</TD_Version>
    <Name>{name}</Name>
    <HardWare><Family>EG4</Family><Device>EG4S20BG256</Device><Speed></Speed></HardWare>
    <Source_Files><Verilog>
{chr(10).join(files)}
    </Verilog></Source_Files>
    <FileSets>
        <FileSet Name="design_1" Type="DesignFiles"></FileSet>
        <FileSet Name="constraint_1" Type="ConstrainFiles"></FileSet>
    </FileSets>
    <TOP_MODULE><LABEL>{top}</LABEL><MODULE>{top}</MODULE><CREATEINDEX>user</CREATEINDEX></TOP_MODULE>
    <Property></Property><Device_Settings></Device_Settings><Configurations></Configurations>
    <Runs><Run Name="syn_1" Type="Synthesis" ConstraintSet="constraint_1" Description="" Active="true">
        <Strategy Name="Default_Synthesis_Strategy"></Strategy><UserParams></UserParams>
    </Run></Runs>
    <Project_Settings></Project_Settings>
</Project>
'''


def make_tcl(variant: str, project_file: str, top: str) -> str:
    return f'''set variant_root [file normalize [file join [file dirname [info script]] .]]
set project_dir [file join $variant_root td_project]
set report_dir [file join $variant_root reports]
set area_file [file join $report_dir gate.area]
file mkdir $report_dir
set project_file {project_file}
cd $project_dir
if {{[catch {{
    import_device eagle_s20.db -package EG4S20BG256
    open_project $project_file -single_run
    load_run_param -run syn_1
    elaborate -top {top}
    read_sdc ../standalone.sdc
    commit_param -step rtl
    optimize_rtl
    commit_param -step gate
    puts "AREA_OUTPUT=$area_file"
    optimize_gate -packarea $area_file
}} message]}} {{
    puts "BUILD_ERROR: $message"
    exit 1
}}
puts SYNTHESIS_COMPLETE
close_project
exit
'''


def main() -> None:
    if RUNS.exists() and any(RUNS.iterdir()):
        raise SystemExit(f"{RUNS} already contains files; choose a fresh output root")
    proposal_ns: dict[str, object] = {}
    proposal_text = PROPOSAL.read_text(encoding="utf-8-sig")
    exec(compile(proposal_text, str(PROPOSAL), "exec"), proposal_ns)
    apply = proposal_ns["apply"]

    source_files = {
        "bmp_scale_engine.v": ACTIVE_HDL / "bmp_scale_engine.v",
        "tf_bmp_file_player.v": ACTIVE_HDL / "tf_bmp_file_player.v",
        "sd_card_bmp.v": ACTIVE_HDL / "SD/sd_card_bmp.v",
    }
    debounce_text = source_files["sd_card_bmp.v"].read_text(encoding="utf-8-sig")
    debounce = re.search(r"(?ms)^module key_press_debounce\s*#\(.*?^endmodule", debounce_text)
    if not debounce:
        raise RuntimeError("key_press_debounce module not found in SD/sd_card_bmp.v")
    RUNS.mkdir(parents=True, exist_ok=True)
    manifest: dict[str, object] = {
        "prepared_utc": datetime.now(timezone.utc).isoformat(),
        "device": "EG4S20BG256",
        "clock_constraint_ns": 20,
        "top_source_sha256": {name: sha(path) for name, path in source_files.items()},
        "proposal_sha256": sha(PROPOSAL),
        "variants": {},
    }

    variants = (
        ("reference", "bmp_scale_engine", ["bmp_scale_engine.v"], None),
        ("width32", "bmp_scale_engine", ["bmp_scale_engine.v"], {"widths": True, "divider_cycles": 32}),
        ("width19", "bmp_scale_engine", ["bmp_scale_engine.v"], {"widths": True, "divider_cycles": 19}),
        ("loader_reference", "tf_bmp_file_player",
         ["tf_bmp_file_player.v", "bmp_scale_engine.v", "key_press_debounce.v"], None),
        ("loader_diag_direct", "tf_bmp_file_player",
         ["tf_bmp_file_player.v", "bmp_scale_engine.v", "key_press_debounce.v"],
         {"widths": False, "diagnostic_direct": True}),
    )

    for name, top, source_names, options in variants:
        folder = RUNS / name
        hdl_dir = folder / "hdl_source"
        td_dir = folder / "td_project"
        hdl_dir.mkdir(parents=True)
        td_dir.mkdir()
        for source_name in source_names:
            if source_name == "key_press_debounce.v":
                (hdl_dir / source_name).write_text(debounce.group(0) + "\n", encoding="utf-8")
            else:
                (hdl_dir / source_name).write_bytes(source_files[source_name].read_bytes())
        if options:
            apply(hdl_dir, **options)

        sdc = folder / "standalone.sdc"
        sdc.write_text(
            "create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]\n",
            encoding="ascii",
        )
        project_name = f"bmp_{name}"
        project_file = td_dir / f"{project_name}.al"
        project_file.write_text(project_xml(project_file, project_name, top, source_names), encoding="utf-8")
        tcl = folder / "run_syn.tcl"
        tcl.write_text(make_tcl(name, project_file.name, top), encoding="ascii")
        manifest["variants"][name] = {
            "top": top,
            "hdl_files": {source: sha(hdl_dir / source) for source in source_names},
            "al": str(project_file.resolve()),
            "sdc": str(sdc.resolve()),
            "tcl": str(tcl.resolve()),
            "gate_area": str((folder / "reports/gate.area").resolve()),
            "console": str((folder / "console.log").resolve()),
        }

    (RUNS / "input_manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(f"Prepared 5 standalone BMP TD synthesis projects under {RUNS}")
    print("No TD command was launched.")


if __name__ == "__main__":
    main()
