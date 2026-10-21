"""Prepare five isolated standalone TD synthesis projects."""

from __future__ import annotations

import hashlib
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def make_al(project_file: Path, project_name: str) -> str:
    project_dir = project_file.parent.resolve().as_posix()
    return f'''<?xml version="1.0" encoding="UTF-8"?>
<Project Version="3" Minor="2" Path="{project_dir}">
    <Project_Created_Time></Project_Created_Time>
    <TD_Version>6.2.178840</TD_Version>
    <Name>{project_name}</Name>
    <HardWare><Family>EG4</Family><Device>EG4S20BG256</Device><Speed></Speed></HardWare>
    <Source_Files>
        <Verilog>
            <File Path="../fat32_file_sector.v">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&amp;R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="1"/>
                </FileInfo>
            </File>
        </Verilog>
    </Source_Files>
    <FileSets>
        <FileSet Name="design_1" Type="DesignFiles"></FileSet>
        <FileSet Name="constraint_1" Type="ConstrainFiles"></FileSet>
    </FileSets>
    <TOP_MODULE><LABEL>fat32_file_sector</LABEL><MODULE>fat32_file_sector</MODULE><CREATEINDEX>user</CREATEINDEX></TOP_MODULE>
    <Property></Property><Device_Settings></Device_Settings><Configurations></Configurations>
    <Runs>
        <Run Name="syn_1" Type="Synthesis" ConstraintSet="constraint_1" Description="" Active="true">
            <Strategy Name="Default_Synthesis_Strategy"></Strategy><UserParams></UserParams>
        </Run>
    </Runs>
    <Project_Settings></Project_Settings>
</Project>
'''


def main() -> None:
    if len(sys.argv) != 4:
        raise SystemExit("usage: prepare_variants.py SOURCE.v OUTPUT_DIR MAPPER_PROPOSAL_DIR")
    source_path, output_root, proposal_root = map(Path, sys.argv[1:])
    source = source_path.read_text(encoding="utf-8-sig")
    proposal_root = proposal_root.resolve()
    sys.path.insert(0, str(proposal_root))
    from mapper_proposal import apply as apply_proposal  # noqa: E402

    variants = {
        "reference": None,
        "algorithm_only": dict(algorithm=True, address=False, index=False),
        "address_only": dict(algorithm=False, address=True, index=False),
        "index_only": dict(algorithm=False, address=False, index=True),
        "combined": dict(algorithm=True, address=True, index=True),
    }
    manifest = {
        "prepared_utc": datetime.now(timezone.utc).isoformat(),
        "device": "EG4S20BG256",
        "clock_constraint_ns": 20,
        "source_path": str(source_path.resolve()),
        "source_sha256": sha256(source_path),
        "variants": {},
    }
    output_root.mkdir(parents=True, exist_ok=True)
    for name, options in variants.items():
        folder = output_root / name
        td_project = folder / "td_project"
        td_project.mkdir(parents=True, exist_ok=True)
        hdl = folder / "fat32_file_sector.v"
        hdl.write_text(source, encoding="utf-8")
        if options:
            apply_proposal(hdl, **options)
        sdc = folder / "mapper.sdc"
        sdc.write_text(
            "create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]\n",
            encoding="ascii",
        )
        project_file = td_project / f"mapper_{name}.al"
        project_file.write_text(make_al(project_file, f"mapper_{name}"), encoding="utf-8")
        tcl = folder / "run_syn.tcl"
        tcl.write_text(
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
            "hdl": str(hdl.resolve()),
            "hdl_sha256": sha256(hdl),
            "al": str(project_file.resolve()),
            "sdc": str(sdc.resolve()),
            "tcl": str(tcl.resolve()),
        }
    (output_root / "input_manifest.json").write_text(
        json.dumps(manifest, indent=2), encoding="utf-8"
    )
    print(f"Prepared five isolated TD projects under {output_root.resolve()}")


if __name__ == "__main__":
    main()
