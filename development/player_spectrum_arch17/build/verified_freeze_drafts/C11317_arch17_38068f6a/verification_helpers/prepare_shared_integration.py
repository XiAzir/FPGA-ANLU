from pathlib import Path
import re,json,hashlib
R=Path(__file__).resolve().parents[2];C=R/'development/player_spectrum_arch17';W=Path(__file__).parent
D=W/'integration';D.mkdir(exist_ok=True)
p=C/'src/user_source/hdl_source/top_tf_hdmi_audio.v';s=p.read_text(encoding='utf-8-sig')
a=s.index('fat32_file_sector #');b=s.index('// AC201 has four active-low LEDs',a)
block='''// One FAT execution engine; both clients retain independent file contexts.
fat32_dual_file_sector #(.REQUEST_STABLE(1),.WAV_STATIC_FILE(1)) u_file_mapper (
    .clk(sd_card_clk),.rst(rst_all),
    .fat_lba(fs_fat_lba),.data_lba(fs_data_lba),.cluster_count(fs_cluster_count),
    .sectors_per_cluster_shift(fs_cluster_shift),
    .bmp_enable(fs_ready && !fs_error),.bmp_start_cluster(bmp_file_cluster),
    .bmp_file_size(bmp_file_size),.bmp_file_read(bmp_card_read),.bmp_file_sector(bmp_card_addr),
    .bmp_file_data(bmp_card_data),.bmp_file_valid(bmp_card_valid),.bmp_file_end(bmp_card_end),
    .bmp_error(bmp_map_error),.bmp_error_code(bmp_map_error_code),
    .wav_enable(fs_ready && fs_wav_found && !fs_error),.wav_start_cluster(fs_wav_cluster),
    .wav_file_size(fs_wav_size),.wav_file_read(wav_card_read),.wav_file_sector(wav_card_addr),
    .wav_file_data(wav_card_data),.wav_file_valid(wav_card_valid),.wav_file_end(wav_card_end),
    .wav_error(wav_map_error),.wav_error_code(wav_map_error_code),
    .sd_read(arb_card_read),.sd_addr(arb_card_addr),
    .sd_data(shared_card_data),.sd_valid(arb_card_valid),.sd_end(arb_card_end)
);

'''
s=s[:a]+block+s[b:]
a=s.index('sd_sector_arbiter u_card_arbiter (');b=s.index(');',a)+2
s=s[:a]+s[b:]
s=s.replace('wire fs_read, bmp_phy_read, wav_phy_read, bmp_map_error, wav_map_error;','wire fs_read, bmp_map_error, wav_map_error;')
s=s.replace('wire [31:0] fs_addr, bmp_phy_addr, wav_phy_addr;','wire [31:0] fs_addr;')
s=s.replace('wire [7:0] bmp_phy_data, wav_phy_data;\n','')
s=s.replace('wire bmp_phy_valid, bmp_phy_end, wav_phy_valid, wav_phy_end;\n','')
assert 'bmp_phy_' not in s and 'wav_phy_' not in s and 'u_card_arbiter' not in s
(D/'top_tf_hdmi_audio.v').write_text(s,encoding='utf-8')
p=C/'src/td_project/AC201_tf_hdmi.al';s=p.read_text(encoding='utf-8-sig')
s,n=re.subn(r'            <File Path="../user_source/hdl_source/sd_sector_arbiter.v">.*?</File>\s*\n','',s,flags=re.S);assert n==1
assert s.count('fat32_file_sector.v')==1
s=s.replace('fat32_file_sector.v','fat32_dual_file_sector.v')
(D/'AC201_tf_hdmi.al').write_text(s,encoding='utf-8')
print('Shared integration drafted; production candidate unchanged')
