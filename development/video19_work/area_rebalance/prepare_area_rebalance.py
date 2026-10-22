from pathlib import Path
import hashlib
import json
import shutil

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parents[2]
BASE_A08 = REPO / "development/video19_work/td/candidate_src/A08"
LIVE_JPEG = REPO / "development/player_video19/src/user_source/hdl_source/jpeg"

VARIANTS = {
    "A08_base": "A08 color-corrected baseline plus live jpeg_input marker-valid fix",
    "A10_c4_mul": "A08_base; restore mul4_q <= mul4_a * mul4_b and remove dsp_style=no on mul4_q in jpeg_idct_x/y",
    "A11_color_mul": "A08_base; map cr 5743 and cb 7258 32-bit signed constant products to DSP, preserving 32-bit truncation before >>>12",
    "A12_c4_color_mul": "A08_base; combine A10 C4 multipliers in IDCT x/y with A11 cr 5743 and cb 7258 color multipliers",
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def prepare(name: str) -> None:
    run = ROOT / name
    src = run / "src_v"
    project = run / "td_project"
    reports = run / "reports"
    if run.exists():
        print(f"KEEP existing run: {run}")
        return
    src.mkdir(parents=True)
    project.mkdir()
    reports.mkdir()

    for original in sorted(BASE_A08.glob("*.v")):
        shutil.copy2(original, src / original.name)
    shutil.copy2(LIVE_JPEG / "jpeg_input.v", src / "jpeg_input.v")

    if name in ("A10_c4_mul", "A12_c4_color_mul"):
        for module in ("jpeg_idct_x.v", "jpeg_idct_y.v"):
            path = src / module
            text = path.read_text(encoding="utf-8-sig")
            old_decl = '(* dsp_style = "no" *) reg signed [31:0] mul4_q;'
            new_decl = "reg signed [31:0] mul4_q;"
            old_expr = "mul4_q <= ($signed(mul4_a) <<< 11) + ($signed(mul4_a) <<< 9) + ($signed(mul4_a) <<< 8) + ($signed(mul4_a) <<< 6) + ($signed(mul4_a) <<< 4);"
            new_expr = "mul4_q <= mul4_a * mul4_b;"
            if text.count(old_decl) != 1 or text.count(old_expr) != 1:
                raise SystemExit(f"unexpected A08 C4 source in {module}")
            path.write_text(text.replace(old_decl, new_decl).replace(old_expr, new_expr), encoding="ascii")
    if name in ("A11_color_mul", "A12_c4_color_mul"):
        path = src / "jpeg_output.v"
        text = path.read_text(encoding="utf-8-sig")
        replacements = (
            ('(* dsp_style = "no" *) wire signed [31:0] cr_1_402_product_w = ($signed(cr_value_w) <<< 12) + ($signed(cr_value_w) <<< 10) + ($signed(cr_value_w) <<< 9) + ($signed(cr_value_w) <<< 6) + ($signed(cr_value_w) <<< 5) + ($signed(cr_value_w) <<< 3) + ($signed(cr_value_w) <<< 2) + ($signed(cr_value_w) <<< 1) + ($signed(cr_value_w) <<< 0);',
             'wire signed [31:0] cr_1_402_product_w = $signed(cr_value_w) * 32\'sd5743;'),
            ('(* dsp_style = "no" *) wire signed [31:0] cr_1_402_w = cr_1_402_product_w >>> 12; // cr_value_w * 1.402',
             'wire signed [31:0] cr_1_402_w = cr_1_402_product_w >>> 12; // cr_value_w * 1.402'),
            ('(* dsp_style = "no" *) wire signed [31:0] cb_1_772_product_w = ($signed(cb_value_w) <<< 12) + ($signed(cb_value_w) <<< 11) + ($signed(cb_value_w) <<< 10) + ($signed(cb_value_w) <<< 6) + ($signed(cb_value_w) <<< 4) + ($signed(cb_value_w) <<< 3) + ($signed(cb_value_w) <<< 1);',
             'wire signed [31:0] cb_1_772_product_w = $signed(cb_value_w) * 32\'sd7258;'),
            ('(* dsp_style = "no" *) wire signed [31:0] cb_1_772_w = cb_1_772_product_w >>> 12; // cb_value_w * 1.772',
             'wire signed [31:0] cb_1_772_w = cb_1_772_product_w >>> 12; // cb_value_w * 1.772'),
        )
        for old, new in replacements:
            if text.count(old) != 1:
                raise SystemExit(f"unexpected A08 color source in {path.name}: {old[:70]}")
            text = text.replace(old, new)
        path.write_text(text, encoding="ascii")

    files = sorted(src.glob("*.v"))
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
    al = project / "jpeg_core.al"
    al.write_text(
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
    sdc = run / "jpeg_core.sdc"
    sdc.write_text('create_clock -name clk_i -period 20 -waveform {0 10} [get_ports {clk_i}]\n', encoding="ascii")
    area = (reports / "gate.area").as_posix()
    rtl_params = (reports / "actualparams.rtl.log").as_posix()
    gate_params = (reports / "actualparams.gate.log").as_posix()
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
        '  elaborate -top jpeg_core', '  read_sdc ../jpeg_core.sdc',
        '  commit_param -step rtl', '  optimize_rtl', '  commit_param -step gate',
        f'  puts "AREA_OUTPUT={{{area}}}"',
        f'  optimize_gate -packarea {{{area}}}',
        '} message]} { puts "BUILD_ERROR: $message"; exit 1 }',
        'puts SYNTHESIS_COMPLETE', 'close_project', 'exit',
    ]
    tcl_path = run / "run_syn.tcl"
    tcl_path.write_text("\n".join(tcl) + "\n", encoding="ascii")
    manifest = {
        "variant": name,
        "parent": "A08+live-inputfix",
        "controlled_changes": (["C4 mul4_q product mapped to DSP in IDCT x/y"] if name == "A10_c4_mul" else [])
        + (["cr 5743 and cb 7258 signed products mapped to DSP"] if name == "A11_color_mul" else [])
        + (["A10 C4 IDCT multipliers plus A11 cr/cb color multipliers"] if name == "A12_c4_color_mul" else []),
        "description": VARIANTS[name],
        "device": "EG4S20BG256",
        "top": "jpeg_core",
        "strategy": "TD 6.2.1 SP1; AreaHigh; min_ripple_len=18; mapper_lut_delay=1600; add_map_lut_struct=high; map_mode=area_prior; multi_thread_mapping=partition; resource_sharing=auto; shifter_style=shifter_reg",
        "clock_period_ns": 20,
        "sources": [{"name": p.name, "sha256": sha256(p)} for p in files],
        "project_sha256": sha256(al),
        "sdc_sha256": sha256(sdc),
        "tcl_sha256": sha256(tcl_path),
    }
    (run / "manifest.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    print(f"PREPARED {name}: {len(files)} Verilog sources, {run}")


for variant in VARIANTS:
    prepare(variant)
