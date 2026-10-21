from random import Random

rng=Random(0xC11314)
def original(w,h):
    a=(-h)&0xffffffff if h&0x80000000 else h
    return (w==0 or w>1024), (a==0 or h==0x80000000 or a>768), (w&0x7ff), (a&0x3ff), bool(h>>31)
def compressed(w,h):
    wl=w&0x7ff; wh=bool(w>>11)
    hl=h&0x3ff; sign=bool(h>>31)
    high=(h>>10)&0x1fffff
    high_one=bool(high)
    high_zero=high!=0x1fffff
    a=(-hl)&0x3ff if sign else hl
    height_bad=((high_zero and sign) or (high_one and not sign) or a==0 or (sign and hl==0) or a>768)
    return (not (wl or wh) or wh or wl>1024),height_bad,wl,a,sign
values=[0,1,768,769,1023,1024,1025,2047,2048,0x7fffffff,0x80000000,0x80000001,0xfffffd00,0xffffffff]
for w in values:
 for h in values:
  if original(w,h)!=compressed(w,h): raise SystemExit(f'mismatch {w:08x} {h:08x} {original(w,h)} {compressed(w,h)}')
for _ in range(500000):
 w=rng.getrandbits(32); h=rng.getrandbits(32)
 if original(w,h)!=compressed(w,h): raise SystemExit(f'mismatch {w:08x} {h:08x} {original(w,h)} {compressed(w,h)}')
print('BMP_HEADER_COMPRESSION_EQ PASS boundary_pairs=196 random_pairs=500000 predicates=width,height,scale_lowbits,sign')
