from __future__ import annotations

import json
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
IVERILOG = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe"
VVP = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe"
FRAME_WORDS = 783_360
MCU_COLS, MCU_ROWS = 120, 68
MCU_COUNT = MCU_COLS * MCU_ROWS
Y_WORDS = MCU_COUNT * 64
C_WORDS = MCU_COUNT * 16
VISIBLE_Y_BYTES = 1920 * 1080
PAD_Y_BYTES = 1920 * 1088
VISIBLE_C_BYTES = 960 * 540
PAD_C_BYTES = 960 * 544


def pixel_addresses(x: int, y: int, base: int) -> tuple[int, ...]:
    mcu = (y // 16) * MCU_COLS + x // 16
    y_subblock = ((y // 8) & 1) * 2 + ((x // 8) & 1)
    yi = (y % 8) * 8 + x % 8
    cx, cy = x // 2, y // 2
    ci = (cy % 8) * 8 + cx % 8
    return (base + mcu * 64 + y_subblock * 16 + yi // 4, yi & 3,
            base + Y_WORDS + mcu * 16 + ci // 4, ci & 3,
            base + Y_WORDS + C_WORDS + mcu * 16 + ci // 4, ci & 3)


def centered_to_byte(value: int) -> int:
    return max(0, min(255, value + 128))


def expected_write_words() -> list[tuple[int, int]]:
    result: list[tuple[int, int]] = []

    def add_block(plane: int, mx: int, my: int, block: int, base: int, count: int,
                  value_fn) -> None:
        mcu = my * MCU_COLS + mx
        by_index = []
        for i in range(count):
            value = value_fn(i)
            by_index.append((i, centered_to_byte(value)))
        for n in range(0, len(by_index), 4):
            chunk = by_index[n:n + 4]
            if len(chunk) != 4:
                raise AssertionError("expected crop boundary to retain whole words")
            i0 = chunk[0][0]
            if [x[0] for x in chunk] != list(range(i0, i0 + 4)):
                raise AssertionError("word group did not contain consecutive sample lanes")
            if plane == 0:
                offset = mcu * 64 + block * 16 + i0 // 4
            elif plane == 1:
                offset = Y_WORDS + mcu * 16 + i0 // 4
            else:
                offset = Y_WORDS + C_WORDS + mcu * 16 + i0 // 4
            word = sum(byte << (8 * lane) for lane, (_, byte) in enumerate(chunk))
            result.append((base + offset, word))

    base1 = FRAME_WORDS
    for block in range(4):
        add_block(0, 119, 67, block, base1, 64,
                  lambda i, b=block: -300 if i == 0 else (300 if i == 1 else i + b * 11 - 40))
    for plane in (1, 2):
        add_block(plane, 119, 67, 0, base1, 64,
                  lambda i, p=plane: -300 if i == 0 else (300 if i == 1 else i + p * 37 - 90))
    # Three pre-restart bytes must be discarded; only the post-restart block writes.
    add_block(0, 0, 0, 0, 0, 64,
              lambda i: -300 if i == 0 else (300 if i == 1 else i - 32))
    return result


def expected_rgb(y: int, cb: int, cr: int) -> tuple[int, int, int]:
    cb_delta, cr_delta = cb - 128, cr - 128
    r = y + ((cr_delta * 5743) >> 12)
    g = y - ((cb_delta * 1410) >> 12) - ((cr_delta * 2925) >> 12)
    b = y + ((cb_delta * 7258) >> 12)
    return tuple(max(0, min(255, c)) for c in (r, g, b))


def exhaustive_visible_address_audit() -> dict:
    y_seen = bytearray(PAD_Y_BYTES)
    cb_seen = bytearray(PAD_C_BYTES)
    y_dups = c_dups = 0
    for y in range(1080):
        for x in range(1920):
            yw, yl, cbw, cbl, _, _ = pixel_addresses(x, y, 0)
            ybyte = yw * 4 + yl
            cbyte = (cbw - Y_WORDS) * 4 + cbl
            if not 0 <= ybyte < PAD_Y_BYTES or not 0 <= cbyte < PAD_C_BYTES:
                raise AssertionError(f"visible pixel maps out of plane at ({x},{y})")
            if y_seen[ybyte]:
                y_dups += 1
            y_seen[ybyte] = 1
            if (x & 1) == 0 and (y & 1) == 0:
                if cb_seen[cbyte]:
                    c_dups += 1
                cb_seen[cbyte] = 1
    if y_dups or c_dups:
        raise AssertionError(f"duplicate sample addresses: y={y_dups}, c={c_dups}")
    if sum(y_seen) != VISIBLE_Y_BYTES or sum(cb_seen) != VISIBLE_C_BYTES:
        raise AssertionError("visible sample coverage does not match declared geometry")
    return {"visible_y_unique_bytes": sum(y_seen), "visible_cb_cr_unique_bytes": sum(cb_seen),
            "y_padding_bytes": PAD_Y_BYTES - VISIBLE_Y_BYTES,
            "each_chroma_padding_bytes": PAD_C_BYTES - VISIBLE_C_BYTES,
            "frame_words": FRAME_WORDS, "two_frame_words": FRAME_WORDS * 2,
            "two_frame_bytes": FRAME_WORDS * 2 * 4, "two_frames_fit_21bit_words": FRAME_WORDS * 2 < 2**21}


def main() -> None:
    sim = HERE / "simv.exe"
    log = HERE / "sim.log"
    sources = [HERE / "tb_yuv420_cache.sv", HERE / "yuv420_cache_write_packer.v",
               HERE / "yuv420_pixel_address.v", HERE / "yuv420_to_rgb888.v"]
    comp = subprocess.run([str(IVERILOG), "-g2012", "-s", "tb_yuv420_cache", "-o", str(sim),
                           *map(str, sources)], capture_output=True, text=True)
    if comp.returncode:
        log.write_text(comp.stdout + comp.stderr, encoding="utf-8")
        raise SystemExit(f"Icarus compile failed; see {log}")
    run = subprocess.run([str(VVP), str(sim)], capture_output=True, text=True, timeout=120)
    text = run.stdout + run.stderr
    log.write_text(text, encoding="utf-8")
    if run.returncode:
        raise SystemExit(f"Icarus simulation failed; see {log}")

    pix_lines = [line.split() for line in text.splitlines() if line.startswith("PIX ")]
    expected_points = [(0, 0, 0), (3, 1, 0), (4, 0, 0), (7, 7, 0), (8, 8, 0),
                       (15, 15, 0), (16, 0, 0), (1919, 0, 0), (0, 15, 0), (0, 16, 0),
                       (1919, 1079, 0), (1918, 1078, 0), (0, 0, FRAME_WORDS),
                       (1919, 1079, FRAME_WORDS)]
    if len(pix_lines) != len(expected_points):
        raise AssertionError(f"expected {len(expected_points)} pixel traces, got {len(pix_lines)}")
    for row, (x, y, base) in zip(pix_lines, expected_points):
        observed = tuple(map(int, row[1:]))
        expected = (x, y, *pixel_addresses(x, y, base))
        if observed != expected:
            raise AssertionError(f"pixel address mismatch: observed={observed} expected={expected}")

    observed_writes = [(int(row[1]), int(row[2], 16)) for row in
                       (line.split() for line in text.splitlines()) if row[0] == "WRITE"]
    expected_writes = expected_write_words()
    if observed_writes != expected_writes:
        for i, (got, exp) in enumerate(zip(observed_writes, expected_writes)):
            if got != exp:
                raise AssertionError(f"write word {i}: observed={got} expected={exp}")
        raise AssertionError(f"write count mismatch: observed={len(observed_writes)}, expected={len(expected_writes)}")
    if max(addr for addr, _ in observed_writes[:96]) != FRAME_WORDS + FRAME_WORDS - 1:
        raise AssertionError("last MCU did not write through the end of frame-1 padded allocation")

    inputs = [(16,128,128),(235,128,128),(128,0,255),(0,255,0),
              (255,0,0),(0,0,255),(128,255,255),(64,127,129)]
    rgb_lines = [line.split() for line in text.splitlines() if line.startswith("RGB ")]
    if len(rgb_lines) != len(inputs):
        raise AssertionError(f"expected {len(inputs)} RGB outputs, got {len(rgb_lines)}")
    for i, (row, (yy, cb, cr)) in enumerate(zip(rgb_lines, inputs)):
        got = tuple(map(int, row[1:]))
        expected = (100 + i, 200 + i, *expected_rgb(yy, cb, cr))
        if got != expected:
            raise AssertionError(f"RGB vector {i}: observed={got}, expected={expected}")

    geometry = exhaustive_visible_address_audit()
    result = {"status": "PASS", "pixel_address_vectors": len(pix_lines),
              "packer_words_checked": len(observed_writes), "rgb_vectors_checked": len(rgb_lines),
              "backpressure": "WRITE and RGB ready toggled during stream; output sequence retained",
              "frame_restart": "three partial bytes before restart were discarded",
              "geometry": geometry, "simulation_log": str(log)}
    (HERE / "test_result.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
