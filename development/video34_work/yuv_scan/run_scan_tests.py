from __future__ import annotations

import json
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
IVERILOG = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe"
VVP = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe"
W, H = 32, 32
MCU_COLS, MCU_ROWS = 2, 2
MCU_COUNT = MCU_COLS * MCU_ROWS
Y_WORDS = MCU_COUNT * 64
C_WORDS = MCU_COUNT * 16
FRAME_WORDS = Y_WORDS + 2 * C_WORDS


def encoded_byte(word_addr: int, lane: int) -> int:
    return (((word_addr * 4 + lane) * 37) + 11) & 255


def pixel_byte_address(x: int, y: int, plane: int, frame_base: int) -> tuple[int, int]:
    mcu = (y // 16) * MCU_COLS + x // 16
    if plane == 0:
        block = ((y // 8) & 1) * 2 + ((x // 8) & 1)
        sample = (y % 8) * 8 + x % 8
        return frame_base + mcu * 64 + block * 16 + sample // 4, sample & 3
    cx, cy = x // 2, y // 2
    sample = (cy % 8) * 8 + cx % 8
    plane_offset = Y_WORDS if plane == 1 else Y_WORDS + C_WORDS
    return frame_base + plane_offset + mcu * 16 + sample // 4, sample & 3


def expected_commands(frame: int) -> list[tuple[int, int, int]]:
    base = frame * FRAME_WORDS
    result = []
    for group in range(H // 4):
        mcu_y, inner = divmod(group, 4)
        for chunk in range(W // 8):
            mcu_x, xblock = divmod(chunk, 2)
            block = (inner // 2) * 2 + xblock
            for pair in range(2):
                local_row = (inner % 2) * 4 + pair * 2
                mcu = mcu_y * MCU_COLS + mcu_x
                result.append((frame, base + mcu * 64 + block * 16 + local_row * 2, 4))
        for plane in range(2):
            for mcu_x in range(MCU_COLS):
                mcu = mcu_y * MCU_COLS + mcu_x
                offset = Y_WORDS + plane * C_WORDS
                result.append((frame, base + offset + mcu * 16 + inner * 4, 4))
    return result


def audit_1080p15_scan_geometry() -> dict:
    width, height = 1920, 1080
    cols, rows = width // 16, (height + 15) // 16
    mcu_count = cols * rows
    y_plane_words = mcu_count * 64
    c_plane_words = mcu_count * 16
    frame_words = y_plane_words + 2 * c_plane_words
    groups = height // 4
    y_commands = (width // 8) * 2
    c_commands = width // 16
    commands_per_group = y_commands + 2 * c_commands
    seen = bytearray(frame_words)
    returned_words = 0
    for group in range(groups):
        mcu_y, inner = divmod(group, 4)
        addresses = []
        for chunk in range(width // 8):
            mcu_x, xblock = divmod(chunk, 2)
            block = (inner // 2) * 2 + xblock
            mcu = mcu_y * cols + mcu_x
            for pair in range(2):
                local_row = (inner % 2) * 4 + pair * 2
                addresses.append(mcu * 64 + block * 16 + local_row * 2)
        for plane in range(2):
            for mcu_x in range(cols):
                mcu = mcu_y * cols + mcu_x
                addresses.append(y_plane_words + plane * c_plane_words + mcu * 16 + inner * 4)
        if len(addresses) != commands_per_group:
            raise AssertionError("1080p command count differs from the planned BL4 schedule")
        for addr in addresses:
            if addr & 3:
                raise AssertionError(f"BL4 address is not four-word aligned: {addr}")
            if addr < 0 or addr + 3 >= frame_words:
                raise AssertionError(f"BL4 address exceeds padded frame: {addr}")
            for word in range(addr, addr + 4):
                if seen[word]:
                    raise AssertionError(f"scan schedule reads frame word twice: {word}")
                seen[word] = 1
                returned_words += 1
    expected_visible_words = (1920 * 1080 + 2 * 960 * 540) // 4
    if returned_words != expected_visible_words:
        raise AssertionError(f"scan schedule reads {returned_words} words, expected {expected_visible_words}")
    return {"visible_width": width, "visible_height": height, "padded_height": rows * 16,
            "groups": groups, "commands_per_group": commands_per_group,
            "commands_per_frame": groups * commands_per_group,
            "returned_words_per_frame": returned_words,
            "frame_words": frame_words, "double_frame_words": 2 * frame_words,
            "all_addresses_aligned_in_range_unique": True}


def main() -> None:
    sim = HERE / "simv.exe"
    log = HERE / "sim.log"
    comp = subprocess.run([
        str(IVERILOG), "-g2012", "-s", "tb_yuv420_scan_cache", "-o", str(sim),
        str(HERE / "tb_yuv420_scan_cache.sv"), str(HERE / "yuv420_scan_cache.v")],
        capture_output=True, text=True)
    if comp.returncode:
        log.write_text(comp.stdout + comp.stderr, encoding="utf-8")
        raise SystemExit(f"Icarus compile failed; see {log}")
    run = subprocess.run([str(VVP), str(sim)], capture_output=True, text=True, timeout=120)
    trace = run.stdout + run.stderr
    log.write_text(trace, encoding="utf-8")
    if run.returncode:
        raise SystemExit(f"Icarus simulation failed; see {log}")

    got_cmds = []
    for line in trace.splitlines():
        if line.startswith("CMD "):
            _, frame, seq, address = line.split()
            got_cmds.append((int(frame), int(address), int(seq)))
    exp_cmds = expected_commands(0) + expected_commands(1)
    if len(got_cmds) != len(exp_cmds):
        raise AssertionError(f"commands: got {len(got_cmds)}, expected {len(exp_cmds)}")
    for seq, (got, exp) in enumerate(zip(got_cmds, exp_cmds)):
        if got[:2] != exp[:2]:
            raise AssertionError(f"command {seq}: got={got}, expected={exp}")
        if got[2] != seq:
            raise AssertionError(f"command sequence tag {seq}: got {got[2]}")

    got_pixels = [line.split() for line in trace.splitlines() if line.startswith("PIX ")]
    expected_pixel_count = 2 * W * H
    if len(got_pixels) != expected_pixel_count:
        raise AssertionError(f"pixel outputs: got {len(got_pixels)}, expected {expected_pixel_count}")
    underflows = 0
    for row_index, row in enumerate(got_pixels):
        _, f, xs, ys, sy, scb, scr, ready, underflow = row
        frame, x, y = int(f), int(xs), int(ys)
        if frame != row_index // (W * H):
            raise AssertionError(f"frame label mismatch at pixel {row_index}")
        local_index = row_index % (W * H)
        if (x, y) != (local_index % W, local_index // W):
            raise AssertionError(f"pixel order mismatch at frame={frame} index={local_index}: ({x},{y})")
        base = frame * FRAME_WORDS
        values = []
        for plane in range(3):
            word, lane = pixel_byte_address(x, y, plane, base)
            values.append(encoded_byte(word, lane))
        observed = tuple(map(int, (sy, scb, scr)))
        if observed != tuple(values):
            raise AssertionError(f"YUV mismatch frame={frame} ({x},{y}): got={observed}, expected={values}")
        if ready != "1":
            raise AssertionError(f"pixel used an unready bank frame={frame} ({x},{y})")
        underflows += int(underflow)
    if underflows:
        raise AssertionError(f"underflow flags={underflows}")

    returned_words = 4 * len(got_cmds)
    result = {
        "status": "PASS",
        "test_geometry": {"width": W, "height": H, "four_line_groups_per_frame": H // 4,
                          "mcus_per_frame": MCU_COUNT, "frame_words": FRAME_WORDS},
        "frames_checked": 2,
        "commands_checked": len(got_cmds),
        "returned_words_checked": returned_words,
        "pixels_ycbcr_checked": len(got_pixels),
        "underflows": underflows,
        "rd_latency_and_gaps": "command ready stalls plus variable command delay and an inter-beat return gap",
        "bank_release": "8 sequential groups per frame exercise both banks and repeated overwrite after group consumption",
        "frame_base_change": f"second frame base={FRAME_WORDS}",
        "expected_ycbcr": "Python independently maps each pixel to MCU-tiled plane word/lane and decodes address-coded memory bytes",
        "1080p15_schedule_audit": audit_1080p15_scan_geometry(),
        "simulation_log": str(log),
    }
    (HERE / "test_result.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
