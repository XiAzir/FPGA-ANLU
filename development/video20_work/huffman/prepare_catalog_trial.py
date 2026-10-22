from pathlib import Path
import hashlib
import json
import re
import shutil

ROOT = Path(__file__).resolve().parent
TRIAL = ROOT / "catalog_optimization"
C04 = Path("development/video19_work/physical_resume/runs/video_system_C04_20261021_200556/frozen/src/user_source/hdl_source").resolve()
SOURCE = C04 / "fat32_catalog.v"

for name in ("catalog_baseline", "catalog_narrow_cluster"):
    run = TRIAL / name
    run.mkdir(parents=True, exist_ok=False)
    (run / "td_project").mkdir()
    (run / "reports").mkdir()
    source = SOURCE.read_text(encoding="utf-8")
    if name == "catalog_narrow_cluster":
        original = "cluster_count<=cluster_count_p2[31:0];"
        candidate = "cluster_count<={4'b0,cluster_count_p2[27:0]};"
        if source.count(original) != 1:
            raise SystemExit("expected unique validated cluster_count assignment")
        source = source.replace(original, candidate, 1)
    (run / "fat32_catalog.v").write_text(source, encoding="utf-8")
    (run / "mapper.sdc").write_text("create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]\n", encoding="ascii")
    project = run / "td_project" / f"catalog_{name}.al"
    project.write_text(
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<Project Version="3" Minor="2" Path="' + project.parent.as_posix() + '">\n'
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
        '  <Property></Property><Device_Settings></Device_Settings><Configurations></Configurations>\n'
        '  <Runs><Run Name="syn_1" Type="Synthesis" ConstraintSet="constraint_1" Description="" Active="true">'
        '<Strategy Name="Default_Synthesis_Strategy"></Strategy><UserParams></UserParams></Run></Runs>\n'
        '  <Project_Settings></Project_Settings>\n</Project>\n', encoding="utf-8")
    (run / "run_syn.tcl").write_text(
        "set variant_root [file normalize [file join [file dirname [info script]] .]]\n"
        "set project_dir [file join $variant_root td_project]\n"
        "set area_file [file join $variant_root reports gate.area]\n"
        f"cd $project_dir\n"
        "if {[catch {\n"
        "  import_device eagle_s20.db -package EG4S20BG256\n"
        f"  open_project catalog_{name}.al -single_run\n"
        "  load_run_param -run syn_1\n"
        "  elaborate -top fat32_catalog\n"
        "  read_sdc ../mapper.sdc\n"
        "  commit_param -step rtl\n"
        "  optimize_rtl\n"
        "  commit_param -step gate\n"
        "  optimize_gate -packarea $area_file\n"
        "} message]} { puts \"BUILD_ERROR: $message\"; exit 1 }\n"
        "puts SYNTHESIS_COMPLETE\nclose_project\nexit\n", encoding="ascii")

baseline = TRIAL / "catalog_baseline" / "fat32_catalog.v"
candidate = TRIAL / "catalog_narrow_cluster" / "fat32_catalog.v"
receipt = {
    "c04_source": str(SOURCE),
    "baseline_sha256": hashlib.sha256(baseline.read_bytes()).hexdigest(),
    "candidate_sha256": hashlib.sha256(candidate.read_bytes()).hexdigest(),
    "edit": "Validated catalog output assignment fixes cluster_count[31:28] to zero and keeps the 28-bit FAT32 cluster domain explicit.",
}
(TRIAL / "manifest.json").write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")

for filename, source in (
    ("tb_catalog_geometry.v", Path("development/resource_opt_work/tb_catalog_geometry.v").resolve()),
    ("tb_fat32_catalog_names.v", Path("development/player_fat32_probe/sim/tb_fat32_catalog.v").resolve()),
    ("tb_fat32_catalog_legacy.v", Path("development/resource_opt_work/catalog_serial/tb_fat32_catalog_legacy.v").resolve()),
    ("run_diff.py", Path("development/resource_opt_work/catalog_serial/run_diff.py").resolve()),
    ("run_extended_diff.py", Path("development/resource_opt_work/catalog_serial/run_extended_diff.py").resolve()),
):
    shutil.copy2(source, TRIAL / filename)

diff = (TRIAL / "run_diff.py").read_text(encoding="utf-8")
diff = diff.replace('ref = ROOT / "fat32_catalog_reference.v"', 'ref = ROOT / "catalog_baseline/fat32_catalog.v"')
diff = diff.replace('cand = ROOT / "fat32_catalog.v"', 'cand = ROOT / "catalog_narrow_cluster/fat32_catalog.v"')
(TRIAL / "run_diff.py").write_text(diff, encoding="utf-8")
ext = (TRIAL / "run_extended_diff.py").read_text(encoding="utf-8")
ext = ext.replace('PROJECT = ROOT.parents[2]', 'PROJECT = ROOT.parents[4]')
ext = ext.replace('REFERENCE = PROJECT / "development/player_spectrum_resource_fit/src/user_source/hdl_source/fat32_catalog.v"', 'REFERENCE = ROOT / "catalog_baseline/fat32_catalog.v"')
ext = ext.replace('GEOMETRY_TB = PROJECT / "development/resource_opt_work/tb_catalog_geometry.v"', 'GEOMETRY_TB = ROOT / "tb_catalog_geometry.v"')
ext = ext.replace('NAMES_TB_SOURCE = PROJECT / "development/player_fat32_probe/sim/tb_fat32_catalog.v"', 'NAMES_TB_SOURCE = ROOT / "tb_fat32_catalog_names.v"')
ext = ext.replace('CANDIDATE = ROOT / "fat32_catalog.v"', 'CANDIDATE = ROOT / "catalog_narrow_cluster/fat32_catalog.v"')
(TRIAL / "run_extended_diff.py").write_text(ext, encoding="utf-8")
print(json.dumps(receipt, indent=2))
