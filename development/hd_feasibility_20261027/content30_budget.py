"""Recompute 1080p30 content budgets from saved project measurements."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
manifest = json.loads((ROOT / 'development/video33_work/media1080/manifest.json').read_text(encoding='utf-8-sig'))
decode = json.loads((ROOT / 'development/video34_work/native1080/frame000_decode_summary.json').read_text(encoding='utf-8-sig'))
q65 = manifest['quality_statistics']['65']
fps = 30
audio_bps = manifest['spi_budget']['pcm_Bps']
other_bps = manifest['spi_budget']['other_Bps']
read_bps = 1920 * 1080 * 3 / 2 * 30
frame_write_bytes = 120 * 68 * 96 * 4
write15_bps = frame_write_bytes * 15
write30_bps = frame_write_bytes * fps
read_bl4_per_s = read_bps / 16
write_blocks_per_s = 120 * 68 * 6 * fps
result = {
    'scope': 'Calculation only; existing 15fps samples extrapolated to 30fps, not a newly encoded 30fps file or board result.',
    'content_frame_budget_ms': 1000 / fps,
    'hdmi_nominal': {'pixel_hz': 74_250_000, 'serial_ddr_clock_hz': 371_250_000, 'data_lane_bps': 742_500_000, 'scan_hz': 30, 'same_for_repeated15_or_unique30': True},
    'tf': {
        'raw_12p5mhz_Bps': 12_500_000 / 8,
        'historical_model_service_Bps': manifest['spi_budget']['historical_service_Bps'],
        'q65_15fps_mean_jpeg_bytes': q65['mean_frame_bytes'],
        'jpeg_30fps_Mbps_estimate': q65['mean_frame_bytes'] * fps * 8 / 1e6,
        'mjp_audio_other_30fps_Bps_estimate': q65['mjp_average_Bps'] * 2 + audio_bps + other_bps,
        'largest_sample_frame_record_plus_audio_other_30fps_Bps': q65['mjp_window_peak']['1']['max_mjp_bytes_per_window'] * fps + audio_bps + other_bps,
        'raw_25mhz_Bps': 25_000_000 / 8,
        'method': 'Double saved MJP video byte rate; retain PCM and miscellaneous byte rates. New 600-frame encoding/quality and actual card throughput remain pending.'
    },
    'decode': {
        'observed_first_frame_cycles': decode['observed_cycles'],
        'model_clock_hz': 100_000_000,
        'first_frame_ms_at_100mhz': decode['observed_cycles'] / 100_000,
        'first_frame_only_throughput_fps_at_100mhz': 100_000_000 / decode['observed_cycles'],
        'clock_hz_for_same_first_frame_cycles_at_30fps': decode['observed_cycles'] * fps,
        'native_samples_per_padded_frame': 120 * 68 * 6 * 64,
        'one_native_sample_per_cycle_floor_ms_at_100mhz': 120 * 68 * 6 * 64 / 100_000,
        'note': 'First-frame measurement does not characterize all frames. Decoder/SDRAM 100MHz production integration and STA remain pending.'
    },
    'sdram_yuv420': {
        'read_30hz_Bps': read_bps,
        'padded_write_frame_bytes': frame_write_bytes,
        'write_content15_Bps': write15_bps,
        'write_content30_Bps': write30_bps,
        'total_15_content_30_scan_Bps': read_bps + write15_bps,
        'total_30_content_30_scan_Bps': read_bps + write30_bps,
        'payload_ratio_30_over_15_content': (read_bps + write30_bps) / (read_bps + write15_bps),
        'raw_50mhz_Bps': 50_000_000 * 4,
        'raw_100mhz_Bps': 100_000_000 * 4,
        'ideal_app_cycles_per_second_read6_write18': read_bl4_per_s * 6 + write_blocks_per_s * 18,
        'ideal_app_cycles_per_second_read7_write18': read_bl4_per_s * 7 + write_blocks_per_s * 18,
        'video_double_buffer_bytes': frame_write_bytes * 2,
        'assumptions': 'Each scanned chroma sample read once with row reuse; 1088 padded write lines and 1080 visible read lines; app transaction estimates exclude refresh/busy and physical timing.'
    },
    'scheduler': {'pcm_hz': 48000, 'samples_per_content_frame_15fps': 3200, 'samples_per_content_frame_30fps': 1600, 'frames_in_20s_30fps': 600},
}
output = Path(__file__).with_name('content30_budget.json')
output.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')
print(json.dumps(result, ensure_ascii=False, indent=2))
