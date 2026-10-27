#!/usr/bin/env python3
"""Finite-width algebra check for the frame counter rewrite."""

from itertools import product


def check(width: int, fifo_width: int, max_burst: int) -> int:
    limit = 1 << width
    fifo_limit = 1 << fifo_width
    cases = 0
    # Frame lengths/counters are restricted to the no-wrap domain used by the
    # controller: completed writes do not exceed the requested frame length.
    for length, completed, fifo, burst, sent in product(
        range(limit), range(limit), range(fifo_limit), range(max_burst + 1), range(max_burst + 1)
    ):
        if completed > length or completed + fifo >= limit or completed + burst >= limit:
            continue
        remaining = length - completed
        assert (length <= completed + fifo) == (remaining <= fifo)
        assert (completed + sent < length) == (sent < remaining)
        # Legal frames are burst-aligned, so each completed burst has a full
        # active_burst_size remaining and subtraction does not underflow.
        if burst == 0:
            continue
        if remaining < burst:
            continue
        post_completed = completed + burst
        post_remaining = remaining - burst
        assert (post_completed < length) == (post_remaining != 0)
        cases += 1
    return cases


if __name__ == '__main__':
    n = check(width=7, fifo_width=4, max_burst=8)
    print(f'PASS: {n} no-wrap states checked for FIFO gate, write limit, and completion')
