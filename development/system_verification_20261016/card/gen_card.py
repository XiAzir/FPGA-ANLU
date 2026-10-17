#!/usr/bin/env python3
"""Build a sparse 64 MiB FAT32 SD test image as sparse readmemh bytes."""
import hashlib, json, math, struct, wave
from pathlib import Path

HERE = Path(__file__).resolve().parent
PROJECT = Path(__file__).resolve().parents[3]
SOURCE_WAV = PROJECT / "deliverables/real_music_20261008/card/TEST.WAV"
IMAGE_BYTES = 64 * 1024 * 1024
TOTAL_SECTORS = IMAGE_BYTES // 512
PART_START = 2048
VOL_SECTORS = TOTAL_SECTORS - PART_START
RESERVED = 32
FATS = 2
FAT_SECTORS = 1024
CLUSTERS = VOL_SECTORS - RESERVED - FATS * FAT_SECTORS
DATA_START_REL = RESERVED + FATS * FAT_SECTORS

def sha(data): return hashlib.sha256(data).hexdigest()
def put16(b, o, v): struct.pack_into('<H', b, o, v)
def put32(b, o, v): struct.pack_into('<I', b, o, v)

def bmp_bytes():
    w = h = 16
    row = ((w * 3 + 3) // 4) * 4
    pix = bytearray()
    # Bottom-up 24-bit BMP: deterministic eight-color tile/checker pattern.
    colors = [(220,35,35),(30,190,65),(35,80,225),(240,205,35),
              (190,45,200),(25,190,200),(245,120,25),(235,235,235)]
    for y in range(h):
        r = bytearray()
        for x in range(w):
            R,G,B = colors[((x//4) + 2*(y//4)) % len(colors)]
            r += bytes((B,G,R))
        r += b'\0' * (row - len(r)); pix[0:0] = r
    off = 54
    out = bytearray(off + len(pix))
    out[0:2] = b'BM'; put32(out,2,len(out)); put32(out,10,off)
    put32(out,14,40); put32(out,18,w); put32(out,22,h)
    put16(out,26,1); put16(out,28,24); put32(out,34,len(pix))
    put32(out,38,2835); put32(out,42,2835)
    out[off:] = pix
    return bytes(out)

def wav_window():
    raw = SOURCE_WAV.read_bytes()
    with wave.open(str(SOURCE_WAV), 'rb') as wf:
        assert (wf.getnchannels(), wf.getsampwidth(), wf.getframerate()) == (1,2,48000)
        pcm = wf.readframes(wf.getnframes())
    offset, samples = 262144, 4096
    chunk = pcm[offset:offset+samples*2]
    assert len(chunk)==samples*2 and any(chunk)
    vals = struct.unpack('<%dh' % samples, chunk)
    assert sum(v != 0 for v in vals) > 4000
    # standard 44-byte PCM WAV, mono 48kHz signed 16-bit.
    hdr = struct.pack('<4sI4s4sIHHIIHH4sI', b'RIFF',36+len(chunk),b'WAVE',b'fmt ',16,
                      1,1,48000,96000,2,16,b'data',len(chunk))
    return raw, offset, samples, hdr+chunk, chunk

def entry(name, ext, attr, cluster, size):
    b=bytearray(32); b[0:8]=name.ljust(8,b' '); b[8:11]=ext.ljust(3,b' '); b[11]=attr
    put16(b,20,(cluster>>16)&0xffff); put16(b,26,cluster&0xffff); put32(b,28,size)
    return b

def build():
    assert CLUSTERS >= 65525, CLUSTERS
    image = {}
    def sector(lba, data):
        assert len(data)==512
        image[lba]=bytes(data)
    mbr=bytearray(512); p=446
    mbr[p+4]=0x0c; put32(mbr,p+8,PART_START); put32(mbr,p+12,VOL_SECTORS)
    mbr[510:512]=b'\x55\xaa'; sector(0,mbr)
    v=bytearray(512); v[0:3]=b'\xeb\x58\x90'; v[3:11]=b'MSDOS5.0'
    put16(v,11,512); v[13]=1; put16(v,14,RESERVED); v[16]=FATS; put16(v,17,0); put16(v,19,0)
    v[21]=0xf8; put16(v,22,0); put16(v,24,63); put16(v,26,255); put32(v,28,PART_START)
    put32(v,32,VOL_SECTORS); put32(v,36,FAT_SECTORS); put16(v,40,0); put16(v,42,0)
    put32(v,44,2); put16(v,48,1); put16(v,50,6); v[64]=0x80; v[66]=0x29
    put32(v,67,0x26101601); v[71:82]=b'FPGA TEST  '; v[82:90]=b'FAT32   '; v[510:512]=b'\x55\xaa'
    sector(PART_START,v)
    backup=bytearray(v); sector(PART_START+6,backup)
    fsinfo=bytearray(512); fsinfo[0:4]=b'RRaA'; fsinfo[484:488]=b'rrAa'
    put32(fsinfo,488,CLUSTERS-3); put32(fsinfo,492,5); fsinfo[510:512]=b'\x55\xaa'
    sector(PART_START+1,fsinfo); sector(PART_START+7,fsinfo)
    # FAT 2 reserved, root=2, IMAGE directory=3, WAV=4..20, BMP=21..22.
    fat=bytearray(FAT_SECTORS*512)
    for c,val in [(0,0x0ffffff8),(1,0x0fffffff),(2,0x0fffffff),(3,0x0fffffff),(21,22),(22,0x0fffffff)]: put32(fat,c*4,val)
    for c in range(4,20): put32(fat,c*4,c+1)
    put32(fat,20*4,0x0fffffff)
    for fi in range(FATS):
        base=PART_START+RESERVED+fi*FAT_SECTORS
        for i in range(FAT_SECTORS): sector(base+i,fat[i*512:(i+1)*512])
    bmp=bmp_bytes(); _,off,samples,wav,pcm=wav_window()
    root=bytearray(512); root[:32]=entry(b'PIC',b'BMP',0x20,21,len(bmp)); root[32:64]=entry(b'TEST',b'WAV',0x20,4,len(wav))
    root[64]=0
    data_lba=PART_START+DATA_START_REL
    sector(data_lba,root)
    for cl in range(4,21):
        data=wav[(cl-4)*512:(cl-3)*512]
        sector(data_lba+(cl-2),data+b'\0'*(512-len(data)))
    for cl in (21,22):
        data=bmp[(cl-21)*512:(cl-20)*512]
        sector(data_lba+(cl-2),data+b'\0'*(512-len(data)))
    # Keep the original sparse byte image for inspection, and also emit compact
    # sector records with an explicit LBA map for simulators with large arrays.
    out=HERE/'card.mem'
    with out.open('w',newline='\n') as f:
        for lba,data in sorted(image.items()):
            base=lba*512
            f.write('@%08x\n'%base)
            f.writelines('%02x\n'%b for b in data)
    packed=HERE/'packed_mem.mem'; lba_file=HERE/'lba_map.mem'
    with packed.open('w',newline='\n') as pf, lba_file.open('w',newline='\n') as lf:
        for lba,data in sorted(image.items()):
            lf.write('%08x\n'%lba)
            pf.write(data.hex()+'\n')
    (HERE/'expected_sectors.mem').write_text(
        ''.join('%02x\n'%b for lba in (0,4130) for b in image[lba]),encoding='ascii')
    wavraw=SOURCE_WAV.read_bytes(); (HERE/'wave_samples.mem').write_text(''.join('%02x\n'%b for b in pcm),encoding='ascii')
    (HERE/'gold_bmp.bin').write_bytes(bmp)
    manifest={
      'format':'FAT32 MBR, partition LBA 2048, 512-byte sectors, one sector/cluster',
      'image_bytes':IMAGE_BYTES,'image_hex_file':'card.mem','packed_sector_file':'packed_mem.mem',
      'lba_map_file':'lba_map.mem','expected_unit_sectors_file':'expected_sectors.mem',
      'populated_sectors':len(image),
      'fat32_cluster_count':CLUSTERS,'fat32_fats':FATS,'fat32_fat_sectors':FAT_SECTORS,
      'files':{'PIC.BMP':{'bytes':len(bmp),'sha256':sha(bmp),'gold':'gold_bmp.bin'},
               'TEST.WAV':{'bytes':len(wav),'sha256':sha(wav),'format':'PCM16 mono 48kHz test window'}},
      'wave_source':{'path':'deliverables/real_music_20261008/card/TEST.WAV','sha256':sha(wavraw),
                     'data_payload_byte_offset':off,'sample_count':samples,
                     'nonzero_samples':sum(v!=0 for v in struct.unpack('<%dh'%samples,pcm)),
                     'window_sha256':sha(pcm),'scope':'非完整原曲，仅用于测试窗口'},
      'wave_samples_mem_sha256':sha((HERE/'wave_samples.mem').read_bytes()),
      'packed_sector_sha256':sha(packed.read_bytes()),'lba_map_sha256':sha(lba_file.read_bytes()),
      'expected_unit_sectors_sha256':sha((HERE/'expected_sectors.mem').read_bytes()),
      'sector_layout':{'mbr':0,'vbr':PART_START,'root_dir':PART_START+DATA_START_REL,
                       'wav_data':PART_START+DATA_START_REL+2,
                       'bmp_data_first':PART_START+DATA_START_REL+(21-2),
                       'bmp_data_second':PART_START+DATA_START_REL+(22-2)}
    }
    (HERE/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(manifest,ensure_ascii=False,indent=2))

if __name__=='__main__': build()
