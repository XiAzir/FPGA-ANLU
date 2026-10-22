from pathlib import Path
import hashlib
import json
import shutil

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parents[2]
PLAYER = REPO / "development/player_video19/src/user_source/hdl_source"
RTL = ROOT / "rtl"
RTL.mkdir(parents=True, exist_ok=True)
files = [PLAYER / "player_video_schedule.v", PLAYER / "player_osd_state.v"]
for source in files:
    shutil.copy2(source, RTL / source.name)

def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()

manifest = {
    "status": "PREPARED",
    "scope": "schedule + OSD ownership/control simulation; reader, framebuffer and audio source are protocol models",
    "rtl_sources": [
        {"name": source.name, "sha256": sha256(RTL / source.name)} for source in files
    ],
    "testbench": {
        "name": "schedule_osd_tb.v",
        "sha256": sha256(ROOT / "schedule_osd_tb.v"),
    },
    "simulator": "@veriflow/iverilog-wasm@0.1.4 (Icarus Verilog WASM), generation 2005",
    "formal_audio_frames": 602,
    "samples_per_audio_frame": 3200,
    "reset_restart": "one reset between two 301-frame phases",
}
(ROOT / "manifest.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
print(json.dumps({"rtl": [p.name for p in files], "manifest": str(ROOT / "manifest.json")}))
