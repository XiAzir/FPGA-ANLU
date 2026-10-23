"""Decode C11329 passive observations; command-line arguments are hex pages."""
import json
import sys

def bits(value, names):
    return {name:bool(value & (1 << i)) for i,name in enumerate(reversed(names))}

def decode(text):
    word=int(text,16)
    assert 0<=word<=0xffffffff
    page=word>>28
    out={'hex':f'{word:08X}','page':f'{page:X}'}
    if page==3:
        out.update(acr_n=(word>>8)&0xfffff,bad_bch_previous_sec=word&255)
    elif page==5:
        out.update(returned_words=(word>>1)&0x7ffff,
            flags=bits((word>>20)&255, ['app_read','returned','nonzero_read',
              'app_write','nonzero_write','count_mismatch','reserved1','reserved0']))
    elif page==6:
        out.update(memory_hex=f'{(word>>12)&0xffff:04X}',reader_state=(word>>8)&15,
            pixel_flags=bits(word&255,['osd_valid','source_valid','read_req','read_ack',
              'fifo_clear','underflow_seen','raw_nonzero_seen','gated_nonzero_seen']))
    elif page==14:
        out.update(samples_previous_sec=(word>>8)&0xffff,bad_terc_previous_sec=word&255,
            flags=bits((word>>24)&15,['island_seen','audio_seen','acr_seen','format_bad_seen']))
    elif page==15:
        out.update(acr_cts=(word>>8)&0xfffff,tone_bad_previous_sec=word&255)
    else:
        out['note']='Use retained C22/C26 file/PCM/control page definitions.'
    return out

if __name__=='__main__':
    print(json.dumps([decode(arg) for arg in sys.argv[1:]],ensure_ascii=False,indent=2))
