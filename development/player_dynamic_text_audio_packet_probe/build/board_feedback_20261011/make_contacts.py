from pathlib import Path
from PIL import Image, ImageDraw
import numpy as np

root = Path(__file__).resolve().parent
for mode in ['before', 'after']:
    out = root / mode
    (out / 'crops').mkdir(exist_ok=True)
    tiles = []
    for i, p in enumerate(sorted((out / 'frames').glob('*.png'))):
        im = Image.open(p).convert('RGB')
        a = np.asarray(im).astype('int32')
        mask = (a[:, :, 0] > 140) & (a[:, :, 0] > a[:, :, 1] * 1.4) & (a[:, :, 0] > a[:, :, 2] * 1.4)
        counts = mask[300:520, 380:920].sum(axis=1)
        cy = 300 + int(np.argmax(np.convolve(counts, np.ones(70), mode='same')))
        crop = im.crop((380, cy-52, 925, cy+52))
        crop.save(out / 'crops' / p.name)
        tile = Image.new('RGB', (565, 130), 'white')
        tile.paste(crop, (10, 23))
        ImageDraw.Draw(tile).text((10, 5), f'{mode} frame {i+1:03d} fps2 nominal {i*0.5:.1f}s', fill='black')
        tiles.append(tile)
    for start in range(0, len(tiles), 18):
        group = tiles[start:start+18]
        sheet = Image.new('RGB', (1130, 130*((len(group)+1)//2)), (210, 210, 210))
        for k, tile in enumerate(group):
            sheet.paste(tile, (k%2*565, k//2*130))
        sheet.save(out / f'contact_{start//18+1}.png')
print('Contact sheets ready; times label the fps2 grid, not exact source PTS.')
