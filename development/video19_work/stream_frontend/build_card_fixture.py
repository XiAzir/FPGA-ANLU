from __future__ import annotations

import hashlib
import json
import math
import shutil
import struct
from pathlib import Path


HERE = Path(__file__).resolve().parent
SECTOR = 512
IMAGE_BYTES = 512 * 1024 * 1024
TOTAL_SECTORS = IMAGE_BYTES // SECTOR
PART_START = 2048
VOL_SECTORS = TOTAL_SECTORS - PART_START
RESERVED = 32
FAT_COUNT = 2
FAT_SECTORS = 1024
SECTORS_PER_CLUSTER = 8
DATA_START_REL = RESERVED + FAT_COUNT * FAT_SECTORS
DATA_LBA = PART_START + DATA_START_REL
DATA_SECTORS = VOL_SECTORS - DATA_START_REL
FAT32_CLUSTERS = DATA_SECTORS // SECTORS_PER_CLUSTER
MJP_PATH = HERE / "output/VIDEO.MJP"
WAV_PATH = HERE / "output/TEST.WAV"
BMP_DIR = Path(
    "E:/QQ CACHE/Download/安路资料/赛题1_工作资料/05_补充参考工程/官方赛题1_康芯2026/"
    "lab_ex4_tf/doc/TF卡图片"
)
BMP_SOURCES = [
    ("00_APPLE.BMP", BMP_DIR / "苹果_640x480_24bit_显示正常_工程适配版.bmp"),
    ("01_BERRY.BMP", BMP_DIR / "草莓_640x480_24bit_显示正常_工程适配版.bmp"),
    ("02_MELON.BMP", BMP_DIR / "西瓜_640x480_24bit_显示正常_工程适配版.bmp"),
    ("03_ROSE.BMP", BMP_DIR / "A_工程适配版.bmp"),
]


def sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def put16(buf: bytearray, offset: int, value: int) -> None:
    struct.pack_into("<H", buf, offset, value)


def put32(buf: bytearray, offset: int, value: int) -> None:
    struct.pack_into("<I", buf, offset, value)


def short_name(name: str) -> tuple[bytes, bytes]:
    stem, ext = name.split(".", 1)
    stem_b = stem.encode("ascii")
    ext_b = ext.encode("ascii")
    if len(stem_b) > 8 or len(ext_b) != 3:
        raise ValueError(f"not an 8.3 name: {name}")
    return stem_b.ljust(8, b" "), ext_b


def directory_entry(name: str, cluster: int, size: int) -> bytes:
    stem, ext = short_name(name)
    item = bytearray(32)
    item[0:8] = stem
    item[8:11] = ext
    item[11] = 0x20
    put16(item, 20, (cluster >> 16) & 0xFFFF)
    put16(item, 26, cluster & 0xFFFF)
    put32(item, 28, size)
    return bytes(item)


def make_mbr() -> bytes:
    mbr = bytearray(SECTOR)
    partition = 446
    mbr[partition + 4] = 0x0C
    put32(mbr, partition + 8, PART_START)
    put32(mbr, partition + 12, VOL_SECTORS)
    mbr[510:512] = b"\x55\xaa"
    return bytes(mbr)


def make_vbr() -> bytes:
    vbr = bytearray(SECTOR)
    vbr[0:3] = b"\xeb\x58\x90"
    vbr[3:11] = b"MSDOS5.0"
    put16(vbr, 11, SECTOR)
    vbr[13] = SECTORS_PER_CLUSTER
    put16(vbr, 14, RESERVED)
    vbr[16] = FAT_COUNT
    put16(vbr, 17, 0)
    put16(vbr, 19, 0)
    vbr[21] = 0xF8
    put16(vbr, 22, 0)
    put16(vbr, 24, 63)
    put16(vbr, 26, 255)
    put32(vbr, 28, PART_START)
    put32(vbr, 32, VOL_SECTORS)
    put32(vbr, 36, FAT_SECTORS)
    put16(vbr, 40, 0)
    put16(vbr, 42, 0)
    put32(vbr, 44, 2)
    put16(vbr, 48, 1)
    put16(vbr, 50, 6)
    vbr[64] = 0x80
    vbr[66] = 0x29
    put32(vbr, 67, 0x26102119)
    vbr[71:82] = b"FPGA VIDEO "
    vbr[82:90] = b"FAT32   "
    vbr[510:512] = b"\x55\xaa"
    return bytes(vbr)


def make_fsinfo(allocated_clusters: int) -> bytes:
    info = bytearray(SECTOR)
    info[0:4] = b"RRaA"
    info[484:488] = b"rrAa"
    put32(info, 488, FAT32_CLUSTERS - allocated_clusters)
    put32(info, 492, 3)
    info[510:512] = b"\x55\xaa"
    return bytes(info)


def validate_bmp(name: str, bmp: bytes) -> None:
    if bmp[:2] != b"BM" or len(bmp) < 54:
        raise ValueError(f"invalid BMP signature: {name}")
    width, height = struct.unpack_from("<ii", bmp, 18)
    planes, depth = struct.unpack_from("<HH", bmp, 26)
    compression = struct.unpack_from("<I", bmp, 30)[0]
    if (width, abs(height), planes, depth, compression) != (640, 480, 1, 24, 0):
        raise ValueError(f"unexpected BMP geometry or format in {name}")


def pad_sectors(data: bytes) -> list[bytes]:
    sectors = []
    for start in range(0, len(data), SECTOR):
        sector = data[start:start + SECTOR]
        sectors.append(sector.ljust(SECTOR, b"\x00"))
    return sectors


def cluster_count(data_bytes: int) -> int:
    return math.ceil(data_bytes / (SECTOR * SECTORS_PER_CLUSTER))


def emit_card_mem(path: Path, sectors: dict[int, bytes]) -> None:
    with path.open("w", encoding="ascii", newline="\n") as stream:
        for lba in sorted(sectors):
            stream.write(f"@{lba * SECTOR:08x}\n")
            sector = sectors[lba]
            stream.writelines(f"{byte:02x}\n" for byte in sector)


def build() -> dict:
    if not MJP_PATH.is_file() or not WAV_PATH.is_file():
        raise FileNotFoundError("Run pack_video_mjp.py first to create VIDEO.MJP and TEST.WAV")
    video = MJP_PATH.read_bytes()
    wav = WAV_PATH.read_bytes()
    if len(video) % SECTOR or video[:4] != b"MJP1":
        raise ValueError("VIDEO.MJP must have the MJP1 header and sector alignment")
    if video[8:12] != struct.pack("<HH", 640, 480) or video[12:16] != struct.pack("<HH", 15, 1):
        raise ValueError("VIDEO.MJP header geometry/rate does not match 640x480 at 15fps")
    if int.from_bytes(video[16:20], "little") != 300:
        raise ValueError("VIDEO.MJP must contain 300 frames")
    if wav[:4] != b"RIFF" or wav[8:12] != b"WAVE":
        raise ValueError("TEST.WAV is not RIFF/WAVE")

    files: list[dict] = [{
        "name": "VIDEO.MJP", "data": video, "start_cluster": 4,
        "source_path": str(MJP_PATH), "source_sha256": sha(video),
    }]
    video_clusters = cluster_count(len(video))
    wav_start_cluster = 4 + video_clusters
    files.append({
        "name": "TEST.WAV", "data": wav, "start_cluster": wav_start_cluster,
        "source_path": str(WAV_PATH), "source_sha256": sha(wav),
    })
    next_cluster = wav_start_cluster + cluster_count(len(wav))
    for name, source in BMP_SOURCES:
        bmp = source.read_bytes()
        validate_bmp(name, bmp)
        file_clusters = cluster_count(len(bmp))
        files.append({
            "name": name, "data": bmp, "start_cluster": next_cluster,
            "source_path": str(source), "source_sha256": sha(bmp),
        })
        next_cluster += file_clusters

    allocated_file_clusters = next_cluster - 4
    if next_cluster >= FAT32_CLUSTERS + 2:
        raise ValueError("allocated files exceed FAT32 data clusters")

    image: dict[int, bytes] = {}

    def put_sector(lba: int, data: bytes) -> None:
        if len(data) != SECTOR:
            raise ValueError(f"LBA {lba} has {len(data)} bytes")
        image[lba] = data

    put_sector(0, make_mbr())
    vbr = make_vbr()
    put_sector(PART_START, vbr)
    put_sector(PART_START + 6, vbr)
    fsinfo = make_fsinfo(allocated_file_clusters + 1)
    put_sector(PART_START + 1, fsinfo)
    put_sector(PART_START + 7, fsinfo)

    fat = bytearray(FAT_SECTORS * SECTOR)
    put32(fat, 0, 0x0FFFFFF8)
    put32(fat, 4, 0x0FFFFFFF)
    put32(fat, 2 * 4, 0x0FFFFFFF)
    for item in files:
        data = item["data"]
        file_cluster_count = cluster_count(len(data))
        first = item["start_cluster"]
        for offset in range(file_cluster_count):
            cluster = first + offset
            following = (cluster + 1) if offset + 1 < file_cluster_count else 0x0FFFFFFF
            put32(fat, cluster * 4, following)

    for copy in range(FAT_COUNT):
        base = PART_START + RESERVED + copy * FAT_SECTORS
        for sector_index in range(FAT_SECTORS):
            start = sector_index * SECTOR
            put_sector(base + sector_index, bytes(fat[start:start + SECTOR]))

    root = bytearray(SECTOR)
    for index, item in enumerate(files):
        root[index * 32:(index + 1) * 32] = directory_entry(
            item["name"], item["start_cluster"], len(item["data"])
        )
    root[len(files) * 32] = 0
    put_sector(DATA_LBA, bytes(root))

    for item in files:
        start_cluster = item["start_cluster"]
        padded = item["data"].ljust(cluster_count(len(item["data"])) * SECTORS_PER_CLUSTER * SECTOR, b"\x00")
        sectors = pad_sectors(padded)
        for offset, sector in enumerate(sectors):
            cluster = start_cluster + offset // SECTORS_PER_CLUSTER
            lba = DATA_LBA + (cluster - 2) * SECTORS_PER_CLUSTER + offset % SECTORS_PER_CLUSTER
            put_sector(lba, sector)
        item["sector_count"] = math.ceil(len(item["data"]) / SECTOR)
        item["allocated_sector_count"] = len(sectors)
        item["cluster_count"] = cluster_count(len(item["data"]))
        item["start_lba"] = DATA_LBA + (start_cluster - 2) * SECTORS_PER_CLUSTER
        item["end_lba"] = item["start_lba"] + item["sector_count"] - 1
        item["allocated_end_lba"] = item["start_lba"] + item["allocated_sector_count"] - 1
        item["end_cluster"] = start_cluster + item["cluster_count"] - 1
        item["sha256"] = sha(item["data"])

    out_dir = HERE / "card_image"
    golden_dir = out_dir / "golden"
    out_dir.mkdir(parents=True, exist_ok=True)
    golden_dir.mkdir(parents=True, exist_ok=True)
    for item in files:
        shutil.copyfile(item["source_path"], golden_dir / item["name"])

    card_path = out_dir / "card.mem"
    packed_path = out_dir / "packed_mem.mem"
    lba_path = out_dir / "lba_map.mem"
    emit_card_mem(card_path, image)
    with packed_path.open("w", encoding="ascii", newline="\n") as packed, \
            lba_path.open("w", encoding="ascii", newline="\n") as lba_map:
        for lba in sorted(image):
            packed.write(image[lba].hex() + "\n")
            lba_map.write(f"{lba:08x}\n")

    manifest_files = []
    for item in files:
        manifest_files.append({
            key: item[key] for key in (
                "name", "bytes", "sha256", "source_path", "source_sha256",
                "start_cluster", "end_cluster", "cluster_count", "sector_count",
                "allocated_sector_count", "start_lba", "end_lba", "allocated_end_lba"
            ) if key in item
        })
        manifest_files[-1]["bytes"] = len(item["data"])
        manifest_files[-1]["golden_path"] = str(golden_dir / item["name"])

    manifest = {
        "format": "FAT32 MBR, SDHC 512MiB, 512-byte sectors, eight sectors per cluster",
        "image_bytes": IMAGE_BYTES,
        "total_sectors": TOTAL_SECTORS,
        "partition_start_lba": PART_START,
        "partition_sectors": VOL_SECTORS,
        "sectors_per_cluster": SECTORS_PER_CLUSTER,
        "reserved_sectors": RESERVED,
        "fat_count": FAT_COUNT,
        "fat_sectors_per_copy": FAT_SECTORS,
        "fat32_data_clusters": FAT32_CLUSTERS,
        "root_cluster": 2,
        "root_directory_lba": DATA_LBA,
        "populated_sectors": len(image),
        "files": manifest_files,
        "sector_lba_map": {
            "mbr": 0,
            "vbr": PART_START,
            "root_directory": DATA_LBA,
            "video_first": files[0]["start_lba"],
            "video_last": files[0]["end_lba"],
            "wav_first": files[1]["start_lba"],
            "wav_last": files[1]["end_lba"],
            "bmp_files": [
                {"name": item["name"], "first": item["start_lba"], "last": item["end_lba"]}
                for item in files[2:]
            ],
            "fat1_first": PART_START + RESERVED,
            "fat1_last": PART_START + RESERVED + FAT_SECTORS - 1,
            "fat2_first": PART_START + RESERVED + FAT_SECTORS,
            "fat2_last": PART_START + RESERVED + 2 * FAT_SECTORS - 1,
        },
        "hashes": {
            "card.mem": sha(card_path.read_bytes()),
            "packed_mem.mem": sha(packed_path.read_bytes()),
            "lba_map.mem": sha(lba_path.read_bytes()),
        },
    }
    manifest_path = out_dir / "manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    summary = dict(manifest)
    summary["mapped_sectors"] = len(image)
    summary["image_hex_file"] = str(card_path)
    summary["packed_sector_file"] = str(packed_path)
    summary["lba_map_file"] = str(lba_path)
    summary["manifest_file"] = str(manifest_path)
    (out_dir / "summary.json").write_text(
        json.dumps(summary, indent=2, ensure_ascii=False) + "\n", encoding="utf-8"
    )
    print(json.dumps(manifest, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    build()
