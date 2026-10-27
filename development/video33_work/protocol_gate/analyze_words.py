from pathlib import Path
from collections import Counter
import argparse
import hashlib
import json

CTL = {0x354: 0, 0x0AB: 1, 0x154: 2, 0x2AB: 3}
TERC4 = {value: nibble for nibble, value in enumerate([
    0x29C, 0x263, 0x2E4, 0x2E2, 0x171, 0x11E, 0x18E, 0x13C,
    0x2CC, 0x139, 0x19C, 0x2C6, 0x28E, 0x271, 0x163, 0x2C3,
])}
PALETTE = [(255,255,255),(255,255,0),(0,255,255),(0,255,0),
           (255,0,255),(255,0,0),(0,0,255),(0,0,0)]


def video_byte(word):
    q = (word & 255) ^ (255 if word & 512 else 0)
    value = q & 1
    for bit in range(1, 8):
        decoded = ((q >> bit) ^ (q >> (bit-1))) & 1
        if not word & 256:
            decoded ^= 1
        value |= decoded << bit
    return value


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('version',type=int,choices=[35,36])
    ap.add_argument('--flip-bit-word',type=int)
    ap.add_argument('--report-invalid-transitions',action='store_true')
    args = ap.parse_args()
    here = Path(__file__).resolve().parent
    width, total, vertical_total = (640, 1000, 550) if args.version == 35 else (1920, 2000, 1100)
    path = here / f'C{args.version}_words.txt'
    state = 'control'
    video_preamble = island_preamble = 0
    guard_remaining = 0
    payload_start = payload_length = 0
    burst_locked = False
    bursts = []
    island_lengths = []
    island_length = 0
    h_last = v_last = None
    h_edges, v_edges = [], []
    h_widths = {0: Counter(), 1: Counter()}
    v_widths = {0: Counter(), 1: Counter()}
    h_segments, v_segments = [], []
    h_changed_at = v_changed_at = None
    unknown = unknown_locked = locked_words = words = 0
    first_locked = None
    rgb_errors = rgb_checked = 0
    first_locked_payload = None
    rgb_errors_first_line = rgb_errors_later = 0
    first_errors = []
    violations = []
    island_started_locked = False

    def sync(code, index):
        nonlocal h_last,v_last,h_changed_at,v_changed_at
        h, v = code & 1, (code >> 1) & 1
        if h_last is not None and h != h_last:
            if h_changed_at is not None:
                h_widths[h_last][index-h_changed_at] += 1
                h_segments.append([h_changed_at,h_last,index-h_changed_at])
            h_changed_at = index
            h_edges.append([index,h])
        if v_last is not None and v != v_last:
            if v_changed_at is not None:
                v_widths[v_last][index-v_changed_at] += 1
                v_segments.append([v_changed_at,v_last,index-v_changed_at])
            v_changed_at = index
            v_edges.append([index,v])
        h_last, v_last = h, v

    with path.open() as stream:
        for line in stream:
            number, time_ns, a, b, c, led = line.split()
            number = int(number)
            words = number
            locked = led[2] == '0'  # Text prints D3..D0; D1 is index2.
            if locked:
                locked_words += 1
                if first_locked is None:
                    first_locked = number
            if any('x' in value.lower() or 'z' in value.lower() for value in (a,b,c)):
                unknown += 1
                unknown_locked += int(locked)
                continue
            lanes = tuple(int(value,16) for value in (a,b,c))
            if number == args.flip_bit_word:
                lanes = (lanes[0] ^ 1,lanes[1],lanes[2])
            control = all(value in CTL for value in lanes)
            video_guard = lanes == (0x2CC,0x133,0x2CC)
            island_guard = lanes[1:] == (0x133,0x133) and lanes[0] in TERC4 and TERC4[lanes[0]] >= 12
            if control:
                sync(CTL[lanes[0]],number)
            elif state in ('island','island_guard','island_tail') and lanes[0] in TERC4 and not video_guard:
                sync(TERC4[lanes[0]] & 3,number)

            if state == 'video' and control:
                bursts.append({'start':payload_start,'words':payload_length,'locked_at_start':burst_locked})
                state = 'control'
            if state == 'video':
                if locked:
                    if first_locked_payload is None:
                        first_locked_payload = payload_start
                    actual = tuple(video_byte(value) for value in reversed(lanes))
                    expected = PALETTE[min(payload_length//(width//8),7)]
                    rgb_checked += 1
                    if actual != expected:
                        rgb_errors += 1
                        if payload_start == first_locked_payload:
                            rgb_errors_first_line += 1
                        else:
                            rgb_errors_later += 1
                        if len(first_errors) < 12:
                            first_errors.append({'word':number,'x':payload_length,'expected':expected,'actual':actual})
                payload_length += 1
                continue
            if state == 'video_guard':
                if not video_guard:
                    raise ValueError(f'Video guard truncated at {number}: {lanes}')
                guard_remaining -= 1
                if guard_remaining == 0:
                    state = 'video'
                    payload_start = number+1
                    payload_length = 0
                    burst_locked = locked
                continue
            if state == 'island_guard':
                if not island_guard:
                    raise ValueError(f'Island guard truncated at {number}: {lanes}')
                guard_remaining -= 1
                if guard_remaining == 0:
                    state = 'island'
                    island_length = 0
                    island_started_locked = locked
                continue
            if state == 'island':
                if video_guard and args.report_invalid_transitions:
                    violations.append({'word':number,'type':'VIDEO_GUARD_INTERRUPTS_ISLAND',
                                       'island_payload_symbols':island_length,
                                       'payload_mod32':island_length%32,
                                       'island_started_locked':island_started_locked,
                                       'missing_island_trailing_guards':True,
                                       'missing_video_preamble':True})
                    island_lengths.append(island_length)
                    state = 'video_guard'
                    guard_remaining = 1
                    continue
                if island_guard:
                    island_lengths.append(island_length)
                    state = 'island_tail'
                else:
                    if not all(value in TERC4 for value in lanes):
                        raise ValueError(f'Unknown TERC4 payload at {number}: {lanes}')
                    island_length += 1
                continue
            if state == 'island_tail':
                if island_guard:
                    continue
                state = 'control'
            if control:
                video_preamble = video_preamble+1 if CTL[lanes[1]] == 1 and CTL[lanes[2]] == 0 else 0
                island_preamble = island_preamble+1 if CTL[lanes[1]] == 1 and CTL[lanes[2]] == 1 else 0
            elif video_guard and video_preamble >= 8:
                state = 'video_guard'
                guard_remaining = 1
                video_preamble = island_preamble = 0
            elif island_guard and island_preamble >= 8:
                state = 'island_guard'
                guard_remaining = 1
                video_preamble = island_preamble = 0
            else:
                video_preamble = island_preamble = 0

    h_falling = [index for index,level in h_edges if level == 0]
    v_falling = [index for index,level in v_edges if level == 0]
    h_periods = Counter(b-a for a,b in zip(h_falling,h_falling[1:]))
    v_periods = Counter(b-a for a,b in zip(v_falling,v_falling[1:]))
    locked_bursts = [burst for burst in bursts if burst['locked_at_start']]
    locked_h_falling = [index for index in h_falling if first_locked is not None and index >= first_locked]
    locked_h_periods = Counter(b-a for a,b in zip(locked_h_falling,locked_h_falling[1:]))
    frame_groups = []
    for burst in locked_bursts:
        if not frame_groups or burst['start']-frame_groups[-1]['last_line_start'] != total:
            frame_groups.append({'first_line_start':burst['start'],'last_line_start':burst['start'],'lines':0})
        frame_groups[-1]['last_line_start'] = burst['start']
        frame_groups[-1]['lines'] += 1
    frame_start_periods = Counter(b['first_line_start']-a['first_line_start'] for a,b in zip(frame_groups,frame_groups[1:]))
    timing_ok = bool(locked_bursts) and set(locked_h_periods) == {total} and {b['words'] for b in locked_bursts} == {width} and set(frame_start_periods) == {total*vertical_total}
    status = 'CAPTURE_REQUIRES_REVIEW'
    if timing_ok and not unknown_locked and not rgb_errors_later:
        status = 'DIGITAL_TIMING_PASS_STARTUP_RGB_DIFFERENCE' if rgb_errors_first_line else 'DIGITAL_PROTOCOL_LINE_CHECK_PASS'
    if violations:
        status = 'PROTOCOL_VIOLATIONS_DETECTED'
    result = {'status':status,'version':args.version,'captured_words':words,
              'first_locked_word':first_locked,'locked_words':locked_words,
              'unknown_words':unknown,'unknown_after_lock':unknown_locked,
              'h_period_words':dict(h_periods),'v_period_words':dict(v_periods),
              'locked_h_period_words':dict(locked_h_periods),
              'locked_h_width_words':{level:dict(Counter(length for start,value,length in h_segments if first_locked is not None and start >= first_locked and value == level)) for level in (0,1)},
              'locked_v_width_words':{level:dict(Counter(length for start,value,length in v_segments if first_locked is not None and start >= first_locked and value == level)) for level in (0,1)},
              'video_frame_start_period_words':dict(frame_start_periods),'video_frame_groups':frame_groups,
              'h_width_words':{key:dict(value) for key,value in h_widths.items()},
              'v_width_words':{key:dict(value) for key,value in v_widths.items()},
              'completed_video_bursts':len(bursts),'locked_video_bursts':len(locked_bursts),
              'locked_video_lengths':dict(Counter(b['words'] for b in locked_bursts)),
              'island_payload_lengths':dict(Counter(island_lengths)),
              'rgb_pixels_checked':rgb_checked,'rgb_mismatches':rgb_errors,'first_rgb_errors':first_errors,
              'rgb_mismatches_first_locked_line':rgb_errors_first_line,'rgb_mismatches_later_lines':rgb_errors_later,
              'first_video_bursts':bursts[:8],'last_video_bursts':bursts[-4:],
              'stream_sha256':hashlib.sha256(path.read_bytes()).hexdigest(),
              'injected_lane0_bit0_at_word':args.flip_bit_word,
              'protocol_violations':len(violations),
              'violations_started_after_lock':sum(v['island_started_locked'] for v in violations),
              'locked_interrupted_payload_lengths':dict(Counter(v['island_payload_symbols'] for v in violations if v['island_started_locked'])),
              'first_protocol_violations':violations[:8],
              'scope':'Original mapped gate netlist and official EG4 functional models; timer accelerated; no routed SDF or physical HDMI receiver.'}
    suffix = '_negative' if args.flip_bit_word else '_invalid_transitions' if args.report_invalid_transitions else ''
    (here/f'C{args.version}_analysis{suffix}.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))


if __name__ == '__main__':
    main()
