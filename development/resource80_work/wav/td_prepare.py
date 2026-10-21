from __future__ import annotations

import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parents[2]
BASELINE = REPO / "development/player_spectrum_resource_80/src/user_source/hdl_source/tf_wav_file_player.v"
CANDIDATE = ROOT / "tf_wav_file_player.v"
RUNS = ROOT / "td_runs"
MODULE = "tf_wav_file_player"


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def generate(label: str, src: Path, area_high: bool) -> dict[str, str]:
    variant = f"{label}_{'area_high' if area_high else 'default'}"
    folder = RUNS / variant
    project = folder / "td_project"
    reports = folder / "reports"
    project.mkdir(parents=True, exist_ok=True)
    reports.mkdir(parents=True, exist_ok=True)
    rtl = folder / f"{MODULE}.v"
    rtl.write_bytes(src.read_bytes())
    area_path = (reports / "gate.area").as_posix()
    rtl_params = (reports / "actualparams.rtl.log").as_posix()
    gate_params = (reports / "actualparams.gate.log").as_posix()
    (folder / "mapper.sdc").write_text(
        "create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]\n", encoding="ascii"
    )
    params = ""
    if area_high:
        params = (
            "  set_param gate add_map_lut_struct high\n"
            "  set_param gate map_mode area_prior\n"
            "  set_param gate multi_thread_mapping partition\n"
            "  set_param rtl resource_sharing auto\n"
            "  set_param rtl shifter_style shifter_reg\n"
        )
    (folder / "run_syn.tcl").write_text(
        "set run_root [file normalize [file join [file dirname [info script]] .]]\n"
        "set project_dir [file join $run_root td_project]\n"
        "set report_dir [file join $run_root reports]\n"
        "cd $project_dir\n"
        "if {[catch {\n"
        "  import_device eagle_s20.db -package EG4S20BG256\n"
        f"  open_project {variant}.al -single_run\n"
        "  load_run_param -run syn_1\n"
        + params
        + f"  report_param -stage rtl -detail -all -file {rtl_params}\n"
        + f"  report_param -stage gate -detail -all -file {gate_params}\n"
        + f"  elaborate -top {MODULE}\n"
        "  read_sdc ../mapper.sdc\n"
        "  commit_param -step rtl\n"
        "  optimize_rtl\n"
        "  commit_param -step gate\n"
        + f"  puts \"AREA_OUTPUT={area_path}\"\n"
        + f"  optimize_gate -packarea {area_path}\n"
        "} message]} { puts \"BUILD_ERROR: $message\"; exit 1 }\n"
        "puts SYNTHESIS_COMPLETE\nclose_project\nexit\n",
        encoding="ascii",
    )
    project_path = project.as_posix()
    (project / f"{variant}.al").write_text(
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        f'<Project Version="3" Minor="2" Path="{project_path}">\n'
        '<Project_Created_Time></Project_Created_Time><TD_Version>6.2.178840</TD_Version>'
        f'<Name>{variant}</Name>\n'
        '<HardWare><Family>EG4</Family><Device>EG4S20BG256</Device><Speed></Speed></HardWare>\n'
        f'<Source_Files><Verilog><File Path="../{MODULE}.v"><FileInfo><Attr Name="UsedInSyn" Val="true"/>'
        '<Attr Name="UsedInP&amp;R" Val="true"/><Attr Name="BelongTo" Val="design_1"/>'
        '<Attr Name="CompileOrder" Val="1"/></FileInfo></File></Verilog></Source_Files>\n'
        '<FileSets><FileSet Name="design_1" Type="DesignFiles"></FileSet>'
        '<FileSet Name="constraint_1" Type="ConstrainFiles"></FileSet></FileSets>\n'
        f'<TOP_MODULE><LABEL>{MODULE}</LABEL><MODULE>{MODULE}</MODULE><CREATEINDEX>user</CREATEINDEX></TOP_MODULE>\n'
        '<Property></Property><Device_Settings></Device_Settings><Configurations></Configurations>\n'
        '<Runs><Run Name="syn_1" Type="Synthesis" ConstraintSet="constraint_1" Description="" Active="true">'
        '<Strategy Name="Default_Synthesis_Strategy"></Strategy><UserParams></UserParams></Run></Runs>\n'
        '<Project_Settings></Project_Settings></Project>\n', encoding="utf-8"
    )
    return {"variant": variant, "source": str(src), "source_sha256": sha(rtl), "folder": str(folder)}


def main() -> None:
    for src in (BASELINE, CANDIDATE):
        if not src.is_file():
            raise SystemExit(f"missing RTL: {src}")
    RUNS.mkdir(exist_ok=True)
    rows = []
    for label, src in (("baseline", BASELINE), ("wav_candidate", CANDIDATE)):
        for high in (False, True):
            rows.append(generate(label, src, high))
    (RUNS / "input_manifest.json").write_text(json.dumps(rows, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(rows, indent=2))


if __name__ == "__main__":
    main()
