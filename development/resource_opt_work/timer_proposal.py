"""Parameter-safe counter-width ablation for the BMP/audio candidate.

`apply(hdl_dir)` edits only these files below an isolated HDL source directory:
  tf_bmp_file_player.v, fat32_file_sector.v,
  SD/sd_card_bmp.v (key_press_debounce only), player_audio_probe.v.

Range proofs (default project parameters):
* tf_bmp_file_player.watchdog: during HEADER/WRITE_WAIT/COMMIT it increments
  only when no progress event occurs. Its timeout is tested against the old
  value after the state case, so the edge that sees old watchdog==WAIT_LIMIT
  still writes WAIT_LIMIT+1 before entering HALT. Thus values are [0,
  WAIT_LIMIT+1] and $clog2(WAIT_LIMIT+2) bits suffice. The 33-bit range
  expression retains 32 bits when that range exceeds 2**32.
* auto_count: it increments only while auto scheduling is active and resets
  when auto_tick is true. auto_tick compares against the original 32-bit
  modulo result CLK_FREQ_HZ-1. The largest stored value is that target; the
  width is ceil(log2(target+1)), at least one. A target requiring 32 bits
  keeps the original width.
* fat32_file_sector.wait_count: in FAT_WAIT/DATA_WAIT, it increments only
  while sd_valid is low and below WAIT_LIMIT-1; timeout calls fail(), which
  writes zero on that same edge. For WAIT_LIMIT>0 its maximum is WAIT_LIMIT-1,
  so ceil(log2(WAIT_LIMIT)) bits suffice (minimum one). WAIT_LIMIT==0 uses
  the original unsigned 32-bit wrap target 32'hffffffff and retains 32 bits.
* key_press_debounce.cnt: while input differs from stable state, it increments
  below DEBOUNCE_CYCLES-1, then updates stable state and clears cnt. For a
  positive cycle count its maximum is DEBOUNCE_CYCLES-1. Zero/negative cycle
  values retain 32 bits to preserve the original signed-expression / unsigned
  comparison behavior and wrap reachability.
* player_audio_probe.blink_count: for positive PIXEL_HZ, the threshold is
  floor(PIXEL_HZ/2)-1; it resets when the old value reaches that threshold.
  Its maximum is floor(PIXEL_HZ/2)-1. Nonpositive/zero-half parameters retain
  32 bits to preserve the original negative-threshold comparison behavior.

All width expressions have a one-bit floor. For parameter ranges whose original
32-bit counter can reach the full 32-bit range, the generated width is 32.
The RTL state transitions, comparisons, and reset values remain unchanged.
"""
from __future__ import annotations

from pathlib import Path


def _replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise ValueError(f"expected one {label} anchor, found {count}")
    return text.replace(old, new, 1)


def _patch_tf(text: str) -> str:
    text = _replace_once(
        text,
        "reg [31:0] watchdog, auto_count;",
        """localparam [31:0] WATCHDOG_THRESHOLD = WAIT_LIMIT;
localparam [32:0] WATCHDOG_RANGE = {1'b0, WATCHDOG_THRESHOLD} + 33'd2;
localparam integer WATCHDOG_W = (WATCHDOG_RANGE > 33'h100000000) ? 32 :
    ((WATCHDOG_RANGE <= 1) ? 1 : $clog2(WATCHDOG_RANGE));
localparam [31:0] AUTO_TARGET = CLK_FREQ_HZ - 1;
localparam [32:0] AUTO_RANGE = {1'b0, AUTO_TARGET} + 33'd1;
localparam integer AUTO_COUNT_W = (AUTO_RANGE >= 33'h100000000) ? 32 :
    ((AUTO_RANGE <= 1) ? 1 : $clog2(AUTO_RANGE));
reg [WATCHDOG_W-1:0] watchdog;
reg [AUTO_COUNT_W-1:0] auto_count;""",
        "tf timer declarations",
    )
    return text


def _patch_mapper(text: str) -> str:
    text = _replace_once(
        text,
        "    localparam E_RANGE = 8'h01, E_GEOM = 8'h02, E_CLUSTER = 8'h03,\n"
        "               E_ADDR = 8'h04, E_SHORT = 8'h05, E_FAT = 8'h06,\n"
        "               E_EOC = 8'h07, E_LOOP = 8'h08, E_LIMIT = 8'h09,\n"
        "               E_TIMEOUT = 8'h0a;",
        """    localparam E_RANGE = 8'h01, E_GEOM = 8'h02, E_CLUSTER = 8'h03,
               E_ADDR = 8'h04, E_SHORT = 8'h05, E_FAT = 8'h06,
               E_EOC = 8'h07, E_LOOP = 8'h08, E_LIMIT = 8'h09,
               E_TIMEOUT = 8'h0a;
    localparam [32:0] WAIT_COUNT_RANGE = {1'b0, WAIT_LIMIT};
    localparam integer WAIT_COUNT_W = (WAIT_LIMIT == 0) ? 32 :
        ((WAIT_COUNT_RANGE <= 1) ? 1 : $clog2(WAIT_COUNT_RANGE));""",
        "mapper timeout width localparam",
    )
    return _replace_once(text, "    reg [31:0] wait_count;", "    reg [WAIT_COUNT_W-1:0] wait_count;", "mapper wait_count declaration")


def _patch_debounce(text: str) -> str:
    text = _replace_once(
        text,
        "localparam integer DEBOUNCE_CYCLES = (CLK_FREQ_HZ / 1000) * DEBOUNCE_MS;\n\n"
        "reg button_sync0;",
        """localparam integer DEBOUNCE_CYCLES = (CLK_FREQ_HZ / 1000) * DEBOUNCE_MS;
localparam [31:0] DEBOUNCE_RANGE = DEBOUNCE_CYCLES[31:0];
localparam integer DEBOUNCE_COUNT_W = (DEBOUNCE_CYCLES <= 0) ? 32 :
    ((DEBOUNCE_RANGE <= 1) ? 1 : $clog2(DEBOUNCE_RANGE));

reg button_sync0;""",
        "debounce width localparam",
    )
    return _replace_once(text, "reg [31:0] cnt;", "reg [DEBOUNCE_COUNT_W-1:0] cnt;", "debounce cnt declaration")


def _patch_audio(text: str) -> str:
    text = _replace_once(
        text,
        "    reg [31:0] blink_count;",
        """    localparam integer BLINK_HALF_CYCLES = PIXEL_HZ / 2;
    localparam [31:0] BLINK_RANGE = BLINK_HALF_CYCLES[31:0];
    localparam integer BLINK_COUNT_W = (BLINK_HALF_CYCLES <= 0) ? 32 :
        ((BLINK_RANGE <= 1) ? 1 : $clog2(BLINK_RANGE));
    reg [BLINK_COUNT_W-1:0] blink_count;""",
        "audio blink width declaration",
    )
    return text


def apply(hdl_dir: str | Path) -> list[Path]:
    """Apply this timer width patch to an isolated HDL source directory."""
    root = Path(hdl_dir)
    targets = {
        root / "tf_bmp_file_player.v": _patch_tf,
        root / "fat32_file_sector.v": _patch_mapper,
        root / "SD" / "sd_card_bmp.v": _patch_debounce,
        root / "player_audio_probe.v": _patch_audio,
    }
    patched: dict[Path, str] = {}
    for path, patch in targets.items():
        if not path.is_file():
            raise FileNotFoundError(path)
        source = path.read_text(encoding="utf-8-sig")
        patched[path] = patch(source)
    for path, source in patched.items():
        path.write_text(source, encoding="utf-8", newline="")
    return list(patched)
