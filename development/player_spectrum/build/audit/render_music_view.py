from pathlib import Path
import sys,wave,struct
p=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(p/'sim'))
from spectrum_oracle import fixed_fft,band_proxy
from spectrum_render_gold import magnitude_height,smooth,pixel
music=p.parents[1]/'deliverables/real_music_20261008/card/TEST.WAV'
levels=[0]*24;peaks=[0]*24;holds=[0]*24
with wave.open(str(music)) as w:
    assert w.getframerate()==48000 and w.getnchannels()==1 and w.getsampwidth()==2
    for n in range(32):
        w.setpos(round((40.0+n/42.5)*48000))
        raw=w.readframes(1024)
        target=[magnitude_height(v) for v in band_proxy(fixed_fft(struct.unpack('<1024h',raw)))]
        for i in range(24):
            levels[i]=smooth(levels[i],target[i])
            if levels[i]>=peaks[i]:peaks[i]=levels[i];holds[i]=10 if levels[i] else 0
            elif holds[i]:holds[i]-=1
            else:peaks[i]=max(levels[i],peaks[i]-2)
out=p/'build/model/real_music_preview.ppm'
image=bytearray()
for y in range(296,432):
    for x in range(640):
        rgb=pixel(x,y,True,0x202a35,levels,peaks)
        image.extend(((rgb>>16)&255,(rgb>>8)&255,rgb&255))
out.write_bytes(b'P6\n640 136\n255\n'+image)
print(out)
