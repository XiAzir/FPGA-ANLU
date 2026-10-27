#!/usr/bin/env python3
"""Count DC-only blocks in baseline sequential 4:2:0 JPEG frames."""
import json
import math
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "media1080"
INDEX = json.loads((ROOT / "media_index.json").read_text())
MJP = (ROOT / "VIDEO.MJP").read_bytes()


def parse_frame(data):
    if data[:2] != b"\xff\xd8":
        raise ValueError("missing SOI")
    huff = {}
    comp = {}
    quant = {}
    width = height = 0
    restart_interval = 0
    pos = 2
    while pos < len(data):
        if data[pos] != 0xff:
            raise ValueError(f"marker sync at {pos}")
        while data[pos] == 0xff:
            pos += 1
        marker = data[pos]
        pos += 1
        if marker == 0xd9:
            break
        if marker == 0xda:
            length = int.from_bytes(data[pos:pos+2], "big")
            ns = data[pos+2]
            scan = []
            p = pos + 3
            for _ in range(ns):
                cid, tables = data[p], data[p+1]
                scan.append((cid, tables >> 4, tables & 15))
                p += 2
            ss, se, ahal = data[p:p+3]
            entropy = data[pos+length:]
            break
        length = int.from_bytes(data[pos:pos+2], "big")
        seg = data[pos+2:pos+length]
        pos += length
        if marker == 0xc0:
            height, width = struct.unpack(">HH", seg[1:5])
            n = seg[5]
            p = 6
            for _ in range(n):
                cid, samp, tq = seg[p:p+3]
                comp[cid] = {"h": samp >> 4, "v": samp & 15, "tq": tq}
                p += 3
        elif marker == 0xc4:
            p = 0
            while p < len(seg):
                tc_th = seg[p]
                p += 1
                counts = list(seg[p:p+16])
                p += 16
                symbols = list(seg[p:p+sum(counts)])
                p += sum(counts)
                code = 0
                table = {}
                k = 0
                for bits, count in enumerate(counts, 1):
                    for _ in range(count):
                        table[(bits, code)] = symbols[k]
                        code += 1
                        k += 1
                    code <<= 1
                huff[(tc_th >> 4, tc_th & 15)] = table
        elif marker == 0xdd:
            restart_interval = int.from_bytes(seg[:2], "big")
        elif marker == 0xdb:
            p = 0
            while p < len(seg):
                info = seg[p]
                p += 1
                precision, tid = info >> 4, info & 15
                width_bytes = 2 if precision else 1
                values = [int.from_bytes(seg[p+j*width_bytes:p+(j+1)*width_bytes], "big") for j in range(64)]
                p += 64 * width_bytes
                quant[tid] = values
    else:
        raise ValueError("missing SOS")
    if (ss, se, ahal) != (0, 63, 0):
        raise ValueError("not baseline sequential scan")
    maxh = max(v["h"] for v in comp.values())
    maxv = max(v["v"] for v in comp.values())
    mcus_x = math.ceil(width / (maxh * 8))
    mcus_y = math.ceil(height / (maxv * 8))
    return entropy, scan, comp, huff, quant, mcus_x, mcus_y, restart_interval


class Bits:
    def __init__(self, data):
        self.data = data
        self.pos = 0
        self.buf = 0
        self.nbits = 0
    def byte(self):
        b = self.data[self.pos]
        self.pos += 1
        if b == 0xff:
            mark = self.data[self.pos]
            self.pos += 1
            if mark == 0:
                return 0xff
            if 0xd0 <= mark <= 0xd7:
                raise RuntimeError(f"restart:{mark:02x}")
            raise ValueError(f"unexpected marker ff{mark:02x}")
        return b
    def get(self, n):
        while self.nbits < n:
            self.buf = (self.buf << 8) | self.byte()
            self.nbits += 8
        self.nbits -= n
        return (self.buf >> self.nbits) & ((1 << n) - 1)
    def symbol(self, table):
        code = 0
        for n in range(1, 17):
            code = (code << 1) | self.get(1)
            if (n, code) in table:
                return table[(n, code)]
        raise ValueError("invalid Huffman code")
    def align_restart(self):
        self.nbits = 0
        self.buf = 0
        if self.data[self.pos] != 0xff or not 0xd0 <= self.data[self.pos+1] <= 0xd7:
            raise ValueError(f"missing RST marker at {self.pos}")
        self.pos += 2


ZIGZAG_TO_NATURAL = [0,1,8,16,9,2,3,10,17,24,32,25,18,11,4,5,
 12,19,26,33,40,48,41,34,27,20,13,6,7,14,21,28,35,42,49,56,57,
 50,43,36,29,22,15,23,30,37,44,51,58,59,52,45,38,31,39,46,53,60,
 61,54,47,55,62,63]

def signed16(value):
    value &= 0xffff
    return value - 0x10000 if value & 0x8000 else value

def frame_stats(data, collect=False):
    entropy, scan, comp, huff, quant, mx, my, rst = parse_frame(data)
    bits = Bits(entropy)
    predictors = {cid: 0 for cid, _, _ in scan}
    total = dc_only = 0
    examples = []
    maxh = max(c["h"] for c in comp.values())
    maxv = max(c["v"] for c in comp.values())
    for mcu in range(mx * my):
        for cid, td, ta in scan:
            for _ in range(comp[cid]["h"] * comp[cid]["v"]):
                cat = bits.symbol(huff[(0, td)])
                raw = bits.get(cat) if cat else 0
                diff = raw - ((1 << cat) - 1) if cat and raw < (1 << (cat - 1)) else raw
                predictors[cid] += diff
                ac_nonzero = False
                coefficients = [(0, signed16(predictors[cid] * quant[comp[cid]["tq"]][0]))]
                k = 1
                while k <= 63:
                    rs = bits.symbol(huff[(1, ta)])
                    run, size = rs >> 4, rs & 15
                    if size == 0:
                        if run == 0:
                            break
                        if run == 15:
                            k += 16
                            continue
                        raise ValueError(f"invalid AC symbol {rs:02x}")
                    k += run
                    raw = bits.get(size)
                    ac = raw - ((1 << size) - 1) if raw < (1 << (size - 1)) else raw
                    qtable = quant[comp[cid]["tq"]]
                    natural = ZIGZAG_TO_NATURAL[k]
                    coefficients.append((natural, signed16(ac * qtable[natural])))
                    ac_nonzero = True
                    k += 1
                total += 1
                if not ac_nonzero:
                    dc_only += 1
                if collect and ((not ac_nonzero and sum(1 for x in examples if x["dc_only"]) < 4) or
                                (ac_nonzero and sum(1 for x in examples if not x["dc_only"]) < 4)):
                    examples.append({"component": cid, "dc_only": not ac_nonzero, "coeffs": coefficients})
        if rst and (mcu + 1) % rst == 0 and (mcu + 1) < mx * my:
            bits.align_restart()
            predictors = {cid: 0 for cid, _, _ in scan}
    return total, dc_only, mx, my, examples


frames = INDEX["frames"]
sample_frames = {0, 49, 99, 149, 199, 249, 299}
all_total = all_dc = analyzed_frames = 0
sampled = []
real_examples = []
for i, item in enumerate(frames):
    if i not in sample_frames:
        continue
    analyzed_frames += 1
    start = item["jpeg_offset_bytes"]
    payload = MJP[start:start + item["jpeg_length_bytes"]]
    end = payload.find(b"\xff\xd9")
    if end < 0:
        raise ValueError(f"frame {i}: EOI missing")
    result = frame_stats(payload[:end+2], collect=(i == 0))
    if i == 0:
        real_examples = result[4]
    if result[0] != 8160 * 6:
        raise ValueError(f"frame {i}: expected 48960 blocks, got {result[0]}")
    all_total += result[0]
    all_dc += result[1]
    if i in sample_frames:
        sampled.append({"frame": i, "blocks": result[0], "dc_only": result[1], "fraction": result[1]/result[0]})
print(json.dumps({"frames": analyzed_frames, "blocks": all_total, "dc_only": all_dc,
                  "fraction": all_dc/all_total, "saved_cycles_at_10_per_dc": all_dc*10,
                  "samples": sampled, "real_block_examples_frame0": real_examples}, indent=2))
