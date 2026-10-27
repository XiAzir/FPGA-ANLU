"""Exhaustively compare old and proposed wipe mapping over a small full domain."""

def old_map(addr, active, rows, old_idx, new_idx, frame_words, line_words, mask):
    old_base = frame_words if old_idx else 0
    new_base = frame_words if new_idx else 0
    offset = (addr - old_base) & mask
    cut_words = rows * line_words
    return ((new_base + offset) & mask) if active and offset < cut_words else addr


def candidate_map(addr, active, rows, old_idx, new_idx, frame_words, line_words, mask):
    old_base = frame_words if old_idx else 0
    new_base = frame_words if new_idx else 0
    cut_absolute = old_base + rows * line_words
    delta = new_base - old_base
    in_range = addr >= old_base and addr < cut_absolute
    return ((addr + delta) & mask) if active and in_range else addr


def main():
    # Exhaust the entire 8-bit address space, both actual frame buffers,
    # every legal row count, active/inactive and both old/new buffer choices.
    width = 8
    mask = (1 << width) - 1
    line_words = 4
    height = 4
    frame_words = line_words * height
    compared = 0
    for addr in range(1 << width):
        for rows in range(height + 1):
            for active in (False, True):
                for old_idx in (0, 1):
                    for new_idx in (0, 1):
                        old = old_map(addr, active, rows, old_idx, new_idx,
                                      frame_words, line_words, mask)
                        new = candidate_map(addr, active, rows, old_idx, new_idx,
                                            frame_words, line_words, mask)
                        assert old == new, (addr, rows, active, old_idx, new_idx, old, new)
                        compared += 1

    actual_frame_words = 480 * 480
    assert 2 * actual_frame_words < (1 << 21)
    print({"result": "PASS", "cases": compared,
           "actual_frame_words": actual_frame_words,
           "actual_max_cut_absolute": 2 * actual_frame_words,
           "address_space": 1 << 21})


if __name__ == "__main__":
    main()
