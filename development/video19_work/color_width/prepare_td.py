from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path


HERE = Path(__file__).resolve().parent
VARIANTS = {
    "control": HERE / "parent/src_v",
    "candidate": HERE / "candidate/src_v",
    "green_control": HERE / "parent/src_v",
    "green_candidate": HERE / "green_dsp/src_v",
}
SETTINGS = "TD 6.2.1 SP1; EG4S20BG256; AreaHigh; min_ripple_len=18; mapper_lut_delay=1600; add_map_lut_struct=high; map_mode=area_prior; multi_thread_mapping=partition; resource_sharing=auto; shifter_style=shifter_reg; max_dsp=17"


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def prepare(name: str, source: Path) -> None:
    root = HERE / "green_dsp/td" if name.startswith("green_") else HERE / "td"
    run = root / name
    run.mkdir(parents=True, exist_ok=True)
    project = run / "td_project"
    reports = run / "reports"
    project.mkdir(exist_ok=True)
    reports.mkdir(exist_ok=True)
    files = sorted(source.glob("*.v"))
    entries = []
    source_prefix = Path(os.path.relpath(source, project)).as_posix()
    for index, path in enumerate(files, 1):
        entries.append(f'<File Path="{source_prefix}/{path.name}"><FileInfo>'
                       '<Attr Name="UsedInSyn" Val="true"/>'
                       '<Attr Name="UsedInP&amp;R" Val="true"/>'
                       '<Attr Name="BelongTo" Val="design_1"/>'
                       f'<Attr Name="CompileOrder" Val="{index}"/>'
                       '</FileInfo></File>')
    al = ('<?xml version="1.0" encoding="UTF-8"?>\n'
          f'<Project Version="3" Minor="2" Path="{project.as_posix()}">'
          '<Project_Created_Time></Project_Created_Time><TD_Version>6.2.178840</TD_Version>'
          '<Name>jpeg_core</Name><HardWare><Family>EG4</Family><Device>EG4S20BG256</Device>'
          '<Speed></Speed></HardWare><Source_Files><Verilog>' + ''.join(entries) + '</Verilog></Source_Files>'
          '<FileSets><FileSet Name="design_1" Type="DesignFiles"></FileSet>'
          '<FileSet Name="constraint_1" Type="ConstrainFiles"></FileSet></FileSets>'
          '<TOP_MODULE><LABEL>jpeg_core</LABEL><MODULE>jpeg_core</MODULE><CREATEINDEX>user</CREATEINDEX></TOP_MODULE>'
          '<Property></Property><Device_Settings></Device_Settings><Configurations></Configurations>'
          '<Runs><Run Name="syn_1" Type="Synthesis" ConstraintSet="constraint_1" Description="" Active="true">'
          '<Strategy Name="Default_Synthesis_Strategy"></Strategy><UserParams></UserParams></Run></Runs>'
          '<Project_Settings></Project_Settings></Project>')
    (project / "jpeg_core.al").write_text(al, encoding="utf-8")
    (run / "jpeg_core.sdc").write_text(
        'create_clock -name clk_i -period 20 -waveform {0 10} [get_ports {clk_i}]\n', encoding="ascii")
    area = (reports / "gate.area").as_posix()
    rtl_param = (reports / "actualparams.rtl.log").as_posix()
    gate_param = (reports / "actualparams.gate.log").as_posix()
    after_param = (reports / "actualparams.gate.after.log").as_posix()
    tcl = f'''set run_root [file normalize [file join [file dirname [info script]] .]]
set project_dir [file join $run_root td_project]
cd $project_dir
if {{[catch {{
  import_device eagle_s20.db -package EG4S20BG256
  open_project jpeg_core.al -single_run
  load_run_param -run syn_1
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate max_dsp 17
  report_param -stage rtl -detail -all -file {{{rtl_param}}}
  report_param -stage gate -detail -all -file {{{gate_param}}}
  report_param -stage gate -detail -all -file {{{after_param}}}
  elaborate -top jpeg_core
  read_sdc ../jpeg_core.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={{{area}}}"
  optimize_gate -packarea {{{area}}}
}} message]}} {{ puts "BUILD_ERROR: $message"; exit 1 }}
puts SYNTHESIS_COMPLETE
close_project
exit
'''
    (run / "run_syn.tcl").write_text(tcl, encoding="ascii")
    (run / "source_manifest.json").write_text(json.dumps({
        "variant": name, "source_root": str(source), "settings": SETTINGS,
        "files": [{"name": path.name, "sha256": sha(path)} for path in files],
    }, indent=2) + "\n", encoding="utf-8")


for variant, source in VARIANTS.items():
    prepare(variant, source)
print(json.dumps({"prepared": list(VARIANTS), "settings": SETTINGS}, indent=2))
