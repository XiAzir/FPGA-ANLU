from pathlib import Path
import hashlib
import json
import shutil
import subprocess

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parents[2]
VENDOR = REPO / "development/video19_work/vendor/core_jpeg"
BASE = ROOT / "candidate_src/A04"
SOURCE = ROOT / "candidate_src/A06"
RUN = ROOT / "candidate_td/A06"
PROJECT = RUN / "td_project"
REPORTS = RUN / "reports"

if SOURCE.exists():
    shutil.rmtree(SOURCE)
shutil.copytree(BASE, SOURCE)

ram_path = SOURCE / "jpeg_idct_transpose_ram.v"
ram = ram_path.read_text(encoding="utf-8-sig")
module_decl = "module jpeg_idct_transpose_ram\n"
ram_decl = "reg [31:0]   ram [31:0] /*verilator public*/;"
assert ram.count(module_decl) == 1 and ram.count(ram_decl) == 1
logic_ram = ram.replace(module_decl, "module jpeg_idct_transpose_logic_ram\n", 1)
logic_ram = logic_ram.replace(ram_decl, '(* ram_style = "dram" *) ' + ram_decl, 1)
(SOURCE / "jpeg_idct_transpose_logic_ram.v").write_text(logic_ram, encoding="ascii")

transpose_path = SOURCE / "jpeg_idct_transpose.v"
transpose = transpose_path.read_text(encoding="utf-8-sig")
instance_decl = "jpeg_idct_transpose_ram\nu_ram0"
assert transpose.count(instance_decl) == 1
transpose_path.write_text(
    transpose.replace(instance_decl, "jpeg_idct_transpose_logic_ram\nu_ram0", 1),
    encoding="ascii",
)

PROJECT.mkdir(parents=True, exist_ok=True)
REPORTS.mkdir(parents=True, exist_ok=True)

def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()

files = sorted(SOURCE.glob("*.v"))
entries = []
for index, source in enumerate(files, 1):
    entries.append(
        f'<File Path="../../../candidate_src/A06/{source.name}"><FileInfo>'
        '<Attr Name="UsedInSyn" Val="true"/>'
        '<Attr Name="UsedInP&amp;R" Val="true"/>'
        '<Attr Name="BelongTo" Val="design_1"/>'
        f'<Attr Name="CompileOrder" Val="{index}"/>'
        '</FileInfo></File>'
    )
(PROJECT / "jpeg_core.al").write_text(
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
area = (REPORTS / "gate.area").as_posix()
rtl_params = (REPORTS / "actualparams.rtl.log").as_posix()
gate_params = (REPORTS / "actualparams.gate.log").as_posix()
gate_params_after = (REPORTS / "actualparams.gate.after.log").as_posix()
tcl = [
    'set run_root [file normalize [file join [file dirname [info script]] .]]',
    'set project_dir [file join $run_root td_project]',
    'cd $project_dir', 'if {[catch {',
    '  import_device eagle_s20.db -package EG4S20BG256',
    '  open_project jpeg_core.al -single_run', '  load_run_param -run syn_1',
    '  set_param gate add_map_lut_struct high',
    '  set_param gate map_mode area_prior',
    '  set_param gate multi_thread_mapping partition',
    '  set_param rtl resource_sharing auto',
    '  set_param rtl shifter_style shifter_reg',
    '  set_param rtl min_ripple_len 18',
    '  set_param gate mapper_lut_delay 1600',
    f'  report_param -stage rtl -detail -all -file {{{rtl_params}}}',
    f'  report_param -stage gate -detail -all -file {{{gate_params}}}',
    '  if {[catch {set_param gate max_dsp 17} max_dsp_message]} { puts "MAX_DSP_UNSUPPORTED=$max_dsp_message" } else { puts "MAX_DSP_SET=17" }',
    f'  report_param -stage gate -detail -all -file {{{gate_params_after}}}',
    '  elaborate -top jpeg_core', '  read_sdc ../jpeg_core.sdc',
    '  commit_param -step rtl', '  optimize_rtl', '  commit_param -step gate',
    f'  puts "AREA_OUTPUT={{{area}}}"',
    f'  optimize_gate -packarea {{{area}}}',
    '} message]} { puts "BUILD_ERROR: $message"; exit 1 }',
    'puts SYNTHESIS_COMPLETE', 'close_project', 'exit',
]
(RUN / "run_syn.tcl").write_text("\n".join(tcl) + "\n", encoding="ascii")
manifest = {
    "variant": "A06",
    "description": "A04 with only transpose bank u_ram0 forced to DRAM via a duplicate same-behavior RAM module; u_ram1..u_ram3 remain BRAM",
    "parent_variant": "A04",
    "vendor_commit": subprocess.check_output(
        ["git", "-C", str(VENDOR), "rev-parse", "HEAD"], text=True
    ).strip(),
    "source_hashes": [{"name": p.name, "sha256": sha256(p)} for p in files],
    "project_sha256": sha256(PROJECT / "jpeg_core.al"),
    "sdc_sha256": sha256(RUN / "jpeg_core.sdc"),
    "tcl_sha256": sha256(RUN / "run_syn.tcl"),
    "settings": "TD 6.2.1 SP1; EG4S20BG256; AreaHigh; min_ripple_len=18; mapper_lut_delay=1600; add_map_lut_struct=high; map_mode=area_prior; multi_thread_mapping=partition; resource_sharing=auto; shifter_style=shifter_reg; max_dsp=17",
    "clock_period_ns": 20,
}
(RUN / "manifest.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
print(json.dumps({"variant": "A06", "source_count": len(files), "run": str(RUN)}))
