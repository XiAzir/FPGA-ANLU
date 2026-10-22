from pathlib import Path
import struct,sys,contextlib,json
root=Path(__file__).resolve().parents[2]
work=Path(__file__).resolve().parent
sys.path.insert(0,str(root/'development/video19_work/stream_frontend'))
import build_card_fixture as fixture
samples=work/'mode_media';samples.mkdir(exist_ok=True)
for i in range(4):
 rgb=bytes((40+i*30,80+i*20,160-i*20))*16*16
 bmp=struct.pack('<2sIHHI',b'BM',54+len(rgb),0,0,54)+struct.pack('<IiiHHIIiiII',40,16,16,1,24,0,len(rgb),2835,2835,0,0)+rgb
 (samples/f'0{i}_TEST.BMP').write_bytes(bmp)
def validate(name,data):
 assert data[:2]==b'BM' and struct.unpack_from('<iiHHI',data,18)==(16,16,1,24,0)
 assert len(data)==822
fixture.HERE=work/'mode_fixture'
fixture.MJP_PATH=root/'development/video19_work/media_q90_trial/output/VIDEO.MJP'
fixture.WAV_PATH=root/'development/video19_work/media_q90_trial/output/TEST.WAV'
fixture.BMP_SOURCES=[(f'0{i}_TEST.BMP',samples/f'0{i}_TEST.BMP') for i in range(4)]
fixture.validate_bmp=validate
fixture.HERE.mkdir(exist_ok=True)
with (fixture.HERE/'generation.log').open('w',encoding='utf-8') as log,contextlib.redirect_stdout(log): fixture.build()
print(fixture.HERE/'card_image')
