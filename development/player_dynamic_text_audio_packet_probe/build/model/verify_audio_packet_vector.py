#!/usr/bin/env python3
"""Independent reflected-LFSR and lane-map checker for audio_packet_vector.json."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent
SRC = ROOT / "audio_packet_vector.json"
MEM = ROOT / "audio_packet_vector.mem"

TERC = [0x29C,0x263,0x2E4,0x2E2,0x171,0x11E,0x18E,0x13C,
        0x2CC,0x139,0x19C,0x2C6,0x28E,0x271,0x163,0x2C3]

def reflected_ecc(data: list[int]) -> int:
    """Right-shift reflected form of generator 0xC1 (reflected polynomial 0x83)."""
    crc = 0
    for byte in data:
        for bit in range(8):
            feedback = (crc & 1) ^ ((byte >> bit) & 1)
            crc >>= 1
            if feedback:
                crc ^= 0x83
    ecc = 0
    for bit in range(8):
        ecc |= (crc & 1) << bit
        crc >>= 1
    return ecc

def parse_hex_array(items: list[str]) -> list[int]:
    return [int(x, 16) for x in items]

def codeword(data: list[int], ecc: int) -> list[int]:
    return [((byte >> bit) & 1) for byte in data for bit in range(8)] + [((ecc >> bit) & 1) for bit in range(8)]

def main() -> None:
    obj = json.loads(SRC.read_text(encoding="utf-8-sig"))
    hb = parse_hex_array(obj["header_data_bytes"])
    hecc = reflected_ecc(hb)
    assert hecc == int(obj["header_bch"], 16), (hex(hecc), obj["header_bch"])
    hbits = codeword(hb, hecc)
    assert hbits == obj["header_codeword_bits_lsb_first"]
    blocks = []
    for ix, item in enumerate(obj["subpackets"]):
        data = parse_hex_array(item["dataBytes"])
        ecc = reflected_ecc(data)
        assert ecc == int(item["ecc"], 16), (ix, hex(ecc), item["ecc"])
        bits = codeword(data, ecc)
        assert bits == item["codewordBitsLsbFirst"], f"subpacket {ix} bit order mismatch"
        blocks.append(bits)

    out = []
    for clock in range(32):
        nib0 = hbits[clock] << 2  # HSYNC=VSYNC=0 in this test vector.
        nib1 = sum(blocks[s][2*clock] << s for s in range(4))
        nib2 = sum(blocks[s][2*clock+1] << s for s in range(4))
        row = obj["words32"][clock]
        assert row["clock"] == clock
        assert [int(x, 16) for x in row["terc_nibble"]] == [nib0,nib1,nib2], (clock, row)
        symbols = [TERC[nib0],TERC[nib1],TERC[nib2]]
        assert [int(x, 16) for x in row["tmds10"]] == symbols, (clock, row)
        packed = (symbols[0] << 20) | (symbols[1] << 10) | symbols[2]
        out.append(f"{packed:08X}")
    MEM.write_text("\n".join(out) + "\n", encoding="ascii")
    print(f"PASS: reflected BCH vector: header={hecc:02X}, body=" + ",".join(f"{int(x['ecc'],16):02X}" for x in obj["subpackets"]))
    print(f"PASS: independently rebuilt {len(out)} parallel 3x10-bit words -> {MEM.name}")

if __name__ == "__main__":
    main()
