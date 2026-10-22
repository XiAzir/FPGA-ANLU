from pathlib import Path
import hashlib
import json

ROOT = Path(__file__).resolve().parent
PAIR = ROOT / "catalog_dual_pair_trial"
HDL = Path("development/video19_work/physical_resume/runs/video_system_C04_20261021_200556/frozen/src/user_source/hdl_source").resolve()
cat = (HDL / "fat32_catalog.v").read_text(encoding="utf-8")
dual = (HDL / "fat32_dual_file_sector.v").read_text(encoding="utf-8")
cat_candidate = cat.replace("cluster_count<=cluster_count_p2[31:0];", "cluster_count<={4'b0,cluster_count_p2[27:0]};", 1)
if cat_candidate == cat:
    raise SystemExit("validated cluster_count assignment was not found")

for name, current_cat in (("baseline", cat), ("candidate", cat_candidate)):
    run = PAIR / name
    run.mkdir(parents=True, exist_ok=False)
    (run / "td_project").mkdir()
    (run / "reports").mkdir()
    (run / "fat32_catalog.v").write_text(current_cat, encoding="utf-8")
    (run / "fat32_dual_file_sector.v").write_text(dual, encoding="utf-8")
    (run / "catalog_dual_pair.v").write_text((ROOT / "catalog_dual_pair.v").read_text(encoding="utf-8"), encoding="utf-8")
    (run / "pair.sdc").write_text("create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]\n", encoding="ascii")
    project = run / "td_project" / f"pair_{name}.al"
    files = []
    for idx, filename in enumerate(("catalog_dual_pair.v", "fat32_catalog.v", "fat32_dual_file_sector.v"), 1):
        files.append(f'''<File Path="../{filename}"><FileInfo><Attr Name="UsedInSyn" Val="true"/><Attr Name="UsedInP&amp;R" Val="true"/><Attr Name="BelongTo" Val="design_1"/><Attr Name="CompileOrder" Val="{idx}"/></FileInfo></File>''')
    project.write_text(
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<Project Version="3" Minor="2" Path="' + project.parent.as_posix() + '">\n'
        '  <Project_Created_Time></Project_Created_Time>\n  <TD_Version>6.2.178840</TD_Version>\n'
        f'  <Name>pair_{name}</Name>\n  <HardWare><Family>EG4</Family><Device>EG4S20BG256</Device><Speed></Speed></HardWare>\n'
        '  <Source_Files><Verilog>' + ''.join(files) + '</Verilog></Source_Files>\n'
        '  <FileSets><FileSet Name="design_1" Type="DesignFiles"></FileSet><FileSet Name="constraint_1" Type="ConstrainFiles"></FileSet></FileSets>\n'
        '  <TOP_MODULE><LABEL>catalog_dual_pair</LABEL><MODULE>catalog_dual_pair</MODULE><CREATEINDEX>user</CREATEINDEX></TOP_MODULE>\n'
        '  <Property></Property><Device_Settings></Device_Settings><Configurations></Configurations>\n'
        '  <Runs><Run Name="syn_1" Type="Synthesis" ConstraintSet="constraint_1" Description="" Active="true"><Strategy Name="Default_Synthesis_Strategy"></Strategy><UserParams></UserParams></Run></Runs>\n'
        '  <Project_Settings></Project_Settings>\n</Project>\n', encoding="utf-8")
    (run / "run_syn.tcl").write_text(
        "set run_root [file normalize [file join [file dirname [info script]] .]]\n"
        "set project_dir [file join $run_root td_project]\ncd $project_dir\n"
        "if {[catch {\n  import_device eagle_s20.db -package EG4S20BG256\n"
        f"  open_project pair_{name}.al -single_run\n"
        "  load_run_param -run syn_1\n  set_param gate add_map_lut_struct high\n"
        "  set_param gate map_mode area_prior\n  set_param gate multi_thread_mapping partition\n"
        "  set_param rtl resource_sharing auto\n  set_param rtl shifter_style shifter_reg\n"
        "  set_param rtl min_ripple_len 18\n  set_param gate mapper_lut_delay 1600\n"
        "  elaborate -top catalog_dual_pair\n  read_sdc ../pair.sdc\n"
        "  commit_param -step rtl\n  optimize_rtl\n  commit_param -step gate\n"
        f"  optimize_gate -packarea {(run / 'reports' / 'gate.area').as_posix()}\n"
        "} message]} { puts \"BUILD_ERROR: $message\"; exit 1 }\n"
        "puts SYNTHESIS_COMPLETE\nclose_project\nexit\n", encoding="ascii")

manifest = {
    "catalog_baseline_sha256": hashlib.sha256(cat.encode()).hexdigest(),
    "catalog_candidate_sha256": hashlib.sha256(cat_candidate.encode()).hexdigest(),
    "dual_sha256": hashlib.sha256(dual.encode()).hexdigest(),
    "wrapper_sha256": hashlib.sha256((ROOT / "catalog_dual_pair.v").read_bytes()).hexdigest(),
    "edit": "C04 catalog output only changes to explicit {4'b0, cluster_count_p2[27:0]} after the original <=0x0ffffff5 validation; dual mapper source remains byte-identical.",
}
(PAIR / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
print(json.dumps(manifest, indent=2))
