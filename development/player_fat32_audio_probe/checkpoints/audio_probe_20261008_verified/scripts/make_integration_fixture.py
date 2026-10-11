"""Sparse, synthetic FAT32 card; no real drive access and no user media edits."""
import argparse
import struct
from pathlib import Path

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--width',type=int,default=16)
    ap.add_argument('--height',type=int,default=64)
    ap.add_argument('--output',type=Path,required=True)
    args=ap.parse_args()
    out=args.output; out.mkdir(parents=True,exist_ok=True)
    part=2048; reserved=32; fat_size=600; spc=8; clusters=70000
    total=reserved+2*fat_size+clusters*spc
    fat_lba=part+reserved; data_lba=fat_lba+2*fat_size
    sectors={}
    def sec(lba): return sectors.setdefault(lba,bytearray(512))
    def u16(b,o,v): struct.pack_into('<H',b,o,v)
    def u32(b,o,v): struct.pack_into('<I',b,o,v)
    m=sec(0)
    # A real MBR contains executable boot code where a VBR holds its BPB.
    # In particular bytes11/12 must not be assumed zero for MBR detection.
    m[0:16]=bytes.fromhex('33c08ed0bc007c8ec08ed8be007cbf00')
    m[446+4]=12; u32(m,446+8,part); u32(m,446+12,total); m[510:512]=b'\x55\xaa'
    b=sec(part); b[0:3]=b'\xeb\x58\x90'; b[3:11]=b'FATSIM  '
    u16(b,11,512); b[13]=spc; u16(b,14,reserved); b[16]=2; b[21]=0xf8
    u32(b,28,part); u32(b,32,total); u32(b,36,fat_size); u32(b,44,2)
    u16(b,48,1); u16(b,50,6); b[82:90]=b'FAT32   '; b[510:512]=b'\x55\xaa'
    def fat(c,n): u32(sec(fat_lba+c//128),(c%128)*4,n)
    fat(0,0x0ffffff8); fat(1,0x0fffffff); fat(2,0x0fffffff)
    root=sec(data_lba)
    # Deleted entry, long-name fragment and directory must not become files.
    root[0]=0xe5; root[32:43]=b'BADNAME BMP'; root[32+11]=0x0f
    root[64:75]=b'FOLDER  BMP'; root[64+11]=0x10
    def entry(slot,name,start,size):
        o=slot*32; root[o:o+11]=name; root[o+11]=0x20
        u16(root,o+20,start>>16); u16(root,o+26,start&65535); u32(root,o+28,size)
    golden=[]
    pixel_count=args.width*args.height
    for image,start in enumerate([10,1000]):
        # Small case has pixels after a whole cluster to exercise header skip.
        offset=4000 if args.width==16 else 54
        bmp=bytearray(offset+pixel_count*3+7)
        bmp[0:2]=b'BM'; u32(bmp,2,len(bmp)); u32(bmp,10,offset); u32(bmp,14,40)
        u32(bmp,18,args.width); u32(bmp,22,args.height); u16(bmp,26,1); u16(bmp,28,24)
        u32(bmp,34,pixel_count*3)
        for p in range(pixel_count):
            x=p%args.width; y=p//args.width
            r=(x*3+y*7+image*59)&255; g=(x*11+y*5+image*83)&255; blue=(x*17+y*13+image*101)&255
            bmp[offset+3*p:offset+3*p+3]=bytes([blue,g,r]); golden.append((r<<16)|(g<<8)|blue)
        bmp[-7:]=b'TRAILER'
        entry(3+image,b'PIC0    BMP' if image==0 else b'PIC1    BMP',start,len(bmp))
        write_file(bmp,start,2,spc,data_lba,sec,fat)
    # JUNK length489 means fmt chunk header starts at byte510 (cross-sector).
    pcm=b''.join(struct.pack('<H',(i*173+0x8123)&65535) for i in range(2300))
    fmt=struct.pack('<HHIIHHH',1,1,48000,96000,2,16,0)
    chunks=b'JUNK'+struct.pack('<I',489)+b'J'*489+b'\0'+b'fmt '+struct.pack('<I',len(fmt))+fmt+b'data'+struct.pack('<I',len(pcm))+pcm
    wave=b'RIFF'+struct.pack('<I',len(chunks)+4)+b'WAVE'+chunks
    entry(5,b'TEST    WAV',5000,len(wave))
    write_file(wave,5000,3,spc,data_lba,sec,fat)
    ordered=sorted(sectors)
    (out/'lbas.hex').write_text('\n'.join(f'{lba:08x}' for lba in ordered)+'\n')
    (out/'sectors.hex').write_text('\n'.join(f'{v:02x}' for lba in ordered for v in sectors[lba])+'\n')
    (out/'pixels.hex').write_text('\n'.join(f'{v:06x}' for v in golden)+'\n')
    (out/'samples.hex').write_text('\n'.join(f'{(i*173+0x8123)&65535:04x}' for i in range(2300))+'\n')
    (out/'config.vh').write_text(f'`define FIXTURE_SECTORS {len(ordered)}\n')
    print(f'Fixture: {args.width}x{args.height}, {len(ordered)} sparse sectors, two fragmented BMPs and cross-sector RIFF/WAV')

def write_file(content,start,step,spc,data_lba,sec,fat):
    cluster_bytes=spc*512
    count=(len(content)+cluster_bytes-1)//cluster_bytes
    for n in range(count):
        c=start+n*step
        fat(c,start+(n+1)*step if n+1<count else 0x0fffffff)
        for s in range(spc):
            p=n*cluster_bytes+s*512
            if p>=len(content): break
            data=content[p:p+512]
            dest=sec(data_lba+(c-2)*spc+s); dest[:]=b'\xa7'*512; dest[:len(data)]=data

if __name__=='__main__': main()
