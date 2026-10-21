#!/usr/bin/env python3
"""Independent gold model for the spectrum overlay's numerical and pixel contract."""
from __future__ import annotations
import json
from pathlib import Path

BANDS=24
MAX_HEIGHT=84
COLORS=[0x24525c,0x2b626b,0x33747c,0x3c868c,0x46979c,0x50a8ac,0x5ab8bb,0x63c6c8,0x6dd2d4,0x78dddf]
GLYPHS={
'S':['01111','10000','10000','01110','00001','00001','11110'],
'P':['11110','10001','10001','11110','10000','10000','10000'],
'E':['11111','10000','10000','11110','10000','10000','11111'],
'C':['01111','10000','10000','10000','10000','10000','01111'],
'T':['11111','00100','00100','00100','00100','00100','00100'],
'R':['11110','10001','10001','11110','10100','10010','10001'],
'U':['10001','10001','10001','10001','10001','10001','01110'],
'M':['10001','11011','10101','10101','10001','10001','10001'],
'W':['10001','10001','10001','10101','10101','10101','01010'],
'A':['01110','10001','10001','11111','10001','10001','10001'],
'V':['10001','10001','10001','10001','10001','01010','00100'],
'O':['01110','10001','10001','10001','10001','10001','01110'],
'N':['10001','11001','10101','10011','10001','10001','10001'],
'H':['10001','10001','10001','11111','10001','10001','10001'],
'L':['10000','10000','10000','10000','10000','10000','11111'],
'D':['11110','10001','10001','10001','10001','10001','11110'],
'I':['01110','00100','00100','00100','00100','00100','01110'],
'G':['01111','10000','10000','10111','10001','10001','01111']}

def magnitude_height(value:int)->int:
    value=max(0,min(65535,value))
    if value<=16:return 0
    exponent=value.bit_length()-1
    return min(MAX_HEIGHT,(exponent-4)*10+((value>>(exponent-3))&7))

def smooth(current:int,target:int)->int:
    if target>current:return current+(target-current+1)//2
    if target<current:return current-(current-target+7)//8
    return current

def palette(i:int)->int:return COLORS[i] if i<len(COLORS) else COLORS[-1]

def title_text(held:bool,tone:bool)->str:
    if held:return 'HOLD '+('TONE' if tone else 'WAV')
    return 'SPECTRUM '+('TONE' if tone else 'WAV')

def glyph_on(c:str,x:int,y:int)->bool:
    rows=GLYPHS.get(c)
    return bool(rows and 0<=x<5 and 0<=y<7 and rows[y][x]=='1')

def pixel(x:int,y:int,de:bool,rgb_in:int,display:list[int],peak:list[int],held:bool=False,tone:bool=False)->int:
    if not de or not (16<=x<624 and 304<=y<432):return rgb_in&0xffffff
    rgb=0x0c1622
    if 128<=x<512 and y in (350,382,414):rgb=0x182b38
    for j in range(BANDS):
        if 128+j*16+2<=x<128+j*16+14:
            h=display[j]; ph=peak[j]; distance=414-y
            if h and y<414 and y>=414-h:rgb=palette(distance>>3)
            if ph and 414-ph-3<=y<414-ph-1:rgb=0xb7eeee
            break
    tx=x-32;ty=y-310
    text=title_text(held,tone)
    ci=tx//16;gx=(tx%16)//2;gy=ty//2
    if 0<=tx<208 and 0<=ty<14 and glyph_on(text[ci] if ci<len(text) else ' ',gx,gy):rgb=0x95adb8 if held else 0xddebf2
    lx=x-128 if x<320 else x-480
    legend='LOW' if x<320 else 'HIGH'
    lxidx=lx//8
    if 420<=y<427 and 0<=lx<32 and lx%8<5 and glyph_on(legend[lxidx] if lxidx<len(legend) else ' ',lx%8,y-420):rgb=0x829cac
    return rgb

# Numerical response checks cover all possible unsigned 16-bit input magnitudes.
heights=[magnitude_height(v) for v in range(65536)]
assert all(0<=h<=84 for h in heights)
assert all(heights[i]<=heights[i+1] for i in range(65535)), 'height curve must be monotonic'
assert all(smooth(h,84)>=h for h in range(85)) and all(smooth(h,0)<=h for h in range(85))

profiles={
    0:([0]*24,[0]*24),
    1:([(j*3+8)%85 for j in range(24)],[max(0,(j*3+8)%85-5) for j in range(24)]),
    2:([84]*24,[84]*24),
    3:([20 if j%2==0 else 0 for j in range(24)],[36 if j%2==0 else 0 for j in range(24)]),
}
def expected_pixels():
    points=[]
    for sc,held,tone,profile in [(1,False,False,1),(1,False,True,1),(1,True,False,1),(1,True,True,1),(2,False,False,2)]:
        disp,pk=profiles[profile]
        coords=[(15,304),(16,304),(623,431),(624,431),(127,350),(128,350),(511,350),(512,350),
                (130,400),(141,400),(142,400),(145,400),(146,400),(157,400),(158,400),
                (498,400),(499,400),(500,400),(509,400),(510,400),(511,400),
                (194,330),(206,330),(207,330),(194,329),(194,330),(194,413),(194,414),(194,420),
                (128,420),(128,421),(140,420),(144,420),(160,420),
                (480,420),(487,420),(488,420),(495,420),(496,420),(503,420),(504,420),(511,420),
                (32,310),(33,310),(34,310),(43,310),(44,310),(48,310),(56,310),(64,310),(80,310),(96,310),
                (112,310),(128,310),(139,310),(144,310),(164,310),(175,310),(176,310),(188,310),(192,310),
                (200,310),(208,310),(211,310),(220,310)]
        for x,y in coords:
            for de,rgb in [(True,0x123456),(False,0xa1b2c3)]:
                points.append({'scenario':sc,'held':held,'tone':tone,'de':de,'x':x,'y':y,'rgb_in':rgb,
                               'expected':pixel(x,y,de,rgb,disp,pk,held,tone)})
    return points

def main():
    pts=expected_pixels(); out=Path(__file__).with_name('vectors');out.mkdir(exist_ok=True)
    # {scenario,held,tone,de,x[9:0],y[8:0],rgb_in,expected} packed into 78 bits.
    with (out/'render_pixels.mem').open('w',encoding='ascii',newline='\n') as f:
        for p in pts:
            v=(p['scenario']<<70)|(int(p['held'])<<69)|(int(p['tone'])<<68)|(int(p['de'])<<67)|(p['x']<<57)|(p['y']<<48)|(p['rgb_in']<<24)|p['expected']
            f.write(f'{v:020x}\n')
    report={'assertions':{'magnitude_input_domain':65536,'height_min':min(heights),'height_max':max(heights),'monotonic':True,
                         'attack_step':'ceil((target-current)/2)','release_step':'ceil((current-target)/8)',
                         'peak':'updated >= peak reloads 10; then hold countdown; then decay by 2 per VS',
                         'rgb_passthrough':'outside panel or de=0'},'pixel_samples':len(pts),'scenarios':profiles,
            'pixel_results':pts}
    (out/'render_gold.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
    print(json.dumps({k:v for k,v in report.items() if k!='pixel_results'},indent=2))
if __name__=='__main__':main()



