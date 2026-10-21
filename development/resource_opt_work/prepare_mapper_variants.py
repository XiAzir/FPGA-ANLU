"""Create isolated RTL copies for mapper proposal ablation simulations."""

from __future__ import annotations

import sys
from pathlib import Path

from mapper_proposal import apply


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit("usage: prepare_mapper_variants.py SOURCE.v BUILD_DIR")
    source_path = Path(sys.argv[1])
    build = Path(sys.argv[2])
    build.mkdir(parents=True, exist_ok=True)
    source = source_path.read_text(encoding="utf-8-sig")

    ref = build / "fat32_file_sector_reference.v"
    ref_text = source.replace(
        "module fat32_file_sector #(", "module fat32_file_sector_reference #(", 1
    )
    if ref_text == source:
        raise ValueError("source module declaration was not found")
    ref.write_text(ref_text, encoding="utf-8")

    variants = {
        "algorithm": dict(algorithm=True, address=False, index=False),
        "address": dict(algorithm=False, address=True, index=False),
        "index": dict(algorithm=False, address=False, index=True),
        "combined": dict(algorithm=True, address=True, index=True),
    }
    for name, options in variants.items():
        candidate = build / f"fat32_file_sector_{name}.v"
        candidate.write_text(source, encoding="utf-8")
        apply(candidate, **options)
        text = candidate.read_text(encoding="utf-8")
        renamed = text.replace(
            "module fat32_file_sector #(",
            f"module fat32_file_sector_{name} #(",
            1,
        )
        if renamed == text:
            raise ValueError(f"could not rename {name} mapper")
        candidate.write_text(renamed, encoding="utf-8")
    print("Prepared isolated variants: algorithm, address, index, combined")


if __name__ == "__main__":
    main()
