from pathlib import Path
import sys

def apply(hdl):
    p=Path(hdl)/'fat32_catalog.v'
    s=p.read_text(encoding='utf-8-sig')
    changes={
      'reg [3:0] spc_shift_calc;':'reg [2:0] spc_shift_calc;',
      'reg [63:0] fat_area_end_p0, fat_capacity_p0, volume_end_p0, partition_end_p0;':'''// Exact bounds of sums from raw BPB bytes (including malformed BPBs).
reg [33:0] fat_area_end_p0;
reg [38:0] fat_capacity_p0;
reg [32:0] volume_end_p0, partition_end_p0;''',
      'reg [63:0] active_fat_offset_p0, data_sector_count_p1, fat_lba_base_p1;':'''reg [31:0] active_fat_offset_p0;
reg [33:0] data_sector_count_p1;
reg [32:0] fat_lba_base_p1;''',
      'reg [63:0] data_lba_p1, cluster_count_p2, fat_lba_p2, root_lba_p2;':'''reg [33:0] data_lba_p1, cluster_count_p2, fat_lba_p2;
reg [35:0] root_lba_p2;''',
      "wire [63:0] fat_span = (fats==2) ? {31'd0,fatsz32,1'b0} : {32'd0,fatsz32};":'''wire [32:0] fat_span = (fats==2) ? {fatsz32,1'b0} : {1'b0,fatsz32};
// Invalid subtraction inputs are rejected by fat_area_end_p0>=total32 or
// root_cluster_masked<2 before any truncated value reaches an output.
wire [27:0] root_cluster_minus_two = root_cluster_masked[27:0]-28'd2;
wire [34:0] root_sector_offset = {7'd0,root_cluster_minus_two} << spc_shift_calc;
// MBR bytes 446..509: two partition-index bits and two byte-lane bits.
wire [5:0] partition_byte = byte_index[5:0]-6'd62;''',
      "fat_area_end_p0<={32'd0,reserved32}+fat_span;":"fat_area_end_p0<={18'd0,reserved_hi,reserved_lo}+{1'b0,fat_span};",
      "fat_capacity_p0<={32'd0,fatsz32}<<7;":"fat_capacity_p0<={fatsz32,7'd0};",
      "volume_end_p0<={32'd0,(is_mbr?chosen_start:32'd0)}+{32'd0,total32};":"volume_end_p0<={1'b0,(is_mbr?chosen_start:32'd0)}+{1'b0,total32};",
      "partition_end_p0<={32'd0,chosen_start}+{32'd0,chosen_size};":"partition_end_p0<={1'b0,chosen_start}+{1'b0,chosen_size};",
      "?{32'd0,fatsz32}:64'd0;":"?fatsz32:32'd0;",
      "data_sector_count_p1<={32'd0,total32}-fat_area_end_p0;":"data_sector_count_p1<={2'b0,total32}-fat_area_end_p0;",
      "fat_lba_base_p1<={32'd0,(is_mbr?chosen_start:32'd0)}+reserved32;":"fat_lba_base_p1<={1'b0,(is_mbr?chosen_start:32'd0)}+{17'd0,reserved_hi,reserved_lo};",
      "data_lba_p1<={32'd0,(is_mbr?chosen_start:32'd0)}+fat_area_end_p0;":"data_lba_p1<={2'b0,(is_mbr?chosen_start:32'd0)}+fat_area_end_p0;",
      "root_lba_p2<=data_lba_p1+(({32'd0,root_cluster_masked}-64'd2)<<spc_shift_calc);":"root_lba_p2<={2'b0,data_lba_p1}+{1'b0,root_sector_offset};",
      '''                 part_index <= (byte_index-446)/16;
                 if(((byte_index-446)%16)==4) part_type[(byte_index-446)/16]<=sd_data;
                 if(((byte_index-446)%16)>=8 && ((byte_index-446)%16)<=11) part_start[(byte_index-446)/16][(((byte_index-446)%16)-8)*8 +: 8]<=sd_data;
                 if(((byte_index-446)%16)>=12 && ((byte_index-446)%16)<=15) part_size[(byte_index-446)/16][(((byte_index-446)%16)-12)*8 +: 8]<=sd_data;''':'''                 part_index <= partition_byte[5:4];
                 if(partition_byte[3:0]==4) part_type[partition_byte[5:4]]<=sd_data;
                 if(partition_byte[3:2]==2) part_start[partition_byte[5:4]][{partition_byte[1:0],3'b000} +: 8]<=sd_data;
                 if(partition_byte[3:2]==3) part_size[partition_byte[5:4]][{partition_byte[1:0],3'b000} +: 8]<=sd_data;''',
      'if(byte_index>=fat_offset && byte_index<fat_offset+4) fat_entry_value[(byte_index-fat_offset)*8 +: 8]<=sd_data;':'''if(byte_index[9:2]=={1'b0,fat_offset[8:2]})
              fat_entry_value[{byte_index[1:0],3'b000} +: 8]<=sd_data;''',
    }
    for a,b in changes.items():
        assert s.count(a)==1,(a,s.count(a))
        s=s.replace(a,b)
    p.write_text(s,encoding='utf-8')

if __name__=='__main__': apply(sys.argv[1])
