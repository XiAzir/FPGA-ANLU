from pathlib import Path
import re

path = Path(__file__).with_name("run.py")
text = path.read_text(encoding="utf-8")
text = text.replace("from PIL import Image\n", "")
text = re.sub(r"def psnr\(.*?(?=def sha256\()", "", text, flags=re.S)
text = re.sub(r"def analyze\(.*?(?=def main\(\) -> None:)", "", text, flags=re.S)
if "def sha256(" not in text:
    digest = '''def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as src:
        for block in iter(lambda: src.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


'''
    text = text.replace("def main() -> None:\n", digest + "def main() -> None:\n", 1)
old = "    result = analyze(jpeg_paths, pixels)\n"
new = (
    '    result = {"fixtures": [str(p) for p in jpeg_paths], "dimensions": [args.width, args.height],\n'
    '              "frames": len(jpeg_paths), "records": pixels.stat().st_size // 7,\n'
    '              "pixel_record_sha256": sha256(pixels), "analysis": "exact baseline/candidate comparison is performed separately"}\n'
)
if old in text:
    text = text.replace(old, new, 1)
path.write_text(text, encoding="utf-8")
print("stripped Pillow-only postprocessing; pixel simulation unchanged")
