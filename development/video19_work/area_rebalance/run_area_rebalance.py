from pathlib import Path
import subprocess
import sys

if len(sys.argv) != 2 or sys.argv[1] not in {"A08_base", "A10_c4_mul", "A11_color_mul", "A12_c4_color_mul"}:
    raise SystemExit("usage: python run_area_rebalance.py A08_base|A10_c4_mul|A11_color_mul|A12_c4_color_mul")

run = Path(__file__).resolve().parent / sys.argv[1]
exe = Path(r"C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\bin\td_commands_prompt.exe")
if not exe.is_file():
    raise SystemExit(f"TD executable not found: {exe}")

log = run / "td_console.log"
with log.open("wb") as output:
    proc = subprocess.Popen([str(exe), (run / "run_syn.tcl").as_posix()], cwd=run,
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
            print(f"{sys.argv[1]}: {text}", flush=True)
    code = proc.wait()
print(f"{sys.argv[1]} TD_EXIT={code}", flush=True)
raise SystemExit(code)
