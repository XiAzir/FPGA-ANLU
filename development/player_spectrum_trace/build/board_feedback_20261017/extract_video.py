"""Preserve supplied videos and extract inspection frames; no board operations."""
from pathlib import Path
import sys,json,hashlib,shutil
sys.path.insert(0,str(Path(__file__).resolve().parents[4]/'tmp/video_tools'))
import cv2
from PIL import Image,ImageDraw
BASE=Path(__file__).resolve().parent
ORIGINAL=Path('E:/QQ CACHE/LiaoTianJiLu/Tencent Files/1791081637/nt_qq/nt_data/Video/2026-10/Ori')
DOC=Path('E:/QQ CACHE/Download/安路资料/开发记录/专题记录/音频可视化/频谱柱_C11304_20261013/C11312_实板反馈_20261017')
DOC.mkdir(parents=True,exist_ok=True)
FILES={'before_key1':'61ce1517b1d00454b1f9bbf135fcfa11.mp4','after_key1':'4d0072ce64b02bf208efe8e464b92da1.mp4','display':'0db7d62a2ffbcb7031785a0ddeb7e82d.mp4'}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
records=[]
for role,name in FILES.items():
 source=ORIGINAL/name;target=DOC/(role+'.mp4')
 if not target.exists():shutil.copy2(source,target)
 if sha(source)!=sha(target):raise ValueError('Evidence copy mismatch')
 cap=cv2.VideoCapture(str(source));fps=cap.get(cv2.CAP_PROP_FPS);count=int(cap.get(cv2.CAP_PROP_FRAME_COUNT));duration=count/fps
 directory=BASE/role;directory.mkdir(parents=True,exist_ok=True)
 meta=dict(role=role,source=str(source),preserved=str(target),sha256=sha(source),bytes=source.stat().st_size,fps=fps,frames=count,duration_seconds=duration,width=cap.get(3),height=cap.get(4))
 times=sorted(set([t for t in [0,.5,2,5,10,20,30,40,max(0,duration-1)] if t<duration]))
 for t in times:
  cap.set(cv2.CAP_PROP_POS_MSEC,t*1000);ok,frame=cap.read()
  if ok:cv2.imwrite(str(directory/f'frame_{t:06.2f}.png'),frame)
 cap.release();records.append(meta);print(json.dumps(meta,ensure_ascii=False),flush=True)
(BASE/'video_manifest.json').write_text(json.dumps(records,ensure_ascii=False,indent=2),encoding='utf-8')
shutil.copy2(BASE/'video_manifest.json',DOC/'video_manifest.json')
