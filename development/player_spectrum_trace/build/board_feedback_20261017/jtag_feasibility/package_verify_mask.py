"""Package only the original C11312's matching readback mask; no new bit."""
from pathlib import Path
from datetime import datetime,timezone,timedelta
import json,hashlib,zipfile,shutil,re

p=Path(__file__).resolve().parent
root=p.parents[4]
task=root/'development/player_spectrum_trace'
doc=Path('E:/QQ CACHE/Download/安路资料/开发记录/专题记录/音频可视化/频谱柱_C11304_20261013/C11312_实板反馈_20261017')
zip_path=root/'deliverables/c11312_sram_verify_mask_20261017.zip'
if zip_path.exists():raise SystemExit('Refuse to replace an existing delivery')
now=datetime.now(timezone(timedelta(hours=8)))
sha=lambda f:hashlib.sha256(f.read_bytes()).hexdigest()
original=root/'download/spectrum_trace.bit'
reference=p/'reference_mask/spectrum_trace.bit'
mask=p/'reference_mask/spectrum_trace.bmk'
expected='60ae6b971ce1f9ed09d76bec14cf88dfc25cdfe7cbbebe5dd9fc070115b812ce'
assert sha(original)==expected
without_date=lambda x:b'\n'.join(t for t in x.split(b'\n') if not t.startswith(b'# Date:'))
assert without_date(original.read_bytes())==without_date(reference.read_bytes())
manifest=json.loads((task/'checkpoints/music_spectrum_trace_20261015_candidate/manifest.json').read_text())
hold_path='build/manual/stage_evidence/hold_ed9d07bc-0e3f-4567-9b23-1910aa2b1f6e.json'
hold_entry=next(e for e in manifest['files'] if e['path']==hold_path)
frozen_root=task/'checkpoints/music_spectrum_trace_20261015_candidate'
assert sha(frozen_root/hold_path)==hold_entry['sha256']
hold_evidence=json.loads((frozen_root/hold_path).read_text())
db=task/'build/manual/AC201_tf_hdmi_pr.db'
assert sha(db)==hold_evidence['artifacts']['AC201_tf_hdmi_pr.db'],'Routed DB differs from frozen delivered hold evidence'
assert 'Generate bits mask file' in (p/'generate_verify_mask.log').read_text()
result={
 'created':now.isoformat(),'purpose':'Matching readback mask for original C11312, not a new firmware or a repair',
 'status':'OFFLINE_MASK_GENERATED_PENDING_HARDWARE_VERIFY',
 'original_bit_sha256':expected,'original_bit_bytes':original.stat().st_size,
 'mask_sha256':sha(mask),'mask_bytes':mask.stat().st_size,
 'routed_db_sha256':sha(db),'routed_db_matches_manifest_protected_frozen_hold_evidence':True,
 'regenerated_reference_only_date_comment_differs':True,
 'reference_comparison':json.loads((p/'reference_comparison.json').read_text()),
 'limits':['No board or cable operation by agent. No HDL/synthesis/place/route change.',
           'Unmasked bit_to_vec jtag_rdbk conversion was accepted for EG4S20, but emitted 0 masked bits even with a sibling bmk. It is NOT supplied as a validated masked verification sequence.',
           'Several diagnostic conversion option probes failed or did not apply the mask; logs retained. The hardware GUI Verify SRAM path must confirm acceptance of the mask before interpreting mismatches.',
           'Verify SRAM covers configuration RAM; official manual excludes user ERAM. It does not read arbitrary live FFs or prove runtime/physical timing.'],
}
readme='''# C11312 配置RAM回读校验辅助包

本包仅含原C11312的 `spectrum_trace.bmk` 掩码、来源校验证明和本说明，**没有新bit，不是修复版**。

## 实验室操作

1. 解压，将 `spectrum_trace.bmk` 放到已核对的 `E:\\anlu\\bit\\spectrum_trace.bit` 同目录，文件名基名保持一致。原bit保持原样。
2. 板卡和AL-LINK接法保持已验证状态。校验对象必须是板内当前加载的C11312；如果已回载基线，不能直接拿C11312校验它，须先按原成功方式加载这份C11312一次。加载后到校验结束期间不掉电、不替换位流。
3. 在BitWriter中选择器件EG4S20BG256和这份 `spectrum_trace.bit`，保持5MHz，将Mode/Operation改为 **Verify SRAM（VERIFY_SRAM）**，执行一次。若出现掩码选择框，选同目录的 `spectrum_trace.bmk`。
4. 把本次完整日志发回。若下拉框没有Verify SRAM，或提示不支持/找不到mask/无mask，发模式列表和错误；不要以普通Download成功代替本次校验结果。

本轮要比较芯片当前配置与原始位流，使用Verify SRAM操作；不涉及Flash固化。需要记录软件是否载入掩码和具体比较结果。单纯出现失配，尚不能直接断言芯片/下载器损坏，需先核对板内版本和动态位掩码是否正确应用。

## 文件来源与已验证范围

- 原bit：634280字节，SHA256 `60AE6B971CE1F9ED09D76BEC14CF88DFC25CDFE7CBBEBE5DD9FC070115B812CE`；实验室已由用户脚本截图确认一致。
- 掩码来自原C11312最终routed DB，DB与10月15日冻结manifest SHA相符。只执行bitgen -gen_mask到隔离目录，未重新综合/布局布线或修改源代码、约束和原交付bit。
- 隔离生成的参考bit与原交付bit除Date注释4字节外完全一致，配置内容逐字节相同。参考bit仅用于来源核对，没有装入本包。
- TD 6.2.178840已为EG4S20BG256生成bmk。原厂SWUG110第4.3.2说明Verify SRAM回读配置RAM，不包含用户ERAM；第4.3.10为Read Save SRAM，二者不同。
- **尚未实板Verify SRAM。** 本机离线bit_to_vec jtag_rdbk转换能运行，但测试转换日志仍为0 bits masked，不能作为正确应用本bmk的校验通过证据，也未把这些未验证向量发给用户。下一步由GUI Verify SRAM实际接收掩码及比较日志确认。

## 结果意义

校验通过仅表明本操作实际覆盖的配置位一致，不代表PLL物理时钟、复位时序、用户ERAM/FFT内容或音画功能正常。校验失败需要先审阅完整日志、掩码应用与失配位置。本轮根因仍未确定。
'''
result_bytes=(json.dumps(result,ensure_ascii=False,indent=2)+'\n').encode('utf-8')
with zipfile.ZipFile(zip_path,'x',compression=zipfile.ZIP_DEFLATED) as z:
 z.write(mask,'spectrum_trace.bmk')
 z.writestr('README_配置回读校验.md',readme.encode('utf-8'))
 z.writestr('mask_provenance.json',result_bytes)
with zipfile.ZipFile(zip_path) as z:
 assert z.testzip() is None
 assert set(z.namelist())=={'spectrum_trace.bmk','README_配置回读校验.md','mask_provenance.json'}
 assert hashlib.sha256(z.read('spectrum_trace.bmk')).hexdigest()==sha(mask)
receipt={**result,'zip_path':str(zip_path),'zip_sha256':sha(zip_path),'zip_bytes':zip_path.stat().st_size}
(p/'mask_delivery_receipt.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2),encoding='utf-8')
(doc/'mask_delivery_receipt.json').write_bytes((p/'mask_delivery_receipt.json').read_bytes())
(doc/'配置回读校验说明.md').write_text(readme,encoding='utf-8')
with (doc/'README.md').open('a',encoding='utf-8') as f:
 f.write(f'''\n## {now:%H:%M} 仅AL-LINK条件下的配置回读路线\n\n只读审计复核旧C11105 ChipWatcher source-IP物理断言、gate新增hub自动1ns约束时序失败，没有找到已证实可用的绕过方式；本轮未重建/交付ChipWatcher，不把旧失败当当前C11312根因。\n\n本机原厂SWUG110确认Verify SRAM和Read Save SRAM，SWUG111要求含调试核的bit才能采集任意内部信号。已从与冻结manifest一致的C11312最终DB隔离bitgen -gen_mask生成配套bmk，参考bit除Date注释4字节外与原bit完全相同；配置负载一致，原bit/旧ZIP/DB未改。交付c11312_sram_verify_mask_20261017.zip仅bmk/说明/证明，不含新bit。ZIP SHA {receipt['zip_sha256']}，CRC及掩码成员SHA通过。\n\n重要边界：离线jtag_rdbk向量转换虽成功，但仍报0 masked bits，尚未验证GUI是否正确装载bmk；错误mode/参数探测均留日志，不当通过。未运行program/download命令或连接板卡。下一步实验室在板内为C11312时选择Verify SRAM并发完整日志；要核对是否支持/装载掩码及实际比较，不能以普通Download成功替代。通过也不覆盖用户ERAM或运行/物理时序。详见配置回读校验说明.md。\n''')
state=Path('E:/QQ CACHE/Download/安路资料/开发记录/当前状态.md')
s=state.read_text(encoding='utf-8');s=re.sub(r'更新：2026-10-17 \d\d:\d\d','更新：2026-10-17 '+now.strftime('%H:%M'),s,count=1)
s=s.replace('先离线核查ChipWatcher插入/采集路线（历史断言、资源及1ns约束失败不能忽略），再安排独立硬件观测','ChipWatcher旧失败尚无已验证解法；已生成与原最终DB/配置匹配的bmk辅助包，下一步实验室Verify SRAM，须确认GUI掩码应用/实际比较日志；尚未实板校验，原bit未变')
state.write_text(s,encoding='utf-8')
log=Path('E:/QQ CACHE/Download/安路资料/开发记录/工作日志/2026-10-17.md')
with log.open('a',encoding='utf-8') as f:
 f.write(f'''\n### {now:%H:%M}｜配置回读辅助掩码｜离线生成/匹配验证完成，实际Verify SRAM待实验室\n\n- 原厂SWUG110第4.3.2/4.3.10支持Verify SRAM/Read Save SRAM；仅配置RAM、排除用户ERAM。SWUG111第2.4.2要求配套调试核bit采集内部信号，不能用现有普通C11312直接任意读FF。旧ChipWatcher新增hub自动1ns时序失败经只读子代理复审，未找到有证据的配置解法，未重建。\n- 原C11312最终PR DB与冻结manifest SHA一致，只在隔离目录bitgen -gen_mask；新参考bit与交付原bit仅Date注释4字节差异，配置内容相同。原bit SHA保持60AE6B...812CE。掩码SHA {sha(mask)}，大小{mask.stat().st_size}。\n- 本机转换探测：无效mode verify报错，-svf用法报不能打开，其他试探未启用mask；jtag_rdbk离线转换成功但0 bits masked，不能标掩码生效，更未执行program/download或连接设备。保留所有日志和限制，不向用户交付这些向量。\n- 交付仅含bmk/README/来源证明的{zip_path.name}，ZIP CRC/成员SHA通过；SHA {receipt['zip_sha256']}。实验室把bmk与原bit同目录，在板内当前为C11312时执行GUI Verify SRAM一次并回传日志；若无选项/掩码错误需先核，不作配置失败定论。无生产RTL/约束/旧bit/ZIP/DB改动，无新播放器版本，根因未定。\n''')
print(json.dumps({'zip':str(zip_path),'sha256':receipt['zip_sha256'],'bytes':receipt['zip_bytes'],'db_matches_frozen':True}))
