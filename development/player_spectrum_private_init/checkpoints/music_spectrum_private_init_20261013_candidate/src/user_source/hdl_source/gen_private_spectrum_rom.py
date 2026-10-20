#!/usr/bin/env python3
"""Generate EG4 EG_PHY_BRAM INIT parameters for the spectrum coefficient ROMs."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


def read_mem(path: Path, depth: int, width: int) -> list[int]:
    words = [int(s, 16) for s in path.read_text(encoding="ascii").split()]
    if len(words) != depth or any(w >= (1 << width) for w in words):
        raise ValueError(f"{path}: expected {depth} words of {width} bits")
    return words


def packed_init(words: list[int], lane_width: int) -> tuple[list[int], list[int]]:
    """Return EG4 8K INIT and INITP planes in gate-level bit order."""
    data_bits = 8 if lane_width <= 9 else 16
    parity_bits = 1 if lane_width <= 9 else 2
    data_per_init = 256 // data_bits
    parity_per_init = 256 // parity_bits
    init = [0] * ((len(words) + data_per_init - 1) // data_per_init)
    initp = [0] * ((len(words) + parity_per_init - 1) // parity_per_init)
    for address, word in enumerate(words):
        if lane_width <= 9:
            data = word & 0xFF
            parity = (word >> 8) & 1
        else:
            upper_data_bits = 8 if lane_width == 18 else lane_width - 9
            data = (word & 0xFF) | (((word >> 9) & ((1 << upper_data_bits) - 1)) << 8)
            parity = ((word >> 8) & 1) | (((word >> 17) & 1) << 1 if lane_width == 18 else 0)
        init[address // data_per_init] |= data << ((address % data_per_init) * data_bits)
        initp[address // parity_per_init] |= parity << ((address % parity_per_init) * parity_bits)
    return init, initp


def hex_params(init: list[int], initp: list[int]) -> list[str]:
    lines = []
    lines.extend(f"    .INITP_{i:02X}(256'h{x:064X})" for i, x in enumerate(initp))
    lines.extend(f"    .INIT_{i:02X}(256'h{x:064X})" for i, x in enumerate(init))
    return lines


def bram(instance: str, width: int, addr_width: int, addr: str, q: str, enable: str,
         init: list[int], initp: list[int], mode: str) -> str:
    params = [f'    .DATA_WIDTH_A("{width}")', f'    .DATA_WIDTH_B("{width}")', f'    .MODE("{mode}")']
    params += hex_params(init, initp)
    addr_expr = f"{{{addr}, {13-addr_width}'b{'1'*(13-addr_width)}}}"
    if width == 18:
        addr_b = f".addrb({addr_expr}), .clkb(clk), .ceb({enable}), .oceb(1'b1), .csb(3'b111), .web(1'b0), .rstb(1'b0), .dib(9'b0),"
        output_ports = f".doa({q}[8:0]), .dob({q}[17:9])"
    else:
        addr_b = ".addrb(13'b0), .clkb(clk), .ceb(1'b0), .oceb(1'b0), .csb(3'b000), .web(1'b0), .rstb(1'b0), .dib(9'b0),"
        output_ports = f".doa({q}), .dob()"
    return "\n".join([
        f"  EG_PHY_BRAM #(",
        ",\n".join(params),
        f"  ) {instance} (",
        f"    .addra({addr_expr}), {addr_b}",
        f"    .clka(clk), .cea({enable}), .ocea(1'b1), .csa(3'b111), .wea(1'b0), .rsta(1'b0), .dia(9'b0),",
        f"    {output_ports}",
        "  );",
    ])


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--source", type=Path, default=Path(__file__).parent)
    ap.add_argument("--out", type=Path, default=Path(__file__).parent / "spectrum_coeff_rom.v")
    args = ap.parse_args()
    hann = read_mem(args.source / "spectrum_hann.mem", 1024, 16)
    twiddle = read_mem(args.source / "spectrum_twiddle.mem", 512, 32)
    h0 = [w & 0x1FF for w in hann]
    h1 = [(w >> 9) & 0x7F for w in hann]
    t0 = [w & 0x3FFFF for w in twiddle]
    t1 = [(w >> 18) & 0x3FFF for w in twiddle]
    banks = [
        ("u_hann_low", 9, 10, "hann_addr", "hann_low_q", "hann_en", h0, "SP8K"),
        ("u_hann_high", 9, 10, "hann_addr", "hann_high_q", "hann_en", h1, "SP8K"),
        ("u_twiddle_low", 18, 9, "twiddle_addr", "twiddle_low_q", "twiddle_en", t0, "PDPW8K"),
        ("u_twiddle_high", 18, 9, "twiddle_addr", "twiddle_high_q", "twiddle_en", t1, "PDPW8K"),
    ]
    inst = []
    manifest = {"roms": []}
    for name, width, aw, addr, q, enable, words, mode in banks:
        init, initp = packed_init(words, width)
        inst.append(bram(name, width, aw, addr, q, enable, init, initp, mode))
        manifest["roms"].append({"instance": name, "lane_width": width, "depth": len(words),
                                 "words_nonzero": sum(v != 0 for v in words),
                                 "word_sha256_be32": hashlib.sha256(b"".join(v.to_bytes(4, "big") for v in words)).hexdigest(),
                                 "init_count": len(init), "initp_count": len(initp)})
    sim = '''`ifdef PRIVATE_ROM_BEHAVIORAL_SIM
    reg [15:0] hann_mem [0:1023];
    reg [31:0] twiddle_mem [0:511];
    reg [15:0] sim_hann_q;
    reg [31:0] sim_twiddle_q;
    assign hann_q = sim_hann_q;
    assign twiddle_q = sim_twiddle_q;
  initial begin
    $readmemh(HANN_FILE, hann_mem);
    $readmemh(TWIDDLE_FILE, twiddle_mem);
  end
  always @(posedge clk) begin
      if (hann_en) sim_hann_q <= hann_mem[hann_addr];
      if (twiddle_en) sim_twiddle_q <= twiddle_mem[twiddle_addr];
  end
`else
  wire [8:0] hann_low_q, hann_high_q;
  wire [17:0] twiddle_low_q, twiddle_high_q;
  assign hann_q = {hann_high_q[6:0], hann_low_q};
  assign twiddle_q = {twiddle_high_q[13:0], twiddle_low_q};
'''
    primitive = "\n".join(inst)
    body = '''// Generated by gen_private_spectrum_rom.py; do not edit by hand.
module spectrum_coeff_rom #(
  parameter HANN_FILE = "spectrum_hann.mem",
  parameter TWIDDLE_FILE = "spectrum_twiddle.mem"
) (
  input wire clk,
  input wire hann_en,
  input wire [9:0] hann_addr,
  output wire [15:0] hann_q,
  input wire twiddle_en,
  input wire [8:0] twiddle_addr,
  output wire [31:0] twiddle_q
);
'''+sim+primitive+'''\n`endif
endmodule
'''
    args.out.write_text(body, encoding="ascii", newline="\n")
    manifest["source_sha256"] = {
        "hann": hashlib.sha256((args.source / "spectrum_hann.mem").read_bytes()).hexdigest(),
        "twiddle": hashlib.sha256((args.source / "spectrum_twiddle.mem").read_bytes()).hexdigest(),
    }
    manifest["output"] = str(args.out.resolve())
    (args.out.parent / "spectrum_coeff_rom_manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(manifest, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
