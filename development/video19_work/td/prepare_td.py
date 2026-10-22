from pathlib import Path
import hashlib
import json
import shutil
import subprocess

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parents[2]
VENDOR = REPO / "development/video19_work/vendor/core_jpeg"
SRC = VENDOR / "src_v"
RUN = ROOT / "jpeg_core_area_high"
PROJECT = RUN / "td_project"
REPORTS = RUN / "reports"
RTL = RUN / "src_v"
PROJECT.mkdir(parents=True, exist_ok=True)
REPORTS.mkdir(parents=True, exist_ok=True)
RTL.mkdir(parents=True, exist_ok=True)

files = sorted(SRC.glob("*.v"))
for source in files:
    shutil.copy2(source, RTL / source.name)

project_file = PROJECT / "jpeg_core.al"
entries = []
for index, source in enumerate(files, 1):
    entries.append(
        f'<File Path="../src_v/{source.name}"><FileInfo>'
        '<Attr Name="UsedInSyn" Val="true"/>'
        '<Attr Name="UsedInP&amp;R" Val="true"/>'
        '<Attr Name="BelongTo" Val="design_1"/>'
        f'<Attr Name="CompileOrder" Val="{index}"/>'
        '</FileInfo></File>'
    )
project_file.write_text(
    '<?xml version="1.0" encoding="UTF-8"?>\n'
    f'<Project Version="3" Minor="2" Path="{PROJECT.as_posix()}">\n'
    '<Project_Created_Time></Project_Created_Time><TD_Version>6.2.178840</TD_Version>'
    '<Name>jpeg_core</Name><HardWare><Family>EG4</Family>'
    '<Device>EG4S20BG256</Device><Speed></Speed></HardWare>\n'
    '<Source_Files><Verilog>' + ''.join(entries) + '</Verilog></Source_Files>\n'
    '<FileSets><FileSet Name="design_1" Type="DesignFiles"></FileSet>'
    '<FileSet Name="constraint_1" Type="ConstrainFiles"></FileSet></FileSets>\n'
    '<TOP_MODULE><LABEL>jpeg_core</LABEL><MODULE>jpeg_core</MODULE>'
    '<CREATEINDEX>user</CREATEINDEX></TOP_MODULE>\n'
    '<Property></Property><Device_Settings></Device_Settings><Configurations></Configurations>\n'
    '<Runs><Run Name="syn_1" Type="Synthesis" ConstraintSet="constraint_1" '
    'Description="" Active="true"><Strategy Name="Default_Synthesis_Strategy">'
    '</Strategy><UserParams></UserParams></Run></Runs>\n'
    '<Project_Settings></Project_Settings></Project>\n', encoding="utf-8"
)
(RUN / "jpeg_core.sdc").write_text(
    'create_clock -name clk_i -period 20 -waveform {0 10} [get_ports {clk_i}]\n',
    encoding="ascii",
)

def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()

manifest = {
    "status": "PREPARED",
    "core_commit": subprocess.check_output(
        ["git", "-C", str(VENDOR), "rev-parse", "HEAD"], text=True
    ).strip(),
    "device": "EG4S20BG256",
    "top": "jpeg_core",
    "parameter": "SUPPORT_WRITABLE_DHT=0 (module default)",
    "clock": {"port": "clk_i", "period_ns": 20},
    "strategy": "AreaHigh; min_ripple_len=18; mapper_lut_delay=1600; add_map_lut_struct=high; map_mode=area_prior; multi_thread_mapping=partition; resource_sharing=auto; shifter_style=shifter_reg",
    "sources": [
        {"name": p.name, "sha256": sha256(p)} for p in sorted(RTL.glob("*.v"))
    ],
    "project_sha256": sha256(project_file),
    "sdc_sha256": sha256(RUN / "jpeg_core.sdc"),
}
(RUN / "manifest.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")

area = (REPORTS / "gate.area").as_posix()
rtl_params = (REPORTS / "actualparams.rtl.log").as_posix()
gate_params = (REPORTS / "actualparams.gate.log").as_posix()
console = (RUN / "td_console.log").as_posix()
tcl = [
    'set run_root [file normalize [file join [file dirname [info script]] .]]',
    'set project_dir [file join $run_root td_project]',
    'cd $project_dir',
    'if {[catch {',
    '  import_device eagle_s20.db -package EG4S20BG256',
    '  open_project jpeg_core.al -single_run',
    '  load_run_param -run syn_1',
    '  set_param gate add_map_lut_struct high',
    '  set_param gate map_mode area_prior',
    '  set_param gate multi_thread_mapping partition',
    '  set_param rtl resource_sharing auto',
    '  set_param rtl shifter_style shifter_reg',
    '  set_param rtl min_ripple_len 18',
    '  set_param gate mapper_lut_delay 1600',
    f'  report_param -stage rtl -detail -all -file {{{rtl_params}}}',
    f'  report_param -stage gate -detail -all -file {{{gate_params}}}',
    '  elaborate -top jpeg_core',
    '  read_sdc ../jpeg_core.sdc',
    '  commit_param -step rtl',
    '  optimize_rtl',
    '  commit_param -step gate',
    f'  puts "AREA_OUTPUT={{{area}}}"',
    f'  optimize_gate -packarea {{{area}}}',
    '} message]} { puts "BUILD_ERROR: $message"; exit 1 }',
    'puts SYNTHESIS_COMPLETE',
    'close_project',
    'exit',
]
(RUN / "run_syn.tcl").write_text("\n".join(tcl) + "\n", encoding="ascii")
print(json.dumps({"run": str(RUN), "source_count": len(files), "top": "jpeg_core"}))
