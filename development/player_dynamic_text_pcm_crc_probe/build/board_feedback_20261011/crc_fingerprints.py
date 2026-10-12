from pathlib import Path
from array import array
import binascii, json, sys, hashlib

root=Path(__file__).resolve().parents[4]
raw=(root/'deliverables/real_music_20261008/card/TEST.WAV').read_bytes()
assert hashlib.sha256(raw).hexdigest()=='d5244fd3935052a743379d9331ee78109c8a913241ed60de472cb9e34a17fecf'
data=raw[44:]
samples=array('H');samples.frombytes(data)
if sys.byteorder!='little': samples.byteswap()
start,n,target=65536,32768,0xD2D6
window=samples[start:start+n]
def crc(a):
    a=array('H',a)
    if sys.byteorder!='little': a.byteswap()
    return binascii.crc_hqx(a.tobytes(),0xffff)
results={'original':crc(window),'byteswap':crc([(x>>8)|((x&255)<<8) for x in window])}
for bit in range(16):
    mask=1<<bit
    for kind,f in [('zero',lambda x:x&~mask),('one',lambda x:x|mask),('invert',lambda x:x^mask)]:
        results[f'bit{bit}_{kind}']=crc(map(f,window))
for shift in range(-16,17): results[f'ordinal_shift_{shift}']=crc(samples[start+shift:start+shift+n])
for phase in range(2):
    results[f'every_sample_repeated_twice_phase{phase}']=crc(samples[(start+i+phase)//2] for i in range(n))
    results[f'every_other_sample_phase{phase}']=crc(samples[2*(start+i)+phase] for i in range(n))
for k in range(1,8):
    results[f'arithmetic_right{k}']=crc((((x if x<32768 else x-65536)>>k)&65535) for x in window)
    results[f'left{k}']=crc((x<<k)&65535 for x in window)
matches=[k for k,v in results.items() if v==target]
report={'target':'D2D6','expected':'F485','matches':matches,'tested':{k:f'{v:04X}' for k,v in results.items()},
        'boundary':'Hypothesis fingerprints only; CRC16 collisions and time-varying faults possible. No board waveform measured.'}
(Path(__file__).parent/'crc_fingerprints.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
print(json.dumps({'matches':matches,'original':f"{results['original']:04X}",'tested':len(results)}))
