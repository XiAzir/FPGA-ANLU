"""Prepare isolated reference and aligned-OR mapper simulation copies."""

from __future__ import annotations

import sys
from pathlib import Path

from mapper_aligned_proposal import apply


def rename_module(path: Path, module_name: str) -> None:
    text = path.read_text(encoding="utf-8-sig")
    renamed = text.replace(
        "module fat32_file_sector #(", f"module {module_name} #(", 1
    )
    if renamed == text:
        raise ValueError(f"could not rename module in {path}")
    path.write_text(renamed, encoding="utf-8")


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit("usage: prepare_mapper_aligned.py SOURCE.v BUILD_DIR")
    source = Path(sys.argv[1])
    build = Path(sys.argv[2])
    build.mkdir(parents=True, exist_ok=True)
    reference = build / "fat32_file_sector_reference.v"
    aligned = build / "fat32_file_sector_aligned.v"
    reference.write_text(source.read_text(encoding="utf-8-sig"), encoding="utf-8")
    aligned.write_text(source.read_text(encoding="utf-8-sig"), encoding="utf-8")
    apply(aligned)
    rename_module(reference, "fat32_file_sector_reference")
    rename_module(aligned, "fat32_file_sector_aligned")
    for template, top in (
        ("tb_mapper_edges.v", "tb_mapper_aligned_edges"),
        ("tb_mapper_long_equiv.v", "tb_mapper_aligned_long"),
    ):
        text = (Path(__file__).parent / template).read_text(encoding="utf-8-sig")
        old_top = "tb_mapper_edges" if "edges" in template else "tb_mapper_long_equiv"
        text = text.replace(f"module {old_top};", f"module {top};", 1)
        text = text.replace(
            "fat32_file_sector_proposal #(", "fat32_file_sector_aligned #("
        )
        (build / f"{top}.v").write_text(text, encoding="utf-8")
    print(f"Prepared reference and aligned-OR copies under {build.resolve()}")


if __name__ == "__main__":
    main()
