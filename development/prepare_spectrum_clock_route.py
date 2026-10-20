from pathlib import Path
import shutil,json,re
from datetime import datetime,timezone,timedelta
root=Path(__file__).resolve().parents[1]
old=root/'development/player_spectrum_tf_margin';new=root/'development/player_spectrum_clock_route'
assert not new.exists()
for name in ('src','scripts','sim'):
    shutil.copytree(old/name,new/name,ignore=shutil.ignore_patterns('__pycache__','*.db','*.vvp','AC201_tf_hdmi_Runs'))
for folder in ('scripts','sim'):
    for f in (new/folder).iterdir():
        if f.suffix in ('.ps1','.tcl','.py'):
            f.write_text(f.read_text(encoding='utf-8-sig').replace('player_spectrum_tf_margin','player_spectrum_clock_route'),encoding='utf-8')
f=new/'src/td_project/AC201_tf_hdmi.al'
f.write_text(f.read_text(encoding='utf-8-sig').replace('player_spectrum_tf_margin','player_spectrum_clock_route'),encoding='utf-8')
for name in ('top_tf_hdmi_audio.v','player_status_monitor.v'):
    f=new/'src/user_source/hdl_source'/name
    f.write_text(f.read_text(encoding='utf-8-sig').replace('C11308','C11309'),encoding='utf-8')
(new/'build/audit').mkdir(parents=True)
for f in (old/'build/audit').iterdir():
    if f.suffix in ('.py','.tcl'):shutil.copyfile(f,new/'build/audit'/f.name)
stamp=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
fb={'createdBeijing':stamp,'versionByConversation':'C11308','independentBuildIdReadable':False,'status':'FAILED_BOARD_VALIDATION','reportedBy':'user','beforeKEY1':'BMP/paging/autoplay/brightness/contrast work; green periodic bands cover images/OSD/spectrum; spectrum moving but silent','afterKEY1':'Same green bands and silent with moving spectrum','display':'Only leftmost8 continuously >30s; user confirms switch positions unchanged','evidence':'Two attached photos; no new video/diagnostic pages available','limits':'Cannot confirm SD CRC/precise BMP status or packet contents from fixed display; green band coverage supports examining output after overlays, not a proven root cause; clock routing inspection not proof of cause.'}
(old/'build/board_feedback_current/feedback.json').write_text(json.dumps(fb,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for f in (root/'download/spectrum_tf_margin.info.json',old/'build/manual/AC201_player_spectrum_tf_margin.info.json'):
    v=json.loads(f.read_text(encoding='utf-8-sig'));v['boardStatus']='FAILED_BOARD_VALIDATION';v['boardFeedback']=fb
    f.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
for source,name in [(Path(r'C:/Users/PENGYU~1/AppData/Local/Temp/codex-clipboard-ddd0511c-aa40-40df-b28a-eda3ebc732b3.jpg'),'green_bands.jpg'),(Path(r'C:/Users/PENGYU~1/AppData/Local/Temp/codex-clipboard-79d91e70-988f-49ad-8785-ed4f6a682769.jpg'),'fixed_left8.jpg')]:
    shutil.copyfile(source,old/'build/board_feedback_current'/name)
status=docs/'当前状态.md';v=status.read_text(encoding='utf-8-sig')
v=re.sub(r'^更新：.*$',f'更新：{stamp}（北京时间；C11308实板绿带/两音源无声/数码管固定左8失败，图片控制部分正常；C11309时钟路由隔离进行中，成功基线C11206）。',v,count=1,flags=re.M)
v=v.replace('**C11308 TF读余量/精确图片失败定位候选已本地交付，实板待验证**','**C11308实板失败，图片控制功能部分正常**')
v=v.replace('实际根因未确认、降速效果未上板；读取图片可能变慢。','用户反馈BMP/翻页/轮播/亮度对比度工作，但绿带覆盖全部图层、两音源频谱运动而无声、数码管左8持续固定超过30秒且拨码未动；版本仅上下文关联，无法独立读ID。降低TF速度对图片变化的单独因果未确认；CRC诊断无法读出。实际根因未确认。',1)
v=re.sub(r'^0\. 加载C11308.*$', '0. C11308停止推荐；C11309隔离增加串行时钟显式BUFG，595扫描移到独立50MHz系统时钟并用握手快照传递hex，先模型/新网表/STA后交付；不把现有本地通过当实板通过。',v,count=1,flags=re.M)
status.write_text(v,encoding='utf-8')
with (docs/'工作日志/2026-10-14.md').open('a',encoding='utf-8') as f:
    f.write(f'\n### {stamp[11:16]}｜C11308绿带/静音/数码管异常反馈｜继续定位\n\n- 用户两照片及补充：图片/翻页/轮播/参数控制正常；绿带覆盖BMP/OSD/频谱、两音源频谱运动但均无声；左8超过30s固定，拨码未动。版本关联仅上下文，无法读ID；不能声称SD CRC0或任何新诊断值。live FAILED，原bit/ZIP/230冻结不改。证据在development/player_spectrum_tf_margin/build/board_feedback_current。\n- 两只读审计：既有ODDR两输入均上升沿capture、D1下降沿output；PLL串行125MHz53负载直连无显式EG_PHY_GCLK，仅2反馈GCLK；clk4 skew0.326ns，四HDMI缺outputdelay。status RTL/IO/PLL与父版相同、GSR置位及25MHzPAD时钟连接合理，不能证明左8根因。\n- 下一步C11309独立工程新增serial BUFG，595扫描移50MHz已有系统GCLK+握手hex快照；待模型、三GCLK/同一clock PAD确认、全TD/STA通过后交付。外部电气与唯一根因未测；未JTAG/TF/Flash。\n')
print(new)

