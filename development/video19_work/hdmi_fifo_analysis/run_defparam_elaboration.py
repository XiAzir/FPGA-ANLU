"""Compile the established integration harness with a hierarchical FIFO defparam.

The run stops at ModelSim elaboration and leaves all archived production inputs
unchanged. It is a diagnostic for parameter reachability through protected IP.
"""
from pathlib import Path
import hashlib
import importlib.util
import json
import re
import sys

ROOT = Path(__file__).resolve().parent
PHOTO_RUNNER = ROOT.parent / "photo_regression/run_photo_system.py"
DEF_PARAM = (
    "dut.u_hdmi_1_4b_transmitter_core_wrapper."
    "u_hdmi_tx_controller_wrapper.u_hdmi_island_data_gen."
    "U_audio_sample_packet_2_channel.u_w96_d1024_fifo.u5.ADDR_WIDTH"
)


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest().upper()


spec = importlib.util.spec_from_file_location("photo_runner", PHOTO_RUNNER)
if spec is None or spec.loader is None:
    raise SystemExit(f"cannot load integration runner: {PHOTO_RUNNER}")
photo = importlib.util.module_from_spec(spec)
spec.loader.exec_module(photo)
photo.HERE = ROOT
original_compile = photo.compile_sources
original_execute = photo.execute


def compile_with_defparam(cwd, sources, flags, top_tb):
    text = top_tb.read_text(encoding="utf-8")
    anchor = "module tb_system;"
    if text.count(anchor) != 1:
        raise RuntimeError("unexpected integration testbench module declaration")
    text = text.replace(
        anchor,
        anchor + f"\n defparam {DEF_PARAM} = 7;\n",
        1,
    )
    top_tb.write_text(text, encoding="utf-8")
    (cwd / "defparam_probe.do").write_text(
        "onerror {quit -code 2 -f}\n"
        "onbreak {quit -code 3 -f}\n"
        f"set fifo_aw [examine -radix decimal /tb_system/{DEF_PARAM.replace('dut.', 'dut.', 1)}]\n"
        "puts \"HDMI_FIFO_ADDR_WIDTH=$fifo_aw\"\n"
        "quit -code 0 -f\n",
        encoding="ascii",
    )
    (cwd / "defparam_receipt.json").write_text(json.dumps({
        "defparam": f"{DEF_PARAM}=7",
        "testbench": str(top_tb),
        "testbench_sha256": sha(top_tb),
        "scope": "isolated ModelSim testbench; no production source modified",
    }, indent=2) + "\n", encoding="utf-8")
    return original_compile(cwd, sources, flags, top_tb)


simulation_result = None


def elaborate_only(command, cwd, log, timeout=240):
    global simulation_result
    if Path(str(command[0])).name.lower() != "vsim.exe":
        return original_execute(command, cwd, log, timeout)
    command = list(command)
    for index, item in enumerate(command[:-1]):
        if item == "-do":
            command[index + 1] = "defparam_probe.do"
        if item == "-l":
            command[index + 1] = "defparam_probe.log"
    simulation_result = original_execute(command, cwd, log, timeout)
    return simulation_result


photo.compile_sources = compile_with_defparam
photo.execute = elaborate_only
sys.argv = [str(PHOTO_RUNNER)]
before = set((ROOT / "runs").glob("photo_system_*"))
try:
    photo.main()
except SystemExit as error:
    exit_code = int(error.code or 0)
else:
    exit_code = 0

created = sorted(set((ROOT / "runs").glob("photo_system_*")) - before,
                 key=lambda item: item.stat().st_mtime)
if not created:
    raise SystemExit(exit_code or 2)
run = created[-1]
log_path = run / "defparam_console.log"
log = log_path.read_text(encoding="utf-8", errors="replace") if log_path.exists() else ""
elab = run / "defparam_probe.log"
elab_log = elab.read_text(encoding="utf-8", errors="replace") if elab.exists() else ""
combined = log + "\n" + elab_log
sim_exit = simulation_result.get("exit_code") if simulation_result else None
status = "PASS" if sim_exit == 0 and "HDMI_FIFO_ADDR_WIDTH=7" in combined else "FAILED"
result = {
    "status": status,
    "run_dir": str(run),
    "defparam": f"{DEF_PARAM}=7",
    "parameter_value_observed": "HDMI_FIFO_ADDR_WIDTH=7" in combined,
    "runner_exit_code": exit_code,
    "simulator_exit_code": sim_exit,
    "diagnostics": [line for line in combined.splitlines()
                    if re.search(r"defparam|ADDR_WIDTH|HDMI_FIFO|\*\* (?:Error|Warning)", line, re.I)],
}
(run / "defparam_summary.json").write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
print(json.dumps(result, indent=2), flush=True)
if status != "PASS":
    raise SystemExit(exit_code or 3)
