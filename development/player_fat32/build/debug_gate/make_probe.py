from pathlib import Path
r=Path('E:/VSCODE-project/FPGA-ANLU/development/player_fat32'); d=r/'build/debug_gate'
s=(r/'sim/tb_fat_file_integration.v').read_text().split('reg [31:0] lbas')[0]
s=s.replace('`include "config.vh"','').replace('module tb_fat_file_integration;','''module fat_probe(input clk,rst,init_done,key_next,key_auto,
input [7:0] card_data, input card_valid,card_end,sample_take,
output card_read,output [31:0] card_addr,
output write_en, output [23:0] write_data,
output primed,sample_available,output [15:0] sample_data,
output fs_ready,fs_error,bmp_error,wav_error,bmp_map_error,wav_map_error);''').replace('parameter WIDTH=16, HEIGHT=64;','parameter WIDTH=640, HEIGHT=480;')
for a in ['reg clk=0; always #10 clk=~clk;','reg rst=1,init_done=0,key_next=1,key_auto=1;','wire fs_ready,fs_error,wav_found;','wire card_read; wire [31:0] card_addr;','reg [7:0] card_data=0;reg card_valid=0,card_end=0;','wire bmp_map_error,wav_map_error;','wire write_req,write_en;wire [23:0] write_data;','reg sample_take=0;wire [15:0] sample_data;','wire sample_available,primed,wav_error;']:
 s=s.replace(a, {'wire fs_ready,fs_error,wav_found;':'wire wav_found;','wire bmp_map_error,wav_map_error;':'','wire write_req,write_en;wire [23:0] write_data;':'wire write_req;'}.get(a,''))
s=s.replace('wire display_valid,bmp_error;','wire display_valid;').replace('reg finish_toggle=0,write_ack=0;','wire finish_toggle=0; wire write_ack=write_req;')
s+='\nendmodule\n'; (d/'fat_probe.v').write_text(s)
p=(r/'src/td_project/AC201_tf_hdmi.al').read_text().replace('../user_source/',(r/'src/user_source').as_posix()+'/')
p=p.replace('</Verilog>',f'<File Path="{(d/"fat_probe.v").as_posix()}"><FileInfo><Attr Name="UsedInSyn" Val="true"/><Attr Name="UsedInP&amp;R" Val="true"/><Attr Name="CompileOrder" Val="105"/></FileInfo></File>\n</Verilog>')
p=p.replace('<Name>AC201_tf_hdmi</Name>','<Name>fat_probe</Name>'); (d/'fat_probe.al').write_text(p)
(d/'synth_probe.tcl').write_text(f'''cd {d.as_posix()}
import_device eagle_s20.db -package EG4S20BG256
open_project fat_probe.al -single_run
load_run_param -run syn_1
elaborate -top fat_probe
commit_param -step rtl
optimize_rtl
commit_param -step gate
optimize_gate -packarea probe.area
write_verilog probe_gate.v
puts PROBE_EXPORTED
close_project
exit
''')
print('Generated independent gate probe project')
