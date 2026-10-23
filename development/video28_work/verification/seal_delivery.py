"""Seal a C28 diagnostic delivery after all four certified TD stages."""
import datetime
import hashlib
import json
import re
import shutil
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
CAND = ROOT / "development/player_video28_hdmi_observe"
VERIFY = CAND / "verification"
MANUAL = CAND / "build/manual"
WORK = ROOT / "development/video28_work"


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read(path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def write(path, value):
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2), encoding="utf-8")


stages = read(VERIFY / "final_stage_binding.json")
offline = read(VERIFY / "offline_tests.json")
assert stages["status"] == offline["status"] == "PASS"
bit = MANUAL / "AC201_player_video28_hdmi_observe.bit"
assert sha(bit) == stages["bit_sha256"]
timing_text = (MANUAL / "AC201_tf_hdmi_phy.ts").read_text(encoding="utf-8")
m = re.search(r"SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns", timing_text)
slack = [float(v) for v in m.groups()]
assert min(slack) >= 0
timing = dict(zip(("setup_wns", "setup_tns", "hold_wns", "hold_tns"), slack))
netlist = (VERIFY / "final_routed.v").read_text(encoding="utf-8")
counts = {name: len(re.findall(r"^\s*" + name + r"\s*#\(", netlist, re.M))
          for name in ("EG_PHY_MSLICE", "EG_PHY_LSLICE")}
assert min(counts.values()) > 0
slices = sum(counts.values())
assert slices <= 9800
area_text = (MANUAL / "AC201_tf_hdmi_phy.area").read_text(encoding="utf-8")
area = {key: int(re.search(r"^#" + key + r"\s+(\d+)", area_text, re.M).group(1))
        for key in ("lut", "reg", "le", "bram", "dsp", "pll", "gclk")}
assert area["bram"] == 62 and area["dsp"] == 26
assert sha(MANUAL / "AC201_tf_hdmi_pr.db") == stages["stages"]["hold"]["artifacts"]["AC201_tf_hdmi_pr.db"]
assert sha(VERIFY / "final_routed.v") == read(VERIFY / "routed_export_binding.json")["final_routed_sha256"]

binding = dict(
    status="PASSIVE_DIAGNOSTIC_OFFLINE_PASS_BOARD_PENDING", build_id="00C11328",
    created_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
    base="C11327", purpose="HDMI lock/line/clock-input activity and photo-progress observations",
    bit_sha256=sha(bit), timing_ns=timing, slice_used=slices,
    slice_percent=100*slices/9800, routed_slices=counts, physical_resources=area,
    offline_tests_sha256=sha(VERIFY / "offline_tests.json"),
    final_stage_binding_sha256=sha(VERIFY / "final_stage_binding.json"),
    final_routed_sha256=sha(VERIFY / "final_routed.v"),
    routed_export_binding_sha256=sha(VERIFY / "routed_export_binding.json"),
    production_delta=offline["production_delta"],
    parent_c27_preserved=offline["parent_c27_preserved"],
    observations=dict(E="HDMI lock/ready, input SOFs and previous active-line count",
                      F="Raw TMDS clock word, pre-ODDR clock transitions/128 pixel cycles; tail 00",
                      page5="Scaler state/y/x when photo has no error; original failure detail otherwise"),
    outstanding=offline["outstanding"], board_result="PENDING",
)
write(VERIFY / "final_binding.json", binding)
download = ROOT / "download/video28_hdmi_observe.bit"
shutil.copy2(bit, download)
assert sha(download) == sha(bit)
write(download.with_suffix(".info.json"), binding)

package = ROOT / "deliverables/video28_hdmi_observe_c11328_20261023"
package.mkdir(exist_ok=False)
payload = {
    "video28_hdmi_observe.bit": download,
    "上板说明.md": WORK / "板测说明.md",
    "decode_pages.py": WORK / "decode_pages.py",
    "final_binding.json": VERIFY / "final_binding.json",
    "offline_tests.json": VERIFY / "offline_tests.json",
    "final_stage_binding.json": VERIFY / "final_stage_binding.json",
    "final_timing_status.txt": MANUAL / "AC201_tf_hdmi_phy.ts",
    "final_area.txt": MANUAL / "AC201_tf_hdmi_phy.area",
    "photo_regression.json": WORK / "photo_regression/summary.json",
    "phy_probe_matrix.json": WORK / "monitor_module/phy_probe_summary.json",
}
manifest = []
for name, source in payload.items():
    dest = package / name
    shutil.copy2(source, dest)
    assert sha(source) == sha(dest)
    manifest.append(dict(path=name, bytes=dest.stat().st_size, sha256=sha(dest)))
write(package / "MANIFEST.json", dict(build_id="00C11328", files=manifest))
zip_path = package.with_suffix(".zip")
assert not zip_path.exists()
with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as z:
    for path in sorted(package.iterdir()):
        z.write(path, path.name)
with zipfile.ZipFile(zip_path) as z:
    assert z.testzip() is None
    assert len(z.infolist()) == len(manifest)+1
    for item in manifest:
        assert hashlib.sha256(z.read(item["path"])).hexdigest() == item["sha256"]
receipt = dict(status="PASS", build_id="00C11328", package=zip_path.relative_to(ROOT).as_posix(),
               package_bytes=zip_path.stat().st_size, package_sha256=sha(zip_path),
               payload_count=len(manifest), bit_sha256=sha(bit), timing_ns=timing,
               slice_used=slices, slice_percent=binding["slice_percent"],
               binding_sha256=sha(VERIFY / "final_binding.json"), files=manifest)
write(VERIFY / "delivery_receipt.json", receipt)
print(json.dumps({key: receipt[key] for key in ("status", "package", "package_sha256", "bit_sha256", "timing_ns", "slice_used", "slice_percent")}, indent=2))
