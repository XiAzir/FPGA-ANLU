from pathlib import Path
import csv, hashlib, io, json, math, re, sys, wave
import numpy as np
from PIL import Image, ImageDraw, ImageFont

sys.path.insert(0,str(Path(__file__).resolve().parent))
from benchmark_jpeg import quantize,psnr
ROOT=Path(__file__).resolve().parents[1];MEDIA=ROOT/'media';RESULTS=ROOT/'results'
DOCS=Path('E:/QQ CACHE/Download/安路资料/开发记录/专题记录/视频素材实验_20261021')
DOCS.mkdir(parents=True,exist_ok=True)
def sha(path):
    h=hashlib.sha256()
    with path.open('rb') as f:
        for b in iter(lambda:f.read(1024*1024),b''):h.update(b)
    return h.hexdigest()
def frames(path):
    data=path.read_bytes();pos=0
    while pos<len(data):
        assert data[pos:pos+2]==b'\xff\xd8'
        end=data.index(b'\xff\xd9',pos)+2
        yield data[pos:end];pos=end
    assert pos==len(data)

source=Path('C:/Users/PENGYUHAO/Downloads/只因你太美（鸡你太美）原版.mp4')
allrows=[]
for p in sorted(RESULTS.glob('*_summary.json')):allrows.extend(json.loads(p.read_text(encoding='utf-8')))
selected=next(x for x in allrows if x['geometry']=='letterbox640' and x['quality']==95)
jpegs=list(frames(Path(selected['path'])));assert len(jpegs)==300
raw=np.memmap(MEDIA/'reference_640x480_15fps.rgb',dtype=np.uint8,mode='r',shape=(300,480,640,3))
sse=0.
for i,b in enumerate(jpegs):
    a=np.array(Image.open(io.BytesIO(b)))
    d=quantize(a,'RGB565').astype(np.int16)-raw[i].astype(np.int16)
    sse+=float(np.sum(d[60:420].astype(np.float32)**2,dtype=np.float64))
combined_psnr=psnr(sse/(300*640*360*3))

font=ImageFont.truetype('C:/Windows/Fonts/simhei.ttf',18)
sheet=Image.new('RGB',(1280,536),'white');draw=ImageDraw.Draw(sheet)
for row,index in enumerate([109,225]):
    original=np.array(raw[index]);decoded=np.array(Image.open(io.BytesIO(jpegs[index])))
    variants=[('参考 RGB888',original),('JPEG Q95',decoded),('RGB565',quantize(original,'RGB565')),('RGB332',quantize(original,'RGB332'))]
    for col,(title,a) in enumerate(variants):
        im=Image.fromarray(a).resize((320,240),Image.Resampling.LANCZOS)
        sheet.paste(im,(col*320,row*268+28))
        draw.text((col*320+6,row*268+4),f'{title}  帧{index}',font=font,fill='black')
sheet.save(ROOT/'inspection/quality_comparison.png')
fixture=ROOT/'decoder_fixture';fixture.mkdir(exist_ok=True)
for i in [0,109,150,299]:
    (fixture/f'frame_{i:03d}.jpg').write_bytes(jpegs[i])
    a=np.array(Image.open(io.BytesIO(jpegs[i])))
    (fixture/f'frame_{i:03d}_pillow_rgb888.bin').write_bytes(a.tobytes())
    a16=a.astype(np.uint16)
    rgb565=((a16[...,0]>>3)<<11)|((a16[...,1]>>2)<<5)|(a16[...,2]>>3)
    (fixture/f'frame_{i:03d}_pillow_rgb565_le.bin').write_bytes(rgb565.astype('<u2').tobytes())

with wave.open(str(MEDIA/'original_audio_16_36_pcm48k_mono.wav'),'rb') as f:
    audio={'sample_rate':f.getframerate(),'channels':f.getnchannels(),'sample_width':f.getsampwidth(),'samples':f.getnframes()}
    pcm=f.readframes(f.getnframes())
assert audio=={'sample_rate':48000,'channels':1,'sample_width':2,'samples':960000}
audio['duration_s']=20.;audio['pcm_payload_sha256']=hashlib.sha256(pcm).hexdigest()
(MEDIA/'original_audio_16_36_pcm48k_mono.pcm').write_bytes(pcm)
ssim_log=(ROOT/'logs/ssim.log').read_text(encoding='utf-8')
ssim=float(re.search(r'All:([0-9.]+)',ssim_log).group(1))
assert 'frame=  300' in ssim_log

columns=['geometry','fps','quality','video_Mbps','media_including_PCM_Mbps','mean_frame_bytes','max_frame_bytes','active_picture_PSNR_RGB_dB','sustainable_fps_at_budget_same_mean_frame']
with (DOCS/'encoding_comparison.csv').open('w',newline='',encoding='utf-8-sig') as f:
    w=csv.DictWriter(f,fieldnames=columns);w.writeheader();w.writerows({k:r[k] for k in columns} for r in allrows)
result={'status':'OFFLINE_MATERIAL_ENCODING_COMPLETE',
 'source':{'path':str(source),'bytes':source.stat().st_size,'sha256':sha(source),'duration_s_from_ffmpeg':59.65,
           'video':'1280x720 30fps H264 yuv420p bt709 limited-range','audio':'48000Hz mono AAC'},
 'selection':{'start_s':16,'end_s':36,'duration_s':20,'content':'basketball and dance motion',
              'letterbox':'640x360 active video with 60 pixel top/bottom black bars in 640x480',
              'crop_control':'scaled to height480 and centre-cropped640x480 without bars'},
 'audio':audio,'selected':selected,'selected_active_SSIM_yuv420p':ssim,
 'selected_jpeg_then_RGB565_active_PSNR_RGB_dB':combined_psnr,
 'format_quantization':json.loads((RESULTS/'rgb_quantization_ablation.json').read_text()),
 'all_encodings':allrows,
 'comparison_rules':['PSNR RGB compared with decoded, resized source; active-picture ROI excludes black bars',
  'JPEG q values are Pillow/libjpeg settings; use same encoder for comparisons',
  '4:2:0 baseline sequential SOF0 8bit standard fixed DHT, no progressive, no restart markers',
  'No JPEG-to-RGB565 hardware implementation or FPGA resource measurement in this stage',
  'source is already compressed H264; this single clip is low-texture, not worst-case natural video',
  'software encode/decode timings are host PC timings, not FPGA throughput'],
 'next_decoder_contract':{'profile':'SOF0 8-bit YCbCr420; fixed DHT; fixed per-quality DQT; interleaved SOS',
   'frame_pixels':307200,'MCUs_per_frame':1200,'IDCT_8x8_blocks_per_frame':7200,
   '15fps_pixels_per_s':4608000,'15fps_blocks_per_s':108000,
   '30fps_pixels_per_s':9216000,'30fps_blocks_per_s':216000,
   'output':'consider block-addressed RGB565 writes; present buffer only on complete-frame and VS',
   'fixtures':'4 JPEGs plus Pillow-decoded RGB888 and RGB565 LE references; hardware rounding tolerance needs specification'},
 'bilibili_reference':'https://www.bilibili.com/video/BV1eAJR6tETi',
 'bilibili_findings':'Public title/owner obtainable; description dash, subtitle list empty; no evidence for SPI, compression or internal resolution. Comment API rejected by automatic review as beyond subtask authorization.'}
artifacts=[MEDIA/'candidate_640x480_15fps_q95_original_audio.mov',MEDIA/'preview_640x480_15fps_original_audio.mp4',
           MEDIA/'original_audio_16_36_pcm48k_mono.wav',MEDIA/'original_audio_16_36_pcm48k_mono.pcm',
           ROOT/'inspection/quality_comparison.png']
result['artifacts']=[{'path':str(p),'bytes':p.stat().st_size,'sha256':sha(p)} for p in artifacts]
(DOCS/'experiment_results.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({'selected_video_Mbps':selected['video_Mbps'],'selected_media_Mbps':selected['media_including_PCM_Mbps'],
 'max_frame_bytes':selected['max_frame_bytes'],'ssim':ssim,'JPEG_then_565_PSNR':combined_psnr,'variants':len(allrows),'audio':audio},ensure_ascii=False,indent=2))
