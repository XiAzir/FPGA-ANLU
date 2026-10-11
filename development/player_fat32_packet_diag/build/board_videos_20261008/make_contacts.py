"""Reproduce contact sheets from extracted video frames; no OCR or data correction.

Inputs: ffmpeg fps=2 JPEG frames and selected -ss PNG frames in default/tone.
The red-pixel density only locates the display; readouts are interpreted manually.
"""
from pathlib import Path
from PIL import Image, ImageDraw
import numpy as np

BASE = Path(__file__).resolve().parent


def display_crop(path):
    im = Image.open(path).convert('RGB')
    a = np.asarray(im).astype(np.int32)
    mask = (a[:, :, 0] > 110) & (a[:, :, 0] > a[:, :, 1] * 1.45) & (a[:, :, 0] > a[:, :, 2] * 1.35)
    counts = mask[170:550, 130:1020].sum(axis=1)
    cy = 170 + int(np.argmax(np.convolve(counts, np.ones(90), mode='same')))
    return im.crop((120, max(0, cy - 90), 1040, min(im.height, cy + 90)))


for mode in ('default', 'tone'):
    folder = BASE / mode
    cropdir = folder / 'crops'
    cropdir.mkdir(exist_ok=True)
    tiles = []
    for index, path in enumerate(sorted((folder / 'frames').glob('frame_*.jpg'))):
        crop = display_crop(path)
        crop.save(cropdir / path.name, quality=95)
        if index % 2 == 0:
            tile = Image.new('RGB', (710, 170), 'white')
            tile.paste(crop.resize((690, 135)), (10, 28))
            ImageDraw.Draw(tile).text((10, 5), f'{mode} frame {index + 1:03d} ~{index * .5:.1f}s', fill='black')
            tiles.append(tile)
    for part in range((len(tiles) + 13) // 14):
        group = tiles[part * 14:(part + 1) * 14]
        sheet = Image.new('RGB', (1420, 170 * ((len(group) + 1) // 2)), (230, 230, 230))
        for i, tile in enumerate(group):
            sheet.paste(tile, ((i % 2) * 710, (i // 2) * 170))
        sheet.save(folder / f'contact_{part + 1}.jpg', quality=95)

pages = ('1', '3', '6', '7', '8', '9', 'A', 'B', 'C')
selected = Image.new('RGB', (1420, 170 * len(pages)), (230, 230, 230))
for row, page in enumerate(pages):
    for column, mode in enumerate(('default', 'tone')):
        paths = list((BASE / mode / 'selected').glob(f'page_{page}_at_*s.png'))
        assert len(paths) == 1, (mode, page, paths)
        path = paths[0]
        crop = display_crop(path)
        crop.save(path.with_name(path.stem + '_crop.jpg'), quality=95)
        tile = Image.new('RGB', (710, 170), 'white')
        tile.paste(crop.resize((690, 135)), (10, 28))
        ImageDraw.Draw(tile).text((10, 5), f'{mode}: {path.stem}', fill='black')
        selected.paste(tile, (column * 710, row * 170))
selected.save(BASE / 'selected_pages.jpg', quality=95)
print('Contact sheets and selected pages generated; data read manually.')
