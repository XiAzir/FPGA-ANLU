"""Write the C11320 delivery metadata from completed, bound verification results."""
from pathlib import Path
from datetime import datetime
import argparse
import hashlib
import json

ROOT = Path(__file__).resolve().parents[2]
WORK = ROOT / 'development/video20_work'
PLAYER = ROOT / 'development/player_video20'
PACKAGE = ROOT / 'deliverables/video20_c11320_20261021'
BIT_SHA = '2c97c1152d69a1a7a9b7681d543f3834c2a4fdd4a0f15ec0982bc90579310e6d'


def read(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))


def save(path, value):
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


parser = argparse.ArgumentParser()
parser.add_argument('--physical-result', required=True, type=Path)
args = parser.parse_args()
physical_path = args.physical_result.resolve()
physical = read(physical_path)
assert physical['status'] == 'PASS_AFTER_STARTUP_TRANSIENT'
checkpoint_binding = read(WORK / 'physical_final/checkpointed_20261022/run_input_binding.json')
assert checkpoint_binding['status'] == 'PASS'
binding_path = WORK / 'whole/D02/final_source_binding.json'
binding = read(binding_path)
assert binding['status'] == 'PASS'
pin = WORK / 'huffman/final_pin/runs/D02_final_health'
pin_receipt = read(pin / 'health_receipt.json')
assert read(pin / 'summary.json')['status'] == 'PASS'
assert pin_receipt['status'] == 'PASS'
photo_path = WORK / 'photo_regression/runs/photo_system_20261021_220234/summary.json'
assert read(photo_path)['status'] == 'PASS'
assert read(PLAYER / 'build/video_system_20261021_215350/summary.json')['status'] == 'PASS'
assert read(PLAYER / 'build/gate_verify/input_manifest.json')['status'] == 'PASS'
assert read(PLAYER / 'build/audit/gate_rom_init.json')['status'] == 'PASS'
assert read(PLAYER / 'build/audit/routed_rom_init.json')['status'] == 'PASS'
reader_result = ROOT / 'development/video19_work/cadence_analysis/runs/q90_reader_loop_20261021_204125_745999/result.json'
reader = read(reader_result)
assert reader['status'] == 'PASS'
reader_sha = hashlib.sha256((PLAYER / 'src/user_source/hdl_source/mjp_file_reader.v').read_bytes()).hexdigest()
assert reader_sha == reader['source_receipt']['reader_source_sha256'].lower()
assert hashlib.sha256((PACKAGE / 'video20.bit').read_bytes()).hexdigest() == BIT_SHA
slice_path = WORK / 'final_route_audit/posthold_slice_count.json'
slice_used = read(slice_path)['post_explicit_hold_routed_netlist_counts']['total_slice_primitives']
assert slice_used == 8637 and slice_used <= 8820
for name, expected in (
    ('VIDEO.MJP', '239a413b3fc9462ab362918177f3e62e7069f10559281815e7c3198457525c31'),
    ('TEST.WAV', '30eaf10a6ff1800163cecb3225cce685873b38c9a8e42635f1e5c92b0e95b5de'),
):
    assert hashlib.sha256((PACKAGE / name).read_bytes()).hexdigest() == expected

validation = {
    'status': 'OFFLINE_VERIFIED_BOARD_PENDING',
    'created_local': datetime.now().isoformat(),
    'source_binding_checks': binding['checks_count'],
    'checkpoint_replay_input_checks': checkpoint_binding['checks_count'],
    'area': {'slice': slice_used, 'total': 9800, 'percent': slice_used / 98,
             'baseline': 9554, 'saved': 9554 - slice_used, 'target_max': 8820,
             'evidence': str(slice_path)},
    'timing': {'setup_wns_ns': .795, 'hold_wns_ns': .024,
               'setup_tns_ns': 0, 'hold_tns_ns': 0},
    'application': {'status': 'PASS', 'ms': 221, 'commits': 3,
                    'original_peak_frame': 108, 'peak_decode_ns': 48234070,
                    'window_ns': 50000000, 'margin_ns': 1765930,
                    'original_pcm_samples_exact': 6408, 'late': 0, 'underflow': 0},
    'hdmi_pin': pin_receipt,
    'physical_sdram': physical,
    'photo_audio_fft': {'status': 'PASS', 'ms': 122, 'pixels_written_and_read': 307200,
                         'pcm_push': 6378, 'pcm_consume': 4447,
                         'fft_frames': 3, 'fft_bands': 72, 'max_abs_error': 0},
    'shared_idct': {'status': 'PASS', 'blocks': 48, 'transactions': 3072,
                    'read_safety_checks': 16300,
                    'threshold_54': 'PASS', 'threshold_53': 'READ_BEFORE_X_WRITE detected'},
    'new_y_gate': {'status': 'PASS', 'real_dsp_primitives': 14, 'transactions': 768},
    'rgb_exact': {'status': 'PASS', 'channel_comparisons': 98304},
    'inherited_reader': {
        'status': 'PRIOR_PASS_UNCHANGED_READER_AND_MEDIA', 'records': 302,
        'evidence': str(reader_result), 'reader_sha256': reader_sha,
        'scope': '300 source frames, wrap0, reset0; byte lengths/CRC and 16755 LBA checks'},
    'pending': ['Full 20-second whole-system replay', 'SDF simulation',
                'Board/TF/HDMI/key interaction and sustained playback'],
}
info = {
    'build_id': 'C11320', 'candidate': 'D02_shared_early_retime_DSP_profile_RGB',
    'status': validation['status'], 'created_local': validation['created_local'],
    'bit_sha256': BIT_SHA, 'slice_used': slice_used, 'slice_total': 9800,
    'slice_percent': slice_used / 98, 'slice_saved_vs_C11319': 917,
    'setup_wns_ns': .795, 'hold_wns_ns': .024, 'setup_tns_ns': 0, 'hold_tns_ns': 0,
    'lut': 16418, 'ff': 8814, 'bram9k': 62, 'dsp': 26, 'pll': 2, 'gclk': 3,
    'spi_mhz': 12.5, 'source_binding': str(binding_path),
    'physical_result': str(physical_path), 'hdmi_pin_run': str(pin),
    'media': {'storage': 'FAT32 TF card root: VIDEO.MJP and TEST.WAV',
              'width': 640, 'height': 480, 'fps': 15, 'frames': 300, 'seconds': 20,
              'content': 'Original 16-36 seconds; 640x360 picture with 60-pixel top/bottom bars',
              'jpeg_quality': 90, 'sampling': '420', 'video_framebuffer': 'RGB565',
              'photo_framebuffer': 'RGB888', 'pcm_rate_hz': 48000,
              'pcm_bits': 16, 'pcm_channels': 1, 'pcm_samples': 960000,
              'hdmi_channels': 'mono duplicated left/right',
              'jpeg_average_mbps': 3.3165176, 'files_gross_mbps': 4.1767224},
    'hardware': 'Board pending; no card, SRAM/JTAG or Flash programming performed',
    'validation_scope': {
        'application': 'Q90 peak108 at second-frame phase800; 50ms window; selected scenes',
        'hdmi': '355ms, four source frames vs independent C03 JPEG gold; TMDS vs AXIS; original PCM',
        'physical': 'Same frozen RTL, unchanged SHA-bound SDRAM controller gate and APUG011 pin model; nominal PLL replay',
        'timing': 'Final post-hold static timing; physical board and SDF pending'},
}
save(PACKAGE / 'validation_summary.json', validation)
save(PACKAGE / 'video20.info.json', info)
(PACKAGE / 'README.md').write_text('''# C11320 视频资源优化离线包

本轮90%目标已达到：8637/9800 Slice，88.13%，较C11319减少917。
Setup +0.795 ns、Hold +0.024 ns，TNS均0。

主文件：video20.bit（Build ID 00C11320）、VIDEO.MJP、TEST.WAV。
媒体存储在TF卡；位流配置播放器电路。视频保持640×480、15fps、20秒JPEG420 Q90，原声48kHz PCM16单声道经HDMI输出。

操作见操作说明.txt，离线验证范围见离线核验说明.txt和validation_summary.json。
实体板卡、完整20秒整机播放、按键和持续运行待现场验证。
''', encoding='utf-8')
(PACKAGE / '操作说明.txt').write_text(f'''C11320 / D02 视频资源优化候选包
阶段：面积与离线核验完成，实体板卡待实测。

资源：8637/9800 Slice=88.13%，较C11319减少917。
时序：Setup +0.795ns / Hold +0.024ns / TNS均0。
视频：原片16～36秒，640×480 /15fps /20秒 /300帧JPEG420 Q90。
画面为640×360内容加上下各60像素黑边，视频RGB565；图片RGB888。
原声：48kHz /PCM16 /单声道 /960000样本，经HDMI左右复制。

1. 位流为video20.bit，板上状态页Build ID为00C11320。
   SHA256：{BIT_SHA}
2. 将TF卡原TEST.WAV备份到电脑，再将本目录VIDEO.MJP、TEST.WAV复制到FAT32卡根目录，原BMP保留。
   安全弹出TF卡，板卡断电时插卡，沿用已稳定的电源/HDMI/JTAG接线。
3. 上电后用BitWriter的PROGRAM_SRAM加载video20.bit，等待成功并核对Build ID。
   此加载掉电后需再次进行。
4. KEY1、KEY2同时按住超过1.5秒，再全部松开，进入视频模式。
5. KEY1短按后松开：从开头重播；KEY2短按后松开：暂停/恢复。
   再次双键长按释放返回图片模式；原图片和频谱功能沿用。
6. 记录完整20秒、原声同步、回环、暂停/重播/切图、SD CRC、音频欠载和持续播放时长。

VIDEO.MJP和TEST.WAV存放TF卡；preview_q90_rgb565.mp4供电脑预览。
本轮沿用C11319同一份媒体；已装有相同SHA媒体的TF卡可继续使用。
C11319位流与离线包另行保留。
''', encoding='utf-8')
(PACKAGE / '离线核验说明.txt').write_text(f'''C11320 离线核验记录

面积：最终post-hold路由网表4334 MSLICE+4303 LSLICE=8637，88.13%。
综合15479 LUT/8740 FF；物理16418 LUT/8814 FF/62 BRAM/26 DSP/2 PLL/3 GCLK。
时序Setup+0.795ns/Hold+0.024ns，两项TNS0。SPI mode3 12.5MHz、PLL、SDC保持。

选中：共享两遍IDCT、独立输入/输出阶段调度、提前转置读取、Y冗余流水删除、精确181常数DSP、固定JPEG420/640×480编译配置、RGB亮度对比度代数简化。
消融：串行共享方案137.4718892ms迟帧淘汰；reader窄化+3LUT淘汰；目录/mapper无正收益淘汰；MCU窄化全帧精确但比固定配置多63LUT淘汰。旧失败全部保留。

应用模型221ms PASS：峰值原108帧在50ms窗口48.23407ms完成，余量1.76593ms；3 commits，6408原声样本，迟帧0、欠载0。
HDMI串行输出355ms PASS：6124468像素、4源帧对独立C03参考、3完整不同内容帧；送出12840 PCM样本，pin逐样本核对12839，最后一笔在流水；BCH/TERC clean。
照片122ms PASS：307200像素写/读，6378/4447 PCM，3 FFT帧72bands精确。
真实新Y DSP门级768事务精确；实际FFT gate 3帧72bands精确。
共享IDCT48块3072事务、16300读安全检查精确；54阈值正控PASS，53阈值负控检出提前读。RGB98304通道穷举精确。
系数ROM gate/routed各1536词3072lane零差异；四bank各27严格参数、192控制真值、28时钟检查通过。
源、阶段、数据库、位流、仿真兼容副本和HDMI独立参考绑定：{binding['checks_count']}项PASS。

器件模型：{physical['status']}，解码{physical['decoded_pixels']}像素，{physical['commits']} commits，{physical['distinct_displayed_frames']}不同显示内容帧，{physical['original_pcm_samples_exact']}原声样本。
同源冻结RTL、原SDRAM控制器gate及APUG011 IS42s32200模型、名义PLL重放；约709ns的5条启动诊断保留，运行期错误{len(physical['runtime_model_errors'])}。
旧run分别在100ms、190ms中断，重跑前经历执行权限/DLL错误；记录保留。2026-10-22分段检查点运行连续完成221ms，另有{checkpoint_binding['checks_count']}项媒体/脚本/优化设计输入哈希核对通过；完成记录见validation_summary.json。

全片302记录reader证据沿用相同源码/相同媒体的C11319结果，整机采用上述所列指定帧与场景。
SDF、完整20秒整机、实体TF/SDRAM/HDMI/按键和持续播放待实测。当前未上板、写卡或Flash。
''', encoding='utf-8')
print(json.dumps({'status': info['status'], 'package': str(PACKAGE),
                  'slice': slice_used, 'binding_checks': binding['checks_count']}, ensure_ascii=False))
