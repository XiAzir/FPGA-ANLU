import subprocess,json,hashlib,pathlib
from PIL import Image,ImageDraw
root=pathlib.Path('development/video23_work/board_20261022')
base=pathlib.Path('E:/QQ CACHE/LiaoTianJiLu/Tencent Files/1791081637/nt_qq/nt_data/Video/2026-10/Ori')
obs=[]
for name,fn in [('photo','bc3337b3ad1017c33ed94c6d05cd972f.mp4'),('video','5af7941c5b80ee09a72ed6ec4397d55a.mp4')]:
 p=base/fn; out=root/name;out.mkdir(exist_ok=True)
 probe=json.loads(subprocess.check_output(['ffprobe','-v','quiet','-show_format','-show_streams','-of','json',str(p)]))
 obs.append({'mode':name,'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'probe':probe})
 with (out/'extract.log').open('w') as log:
  subprocess.run(['ffmpeg','-hide_banner','-y','-i',str(p),'-vf','fps=2','-q:v','2',str(out/'frame_%03d.jpg'),'-vn','-acodec','pcm_s16le',str(out/'audio.wav')],stdout=log,stderr=log,check=True)
 frames=sorted(out.glob('frame_*.jpg'))
 for start in range(0,len(frames),12):
  sheet=Image.new('RGB',(1920,4*295),(32,32,32)); d=ImageDraw.Draw(sheet)
  for i,f in enumerate(frames[start:start+12]):
   im=Image.open(f);im.thumbnail((640,270)); x=i%3*640;y=i//3*295;sheet.paste(im,(x,y));d.text((x+8,y+272),f'{name} t={(start+i)*0.5:.1f}s',fill='white')
  sheet.save(root/f'{name}_{start+1:03d}_sheet.jpg',quality=95)
(root/'source_manifest.json').write_text(json.dumps(obs,indent=2,ensure_ascii=False),encoding='utf-8')
print([(o['mode'],o['probe']['format']['duration'],o['probe']['streams'][0]['width'],o['probe']['streams'][0]['height']) for o in obs])
