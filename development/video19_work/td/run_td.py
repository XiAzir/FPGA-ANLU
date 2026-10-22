from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
RUN = ROOT / "jpeg_core_area_high"
TCL = RUN / "run_syn.tcl"
EXE = Path(r"C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\bin\td_commands_prompt.exe")
LOG = RUN / "td_console.log"
if not EXE.is_file():
    raise SystemExit(f"TD executable not found: {EXE}")
with LOG.open("wb") as output:
    proc = subprocess.Popen(
        [str(EXE), TCL.as_posix()], cwd=RUN, stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT
    )
    assert proc.stdout is not None
    for line in proc.stdout:
        output.write(line)
        output.flush()
        text = line.decode("utf-8", "replace").strip()
        if any(token in text for token in (
            "AREA_OUTPUT", "SYNTHESIS_COMPLETE", "BUILD_ERROR",
            "WARNING", "CRITICAL-WARNING", "ERROR", "#LUT", "#REG",
        )):
            print(text, flush=True)
    code = proc.wait()
print(f"TD_EXIT={code}", flush=True)
raise SystemExit(code)
