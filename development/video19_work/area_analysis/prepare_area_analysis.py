from pathlib import Path
import hashlib
import json


ROOT = Path(__file__).resolve().parent
RUN = ROOT / "A12_valid_prefix"
SOURCE = RUN / "src_v"
PROJECT = RUN / "td_project"
REPORTS = RUN / "reports"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


for directory in (SOURCE, PROJECT, REPORTS):
    if not directory.is_dir():
        raise SystemExit(f"missing isolated experiment directory: {directory}")

sources = sorted(SOURCE.glob("*.v"))
if len(sources) != 24:
    raise SystemExit(f"expected 24 frozen A11-derived Verilog files, found {len(sources)}")

entries = []
for index, source in enumerate(sources, 1):
    entries.append(
        f'<File Path="../src_v/{source.name}"><FileInfo>'
        '<Attr Name="UsedInSyn" Val="true"/>'
        '<Attr Name="UsedInP&amp;R" Val="true"/>'
        '<Attr Name="BelongTo" Val="design_1"/>'
        f'<Attr Name="CompileOrder" Val="{index}"/>'
        '</FileInfo></File>'
    )

project_file = PROJECT / "jpeg_core.al"
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

sdc = RUN / "jpeg_core.sdc"
sdc.write_text('create_clock -name clk_i -period 20 -waveform {0 10} [get_ports {clk_i}]\n', encoding="ascii")
area = REPORTS / "gate.area"
rtl_params = REPORTS / "actualparams.rtl.log"
gate_params = REPORTS / "actualparams.gate.log"
tcl = [
    'set run_root [file normalize [file join [file dirname [info script]] .]]',
    'set project_dir [file join $run_root td_project]', 'cd $project_dir',
    'if {[catch {', '  import_device eagle_s20.db -package EG4S20BG256',
    '  open_project jpeg_core.al -single_run', '  load_run_param -run syn_1',
    '  set_param gate add_map_lut_struct high', '  set_param gate map_mode area_prior',
    '  set_param gate multi_thread_mapping partition', '  set_param rtl resource_sharing auto',
    '  set_param rtl shifter_style shifter_reg', '  set_param rtl min_ripple_len 18',
    '  set_param gate mapper_lut_delay 1600',
    f'  report_param -stage rtl -detail -all -file {{{rtl_params.as_posix()}}}',
    f'  report_param -stage gate -detail -all -file {{{gate_params.as_posix()}}}',
    '  elaborate -top jpeg_core', '  read_sdc ../jpeg_core.sdc',
    '  commit_param -step rtl', '  optimize_rtl', '  commit_param -step gate',
    f'  puts "AREA_OUTPUT={{{area.as_posix()}}}"',
    f'  optimize_gate -packarea {{{area.as_posix()}}}',
    '} message]} { puts "BUILD_ERROR: $message"; exit 1 }',
    'puts SYNTHESIS_COMPLETE', 'close_project', 'exit',
]
tcl_path = RUN / "run_syn.tcl"
tcl_path.write_text("\n".join(tcl) + "\n", encoding="ascii")

manifest = {
    "variant": "A12_valid_prefix",
    "parent": "A11_color_mul",
    "change": "replace four 64-bit per-bank data-valid maps with per-block/per-bank valid-prefix counts",
    "invariant": "accepted JPEG coefficients arrive in ascending index order 0..63; writes to a block slot begin at index 0",
    "same_cycle_priority": "read-block clear, then new-block clear, then accepted input write",
    "device": "EG4S20BG256",
    "top": "jpeg_core",
    "strategy": "TD 6.2.1 SP1; AreaHigh; min_ripple_len=18; mapper_lut_delay=1600; add_map_lut_struct=high; map_mode=area_prior; multi_thread_mapping=partition; resource_sharing=auto; shifter_style=shifter_reg",
    "clock_period_ns": 20,
    "sources": [{"name": source.name, "sha256": sha256(source)} for source in sources],
    "project_sha256": sha256(project_file),
    "sdc_sha256": sha256(sdc),
    "tcl_sha256": sha256(tcl_path),
}
(RUN / "manifest.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
print(json.dumps({"variant": manifest["variant"], "source_count": len(sources), "manifest": str(RUN / "manifest.json")}))
