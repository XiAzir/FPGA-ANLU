from pathlib import Path
import sys

def apply(hdl):
    p=Path(hdl)/'fat32_catalog.v';s=p.read_text(encoding='utf-8-sig')
    def rep(a,b):
        nonlocal s
        assert s.count(a)==1,(a,s.count(a))
        s=s.replace(a,b)
    # All BPB input bytes stay unchanged throughout PREP0..CHECK. These
    # registers only copy stable values; remove their unnecessary storage.
    rep('reg [38:0] fat_capacity_p0;',"wire [38:0] fat_capacity_p0 = {fatsz32,7'd0};")
    rep('reg [32:0] volume_end_p0, partition_end_p0;',"""wire [32:0] volume_end_p0 = {1'b0,(is_mbr?chosen_start:32'd0)}+{1'b0,total32};
wire [32:0] partition_end_p0 = {1'b0,chosen_start}+{1'b0,chosen_size};""")
    rep('reg [31:0] active_fat_offset_p0;',"""wire [31:0] active_fat_offset_p0 =
    ((extflags&16'h0080)!=0 && (extflags&16'h000f)==1)?fatsz32:32'd0;""")
    rep('reg [33:0] data_sector_count_p1;',"wire [33:0] data_sector_count_p1 = {2'b0,total32}-fat_area_end_p0;")
    rep('reg [32:0] fat_lba_base_p1;',"wire [32:0] fat_lba_base_p1 = {1'b0,(is_mbr?chosen_start:32'd0)}+{17'd0,reserved_hi,reserved_lo};")
    rep('   fat_area_end_p0<=0; fat_capacity_p0<=0; volume_end_p0<=0; partition_end_p0<=0;', '   fat_area_end_p0<=0;')
    rep('   active_fat_offset_p0<=0; data_sector_count_p1<=0; fat_lba_base_p1<=0;\n','')
    for line in [
      "     fat_capacity_p0<={fatsz32,7'd0};\n",
      "     volume_end_p0<={1'b0,(is_mbr?chosen_start:32'd0)}+{1'b0,total32};\n",
      "     partition_end_p0<={1'b0,chosen_start}+{1'b0,chosen_size};\n",
      "     active_fat_offset_p0<=((extflags&16'h0080)!=0 && (extflags&16'h000f)==1)?fatsz32:32'd0;\n",
      "     data_sector_count_p1<={2'b0,total32}-fat_area_end_p0;\n",
      "     fat_lba_base_p1<={1'b0,(is_mbr?chosen_start:32'd0)}+{17'd0,reserved_hi,reserved_lo};\n",
    ]: rep(line,'')
    rep('reg [31:0] wait_count;', 'reg [$clog2(SECTOR_TIMEOUT_CYCLES+1)-1:0] wait_count;')
    rep('reg [31:0] root_clusters_read;', 'reg [$clog2(MAX_ROOT_CLUSTERS+2)-1:0] root_clusters_read;')
    rep('reg [9:0] sectors_seen;\n','')
    rep('byte_index<=0; sectors_seen<=0;', 'byte_index<=0;')
    rep('         sectors_seen<=sectors_seen+1\'b1;\n','')
    rep('if(sectors_seen!=512 || sd_valid || byte_index!=512)', 'if(sd_valid || byte_index!=512)')
    # Delete states/fields that are never read by the production logic.
    for line in [
      'reg [7:0] mbr_tmp[0:3];\n','reg [1:0] part_index;\n',
      'reg [31:0] reserved_sectors, fat_count;\n', 'reg [1:0] fat_value_byte;\n',
      'reg [5:0] dir_byte;\n','reg [31:0] dir_cluster, dir_size;\n',
      'reg [31:0] max_cluster;\n',
      '                 part_index <= partition_byte[5:4];\n',
      '             dir_cluster <= {dir_clhi_b[1],dir_clhi_b[0],dir_cllo_b[1],dir_cllo_b[0]};\n',
      '             dir_size <= {sd_data,dir_size_b[2],dir_size_b[1],dir_size_b[0]};\n',
      '             dir_byte<=0;\n',
      '       reserved_sectors<=reserved32; fat_count<=fats; fat_size<=fatsz32; root_cluster<=root_cluster_masked;\n',
    ]: rep(line,'')
    rep('    part_index<=0; fat_entry_cluster<=0; fat_entry_value<=0; fat_value_byte<=0; fat_offset<=0;', '    fat_entry_value<=0; fat_offset<=0;')
    rep('root_clusters_read<=0; dir_byte<=0;', 'root_clusters_read<=0;')
    rep('root_b[i]<=0; mbr_tmp[i]<=0;', 'root_b[i]<=0;')
    rep('reg [31:0] fat_entry_cluster, fat_entry_value;', 'reg [31:0] fat_entry_value;')
    rep('      fat_entry_cluster<=current_root_cluster; fat_entry_value<=0;', '      fat_entry_value<=0;')
    rep('reg [31:0] volume_base, volume_sectors, fat_size, root_cluster;\n','')
    rep('gap_count<=0; volume_base<=0; volume_sectors<=0;', 'gap_count<=0;')
    rep('   fat_size<=0; root_cluster<=0; is_mbr<=0; chosen_start<=0; chosen_size<=0;', '   is_mbr<=0; chosen_start<=0; chosen_size<=0;')
    rep('         is_mbr<=1; volume_base<=selected_start; volume_sectors<=selected_size;', '         is_mbr<=1;')
    rep('       volume_base<=is_mbr?chosen_start:0; volume_sectors<=total32;\n','')
    p.write_text(s,encoding='utf-8')

if __name__=='__main__': apply(sys.argv[1])
