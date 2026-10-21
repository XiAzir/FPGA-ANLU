from pathlib import Path
import shutil

root = Path(__file__).resolve().parents[3]
work = Path(__file__).resolve().parent
hdl = root / "development/player_spectrum_opt16/src/user_source/hdl_source"
configs = {
    "dual_ref": {
        "project": "mapper_pair_dual_ref",
        "top": "mapper_pair_dual_ref",
        "sources": [
            ("mapper_pair_compare.v", work / "mapper_pair_compare.v"),
            ("fat32_file_sector.v", hdl / "fat32_file_sector.v"),
            ("sd_sector_arbiter.v", hdl / "sd_sector_arbiter.v"),
        ],
    },
    "shared": {
        "project": "mapper_pair_shared",
        "top": "mapper_pair_shared",
        "sources": [
            ("mapper_pair_compare.v", work / "mapper_pair_compare.v"),
            ("candidate.v", work / "candidate.v"),
        ],
    },
}

def project_xml(project_dir: Path, project: str, top: str, source_names: list[str]) -> str:
    files = "\n".join(
        f'''            <File Path="../{name}">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&amp;R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="{idx}"/>
                </FileInfo>
            </File>'''
        for idx, name in enumerate(source_names, 1)
    )
    return f'''<?xml version="1.0" encoding="UTF-8"?>
<Project Version="3" Minor="2" Path="{project_dir.as_posix()}">
    <Project_Created_Time></Project_Created_Time>
    <TD_Version>6.2.178840</TD_Version>
    <Name>{project}</Name>
    <HardWare><Family>EG4</Family><Device>EG4S20BG256</Device><Speed></Speed></HardWare>
    <Source_Files><Verilog>{files}
        </Verilog></Source_Files>
    <FileSets><FileSet Name="design_1" Type="DesignFiles"></FileSet>
        <FileSet Name="constraint_1" Type="ConstrainFiles"></FileSet></FileSets>
    <TOP_MODULE><LABEL>{top}</LABEL><MODULE>{top}</MODULE><CREATEINDEX>user</CREATEINDEX></TOP_MODULE>
    <Property></Property><Device_Settings></Device_Settings><Configurations></Configurations>
    <Runs><Run Name="syn_1" Type="Synthesis" ConstraintSet="constraint_1" Description="" Active="true">
        <Strategy Name="Default_Synthesis_Strategy"></Strategy><UserParams></UserParams>
    </Run></Runs><Project_Settings></Project_Settings>
</Project>
'''

def tcl_text(run_dir: Path, project: str) -> str:
    reports = (run_dir / "reports").as_posix()
    proj_dir = (run_dir / "td_project").as_posix()
    return f'''set run_root [file normalize [file join [file dirname [info script]] .]]
set project_dir [file join $run_root td_project]
cd $project_dir
if {{[catch {{
  import_device eagle_s20.db -package EG4S20BG256
  open_project {project}.al -single_run
  load_run_param -run syn_1
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  report_param -stage rtl -detail -all -file {reports}/actualparams.rtl.log
  report_param -stage gate -detail -all -file {reports}/actualparams.gate.log
  elaborate -top {project}
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={reports}/gate.area"
  optimize_gate -packarea {reports}/gate.area
}} message]}} {{ puts "BUILD_ERROR: $message"; exit 1 }}
puts SYNTHESIS_COMPLETE
close_project
exit
'''

for tag, cfg in configs.items():
    run_dir = work / "td" / tag
    proj_dir = run_dir / "td_project"
    reports = run_dir / "reports"
    proj_dir.mkdir(parents=True, exist_ok=True)
    reports.mkdir(parents=True, exist_ok=True)
    for name, source in cfg["sources"]:
        shutil.copy2(source, run_dir / name)
    shutil.copy2(work / "mapper.sdc", run_dir / "mapper.sdc")
    (proj_dir / f'{cfg["project"]}.al').write_text(
        project_xml(proj_dir, cfg["project"], cfg["top"], [name for name, _ in cfg["sources"]]),
        encoding="utf-8",
    )
    (run_dir / "run_syn.tcl").write_text(tcl_text(run_dir, cfg["project"]), encoding="utf-8")
print("AreaHigh reference and shared candidate prepared.")
