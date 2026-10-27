from __future__ import annotations

import json
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
IVERILOG = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe"
VVP = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe"
ARBITER = ROOT / "development/player_video34_1080p15/src/user_source/hdl_source/yuv_sdram_burst_arbiter.v"
W = H = 32
MCU_COLS = MCU_ROWS = 2
MCU_COUNT = 4
Y_WORDS, C_WORDS = MCU_COUNT * 64, MCU_COUNT * 16
FRAME_WORDS = Y_WORDS + 2 * C_WORDS


def writer_word(index: int) -> int:
    return (0xA5000000 ^ (index * 0x0103070B)) & 0xFFFFFFFF


def memory_word(word_addr: int) -> int:
    if FRAME_WORDS <= word_addr < FRAME_WORDS + 16:
        return writer_word(word_addr - FRAME_WORDS)
    value = 0
    for lane in range(4):
        byte_addr = word_addr * 4 + lane
        value |= (((byte_addr * 37 + 11) & 255) << (lane * 8))
    return value


def expected_commands(frame: int) -> list[tuple[int, int]]:
    base = frame * FRAME_WORDS
    result = []
    for group in range(H // 4):
        mcu_y, inner = divmod(group, 4)
        for chunk in range(W // 8):
            mcu_x, xblock = divmod(chunk, 2)
            block = (inner // 2) * 2 + xblock
            mcu = mcu_y * MCU_COLS + mcu_x
            for pair in range(2):
                row = (inner % 2) * 4 + pair * 2
                result.append((frame, base + mcu * 64 + block * 16 + row * 2))
        for plane in range(2):
            for mcu_x in range(MCU_COLS):
                mcu = mcu_y * MCU_COLS + mcu_x
                result.append((frame, base + Y_WORDS + plane * C_WORDS + mcu * 16 + inner * 4))
    return result


def pixel_word_lane(x: int, y: int, plane: int, base: int) -> tuple[int, int]:
    mcu = (y // 16) * MCU_COLS + x // 16
    if plane == 0:
        block = ((y // 8) & 1) * 2 + ((x // 8) & 1)
        sample = (y % 8) * 8 + x % 8
        return base + mcu * 64 + block * 16 + sample // 4, sample & 3
    cx, cy = x // 2, y // 2
    sample = (cy % 8) * 8 + cx % 8
    offset = Y_WORDS if plane == 1 else Y_WORDS + C_WORDS
    return base + offset + mcu * 16 + sample // 4, sample & 3


def main() -> None:
    sim = HERE / "simv_arbiter.exe"
    log = HERE / "sim_arbiter.log"
    compile_result = subprocess.run([
        str(IVERILOG), "-g2012", "-s", "tb_yuv_scan_arbiter", "-o", str(sim),
        str(HERE / "tb_yuv_scan_arbiter.sv"), str(HERE / "yuv420_scan_cache.v"), str(ARBITER)],
        capture_output=True, text=True)
    if compile_result.returncode:
        log.write_text(compile_result.stdout + compile_result.stderr, encoding="utf-8")
        raise SystemExit(f"Icarus compile failed; see {log}")
    run = subprocess.run([str(VVP), str(sim)], capture_output=True, text=True, timeout=120)
    trace = run.stdout + run.stderr
    log.write_text(trace, encoding="utf-8")
    if run.returncode:
        raise SystemExit(f"integrated Icarus run failed; see {log}")

    got_commands = []
    pixels = []
    done = None
    for line in trace.splitlines():
        fields = line.split()
        if fields and fields[0] == "CMD":
            got_commands.append((int(fields[1]), int(fields[2])))
        elif fields and fields[0] == "PIX":
            pixels.append(tuple(map(int, fields[1:])))
        elif fields and fields[0] == "DONE":
            done = {key: int(value) for key, value in (token.split("=") for token in fields[1:])}

    expected_cmds = expected_commands(0) + expected_commands(1)
    if got_commands != expected_cmds:
        for i, (got, expected) in enumerate(zip(got_commands, expected_cmds)):
            if got != expected:
                raise AssertionError(f"BL4 command {i}: got={got}, expected={expected}")
        raise AssertionError(f"command count got={len(got_commands)}, expected={len(expected_cmds)}")

    if len(pixels) != 2 * W * H:
        raise AssertionError(f"pixel outputs got={len(pixels)}, expected={2*W*H}")
    for n, row in enumerate(pixels):
        frame, x, y, y_sample, cb_sample, cr_sample, bank_ready, underflow = row
        expected_frame = n // (W * H)
        xy_index = n % (W * H)
        expected_x, expected_y = xy_index % W, xy_index // W
        if (frame, x, y) != (expected_frame, expected_x, expected_y):
            raise AssertionError(f"pixel order/coordinates n={n}: {(frame,x,y)}")
        base = frame * FRAME_WORDS
        # Select the addressed byte from the address-coded APUG memory model.
        y_expected = (memory_word(pixel_word_lane(x, y, 0, base)[0]) >>
                      (8 * pixel_word_lane(x, y, 0, base)[1])) & 255
        cb_expected = (memory_word(pixel_word_lane(x, y, 1, base)[0]) >>
                       (8 * pixel_word_lane(x, y, 1, base)[1])) & 255
        cr_expected = (memory_word(pixel_word_lane(x, y, 2, base)[0]) >>
                       (8 * pixel_word_lane(x, y, 2, base)[1])) & 255
        if (y_sample, cb_sample, cr_sample) != (y_expected, cb_expected, cr_expected):
            raise AssertionError(f"YUV mismatch frame={frame} ({x},{y}): got={(y_sample,cb_sample,cr_sample)} expected={(y_expected,cb_expected,cr_expected)}")
        if bank_ready != 1 or underflow != 0:
            raise AssertionError(f"bank status frame={frame} ({x},{y}): ready={bank_ready}, underflow={underflow}")

    if done is None:
        raise AssertionError("missing DONE summary")
    expected_done = {"reads":192,"words":768,"returns":768,"writes":16,
                     "pixels":2048,"underflows":0}
    for key, value in expected_done.items():
        if done.get(key) != value:
            raise AssertionError(f"DONE {key}: got={done.get(key)}, expected={value}")
    if not 0 < done["write_pixel"] < W * H:
        raise AssertionError(f"the background write did not overlap frame 0 scan: {done['write_pixel']}")
    if done.get("gate_wait", 0) == 0 or done.get("refresh_wait", 0) == 0 or done.get("busy_wait", 0) == 0:
        raise AssertionError(f"missing busy/ref pause coverage: {done}")
    if done.get("return_gaps", 0) == 0:
        raise AssertionError(f"missing response gap coverage: {done}")

    result = {
        "status": "PASS",
        "arbiter_source": str(ARBITER),
        "geometry": {"width": W, "height": H, "frame_words": FRAME_WORDS},
        "frames_scanned": 2,
        "commands_checked": len(got_commands),
        "actual_read_returns_checked": done["returns"],
        "background_16_word_write_checked": done["writes"],
        "background_write_overlapped_frame0_pixels": done["write_pixel"],
        "pixels_ycbcr_checked": len(pixels),
        "underflows": done["underflows"],
        "arbiter_request_gate_wait_cycles": done["gate_wait"],
        "refresh_wait_cycles": done["refresh_wait"],
        "busy_wait_cycles": done["busy_wait"],
        "returned_data_leads_valid_by_one_mem_clock": "PASS; all address-coded readbacks matched",
        "simulator_log": str(log),
    }
    (HERE / "arbiter_integration_result.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
