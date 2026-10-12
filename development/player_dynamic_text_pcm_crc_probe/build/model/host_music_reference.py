from pathlib import Path
import hashlib, json, struct, binascii

project = Path(__file__).resolve().parents[4]
p = project / 'deliverables/real_music_20261008/card/TEST.WAV'
raw = p.read_bytes()
assert raw[:4] == b'RIFF' and raw[8:12] == b'WAVE'
pos = 12
payload = fmt = None
while pos + 8 <= len(raw):
    tag, size = raw[pos:pos+4], struct.unpack_from('<I', raw, pos+4)[0]
    if tag == b'fmt ': fmt = struct.unpack_from('<HHIIHH', raw, pos+8)
    if tag == b'data': offset, payload = pos+8, raw[pos+8:pos+8+size]
    pos += 8 + size + (size & 1)
assert fmt == (1,1,48000,96000,2,16) and payload and len(payload) % 2 == 0
n = 32768
skip = 65536
prefix = (payload * ((2*(skip+n) + len(payload)-1)//len(payload)))[2*skip:2*(skip+n)]
assert binascii.crc_hqx(b'123456789', 0xffff) == 0x29b1
crc = binascii.crc_hqx(prefix, 0xffff)
record = {'source': str(p), 'sha256': hashlib.sha256(raw).hexdigest(),
          'file_bytes': len(raw), 'data_offset': offset, 'first_high_byte_position': offset+2*skip+1,
          'payload_bytes': len(payload), 'prefix_samples': n,
          'skip_samples': skip,
          'window_first_sample': skip, 'window_last_sample':skip+n-1,
          'nonzero_samples': sum(x!=0 for x in struct.unpack('<'+'h'*n,prefix)),
          'byte_order': 'PCM16 little endian: low byte then high byte',
          'crc_algorithm': 'CRC-16/CCITT-FALSE; poly1021 initFFFF no final xor',
          'prefix_crc16_hex': f'{crc:04X}', 'prefix_sha256': hashlib.sha256(prefix).hexdigest(),
          'expected_complete_pages': {'6':f'6700{crc:04X}','7':f'7700{crc:04X}',
             '8':f'8700{crc:04X}','9':'97000000','A':'A7008000',
             'B':f'B7{offset+2*skip+1:06X}','C':f'C7{offset:06X}','D':'DFC11108'},
          'limit': 'Local delivered music reference, not a fresh hash of the remote TF card. CRC16 can collide.'}
(Path(__file__).resolve().parent/'host_music_reference.json').write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(record,ensure_ascii=False,indent=2))
