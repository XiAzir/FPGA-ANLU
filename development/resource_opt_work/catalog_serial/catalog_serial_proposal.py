"""Apply one 36-bit shared add/sub ALU to an isolated mapper catalog source."""

from __future__ import annotations

from pathlib import Path


def apply(hdl_path: str | Path) -> None:
    path = Path(hdl_path)
    source = path.read_text(encoding="utf-8-sig")
    original = source

    def sub(old: str, new: str, what: str) -> None:
        nonlocal source
        count = source.count(old)
        if count != 1:
            raise ValueError(f"{path}: expected one {what}, found {count}")
        source = source.replace(old, new, 1)

    sub("S_BPB_PREP0=12, S_BPB_PREP1=13,\n           S_BPB_PREP2=14, S_BPB_CHECK=15;",
        "S_BPB_PREP0=12, S_BPB_CHECK=15;", "prep state declarations")
    sub("wire [32:0] volume_end_p0 = {1'b0,(is_mbr?chosen_start:32'd0)}+{1'b0,total32};\n"
        "wire [32:0] partition_end_p0 = {1'b0,chosen_start}+{1'b0,chosen_size};",
        "reg volume_end_overflow, partition_end_overflow;\nreg [3:0] bpb_step;",
        "parallel volume and partition adders")
    sub("wire [33:0] data_sector_count_p1 = {2'b0,total32}-fat_area_end_p0;\n"
        "wire [32:0] fat_lba_base_p1 = {1'b0,(is_mbr?chosen_start:32'd0)}+{17'd0,reserved_hi,reserved_lo};",
        "", "parallel data-sector and FAT-base adders")
    sub("reg [33:0] data_lba_p1, cluster_count_p2, fat_lba_p2;\nreg [35:0] root_lba_p2;",
        "reg [33:0] data_lba_p1, cluster_count_p2, fat_lba_p2;\n"
        "reg [35:0] root_lba_p2;\n"
        "reg [35:0] geom_alu_a, geom_alu_b;\n"
        "reg geom_alu_sub;\n"
        "wire [35:0] geom_alu_result = geom_alu_a + (geom_alu_b ^ {36{geom_alu_sub}}) + geom_alu_sub;",
        "geometry ALU declarations")
    sub("wire [34:0] root_sector_offset = {7'd0,root_cluster_minus_two} << spc_shift_calc;",
        "wire [34:0] root_sector_offset = {7'd0,root_cluster_minus_two} << spc_shift_calc;\n"
        "always @* begin\n"
        "  geom_alu_a=0; geom_alu_b=0; geom_alu_sub=0;\n"
        "  case (bpb_step)\n"
        "    0: begin geom_alu_a={4'd0,reserved32}; geom_alu_b={3'd0,fat_span}; end\n"
        "    1: begin geom_alu_a={4'd0,(is_mbr?chosen_start:32'd0)}; geom_alu_b={4'd0,total32}; end\n"
        "    2: begin geom_alu_a={4'd0,chosen_start}; geom_alu_b={4'd0,chosen_size}; end\n"
        "    3: begin geom_alu_a={4'd0,total32}; geom_alu_b={2'd0,fat_area_end_p0}; geom_alu_sub=1; end\n"
        "    4: begin geom_alu_a={4'd0,(is_mbr?chosen_start:32'd0)}; geom_alu_b={4'd0,reserved32}; end\n"
        "    5: begin geom_alu_a={2'd0,fat_lba_p2}; geom_alu_b={4'd0,active_fat_offset_p0}; end\n"
        "    6: begin geom_alu_a={2'd0,(is_mbr?chosen_start:32'd0)}; geom_alu_b={2'd0,fat_area_end_p0}; end\n"
        "    7: begin geom_alu_a={2'd0,data_lba_p1}; geom_alu_b={1'd0,root_sector_offset}; end\n"
        "    default: begin end\n"
        "  endcase\n"
        "end",
        "geometry ALU operand mux")
    sub("   fat_area_end_p0<=0;\n   data_lba_p1<=0; cluster_count_p2<=0; fat_lba_p2<=0; root_lba_p2<=0;",
        "   fat_area_end_p0<=0; volume_end_overflow<=0; partition_end_overflow<=0; bpb_step<=0;\n"
        "   data_lba_p1<=0; cluster_count_p2<=0; fat_lba_p2<=0; root_lba_p2<=0;",
        "geometry reset assignments")
    old_prep = (
        "   S_GAP_BOOT: if(gap_count!=0) gap_count<=gap_count-1'b1; else if(signature_lo!=8'h55 || signature_hi!=8'haa) fail(E_SECTOR); else state<=S_BPB_PREP0;\n"
        "   // Spread BPB geometry over several clocks. This keeps wide adds and the\n"
        "   // cluster-count comparison out of the sector-end control path.\n"
        "   S_BPB_PREP0: begin\n"
        "     fat_area_end_p0<={18'd0,reserved_hi,reserved_lo}+{1'b0,fat_span};\n"
        "     state<=S_BPB_PREP1;\n"
        "   end\n"
        "   S_BPB_PREP1: begin\n"
        "     data_lba_p1<={2'b0,(is_mbr?chosen_start:32'd0)}+fat_area_end_p0;\n"
        "     state<=S_BPB_PREP2;\n"
        "   end\n"
        "   S_BPB_PREP2: begin\n"
        "     cluster_count_p2<=data_sector_count_p1>>spc_shift_calc;\n"
        "     fat_lba_p2<=fat_lba_base_p1+active_fat_offset_p0;\n"
        "     root_lba_p2<={2'b0,data_lba_p1}+{1'b0,root_sector_offset};\n"
        "     state<=S_BPB_CHECK;\n"
        "   end\n"
    )
    new_prep = (
        "   S_GAP_BOOT: if(gap_count!=0) gap_count<=gap_count-1'b1; else if(signature_lo!=8'h55 || signature_hi!=8'haa) fail(E_SECTOR); else begin bpb_step<=0; state<=S_BPB_PREP0; end\n"
        "   // A single 36-bit add/sub ALU computes geometry over eight clocks.\n"
        "   S_BPB_PREP0: begin\n"
        "     case (bpb_step)\n"
        "       0: fat_area_end_p0<=geom_alu_result[33:0];\n"
        "       1: volume_end_overflow<=geom_alu_result[32] && (|geom_alu_result[31:0]);\n"
        "       2: partition_end_overflow<=geom_alu_result[32] && (|geom_alu_result[31:0]);\n"
        "       3: cluster_count_p2<=geom_alu_result[33:0];\n"
        "       4: begin cluster_count_p2<=cluster_count_p2>>spc_shift_calc; fat_lba_p2<=geom_alu_result[32:0]; end\n"
        "       5: fat_lba_p2<=geom_alu_result[33:0];\n"
        "       6: data_lba_p1<=geom_alu_result[33:0];\n"
        "       7: root_lba_p2<=geom_alu_result;\n"
        "       default: begin end\n"
        "     endcase\n"
        "     if(bpb_step==7) begin bpb_step<=0; state<=S_BPB_CHECK; end\n"
        "     else bpb_step<=bpb_step+1'b1;\n"
        "   end\n"
    )
    sub(old_prep, new_prep, "BPB prep state schedule")
    sub("else if(volume_end_p0>64'h0000000100000000 || (is_mbr && partition_end_p0>64'h0000000100000000)) fail(E_RANGE);",
        "else if(volume_end_overflow || (is_mbr && partition_end_overflow)) fail(E_RANGE);",
        "range overflow predicates")

    if source == original:
        raise AssertionError("no shared-ALU changes applied")
    path.write_text(source, encoding="utf-8", newline="")


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("hdl_path")
    apply(parser.parse_args().hdl_path)
