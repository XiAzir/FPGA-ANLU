from __future__ import annotations

import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
TD = Path(r"C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\bin\td_commands_prompt.exe")
VALID = {"control", "candidate", "green_control", "green_candidate",
         "green_control20", "green_candidate20"}


def main() -> None:
    if len(sys.argv) != 2 or sys.argv[1] not in VALID:
        raise SystemExit("usage: python run_td.py control|candidate|green_control|green_candidate|green_control20|green_candidate20")
    name = sys.argv[1]
    if name.endswith("20"):
        root = HERE / "green_dsp/td_maxdsp20"
    else:
        root = HERE / "green_dsp/td" if name.startswith("green_") else HERE / "td"
    run = root / name
    log_path = run / "td_console.log"
    if not TD.is_file():
        raise SystemExit(f"TD executable not found: {TD}")
    with log_path.open("wb") as output:
        process = subprocess.Popen([str(TD), (run / "run_syn.tcl").as_posix()], cwd=run,
                                   stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        assert process.stdout is not None
        for line in process.stdout:
            output.write(line)
            output.flush()
            text = line.decode("utf-8", "replace").strip()
            if any(token in text for token in (
                "SYNTHESIS_COMPLETE", "BUILD_ERROR", "WARNING", "CRITICAL-WARNING",
                "AREA_OUTPUT", "Setup WNS", "Setup TNS", "#DSPs", "#RAMs", "#Slices",
            )):
                print(f"{name}: {text}", flush=True)
        code = process.wait()
    print(f"{name} TD_EXIT={code}", flush=True)
    raise SystemExit(code)


if __name__ == "__main__":
    main()
