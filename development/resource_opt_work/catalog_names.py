from pathlib import Path
import sys

def apply(hdl):
    p=Path(hdl)/'fat32_catalog.v';s=p.read_text(encoding='utf-8')
    def rep(a,b):
        nonlocal s
        assert s.count(a)==1,(a,s.count(a))
        s=s.replace(a,b)
    rep('reg [7:0] dir_name[0:10];\nreg [7:0] dir_attr;', '''// Match the 8.3 names while consuming each entry. Only match/skip flags
// are used at byte 31; retaining eleven raw name bytes is unnecessary.
reg dir_first_zero, dir_deleted, dir_skip, bmp_name_match, wav_name_match;''')
    rep('   for(i=0;i<11;i=i+1) dir_name[i]<=0;', '   dir_first_zero<=1; dir_deleted<=0; dir_skip<=0; bmp_name_match<=0; wav_name_match<=0;')
    rep('''           if(byte_index[4:0]<11) dir_name[byte_index[4:0]]<=sd_data;
           case(byte_index[4:0])
             11: dir_attr<=sd_data;''','''           case(byte_index[4:0])
             0: begin
               dir_first_zero<=(sd_data==0); dir_deleted<=(sd_data==8'he5);
               wav_name_match<=(sd_data=="T");
             end
             1: wav_name_match<=wav_name_match && sd_data=="E";
             2: wav_name_match<=wav_name_match && sd_data=="S";
             3: wav_name_match<=wav_name_match && sd_data=="T";
             4,5,6,7: wav_name_match<=wav_name_match && sd_data==" ";
             8: begin bmp_name_match<=sd_data=="B"; wav_name_match<=wav_name_match && sd_data=="W"; end
             9: begin bmp_name_match<=bmp_name_match && sd_data=="M"; wav_name_match<=wav_name_match && sd_data=="A"; end
             10: begin bmp_name_match<=bmp_name_match && sd_data=="P"; wav_name_match<=wav_name_match && sd_data=="V"; end
             11: dir_skip<=sd_data==8'h0f || sd_data[3] || sd_data[4];''')
    rep("if(dir_name[0]==8'h00)", 'if(dir_first_zero)')
    rep("else if(!root_end_marker && dir_name[0]!=8'he5 && dir_attr!=8'h0f && !dir_attr[3] && !dir_attr[4])", 'else if(!root_end_marker && !dir_deleted && !dir_skip)')
    rep('if(dir_name[8]=="B" && dir_name[9]=="M" && dir_name[10]=="P")', 'if(bmp_name_match)')
    rep('if(dir_name[0]=="T" && dir_name[1]=="E" && dir_name[2]=="S" && dir_name[3]=="T" && dir_name[4]==" " && dir_name[5]==" " && dir_name[6]==" " && dir_name[7]==" " && dir_name[8]=="W" && dir_name[9]=="A" && dir_name[10]=="V")', 'if(wav_name_match)')
    p.write_text(s,encoding='utf-8')

if __name__=='__main__': apply(sys.argv[1])
