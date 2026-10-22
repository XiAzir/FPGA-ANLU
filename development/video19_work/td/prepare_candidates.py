from pathlib import Path
import hashlib
import json
import re
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parents[2]
VENDOR = REPO / "development/video19_work/vendor/core_jpeg"
VENDOR_SRC = VENDOR / "src_v"
BASE_SRC = ROOT / "jpeg_core_area_high/src_v"
SNAPSHOT = ROOT / "candidate_src/vendor_snapshot"
VARIANTS = {
    "A01": "constant C4_16 multiply rewritten as exact signed 32-bit shift-add in jpeg_idct_x/y",
    "A02": "four fixed YCbCr constants rewritten as exact signed 32-bit shift-add/sub in jpeg_output",
    "A03": "A01 plus A02",
    "A04": "A03 plus dsp_style=no on C4, YCbCr and IDCT 181/256 product nets",
    "A05": "A04 plus ram_style=dram on 32x32 transpose RAM",
}
CONSTANTS = {
    2896: [11, 9, 8, 6, 4],
    181: [7, 5, 4, 2, 0],
    5743: [12, 10, 9, 6, 5, 3, 2, 1, 0],
    2925: [11, 9, 8, 6, 5, 3, 2, 0],
    1410: [10, 8, 7, 1],
    7258: [12, 11, 10, 6, 4, 3, 1],
}

def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()

def shift_sum(signal: str, constant: int) -> str:
    terms = [f"($signed({signal}) <<< {shift})" for shift in CONSTANTS[constant]]
    return " + ".join(terms)

if not SNAPSHOT.exists():
    shutil.copytree(BASE_SRC, SNAPSHOT)
vendor_hashes = {p.name: sha256(p) for p in sorted(VENDOR_SRC.glob("*.v"))}
snapshot_hashes = {p.name: sha256(p) for p in sorted(SNAPSHOT.glob("*.v"))}
if vendor_hashes != snapshot_hashes:
    raise SystemExit("candidate_src/vendor_snapshot differs from the pinned vendor src_v")

for name, description in VARIANTS.items():
    source_dir = ROOT / f"candidate_src/{name}"
    if source_dir.exists():
        shutil.rmtree(source_dir)
    shutil.copytree(SNAPSHOT, source_dir)

    if name in ("A01", "A03", "A04", "A05"):
        for module in ("jpeg_idct_x.v", "jpeg_idct_y.v"):
            path = source_dir / module
            text = path.read_text(encoding="utf-8-sig")
            old = "mul4_q <= mul4_a * mul4_b;"
            assert text.count(old) == 1, (module, text.count(old))
            product = f"mul4_q <= {shift_sum('mul4_a', 2896)};"
            if name in ("A04", "A05"):
                old_decl = "reg signed [31:0] mul4_q;"
                assert text.count(old_decl) == 1
                text = text.replace(old_decl, '(* dsp_style = "no" *) reg signed [31:0] mul4_q;')
                additions = []
                for index, operand in enumerate(("o_t6_5", "o_t5_6")):
                    additions.append(f'(* dsp_style = "no" *) wire signed [31:0] scale181_{index}_w = {shift_sum(operand, 181)};')
                    old_181 = f"({operand} * 181) / 256"
                    assert text.count(old_181) == 1
                    text = text.replace(old_181, f"scale181_{index}_w / 256")
                state_marker = "reg signed [31:0] o_t5_6;"
                assert text.count(state_marker) == 1
                text = text.replace(state_marker, state_marker + "\n" + "\n".join(additions), 1)
            text = text.replace(old, product)
            path.write_text(text, encoding="ascii")

    if name in ("A02", "A03", "A04", "A05"):
        path = source_dir / "jpeg_output.v"
        text = path.read_text(encoding="utf-8-sig")
        for identifier, constant in (
            ("cr_1_402_w", 5743), ("cr_0_714_w", 2925),
            ("cb_0_344_w", 1410), ("cb_1_772_w", 7258),
        ):
            old = f"wire signed [31:0] {identifier} = ("
            start = text.index(old)
            end = text.index(";", start)
            # The wire operands are cr_value_w for cr_* and cb_value_w for cb_*.
            operand = "cr_value_w" if identifier.startswith("cr_") else "cb_value_w"
            replacement = f"wire signed [31:0] {identifier} = {shift_sum(operand, constant)}"
            if name in ("A04", "A05"):
                replacement = replacement.replace("wire signed", '(* dsp_style = "no" *) wire signed', 1)
            text = text[:start] + replacement + text[end:]
        path.write_text(text, encoding="ascii")

    if name == "A05":
        path = source_dir / "jpeg_idct_transpose_ram.v"
        text = path.read_text(encoding="utf-8-sig")
        old = "reg [31:0]   ram [31:0] /*verilator public*/;"
        assert text.count(old) == 1
        text = text.replace(old, '(* ram_style = "dram" *) reg [31:0]   ram [31:0] /*verilator public*/;')
        path.write_text(text, encoding="ascii")

    run = ROOT / f"candidate_td/{name}"
    project = run / "td_project"
    reports = run / "reports"
    project.mkdir(parents=True, exist_ok=True)
    reports.mkdir(parents=True, exist_ok=True)
    files = sorted(source_dir.glob("*.v"))
    entries = []
    for index, source in enumerate(files, 1):
        entries.append(
            f'<File Path="../../../candidate_src/{name}/{source.name}"><FileInfo>'
            '<Attr Name="UsedInSyn" Val="true"/>'
            '<Attr Name="UsedInP&amp;R" Val="true"/>'
            '<Attr Name="BelongTo" Val="design_1"/>'
            f'<Attr Name="CompileOrder" Val="{index}"/>'
            '</FileInfo></File>'
        )
    (project / "jpeg_core.al").write_text(
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        f'<Project Version="3" Minor="2" Path="{project.as_posix()}">\n'
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
    (run / "jpeg_core.sdc").write_text(
        'create_clock -name clk_i -period 20 -waveform {0 10} [get_ports {clk_i}]\n',
        encoding="ascii",
    )
    area = (reports / "gate.area").as_posix()
    rtl_params = (reports / "actualparams.rtl.log").as_posix()
    gate_params = (reports / "actualparams.gate.log").as_posix()
    gate_params_after = (reports / "actualparams.gate.after.log").as_posix()
    tcl = [
        'set run_root [file normalize [file join [file dirname [info script]] .]]',
        'set project_dir [file join $run_root td_project]',
        'cd $project_dir', 'if {[catch {',
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
        *(['  if {[catch {set_param gate max_dsp 17} max_dsp_message]} { puts "MAX_DSP_UNSUPPORTED=$max_dsp_message" } else { puts "MAX_DSP_SET=17" }',
           f'  report_param -stage gate -detail -all -file {{{gate_params_after}}}'] if name in ("A04", "A05") else []),
        '  elaborate -top jpeg_core', '  read_sdc ../jpeg_core.sdc',
        '  commit_param -step rtl', '  optimize_rtl', '  commit_param -step gate',
        f'  puts "AREA_OUTPUT={{{area}}}"',
        f'  optimize_gate -packarea {{{area}}}',
        '} message]} { puts "BUILD_ERROR: $message"; exit 1 }',
        'puts SYNTHESIS_COMPLETE', 'close_project', 'exit',
    ]
    (run / "run_syn.tcl").write_text("\n".join(tcl) + "\n", encoding="ascii")
    source_hashes = [{"name": p.name, "sha256": sha256(p)} for p in files]
    manifest = {
        "variant": name,
        "description": description,
        "vendor_commit": subprocess.check_output(
            ["git", "-C", str(VENDOR), "rev-parse", "HEAD"], text=True
        ).strip(),
        "vendor_source_hashes": vendor_hashes,
        "variant_source_hashes": source_hashes,
        "project_sha256": sha256(project / "jpeg_core.al"),
        "sdc_sha256": sha256(run / "jpeg_core.sdc"),
        "tcl_sha256": sha256(run / "run_syn.tcl"),
        "settings": "TD 6.2.1 SP1; EG4S20BG256; AreaHigh; min_ripple_len=18; mapper_lut_delay=1600; add_map_lut_struct=high; map_mode=area_prior; multi_thread_mapping=partition; resource_sharing=auto; shifter_style=shifter_reg",
        "max_dsp_override_attempt": "set_param gate max_dsp 17 under Tcl catch" if name in ("A04", "A05") else None,
        "clock_period_ns": 20,
    }
    (run / "manifest.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    print(f"PREPARED {name}: {len(files)} RTL files; {run}")
