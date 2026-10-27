from __future__ import annotations

import json
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
HDL = ROOT / "development/player_video34_1080p15/src/user_source/hdl_source"
IVERILOG = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe"
VVP = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe"
W = H = 32
MCU_COLS = MCU_ROWS = 2
MCU_COUNT = 4
Y_WORDS, C_WORDS = MCU_COUNT * 64, MCU_COUNT * 16
FRAME_WORDS = Y_WORDS + 2 * C_WORDS
TOTAL_WORDS = 2 * FRAME_WORDS


def centered(frame: int, plane: int, x: int, y: int) -> int:
    return ((x * 7 + y * 11 + frame * 37 + plane * 53) % 511) - 255


def stored_byte(frame: int, plane: int, x: int, y: int) -> int:
    return max(0, min(255, centered(frame, plane, x, y) + 128))


def expected_write_word(frame: int, local_addr: int) -> int:
    value = 0
    if local_addr < Y_WORDS:
        plane = 0
        mcu = local_addr // 64
        block = (local_addr % 64) // 16
        word_in_block = local_addr % 16
        mx, my = mcu % MCU_COLS, mcu // MCU_COLS
        bx, by = block % 2, block // 2
        for lane in range(4):
            sample = word_in_block * 4 + lane
            x = mx * 16 + bx * 8 + sample % 8
            y = my * 16 + by * 8 + sample // 8
            value |= stored_byte(frame, plane, x, y) << (lane * 8)
    else:
        if local_addr < Y_WORDS + C_WORDS:
            plane = 1
            mcu = (local_addr - Y_WORDS) // 16
            word_in_block = (local_addr - Y_WORDS) % 16
        else:
            plane = 2
            mcu = (local_addr - Y_WORDS - C_WORDS) // 16
            word_in_block = (local_addr - Y_WORDS - C_WORDS) % 16
        mx, my = mcu % MCU_COLS, mcu // MCU_COLS
        for lane in range(4):
            sample = word_in_block * 4 + lane
            x = mx * 8 + sample % 8
            y = my * 8 + sample // 8
            value |= stored_byte(frame, plane, x, y) << (lane * 8)
    return value


def expected_read_addresses(frame: int) -> list[int]:
    base = frame * FRAME_WORDS
    addresses = []
    for group in range(H // 4):
        mcu_y, inner = divmod(group, 4)
        for chunk in range(W // 8):
            mx, xblock = divmod(chunk, 2)
            block = (inner // 2) * 2 + xblock
            mcu = mcu_y * MCU_COLS + mx
            for pair in range(2):
                row = (inner % 2) * 4 + pair * 2
                start = base + mcu * 64 + block * 16 + row * 2
                addresses.extend(range(start, start + 4))
        for plane in range(2):
            for mx in range(MCU_COLS):
                mcu = mcu_y * MCU_COLS + mx
                start = base + Y_WORDS + plane * C_WORDS + mcu * 16 + inner * 4
                addresses.extend(range(start, start + 4))
    return addresses


def expected_rgb(frame: int, x: int, y: int) -> tuple[int, int, int]:
    yy = stored_byte(frame, 0, x, y)
    cb = stored_byte(frame, 1, x // 2, y // 2)
    cr = stored_byte(frame, 2, x // 2, y // 2)
    cbd, crd = cb - 128, cr - 128
    channels = (yy + ((crd * 5743) >> 12),
                yy - ((cbd * 1410) >> 12) - ((crd * 2925) >> 12),
                yy + ((cbd * 7258) >> 12))
    return tuple(max(0, min(255, c)) for c in channels)


def main() -> None:
    sim = HERE / "simv_native_wrapper.exe"
    log = HERE / "sim_native_wrapper.log"
    sources = [
        HERE / "tb_native_yuv420_frame_buffer.sv",
        HDL / "native_yuv420_frame_buffer.v",
        HDL / "idct_yuv420_block_buffer.v",
        HDL / "yuv_sdram_burst_arbiter.v",
        HDL / "yuv420_scan_cache.v",
        HDL / "yuv420_to_rgb888.v",
    ]
    comp = subprocess.run([str(IVERILOG), "-g2012", "-s", "tb_native_yuv420_frame_buffer",
                           "-o", str(sim), *map(str, sources)], capture_output=True, text=True)
    if comp.returncode:
        log.write_text(comp.stdout + comp.stderr, encoding="utf-8")
        raise SystemExit(f"Icarus compile failed; see {log}")
    run = subprocess.run([str(VVP), str(sim)], capture_output=True, text=True, timeout=120)
    trace = run.stdout + run.stderr
    log.write_text(trace, encoding="utf-8")
    if run.returncode:
        raise SystemExit(f"native wrapper Icarus regression failed; see {log}")

    writes: dict[int, int] = {}
    reads: list[int] = []
    done_pulses: list[tuple[int, int]] = []
    rgb_rows: list[tuple[int, int, int, int]] = []
    done_summary = None
    for line in trace.splitlines():
        fields = line.split()
        if not fields:
            continue
        if fields[0] == "W":
            address, data = int(fields[1]), int(fields[2], 16)
            if address in writes:
                raise AssertionError(f"duplicate SDRAM write address {address}")
            writes[address] = data
        elif fields[0] == "R":
            reads.append(int(fields[1]))
        elif fields[0] == "WD":
            done_pulses.append((int(fields[1]), int(fields[2])))
        elif fields[0] == "RGB":
            rgb_rows.append((int(fields[1]), int(fields[2]), int(fields[3]), int(fields[4], 16)))
        elif fields[0] == "DONE":
            done_summary = dict(token.split("=") for token in fields[1:])

    if len(writes) != TOTAL_WORDS or set(writes) != set(range(TOTAL_WORDS)):
        raise AssertionError(f"write coverage={len(writes)} words; expected exactly addresses 0..{TOTAL_WORDS-1}")
    for address, value in writes.items():
        frame, local_addr = divmod(address, FRAME_WORDS)
        expected = expected_write_word(frame, local_addr)
        if value != expected:
            raise AssertionError(f"write data address {address}: got={value:08x}, expected={expected:08x}")
    if done_pulses != [(0, FRAME_WORDS), (1, FRAME_WORDS)]:
        raise AssertionError(f"write_frame_done events={done_pulses}")

    expected_reads = expected_read_addresses(0) + expected_read_addresses(1)
    if reads != expected_reads:
        for i, (got, want) in enumerate(zip(reads, expected_reads)):
            if got != want:
                raise AssertionError(f"read address {i}: got={got}, expected={want}")
        raise AssertionError(f"read word count={len(reads)}, expected={len(expected_reads)}")
    if len(set(reads)) != len(reads):
        raise AssertionError("scan read schedule contains duplicate words")

    if len(rgb_rows) != 2 * W * H:
        raise AssertionError(f"RGB outputs={len(rgb_rows)}, expected={2*W*H}")
    for n, (frame, x, y, rgb) in enumerate(rgb_rows):
        expected_frame = n // (W * H)
        pixel_index = n % (W * H)
        expected_x, expected_y = pixel_index % W, pixel_index // W
        if (frame, x, y) != (expected_frame, expected_x, expected_y):
            raise AssertionError(f"RGB coordinate/order n={n}: {(frame,x,y)}")
        r, g, b = expected_rgb(frame, x, y)
        expected = (r << 16) | (g << 8) | b
        if rgb != expected:
            raise AssertionError(f"RGB mismatch frame={frame} ({x},{y}): got={rgb:06x}, expected={expected:06x}")

    if done_summary is None:
        raise AssertionError("missing DONE summary")
    expected_done = {"rgb":2048,"f0":1024,"f1":1024,"underflow":0,
                     "reads":768,"returns":768,"done":2,"prefetch":2}
    done_ints = {key: int(done_summary[key]) for key in expected_done}
    if done_ints != expected_done:
        raise AssertionError(f"DONE counters: {done_ints}")
    if done_summary.get("writes") != "384/384":
        raise AssertionError(f"DONE frame write counts={done_summary.get('writes')}")
    first,last = map(int, done_summary["overlap"].split("-"))
    if not 0 < first <= last < W * H:
        raise AssertionError(f"frame 1 write did not overlap frame 0 display: {first}-{last}")

    result = {
        "status": "PASS",
        "wrapper": str(HDL / "native_yuv420_frame_buffer.v"),
        "geometry": {"width": W, "height": H, "frame_words": FRAME_WORDS},
        "native_blocks_per_frame": 24,
        "idct_index_permutation": "native_index={sequence[2:0],sequence[5:3]}; 64-cycle nonstallable blocks",
        "complete_unique_writes": len(writes),
        "write_frame_done_pulses": done_pulses,
        "read_words_checked": len(reads),
        "rgb_pixels_checked": len(rgb_rows),
        "frame1_write_overlapped_frame0_rgb_indices": [first, last],
        "underflows": 0,
        "apug_data_delay_1_cycle_and_actual_return_handoff": "PASS; address-coded memory readback matched",
        "rgb_reference": "Python independently applies sample clipping, YUV420 coordinates, C32 constants, >>>12, and RGB saturation",
        "simulator_log": str(log),
    }
    (HERE / "native_wrapper_regression_result.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
