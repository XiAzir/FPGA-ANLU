from pathlib import Path
import hashlib,json
root=Path('E:/VSCODE-project/FPGA-ANLU')
p=root/'development/player_pcm_waveform_keyfreeze'
parent=root/'development/player_pcm_waveform_freeze/checkpoints/waveform_freeze_20261012_candidate'
def sha(f): return hashlib.sha256(f.read_bytes()).hexdigest().upper()
same,changed=[],[]
for f in sorted((parent/'src/user_source').rglob('*')):
    if f.is_file():
        rel=f.relative_to(parent/'src')
        (same if sha(f)==sha(p/'src'/rel) else changed).append(rel.as_posix())
assert set(changed)=={'user_source/hdl_source/top_tf_hdmi_audio.v','user_source/hdl_source/player_status_monitor.v','user_source/hdl_source/player_pcm_waveform.v','user_source/hdl_source/player_adjust_control.v'}
(p/'build/model/parent_source_audit.json').write_text(json.dumps({'parentVersion':'C11203','parentFrozenFiles':143,'parentManifestSha256':sha(parent/'manifest.json'),'unchangedInheritedSources':same,'changedSources':changed},indent=2),encoding='utf-8')
(p/'build/model/normalize_project.tcl').write_text('cd '+p.as_posix()+'/src/td_project\nif {[catch {\n import_device eagle_s20.db -package EG4S20BG256\n open_project AC201_tf_hdmi.al -single_run\n close_project\n} message]} { puts "PROJECT_NORMALIZATION_ERROR: $message"; exit 1 }\nputs PROJECT_NORMALIZATION_COMPLETE\nexit\n',encoding='utf-8')
(p/'README.md').write_text('''# C11204 按键冻结波形诊断

从C11203冻结143文件逐项哈希核验后隔离复制，未复制数据库。默认动态，不再自动三秒冻结。PLAY模式同时短按KEY0+KEY1并松开，VS冻结当前可见front；再短按双键恢复动态。短按须两键稳定按下重叠，建议约0.2~0.5秒；双键长按仍恢复B/C默认，编辑模式双短无操作。长KEY1切源解除冻结，新源动态显示，需要时再双短冻结。HOLD标题仅在真正帧边界冻结后显示。

若尚无有效front则等待完整窗提交；同沿按钮/VS读取旧请求可延到下一VS。恢复丢弃back部分窗，保留旧front到新窗VS提交；声音照播、无audio反压。原窗口128组min/max×4px/57纵向档不变。物理实现重布局，候选不是重影修复，板测待验证。成功基线仍C11201；TF不改、不写Flash。
''',encoding='utf-8')
print(json.dumps({'unchanged':len(same),'changed':changed}))
