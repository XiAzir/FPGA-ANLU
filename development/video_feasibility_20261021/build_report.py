from pathlib import Path
import hashlib, json, re, sys, zipfile
from xml.etree import ElementTree as ET
from xml.sax.saxutils import escape
from pypdf import PdfReader
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib import colors
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.enums import TA_LEFT
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak
from reportlab.lib.pagesizes import A4

sys.stdout.reconfigure(encoding='utf-8')
WORK = Path(__file__).resolve().parent
PROJECT = WORK.parents[1]
DOCS = Path('E:/QQ CACHE/Download/安路资料')
OUT = DOCS/'开发记录/专题记录/视频播放可行性_20261021'
OUT.mkdir(parents=True, exist_ok=True)
pdfmetrics.registerFont(TTFont('CN', 'C:/Windows/Fonts/simsun.ttc'))
pdfmetrics.registerFont(TTFont('CNBold', 'C:/Windows/Fonts/simhei.ttf'))
pdfmetrics.registerFontFamily('CN', normal='CN', bold='CNBold', italic='CN', boldItalic='CNBold')

sources = [
    DOCS/'赛题解析一.pptx',
    DOCS/'赛题1_工作资料/01_赛题与参考说明/2026选题指南_康芯版.docx',
    DOCS/"赛题1_工作资料/05_补充参考工程/官方赛题1_康芯2026/全国大学生嵌入式芯片与系统设计竞赛'2026选题指南_康芯.docx",
    next(DOCS.glob('new*.pdf')),
    DOCS/'2026安路赛题一、二相关Q&A.docx',
    DOCS/'开发记录/专题记录/SPI提速_20261021/README.md',
    DOCS/'开发记录/专题记录/SPI提速_20261021/C11315_实施记录.md',
    DOCS/'开发记录/专题记录/资源优化/C11318_20261021/README.md',
]
rtl = 'development/player_spectrum_ctrl18/src/user_source/hdl_source/'
source_files = [
    'top_tf_hdmi_audio.v', 'frame_buffer_rgb888.v', 'tf_bmp_file_player.v',
    'bmp_scale_engine.v', 'SD/spi_master.v', 'SD/sd_card_sec_read_write.v',
    'SD/color_bar.v', 'IP/sys_pll.v', 'IP/video_pll.v', 'IP/sdram.v',
    'include/global_def.v', 'SD/frame_read_write.v',
]
sources += [PROJECT/rtl/p for p in source_files]
sources += [PROJECT/'development/player_spectrum_ctrl18/build/manual/AC201_tf_hdmi_phy.area']
receipt = {'date': '2026-10-21', 'baseline': 'C11318', 'sources': []}
for p in sources:
    receipt['sources'].append({'path': str(p), 'sha256': hashlib.sha256(p.read_bytes()).hexdigest()})

extracts = []
for p in sources[:5]:
    if p.suffix == '.pdf':
        reader = PdfReader(p)
        for i in [13, 14]:
            extracts.append({'path': str(p), 'locator': f'PDF物理页{i+1}', 'text': reader.pages[i].extract_text()})
    else:
        with zipfile.ZipFile(p) as z:
            if p.suffix == '.pptx':
                for i in [5, 6, 21]:
                    root = ET.fromstring(z.read(f'ppt/slides/slide{i}.xml'))
                    text = '\n'.join(x.text or '' for x in root.iter() if x.tag.endswith('}t'))
                    extracts.append({'path': str(p), 'locator': f'第{i}页', 'text': text})
            else:
                root = ET.fromstring(z.read('word/document.xml'))
                ns = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
                paras = [''.join(x.text or '' for x in q.findall('.//w:t',ns)) for q in root.findall('.//w:p',ns)]
                selected = [{'paragraph': i+1, 'text': q} for i,q in enumerate(paras)
                            if p == sources[4] or 212 <= i <= 234]
                extracts.append({'path': str(p), 'locator': 'OOXML正文段落序号', 'paragraphs': selected})
(OUT/'source_extracts.json').write_text(json.dumps(extracts, ensure_ascii=False, indent=2), encoding='utf-8')

W,H = 640,480
N=W*H
S=1_353_638
A=48_000*2
O=20_000
F=25_000_000/(800*525)
BUDGET = .8*S-A-O
formats=[]
for name,bpp in [('RGB888',24),('RGB565',16),('RGB332',8)]:
    fbytes=N*bpp//8
    formats.append({'name': name, 'bpp': bpp, 'bytes_per_frame': fbytes,
      'two_buffers_bytes': 2*fbytes, 'wire_only_fps': 1_562_500/fbytes,
      'byte_test_fps': (1e9/720)/fbytes, 'service_fps': S/fbytes,
      'service_with_mono_audio_fps': (S-A)/fbytes,
      'budget_fps': BUDGET/fbytes, 'scan_MBps': fbytes*F/1e6,
      'scan_plus_write30_MBps': fbytes*(F+30)/1e6,
      'raw_Mbps': {str(f):fbytes*f*8/1e6 for f in [15,25,30,60]}})
calc={'units':'MB=10^6 bytes; Mbps=10^6 bits/s; KiB=1024 bytes; MiB=2^20 bytes',
      'resolution':[W,H], 'pixels_per_frame': N, 'display_refresh_hz':F,
      'spi_wire_Bps':1_562_500, 'byte_test_period_ns':720,
      'byte_test_Bps':1e9/720,'simulation_sector_service_Bps':S,
      'audio_mono_pcm16_48k_Bps':A, 'other_allowance_Bps':O,
      'headroom_fraction':.2, 'video_budget_Bps':BUDGET,
      'video_budget_Mbps':BUDGET*8/1e6, 'formats':formats,
      'compressed_6Mbps':[{'fps':f,'average_bytes_per_frame':750000/f,
        'compression_ratio_RGB888':N*3*f/750000,
        'compression_ratio_RGB565':N*2*f/750000} for f in [15,24,25,30,F]],
      'compressed_buffer_256KiB_seconds_at_6Mbps':262144/750000,
      'decoder_pixel_rates':{str(f):N*f for f in [15,25,30,F]}}
assert BUDGET*8/1e6 < 8
assert all(x['bytes_per_frame']%512==0 for x in formats)
assert abs(formats[0]['service_with_mono_audio_fps']*921600-(S-A))<1e-6
(OUT/'calculations.json').write_text(json.dumps(calc,ensure_ascii=False,indent=2),encoding='utf-8')

PAGE_W,PAGE_H=A4
BODY_W=PAGE_W-92
styles={
 'title':ParagraphStyle('Title',fontName='CNBold',fontSize=21,leading=29,textColor=colors.black,spaceAfter=13),
 'h1':ParagraphStyle('H1',fontName='CNBold',fontSize=15,leading=21,textColor=colors.black,spaceAfter=10),
 'h2':ParagraphStyle('H2',fontName='CNBold',fontSize=11.5,leading=17,textColor=colors.black,spaceBefore=9,spaceAfter=5),
 'body':ParagraphStyle('Body',fontName='CN',fontSize=10,leading=16.3,textColor=colors.black,spaceAfter=7,wordWrap='CJK'),
 'small':ParagraphStyle('Small',fontName='CN',fontSize=8.5,leading=13.3,textColor=colors.HexColor('#444444'),spaceAfter=6,wordWrap='CJK'),
 'cell':ParagraphStyle('Cell',fontName='CN',fontSize=9,leading=13,wordWrap='CJK'),
 'head':ParagraphStyle('Head',fontName='CNBold',fontSize=9,leading=13,wordWrap='CJK'),
}
story=[]
def p(t, kind='body'): story.append(Paragraph(t,styles[kind]))
def h(t): p(t,'h2')
def table(headers, rows, weights=None):
    widths=[BODY_W*x/sum(weights) for x in weights] if weights else [BODY_W/len(headers)]*len(headers)
    data=[[Paragraph(escape(str(x)),styles['head']) for x in headers]]
    data += [[Paragraph(escape(str(x)),styles['cell']) for x in row] for row in rows]
    t=Table(data,colWidths=widths,repeatRows=1,hAlign='LEFT')
    t.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,0),colors.HexColor('#e9eef3')),
      ('VALIGN',(0,0),(-1,-1),'TOP'),('LEFTPADDING',(0,0),(-1,-1),7),
      ('RIGHTPADDING',(0,0),(-1,-1),7),('TOPPADDING',(0,0),(-1,-1),6),
      ('BOTTOMPADDING',(0,0),(-1,-1),6),('LINEBELOW',(0,0),(-1,0),.7,colors.HexColor('#8a99a8')),
      ('LINEBELOW',(0,1),(-1,-1),.35,colors.HexColor('#d5dce2'))]))
    story.append(t);story.append(Spacer(1,8))
def page(title):
    if story:story.append(PageBreak())
    p(title,'h1')

p('像素格式与视频播放可行性报告','title')
p('AC601 与 AC201  EG4S20BG256  |  C11318 基线  |  2026年10月21日','small')
p('<b>建议保留 RGB888 图片功能，为视频单独评估 RGB565 缓存和压缩码流。</b>以 640×480 为基准，当前 12.5 MHz SPI 链路适合先探索 15 fps、约 6 Mbps 的视频；25 至 30 fps 可作为第二阶段目标，解码器吞吐、资源和实卡持续读取需要分别验证。')
h('赛题分辨率的原文依据')
p('康芯版指南第 1.3 节明确写明：“至少支持对4幅640×480、24-bit的图片进行自动扫描、识别与装载”。赛题解析 PPT 第 5 页同样指定“640X480、24-bit RGB 非压缩 BMP 图片”。因此本报告采用 <b>640×480 作为基础功能及视频探索的保守分辨率基准</b>。[1][2]')
p('本地修改稿 PDF 物理第 14 至 15 页将赛题一改为开放式多媒体要求，相关章节未写明最低分辨率；这份文件具有“修改ing”文件名和模板字样，现有本地材料尚缺统一版本确认。康芯版“显示器建议支持1280×720@60Hz”位于自备设备建议段落。赛题二答疑中的1024×600条款归属赛题二。本项目沿用640×480可覆盖已有明确基础规格。[1][3][4]')
h('建议采用的组合')
table(['用途','建议格式','理由'],[
 ['基础图片与画质对照','RGB888','保留24-bit BMP输入和现有色彩精度，已有完整验证积累'],
 ['新增视频缓存候选','RGB565','每帧减少1/3存储和像素搬运，配合压缩输入探索流畅播放'],
 ['带宽演示与风格化内容','RGB332','帧体积为RGB888的1/3，颜色仅256种，渐变和自然画面损失较大'],
], [1.3,1,2.5])
p('视频播放可增强作品的完整性、技术深度与展示效果。已核查材料的评分以实现质量、稳定性和创新性综合评判；视频播放的独立固定加分值未列出，演示目标宜与现有音频、频谱及交互整合。[2][3]','small')

page('一  三种像素格式的选择')
table(['指标','RGB888','RGB565','RGB332'],[
 ['每像素位数','24 bit','16 bit','8 bit'],
 ['通道色阶 R G B','256 / 256 / 256','32 / 64 / 32','8 / 8 / 4'],
 ['可表示颜色数','16,777,216','65,536','256'],
 ['640×480 单帧','921,600 B','614,400 B','307,200 B'],
 ['双缓冲容量','1,843,200 B','1,228,800 B','614,400 B'],
 ['相对容量与像素流量','100%','66.67%','33.33%'],
 ['画质判断','渐变与调色余量最佳','通常可接受，暗部/渐变可见量化','色带明显，蓝色仅4级'],
], [1.4,1.15,1.15,1.15])
h('转换位置决定实际收益')
p('<b>SD卡文件先变小：</b>离线转为紧凑RGB565/RGB332，或编码成压缩视频，才能直接减少卡侧读取字节。读取24-bit BMP后再降位宽，卡侧仍已传输了完整BMP像素数据。现有loader只解析24bpp BI_RGB，新增格式需要独立解析入口。[7]')
p('<b>SDRAM里存得更紧凑：</b>使用16位或8位紧凑帧缓存，才会相应减少帧容量及读写流量。当前32位SDRAM已采用“4像素打包3字”的RGB888布局；换RGB565需2像素/字，RGB332需4像素/字，地址、突发长度、FIFO及解包逻辑随之调整。[6]')
p('<b>HDMI前展开：</b>视频读出后扩展为8位通道，再执行现有亮度、对比度、OSD和频谱合成。这样UI可继续保留RGB888精度。仅在HDMI前把像素数值量化，SD卡和帧缓存流量保持原值，现有RGB模式的像素时钟和TMDS速率也保持原值。')
h('对资源优化的判断')
p('RGB565的2像素/32位字对齐有望简化RGB888跨字解包；最终Slice收益还需同版本控制组消融。SDRAM物理总线仍为32位，RGB调整和叠加层继续使用24位时，其组合逻辑规模也会保留。当前C11318为6972/9800 Slice、45/64 BRAM、9/29 DSP，约剩2828 Slice；视频解码应纳入整体资源预算。[5][6]')
p('基础输入继续支持原24-bit BMP；现有全精度路径保留为画质与功能对照。视频候选可单独量化，先用自然画面、暗部渐变、字幕和频谱同屏比较RGB565，再决定是否用于正式缓存。抖动可减轻色带，同时可能降低简单RLE或差分编码的压缩效率。','small')

page('二  当前链路下的帧率与码率')
p('以下均按640×480完整帧计算。MB使用十进制10⁶字节，Mbps使用10⁶ bit/s；单声道音频采用当前48 kHz PCM16，卡侧负载0.096 MB/s，HDMI双声道由单声道复制。[5]')
table(['带宽层次','数值','依据与用途'],[
 ['SPI物理线速','12.5 Mbps = 1.5625 MB/s','SCLK每拍1bit，作为理想绝对线速'],
 ['字节接口仿真','约11.111 Mbps = 1.388889 MB/s','既有mode3测试连续请求720 ns/字节，含字节间隙'],
 ['扇区服务仿真','10.829104 Mbps = 1.353638 MB/s','完成块×512 / 累积块服务时长，含命令/token/CRC'],
 ['扣当前单声道音频','10.061104 Mbps = 1.257638 MB/s','仍需支付FAT访问、文件调度与等待'],
], [1.2,1.5,2.2])
p('扇区服务数据来自数字SD模型和短素材，适合作为条件估算。实卡长时连续有效吞吐待测；将1.353638 MB/s视为全时可用会偏乐观。C11318继承此SPI结构，当前报告未新增视频播放测量。[5]','small')
p('现有HDMI三条数据lane各为25 MHz×10＝250 Mbps，合计750 Mbps固定串行速率，包含消隐/控制/音频传输。该端口线速由输出时序决定，卡文件压缩码率可独立降低。','small')
h('未压缩完整帧的读取预算')
table(['格式','线速除以帧长','服务仿真除以帧长','再扣音频','80%预算再扣音频及杂项'],[
 [x['name'],f"{x['wire_only_fps']:.2f} fps",f"{x['service_fps']:.2f} fps",f"{x['service_with_mono_audio_fps']:.2f} fps",f"{x['budget_fps']:.2f} fps"] for x in formats
], [1,1,1.15,1,1.6])
p('预算列取0.8×1.353638 MB/s，另扣0.096 MB/s音频和0.020 MB/s元数据/调度额度，剩0.9669104 MB/s。20%余量及0.020 MB/s为本报告设计假设。该表给出输入带宽条件上限，现有轮播状态机还会增加加载、提交和帧边界等待。')
h('未压缩视频所需视频净码率')
table(['格式','15 fps','25 fps','30 fps','60 fps'],[
 [x['name']]+[f"{x['raw_Mbps'][str(f)]:.3f}" for f in [15,25,30,60]] for x in formats
], [1,1,1,1,1])
p('上表单位为Mbps，仅像素数据。640×480 RGB565即便15 fps也需要73.728 Mbps，明显超过当前12.5 Mbps SPI线速。源色深从24位降低到8位仍需继续压缩，才能进入15至30 fps视频目标。','small')

page('三  低码率视频的收益和目标预算')
p('<b>低码率可以有效缓解SD读取压力。</b>以6 Mbps压缩视频加当前PCM音频计，总媒体负载6.768 Mbps；再计0.160 Mbps杂项，总计6.928 Mbps，约占仿真服务吞吐的64.0%。先用6 Mbps建立稳定目标，比贴近总读取能力更适合保留卡等待余量。')
table(['输入预算方案','70%服务利用率','80%服务利用率'],[
 ['可用媒体及杂项带宽','7.580 Mbps','8.663 Mbps'],
 ['扣PCM单声道与0.160Mbps杂项后视频预算',f'{(.7*S-A-O)*8/1e6:.3f} Mbps',f'{BUDGET*8/1e6:.3f} Mbps'],
 ['建议初始压缩视频码率','6 Mbps','6 至 7.5 Mbps'],
], [2.4,1.25,1.25])
p('上述预算可用于任意被FPGA支持的编码格式。压缩方案、量化参数、画面复杂度和峰值帧长共同决定能否在该码率下维持所需画质。更换为双声道PCM16原文件时，音频负载增至1.536 Mbps，视频预算相应减少0.768 Mbps。')
h('6 Mbps视频在不同帧率下的平均帧长和压缩需求')
table(['内容帧率','平均压缩帧长','相对RGB888压缩比','相对RGB565压缩比'],[
 [f"{x['fps']:.2f} fps",f"{x['average_bytes_per_frame']/1000:.2f} KB",f"{x['compression_ratio_RGB888']:.2f}:1",f"{x['compression_ratio_RGB565']:.2f}:1"] for x in calc['compressed_6Mbps']
], [1,1.2,1.3,1.3])
p('例如640×480、30 fps、6 Mbps对应平均25 KB/帧；15 fps对应50 KB/帧。同一编码方案与码率下，提高帧率会减少每帧可用字节，通常需要更强压缩或接受画质变化。实际图像质量应以素材编码结果评估，表中压缩比是需求量。')
h('平均码率 峰值与预读')
p('压低文件平均码率可降低读取利用率，复杂帧或关键帧仍会产生突发。若出现100 KB帧，按6 Mbps平均供给需约133 ms传入，30 fps单帧期限为33.3 ms。可用离线限制峰值帧长、提前预读和帧间排期安排吸收突发。')
p('编码缓冲需求近似为“消耗字节率×允许的停顿时间＋额外突发量”。6 Mbps流应对200 ms卡等待需至少150 KB基本预读；256 KiB纯码流缓冲约覆盖350 ms，尚需计音频、元数据和额外峰值。码流适合放SDRAM预读，避免占满当前剩余BRAM。','small')

page('四  解码后带宽与真正的帧率约束')
p('完整视频链为“TF文件→码流预读→硬件解码→备用帧缓存→VS提交→显示”。压缩减少前端字节，解码后像素吞吐仍由分辨率与内容帧率决定。应同时满足读取、解码、存储和显示四项约束。')
h('现有显示与SDRAM能力')
p('当前像素时钟25 MHz，水平总长800、垂直总长525；扫描刷新为25,000,000÷800÷525＝<b>59.5238 Hz</b>。在当前时序下，独立完整画面更新的显示侧上限约59.52 fps。内容15、25或30 fps通过重复显示帧输出；严格30 fps长期可见节奏宜配合59.5238 Hz实际刷新做时间戳排期，或后续单独验证标准60 Hz时序。[6]')
p('存储为2M×32 bit，即8 MiB；当前SDRAM控制时钟50 MHz，原始总线率200 MB/s，刷新、激活、读写切换和仲裁占用需扣除。当前控制器默认256字突发。下表统计像素有效字节，真实控制器可持续能力需要专门测量。[6]')
table(['紧凑缓存格式','扫描读平均','30 fps新帧写','合计平均','活动显示期读峰值'],[
 [x['name'],f"{x['scan_MBps']:.3f}",f"{x['bytes_per_frame']*30/1e6:.3f}",f"{x['scan_plus_write30_MBps']:.3f}",str(25*x['bpp']/8)] for x in formats
], [1.25,1.15,1.15,1.15,1.45])
p('单位MB/s，按59.5238Hz扫描及30fps全帧写。亮度、OSD与频谱当前在读出后合成，这些叠加本身无需写回帧缓存。RGB565输入若解码后存为RGB888，存储预算应使用RGB888这一行；帧间差分需要参考帧读或复制时，还要计入额外存储流量。','small')
h('解码器和现有加载器的约束')
p('640×480解码15 fps需要4.608 Mpixel/s，30 fps需要9.216 Mpixel/s。若在25 MHz域运算，平均分别只有5.43和2.71个时钟/像素，复杂变换需块级流水或在50 MHz域复用运算。59.52 fps需18.286 Mpixel/s；解码器吞吐尚未实现测量。')
p('当前BMP scaler以PIXEL_INTERVAL=10运行于50 MHz域，仅输出间隔就使像素生成上限低于等于16.28 fps；行映射、存储等待、文件读取还会增加时长。loader按完整BMP加载、备用buffer写满、提交并等待显示完成后返回IDLE，自动轮播另有周期控制。因此新增视频应使用持续码流/帧调度入口。[7]')
p('现有整机首次commit约95 ms来自16×16 BMP放大为640×480的短素材回放；该时间包含挂载等阶段。完整640×480原始图或视频帧率需按真实文件字节和流水重新计量。','small')

page('五  视频编码与实施路线建议')
table(['方案','适合场景','主要成本与优先级'],[
 ['紧凑原始RGB565','低帧率画质基线','解析简单、定长易定位；640×480约2fps读取预算，用作正确性对照'],
 ['RLE或分块差分','字幕/动画/广告等受控素材','可用较小解码结构；自然视频和快速运动压缩波动大，需离线逐帧验收'],
 ['MJPEG或受限JPEG帧序列','自然视频第一候选','独立帧便于定位；熵解码、反量化、IDCT、色彩变换需资源/吞吐消融'],
 ['H.264等帧间编码','更高压缩效率的后续探索','运动补偿、参考帧及码流解析提高工程复杂度，现阶段优先级较低'],
], [1.35,1.5,2.65])
p('推荐先完成编码器在PC端的离线素材转换，FPGA独立读取和解码，演示时脱离PC。编解码具体规则与数据格式公开留档，并保持原图片、音频和频谱功能。根据赛题要求，运行时数据处理在FPGA实现；本路线的PC仅承担素材准备。[3][4]')
h('两个阶段目标')
p('<b>第一阶段：</b>640×480、15 fps、约6 Mbps、当前48 kHz单声道PCM；先测MJPEG受限解码核的面积及速度，同时以受控差分动画做较小资源备选。视频缓存比较RGB888/RGB565，OSD和频谱继续在RGB888域合成。若解码核超出整体资源预算，按实测结果调整编码设计。')
p('<b>第二阶段：</b>在读取和解码基准通过后探索25至30 fps，码率6至7.5 Mbps；30 fps目标约25至31.25 KB/帧，需对高运动素材检查画质、峰值与缓冲。当前显示时序的约59.52 fps留作显示侧条件上限，最终内容最大帧率应由实卡和整机实测确定。')
h('需要完成的最小验证')
p('1 读取：长文件连续/碎片场景，记录总有效吞吐、各时间窗口最低吞吐、token最长等待、音频FIFO低水位和CRC。\n<br/>2 解码：对高运动、暗部、文字及自然场景逐帧与离线golden比较；记录平均及最慢帧时长、码流峰值、A/V时间戳。\n<br/>3 存储：真实SDRAM读写并发下验证完整帧、双缓冲所有权、VS提交、转场与欠载。\n<br/>4 消融：原始基线、仅改缓存格式、仅加解码器、组合四组，记录Slice/BRAM/DSP及setup/hold；量化画质变化。')
h('可选的低源分辨率路线')
p('320×240像素数为640×480的1/4，可用于快速验证视频调度。例如RGB332、10fps原始源为0.768 MB/s，加单声道音频及杂项约0.884 MB/s；HDMI仍可放大到640×480。该路线适合功能原型，完整640×480图片入口继续保留。若正式视频演示采用较低源分辨率，应在展示指标中明确源尺寸与输出尺寸。','small')

page('六  证据来源和计算口径')
p('本轮执行了赛题文件OOXML/PDF读取、修改稿相关页视觉核对、生产RTL与面积报告静态审阅、带宽公式计算。生产RTL、约束、时钟、位流保持原交付；视频解码、实卡持续吞吐和视频整机尚待实现验证。报告记录于2026年10月21日，沿用C11318离线交付状态。')
refs=[
 ('[1] 康芯版选题指南',str(sources[1]),'第1.3节基础要求、1.5节自备设备；独立包内副本同段落一致。'),
 ('[2] 赛题解析一',str(sources[0]),'2026.09.05，第5页基础要求，第6页扩展要求，第21页注意事项。'),
 ('[3] 修改稿PDF',str(sources[3]),'物理第14至15页赛题一全文；文件的其他页和赛题二指标未用于最低分辨率结论。'),
 ('[4] 主办方答疑',str(sources[4]),'2026.09.10，赛题一处理器、显示设备、TF格式相关答疑。'),
 ('[5] SPI与资源实测记录',str(sources[5]),'mode3连续请求720ns/字节；C11315实施记录中的1.353638MB/s为仿真扇区服务吞吐；C11318报告为当前资源基线。'),
    ('[6] 当前生产链路',str(PROJECT/rtl),'top_tf_hdmi_audio.v:437；SD/color_bar.v:41；IP/video_pll.v:13；IP/sys_pll.v:17；frame_buffer_rgb888.v:33；SD/frame_read_write.v:5；IP/sdram.v:31。'),
 ('[7] 当前BMP入口',str(PROJECT/rtl/'tf_bmp_file_player.v'),'头部约束:63起；scaler参数:110；提交/显示等待:220起。bmp_scale_engine.v中的PIXEL_INTERVAL、S_EMIT和像素状态机配合审阅。'),
]
for title,path,note in refs:
    p('<b>'+escape(title)+'</b>','small')
    p(escape(path.replace('\\','/')),'small')
    p(escape(note),'small')
h('公式与可复算附件')
p('原始视频码率＝宽×高×每像素bit×fps。输入带宽帧率预算＝视频可用字节率÷每帧字节。压缩视频平均帧长＝视频bit率÷8÷fps。SDRAM平均像素流量＝帧字节×（扫描刷新＋内容写入fps），另加参考帧、控制器协议和突发浪费。','small')
p('calculations.json保存全部计算输入和未四舍五入结果；source_extracts.json保存相关赛题原文和定位；source_receipt.json保存文档与RTL的SHA256。控制器Byte测试取既有720ns观测值，代替仅按状态机估算的约700ns粗值。所有建议码率均为预算，板端测量后再调整。','small')

pdf_path=OUT/'RGB像素格式与640x480视频播放可行性报告.pdf'
def decorate(c,d):
    c.setFont('CN',8)
    c.setFillColor(colors.HexColor('#52606d'))
    c.drawString(46,28,'FPGA-ANLU  |  2026-10-21  |  离线可行性评估')
    c.drawRightString(PAGE_W-46,28,str(d.page))
doc=SimpleDocTemplate(str(pdf_path),pagesize=A4,rightMargin=46,leftMargin=46,
                     topMargin=43,bottomMargin=48,title='像素格式与视频播放可行性报告',author='FPGA-ANLU')
doc.build(story,onFirstPage=decorate,onLaterPages=decorate)
receipt['output']={'path':str(pdf_path),'sha256':hashlib.sha256(pdf_path.read_bytes()).hexdigest()}
receipt['calculations_sha256']=hashlib.sha256((OUT/'calculations.json').read_bytes()).hexdigest()
(OUT/'source_receipt.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2),encoding='utf-8')
print('REPORT_CREATED',pdf_path)
print('PAGES',len(PdfReader(pdf_path).pages))
print(json.dumps(calc,ensure_ascii=False,indent=2))
