from pathlib import Path
from PIL import Image,ImageDraw
import numpy as np
root=Path('development/player_dynamic_text_cadence_probe/build/board_feedback_20261011')
for mode in ['before','after']:
    tiles=[]
    out=root/mode
    (out/'crops').mkdir(exist_ok=True)
    for i,p in enumerate(sorted((out/'frames').glob('*.png'))):
        im=Image.open(p).convert('RGB')
        a=np.asarray(im).astype('int32')
        m=(a[:,:,0]>130)&(a[:,:,0]>a[:,:,1]*1.4)&(a[:,:,0]>a[:,:,2]*1.4)
        counts=m[300:540,350:940].sum(axis=1)
        cy=300+int(np.argmax(np.convolve(counts,np.ones(65),mode='same')))
        cr=im.crop((350,cy-55,940,cy+55))
        cr.save(out/'crops'/p.name)
        tile=Image.new('RGB',(620,145),'white')
        tile.paste(cr,(15,30))
        ImageDraw.Draw(tile).text((10,7),f'{mode} frame {i+1:03d} fps2 ~{i*.5:.1f}s',fill='black')
        tiles.append(tile)
    for j in range(0,len(tiles),18):
        group=tiles[j:j+18]
        sheet=Image.new('RGB',(1240,145*((len(group)+1)//2)),(210,210,210))
        for k,tile in enumerate(group):sheet.paste(tile,(k%2*620,k//2*145))
        sheet.save(out/f'contact_{j//18+1}.png')
print('contact sheets ready')
