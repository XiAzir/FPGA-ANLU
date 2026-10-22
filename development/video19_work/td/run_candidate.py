from pathlib import Path
import json
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
if len(sys.argv) != 2 or sys.argv[1] not in {"A01", "A02", "A03", "A04", "A05", "A06", "A09"}:
    raise SystemExit("usage: python run_candidate.py A01|A02|A03|A04|A05|A06|A09")
NAME = sys.argv[1]
RUN = ROOT / f"candidate_td/{NAME}"
TCL = RUN / "run_syn.tcl"
EXE = Path(r"C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\bin\td_commands_prompt.exe")
LOG = RUN / "td_console.log"
if not EXE.is_file():
    raise SystemExit(f"TD executable not found: {EXE}")
with LOG.open("wb") as output:
    proc = subprocess.Popen([str(EXE), TCL.as_posix()], cwd=RUN,
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    assert proc.stdout is not None
    for line in proc.stdout:
        output.write(line)
        output.flush()
        text = line.decode("utf-8", "replace").strip()
        if any(token in text for token in (
            "SYNTHESIS_COMPLETE", "BUILD_ERROR", "WARNING", "CRITICAL-WARNING",
            "AREA_OUTPUT", "Setup WNS", "#DSPs", "#RAMs",
        )):
            print(text, flush=True)
    code = proc.wait()
print(f"TD_EXIT={code}", flush=True)
raise SystemExit(code)
