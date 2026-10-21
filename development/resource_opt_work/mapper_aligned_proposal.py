"""Build the combined mapper proposal with the aligned sector-offset OR."""

from __future__ import annotations

from pathlib import Path

from mapper_proposal import apply as apply_latest_wire_proposal


def apply(hdl_path: str | Path) -> None:
    """Apply latest wire-width proposal and replace aligned offset addition by OR.

    If the passed source already contains the latest 44-bit wire datapath, only
    the OR rewrite is applied. Otherwise the full combined mapper proposal is
    applied first. Only *hdl_path* is written.
    """
    path = Path(hdl_path)
    source = path.read_text(encoding="utf-8-sig")
    if "wire [43:0] data_addr_tmp =" not in source:
        apply_latest_wire_proposal(path)
        source = path.read_text(encoding="utf-8-sig")

    old = (
        "    wire [43:0] data_addr_tmp = {12'd0, data_lba} +\n"
        "        (({16'd0, current_cluster[27:0]} - 44'd2) <<\n"
        "         sectors_per_cluster_shift) +\n"
        "        (rq_sector & ((32'd1 << sectors_per_cluster_shift) - 32'd1));\n"
    )
    new = (
        "    wire [43:0] data_addr_tmp = {12'd0, data_lba} +\n"
        "        ((({16'd0, current_cluster[27:0]} - 44'd2) <<\n"
        "          sectors_per_cluster_shift) |\n"
        "         (rq_sector & ((32'd1 << sectors_per_cluster_shift) - 32'd1)));\n"
    )
    count = source.count(old)
    if count != 1:
        raise ValueError(f"{path}: expected one latest 44-bit aligned address expression, found {count}")
    path.write_text(source.replace(old, new, 1), encoding="utf-8", newline="")


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("hdl_path", help="explicit isolated candidate fat32_file_sector.v")
    args = parser.parse_args()
    apply(args.hdl_path)
