from pathlib import Path
from datetime import datetime, timezone, timedelta
import hashlib
import html
from html.parser import HTMLParser
import json
import re
import shutil
import struct
import wave
import zipfile

ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
PACKAGE = ROOT / 'deliverables/ANLU_C27_Board_Test_20261022'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_text(encoding='utf-8-sig'))
bits = {
    'video27_command_boundary.bit': 'a348d40642f9406d2e82c88a8bf2037fce4fe0d650e9236a00dd1fa5643e905c',
    'video22_audio_diag.bit': '489e1d92558404d67d10467b4a78979a017ea4e1816527446706419c5c43f87e',
}
for name, expected in bits.items():
    assert sha(ROOT / 'download' / name) == expected
media_root = ROOT / 'development/video19_work/media_q90_trial'
media_manifest = read(media_root / 'card_image/manifest.json')
index = read(media_root / 'output/index.json')
for row in media_manifest['files']:
    assert sha(Path(row['golden_path'])) == row['sha256']
    assert Path(row['golden_path']).stat().st_size == row['bytes']
assert index['video_sha256'] == sha(media_root / 'output/VIDEO.MJP')
assert index['audio']['sha256'] == sha(media_root / 'output/TEST.WAV')
assert (index['width'], index['height'], index['fps_num'], index['frame_count']) == (640, 480, 15, 300)
with wave.open(str(media_root / 'output/TEST.WAV')) as wav:
    assert (wav.getnchannels(), wav.getsampwidth(), wav.getframerate(), wav.getnframes()) == (1, 2, 48000, 960000)
delivery = read(ROOT / 'development/player_video27_command_boundary/verification/delivery_receipt.json')
assert delivery['status'] == 'PASS_OFFLINE_DELIVERY_BOARD_PENDING'
assert delivery['bit_sha256'] == bits['video27_command_boundary.bit']

for part in ['', 'bitstreams', 'TF_CARD_BACKUP', 'evidence', 'reference', 'licenses']:
    (PACKAGE / part).mkdir(parents=True, exist_ok=True)
for name in bits:
    shutil.copy2(ROOT / 'download' / name, PACKAGE / 'bitstreams' / name)
for row in media_manifest['files']:
    target = PACKAGE / 'TF_CARD_BACKUP' / row['name']
    shutil.copy2(Path(row['golden_path']), target)
    if row['name'].endswith('.BMP'):
        raw = target.read_bytes()
        assert raw[:2] == b'BM'
        assert struct.unpack_from('<iiHH', raw, 18) == (640, 480, 1, 24)

frame = index['frames'][0]
video = (media_root / 'output/VIDEO.MJP').read_bytes()
first = video[frame['jpeg_offset_bytes']:][:frame['jpeg_length_bytes']]
assert hashlib.sha256(first).hexdigest() == frame['jpeg_sha256']
assert first[:2] == b'\xff\xd8' and first[-2:] == b'\xff\xd9'
(PACKAGE / 'reference/VIDEO_first_frame.jpg').write_bytes(first)

guide = (HERE / 'teammate_guide.md').read_text(encoding='utf-8')
(PACKAGE / '01_上板详细指南.md').write_text(guide, encoding='utf-8')

def inline(s):
    s = html.escape(s)
    s = re.sub(r'`([^`]+)`', r'<code>\1</code>', s)
    return re.sub(r'\*\*([^*]+)\*\*', r'<strong>\1</strong>', s)

def render_guide(source):
    lines = source.splitlines()
    out = []
    toc = []
    i = 0
    section = 0
    while i < len(lines):
        line = lines[i]
        if not line:
            i += 1
            continue
        if line.startswith('#'):
            level = len(line) - len(line.lstrip('#'))
            title = line[level:].strip()
            if level == 2:
                section += 1
                toc.append(f'<a href="#s{section}">{inline(title)}</a>')
                out.append(f'<h2 id="s{section}">{inline(title)}</h2>')
            else:
                out.append(f'<h{level}>{inline(title)}</h{level}>')
            i += 1
        elif line.startswith('|'):
            table = []
            while i < len(lines) and lines[i].startswith('|'):
                table.append([c.strip() for c in lines[i].strip('|').split('|')])
                i += 1
            assert all(re.fullmatch(r':?-+:?', c) for c in table[1])
            out.append('<div class="table-wrap"><table><thead><tr>' + ''.join('<th>' + inline(c) + '</th>' for c in table[0]) + '</tr></thead><tbody>')
            for row in table[2:]:
                out.append('<tr>' + ''.join('<td>' + inline(c) + '</td>' for c in row) + '</tr>')
            out.append('</tbody></table></div>')
        elif line.startswith('- ') or re.match(r'^\d+\. ', line):
            ordered = not line.startswith('- ')
            tag = 'ol' if ordered else 'ul'
            out.append(f'<{tag}>')
            pattern = r'^\d+\. ' if ordered else r'^- '
            while i < len(lines) and re.match(pattern, lines[i]):
                item = re.sub(pattern, '', lines[i])
                out.append('<li>' + inline(item) + '</li>')
                i += 1
            out.append(f'</{tag}>')
        elif line.startswith('!['):
            m = re.fullmatch(r'!\[([^\]]+)\]\(([^)]+)\)', line)
            assert m
            out.append(f'<figure><img src="{html.escape(m[2], quote=True)}" alt="{html.escape(m[1], quote=True)}"><figcaption>{inline(m[1])}</figcaption></figure>')
            i += 1
        else:
            out.append('<p>' + inline(line) + '</p>')
            i += 1
    return '\n'.join(out), ''.join(toc)

body, toc = render_guide(guide)
document = '''<!doctype html><html lang="zh-CN"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>C27 队友上板详细指南</title><style>
:root{color-scheme:light}*{box-sizing:border-box}body{margin:0;background:#f7f6f2;color:#242424;font:16px/1.8 "Microsoft YaHei","PingFang SC",sans-serif}main{max-width:1000px;margin:24px auto;background:white;padding:40px 46px;border:1px solid #deddd7}h1{font-size:30px;line-height:1.35;margin:0 0 20px}h2{font-size:23px;margin:38px 0 16px;border-top:2px solid #333;padding-top:22px;scroll-margin-top:15px}h3{font-size:18px;margin:28px 0 10px;color:#245c59}p{margin:12px 0}li{padding:4px 0}ul,ol{padding-left:25px}code{background:#f0f1ed;padding:2px 5px;overflow-wrap:anywhere}.table-wrap{overflow-x:auto;margin:18px 0}table{border-collapse:collapse;width:100%;font-size:14px;line-height:1.65}th,td{border:1px solid #cfcfc9;padding:10px 12px;vertical-align:top;overflow-wrap:anywhere}th{background:#eeeee8;text-align:left}details{margin:0 0 30px;padding:14px 18px;background:#f0f3ee}summary{cursor:pointer;font-weight:bold}nav a{display:block;padding:3px;color:#245c59}figure{margin:24px 0}img{max-width:100%;height:auto;border:1px solid #ccc}figcaption{font-size:14px;color:#555}footer{margin-top:35px;border-top:1px solid #ccc;padding-top:12px;font-size:13px;color:#555}.tag{color:#245c59;font-size:13px;letter-spacing:2px;margin:0 0 16px}
@media(max-width:700px){main{margin:0;padding:24px 18px;border:0}h1{font-size:25px}h2{font-size:21px}body{font-size:16px}th,td{min-width:100px;padding:8px}nav a{padding:5px 0}}
@media print{body{background:white;font-size:10pt;line-height:1.65}main{max-width:none;margin:0;border:0;padding:0}details{display:none}h2{break-after:avoid;margin-top:24px;padding-top:12px;font-size:15pt}h3{break-after:avoid;font-size:12pt}table{font-size:9pt}thead{display:table-header-group}tr{break-inside:avoid}.table-wrap{overflow:visible}img{max-height:220px;width:auto}a{color:inherit}}
</style></head><body><main><p class="tag">ANLU · C27 BOARD TEST · 2026-10-22</p>
<details><summary>目录（点此展开）</summary><nav>''' + toc + '</nav></details>' + body + '<footer>本页可离线阅读。浏览器菜单“打印”可保存为 PDF。主测版本 00C11327，对照版本 00C11322。</footer></main></body></html>'
(PACKAGE / '01_上板详细指南.html').write_text(document, encoding='utf-8')

start = r'''C27 队友上板包｜先读这里

1. 将整个压缩包解压到纯英文路径，例如 D:\ANLU_C27_Test。
2. 双击“01_上板详细指南.html”，按章节照做；Markdown 版内容相同。
3. 沿用目前已装好素材的TF卡、稳定5V电源、HDMI线和显示器。
4. BitWriter 经 AL-LINK/JTAG，5MHz，PROGRAM_SRAM，加载：
   bitstreams\video27_command_boundary.bit
   等10秒，数码管版本确认00C11327。
5. 顺序：冷启图声→手动切图→AUTO→原声/音阶→视频暂停→KEY0重播3次→频繁往返。
6. 故障时先松键：拍显示器全屏+声音，录20～25秒完整数码管，再加载C22同卡对照。
   C22文件：bitstreams\video22_audio_diag.bit；版本00C11322。
7. 复制“02_测试反馈模板.txt”另存填写，和原录像一起交回原负责人。

TF_CARD_BACKUP 是备用素材。当前卡已装好时先沿用，.bit在电脑上经下载器加载。
C27已通过离线仿真/时序，实板效果等待这次测试。C22曾恢复图声，仍有杂音与偶发黑屏记录。
具体按法和故障录制方法均在详细指南中。掉电后需重新PROGRAM_SRAM加载测试位流。
'''
(PACKAGE / '00_START_HERE.txt').write_text(start, encoding='utf-8-sig')

feedback = '''C27/C22 队友上板反馈模板
请复制为新文件再填写；可写“通过/异常/未测”，异常写具体现象。

【基本情况】
测试者：
日期、开始/结束时间：
板卡：AC601+AC201；扫描器件：
供电方式：
显示器型号、音量、HDMI接法：
TF沿用/换卡/覆盖文件（若有，写发生时间与文件）：
本轮下载文件名：
BitWriter下载结果：
数码管版本：
重新下载次数、各轮次编号：

【逐项结果】
T01 冷启动等10秒：图片/IMG索引与总数/频谱/原声/绿点：
T02 KEY0手动8次：各图/回第一张/闪现/绿点/音乐连续性：
T03 KEY1 AUTO开关各一次：AUTO提示/轮播/IMG0/4/频谱：
T04 原声：干净/杂音/无声；内置音阶：干净/杂音/无声；已切回原声：
T05 视频：有无声画；KEY1暂停/继续两次：
T06 KEY0重播第1次：恢复时间/声画/无信号时长/计时：
T06 KEY0重播第2次：
T06 KEY0重播第3次：
T07 视频出现1～2秒后开始双键长按返回，3轮：
T08 长间隔切换2轮：
T08 连续视频实际时长、循环情况：
T09 C22版本00C11322：冷启图片/原声/音阶/杂音、故障是否随版本变化：
选测：亮度/对比度/频谱冻结：

【每个故障单独复制以下小节】
故障编号、版本、测试项、新一轮编号：
故障前是什么模式、图几或视频播放多久：
具体按法：哪颗键、按住多久、松开后等了多久：
显示器：有UI/仅UI/无信号；IMG索引与总数；右上角计时：
声音：原声/音阶；有声/杂音/无声；频谱有无刷新：
绿点/闪现/动画：
8位数码管（从左到右；看不清可留空并附原视频）：
  版本页：
  2开头状态页：
  紧随状态的CRC页：
  FFT页：
  4页：
  5页：
  6页：
  7页：
  8页：
  9页：
  A页：
  B页：
  C页：
  D页：
  WAV头页：
  BMP/MJP头页：
画面录像文件名/完整本地路径：
20～25秒数码管录像文件名/完整本地路径：
原声与音阶录音/录像文件名/完整本地路径：
取证后采用了什么恢复方法、结果：
同TF/同线C22对照结果及录像：

【结束情况】
最后加载版本：
结束时图声状态：
其他观察：
'''
(PACKAGE / '02_测试反馈模板.txt').write_text(feedback, encoding='utf-8-sig')

keys = '''C27 按键速查（沿用既有KEY0、KEY1称呼）

普通图片：短KEY0=下一张；短KEY1=AUTO开/关。
普通视频：短KEY0=从头重播；短KEY1=暂停/继续。
普通播放单独长KEY1约2秒=原声/内置do-re-mi切换，再长按返回。
两键一起按住约2秒、再全部松开=图片/视频切换；亮度对比度恢复默认、回普通播放。
两键一起短按并松开=频谱冻结/继续。
单独长KEY0约2秒循环：普通播放→亮度→对比度→普通播放。
亮度/对比度调节时：短KEY0减，短KEY1加。

短按约0.1～0.3秒，动作之间留时间观察。
双键切换在两键全部松开后触发；测试时两键共同按住约2秒。
发生故障先松键录状态；数码管每页约1秒，录20～25秒覆盖一轮。
板卡复位键与上述功能键分开。掉电后重新下载测试位流。
'''
(PACKAGE / '03_按键速查表.txt').write_text(keys, encoding='utf-8-sig')

notes = '''版本与已知问题（2026-10-22）

C27 / 00C11327：本包主测，修正完整六字节SD命令发完后再判断R1；SPI工作态12.5MHz。
相对C26只改解析器和版本页，其他119份user_source保持。
离线命令候选168/168、原版72项预期失败检出、错误R1控制8项通过；
冷启及4次模式切换+2次重播整机模型通过。9059/9800 Slice，92.44%，Setup/Hold +0.746/+0.033ns。
本次实板重点：短KEY0重播后的声画恢复、频繁模式往返，以及图片绿点/IMG0/4/无声。

C22 / 00C11322：随包对照。用户此前多次重载可恢复HDMI、图片和声音；
原声/内置音阶持续杂音、偶发切换/重播黑屏、双键切换失效仍有记录。

C26 / 00C11326：原观测版，本包未附位流。
用户曾反馈IMG1黑屏、切图露出前一张并有绿点，KEY1后IMG0/4及频谱停止，原声/音阶无声。
视频可播放；短KEY0重播后仅UI。录像读20400000/CRC00000000、C1114063，停CMD8初始化。
本次C27实板结果仍需测试；图片和音频异常继续逐项记录。

主流程见根目录详细指南。两个版本的B/C/D诊断定义各见对应原说明。
'''
(PACKAGE / 'evidence/版本与已知问题.txt').write_text(notes, encoding='utf-8-sig')
shutil.copy2(ROOT / 'deliverables/video27_command_boundary_c11327_20261022/validation.json', PACKAGE / 'evidence/C27_offline_validation.json')
shutil.copy2(ROOT / 'deliverables/video27_command_boundary_c11327_20261022/操作说明.txt', PACKAGE / 'evidence/C27_original_notes.txt')
shutil.copy2(ROOT / 'deliverables/video22_audio_diag_c11322_20261022/操作说明.txt', PACKAGE / 'evidence/C22_original_notes.txt')
for name in ['JPEG_LICENSE.txt', 'THIRD_PARTY_NOTICES.txt']:
    shutil.copy2(ROOT / 'deliverables/video19_c11319_20261021' / name, PACKAGE / 'licenses' / name)

class LocalLinks(HTMLParser):
    def __init__(self):
        super().__init__()
        self.links = []
        self.ids = set()
        self.headers = []
    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if 'id' in attrs:
            self.ids.add(attrs['id'])
        if tag in ('a', 'img'):
            self.links.append(attrs.get('href') if tag == 'a' else attrs.get('src'))
        if tag == 'h2':
            self.headers.append(attrs.get('id'))

check = LocalLinks()
check.feed(document)
assert len(check.headers) == 11
for link in check.links:
    assert link
    if link.startswith('#'):
        assert link[1:] in check.ids
    else:
        assert (PACKAGE / link).is_file()
for filename in ['00_START_HERE.txt', '01_上板详细指南.md', '02_测试反馈模板.txt', '03_按键速查表.txt']:
    assert '\ufffd' not in (PACKAGE / filename).read_text(encoding='utf-8-sig')
for name, expected in bits.items():
    assert sha(PACKAGE / 'bitstreams' / name) == expected

files = [{'path': f.relative_to(PACKAGE).as_posix(), 'bytes': f.stat().st_size, 'sha256': sha(f)}
         for f in sorted(PACKAGE.rglob('*')) if f.is_file() and f.name not in ['MANIFEST.json', 'SHA256SUMS.txt']]
manifest = {'package': PACKAGE.name, 'created_local': datetime.now(timezone(timedelta(hours=8))).isoformat(),
            'main_version': '00C11327', 'control_version': '00C11322',
            'board_status': 'C27 pending teammate test; C22 previously playable with known faults',
            'files': files}
(PACKAGE / 'MANIFEST.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
all_payload = files + [{'path': 'MANIFEST.json', 'bytes': (PACKAGE / 'MANIFEST.json').stat().st_size, 'sha256': sha(PACKAGE / 'MANIFEST.json')}]
(PACKAGE / 'SHA256SUMS.txt').write_text('SHA256  bytes  relative_path\n' + '\n'.join(f"{r['sha256']}  {r['bytes']}  {r['path']}" for r in all_payload) + '\n', encoding='utf-8')
zip_path = PACKAGE.with_suffix('.zip')
with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as z:
    for f in sorted(PACKAGE.rglob('*')):
        if f.is_file():
            z.write(f, (Path(PACKAGE.name) / f.relative_to(PACKAGE)).as_posix())
with zipfile.ZipFile(zip_path) as z:
    assert z.testzip() is None
    for row in all_payload:
        raw = z.read(PACKAGE.name + '/' + row['path'])
        assert len(raw) == row['bytes'] and hashlib.sha256(raw).hexdigest() == row['sha256']
    assert z.read(PACKAGE.name + '/SHA256SUMS.txt') == (PACKAGE / 'SHA256SUMS.txt').read_bytes()
receipt = {'status': 'PASS_TEAMMATE_GUIDE_PACKAGE', 'package': str(PACKAGE),
           'zip': str(zip_path), 'zip_bytes': zip_path.stat().st_size, 'zip_sha256': sha(zip_path),
           'payload_files': len(all_payload) + 1, 'bit_sha256': bits,
           'checks': ['ZIP CRC and all payload sizes/SHA256', 'Both original bit hashes',
                      'TF golden manifest hashes and sizes', '640x480 BMP headers',
                      '48k PCM16 mono 960000 samples', '300 frame 640x480 15fps video index',
                      'First JPEG bytes/hash', '11 HTML sections and all local links', 'UTF8 documents'],
           'hardware_operations': 'None; teammate testing pending'}
(HERE / 'teammate_package_receipt.json').write_text(json.dumps(receipt, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps(receipt, ensure_ascii=False, indent=2))
