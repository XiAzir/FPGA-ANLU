from pathlib import Path
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parent
TRIAL = ROOT / "dual_waitcount"
SOURCE = Path("development/video19_work/physical_resume/runs/video_system_C04_20261021_200556/frozen/src/user_source/hdl_source/fat32_dual_file_sector.v").resolve()

baseline = SOURCE.read_text(encoding="utf-8")
candidate = baseline.replace(
    "    reg [31:0] wait_count [0:1];",
    "    localparam integer WAIT_COUNT_W = (WAIT_LIMIT == 0 || WAIT_LIMIT == 32'hffffffff) ? 32 : (($clog2(WAIT_LIMIT) < 1) ? 1 : $clog2(WAIT_LIMIT));\n"
    "    reg [WAIT_COUNT_W-1:0] wait_count [0:1];",
    1,
)
if candidate == baseline:
    raise SystemExit("expected wait_count declaration was not found")

for name, text in (("baseline", baseline), ("candidate", candidate)):
    run = TRIAL / name
    run.mkdir(parents=True, exist_ok=False)
    (run / "td_project").mkdir()
    (run / "reports").mkdir()
    (run / "fat32_dual_file_sector.v").write_text(text, encoding="utf-8")
    (run / "mapper.sdc").write_text("create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]\n", encoding="ascii")
    project = run / "td_project" / f"dual_{name}.al"
    project.write_text(
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<Project Version="3" Minor="2" Path="' + project.parent.as_posix() + '">\n'
        '  <Project_Created_Time></Project_Created_Time>\n  <TD_Version>6.2.178840</TD_Version>\n'
        f'  <Name>dual_{name}</Name>\n  <HardWare><Family>EG4</Family><Device>EG4S20BG256</Device><Speed></Speed></HardWare>\n'
        '  <Source_Files><Verilog><File Path="../fat32_dual_file_sector.v"><FileInfo>'
        '<Attr Name="UsedInSyn" Val="true"/><Attr Name="UsedInP&amp;R" Val="true"/>'
        '<Attr Name="BelongTo" Val="design_1"/><Attr Name="CompileOrder" Val="1"/>'
        '</FileInfo></File></Verilog></Source_Files>\n'
        '  <FileSets><FileSet Name="design_1" Type="DesignFiles"></FileSet><FileSet Name="constraint_1" Type="ConstrainFiles"></FileSet></FileSets>\n'
        '  <TOP_MODULE><LABEL>fat32_dual_file_sector</LABEL><MODULE>fat32_dual_file_sector</MODULE><CREATEINDEX>user</CREATEINDEX></TOP_MODULE>\n'
        '  <Property></Property><Device_Settings></Device_Settings><Configurations></Configurations>\n'
        '  <Runs><Run Name="syn_1" Type="Synthesis" ConstraintSet="constraint_1" Description="" Active="true"><Strategy Name="Default_Synthesis_Strategy"></Strategy><UserParams></UserParams></Run></Runs>\n'
        '  <Project_Settings></Project_Settings>\n</Project>\n', encoding="utf-8")
    (run / "run_syn.tcl").write_text(
        "set run_root [file normalize [file join [file dirname [info script]] .]]\n"
        "set project_dir [file join $run_root td_project]\ncd $project_dir\n"
        "if {[catch {\n  import_device eagle_s20.db -package EG4S20BG256\n"
        f"  open_project dual_{name}.al -single_run\n"
        "  load_run_param -run syn_1\n  set_param gate add_map_lut_struct high\n"
        "  set_param gate map_mode area_prior\n  set_param gate multi_thread_mapping partition\n"
        "  set_param rtl resource_sharing auto\n  set_param rtl shifter_style shifter_reg\n"
        "  set_param rtl min_ripple_len 18\n  set_param gate mapper_lut_delay 1600\n"
        "  elaborate -top fat32_dual_file_sector\n  read_sdc ../mapper.sdc\n"
        "  commit_param -step rtl\n  optimize_rtl\n  commit_param -step gate\n"
        f"  optimize_gate -packarea {(run / 'reports' / 'gate.area').as_posix()}\n"
        "} message]} { puts \"BUILD_ERROR: $message\"; exit 1 }\n"
        "puts SYNTHESIS_COMPLETE\nclose_project\nexit\n", encoding="ascii")

(TRIAL / "tb_fat32_dual_file_sector.v").write_bytes(Path("development/arch17_work/shared_mapper/tb_fat32_dual_file_sector.v").read_bytes())
(TRIAL / "tb_fat32_dual_timeout.v").write_bytes(Path("development/arch17_work/shared_mapper/tb_fat32_dual_timeout.v").read_bytes())
(TRIAL / "tb_fat32_dual_disable_drain.v").write_bytes(Path("development/arch17_work/shared_mapper/tb_fat32_dual_disable_drain.v").read_bytes())
(TRIAL / "tb_fat32_sd_end_edge.v").write_bytes(Path("development/arch17_work/shared_mapper/tb_fat32_sd_end_edge.v").read_bytes())
(TRIAL / "tb_cidle_peer_timeout_race.v").write_bytes(Path("development/arch17_work/shared_mapper/tb_cidle_peer_timeout_race.v").read_bytes())
(TRIAL / "tb_cidle_timeout_natural.v").write_bytes(Path("development/arch17_work/shared_mapper/tb_cidle_timeout_natural.v").read_bytes())

manifest = {
    "baseline_sha256": hashlib.sha256(baseline.encode()).hexdigest(),
    "candidate_sha256": hashlib.sha256(candidate.encode()).hexdigest(),
    "change": "WAIT_COUNT_W is the number of bits needed to reach WAIT_LIMIT-1, with 32-bit fallback for WAIT_LIMIT 0 and 0xffffffff.",
    "source": str(SOURCE),
}
(TRIAL / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
print(json.dumps(manifest, indent=2))
