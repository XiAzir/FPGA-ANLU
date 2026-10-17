from pathlib import Path
from datetime import datetime, timezone, timedelta
import json, hashlib, zipfile, shutil, re

p=Path(__file__).resolve().parent
root=p.parents[1]
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
def sha(f): return hashlib.sha256(f.read_bytes()).hexdigest().upper()
def readj(f): return json.loads(f.read_text(encoding='utf-8-sig'))
receipt=readj(p/'build/delivery_verified.json')
checkpoint=Path(receipt['checkpoint']); manifest=readj(checkpoint/'manifest.json')
for item in manifest:
    f=checkpoint/item['path']
    assert f.stat().st_size==item['bytes'] and sha(f)==item['sha256']
zipp=Path(receipt['zip'])
with zipfile.ZipFile(zipp) as z:
    assert z.testzip() is None
    checks=z.read('checksums.sha256').decode('ascii').splitlines()
    for row in checks:
        expected,name=row.split('  ',1)
        assert hashlib.sha256(z.read(name)).hexdigest().upper()==expected
    assert len(z.namelist())==6 and len(checks)==5
for f in (p/'build/manual/AC201_player_spectrum_baseline_phy.bit',root/'download/spectrum_baseline_phy.bit',root/'deliverables/spectrum_baseline_phy.bit'):
    assert sha(f)==receipt['bitSha256']
model=readj(p/'build/model/model_result.json')
for item in model['bound_sources'].values():
    assert sha(root/item['path'])==item['sha256'].upper()
old_checkpoint=root/'development/player_spectrum/checkpoints/music_spectrum_20261013_candidate'
for item in readj(old_checkpoint/'manifest.json'):
    f=old_checkpoint/item['path']
    assert f.stat().st_size==item['bytes'] and sha(f)==item['sha256']
stamp=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
verification={'createdBeijing':stamp,'status':'PASS','candidateManifestFiles':len(manifest),'oldC11304ManifestFiles':325,
 'zipMembers':6,'checksumRows':5,'modelBindings':len(model['bound_sources']),
 'zipSha256':sha(zipp),'bitSha256':receipt['bitSha256'],
 'scope':'Local package/source integrity only, no board verification'}
(p/'build/independent_delivery_verification.json').write_text(json.dumps(verification,indent=2)+'\n',encoding='utf-8')
topic=docs/'专题记录/音频可视化/频谱柱_C11304_20261013/C11305_基线PHY恢复'
topic.mkdir(exist_ok=True)
for source,name in ((p/'build/delivery/README.md','操作卡.md'),(p/'build/delivery_verified.json','交付凭据.json'),
                    (p/'build/model/model_result.json','模型结果.json'),
                    (p/'build/audit/spectrum_rom_init_audit.json','系数初始化核验.json'),
                    (p/'build/audit/black_screen_audit.md','黑屏审计.md'),
                    (p/'build/independent_delivery_verification.json','独立交付校验.json')):
    shutil.copyfile(source,topic/name)
(topic/'README.md').write_text(f'''# C11305恢复基线HDMI发送电路

更新：{stamp}（北京时间）。本地候选交付完成，实板PENDING；成功基线仍为C11206。

## 失败与改动

用户报告C11304 KEY1前后黑屏无信号；后视频DFC11304确认版本，源/输入前缀CRC F485、flag7，无格式错误；名义秒48000 PCM及核内部锁定/帧事件不证明HDMI引脚正确。用户本次同供电/HDMI回载C11206后音画正常。原C11304模型/STA仅在本地范围有效，live标FAILED，旧bit/ZIP/325文件快照保留。

独立工程`E:/VSCODE-project/FPGA-ANLU/development/player_spectrum_baseline_phy`，相对C11304仅4份user_source改变：hdmi_phy_warpper.v和lane_lvds_10_1.v逐字恢复成功C11206；top/status两处ID改C11305。FFT/渲染/其余源码和IP/引脚/SDC不改。eram_init保持on，影响HDMI FIFO这一变量未排除。未发现能证明C11303边沿语义错误的静态证据；新布局亦不同，唯一实物根因未确认。[审计](黑屏审计.md)。

## 本地验证

频谱gold回归：312合成频段/48真实音乐频段/72集成频段bit-exact，650像素通过；HOLD/恢复/切源/reset/100ms stale通过，{len(model['bound_sources'])}输入SHA核对。27组串行器普通数字延迟矩阵通过；此模型不含glbl全局配置复位、真实电气/接收器裕量，不证明实板。[模型](模型结果.json)。

TD6.2.178840 syn/physical/nativehold/bitgen成功，全部stage证据链接一致。最终setup+0.308ns/hold+0.030ns/TNS0、coverage99.97%；16409LUT/9811reg/17914LE/44BRAM9K/11DSP/2GCLK。hold前+0.308/+0.003报告/DB在build/prehold保留。gate1536系数INIT零差异。首轮错误路径替换导致blackbox的失败log保留build/rejected_path_replacement.log，修正工程注册/runner路径后完整重编译，没有从失败轮发布位流。

ZIP 6成员/5校验行、{len(manifest)}冻结文件、29模型输入以及旧C11304 325冻结文件独立核验通过；原C11206/C11303/C11304 bit和旧ZIP哈希保持。未操作JTAG/TF/Flash。SOURCE恢复不等于旧路由恢复；实际接收器信号眼图/冷启动/长期未验证。

## 交付与下一步

[测试包](E:/VSCODE-project/FPGA-ANLU/deliverables/music_spectrum_baseline_phy_20261013.zip)，[操作卡](操作卡.md)。加载spectrum_baseline_phy.bit，PROGRAM_SRAM/5MHz，D页DFC11305。先确认默认音画，再长KEY1内部音阶；异常包内bmp_scale.bit回退。候选尚未通过实板，不升为成功版。

bit SHA256：`{receipt['bitSha256']}`；ZIP SHA256：`{receipt['zipSha256']}`；manifest SHA256：`{receipt['manifestSha256']}`。[交付凭据](交付凭据.json)、[独立核验](独立交付校验.json)。

若仍无信号，另建候选恢复eram_init off并以独立验证方法保持频谱系数初始化，或固定源隔离；这些下一分支尚未执行。
''',encoding='utf-8')
status=docs/'当前状态.md'; s=status.read_text(encoding='utf-8-sig')
s=re.sub(r'^更新：.*$',f'更新：{stamp}（北京时间；C11304实板失败，C11305本地隔离候选交付/实板pending，成功基线C11206）。',s,count=1,flags=re.M)
s=s.replace('## 当前阶段\n','## 当前阶段\n\n- **C11305基线PHY恢复候选已本地交付，实板待验证**：仅恢复成功C11206两份HDMI PHY文件并改ID，保留C11304真实频谱/eram_init on。新模型gold、27组串行器、gate1536系数INIT、TD全流程/时序及221冻结文件/ZIP核验通过；setup+0.308/hold+0.030ns/TNS0。D页DFC11305、PROGRAM_SRAM/5MHz。唯一根因未确认、实板未验证、未操作JTAG/TF/Flash。[候选/操作/证据](专题记录/音频可视化/频谱柱_C11304_20261013/C11305_基线PHY恢复/README.md)。\n',1)
s=s.replace('C11304真实频谱柱实板失败，C11305隔离修复进行中','C11304真实频谱柱实板失败，禁止作为成功版')
s=s.replace('C11305恢复C11206两份PHY文件，频谱/ERAM初始化暂不变；唯一根因未确认。','用户本次同条件回载C11206音画恢复正常。C11305恢复C11206两份PHY文件，频谱/ERAM初始化暂不变；唯一根因未确认。')
s=s.replace('0. C11304实板失败，停止作为测试推荐；本地制作C11305恢复成功C11206 PHY、保留频谱柱的隔离修复候选，完成时序/封存后交付板测。','0. C11304实板失败且本次同条件回载C11206恢复；优先同条件加载新C11305 spectrum_baseline_phy.bit、确认DFC11305和默认音画，再长KEY1对比两音源。候选实板未验证。')
status.write_text(s,encoding='utf-8')
failure=readj(root/'development/player_spectrum/build/board_failure_20261013/feedback.json')
for f in (root/'download/spectrum.info.json',root/'development/player_spectrum/build/manual/AC201_player_spectrum.info.json'):
    v=readj(f);v['boardFeedback']=failure
    f.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
with (docs/'工作日志/2026-10-13.md').open('a',encoding='utf-8') as f:
    f.write(f'''\n### {stamp[11:16]}｜C11305恢复基线PHY候选交付｜本地已完成/实板待验证

- 动作：新player_spectrum_baseline_phy仅恢复C11206两份PHY、两处ID C11305，保留频谱和eram_init on；旧C11304失败bit/ZIP/325快照保留，live FAILED，同条件回载C11206音画正常（用户反馈）。
- 验证：29源绑定、频谱gold/650像素/集成回归、27组数字串行器通过；1536系数gateINIT零差异；TD综合/物理/hold/bitgenstage一致；setup+0.308/hold+0.030ns/TNS0/coverage99.97%，16409LUT/9811reg/17914LE/44BRAM/11DSP。
- 交付：ZIP {receipt['zip']} SHA {receipt['zipSha256']}；bit SHA {receipt['bitSha256']}；221冻结文件manifest {receipt['manifestSha256']}；独立ZIP6成员/5行和旧C11304 325冻结逐项核验。第一次工程注册路径误替换blackbox修正后重编译；失败log保留，不发布失败轮。
- 未完成/影响：唯一实物原因未确认，ERAM初始化确实也作用HDMI核FIFO且未隔离；新模型不证明PAD/接收器/电气，音画/长期/冷启动待板测。未操作JTAG/TF/Flash。
- 下一步：用户加载spectrum_baseline_phy.bit PROGRAM_SRAM/5MHz，D页DFC11305；先默认音画，再长KEY1，两音源异常则回bmp_scale.bit。[详细证据](../专题记录/音频可视化/频谱柱_C11304_20261013/C11305_基线PHY恢复/README.md)。
''')
print(json.dumps(verification,indent=2))
