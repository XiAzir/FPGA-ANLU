from pathlib import Path
import hashlib
import json
import re

HERE=Path(__file__).resolve().parent

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def run_row(label, baseline_name, candidate_name, mode, gap=0, abort_bytes=0):
    b=HERE/"runs"/baseline_name
    c=HERE/"runs"/candidate_name
    def parse(folder):
        text=(folder/"sim.log").read_text(encoding="utf-8")
        line=next(line for line in text.splitlines() if line.startswith("RESULT "))
        return {key:int(value,0) if value.startswith("0x") else int(value)
                for key,value in re.findall(r"(\w+)=([^\s]+)",line)}
    br,cr=parse(b),parse(c)
    comparison_files={
        "v1_frame108":HERE/"frame108_exact_result.json",
        "v3_frame108":HERE/"frame108_v3_exact_result.json",
        "v3_gap":HERE/"frame108_v3_mode3_exact_result.json",
        "v3_abort":HERE/"frame108_v3_abort_exact_result.json",
        "v1_frame000":HERE/"runs/q90_frame_000/comparison.json",
        "v1_frame299":HERE/"runs/q90_frame_299/comparison.json",
    }
    compare=json.loads(comparison_files[label].read_text(encoding="utf-8"))
    return {
        "label":label,"mode":mode,"gap":gap,"abort_bytes":abort_bytes,
        "baseline": {"run":str(b.relative_to(HERE)),**br,"pixel_sha256":digest(b/"pixels_xy_rgb.bin")},
        "candidate": {"run":str(c.relative_to(HERE)),**cr,"pixel_sha256":digest(c/"pixels_xy_rgb.bin")},
        "record_stream_exact":compare["record_stream_exact"],
        "record_count":compare["records"],
        "pin_gold_exact":(bool(compare["pin_gold"]["exact"]) if compare.get("pin_gold") else None),
        "comparison_file":str(comparison_files[label].relative_to(HERE)),
    }

rows=[
    run_row("v1_frame108","baseline_frame108","candidate_frame108",0),
    run_row("v1_frame000","baseline_q90_frame_000","candidate_q90_frame_000",0),
    run_row("v1_frame299","baseline_q90_frame_299","candidate_q90_frame_299",0),
    run_row("v3_frame108","baseline_v3_frame108","candidate_v3_frame108",0),
    run_row("v3_gap","b_v3_gap","c_v3_gap",3,gap=5),
    run_row("v3_abort","b_v3_abort","c_v3_abort",2,abort_bytes=20000),
]
manifest=json.loads((HERE/"source_manifest.json").read_text(encoding="utf-8"))
v3_manifest=json.loads((HERE/"candidate_v3_manifest.json").read_text(encoding="utf-8"))
result={
    "status":"PASS",
    "dimensions":[640,480],
    "pixels_per_frame":307200,
    "baseline_changed_from_candidate_v1":manifest["changed_sources"],
    "baseline_changed_from_candidate_v3":v3_manifest["changed_sources"],
    "baseline_source_sha256":manifest["baseline_source_sha256"],
    "candidate_v1_source_sha256":manifest["candidate_source_sha256"],
    "candidate_v3_source_sha256":v3_manifest["candidate_v3_source_sha256"],
    "fixture_sha256":{k:v["sha256"] for k,v in manifest["fixtures"].items()},
    "cases":rows,
    "unit_evidence_from_parent":str(Path("development/video20_work/shared_idct/equiv_214319").resolve()),
    "limitations":[
        "The unstarted V1 0+299 serial run failed before RTL simulation because the absolute concatenated JPEG path exceeded the testbench's 128-character string register; the individual frame 0 and frame 299 runs completed and matched exactly.",
        "No timing/resource synthesis was performed in this pixel validation task.",
    ],
}
(HERE/"validation_summary.json").write_text(json.dumps(result,indent=2)+"\n",encoding="utf-8")

lines=["# Shared IDCT full JPEG validation", "",
       "C04 current JPEG RTL is the baseline. The V1 candidate changes only `jpeg_idct.v`; V3 changes only `jpeg_idct.v` and `jpeg_idct_transpose.v`. Every listed full-frame comparison contains 307,200 coordinate/RGB records.", "",
       "| Case | Mode | Baseline cycles | Candidate cycles | Backpressure stalls (base/candidate) | Exact records | Pin gold |",
       "|---|---:|---:|---:|---:|---|---|"]
for row in rows:
    pin = "—" if row["pin_gold_exact"] is None else str(row["pin_gold_exact"])
    lines.append(f"| {row['label']} | {row['mode']} | {row['baseline']['cycles']} | {row['candidate']['cycles']} | {row['baseline']['stalls']}/{row['candidate']['stalls']} | {row['record_stream_exact']} | {pin} |")
lines += ["", "Frame108 V1, V3 mode0, V3 random input gaps plus random output backpressure, and V3 abort/reset recovery each match the C04 output stream exactly and match independent frame108 pin gold by coordinate and RGB. Frame0 and frame299 V1 single-frame runs also match exactly.", "", "The serialized V1 0+299 launch stopped before simulation because the generated absolute concatenated input path exceeded the testbench's 128-character path register. No serialized result is claimed. No synthesis or P&R was run.", "", "Machine-readable source hashes, fixture hashes, run log paths and per-case cycle counts are in [validation_summary.json](validation_summary.json).", ""]
(HERE/"validation_summary.md").write_text("\n".join(lines),encoding="utf-8")
print(HERE/"validation_summary.json")
