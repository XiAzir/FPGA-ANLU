from pathlib import Path
import subprocess,json,hashlib,re,sys

ROOT=Path(__file__).resolve().parents[2]
HERE=Path(__file__).parent
OUT=HERE/'native'
OUT.mkdir(exist_ok=True)
PYTHON=Path('C:/Users/PENGYUHAO/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/python.exe')
variant=sys.argv[1] if len(sys.argv)>1 else 'gradient'
MAKE='''from PIL import Image
import io
from pathlib import Path
import sys
im=Image.new('RGB',(16,16))
for y in range(16):
 for x in range(16):
  if sys.argv[1]=='solid':rgb=(105,150,190)
  elif sys.argv[1]=='blocks':rgb=((x//8)*190+20,(y//8)*160+30,80)
  else:rgb=((x*13+y*7)%256,(x*5+y*19)%256,(x*23+y*3)%256)
  im.putpixel((x,y),rgb)
b=io.BytesIO();im.save(b,format='JPEG',quality=65,subsampling=2,optimize=False,progressive=False)
blob=b.getvalue();p=Path('development/video34_work/native');(p/'fixture.jpg').write_bytes(blob)
(p/'fixture.hex').write_text(''.join(f'{v:02x}\\n' for v in blob),encoding='ascii')
'''
subprocess.run([str(PYTHON),'-c',MAKE,variant],cwd=ROOT,check=True)
(OUT/f'fixture_{variant}.jpg').write_bytes((OUT/'fixture.jpg').read_bytes())
candidate=ROOT/'development/player_video34_1080p15/src/user_source/hdl_source/jpeg'
baseline=ROOT/'development/player_video32_read_return/src/user_source/hdl_source/jpeg'
reference_dir=OUT/'c32_source'
reference_dir.mkdir(exist_ok=True)
reference_inputs=sorted(baseline.glob('*.v'))
module_names=[]
for path in reference_inputs:
    module_names.extend(re.findall(rb'^\s*module\s+(\w+)',path.read_bytes(),re.M))
module_pattern=re.compile(rb'\b(?:'+b'|'.join(module_names)+rb')\b')
references=[]
for path in reference_inputs:
    output=reference_dir/path.name
    output.write_bytes(module_pattern.sub(lambda m:m.group(0)+b'_c32',path.read_bytes()))
    references.append(output)
length=(OUT/'fixture.jpg').stat().st_size
iv=ROOT/'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
vvp=iv.with_name('vvp.exe')
source_files=sorted(candidate.glob('*.v'))
source_hashes={str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in source_files}
program=OUT/'native.vvp'
block_buffer=candidate.parent/'idct_yuv420_block_buffer.v'
subprocess.run([str(iv),'-g2012','-s','tb_native_jpeg',f'-Ptb_native_jpeg.LENGTH={length}','-o',str(program),str(HERE/'tb_native_jpeg.v'),str(block_buffer),*[str(p) for p in references],*[str(p) for p in source_files]],cwd=ROOT,check=True)
r=subprocess.run([str(vvp),str(program)],cwd=ROOT,capture_output=True,text=True)
(OUT/'compare.log').write_text(r.stdout+r.stderr,encoding='utf-8')
(OUT/f'compare_{variant}.log').write_text(r.stdout+r.stderr,encoding='utf-8')
print(r.stdout+r.stderr)
if r.returncode or 'PASS RGB_pixels=' not in r.stdout: raise RuntimeError('Native JPEG comparison failed')
(OUT/f'source_binding_{variant}.json').write_text(json.dumps({'fixture_bytes':length,'fixture_sha256':hashlib.sha256((OUT/'fixture.jpg').read_bytes()).hexdigest(),'sources':source_hashes,'block_buffer_sha256':hashlib.sha256(block_buffer.read_bytes()).hexdigest()},indent=2),encoding='utf-8')
