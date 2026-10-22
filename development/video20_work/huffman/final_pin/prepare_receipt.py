from pathlib import Path
import hashlib
import json
import sys

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[3]
BASE=ROOT/"development/player_video20/build/video_system_20261021_215350"
SYS=ROOT/"development/system_verification_20261016"
PLAYER=ROOT/"development/player_video20"
REFERENCE=ROOT/"development/video19_work/video_pin_scoreboard/runs/C04_Q90_pin_reference_mjp107_20261021_203750"
OLD_RUNS=ROOT/"development/video19_work/video_pin_scoreboard/runs"

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

checker=HERE/"system_pin_scoreboard_video.vh"
reference_receipt=json.loads((REFERENCE/"reference_receipt.json").read_text(encoding="utf-8"))
negative_runs={}
for name in ("C04_Q90_pin_20261021_203750_negative_rgb","C04_Q90_pin_20261021_203750_negative_pcm"):
    run=OLD_RUNS/name
    summary=json.loads((run/"summary.json").read_text(encoding="utf-8"))
    receipt=json.loads((run/"pin_source_receipt.json").read_text(encoding="utf-8"))
    negative_runs[name]={"status":summary["status"],"scoreboard_sha256":receipt["scoreboard_sha256"],
                         "testbench_sha256":receipt["testbench_sha256"],"summary_sha256":sha(run/"summary.json")}

if sha(checker).lower()!=negative_runs[next(iter(negative_runs))]["scoreboard_sha256"].lower():
    raise SystemExit("copied checker SHA differs from C04 negative-control receipts")
if any(row["status"]!="NEGATIVE_CONTROL_PASS" or row["scoreboard_sha256"].lower()!=sha(checker).lower()
       for row in negative_runs.values()):
    raise SystemExit("C04 negative-control receipts do not bind the copied checker SHA")
if reference_receipt.get("status")!="PASS" or reference_receipt.get("reference_pixels_per_frame")!=307200:
    raise SystemExit("existing C04 Q90 independent reference is not PASS/complete")

summary_path=BASE/"summary.json"
if summary_path.is_file():
    app_summary=json.loads(summary_path.read_text(encoding="utf-8"))
    app_state={"present":True,"status":app_summary.get("status"),"summary_sha256":sha(summary_path),
               "declared_run":app_summary.get("run_directory")}
else:
    app_state={"present":False,"status":"pending_at_preparation","summary_path":str(summary_path)}

receipt={
    "status":"PREPARED_ONLY",
    "project_root":str(ROOT),
    "root_resolution":str(ROOT),
    "base_run_default":str(BASE),
    "system_verification_root":str(SYS),
    "player_root":str(PLAYER),
    "runner_sha256":sha(HERE/"run_pin_scoreboard.py"),
    "scoreboard_sha256":sha(checker),
    "reference_run":str(REFERENCE),
    "reference_status":reference_receipt["status"],
    "reference_start_frame":reference_receipt.get("start_frame"),
    "reference_frame_count":len(reference_receipt.get("frames",[])),
    "reference_receipt_sha256":sha(REFERENCE/"reference_receipt.json"),
    "reference_mem_sha256":sha(REFERENCE/"pin_rgb_reference.mem"),
    "old_c04_negative_controls":negative_runs,
    "negative_control_reuse_scope":"C04 RGB/PCM single-reference-bit rejection evidence for this unchanged checker only; no D02 negative-control run is claimed.",
    "model_sim_compatibility_scope":"The runner applies the compatibility rewrite only to the per-run copied frozen jpeg_output.v.",
    "d02_app_summary":app_state,
    "pin_simulation_started":False,
}
(HERE/"prep_receipt.json").write_text(json.dumps(receipt,indent=2)+"\n",encoding="utf-8")
print(json.dumps(receipt,indent=2))
