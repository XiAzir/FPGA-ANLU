from pathlib import Path
from datetime import datetime,timezone,timedelta
import json,hashlib,zipfile,shutil,re
p=Path(__file__).resolve().parent;root=p.parents[1]
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest().upper()
def readj(f):return json.loads(f.read_text(encoding='utf-8-sig'))
r=readj(p/'build/delivery_verified.json');ck=Path(r['checkpoint']);manifest=readj(ck/'manifest.json')
for item in manifest:
    f=ck/item['path'];assert f.stat().st_size==item['bytes'] and sha(f)==item['sha256']
with zipfile.ZipFile(r['zip']) as z:
    assert z.testzip() is None
    rows=z.read('checksums.sha256').decode('ascii').splitlines()
    for row in rows:
        expected,name=row.split('  ',1);assert hashlib.sha256(z.read(name)).hexdigest().upper()==expected
    assert len(z.namelist())==6 and len(rows)==5
for f in (p/'build/manual/AC201_player_spectrum_observed.bit',root/'download/spectrum_observed.bit',root/'deliverables/spectrum_observed.bit'):
    assert sha(f)==r['bitSha256']
model=readj(p/'build/model/model_result.json')
for item in model['bound_sources'].values():assert sha(root/item['path'])==item['sha256'].upper()
old=root/'development/player_spectrum_private_init/checkpoints/music_spectrum_private_init_20261013_candidate'
old_manifest=readj(old/'manifest.json')
for item in old_manifest:
    f=old/item['path'];assert f.stat().st_size==item['bytes'] and sha(f)==item['sha256']
stamp=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
proof={'createdBeijing':stamp,'status':'PASS','candidateFiles':len(manifest),'preservedC11306Files':len(old_manifest),
       'zipMembers':6,'checksumRows':5,'modelBindings':len(model['bound_sources']),
       'bitSha256':r['bitSha256'],'zipSha256':r['zipSha256'],'scope':'Local artifact/source integrity only; no board validation'}
(p/'build/independent_delivery_verification.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
topic=docs/'专题记录/音频可视化/频谱柱_C11304_20261013/C11307_ROM读控制与ODDR诊断'
topic.mkdir(exist_ok=True)
for source,name in ((p/'build/delivery/README.md','操作卡.md'),(p/'build/delivery_verified.json','交付凭据.json'),
 (p/'build/model/model_result.json','模型结果.json'),(p/'build/audit/private_rom_init_audit.json','综合系数核验.json'),
 (p/'build/audit/routed_rom_init_audit.json','路由后系数核验.json'),(p/'build/audit/gate_rom_control_audit.json','综合读控制核验.json'),
 (p/'build/audit/routed_rom_control_audit.json','路由后读控制核验.json'),(p/'build/independent_delivery_verification.json','独立交付核验.json')):
    shutil.copyfile(source,topic/name)
feedback=readj(root/'development/player_spectrum_private_init/build/board_failure_20261013/feedback.json')
(topic/'C11306实板反馈.json').write_text(json.dumps(feedback,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(topic/'README.md').write_text(f'''# C11307 ROM读控制与ODDR准备沿、被动频谱诊断

更新：{stamp}（北京时间）。本地候选交付完成，实板PENDING；成功基线仍C11206。

## 现场结果与动作

C11306默认无音画，tone后有图/闪现亮点、音阶伴杂音、频谱空；原翻页/轮播/亮度对比度正常，用户报告旧文件回载正常。两视频DFC11306、1D880000、默认3300BB80/tone3B00BB80；源/FIFO/HDMI输入WAV前32768样本prefix均F485/flag7、format_bad0。本次未见C11305 mapper timeout；前缀冻结不证明后续或tone/实际TMDS内容。[反馈](C11306实板反馈.json)。C11306 live FAILED，原bit/ZIP/232快照不改。

新工程`E:/VSCODE-project/FPGA-ANLU/development/player_spectrum_observed`：

- 四系数ROM读通路显式控制对齐C11304 TD推断映射：Hann9b SP8K同步CEA；twiddle18b PDPW8K使用CE mux0/1、CSA/CSB最高位由FFT ISSUE控制、WE mux1/0，其余CLK/OCE/REG/GSR/RESET和地址/DOA-DOB照推断配置。前版将issue接CE而CS恒高，等价性未被证明。常量INIT保留，global eram_init仍off；对齐推断配置不等于已证实硅后因果/无写入行为。
- HDMI只将lane中S_oddr_data两位的准备沿从serial posedge改negedge。保持C11206 pixel marker posedge、wrapper直通和load/shift/位序；没有继承C11303的另外两个改动。独立108组数字延迟矩阵：baseline nominal27pass、boundary0/27；最小变体nominal+boundary54/54pass。注入D0/D1/PAD延迟非测量，未含真实眼图/抖动/亚稳态。
- 新增只读频谱诊断，B页完成FFT帧数（切源清零），C页8状态bit+上帧16bit最大幅值。状态从bit7到0为PCM见到/FFT完成/非零频段/Hann非零/twiddle非零/前台提交/前台非零/前台冻结。通常非静音运行FE、HOLD为FF；仅为阶段定位，不单凭某个瞬间判故障。B/C取代历史first_high_pos/data_offset两字段，D版本位置/翻页周期不变。

相对C11306仅8份user_source变化（lane、top、status、analyzer、overlay、ROM、generator、manifest），无新增生产文件。包门禁核对lane唯一样本沿差异、top去诊断/ID后与parent相同；其余85user_source及IP/引脚/SDC/PLL保持。诊断只去七段数码管，无路径回TF/audio/HDMI控制或FFT运算。

## 验证与边界

独立行为回归：312合成段+48真实音乐段+72集成段bit-exact，650像素和HOLD/恢复/切源/reset/stale通过；新遥测TB验证非零系数/完成帧/非零帧最大值/前台、HOLD时FFT继续、切源与global reset清零。35源绑定逐项核查。PRIVATE_ROM_BEHAVIORAL_SIM不使用受保护官方BRAM模型，不能声称其门级仿真通过。

正式gate和hold后routed导出网表分别核：1536系数零差异、4bank各27项MODE/位宽/CE/CS/OCE/CLK/WE/REG/GSR/RESET参数（共108）对齐。动态端口来自生产generator静态接线与manifest说明；参数匹配不证明实板读值。[综合/路由后读控制](路由后读控制核验.json)、[系数](路由后系数核验.json)。

TD6.2.178840 native规范化后首轮syn/physical/hold/bitgen均success，scope/scripts/DB一致。最终setup+0.365/hold+0.024ns/TNS0/coverage99.97%；16563LUT/9758reg/17926LE/44BRAM9K/11DSP/2GCLK。hold前HWNS-0.060/HTNS-0.154ns报告/DB保留build/prehold，nativefix_hold消除。候选281冻结、ZIP6成员/5行、35模型绑定、旧C11306 232冻结独立核验；旧位流与ZIP保持。未操作JTAG/TF/Flash。

唯一实物根因、白点/杂音是否消失、默认WAV与频谱反应、长期/冷启动均待板测；眼图/接收端和raw bit ROM数据未独立测量/解码。恢复ROM读控制是实际差异修正，ODDR变体解决的是数字模型中的混采风险，二者不构成实板已修复结论。

## 交付与下一步

[测试包](E:/VSCODE-project/FPGA-ANLU/deliverables/music_spectrum_observed_20261013.zip)、[操作卡](操作卡.md)。加载spectrum_observed.bit PROGRAM_SRAM/5MHz，D页DFC11307。先检查默认音乐/画面/柱，再长KEY1检查tone；仍异常请保留整轮数码管约22秒（特别B/C），异常回包内bmp_scale.bit。

bit SHA `{r['bitSha256']}`；ZIP SHA `{r['zipSha256']}`；manifest SHA `{r['manifestSha256']}`。[凭据](交付凭据.json)、[独立核验](独立交付核验.json)。
''',encoding='utf-8')
status=docs/'当前状态.md';s=status.read_text(encoding='utf-8-sig')
s=re.sub(r'^更新：.*$',f'更新：{stamp}（北京时间；C11306实板失败，C11307 ROM读控制/ODDR准备沿/被动诊断候选已本地交付/实板pending；成功基线C11206）。',s,count=1,flags=re.M)
s=s.replace('## 当前阶段\n','## 当前阶段\n\n- **C11307 ROM读控制/ODDR准备沿/被动频谱诊断候选已本地交付，实板待验证**：四ROM读控制对齐TD推断（globalinit off），仅serial ODDR两位准备改负沿、baseline marker/wrapper保持。B帧数/C状态+最大幅值诊断；35输入绑定/频谱gold/650像素/遥测TB、54组变体数字矩阵、gate+routed1536系数和108控制参数通过；最终setup+0.365/hold+0.024ns/TNS0/coverage99.97%，16563LUT/9758reg/17926LE/44BRAM/11DSP。281冻结/ZIP及旧C11306 232冻结核验。PROGRAM_SRAM/5MHz、DFC11307，实板白点/杂音/默认WAV/频谱与唯一因果未确认；未操作JTAG/TF/Flash。[候选/操作/证据](专题记录/音频可视化/频谱柱_C11304_20261013/C11307_ROM读控制与ODDR诊断/README.md)。\n',1)
s=re.sub(r'^0\. C11306停止推荐.*$', '0. 优先同条件加载C11307 spectrum_observed.bit、确认DFC11307；先默认WAV，再长KEY1。若异常录完整数码管一轮（约22秒，尤其B帧数/C阶段状态+最大幅值），凭读系数/完成FFT/显示阶段定位。候选未通过实板，旧失败版停止推荐。',s,count=1,flags=re.M)
status.write_text(s,encoding='utf-8')
with (docs/'工作日志/2026-10-13.md').open('a',encoding='utf-8') as f:
    f.write(f'''\n### {stamp[11:16]}｜C11307 ROM读控制/ODDR准备沿/被动诊断交付｜本地已完成/实板待验证

- 修正4系数ROM CE/CS/WE等读映射照TD推断；仅ODDR serial准备改negedge，pixel marker/wrapper保持；B=FFT帧数、C=8阶段标志+16bit上帧最大值，只读无控制反馈。8生产源改、其余85及IP/PLL/reset/约束/TF音频链路保持。两luna完成独立读路径审计/108组串行矩阵（变体54pass，旧boundary27反例），未板测。
- 35源/gold312+48+72段exact/650像素/遥测/HOLD/切源通过；PRIVATE_ROM_BEHAVIORAL_SIM不等于官方protected primitive sim。gate+routed1536系数/108控制参数相同；仅参数/静态读接线核验，不证明硅后read。
- TD全stage成功scope/DB/scripts一致；最终setup+0.365/hold+0.024/TNS0/coverage99.97%，16563LUT/9758reg/17926LE/44BRAM/11DSP。prehold -0.060/-0.154报告/DB保留。
- ZIP {r['zip']} SHA {r['zipSha256']}；bit SHA {r['bitSha256']}；281冻结manifest {r['manifestSha256']}，独立ZIP6成员/5行/35源/旧C11306 232冻结核对。旧位流/包保持，未操作JTAG/TF/Flash。
- 未完成：实板白点/杂音/默认音画/频谱反应、唯一根因/长期待确认。下一步加载spectrum_observed.bit PROGRAM_SRAM/5MHz、DFC11307，默认→tone；仍异常录一轮数码管含B/C。[专题](../专题记录/音频可视化/频谱柱_C11304_20261013/C11307_ROM读控制与ODDR诊断/README.md)。
''')
print(json.dumps(proof,indent=2))
