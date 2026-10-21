from pathlib import Path
import json
checks=0
for w in range(1,1025):
 stride=(3*w+3)//4*4
 assert 3*w<=stride<=3*w+3
 for h in range(1,769):
  image_bytes=stride*h
  # Affine addresses increase in row and column. The maximal legal pair
  # bounds every source byte; choose the largest valid 32-bit offset too.
  offset=(1<<32)-1-image_bytes
  row_base=offset+stride*(h-1)
  last_byte=row_base+3*(w-1)+2
  file_size=offset+image_bytes
  assert 0<=row_base<=last_byte<file_size<(1<<32)
  checks+=1
result={'status':'PASS','geometry_pairs':checks,'width':[1,1024],'height':[1,768],
 'proof':'Affine monotonic row/column bounds; stride=ceil(3*w/4)*4 >=3*w; max byte offset is stride*(h-1)+3*w-1 <stride*h. Any accepted offset+image_bytes <=file_size <=2^32-1 implies row and byte adders cannot overflow and byte<file_size.'}
(Path(__file__).parent/'bmp_extent_proof.json').write_text(json.dumps(result,indent=2));print(json.dumps(result))
