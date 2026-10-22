from pathlib import Path
import hashlib
import json
import re
import shutil

ROOT = Path(__file__).resolve().parent
HERE = ROOT / "shared_validation"
BASELINE_SRC = Path("development/player_video19/src/user_source/hdl_source/jpeg").resolve()
CANDIDATE_SRC = Path("development/video20_work/shared_idct/src_v").resolve()
Q90 = Path("development/video19_work/cadence_analysis/runs/q90_reader_loop_20261021_204125_745999/jpeg_reference").resolve()
PIN = Path("development/video19_work/video_pin_scoreboard/runs/C04_Q90_pin_reference_mjp107_20261021_203750").resolve()
PIN_CORE = PIN / "standalone_core"

HERE.mkdir(parents=True, exist_ok=False)
for label, source in (("baseline_src", BASELINE_SRC), ("candidate_src", CANDIDATE_SRC)):
    target = HERE / label
    target.mkdir()
    files = sorted(source.glob("*.v"))
    if len(files) != 24:
        raise SystemExit(f"expected 24 JPEG RTL modules in {source}, got {len(files)}")
    for path in files:
        shutil.copy2(path, target / path.name)

fixtures = HERE / "fixtures"
fixtures.mkdir()
shutil.copy2(PIN / "input_frame_1.jpg", fixtures / "q90_frame_108.jpg")
shutil.copy2(Q90 / "frame_000.jpg", fixtures / "q90_frame_000.jpg")
shutil.copy2(Q90 / "frame_299.jpg", fixtures / "q90_frame_299.jpg")
shutil.copy2(PIN / "pin_rgb_reference.mem", fixtures / "pin_rgb_reference.mem")
shutil.copy2(Path("development/video19_work/jpeg_unit/tb_jpeg_core.sv"), HERE / "tb_jpeg_core.sv")
shutil.copy2(Path("development/video19_work/jpeg_unit/compare_runs.py"), HERE / "compare_runs.py")
runner = Path("development/video19_work/jpeg_unit/run.py").read_text(encoding="utf-8")
runner = runner.replace("ROOT = HERE.parents[2]", "ROOT = HERE.parents[3]")
runner = runner.replace("from PIL import Image\n", "")
runner = re.sub(r"def psnr\(.*?(?=def sha256\()", "", runner, flags=re.S)
runner = re.sub(r"def analyze\(.*?(?=def main\(\) -> None:)", "", runner, flags=re.S)
runner = runner.replace(
    "    result = analyze(jpeg_paths, pixels)\n",
    '    result = {"fixtures": [str(p) for p in jpeg_paths], "dimensions": [args.width, args.height],\n'
    '              "frames": len(jpeg_paths), "records": pixels.stat().st_size // 7,\n'
    '              "pixel_record_sha256": sha256(pixels), "analysis": "exact baseline/candidate comparison is performed separately"}\n',
)
(HERE / "run.py").write_text(runner, encoding="utf-8")

def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()

baseline = {p.name: sha(p) for p in sorted((HERE / "baseline_src").glob("*.v"))}
candidate = {p.name: sha(p) for p in sorted((HERE / "candidate_src").glob("*.v"))}
changed = sorted(name for name in baseline if baseline[name] != candidate.get(name))
if changed != ["jpeg_idct.v"]:
    raise SystemExit(f"shared candidate differs from current C04 in unexpected files: {changed}")
manifest = {
    "baseline_origin": str(BASELINE_SRC),
    "candidate_origin": str(CANDIDATE_SRC),
    "baseline_source_sha256": baseline,
    "candidate_source_sha256": candidate,
    "changed_sources": changed,
    "fixtures": {p.name: {"sha256": sha(p), "bytes": p.stat().st_size} for p in sorted(fixtures.iterdir()) if p.is_file()},
    "testbench_sha256": sha(HERE / "tb_jpeg_core.sv"),
    "note": "Baseline is current C04 live JPEG source read-only copied into this isolated folder; candidate source set is the frozen shared-IDCT complete source. Only jpeg_idct.v differs.",
}
(HERE / "source_manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
print(json.dumps({"changed_sources": changed, "baseline_idct_sha256": baseline["jpeg_idct.v"], "candidate_idct_sha256": candidate["jpeg_idct.v"], "fixtures": manifest["fixtures"]}, indent=2))
