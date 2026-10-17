from pathlib import Path
p=Path(__file__).resolve().parent
base=p.parent/'player_spectrum_tf_margin'
s=(base/'package_candidate.py').read_text(encoding='utf-8')
s=s.replace("player_spectrum_observed","player_spectrum_tf_margin").replace("player_spectrum_tf_margin.bit","player_spectrum_clock_route.bit")
s=s.replace("AC201_player_spectrum_tf_margin","AC201_player_spectrum_clock_route")
s=s.replace("spectrum_tf_margin.bit","spectrum_clock_route.bit").replace("spectrum_tf_margin.info.json","spectrum_clock_route.info.json")
s=s.replace("music_spectrum_tf_margin_20261014","music_spectrum_clock_route_20261014")
s=s.replace("music_spectrum_observed_20261013","music_spectrum_tf_margin_20261014")
s=s.replace("spectrum_observed.bit","spectrum_tf_margin.bit")
s=s.replace("8CFD873C1B9727A18C8A3731233943B6C43D56DD56677623CDAEC0962B7A2AF4","AD3C0ED07482FF88B9F252AFC3862311DE752216A511FE7164782D56E4B8C895")
s=s.replace("F96C748747BD008A18461D5728247A7430C0AF1FF0BB4E87A6FBC8B5A5E9D626","0A1E83ECAB5B826E3F7480223D8BB511619337A460887D6500B7DC763F54A4ED")
s=s.replace("music_spectrum_observed_20261013_candidate","music_spectrum_tf_margin_20261014_candidate")
s=s.replace("changed=[];inherited=[]","changed=[];inherited=[];added=[]")
s=s.replace("assert base.is_file(),rel\n    (inherited", "if not base.is_file():added.append(rel);continue\n    (inherited")
start=s.index("allowed={");end=s.index("assert '<eram_init>",start)
s=s[:start]+"""allowed={'hdl_source/top_tf_hdmi_audio.v','hdl_source/player_status_monitor.v'}
assert set(changed)==allowed,changed
assert set(added)=={'hdl_source/player_status_mailbox.v'}
"""+s[end:]
s=s.replace("assert len(rows)==281","assert len(rows)==230")
s=s.replace("'parentFrozenFilesVerified':281","'parentFrozenFilesVerified':230")
s=s.replace("'version':'C11308'","'version':'C11309'")
s=s.replace("'parent':'C11307 partial progress; no BMP and WAV noise; tone/spectrum user-reported normal'","'parent':'C11308 failed board validation: images/controls work, green bands across all overlays, both audio sources silent, fixed left8 on595'")
s=s.replace("'changes':changed,","'changes':changed,'added':added,")
s=s.replace("'parent':'C11307','changed':changed,'inherited':inherited","'parent':'C11308','changed':changed,'added':added,'inherited':inherited")
s=s.replace("'changesScope':'TF SPI divisor0->2; passive raw512-byte SD CRC counters and sticky BMP failure detail; status E/F0/F1. Existing FFT/PHY/PLL/SDC inherited byte-for-byte.'","'changesScope':'Explicit EG_LOGIC_BUFG for125MHz serial clock; 595 scanning on50MHz system-clock BUFG with atomic requestACK snapshot; rst_all declared before use. TF divisor2, FFT, lane/PHY, PLL parameters and SDC inherited byte-for-byte.'")
s=s.replace("'limits':'Clock margin is an isolation experiment, not confirmed physical root cause. CRC counters do not prevent corrupted sectors or retry. Binary counter CDC diagnostic may briefly show a transitional count. Digital/STA evidence does not prove physical A/V.'","'limits':'Clock routing is an isolation candidate, not proven physical root cause. Existing missing external output delay/electrical measurements remain; protected BRAM dynamic behavior not simulated. Status scanning/mailbox tests prove digital logic only, not physical595. SD CRC counters do not prevent corrupted sectors or retry.'")
s=s.replace("'modelEvidence':'build/model source-bound tests plus structurally inherited C11307 full FFT/serializer evidence; no protected vendor BRAM dynamic simulation'","'modelEvidence':'C11309 actual595 serial pin-level decoding/mailbox and status pages; SD/BMP/SPI diagnostic model results inherited with identical production RTL hashes from C11308; FFT/serializer evidence inherited from unchanged C11307 source; no vendor protected BRAM simulation'")
s=s.replace("PROGRAM_SRAM/JTAG5MHz; DFC11308","PROGRAM_SRAM/JTAG5MHz; DFC11309")
needle="assert any('PASS' in f.read_text(encoding='utf-8-sig') for f in (p/'build/model').glob('*spi*log'))"
s=s.replace(needle,needle+"""
for kind in ('gate','routed'):
    clock_audit=readj(p/f'build/audit/{kind}_clock_route.json')
    assert clock_audit['status']=='PASS'
mailbox_logs=list((p/'build/model').glob('*mailbox*run*.log'))
assert mailbox_logs and any('PASS' in f.read_text(encoding='utf-8-sig') for f in mailbox_logs)
""")
start=s.index("readme='''");end=s.index("txt=json.dumps",start)
readme=(base/'build/delivery/README.md').read_text(encoding='utf-8')
a=readme.index('- E页')
details=readme[a:readme.index('本地：')]
readme="""# C11309：HDMI串行全局时钟与独立数码管扫描（实板待验证）

C11308用户反馈图片/切图/轮播/参数调节正常，但绿色条带覆盖图片/字幕/频谱，两音源无声且数码管左8持续固定，拨码未改变。当前候选给125MHz HDMI串行时钟增加显式全局缓冲，四路PAD与串行逻辑共享该时钟；数码管扫描改到既有50MHz系统全局时钟，显示值用完整32位请求/应答快照从pixel域传递。没有改变PLL频率/相位参数、HDMI序列化RTL、TF6.25MHz设置或频谱算法。不是已确认的根因修复；电气和完整实板效果待验证。

BitWriter PROGRAM_SRAM / JTAG5MHz，加载 spectrum_clock_route.bit，D页应为DFC11309。数码管启动前4秒为自检，之后完整轮转26秒。先看数码管能否轮转，再默认WAV检查画面/绿带/声音/频谱，长KEY1检查内置音阶。保持现有接线/拨码；若异常录至少28秒数码管并描述两音源，若仍左8则直接记录持续固定。该包不要求重新装TF素材。成功回退bmp_scale.bit=C11206仍随包保留。

"""+details+"""
本地：新增实际595引脚解码/跨时钟快照模型、当前状态页；父版SD/BMP/SPI模型仅在相同生产源SHA绑定下继承。完整TD综合/布线/nativehold/位流同源生成；gate及routed均核验显式第三GCLK、PLL→GCLK→四PAD及串行逻辑时钟连线、595三个PAD系统时钟连线、ROM系数/控制。新串行路由偏斜以审计JSON为准，不夸称改善数值。静态时序和数字模型不证明板上HDMI/595电气效果、整曲音频或唯一故障原因。未执行JTAG/TF写入/Flash。
"""
s=s[:start]+"readme="+repr(readme)+"\n"+s[end:]
(p/'package_candidate.py').write_text(s,encoding='utf-8')
print('C11309 packaging prepared; must wait for routed/model gates')

