from pathlib import Path
import sys,json
sys.path.insert(0,str(Path(__file__).resolve().parents[4]/'tmp/video_tools'))
import cv2,numpy as np
from PIL import Image,ImageDraw
BASE=Path(__file__).resolve().parent
meta=json.loads((BASE/'video_manifest.json').read_text(encoding='utf-8'))
for item in meta[:2]:
 role=item['role'];folder=BASE/role;cap=cv2.VideoCapture(item['source']);tiles=[];crops=[]
 for n in range(int(item['duration_seconds'])):
  t=n+.5;cap.set(cv2.CAP_PROP_POS_MSEC,t*1000);ok,frame=cap.read()
  if not ok:continue
  frame=cv2.rotate(frame,cv2.ROTATE_90_COUNTERCLOCKWISE)
  hsv=cv2.cvtColor(frame,cv2.COLOR_BGR2HSV)
  mask=(((hsv[:,:,0]<15)|(hsv[:,:,0]>170))&(hsv[:,:,1]>110)&(hsv[:,:,2]>150)).astype(np.uint8)*255
  joined=cv2.morphologyEx(mask,cv2.MORPH_CLOSE,np.ones((13,27),np.uint8))
  contours,_=cv2.findContours(joined,cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)
  bounds=[cv2.boundingRect(c) for c in contours]
  eligible=[b for b in bounds if b[2]>180 and b[2]>3*b[3] and b[3]>15]
  if eligible:
   x,y,w,h=max(eligible,key=lambda b:b[2]*b[3]);x=max(x-8,0);y=max(y-6,0);w+=16;h+=12
  else:
   rows=np.sum(mask>0,axis=1);y=max(int(np.argmax(np.convolve(rows,np.ones(25),mode='same')))-42,0)
   x=210;w=650;h=84
  crop=frame[y:y+h,x:x+w]
  cv2.imwrite(str(folder/f'digits_{t:05.1f}.png'),crop)
  image=Image.fromarray(cv2.cvtColor(crop,cv2.COLOR_BGR2RGB));image.thumbnail((530,100))
  tile=Image.new('RGB',(550,135),'#222222');draw=ImageDraw.Draw(tile);draw.text((8,4),f'{role} t={t:05.1f}s',fill='white')
  tile.paste(image,((550-image.width)//2,27));tiles.append(tile)
  crops.append(dict(t=t,rotated_crop=[x,y,w,h]))
 for start in range(0,len(tiles),16):
  sheet=Image.new('RGB',(2200,540),'#555555')
  for i,tile in enumerate(tiles[start:start+16]):sheet.paste(tile,((i%4)*550,(i//4)*135))
  sheet.save(folder/f'sheet_{start:02d}_{min(start+15,len(tiles)-1):02d}.jpg',quality=95)
 (folder/'crops.json').write_text(json.dumps(crops,indent=2))
 cap.release();print(role,'samples',len(tiles),flush=True)
