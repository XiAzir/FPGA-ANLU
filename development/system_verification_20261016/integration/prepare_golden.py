"""Read BMP/PCM fixtures independently; do not reproduce the RTL file parser."""
import struct,json,hashlib
from pathlib import Path

def sha(data):return hashlib.sha256(data).hexdigest()
def prepare(card,out):
 manifest=json.loads((card/'manifest.json').read_text(encoding='utf-8'))
 bmp=(card/'gold_bmp.bin').read_bytes()
 if sha(bmp)!=manifest['files']['PIC.BMP']['sha256']:raise ValueError('BMP fixture SHA mismatch')
 if sha((card/'wave_samples.mem').read_bytes())!=manifest['wave_samples_mem_sha256']:raise ValueError('PCM fixture SHA mismatch')
 offset=struct.unpack_from('<I',bmp,10)[0]
 width,height=struct.unpack_from('<ii',bmp,18)
 planes,depth=struct.unpack_from('<HH',bmp,26)
 compression=struct.unpack_from('<I',bmp,30)[0]
 if (bmp[:2],width,abs(height),planes,depth,compression)!=(b'BM',16,16,1,24,0):raise ValueError('Unexpected fixture format')
 stride=(width*3+3)//4*4
 rgb=[]
 for y in range(abs(height)):
  row=(abs(height)-1-y) if height>0 else y
  for x in range(width):
   b,g,r=bmp[offset+row*stride+x*3:offset+row*stride+x*3+3]
   rgb.append((r<<16)|(g<<8)|b)
 (out/'source_rgb.mem').write_text(''.join(f'{v:06x}\n' for v in rgb),encoding='ascii')
 (out/'golden_receipt.json').write_text(json.dumps(dict(bmp_sha256=sha(bmp),pcm_window_sha256=manifest['wave_source']['window_sha256'],bmp_dimensions=[width,height],source_rgb_sha256=sha((out/'source_rgb.mem').read_bytes()),method='Independent BMP struct decoding, top-down source pixels; display uses aspect-preserving nearest-neighbor centered rectangle'),indent=2))
