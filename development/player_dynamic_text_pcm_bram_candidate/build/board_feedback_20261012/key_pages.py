from pathlib import Path
from PIL import Image,ImageDraw
import numpy as np
r=Path('E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_pcm_bram_candidate/build/board_feedback_20261012')
rows={'1':1,'3':4,'6':8,'7':12,'8':16,'9':20,'A':24,'B':28,'C':32,'D':36}
for mode in ('before','after'):
    sheet=Image.new('RGB',(840,165*10),'white')
    for j,(page,n) in enumerate(rows.items()):
        im=Image.open(r/mode/'frames'/f'{n:03}.png').convert('RGB')
        a=np.asarray(im).astype('int32')
        mask=(a[:,:,0]>140)&(a[:,:,0]>a[:,:,1]*1.4)&(a[:,:,0]>a[:,:,2]*1.4)
        counts=mask[150:550,200:1000].sum(axis=1)
        cy=150+int(np.argmax(np.convolve(counts,np.ones(80),mode='same')))
        crop=im.crop((200,cy-70,1000,cy+70))
        sheet.paste(crop,(20,j*165+25))
        ImageDraw.Draw(sheet).text((20,j*165+5),f'{mode} page {page}; fps2 frame {n:03}',fill='black')
    sheet.save(r/mode/'key_pages.png')
