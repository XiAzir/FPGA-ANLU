from pathlib import Path
import hashlib
import json
import shutil

HERE=Path(__file__).resolve().parent
SOURCE_V1=HERE/"candidate_src"
V3=HERE/"candidate_v3_src"
PARENT=Path("development/video20_work/shared_idct").resolve()
if V3.exists():
    raise SystemExit(f"refusing to overwrite: {V3}")
V3.mkdir()
for source in SOURCE_V1.glob("*.v"):
    shutil.copy2(source,V3/source.name)
shutil.copy2(PARENT/"jpeg_idct_early.v",V3/"jpeg_idct.v")
shutil.copy2(PARENT/"jpeg_idct_transpose_early.v",V3/"jpeg_idct_transpose.v")

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

baseline={p.name:sha(p) for p in sorted((HERE/"baseline_src").glob("*.v"))}
candidate={p.name:sha(p) for p in sorted(V3.glob("*.v"))}
changed=sorted(name for name in baseline if baseline[name]!=candidate[name])
if changed!=["jpeg_idct.v","jpeg_idct_transpose.v"]:
    raise SystemExit(f"unexpected V3 source differences: {changed}")
manifest={
    "baseline_origin":str(HERE/"baseline_src"),
    "v3_idct_wrapper_origin":str(PARENT/"jpeg_idct_early.v"),
    "v3_transpose_origin":str(PARENT/"jpeg_idct_transpose_early.v"),
    "changed_sources":changed,
    "baseline_source_sha256":baseline,
    "candidate_v3_source_sha256":candidate,
    "candidate_v3_tree_sha256":hashlib.sha256("\n".join(f"{k}:{v}" for k,v in candidate.items()).encode()).hexdigest(),
    "unit_evidence":str(PARENT/"equiv_214319"),
    "notes":"Only the parent-frozen V3 shared IDCT wrapper and EARLY_READ transpose files replace the corresponding V1 candidate source filenames; other 22 files remain identical to current C04 baseline.",
}
(HERE/"candidate_v3_manifest.json").write_text(json.dumps(manifest,indent=2)+"\n",encoding="utf-8")
print(json.dumps({"changed_sources":changed,"idct_v3_sha256":candidate["jpeg_idct.v"],"transpose_v3_sha256":candidate["jpeg_idct_transpose.v"],"tree_sha256":manifest["candidate_v3_tree_sha256"]},indent=2))
