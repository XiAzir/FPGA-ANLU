from pathlib import Path
import shutil
import re

ROOT = Path(__file__).resolve().parent
REFS = Path("development/video19_work/dht_case").resolve()
NAMES = ["y_dc", "y_ac", "cx_dc", "cx_ac"]

for variant in ("dht_if_chain", "dht_casez"):
    run = ROOT / variant
    if run.exists():
        raise SystemExit(f"refusing to overwrite existing evidence: {run}")
    shutil.copytree(ROOT / "src_v", run / "src_v")
    shutil.copytree(ROOT / "td_project", run / "td_project")
    shutil.copy2(ROOT / "jpeg_core.sdc", run / "jpeg_core.sdc")
    (run / "reports").mkdir()
    if variant == "dht_if_chain":
        for name in NAMES:
            path = run / "src_v" / f"jpeg_dht_std_{name}.v"
            ref = (REFS / f"jpeg_dht_std_{name}_reference.v").read_text(encoding="utf-8")
            ref = ref.replace(f"module jpeg_dht_std_{name}_reference", f"module jpeg_dht_std_{name}", 1)
            path.write_text(ref, encoding="utf-8")
    project = run / "td_project" / "jpeg_core.al"
    ptext = project.read_text(encoding="utf-8")
    ptext = re.sub(r'Path="[^"]+"', f'Path="{(run / "td_project").as_posix()}"', ptext, count=1)
    project.write_text(ptext, encoding="utf-8")
    tcl = (ROOT / "run_syn.baseline.tcl").read_text(encoding="utf-8")
    tcl = tcl.replace("E:/VSCODE-project/FPGA-ANLU/development/video20_work/huffman/reports/", run.as_posix() + "/reports/")
    (run / "run_syn.tcl").write_text(tcl, encoding="ascii")
print("prepared C04-source DHT if-chain and casez runs")
