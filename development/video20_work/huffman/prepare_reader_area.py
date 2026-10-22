from pathlib import Path
import shutil
import re

ROOT = Path(__file__).resolve().parent
TEMPLATE = ROOT / "td_project" / "jpeg_core.al"
SOURCES = ROOT / "src_v"
VARIANTS = {
    "reader_baseline": SOURCES / "mjp_file_reader_reference.v",
    "reader_candidate": SOURCES / "mjp_file_reader.v",
}

for name, source in VARIANTS.items():
    run = ROOT / name
    if run.exists():
        raise SystemExit(f"refusing to overwrite existing evidence: {run}")
    (run / "src_v").mkdir(parents=True)
    (run / "td_project").mkdir()
    (run / "reports").mkdir()
    text = source.read_text(encoding="utf-8")
    if name == "reader_baseline":
        text = text.replace("module mjp_file_reader_reference (", "module mjp_file_reader (", 1)
    (run / "src_v" / "mjp_file_reader.v").write_text(text, encoding="utf-8")
    shutil.copy2(ROOT / "jpeg_core.sdc", run / "jpeg_core.sdc")

    project = TEMPLATE.read_text(encoding="utf-8")
    project = re.sub(r'Path="[^"]+"', f'Path="{(run / "td_project").as_posix()}"', project, count=1)
    file_node = '''<File Path="../src_v/mjp_file_reader.v">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="0"/>
                </FileInfo>
            </File>'''
    project = re.sub(r"<Verilog>.*?</Verilog>", "<Verilog>\n            " + file_node + "\n        </Verilog>", project, count=1, flags=re.S)
    project = project.replace("<LABEL>jpeg_core</LABEL>", "<LABEL>mjp_file_reader</LABEL>")
    project = project.replace("<MODULE>jpeg_core</MODULE>", "<MODULE>mjp_file_reader</MODULE>")
    (run / "td_project" / "jpeg_core.al").write_text(project, encoding="utf-8")

    tcl = (ROOT / "run_syn.baseline.tcl").read_text(encoding="utf-8")
    tcl = tcl.replace("elaborate -top jpeg_core", "elaborate -top mjp_file_reader")
    tcl = tcl.replace("../jpeg_core.sdc", "../jpeg_core.sdc")
    tcl = tcl.replace("reports/gate.area", "reports/gate.area")
    for stale_root in ("E:/VSCODE-project/FPGA-ANLU/development/video20_work/huffman",):
        tcl = tcl.replace(stale_root + "/reports/", (run.as_posix() + "/reports/"))
    (run / "run_syn.tcl").write_text(tcl, encoding="ascii")
print("prepared reader_baseline and reader_candidate TD runs")
