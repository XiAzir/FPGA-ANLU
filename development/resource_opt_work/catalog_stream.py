from pathlib import Path
import sys

def apply(hdl):
    p=Path(hdl)/'fat32_catalog.v';s=p.read_text(encoding='utf-8-sig')
    def replace(a,b):
        nonlocal s
        assert s.count(a)==1,(a,s.count(a))
        s=s.replace(a,b)
    replace('''reg [7:0] part_type[0:3];
reg [31:0] part_start[0:3], part_size[0:3];''','''// The first FAT32 partition wins. Capture it as bytes arrive; later
// partitions cannot affect selection, including when the first is invalid.
reg partition_found;
reg [1:0] selected_partition;
reg [31:0] selected_start, selected_size;''')
    replace('   fat_size<=0; root_cluster<=0; is_mbr<=0; chosen_start<=0; chosen_size<=0;', '''   fat_size<=0; root_cluster<=0; is_mbr<=0; chosen_start<=0; chosen_size<=0;
   partition_found<=0; selected_partition<=0; selected_start<=0; selected_size<=0;''')
    replace('root_b[i]<=0; part_type[i]<=0;part_start[i]<=0;part_size[i]<=0;mbr_tmp[i]<=0;', 'root_b[i]<=0; mbr_tmp[i]<=0;')
    replace('''                 part_index <= partition_byte[5:4];
                 if(partition_byte[3:0]==4) part_type[partition_byte[5:4]]<=sd_data;
                 if(partition_byte[3:2]==2) part_start[partition_byte[5:4]][{partition_byte[1:0],3'b000} +: 8]<=sd_data;
                 if(partition_byte[3:2]==3) part_size[partition_byte[5:4]][{partition_byte[1:0],3'b000} +: 8]<=sd_data;''','''                 part_index <= partition_byte[5:4];
                 if(partition_byte==0) begin
                   partition_found<=0; selected_start<=0; selected_size<=0;
                 end
                 if(partition_byte[3:0]==4 && !partition_found &&
                    (sd_data==8'h0b || sd_data==8'h0c)) begin
                   partition_found<=1; selected_partition<=partition_byte[5:4];
                 end
                 if(partition_found && selected_partition==partition_byte[5:4]) begin
                   if(partition_byte[3:2]==2) selected_start[{partition_byte[1:0],3'b000} +: 8]<=sd_data;
                   if(partition_byte[3:2]==3) selected_size[{partition_byte[1:0],3'b000} +: 8]<=sd_data;
                 end''')
    start=s.index('     if(!is_mbr && !bpb_header_candidate &&')
    end=s.index('     end else if(bps_lo!=0',start)
    s=s[:start]+'''     if(!is_mbr && !bpb_header_candidate && partition_found) begin
       if(selected_start==0 || selected_size==0 ||
          ({1'b0,selected_start}+{1'b0,selected_size})>33'h100000000) fail(E_RANGE);
       else begin
         chosen_start<=selected_start; chosen_size<=selected_size;
         is_mbr<=1; volume_base<=selected_start; volume_sectors<=selected_size;
         issue_sector(S_READ_BOOT,selected_start);
       end
'''+s[end:]
    p.write_text(s,encoding='utf-8')

if __name__=='__main__': apply(sys.argv[1])
