from pathlib import Path
from pypdf import PdfReader
import json

root = Path('E:/QQ CACHE/Download/安路资料/赛题1_工作资料')
specs = [
    root / '04_补充芯片手册/DS300_Eagle_EG4系列数据手册_v3.9.6_官方.pdf',
    root / '04_补充芯片手册/DS301_EG4S20数据手册_v2.7.8_官方.pdf',
]
for path in specs:
    reader = PdfReader(path)
    hits = []
    for page_index, page in enumerate(reader.pages):
        text = page.extract_text() or ''
        selected = ('LVDS' in text and any(word in text for word in ['Mbps','Gbps','MHz','速率'])) or ('SDRAM' in text and any(word in text for word in ['64Mb','64M','8MB','8 MB','133']))
        if selected:
            hits.append({'page_1based': page_index+1, 'text': text[:6500]})
    out = Path(__file__).parent / (path.stem + '_selected.json')
    out.write_text(json.dumps(hits, ensure_ascii=False, indent=2), encoding='utf-8')
    print(json.dumps({'file': path.name, 'pages': len(reader.pages), 'hit_pages': [h['page_1based'] for h in hits]}, ensure_ascii=False))
    for hit in hits:
        lines = hit['text'].splitlines()
        for i, line in enumerate(lines):
            if any(word in line for word in ['Mbps','Gbps','800','1000','400','133','64Mb','64M','8MB','8 MB','fMAX','FMAX']):
                print(json.dumps({'page':hit['page_1based'],'excerpt':' | '.join(lines[max(0,i-2):i+3])},ensure_ascii=False))

rows = []
for width, height, scan in [(640,480,60),(1280,720,60),(1920,1080,60),(1920,1080,30),(1920,1080,24)]:
    mcus = ((width+15)//16)*((height+15)//16)
    rows.append({'width':width,'height':height,'content_fps':15,'scan_hz':scan,
                 'video_pixels_per_sec':width*height*15,
                 'rgb565_dual_buffer_MB':width*height*2*2/1e6,
                 'current_rgb888_two_slot_allocation_MB':width*height*3*2/1e6,
                 'rgb565_read_MBps':width*height*2*scan/1e6,
                 'rgb565_write_MBps':width*height*2*15/1e6,
                 'rgb565_read_write_MBps':width*height*2*(scan+15)/1e6,
                 'yuv420_read_write_MBps':width*height*1.5*(scan+15)/1e6,
                 'idct_min_ms_at_50MHz':mcus*6*128/50e6*1000,
                 'idct_isolated_ceiling_fps':50e6/(mcus*6*128)})
Path(__file__).with_name('budgets.json').write_text(json.dumps(rows,indent=2),encoding='utf-8')
print(json.dumps({'budgets': rows},ensure_ascii=False))
