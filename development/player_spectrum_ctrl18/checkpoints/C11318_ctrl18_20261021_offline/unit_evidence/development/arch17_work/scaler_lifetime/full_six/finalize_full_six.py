from pathlib import Path
import hashlib,json
out=Path(__file__).resolve().parent

def sha(name): return hashlib.sha256((out/name).read_bytes()).hexdigest()

receipt_path=out/'source_receipt.json'
r=json.loads(receipt_path.read_text(encoding='utf-8'))
log=out/'full_six_run.log'
text=log.read_text(encoding='utf-8')
expected='SCALER_INTEGRATION PASS images=6 pairs=C11316/CANDIDATE_HEADER_VALIDATED1 pixels=1843200 cycle_outputs=matched native=1 odd_vertical=1'
assert expected in text
assert text.count('SCALER_ASSET PASS')==12
assert len(r['images'])==12 and r['expected_total_pixels']==1843200
r['simulation'].update({
 'result':'PASS',
 'command':'pwsh -NoProfile -File development/arch17_work/scaler_lifetime/full_six/run_full_six.ps1',
 'started_beijing':'2026-10-21 12:33:36',
 'completed_beijing_log_last_write':'2026-10-21 12:49:53',
 'exit_code':0,
 'compile_log_sha256':sha('full_six_compile.log'),
 'run_log_sha256':sha('full_six_run.log'),
 'stderr_sha256':sha('full_six_run.err'),
 'compiled_vvp_sha256':sha('full_six.vvp'),
 'final_pass_line':expected,
 'finish_time_ps':86204775000,
 'asset_pass_records':12,
 'per_pair_pixels':307200,
 'public_output_compare_width_bits':160,
 'compile_attempt1':'Compile-only failure because copied legacy debug message referenced pre-rename hierarchy dut.u_scale.*; no simulation executed. Preserved as compile_attempt1_hierarchy.log. Removed that diagnostic-only hierarchical probe in the generated TB and recompiled successfully.'
})
r['testbench_as_run']['sha256']=sha('tb_full_six.v')
for key,name in [('baseline_engine_as_run','bmp_scale_engine_base_pair.v'),('candidate_engine_as_run','bmp_scale_engine_candidate_pair.v'),('baseline_loader_as_run','tf_bmp_file_player_base_pair.v'),('candidate_loader_as_run','tf_bmp_file_player_candidate_pair.v')]:
 r[key]['sha256']=sha(name)
r['reproduction']={
 'prepare_command':'python development/arch17_work/scaler_lifetime/full_six/prepare_full_six.py',
 'prepare_script_sha256':sha('prepare_full_six.py'),
 'run_command':'pwsh -NoProfile -File development/arch17_work/scaler_lifetime/full_six/run_full_six.ps1',
 'runner_sha256':sha('run_full_six.ps1'),
 'compile_command':'iverilog -g2001 -s tb_scaler_full_loader -o full_six.vvp bmp_scale_engine_base_pair.v bmp_scale_engine_candidate_pair.v tf_bmp_file_player_base_pair.v tf_bmp_file_player_candidate_pair.v ../key_press_debounce.v tb_full_six.v',
 'runtime_command':'vvp full_six.vvp'
}
receipt_path.write_text(json.dumps(r,indent=2)+'\n',encoding='utf-8')

readme='''# C11316 scaler header-lifetime full six-image pair\n\n结论：fresh Icarus 配对回归 PASS。Baseline 是 C11316 scaler engine SHA `f3d77c0dcaac1a43c59e30deb51b06988a81a9d91f0c6135f0eb17158057c04c`；candidate engine SHA `cde50900d2307674272134b2043c1cd26b53f1372fad913eef1b227a7f9706e2`；两侧使用完全相同的 C11316 loader SHA `8c4c61c8f8474ae44115c3ac0a056910886996302cd0845b775cf00a8b28f5b7`，生产实例 `.HEADER_VALIDATED(1)`。未修改 candidate/main/C11316父源码或冻结文件。\n\nTB 并行运行六个真实loader/scaler pair。每个 pair 都用相同 BMP 输入并各自对 640×480 输出的 307200 个 RGB24 像素逐字比对 golden；baseline 与 candidate 的 loader 160-bit `observation`（全部公开输出）在每个非reset下降沿逐拍比较。六图总输出1843200像素。完成条件要求两侧六个 done 全部置位。\n\n结果摘录见 `full_six_run.log`：六组各打印 `SCALER_ASSET PASS`，末尾为 `SCALER_INTEGRATION PASS images=6 pairs=C11316/CANDIDATE_HEADER_VALIDATED1 pixels=1843200 cycle_outputs=matched native=1 odd_vertical=1`；Icarus exit 0，TB `$finish` at 86204775000ps。图像覆盖320×240 bottom-up、800×600 bottom-up、191×321 top-down padding3、512×128 letterbox、native 640×480、800×599 odd vertical。编译命令日志为空（无错误/告警），stderr为空。\n\n实际复现命令（PowerShell 7）：\n\n```powershell\npython development/arch17_work/scaler_lifetime/full_six/prepare_full_six.py\npwsh -NoProfile -File development/arch17_work/scaler_lifetime/full_six/run_full_six.ps1\n```\n\n源及媒体SHA、as-run副本SHA、参数、compile/run日志哈希和完成标记均记录在 `source_receipt.json`。生成器将 C11316 与 candidate engine 仅重命名 module identifier 后绑定到相同 C11316 loader 的两份同内容副本。第一次复制模板后的编译在 elaboration 时发现旧诊断代码使用 `dut.u_scale.*` 层级；该次只编译失败，日志保留在 `compile_attempt1_hierarchy.log`。生成器随后移除了仅用于pixel mismatch时打印的旧层级诊断，TB的golden逐像素检查和全部公开输出逐拍比较保持完整；重新编译和完整仿真通过。\n'''
(out/'README.md').write_text(readme,encoding='utf-8')
print(json.dumps({'result':'PASS','receipt_sha256':sha('source_receipt.json'),'readme_sha256':sha('README.md'),'run_log_sha256':sha('full_six_run.log'),'vvp_sha256':sha('full_six.vvp')},indent=2))
