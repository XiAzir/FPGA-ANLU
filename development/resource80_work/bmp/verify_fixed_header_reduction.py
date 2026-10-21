from random import Random
rng=Random(0x80C11314)
def old_fields(magic,planes,bits,compression):
 return magic==0x4d42, planes==1, bits==24, compression==0
def reduced_fields(magic,planes,bits,compression):
 mb=lambda v,n: (v>>(8*n))&255
 return (mb(magic,0)==0x42 and mb(magic,1)==0x4d,
         mb(planes,0)==1 and mb(planes,1)==0,
         mb(bits,0)==24 and mb(bits,1)==0,
         all(mb(compression,n)==0 for n in range(4)))
for _ in range(500000):
 vals=(rng.getrandbits(16),rng.getrandbits(16),rng.getrandbits(16),rng.getrandbits(32))
 if old_fields(*vals)!=reduced_fields(*vals): raise SystemExit(f'fixed-header mismatch {vals}')
print('BMP_FIXED_HEADER_REDUCTION_EQ PASS random_headers=500000 fields=magic,planes,bits,compression')
