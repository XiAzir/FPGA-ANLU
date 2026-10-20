from pathlib import Path
import zipfile
import xml.etree.ElementTree as ET
import re
import sys
from pypdf import PdfReader

root = Path('E:/QQ CACHE/Download/安路资料')
paths = [root/'赛题解析一.pptx', root/'赛题1_工作资料/01_赛题与参考说明/2026选题指南_康芯版.docx', root/'赛题1_工作资料/05_补充参考工程/官方赛题1_康芯2026/全国大学生嵌入式芯片与系统设计竞赛\'2026选题指南_康芯.docx']
out=[]
for path in paths:
    with zipfile.ZipFile(path) as z:
        names = ['word/document.xml'] if path.suffix=='.docx' else sorted((n for n in z.namelist() if re.fullmatch(r'ppt/slides/slide\d+\.xml',n)),key=lambda n:int(re.search(r'slide(\d+)',n).group(1)))
        for name in names:
            tree=ET.fromstring(z.read(name))
            paras=[''.join(e.itertext()) for e in tree.iter() if e.tag.endswith('}t')]
            for i,p in enumerate(paras):
                if any(k in p for k in ['波形','频谱','可视化','创新性','艺术','评分']):
                    out.append(f'\n{path}\n{name}\n'+'\n'.join(paras[max(0,i-2):min(len(paras),i+4)]))
for path in root.glob('*选题*pdf'):
    reader=PdfReader(path)
    for i,page in enumerate(reader.pages):
        s=page.extract_text() or ''
        if any(k in s for k in ['波形','频谱','可视化']):out.append(f'\n{path} PDF第{i+1}页\n{s}')
text='\n'.join(out)
Path(__file__).with_name('requirements.txt').write_text(text,encoding='utf-8')
sys.stdout.reconfigure(encoding='utf-8')
print(text)
