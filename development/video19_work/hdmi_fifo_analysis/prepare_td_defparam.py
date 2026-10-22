"""Create an isolated TD project snapshot with a FIFO depth defparam probe."""
from pathlib import Path
import hashlib
import json
import re
import shutil

ROOT = Path(__file__).resolve().parent
PLAYER_SRC = ROOT.parent.parent / "player_video19/src"
RUN = ROOT / "td_defparam"
SNAPSHOT = RUN / "project"
PROJECT = SNAPSHOT / "td_project/AC201_tf_hdmi.al"
TOP = SNAPSHOT / "user_source/hdl_source/top_tf_hdmi_audio.v"
RELATIVE_PATH = (
    "u_hdmi_1_4b_transmitter_core_wrapper."
    "u_hdmi_tx_controller_wrapper.u_hdmi_island_data_gen."
    "U_audio_sample_packet_2_channel.u_w96_d1024_fifo.u5.ADDR_WIDTH"
)


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest().upper()


if SNAPSHOT.exists():
    raise SystemExit(f"Refusing to overwrite existing TD experiment: {SNAPSHOT}")
RUN.mkdir(parents=True)
shutil.copytree(PLAYER_SRC / "user_source", SNAPSHOT / "user_source")
shutil.copytree(PLAYER_SRC / "td_project", SNAPSHOT / "td_project")

project_text = PROJECT.read_text(encoding="utf-8-sig")
original_root = (PLAYER_SRC / "td_project").as_posix()
if project_text.count(f'Path="{original_root}"') != 1:
    raise RuntimeError("expected one TD project-root Path attribute")
project_text = project_text.replace(
    f'Path="{original_root}"', f'Path="{(SNAPSHOT / "td_project").as_posix()}"', 1)
PROJECT.write_text(project_text, encoding="utf-8")

top_text = TOP.read_text(encoding="utf-8-sig")
module_match = re.search(r"^\s*module\s+top\b", top_text, re.M)
if not module_match or top_text.count("module top") != 1:
    raise RuntimeError("could not locate unique top module")
insert_at = top_text.index(";", module_match.start()) + 1
top_text = (top_text[:insert_at] + f"\n defparam {RELATIVE_PATH} = 7;\n" +
            top_text[insert_at:])
TOP.write_text(top_text, encoding="utf-8")

output = RUN / "build"
output.mkdir()
tcl = f'''set fpga_project_root [file normalize [file join [file dirname [info script]] project]]
set project_dir $fpga_project_root/td_project
set output_dir [file normalize [file join [file dirname [info script]] build]]
cd $project_dir
if {{[catch {{
    import_device eagle_s20.db -package EG4S20BG256
    open_project AC201_tf_hdmi.al -single_run
    load_run_param -run syn_1
    elaborate -top top
    read_adc ../user_source/constraints_source/pin.adc
    read_sdc ../user_source/constraints_source/timing.sdc
    read_sdc -ip rfifo_32_32_512 ../user_source/hdl_source/IP/afifo_16_32_256.tcl
    read_sdc -ip wfifo_32_32_512 ../user_source/hdl_source/IP/afifo_32_16_256.tcl
    commit_param -step rtl
    optimize_rtl
    export_db $output_dir/AC201_tf_hdmi_rtl.db
    commit_param -step gate
    optimize_gate -packarea $output_dir/AC201_tf_hdmi_gate.area
    write_verilog $output_dir/AC201_tf_hdmi_gate.v
    export_db $output_dir/AC201_tf_hdmi_gate.db
}} message]}} {{
    puts "BUILD_ERROR: $message"
    exit 1
}}
puts "SYNTHESIS_COMPLETE_WITH_GATE_DATABASE"
close_project
exit
'''
(RUN / "build_defparam.tcl").write_text(tcl, encoding="ascii")
receipt = {
    "status": "PREPARED",
    "source_project": str(PLAYER_SRC / "td_project/AC201_tf_hdmi.al"),
    "source_project_sha256": sha(PLAYER_SRC / "td_project/AC201_tf_hdmi.al"),
    "snapshot_project": str(PROJECT),
    "snapshot_project_sha256": sha(PROJECT),
    "source_top": str(PLAYER_SRC / "user_source/hdl_source/top_tf_hdmi_audio.v"),
    "source_top_sha256": sha(PLAYER_SRC / "user_source/hdl_source/top_tf_hdmi_audio.v"),
    "snapshot_top": str(TOP),
    "snapshot_top_sha256": sha(TOP),
    "defparam": f"{RELATIVE_PATH}=7",
    "scope": "isolated TD source and project snapshot; synthesis only",
}
(RUN / "receipt.json").write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")
print(json.dumps(receipt, indent=2))
