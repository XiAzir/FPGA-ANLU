from pathlib import Path
import re
p=Path(__file__).resolve().parents[1]
f=p/'src/user_source/hdl_source/player_pcm_waveform.v'
s=f.read_text(encoding='utf-8-sig')
base=(7,11,18)
def table(name,delta):
    entries=[]
    for a in range(17):
        rgb=[b+(a*d)//16 for b,d in zip(base,delta)]
        entries.append(f"            {a}:{name}=24'h{rgb[0]:02x}{rgb[1]:02x}{rgb[2]:02x};")
    return f'''    function [23:0] {name};
        input [4:0] a;
        begin case(a)
'''+ '\n'.join(entries)+f'''\n            default:{name}=24'h070b12;
        endcase end
    endfunction'''
for name,delta in [('main_color',(65,209,192)),('glow_color',(4,13,12))]:
    s,n=re.subn(r'    function \[23:0\] '+name+r';.*?    endfunction',lambda m:table(name,delta),s,count=1,flags=re.S)
    assert n==1
f.write_text(s,encoding='utf-8')
print('BACKGROUND_COMPOSITED_16_STEP_CORE_AND_MONOTONIC_HALO_PALETTE_SET')
