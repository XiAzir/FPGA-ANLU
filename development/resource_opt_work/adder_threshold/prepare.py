from __future__ import annotations

import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parents[2]
SOURCE_ROOT = REPO / "development/player_spectrum_resource_fit/src/user_source/hdl_source"
STRATEGY = Path("C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/doc/strategies/official_strategy_ph1.json")
RUNS = ROOT / "runs"


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def generate(module: str, variant: str, src: Path) -> dict[str, str]:
    folder = RUNS / f"{module}_{variant}"
    project = folder / "td_project"
    project.mkdir(parents=True, exist_ok=True)
    rtl = folder / f"{module}.v"
    rtl.write_bytes(src.read_bytes())
    area_target = (folder / "reports/gate.area").as_posix()
    rtl_param_target = (folder / "reports/actualparams.rtl.log").as_posix()
    gate_param_target = (folder / "reports/actualparams.gate.log").as_posix()
    (folder / "mapper.sdc").write_text("create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]\n", encoding="ascii")
    (folder / "run_syn.tcl").write_text(
        "set run_root [file normalize [file join [file dirname [info script]] .]]\n"
        "set project_dir [file join $run_root td_project]\n"
        "set report_dir [file join $run_root reports]\n"
        "file mkdir $report_dir\n"
        f"set project_file {module}_{variant}.al\n"
        "cd $project_dir\n"
        "if {[catch {\n"
        "  import_device eagle_s20.db -package EG4S20BG256\n"
        "  open_project $project_file -single_run\n"
        "  load_run_param -run syn_1\n"
        + ("  set_param rtl min_ripple_len 18\n  set_param gate mapper_lut_delay 1600\n" if variant == "adder_chain_threshold_high" else "")
        + f"  report_param -stage rtl -detail -all -file {rtl_param_target}\n"
        f"  report_param -stage gate -detail -all -file {gate_param_target}\n"
        f"  elaborate -top {module}\n"
        "  read_sdc ../mapper.sdc\n"
        "  commit_param -step rtl\n"
        "  optimize_rtl\n"
        "  commit_param -step gate\n"
        f"  puts \"AREA_OUTPUT={area_target}\"\n"
        f"  optimize_gate -packarea {area_target}\n"
        "} message]} { puts \"BUILD_ERROR: $message\"; exit 1 }\n"
        "puts SYNTHESIS_COMPLETE\nclose_project\nexit\n",
        encoding="ascii",
    )
    project_path = project.as_posix()
    (project / f"{module}_{variant}.al").write_text(
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        f'<Project Version="3" Minor="2" Path="{project_path}">\n'
        f'<Project_Created_Time></Project_Created_Time><TD_Version>6.2.178840</TD_Version><Name>{module}_{variant}</Name>\n'
        '<HardWare><Family>EG4</Family><Device>EG4S20BG256</Device><Speed></Speed></HardWare>\n'
        f'<Source_Files><Verilog><File Path="../{module}.v"><FileInfo><Attr Name="UsedInSyn" Val="true"/><Attr Name="UsedInP&amp;R" Val="true"/><Attr Name="BelongTo" Val="design_1"/><Attr Name="CompileOrder" Val="1"/></FileInfo></File></Verilog></Source_Files>\n'
        '<FileSets><FileSet Name="design_1" Type="DesignFiles"></FileSet><FileSet Name="constraint_1" Type="ConstrainFiles"></FileSet></FileSets>\n'
        f'<TOP_MODULE><LABEL>{module}</LABEL><MODULE>{module}</MODULE><CREATEINDEX>user</CREATEINDEX></TOP_MODULE>\n'
        '<Property></Property><Device_Settings></Device_Settings><Configurations></Configurations>\n'
        '<Runs><Run Name="syn_1" Type="Synthesis" ConstraintSet="constraint_1" Description="" Active="true"><Strategy Name="Default_Synthesis_Strategy"></Strategy><UserParams></UserParams></Run></Runs>\n'
        '<Project_Settings></Project_Settings></Project>\n', encoding="utf-8")
    return {"module": module, "variant": variant, "source": str(src), "sha256": sha(rtl), "al": str(project / f"{module}_{variant}.al")}


def main() -> None:
    if not STRATEGY.is_file():
        raise SystemExit(f"official strategy JSON missing: {STRATEGY}")
    strategy = json.loads(STRATEGY.read_text(encoding="utf-8"))["AdderChainThresholdHigh"]
    actual = {(p["step"], p["param"]): p["val"] for p in strategy["params"]}
    if actual != {("gate", "mapper_lut_delay"): "1600", ("rtl", "min_ripple_len"): "18"}:
        raise SystemExit(f"unexpected AdderChainThresholdHigh parameters: {actual}")
    RUNS.mkdir(exist_ok=True)
    manifest = []
    for module in ("fat32_catalog", "fat32_file_sector"):
        src = SOURCE_ROOT / f"{module}.v"
        if not src.is_file():
            raise SystemExit(f"missing current source: {src}")
        for variant in ("baseline", "adder_chain_threshold_high"):
            manifest.append(generate(module, variant, src))
    (RUNS / "input_manifest.json").write_text(json.dumps({"strategy": strategy, "runs": manifest}, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"strategy": strategy, "runs": manifest}, indent=2))


if __name__ == "__main__":
    main()
