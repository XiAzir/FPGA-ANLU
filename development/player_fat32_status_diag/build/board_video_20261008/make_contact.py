from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

root = Path(__file__).parent
frames = sorted((root / 'frames').glob('frame_*.jpg'))
font = ImageFont.truetype('C:/Windows/Fonts/arial.ttf', 22)
for start in range(0, len(frames), 24):
    subset = frames[start:start + 24]
    sheet = Image.new('RGB', (4 * 640, ((len(subset) + 3) // 4) * 390), '#202020')
    draw = ImageDraw.Draw(sheet)
    for index, path in enumerate(subset):
        x = (index % 4) * 640
        y = (index // 4) * 390
        frame = Image.open(path)
        frame.thumbnail((640, 360))
        sheet.paste(frame, (x, y + 30))
        draw.text((x + 8, y + 4), f'{start + index + 0.5:.1f} s', font=font, fill='white')
    sheet.save(root / f'contact_{start // 24 + 1}.jpg', quality=93)
print(f'{len(frames)} frames, CCW 90 degrees; nominal fps-filter sample centers shown')

chosen = [4, 6, 8, 10, 11, 12, 20, 21, 30, 31, 40, 41]
sheet = Image.new('RGB', (1200, 6 * 250), '#202020')
draw = ImageDraw.Draw(sheet)
for index, number in enumerate(chosen):
    x, y = (index % 2) * 600, (index // 2) * 250
    crop = Image.open(frames[number - 1]).crop((390, 390, 960, 610))
    sheet.paste(crop, (x, y + 30))
    draw.text((x + 8, y + 4), f'{number - 0.5:.1f} s', font=font, fill='white')
sheet.save(root / 'display_crops.jpg', quality=95)
