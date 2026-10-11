"""Prepare an isolated Icarus replay from clear common primitives + card fixture."""
import re
import shutil
from pathlib import Path

EARLY = Path(__file__).resolve().parent
TASK = EARLY.parents[2]
COMMON = Path(r"C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\sim_release\common\al_map_basic.v")
FIXTURE = TASK / "build" / "actual_card_replay"
PRIMITIVES = ("AL_MUX", "AL_DFF", "AL_DFF_X", "AL_FADD")


def module_source(text, name):
    match = re.search(rf"(?m)^module\s+{re.escape(name)}\b", text)
    if not match:
        raise ValueError(f"plain module {name} not found in {COMMON}")
    end = re.search(r"(?m)^endmodule\b", text[match.start():])
    if not end:
        raise ValueError(f"endmodule missing for {name}")
    return text[match.start():match.start() + end.end()]


def main():
    EARLY.mkdir(parents=True, exist_ok=True)
    fixture_out = EARLY / "fixture"
    fixture_out.mkdir(parents=True, exist_ok=True)
    clear = COMMON.read_text(encoding="utf-8", errors="replace")
    extracted = [
        "// Extracted clear modules from Anlogic sim_release/common/al_map_basic.v.\n"
        "// FORMAL_VERIFICATION bypasses glbl-only GSR startup; RTL resets remain active.\n"
    ]
    for name in PRIMITIVES:
        extracted.append(module_source(clear, name))
    (EARLY / "al_map_basic_subset.v").write_text("\n\n".join(extracted) + "\n", encoding="utf-8")

    if not (FIXTURE / "fixture_report.json").exists():
        raise FileNotFoundError(f"actual replay fixture missing: {FIXTURE}")
    for name in ("lbas.hex", "sectors.hex", "config.vh"):
        shutil.copyfile(FIXTURE / name, fixture_out / name)
    for source, count, dest in (("pixels.hex", 2 * 640 * 480, "pixels.hex"),
                                ("samples.hex", 2300, "samples.hex")):
        values = (FIXTURE / source).read_text(encoding="ascii").splitlines()
        if len(values) < count:
            raise ValueError(f"{source} has only {len(values)} entries, need {count}")
        (fixture_out / dest).write_text("\n".join(values[:count]) + "\n", encoding="ascii")
    shutil.copyfile(TASK / "build" / "debug_gate" / "tb_fat_probe.v", EARLY / "tb_fat_probe.v")
    shutil.copyfile(TASK / "build" / "debug_gate" / "probe_rtl.v", EARLY / "probe_rtl.v")
    print(f"Prepared {fixture_out}: SPC64 actual-card sectors, 2-frame pixel golden, 2300-sample golden")
    print(f"Copied {EARLY / 'probe_rtl.v'} and the existing first-256-pixels probe TB into isolated early_sim")
    print("Only the missing EG_LOGIC_DRAM/BRAM behavior is locally modeled; no encrypted device library was read or compiled.")


if __name__ == "__main__":
    main()
