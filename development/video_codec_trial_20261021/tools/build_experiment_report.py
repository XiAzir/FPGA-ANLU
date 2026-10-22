from pathlib import Path
import json,hashlib
from xml.sax.saxutils import escape
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import SimpleDocTemplate,Paragraph,Spacer,Table,TableStyle,PageBreak,Image

ROOT=Path(__file__).resolve().parents[1]
OUT=Path('E:/QQ CACHE/Download/安路资料/开发记录/专题记录/视频素材实验_20261021')
R=json.loads((OUT/'experiment_results.json').read_text(encoding='utf-8'))
pdfmetrics.registerFont(TTFont('CN','C:/Windows/Fonts/simsun.ttc'))
pdfmetrics.registerFont(TTFont('CNBold','C:/Windows/Fonts/simhei.ttf'))
pdfmetrics.registerFontFamily('CN',normal='CN',bold='CNBold',italic='CN',boldItalic='CNBold')
S={k:ParagraphStyle(k,fontName='CNBold' if k in ['title','h','head'] else 'CN',
                   fontSize=size,leading=leading,spaceAfter=after,wordWrap='CJK')
   for k,size,leading,after in [('title',19,27,13),('h',13,19,9),('body',10,16.5,8),('small',8.5,13,6),('cell',9,13,0),('head',9,13,0)]}
story=[];width=A4[0]-92
def p(t,k='body'):story.append(Paragraph(t,S[k]))
def h(t):p(t,'h')
def page(t):story.append(PageBreak());h(t)
def table(head,rows,weights):
    data=[[Paragraph(escape(str(x)),S['head']) for x in head]]+[[Paragraph(escape(str(x)),S['cell']) for x in r] for r in rows]
    t=Table(data,colWidths=[width*x/sum(weights) for x in weights],repeatRows=1,hAlign='LEFT')
    t.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,0),colors.HexColor('#e9eef3')),('VALIGN',(0,0),(-1,-1),'TOP'),
      ('LEFTPADDING',(0,0),(-1,-1),7),('RIGHTPADDING',(0,0),(-1,-1),7),('TOPPADDING',(0,0),(-1,-1),6),
      ('BOTTOMPADDING',(0,0),(-1,-1),6),('LINEBELOW',(0,0),(-1,0),.6,colors.HexColor('#7c8b99')),
      ('LINEBELOW',(0,1),(-1,-1),.3,colors.HexColor('#d4dce3'))]))
    story.append(t);story.append(Spacer(1,8))
def row(g,q):return next(x for x in R['all_encodings'] if x['geometry']==g and x['quality']==q)

p('本地视频编码与带宽实验','title')
p('FPGA-ANLU  C11318基线  2026年10月21日','small')
p('<b>选取原片第16至36秒，保留原声。640×480、15fps、JPEG Q95的视频平均4.610Mbps，加PCM原声5.378Mbps，素材读取预算成立。</b>30fps Q90样本的视频为6.631Mbps，加原声7.399Mbps，也处于先前工程预算。两项结论来自PC端编码与回读，FPGA解码资源和持续运行待下一阶段验证。')
h('素材与处理方法')
p('用户原片约59.65秒，1280×720、30fps、H.264，音频48kHz单声道AAC。截取16至36秒的运球和舞蹈片段，共20秒。保留全部画面时缩放至640×360，上下各60像素黑边组成640×480；另做满画面中心裁切640×480控制组，以及320×240比较组。')
p('原声解码为48kHz PCM16单声道，960000个样本、1920000字节。15fps版本300帧，30fps版本600帧。JPEG采用Pillow/libjpeg的Q参数、4:2:0、固定标准Huffman、非渐进编码；27组共编码并回读9000帧，逐帧记录大小与画质。')
h('15fps质量档位消融')
table(['档位','视频Mbps','加PCM Mbps','最大帧KB','有效画面PSNR'],[
 [f'Q{q}',f"{row('letterbox640',q)['video_Mbps']:.3f}",f"{row('letterbox640',q)['media_including_PCM_Mbps']:.3f}",
  f"{row('letterbox640',q)['max_frame_bytes']/1000:.2f}",f"{row('letterbox640',q)['active_picture_PSNR_RGB_dB']:.2f} dB"] for q in [85,90,95,97,99]
], [1,1,1.2,1.1,1.4])
p('先以Q95作硬件验证基线，Q97作为较高码率对照。Q99视频平均7.819Mbps，超过先前7.735Mbps视频预算，退出首选。Q值为本次编码器的质量参数。PSNR采用缩放后RGB888参考，并在统计中去除黑边；参考源本身已经过H.264压缩。','small')
h('原声与封装自检')
p('最终MOV回读出的JPEG流SHA256和PCM有效载荷SHA256均与封装前相同，保持300帧及20秒原声。另提供H.264/AAC预览MP4供观看。初次AVI出现时基/交织异常，失败产物保留在attempts/avi_timebase；最终MOV使用显式15fps时间戳，探测时长20.00秒。','small')

page('一  分辨率 帧率与缓存格式消融')
table(['画面与档位','帧率','视频Mbps','加PCM Mbps','最大帧KB'],[
 [label,str(row(g,q)['fps']),f"{row(g,q)['video_Mbps']:.3f}",f"{row(g,q)['media_including_PCM_Mbps']:.3f}",f"{row(g,q)['max_frame_bytes']/1000:.2f}"]
 for label,g,q in [('320×240 保持比例 Q95','letterbox320',95),('640×480 保持比例 Q95','letterbox640',95),
                  ('640×480 满画面裁切 Q95','crop640',95),('640×480 保持比例 Q97','letterbox640',97),
                  ('640×480 保持比例 Q85','letterbox640_30',85),('640×480 保持比例 Q90','letterbox640_30',90),
                  ('640×480 保持比例 Q95','letterbox640_30',95)]
], [2.2,.6,1.1,1.2,1.1])
p('满画面裁切Q95视频4.740Mbps，与带黑边Q95的4.610Mbps接近，说明本片段的预算余量也存在于裁切控制组。两个版本的空间内容不同，码率差额同时受裁切、缩放和黑边影响。源片背景较平整，后续应补高纹理、高运动和场景切换素材。')
p('30fps Q90视频6.631Mbps，最大单帧31.115KB。按先前0.9669104MB/s视频预算，其最大帧纯传输约32.18ms，接近33.33ms内容帧期限；卡等待和解码并发仍需预读缓冲。Q95提升到30fps时视频9.218Mbps，超过工程预算。此数据支持30fps的输入预算探索，整机最大帧率仍待实测。')
h('RGB565与RGB332量化影响')
table(['处理方式','有效画面RGB PSNR','说明'],[
 ['JPEG Q95 解码RGB888',f"{R['selected']['active_picture_PSNR_RGB_dB']:.2f} dB",'相对缩放参考，SSIM为0.997268'],
 ['直接量化RGB565',f"{R['format_quantization'][0]['active_PSNR_RGB_dB']:.2f} dB",'截取高位后复制位展开，测于JPEG之前'],
 ['JPEG Q95 后存RGB565',f"{R['selected_jpeg_then_RGB565_active_PSNR_RGB_dB']:.2f} dB",'包含JPEG和565两级误差'],
 ['直接量化RGB332',f"{R['format_quantization'][1]['active_PSNR_RGB_dB']:.2f} dB",'本素材色带和背景色块明显'],
], [1.6,1.1,2])
p('本轮继续建议图片RGB888，视频565作为资源/带宽候选，RGB332留作风格化对照。改存565主要减少帧缓存搬运；卡侧仍读取同一JPEG码流，硬件解码结构收益需独立综合。','small')

page('二  画质样例与下一步解码验证')
story.append(Image(str(ROOT/'inspection/quality_comparison.png'),width=width,height=width*536/1280))
p('两行分别为片段帧109和225，列为RGB888参考、JPEG Q95、RGB565、RGB332。样例图已缩小；全尺寸参考及JPEG位于工程实验目录。','small')
h('本次JPEG输入合同')
p('已解析所有编码帧：8-bit SOF0、YCbCr 4:2:0、单次交织扫描、标准固定Huffman表，同一Q档DQT/DHT一致，未写入渐进或重启间隔。640×480包含1200个MCU、7200个8×8 IDCT块；15fps要求4.608Mpixel/s和108000块/s，30fps要求翻倍。')
p('已准备4张独立JPEG及对应Pillow解码RGB888、RGB565小端参考，覆盖首帧、最大帧及其他动作帧。后续先评估ultraembedded/core_jpeg，公开README声明支持baseline/4:2:0/标准Huffman，许可Apache-2.0；实际安路资源、定点误差、块坐标次序与输出背压需本地仿真和TD综合验证。[1]')
h('B站案例核查')
p('BV1eAJR6tETi公开标题为“全国嵌入式大赛安陆fpga赛道，兄弟们求评价”，UP主“嵌入式小谦”。公开简介为“-”，字幕列表为空；可读取材料未给出SPI、像素格式、压缩方法或作品内部输出规格。API中的1920×1080是上传视频尺寸字段。评论内容引用用户提供文本，评论API读取遭自动审批审查以超出子任务授权范围为由拒绝，后续未重试。[2]')
h('下一步与当前状态')
p('先建立独立JPEG核工程，使用当前4张JPEG做无停顿、随机输入间隙和输出背压验证，再测EG4S20综合占用。当前静态余量2828 Slice、19 BRAM9K、20 DSP；输出块布局与现有紧凑帧缓存可能需要适配。独立验证通过后再整合连续文件、音频时间戳、完整帧提交与VS切换。生产C11318源码、约束和位流保持，视频RTL/板测尚未开展。')
p('[1] https://github.com/ultraembedded/core_jpeg<br/>[2] https://www.bilibili.com/video/BV1eAJR6tETi<br/>详细指标：同目录experiment_results.json与encoding_comparison.csv。工程工具、编码日志、失败封装、参考与夹具：development/video_codec_trial_20261021/。','small')

pdf=OUT/'本地视频编码与带宽实验报告.pdf'
def footer(c,d):
    c.setFont('CN',8);c.setFillColor(colors.HexColor('#555555'))
    c.drawString(46,27,'FPGA-ANLU  |  素材编码实验  |  2026-10-21');c.drawRightString(A4[0]-46,27,str(d.page))
SimpleDocTemplate(str(pdf),pagesize=A4,leftMargin=46,rightMargin=46,topMargin=43,bottomMargin=48,
                  title='本地视频编码与带宽实验',author='FPGA-ANLU').build(story,onFirstPage=footer,onLaterPages=footer)
print(pdf)
print(hashlib.sha256(pdf.read_bytes()).hexdigest())
