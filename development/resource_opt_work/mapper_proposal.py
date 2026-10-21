"""Apply the resource proposal to one isolated fat32_file_sector.v candidate.

The caller owns the candidate file. This module never searches for or edits the
project's active source on its own; call apply(hdl_path) explicitly.
"""

from __future__ import annotations

from pathlib import Path


def apply(
    hdl_path: str | Path,
    *,
    algorithm: bool = True,
    address: bool = True,
    index: bool = True,
) -> None:
    """Rewrite selected proposal sections in only *hdl_path*.

    ``algorithm`` selects the sector-ceil and 4096-cluster predicate changes;
    ``address`` selects 44-bit data and 33-bit FAT address datapaths;
    ``index`` selects 12-bit walk/cache indices. All sections default on.
    """
    path = Path(hdl_path)
    source = path.read_text(encoding="utf-8-sig")
    original = source

    def replace_once(old: str, new: str, label: str) -> None:
        nonlocal source
        count = source.count(old)
        if count != 1:
            raise ValueError(f"{path}: expected one {label} fragment, found {count}")
        source = source.replace(old, new, 1)

    if index:
        replace_once(
            "    reg [31:0] current_cluster, target_index, walk_index;\n",
            "    reg [31:0] current_cluster;\n"
            "    reg [11:0] target_index, walk_index;\n",
            "12-bit target/walk index declaration",
        )
        replace_once(
            "    reg [31:0] cache_cluster, cache_index, cache_start, cache_size;\n",
            "    reg [31:0] cache_cluster, cache_start, cache_size;\n"
            "    reg [11:0] cache_index;\n",
            "12-bit cache index declaration",
        )
    if algorithm:
        replace_once(
        "    wire [32:0] file_size_ext = {1'b0, rq_size};\n"
        "    wire [32:0] sectors_needed = (file_size_ext + 33'd511) >> 9;\n"
        "    wire [32:0] sectors_per_cluster = 33'd1 << sectors_per_cluster_shift;\n"
        "    wire [32:0] clusters_needed =\n"
        "        (sectors_needed + sectors_per_cluster - 1'b1) >> sectors_per_cluster_shift;\n",
        "    // ceil(file_size/512), represented exactly for every 32-bit input.\n"
        "    wire [23:0] sectors_needed =\n"
        "        {1'b0, rq_size[31:9]} + {23'd0, (|rq_size[8:0])};\n",
            "sector ceil arithmetic",
        )
        replace_once(
            "                end else if (clusters_needed > 33'd4096) begin\n",
            "                end else if (sectors_needed >\n"
            "                             (33'd4096 << sectors_per_cluster_shift)) begin\n",
            "4096-cluster limit predicate",
        )
    if address:
        replace_once(
            "    reg [63:0] wide_tmp;\n",
            "    wire [43:0] data_addr_tmp = {12'd0, data_lba} +\n"
            "        (({16'd0, current_cluster[27:0]} - 44'd2) <<\n"
            "         sectors_per_cluster_shift) +\n"
            "        (rq_sector & ((32'd1 << sectors_per_cluster_shift) - 32'd1));\n"
            "    wire [32:0] fat_addr_tmp = {1'b0, fat_lba} +\n"
            "        {8'd0, current_cluster[31:7]};\n",
            "address temporary declarations",
        )
        replace_once(
        "                    wide_tmp = {32'd0, data_lba} +\n"
        "                        (({32'd0, current_cluster} - 64'd2) << sectors_per_cluster_shift) +\n"
        "                        (rq_sector & ((32'd1 << sectors_per_cluster_shift) - 1));\n"
        "                    if (wide_tmp > 64'h00000000ffffffff) begin\n"
        "                        fail(E_ADDR);\n"
        "                    end else begin\n"
        "                        sd_addr <= wide_tmp[31:0];\n",
        "                    if (|data_addr_tmp[43:32]) begin\n"
        "                        fail(E_ADDR);\n"
        "                    end else begin\n"
        "                        sd_addr <= data_addr_tmp[31:0];\n",
        "44-bit data address calculation",
        )
        replace_once(
        "                    wide_tmp = {32'd0, fat_lba} +\n"
        "                        ((({32'd0, current_cluster} << 2)) >> 9);\n"
        "                    if (wide_tmp > 64'h00000000ffffffff) begin\n"
        "                        fail(E_ADDR);\n"
        "                    end else begin\n"
        "                        sd_addr <= wide_tmp[31:0];\n",
        "                    if (fat_addr_tmp[32]) begin\n"
        "                        fail(E_ADDR);\n"
        "                    end else begin\n"
        "                        sd_addr <= fat_addr_tmp[31:0];\n",
        "33-bit FAT address calculation",
        )

    if source == original:
        raise AssertionError("no proposal changes were applied")
    path.write_text(source, encoding="utf-8", newline="")


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("hdl_path", help="explicit candidate fat32_file_sector.v")
    parser.add_argument("--algorithm", action="store_true", help="apply only the algorithm section")
    parser.add_argument("--address", action="store_true", help="apply only the address section")
    parser.add_argument("--index", action="store_true", help="apply only the index section")
    args = parser.parse_args()
    if args.algorithm or args.address or args.index:
        apply(args.hdl_path, algorithm=args.algorithm, address=args.address, index=args.index)
    else:
        apply(args.hdl_path)
