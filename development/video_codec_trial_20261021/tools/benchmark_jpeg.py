from pathlib import Path
import argparse, csv, hashlib, io, json, math, time, wave
import numpy as np
from PIL import Image, __version__ as pillow_version

ROOT = Path(__file__).resolve().parents[1]
MEDIA = ROOT/'media'
RESULTS = ROOT/'results'
GEOMETRIES = {
    'letterbox640': ('reference_640x480_15fps.rgb',640,480,60,420),
    'crop640': ('reference_crop_640x480_15fps.rgb',640,480,0,480),
    'letterbox320': ('reference_320x240_15fps.rgb',320,240,30,210),
    'letterbox640_30': ('reference_640x480_30fps.rgb',640,480,60,420),
}
QUALITIES = [65,75,85,90,93,95,97,99]
FPS = 15
FRAMES = 300
SERVICE = 1_353_638
AUDIO = 96_000
OTHER = 20_000
BUDGET = .8*SERVICE-AUDIO-OTHER

def sha(p):
    h=hashlib.sha256()
    with p.open('rb') as f:
        for block in iter(lambda:f.read(1024*1024),b''):h.update(block)
    return h.hexdigest()

def psnr(mse):
    return 10*math.log10(255*255/mse) if mse else 999.0

def jpeg_header(blob):
    assert blob[:2]==b'\xff\xd8'
    pos=2; markers=[]; dqt=[]; dht=[]; sof=None; sos=None
    while pos<len(blob):
        assert blob[pos]==255
        marker=blob[pos+1];pos+=2
        if marker==0xd9:break
        length=int.from_bytes(blob[pos:pos+2],'big');data=blob[pos+2:pos+length]
        markers.append(marker)
        if marker==0xdb:dqt.append(data.hex())
        if marker==0xc4:dht.append(data.hex())
        if marker==0xc0:
            sof={'precision':data[0],'height':int.from_bytes(data[1:3],'big'),
                 'width':int.from_bytes(data[3:5],'big'),'components':data[5],
                 'component_specs':list(data[6:])}
        if marker==0xda:sos=data.hex();break
        pos+=length
    assert sof is not None and sof['precision']==8 and sof['components']==3
    assert 0xc2 not in markers
    return {'markers':[hex(x) for x in markers],'sof0':sof,'sos':sos,
      'dqt_sha256':hashlib.sha256(json.dumps(dqt).encode()).hexdigest(),
      'dht_sha256':hashlib.sha256(json.dumps(dht).encode()).hexdigest(),
      'restart_interval_marker':0xdd in markers}

def simulate_queue(sizes,bps):
    # All video bytes share one prefetch queue. Each frame is needed at its
    # content timestamp; prefix maxima give initial reserve for this trace.
    need=np.cumsum(sizes)-np.arange(len(sizes))*bps/FPS
    return {'initial_video_bytes_for_trace':float(max(0,np.max(need))),
            'initial_seconds_at_video_bps':float(max(0,np.max(need))/bps)}

def run_geometry(name):
    filename,w,h,y0,y1=GEOMETRIES[name]
    source=MEDIA/filename
    assert source.stat().st_size==FRAMES*w*h*3
    raw=np.memmap(source,dtype=np.uint8,mode='r',shape=(FRAMES,h,w,3))
    records=[]
    for q in QUALITIES:
        start=time.time(); sizes=[]; sse=0.; roi_sse=0.; frame_psnr=[]; headers=[]
        out=MEDIA/f'{name}_q{q}_420.mjpg'
        with out.open('wb') as f:
            for i in range(FRAMES):
                original=np.asarray(raw[i])
                buf=io.BytesIO()
                Image.fromarray(original).save(buf,format='JPEG',quality=q,subsampling=2,
                                              optimize=False,progressive=False)
                b=buf.getvalue();sizes.append(len(b));f.write(b)
                decoded=np.asarray(Image.open(io.BytesIO(b)),dtype=np.int16)
                diff=decoded-original.astype(np.int16)
                total=float(np.sum(diff.astype(np.float32)**2,dtype=np.float64));sse+=total
                roi_total=float(np.sum(diff[y0:y1].astype(np.float32)**2,dtype=np.float64));roi_sse+=roi_total
                frame_psnr.append(psnr(roi_total/((y1-y0)*w*3)))
                headers.append(jpeg_header(b))
        sizes=np.array(sizes,dtype=np.int64)
        assert len({x['dqt_sha256'] for x in headers})==1
        assert len({x['dht_sha256'] for x in headers})==1
        assert len({json.dumps(x['sof0']) for x in headers})==1
        windows={str(k):float(np.max(np.convolve(sizes,np.ones(k,dtype=np.int64),'valid'))*FPS/k*8/1e6) for k in [1,3,15,30]}
        rec={'geometry':name,'width':w,'height':h,'active_picture_height':y1-y0,
             'quality':q,'jpeg_subsampling':'4:2:0','huffman':'standard fixed tables',
             'progressive':False,'fps':FPS,'frames':FRAMES,'duration_s':FRAMES/FPS,
             'mean_frame_bytes':float(np.mean(sizes)),'p95_frame_bytes':float(np.percentile(sizes,95)),
             'max_frame_bytes':int(np.max(sizes)),'max_frame_index':int(np.argmax(sizes)),
             'min_frame_bytes':int(np.min(sizes)),'video_Mbps':float(np.sum(sizes)*8/(FRAMES/FPS)/1e6),
             'media_including_PCM_Mbps':float(np.sum(sizes)*8/(FRAMES/FPS)/1e6+.768),
             'window_peak_video_Mbps':windows,'full_frame_PSNR_RGB_dB':psnr(sse/(FRAMES*w*h*3)),
             'active_picture_PSNR_RGB_dB':psnr(roi_sse/(FRAMES*w*(y1-y0)*3)),
             'worst_frame_active_PSNR_dB':float(min(frame_psnr)),
             'slowest_frame_transfer_ms_at_video_budget':float(np.max(sizes)/BUDGET*1000),
             'sustainable_fps_at_budget_same_mean_frame':float(BUDGET/np.mean(sizes)),
             'sustainable_fps_at_service_less_audio_same_mean_frame':float((SERVICE-AUDIO)/np.mean(sizes)),
             'trace_queue_6Mbps':simulate_queue(sizes,750_000),
             'trace_queue_budget':simulate_queue(sizes,BUDGET),
             'profile':headers[0],'elapsed_s':time.time()-start,'path':str(out),'sha256':sha(out)}
        records.append(rec)
        with (RESULTS/f'{name}_q{q}_frames.csv').open('w',newline='',encoding='utf-8') as f:
            writer=csv.writer(f);writer.writerow(['frame','time_s','bytes','active_PSNR_RGB_dB'])
            writer.writerows((i,i/FPS,int(n),frame_psnr[i]) for i,n in enumerate(sizes))
        print(f"{name} q={q} video={rec['video_Mbps']:.3f}Mbps max={rec['max_frame_bytes']}B activePSNR={rec['active_picture_PSNR_RGB_dB']:.2f}dB elapsed={rec['elapsed_s']:.1f}s",flush=True)
    (RESULTS/f'{name}_summary.json').write_text(json.dumps(records,ensure_ascii=False,indent=2),encoding='utf-8')

def quantize(rgb,fmt):
    a=rgb.astype(np.uint16)
    if fmt=='RGB565':
        r=a[...,0]>>3;g=a[...,1]>>2;b=a[...,2]>>3
        out=np.stack([(r<<3)|(r>>2),(g<<2)|(g>>4),(b<<3)|(b>>2)],axis=-1)
    else:
        r=a[...,0]>>5;g=a[...,1]>>5;b=a[...,2]>>6
        out=np.stack([(r<<5)|(r<<2)|(r>>1),(g<<5)|(g<<2)|(g>>1),(b<<6)|(b<<4)|(b<<2)|b],axis=-1)
    return out.astype(np.uint8)

def quantization_ablation():
    raw=np.memmap(MEDIA/GEOMETRIES['letterbox640'][0],dtype=np.uint8,mode='r',shape=(FRAMES,480,640,3))
    result=[]
    for fmt in ['RGB565','RGB332']:
        sse=0.;roi_sse=0.
        for i in range(FRAMES):
            d=quantize(raw[i],fmt).astype(np.int16)-raw[i].astype(np.int16)
            sse+=float(np.sum(d.astype(np.float32)**2,dtype=np.float64))
            roi_sse+=float(np.sum(d[60:420].astype(np.float32)**2,dtype=np.float64))
        result.append({'format':fmt,'frames':FRAMES,'full_PSNR_RGB_dB':psnr(sse/(FRAMES*480*640*3)),
                       'active_PSNR_RGB_dB':psnr(roi_sse/(FRAMES*360*640*3)),
                       'method':'truncate bits then bit-replicate to RGB888; measured before JPEG'})
    (RESULTS/'rgb_quantization_ablation.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
    print(json.dumps(result),flush=True)

if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('geometry',choices=list(GEOMETRIES)+['quantization'])
    ap.add_argument('--fps',type=int,choices=[15,30],default=15)
    ap.add_argument('--qualities',nargs='+',type=int)
    a=ap.parse_args();FPS=a.fps;FRAMES=20*FPS
    if a.qualities:QUALITIES=a.qualities
    if a.geometry=='quantization':quantization_ablation()
    else:run_geometry(a.geometry)
