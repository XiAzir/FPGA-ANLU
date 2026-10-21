from __future__ import annotations

import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parents[3]
RTL = ROOT.parent / "fat32_file_sector.v"
WRAPPER = ROOT / "mapper_pair.v"
RUNS = ROOT / "runs"


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def make_run(label: str, top: str) -> dict[str, str]:
    folder = RUNS / label
    project = folder / "td_project"
    reports = folder / "reports"
    project.mkdir(parents=True, exist_ok=True)
    reports.mkdir(parents=True, exist_ok=True)
    rtl_copy = folder / "fat32_file_sector.v"
    wrapper_copy = folder / "mapper_pair.v"
    rtl_copy.write_bytes(RTL.read_bytes())
    wrapper_copy.write_bytes(WRAPPER.read_bytes())
    area = (reports / "gate.area").as_posix()
    rtl_params = (reports / "actualparams.rtl.log").as_posix()
    gate_params = (reports / "actualparams.gate.log").as_posix()
    (folder / "mapper.sdc").write_text(
        "create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]\n",
        encoding="ascii",
    )
    tcl = (
        "set run_root [file normalize [file join [file dirname [info script]] .]]\n"
        "set project_dir [file join $run_root td_project]\n"
        "cd $project_dir\n"
        "if {[catch {\n"
        "  import_device eagle_s20.db -package EG4S20BG256\n"
        f"  open_project {label}.al -single_run\n"
        "  load_run_param -run syn_1\n"
        "  set_param gate add_map_lut_struct high\n"
        "  set_param gate map_mode area_prior\n"
        "  set_param gate multi_thread_mapping partition\n"
        "  set_param rtl resource_sharing auto\n"
        "  set_param rtl shifter_style shifter_reg\n"
        "  set_param rtl min_ripple_len 18\n"
        "  set_param gate mapper_lut_delay 1600\n"
        f"  report_param -stage rtl -detail -all -file {rtl_params}\n"
        f"  report_param -stage gate -detail -all -file {gate_params}\n"
        f"  elaborate -top {top}\n"
        "  read_sdc ../mapper.sdc\n"
        "  commit_param -step rtl\n"
        "  optimize_rtl\n"
        "  commit_param -step gate\n"
        f"  puts \\\"AREA_OUTPUT={area}\\\"\n"
        f"  optimize_gate -packarea {area}\n"
        "} message]} { puts \"BUILD_ERROR: $message\"; exit 1 }\n"
        "puts SYNTHESIS_COMPLETE\nclose_project\nexit\n"
    )
    (folder / "run_syn.tcl").write_text(tcl, encoding="ascii")
    project_path = project.as_posix()
    (project / f"{label}.al").write_text(
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        f'<Project Version="3" Minor="2" Path="{project_path}">\n'
        '<Project_Created_Time></Project_Created_Time><TD_Version>6.2.178840</TD_Version>'
        f'<Name>{label}</Name>\n'
        '<HardWare><Family>EG4</Family><Device>EG4S20BG256</Device><Speed></Speed></HardWare>\n'
        '<Source_Files><Verilog>'
        '<File Path="../fat32_file_sector.v"><FileInfo><Attr Name="UsedInSyn" Val="true"/>'
        '<Attr Name="UsedInP&amp;R" Val="true"/><Attr Name="BelongTo" Val="design_1"/>'
        '<Attr Name="CompileOrder" Val="1"/></FileInfo></File>'
        '<File Path="../mapper_pair.v"><FileInfo><Attr Name="UsedInSyn" Val="true"/>'
        '<Attr Name="UsedInP&amp;R" Val="true"/><Attr Name="BelongTo" Val="design_1"/>'
        '<Attr Name="CompileOrder" Val="2"/></FileInfo></File>'
        '</Verilog></Source_Files>\n'
        '<FileSets><FileSet Name="design_1" Type="DesignFiles"></FileSet>'
        '<FileSet Name="constraint_1" Type="ConstrainFiles"></FileSet></FileSets>\n'
        f'<TOP_MODULE><LABEL>{top}</LABEL><MODULE>{top}</MODULE><CREATEINDEX>user</CREATEINDEX></TOP_MODULE>\n'
        '<Property></Property><Device_Settings></Device_Settings><Configurations></Configurations>\n'
        '<Runs><Run Name="syn_1" Type="Synthesis" ConstraintSet="constraint_1" Description="" Active="true">'
        '<Strategy Name="Default_Synthesis_Strategy"></Strategy><UserParams></UserParams></Run></Runs>\n'
        '<Project_Settings></Project_Settings></Project>\n',
        encoding="utf-8",
    )
    return {
        "variant": label,
        "top": top,
        "source_sha256": sha(rtl_copy),
        "wrapper_sha256": sha(wrapper_copy),
        "folder": str(folder),
    }


def main() -> None:
    if not RTL.is_file() or not WRAPPER.is_file():
        raise SystemExit("missing mapper RTL or wrapper")
    RUNS.mkdir(exist_ok=True)
    rows = [
        make_run("generic_000", "mapper_pair_generic"),
        make_run("top_specialized", "mapper_pair_specialized"),
    ]
    (RUNS / "input_manifest.json").write_text(json.dumps(rows, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(rows, indent=2))


if __name__ == "__main__":
    main()
