"""Sanity-check HDL timer width formulas and calculate default bit savings."""
from __future__ import annotations

import json
from pathlib import Path

U32 = (1 << 32) - 1
LIMIT = 1 << 32


def ceil_width(exclusive_upper: int) -> int:
    if exclusive_upper >= LIMIT:
        return 32
    return max(1, (exclusive_upper - 1).bit_length())


def watchdog_width(wait_limit: int) -> int:
    return 32 if wait_limit < 0 else ceil_width((wait_limit & U32) + 2)


def auto_width(clk_hz: int) -> int:
    target = (clk_hz - 1) & U32
    return ceil_width(target + 1)


def mapper_width(wait_limit: int) -> int:
    return 32 if (wait_limit & U32) == 0 else ceil_width(wait_limit & U32)


def debounce_width(cycles: int) -> int:
    return 32 if cycles <= 0 else ceil_width(cycles)


def blink_width(pixel_hz: int) -> int:
    half = pixel_hz // 2
    return 32 if half <= 0 else ceil_width(half)


def main() -> None:
    defaults = {
        "tf_watchdog": watchdog_width(50_000_000),
        "tf_auto_count": auto_width(50_000_000),
        "mapper_wait_count_each": mapper_width(50_000_000),
        "key_debounce_cnt_each_tf_loader": debounce_width((50_000_000 // 1000) * 50),
        "audio_blink_count": blink_width(25_000_000),
    }
    assert defaults == {
        "tf_watchdog": 26,
        "tf_auto_count": 26,
        "mapper_wait_count_each": 26,
        "key_debounce_cnt_each_tf_loader": 22,
        "audio_blink_count": 24,
    }
    total = (32-defaults["tf_watchdog"])+(32-defaults["tf_auto_count"])
    total += 2*(32-defaults["mapper_wait_count_each"])
    total += 2*(32-defaults["key_debounce_cnt_each_tf_loader"])
    total += 32-defaults["audio_blink_count"]
    assert total == 52

    edges = {
        "watchdog_zero": watchdog_width(0),
        "watchdog_u32max": watchdog_width(U32),
        "watchdog_wrap_edge": watchdog_width(U32-1),
        "autotick_zero_hz": auto_width(0),
        "autotick_one_hz": auto_width(1),
        "autotick_u32max_hz": auto_width(U32),
        "mapper_zero_limit": mapper_width(0),
        "mapper_one_limit": mapper_width(1),
        "mapper_u32max_limit": mapper_width(U32),
        "debounce_zero_cycles": debounce_width(0),
        "debounce_one_cycle": debounce_width(1),
        "debounce_sd_card_100mhz_50ms": debounce_width((100_000_000 // 1000) * 50),
        "blink_zero_hz": blink_width(0),
        "blink_one_hz": blink_width(1),
        "blink_two_hz": blink_width(2),
    }
    assert all(width == 32 for key, width in edges.items()
               if key in {"watchdog_u32max", "watchdog_wrap_edge", "autotick_zero_hz",
                          "autotick_u32max_hz", "mapper_zero_limit", "mapper_u32max_limit",
                          "debounce_zero_cycles", "blink_zero_hz", "blink_one_hz"})
    assert edges["watchdog_zero"] == 1 and edges["autotick_one_hz"] == 1
    assert edges["mapper_one_limit"] == 1 and edges["debounce_one_cycle"] == 1
    assert edges["debounce_sd_card_100mhz_50ms"] == 23
    assert edges["blink_two_hz"] == 1

    report = {
        "status": "PASS",
        "default_widths": defaults,
        "default_counter_reductions": {
            "tf_watchdog": 32-defaults["tf_watchdog"],
            "tf_auto_count": 32-defaults["tf_auto_count"],
            "mapper_wait_count_each_x2": 2*(32-defaults["mapper_wait_count_each"]),
            "key_debounce_cnt_each_tf_loader_x2": 2*(32-defaults["key_debounce_cnt_each_tf_loader"]),
            "audio_blink_count": 32-defaults["audio_blink_count"],
            "total_ff_bits": total,
        },
        "parameter_edge_widths": edges,
        "proof_notes": [
            "watchdog reaches WAIT_LIMIT+1 on the edge that observes the old value at WAIT_LIMIT; range width uses WAIT_LIMIT+2",
            "auto_count reaches the original 32-bit target CLK_FREQ_HZ-1 and resets on that tick",
            "mapper wait_count resets in fail() on the threshold edge and otherwise reaches at most WAIT_LIMIT-1",
            "positive debounce cycles reach at most DEBOUNCE_CYCLES-1 before reset; nonpositive cases retain 32 bits",
            "positive audio blink half-period reaches at most floor(PIXEL_HZ/2)-1; zero/negative thresholds retain 32 bits",
            "all parameter-dependent widths have a one-bit minimum; over-32-bit required ranges select 32 bits"
        ]
    }
    output = Path(__file__).with_name("timer_range_proof.json")
    output.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
