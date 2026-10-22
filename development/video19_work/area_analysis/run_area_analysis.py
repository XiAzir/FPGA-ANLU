from pathlib import Path
import subprocess


RUN = Path(__file__).resolve().parent / "A12_valid_prefix"
EXE = Path(r"C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\bin\td_commands_prompt.exe")

if not EXE.is_file():
    raise SystemExit(f"TD executable not found: {EXE}")

with (RUN / "td_console.log").open("wb") as output:
    proc = subprocess.Popen([str(EXE), (RUN / "run_syn.tcl").as_posix()], cwd=RUN,
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    assert proc.stdout is not None
    for line in proc.stdout:
        output.write(line)
        output.flush()
        message = line.decode("utf-8", "replace").strip()
        if any(token in message for token in ("SYNTHESIS_COMPLETE", "BUILD_ERROR", "WARNING", "AREA_OUTPUT")):
            print(f"A12_valid_prefix: {message}", flush=True)
    code = proc.wait()
print(f"A12_valid_prefix TD_EXIT={code}", flush=True)
raise SystemExit(code)
