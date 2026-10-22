from pathlib import Path
import hashlib
import json

ROOT = Path(__file__).resolve().parent
SRC = ROOT / "src_v" / "mjp_file_reader.v"
BASELINE = ROOT / "src_v" / "mjp_file_reader_reference.v"

text = SRC.read_text(encoding="utf-8")
BASELINE.write_text(text.replace("module mjp_file_reader (", "module mjp_file_reader_reference (", 1), encoding="utf-8")

text = text.replace("reg [31:0] total_frames;", "reg [8:0] total_frames;")
text = text.replace("reg [31:0] header_frame_index;", "reg [8:0] header_frame_index;")
text = text.replace("            total_frames <= 32'd0;", "            total_frames <= 9'd0;")
text = text.replace("            header_frame_index <= 32'd0;", "            header_frame_index <= 9'd0;")
text = text.replace("""                            if (sector_write_count >= 10'd16 && sector_write_count <= 10'd19)
                                total_frames[(sector_write_count-10'd16)*8 +: 8] <= card_data;""", """                            if (sector_write_count == 10'd16)
                                total_frames[7:0] <= card_data;
                            else if (sector_write_count == 10'd17)
                                total_frames[8] <= card_data[0];""")
text = text.replace("""                            if (sector_write_count >= 10'd8 && sector_write_count <= 10'd11)
                                header_frame_index[(sector_write_count-10'd8)*8 +: 8] <= card_data;""", """                            if (sector_write_count == 10'd8)
                                header_frame_index[7:0] <= card_data;
                            else if (sector_write_count == 10'd9)
                                header_frame_index[8] <= card_data[0];""")
text = text.replace("last_index <= total_frames[8:0] - 9'd1;", "last_index <= total_frames - 9'd1;")
text = text.replace("frame_index <= header_frame_index[8:0];", "frame_index <= header_frame_index;")
SRC.write_text(text, encoding="utf-8")

receipt = {
    "baseline_sha256": hashlib.sha256(BASELINE.read_bytes()).hexdigest(),
    "candidate_sha256": hashlib.sha256(SRC.read_bytes()).hexdigest(),
    "changed_file": str(SRC.relative_to(ROOT)),
    "changes": ["total_frames 32->9 bits and fixed byte decode", "header_frame_index 32->9 bits and fixed byte decode"],
}
(ROOT / "reader_manifest.json").write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")
print(json.dumps(receipt, indent=2))
