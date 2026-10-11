"""Build a sparse sector-level replay fixture from the read-only card snapshot.

Only physical LBA 0 is synthetic: the host denied a physical-drive read, so this
is a partition-table wrapper around the captured volume beginning at LBA 32.
Every other fixture byte comes from actual_card_readonly/volume_first17000_sectors.bin.
"""
import argparse
import hashlib
import json
import struct
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CAPTURE_DIR = ROOT / "build" / "actual_card_readonly"
SECTOR_SIZE = 512
PARTITION_LBA = 32
IMAGE_HASHES = {
    "00_APPLEBMP": "31A508B43BC3EC44F5814382A6DD12B5F379CA248B633120C25F1A6BF85239E1",
    "01_BERRYBMP": "A51B868D9E1C08CE599095A9A40048174CD35CE1C6EA3C74E370D3E6A6D87C2E",
    "02_MELONBMP": "BC7170E5C0D33B07C7F7A1622CD7A58084C2E4C7478D11B5ED29EE4BA8EC4297",
    "03_A    BMP": "78C9692B7C47AF62E82220BA294E71548507DA16990AA04F7C3DD58987B3CA06",
}
WAV_HASH = "B29C1669416DA2C492187A9DB66E0E97BFCD2E6FA9812B33ED300C1C21CA80A7"


def le16(buf, off):
    return struct.unpack_from("<H", buf, off)[0]


def le32(buf, off):
    return struct.unpack_from("<I", buf, off)[0]


def parse_wav_data_offset(wav):
    if wav[:4] != b"RIFF" or wav[8:12] != b"WAVE":
        raise ValueError("captured WAV is not RIFF/WAVE")
    end = min(len(wav), 8 + le32(wav, 4))
    pos = 12
    while pos + 8 <= end:
        ident = wav[pos:pos + 4]
        size = le32(wav, pos + 4)
        payload = pos + 8
        if payload + size > end:
            raise ValueError(f"WAV chunk {ident!r} escapes RIFF bounds")
        if ident == b"data":
            if size == 0 or size & 1:
                raise ValueError("WAV data length must be positive and PCM16 aligned")
            return payload, size
        pos = payload + size + (size & 1)
    raise ValueError("WAV data chunk not found")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--output", type=Path, default=ROOT / "build" / "actual_card_replay")
    args = ap.parse_args()
    out = args.output.resolve()
    out.mkdir(parents=True, exist_ok=True)

    capture = (CAPTURE_DIR / "volume_first17000_sectors.bin").read_bytes()
    parsed = json.loads((CAPTURE_DIR / "parsed.json").read_text(encoding="utf-8"))
    if len(capture) != 17000 * SECTOR_SIZE:
        raise ValueError(f"unexpected snapshot size: {len(capture)}")
    geo = parsed["geometry"]
    spc = geo["spc"]
    if spc != 64 or geo["partition_lba"] != PARTITION_LBA:
        raise ValueError(f"fixture expects captured SPC64/partition32 geometry, got {geo}")

    def captured_sector(physical_lba):
        volume_lba = physical_lba - PARTITION_LBA
        if volume_lba < 0 or volume_lba >= len(capture) // SECTOR_SIZE:
            raise ValueError(f"LBA {physical_lba} is outside the captured volume")
        start = volume_lba * SECTOR_SIZE
        return capture[start:start + SECTOR_SIZE]

    entries = {entry["name"]: entry for entry in parsed["entries"]}
    image_names = list(IMAGE_HASHES)
    wav_entry = entries["TEST    WAV"]
    selected = {0}  # the synthetic, unavailable physical MBR
    selected.add(PARTITION_LBA)  # actual captured VBR

    # Include real active-FAT sectors used by root and file-chain lookups and
    # the first root-directory sector. All included non-MBR bytes are captured.
    fat0 = PARTITION_LBA + geo["reserved"]
    root_lba = PARTITION_LBA + geo["data_lba_volume"]
    selected.update((fat0, fat0 + 1, root_lba))

    expected_pixels = []
    extracted = {}
    for name in image_names + ["TEST    WAV"]:
        entry = entries[name]
        chain = entry["chain"]
        if any(chain[i + 1] != chain[i] + 1 for i in range(len(chain) - 1)):
            raise ValueError(f"captured chain for {name!r} is not contiguous")
        first_lba = entry["lba"]
        size = entry["size"]
        count = (size + SECTOR_SIZE - 1) // SECTOR_SIZE
        file_bytes = bytearray()
        for n in range(count):
            lba = first_lba + n
            data = captured_sector(lba)
            selected.add(lba)
            file_bytes.extend(data)
        file_bytes = bytes(file_bytes[:size])
        digest = hashlib.sha256(file_bytes).hexdigest().upper()
        expected_digest = WAV_HASH if name == "TEST    WAV" else IMAGE_HASHES[name]
        if digest != expected_digest or entry["sha256"].upper() != expected_digest:
            raise ValueError(f"captured {name!r} hash mismatch: {digest}")
        extracted[name] = file_bytes

        if name != "TEST    WAV":
            if (file_bytes[:2] != b"BM" or le32(file_bytes, 10) != 54 or
                    le32(file_bytes, 14) != 40 or le32(file_bytes, 18) != 640 or
                    le32(file_bytes, 22) != 480 or le16(file_bytes, 26) != 1 or
                    le16(file_bytes, 28) != 24 or le32(file_bytes, 30) != 0):
                raise ValueError(f"captured BMP {name!r} has unexpected header")
            pixel_bytes = file_bytes[54:54 + 640 * 480 * 3]
            if len(pixel_bytes) != 640 * 480 * 3:
                raise ValueError(f"captured BMP {name!r} pixel data is truncated")
            for pos in range(0, len(pixel_bytes), 3):
                blue, green, red = pixel_bytes[pos:pos + 3]
                expected_pixels.append((red << 16) | (green << 8) | blue)

    wav = extracted["TEST    WAV"]
    data_offset, data_len = parse_wav_data_offset(wav)
    if data_offset != 44 or data_len != 768000:
        raise ValueError(f"expected captured WAV PCM at byte 44/384000 samples, got {data_offset}/{data_len}")
    samples = struct.unpack_from("<384000H", wav, data_offset)

    # Synthetic MBR contains no captured-volume bytes and points at captured LBA32.
    mbr = bytearray(SECTOR_SIZE)
    mbr[0:16] = bytes.fromhex("33c08ed0bc007c8ec08ed8be007cbf00")
    mbr[446 + 4] = 0x0C
    struct.pack_into("<I", mbr, 446 + 8, PARTITION_LBA)
    struct.pack_into("<I", mbr, 446 + 12, geo["total_sectors"])
    mbr[510:512] = b"\x55\xaa"
    sectors = {0: bytes(mbr)}
    for lba in sorted(selected - {0}):
        sectors[lba] = captured_sector(lba)

    (out / "lbas.hex").write_text("\n".join(f"{lba:08x}" for lba in sectors) + "\n", encoding="ascii")
    (out / "sectors.hex").write_text(
        "\n".join(f"{byte:02x}" for data in sectors.values() for byte in data) + "\n",
        encoding="ascii")
    (out / "pixels.hex").write_text("\n".join(f"{value:06x}" for value in expected_pixels) + "\n", encoding="ascii")
    (out / "samples.hex").write_text("\n".join(f"{value:04x}" for value in samples) + "\n", encoding="ascii")
    (out / "config.vh").write_text(f"`define FIXTURE_SECTORS {len(sectors)}\n", encoding="ascii")
    report = {
        "source": str(CAPTURE_DIR / "volume_first17000_sectors.bin"),
        "physical_lba0": "synthetic MBR only; actual MBR was not captured",
        "partition_lba": PARTITION_LBA,
        "captured_spc": spc,
        "captured_non_mbr_sectors": len(sectors) - 1,
        "file_sha256": {name: hashlib.sha256(data).hexdigest().upper() for name, data in extracted.items()},
        "bmp_expected_pixels": len(expected_pixels),
        "wav_data_offset": data_offset,
        "wav_expected_samples": len(samples),
        "synthetic_sector_lbas": [0],
    }
    (out / "fixture_report.json").write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(f"Actual-card fixture: SPC={spc}, {len(sectors)} sparse sectors "
          f"({len(sectors)-1} captured + synthetic MBR), 4x480p BMP, "
          f"WAV {len(samples)} samples; all five extracted SHA256 hashes verified")


if __name__ == "__main__":
    main()
