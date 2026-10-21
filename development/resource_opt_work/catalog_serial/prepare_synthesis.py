from __future__ import annotations

import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
RUNS = ROOT / "synthesis"


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def make_variant(name: str, source: Path) -> dict[str, str]:
    folder = RUNS / name
    project = folder / "td_project"
    project.mkdir(parents=True, exist_ok=True)
    hdl = folder / "fat32_catalog.v"
    hdl.write_bytes(source.read_bytes())
    (folder / "mapper.sdc").write_text("create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]\n", encoding="ascii")
    (folder / "run_syn.tcl").write_text(
        "set variant_root [file normalize [file join [file dirname [info script]] .]]\n"
        "set project_dir [file join $variant_root td_project]\n"
        "set report_dir [file join $variant_root reports]\n"
        "set area_file [file join $report_dir gate.area]\n"
        "file mkdir $report_dir\n"
        f"set project_file catalog_{name}.al\n"
        "cd $project_dir\n"
        "if {[catch {\n"
        "    import_device eagle_s20.db -package EG4S20BG256\n"
        "    open_project $project_file -single_run\n"
        "    load_run_param -run syn_1\n"
        "    elaborate -top fat32_catalog\n"
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
    (project / f"catalog_{name}.al").write_text(
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<Project Version="3" Minor="2" Path="' + project.as_posix() + '">\n'
        '  <Project_Created_Time></Project_Created_Time>\n'
        '  <TD_Version>6.2.178840</TD_Version>\n'
        f'  <Name>catalog_{name}</Name>\n'
        '  <HardWare><Family>EG4</Family><Device>EG4S20BG256</Device><Speed></Speed></HardWare>\n'
        '  <Source_Files><Verilog><File Path="../fat32_catalog.v"><FileInfo>'
        '<Attr Name="UsedInSyn" Val="true"/><Attr Name="UsedInP&amp;R" Val="true"/>'
        '<Attr Name="BelongTo" Val="design_1"/><Attr Name="CompileOrder" Val="1"/>'
        '</FileInfo></File></Verilog></Source_Files>\n'
        '  <FileSets><FileSet Name="design_1" Type="DesignFiles"></FileSet>'
        '<FileSet Name="constraint_1" Type="ConstrainFiles"></FileSet></FileSets>\n'
        '  <TOP_MODULE><LABEL>fat32_catalog</LABEL><MODULE>fat32_catalog</MODULE><CREATEINDEX>user</CREATEINDEX></TOP_MODULE>\n'
        '  <Property></Property><Device_Settings></Device_Settings>\n'
        '  <Configurations></Configurations>\n'
        '  <Runs><Run Name="syn_1" Type="Synthesis" ConstraintSet="constraint_1" Description="" Active="true">'
        '<Strategy Name="Default_Synthesis_Strategy"></Strategy><UserParams></UserParams></Run></Runs>\n'
        '  <Project_Settings></Project_Settings>\n'
        '</Project>\n',
        encoding="utf-8",
    )
    return {"variant": name, "source": str(source), "hdl_sha256": digest(hdl), "al": str(project / f"catalog_{name}.al")}


def main() -> None:
    source_root = Path(__file__).resolve().parents[2] / "player_spectrum_resource_fit/src/user_source/hdl_source"
    reference = source_root / "fat32_catalog.v"
    candidate = ROOT / "fat32_catalog.v"
    if not reference.is_file() or not candidate.is_file():
        raise SystemExit(f"missing input: reference={reference.is_file()} candidate={candidate.is_file()}")
    RUNS.mkdir(exist_ok=True)
    items = [make_variant("reference", reference), make_variant("shared36", candidate)]
    (RUNS / "input_manifest.json").write_text(json.dumps(items, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(items, indent=2))


if __name__ == "__main__":
    main()
