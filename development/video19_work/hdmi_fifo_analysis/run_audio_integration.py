"""Run the photo/audio/FFT system test with one isolated EG_LOGIC_RAMFIFO model."""
from pathlib import Path
import hashlib
import importlib.util
import json
import re
import shutil
import sys

ROOT = Path(__file__).resolve().parent
PHOTO_RUNNER = ROOT.parent / "photo_regression/run_photo_system.py"
MODELS = ROOT / "models"
VARIANTS = {"original", "depth128", "depth256"}


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest().upper()


if len(sys.argv) != 2 or sys.argv[1] not in VARIANTS:
    raise SystemExit("usage: python run_audio_integration.py original|depth128|depth256")
variant = sys.argv[1]
model = MODELS / variant / "eg_logic_ramfifo.v"
if not model.is_file():
    raise SystemExit(f"FIFO simulation model missing: {model}")

spec = importlib.util.spec_from_file_location("photo_runner", PHOTO_RUNNER)
if spec is None or spec.loader is None:
    raise SystemExit(f"cannot load existing integration runner: {PHOTO_RUNNER}")
photo = importlib.util.module_from_spec(spec)
spec.loader.exec_module(photo)
photo.HERE = ROOT
original_compile = photo.compile_sources


def compile_with_fifo_model(cwd, sources, flags, top_tb):
    local_model = cwd / "eg_logic_ramfifo_model.v"
    shutil.copy2(model, local_model)
    ordered_sources = [local_model] + list(sources)
    result = original_compile(cwd, ordered_sources, flags, top_tb)
    receipt_path = cwd / "source_receipt.json"
    receipt = json.loads(receipt_path.read_text(encoding="utf-8"))
    receipt["simulation_only_fifo_model"] = {
        "variant": variant,
        "source": str(model),
        "source_sha256": sha(model),
        "compiled_copy": str(local_model),
        "compiled_copy_sha256": sha(local_model),
        "model_precedence": "compiled into work; ModelSim invocation searches work before eg4",
    }
    receipt_path.write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")
    return result


photo.compile_sources = compile_with_fifo_model
sys.argv = [str(PHOTO_RUNNER)]
before = set((ROOT / "runs").glob("photo_system_*"))
exit_code = 0
try:
    photo.main()
except SystemExit as error:
    exit_code = int(error.code or 0)

created = sorted(set((ROOT / "runs").glob("photo_system_*")) - before,
                 key=lambda item: item.stat().st_mtime)
if not created:
    raise SystemExit(exit_code or 2)
run = created[-1]
log = (run / "console.log").read_text(encoding="utf-8", errors="replace")
max_events = [
    {"depth": int(depth), "occupancy": int(occupancy), "writes": int(writes), "reads": int(reads)}
    for depth, occupancy, writes, reads in re.findall(
        r"HDMI_FIFO_MAX depth=(\d+) occupancy=(\d+) writes=(\d+) reads=(\d+)", log)
]
stats = [
    {"depth": int(depth), "occupancy": int(occupancy), "max": int(maximum),
     "writes": int(writes), "reads": int(reads), "overflow": int(overflow),
     "underflow": int(underflow)}
    for depth, occupancy, maximum, writes, reads, overflow, underflow in re.findall(
        r"HDMI_FIFO_STATS depth=(\d+) occupancy=(\d+) max=(\d+) writes=(\d+) reads=(\d+) overflow=(\d+) underflow=(\d+)",
        log)
]
summary_path = run / "summary.json"
summary = json.loads(summary_path.read_text(encoding="utf-8"))
summary["fifo_depth_experiment"] = {
    "variant": variant,
    "depth_override_only_for_data_width_96": {"original": 1024, "depth128": 128, "depth256": 256}[variant],
    "local_model_source_sha256": sha(model),
    "max_occupancy_events": max_events,
    "periodic_fifo_stats": stats,
    "model_bound": bool(max_events or stats),
}
summary_path.write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
print(json.dumps({"variant": variant, "run": str(run),
                  "system_status": summary.get("status"),
                  "fifo_model_bound": summary["fifo_depth_experiment"]["model_bound"],
                  "fifo_stats": stats}, indent=2), flush=True)
if exit_code != 0 or not summary["fifo_depth_experiment"]["model_bound"]:
    raise SystemExit(exit_code or 3)
