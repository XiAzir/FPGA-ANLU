from pathlib import Path
import wave,struct,zlib,json,hashlib
p=Path(__file__).resolve().parents[2];root=p.parents[1]
wav=root/'deliverables/real_music_20261008/card/TEST.WAV'
with wave.open(str(wav)) as w:
    assert (w.getframerate(),w.getsampwidth(),w.getnchannels())==(48000,2,1)
    pcm=struct.unpack('<'+'h'*w.getnframes(),w.readframes(w.getnframes()))
env=0;sum_abs=0;count=0;i=0;hist=[0]*128;visible=list(hist)
for frame in range(1,1906):
    boundary=frame*420000
    # Only samples strictly before this VS enter its snapshot, matching NBA
    # ordering for a sample accepted on the same clock as VS.
    while (i+1)*25000000 < boundary*48000:
        sum_abs+=abs(pcm[i]);count+=1;i+=1
        if count==256:
            target=(sum_abs//256)*16
            env=env+(target-env+15)//16 if target>=env else env-(env-target+63)//64
            count=0;sum_abs=0
    visible=hist[:]
    height=env//128 if env<=65536 else 512+(env-65536)//512
    hist=hist[1:]+[min(832,height)]
curve=[]
for x in range(512):
    s,k=divmod(x,4);a,b,c,d=[visible[max(0,min(127,t))] for t in [s-1,s,s+1,s+2]]
    weights=[(0,128,0,0),(-9,111,29,-3),(-8,72,72,-8),(-3,29,111,-9)][k]
    value=sum(q*v for q,v in zip(weights,(a,b,c,d)))//128
    curve.append(max(min(b,c),min(max(b,c),value)))
W,H=640,104;bg=(7,11,18);pixels=bytearray(W*H*3)
def put(x,y,color):
    if 0<=x<W and 0<=y<H:pixels[(y*W+x)*3:(y*W+x)*3+3]=bytes(color)
for y in range(H):
    for x in range(W):
        color=bg if 16<x<623 and 0<y<103 else (0,0,0)
        if 64<=x<576 and 36<=y<=92:
            height=curve[x-64];dist=abs((88-y)*16-height)
            if dist<16:color=tuple(b+(16-dist)*d//16 for b,d in zip(bg,(65,209,192)))
            elif dist<32:color=tuple(b+(32-dist)*d//16 for b,d in zip(bg,(4,13,12)))
            elif y==88:color=(23,33,44)
        put(x,y,color)
glyph={'E':[31,16,16,30,16,16,31],'N':[17,25,21,19,17,17,17],'V':[17,17,17,17,17,10,4],
       'W':[17,17,17,21,21,21,10],'A':[14,17,17,31,17,17,17]}
for idx,ch in enumerate('ENV WAV'):
    for r,bits in enumerate(glyph.get(ch,[0]*7)):
        for c in range(5):
            if bits & (1<<(4-c)):
                for yy in range(2):
                    for xx in range(2):put(24+idx*16+c*2+xx,8+r*2+yy,(255,255,255))
def chunk(k,data):return struct.pack('>I',len(data))+k+data+struct.pack('>I',zlib.crc32(k+data)&0xffffffff)
raw=b''.join(b'\0'+pixels[y*W*3:(y+1)*W*3] for y in range(H))
path=p/'build/model/envelope_offline_preview.png'
path.write_bytes(b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',struct.pack('>IIBBBBB',W,H,8,2,0,0,0))+chunk(b'IDAT',zlib.compress(raw))+chunk(b'IEND',b''))
(path.with_suffix('.json')).write_text(json.dumps({'kind':'OFFLINE_REFERENCE_RENDER_NOT_BOARD_PHOTO','inputWav':str(wav),
    'inputSha256':hashlib.sha256(wav.read_bytes()).hexdigest().upper(),'snapshotNominalSeconds':1905*420000/25000000,
    'columns':512,'history':128,'curveQ4':curve,'imageSha256':hashlib.sha256(path.read_bytes()).hexdigest().upper()},indent=2),encoding='utf-8')
print(path)
