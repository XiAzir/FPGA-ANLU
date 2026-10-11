"""Independent sample-domain count of the source DDS sign transitions.

Read-only source extraction; this is not a physical-clock or routed simulation.
"""
import json
import re
from pathlib import Path

root = Path(__file__).parent
source = root.parent.parent / 'src/user_source/hdl_source/hdmi_audio_tone_pcm_scale.v'
text = source.read_text(encoding='utf-8')
increments = [int(n) for n in re.findall(r"note_inc_lut\s*=\s*32'd(\d+)", text)]
assert len(increments) == 8
phase = 0
pending_pcm = 0
previous_pcm = None
windows = []
changes = 0
# The output takes the preceding registered sign; phase itself is a 32-bit sum.
# Keep the initial zero output, and compare all subsequent valid samples.
for sample in range(48000 * 8):
    output_pcm = pending_pcm
    if previous_pcm is not None and output_pcm != previous_pcm:
        changes += 1
    previous_pcm = output_pcm
    pending_pcm = 1000000 if phase & (1 << 31) else -1000000
    phase = (phase + increments[(sample // 24000) % 8]) & 0xffffffff
    if (sample + 1) % 48000 == 0:
        windows.append(changes)
        changes = 0

result = {
    'method': 'sample-domain mathematical model, 48000 samples per second, 24000 per note; source LUT, 32-bit phase sum, output sign register delay',
    'source': str(source),
    'increments': increments,
    'ideal_frequencies_hz': [x * 48000 / (1 << 32) for x in increments],
    'model_changes_per_aligned_second': windows,
    'video_values': {'0x02A7': 679, '0x0340': 832, '0x03F9': 1017, '0x022B': 555},
    'boundary': 'Matches observed transition counts; does not assert observed sample amplitudes, individual sample order, ACR/HDMI packet correctness or external waveform',
}
(root / 'tone_reference.json').write_text(json.dumps(result, indent=2), encoding='utf-8')
print(json.dumps({'model': windows, 'observed': result['video_values']}))
