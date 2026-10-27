from pathlib import Path
from collections import Counter
import argparse
import hashlib
import json

CTL = {0x354: 0, 0x0AB: 1, 0x154: 2, 0x2AB: 3}
TERC = {code: value for value, code in enumerate((
    0x29C, 0x263, 0x2E4, 0x2E2, 0x171, 0x11E, 0x18E, 0x13C,
    0x2CC, 0x139, 0x19C, 0x2C6, 0x28E, 0x271, 0x163, 0x2C3))}
PALETTE = ((255,255,255),(255,255,0),(0,255,255),(0,255,0),
           (255,0,255),(255,0,0),(0,0,255),(0,0,0))


def decode_rgb(code):
    qm = (code & 255) ^ (255 if code & 512 else 0)
    result = qm & 1
    for bit in range(1, 8):
        value = ((qm >> bit) ^ (qm >> (bit - 1))) & 1
        result |= (value ^ (0 if code & 256 else 1)) << bit
    return result


def ecc(data, bits):
    value = 0
    for bit in range(bits):
        value = (value >> 1) ^ (0x83 if (value ^ (data >> bit)) & 1 else 0)
    return value


def check(args):
    width, total, sync_width = (640,1000,96) if args.version == 37 else (1920,2000,8)
    source = Path(args.stream)
    state = 'control'
    started = False
    vp = dp = left = 0
    rgb_count = pixels = 0
    rgb_start = None
    first_rgb = None
    packets = Counter()
    bursts = []
    payload = []
    last_sync = [None,None]
    edge_at = [None,None]
    falling = [[],[]]
    pulse_widths = [Counter(),Counter()]
    unknown = 0
    valid_times = []
    error = None
    observed = 0

    def require(condition, message):
        if not condition:
            raise ValueError(f'word {observed}: {message}')

    def sync(value):
        for axis in (0,1):
            level = (value >> axis) & 1
            if last_sync[axis] is not None and level != last_sync[axis]:
                if edge_at[axis] is not None and last_sync[axis] == 0:
                    pulse_widths[axis][observed-edge_at[axis]] += 1
                edge_at[axis] = observed
                if level == 0:
                    falling[axis].append(observed)
            last_sync[axis] = level

    def packet():
        require(len(payload) == 32, f'data-island length {len(payload)}, expected 32')
        header = sum(((p[0] >> 2) & 1) << i for i,p in enumerate(payload))
        sub = [sum((((p[1] >> k) & 1) << (2*i)) |
                   (((p[2] >> k) & 1) << (2*i+1)) for i,p in enumerate(payload)) for k in range(4)]
        require(header >> 24 == ecc(header & 0xFFFFFF,24), 'header BCH mismatch')
        for k,value in enumerate(sub):
            require(value >> 56 == ecc(value & ((1 << 56)-1),56), f'subpacket {k} BCH mismatch')
        head = header & 0xFFFFFF
        body = [(sub[k] >> (8*b)) & 255 for k in range(4) for b in range(7)]
        require(head in (0,0x0D0282,0x190183), f'unexpected header {head:06x}')
        require((sum(body)+sum((head >> (8*b)) & 255 for b in range(3))) % 256 == 0,
                'InfoFrame checksum mismatch')
        if head == 0x0D0282:
            require(body[4] == 0,'AVI VIC is not zero')
        if head == 0x190183:
            require(bytes(body[1:9]) == b'FPGAANLU','SPD vendor differs')
        if head == 0:
            require(not any(body),'NULL body differs')
        packets[f'{head:06x}'] += 1

    try:
        with source.open() as stream:
            for line in stream:
                number, at, a,b,c,led = line.split()
                observed = int(number)
                if any('x' in code.lower() or 'z' in code.lower() for code in (a,b,c)):
                    unknown += 1
                    require(not started,'unknown value after video stream start')
                    continue
                lanes = tuple(int(code,16) for code in (a,b,c))
                if args.flip_word == observed:
                    lanes = (lanes[0] ^ 1,lanes[1],lanes[2])
                control = all(code in CTL for code in lanes)
                vg = lanes == (0x2CC,0x133,0x2CC)
                dg = lanes[1:] == (0x133,0x133) and lanes[0] in TERC and TERC[lanes[0]] >= 12
                if started:
                    valid_times.append(float(at))
                if control:
                    sync(CTL[lanes[0]])
                elif state in ('di_head','payload','di_tail') and lanes[0] in TERC:
                    sync(TERC[lanes[0]] & 3)

                if state == 'video' and control:
                    require(rgb_count == width,f'video row has {rgb_count} pixels, expected {width}')
                    bursts.append({'start':rgb_start,'pixels':rgb_count})
                    state = 'control'
                if state == 'video':
                    require(rgb_count < width,'video overruns row')
                    actual = tuple(decode_rgb(code) for code in reversed(lanes))
                    expected = PALETTE[rgb_count // (width//8)]
                    require(actual == expected,f'RGB x={rgb_count} got {actual}, expected {expected}')
                    pixels += 1
                    rgb_count += 1
                    continue
                if state == 'video_guard':
                    require(vg,'video guard is truncated')
                    left -= 1
                    if not left:
                        state = 'video'
                        rgb_count = 0
                        rgb_start = observed+1
                        if first_rgb is None:
                            first_rgb = rgb_start
                    continue
                if state == 'di_head':
                    require(dg,'data-island leading guard is truncated')
                    state = 'payload'
                    payload = []
                    continue
                if state == 'payload':
                    require(all(code in TERC for code in lanes),'invalid TERC4 symbol in packet')
                    decoded = tuple(TERC[code] for code in lanes)
                    require(decoded[0] & 8,'channel-0 packet marker missing')
                    payload.append(decoded)
                    if len(payload) == 32:
                        packet()
                        state = 'di_tail'
                        left = 2
                    continue
                if state == 'di_tail':
                    require(dg,'data-island trailing guard is missing')
                    left -= 1
                    if not left:
                        state = 'control'
                    continue
                if control:
                    vp = vp+1 if (CTL[lanes[1]],CTL[lanes[2]]) == (1,0) else 0
                    dp = dp+1 if (CTL[lanes[1]],CTL[lanes[2]]) == (1,1) else 0
                elif vg and vp >= 8:
                    started = True
                    state = 'video_guard'
                    left = 1
                    vp = dp = 0
                elif dg and dp >= 8:
                    state = 'di_head'
                    vp = dp = 0
                else:
                    require(not started,'symbol outside a video/data-island period')
                    vp = dp = 0

        hperiods = Counter(b-a for a,b in zip(falling[0],falling[0][1:]))
        require(len(bursts) >= 8,'fewer than 8 complete video rows')
        require(set(hperiods) == {total},f'horizontal periods {dict(hperiods)}')
        require(set(pulse_widths[0]) == {sync_width},f'horizontal low widths {dict(pulse_widths[0])}')
        require(packets['0d0282'] >= 1 and packets['190183'] >= 1 and packets['000000'] >= 1,
                f'metadata packet coverage {dict(packets)}')
    except ValueError as exc:
        error = str(exc)
    periods = [b-a for a,b in zip(valid_times,valid_times[1:])]
    result = {
        'status': 'PIN_PROTOCOL_WINDOW_FAIL' if error else 'PIN_PROTOCOL_WINDOW_PASS',
        'version': args.version, 'stream': str(source),
        'stream_sha256': hashlib.sha256(source.read_bytes()).hexdigest(),
        'captured_words': observed, 'unknown_before_video': unknown,
        'first_video_word': first_rgb, 'complete_video_rows': len(bursts),
        'rgb_pixels_checked': pixels, 'packets_by_header': dict(packets),
        'h_period_words': dict(Counter(b-a for a,b in zip(falling[0],falling[0][1:]))),
        'h_low_width_words': dict(pulse_widths[0]),
        'v_period_words': dict(Counter(b-a for a,b in zip(falling[1],falling[1][1:]))),
        'v_low_width_words': dict(pulse_widths[1]),
        'pixel_period_ns_min_max': [min(periods),max(periods)] if periods else [],
        'injected_lane0_bit0_word': args.flip_word, 'error': error,
        'scope': 'Original mapped gate and official EG4 PLL/ODDR/IO models; model-only 200ns PLL input reset and accelerated startup wait; short pin window, no SDF or physical receiver.'
    }
    Path(args.output).write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,ensure_ascii=False))
    return 1 if error else 0


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--version',type=int,choices=(37,38),required=True)
    parser.add_argument('--stream',required=True)
    parser.add_argument('--output',required=True)
    parser.add_argument('--flip-word',type=int)
    raise SystemExit(check(parser.parse_args()))
