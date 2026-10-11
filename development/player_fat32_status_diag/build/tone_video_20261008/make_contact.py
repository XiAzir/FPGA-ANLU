from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

root = Path(__file__).parent
frames = sorted((root / 'frames').glob('frame_*.jpg'))
font = ImageFont.truetype('C:/Windows/Fonts/arial.ttf', 22)
sheet = Image.new('RGB', (4 * 640, ((len(frames) + 3) // 4) * 390), '#202020')
draw = ImageDraw.Draw(sheet)
for index, path in enumerate(frames):
    x, y = (index % 4) * 640, (index // 4) * 390
    frame = Image.open(path)
    frame.thumbnail((640, 360))
    sheet.paste(frame, (x, y + 30))
    draw.text((x + 8, y + 4), f'{index + 0.5:.1f} s', font=font, fill='white')
sheet.save(root / 'contact.jpg', quality=95)
print(f'{len(frames)} frames, native orientation; nominal fps-filter sample centers shown')

chosen = [9, 10, 11, 13, 18, 20, 21, 22]
sheet = Image.new('RGB', (1100, 4 * 220), '#202020')
draw = ImageDraw.Draw(sheet)
for index, number in enumerate(chosen):
    x, y = (index % 2) * 550, (index // 2) * 220
    crop = Image.open(frames[number - 1]).crop((410, 500, 960, 690))
    sheet.paste(crop, (x, y + 30))
    draw.text((x + 8, y + 4), f'{number - 0.5:.1f} s', font=font, fill='white')
sheet.save(root / 'display_crops.jpg', quality=95)
