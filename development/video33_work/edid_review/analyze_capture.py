from pathlib import Path
import hashlib
import json
import zipfile

ROOT = Path(__file__).resolve().parents[3]
HERE = Path(__file__).resolve().parent
ARCHIVE = Path('E:/QQ CACHE/Download/EDID_result_20261027_123105_181.zip')
PREFIX = 'EDID_result_20261027_123105_181/'
OUTPUT = HERE / 'capture_20261027_123105_181'

# Nominal CTA names, checked against the Linux DRM CTA timing table.
CTA_NAMES = {
    3: '720x480p nominal 60Hz (59.94Hz at 27MHz)',
    4: '1280x720p60',
    5: '1920x1080i60',
    16: '1920x1080p60',
}


def detailed_timing(b, offset):
    clock = int.from_bytes(b[:2], 'little') * 10000
    h_active = b[2] | ((b[4] >> 4) << 8)
    h_blank = b[3] | ((b[4] & 15) << 8)
    v_active = b[5] | ((b[7] >> 4) << 8)
    v_blank = b[6] | ((b[7] & 15) << 8)
    h_front = b[8] | ((b[11] >> 6) << 8)
    h_sync = b[9] | (((b[11] >> 4) & 3) << 8)
    v_front = (b[10] >> 4) | (((b[11] >> 2) & 3) << 4)
    v_sync = (b[10] & 15) | ((b[11] & 3) << 4)
    h_total, v_total = h_active + h_blank, v_active + v_blank
    return {
        'offset_hex': hex(offset), 'raw_hex': b.hex(),
        'pixel_clock_mhz': clock / 1e6,
        'active': [h_active, v_active], 'total': [h_total, v_total],
        'front_porch': [h_front, v_front], 'sync_width': [h_sync, v_sync],
        'back_porch': [h_blank-h_front-h_sync, v_blank-v_front-v_sync],
        'interlaced': bool(b[17] & 128),
        'horizontal_khz': clock / h_total / 1000,
        'raster_rate_hz': clock / h_total / v_total,
    }


def parse_edid(raw):
    manufacturer = int.from_bytes(raw[8:10], 'big')
    result = {
        'manufacturer': ''.join(chr(64 + ((manufacturer >> shift) & 31)) for shift in (10, 5, 0)),
        'edid_version': f'{raw[18]}.{raw[19]}',
        'raw_bytes': len(raw),
        'checksums_mod256': [sum(raw[n:n+128]) % 256 for n in range(0, len(raw), 128)],
        'base_detailed_timings': [], 'range_descriptors': [],
        'standard_timings': [], 'cta_extensions': [],
    }
    assert raw[:8] == bytes.fromhex('00ffffffffffff00')
    assert len(raw) == 128 * (1 + raw[126])
    assert result['checksums_mod256'] == [0] * (1 + raw[126])

    for offset in range(38, 54, 2):
        a, b = raw[offset:offset+2]
        if (a, b) == (1, 1):
            continue
        width = (a + 31) * 8
        aspect = ((16, 10), (4, 3), (5, 4), (16, 9))[b >> 6]
        result['standard_timings'].append({
            'offset_hex': hex(offset), 'raw_hex': raw[offset:offset+2].hex(),
            'active': [width, width * aspect[1] // aspect[0]],
            'refresh_hz': (b & 63) + 60,
        })

    for offset in range(54, 126, 18):
        d = raw[offset:offset+18]
        if d[0] or d[1]:
            result['base_detailed_timings'].append(detailed_timing(d, offset))
        elif d[3] == 0xFC:
            result['product_name'] = d[5:18].decode('ascii').strip()
        elif d[3] == 0xFD:
            item = {'offset_hex': hex(offset), 'raw_hex': d.hex()}
            if raw[18:20] == bytes([1, 3]):
                item.update({'vertical_hz': [d[5], d[6]], 'horizontal_khz': [d[7], d[8]],
                             'max_pixel_clock_mhz': d[9] * 10})
            result['range_descriptors'].append(item)

    for start in range(128, len(raw), 128):
        ext = raw[start:start+128]
        if ext[0] != 2:
            continue
        cta = {'offset_hex': hex(start), 'version': ext[1], 'data_blocks': [],
               'video_descriptors': [], 'detailed_timings': []}
        offset = 4
        while offset < ext[2]:
            header = ext[offset]
            tag, length = header >> 5, header & 31
            data = ext[offset+1:offset+1+length]
            cta['data_blocks'].append({'offset_hex': hex(start+offset), 'tag': tag,
                                       'payload_hex': data.hex()})
            if tag == 2:
                for index, value in enumerate(data):
                    vic = value & 127
                    cta['video_descriptors'].append({
                        'offset_hex': hex(start+offset+1+index), 'raw_hex': f'{value:02x}',
                        'vic': vic, 'native': bool(value & 128),
                        'mode': CTA_NAMES.get(vic, 'reserved' if vic == 0 else 'unmapped'),
                    })
            elif tag == 3 and data[:3] == bytes.fromhex('030c00'):
                cta['hdmi_vsdb'] = {'offset_hex': hex(start+offset), 'raw_hex': data.hex(),
                                    'max_tmds_clock_mhz': data[6] * 5}
            offset += 1 + length
        for offset in range(ext[2], 127-17, 18):
            d = ext[offset:offset+18]
            if d[0] or d[1]:
                cta['detailed_timings'].append(detailed_timing(d, start+offset))
        result['cta_extensions'].append(cta)
    return result


def main():
    OUTPUT.mkdir()
    with zipfile.ZipFile(ARCHIVE) as z:
        assert z.testzip() is None
        capture = json.loads(z.read(PREFIX+'capture.json').decode('utf-8-sig'))
        monitors = []
        for monitor in capture['monitors']:
            raw = z.read(PREFIX+monitor['raw_file'])
            assert hashlib.sha256(raw).hexdigest() == monitor['sha256']
            (OUTPUT/monitor['raw_file']).write_bytes(raw)
            decoded = parse_edid(raw)
            monitors.append({'number': monitor['monitor_number'], 'windows_name': monitor['windows_name'],
                             'instance_name': monitor['instance_name'], 'sha256': monitor['sha256'],
                             'interpretation': decoded})
        (OUTPUT/'capture.json').write_bytes(z.read(PREFIX+'capture.json'))

    result = {
        'archive': str(ARCHIVE), 'archive_sha256': hashlib.sha256(ARCHIVE.read_bytes()).hexdigest(),
        'capture_time': capture['recorded_at'], 'monitors': monitors,
        'identity': {'notebook_panel': 1, 'fpga_display': 2,
                     'basis': 'User confirmed exactly two displays, one notebook panel and one FPGA screen; Windows identities and native timings distinguish them.'},
        'comparisons': [
            {'build': 'C33/C36', 'active': [1920, 1080], 'total': [2000, 1100],
             'pixel_clock_mhz': 33, 'horizontal_khz': 33e3/2000,
             'scan_hz': 33e6/2000/1100, 'user_result': 'no signal'},
            {'build': 'C35', 'active': [640, 480], 'total': [1000, 550],
             'pixel_clock_mhz': 33, 'horizontal_khz': 33e3/1000,
             'scan_hz': 33e6/1000/550, 'user_result': 'stable complete colorbars'},
        ],
        'edid_caveats': [
            'External display range descriptor states 58-62Hz, while CTA DTD also lists 1280x720 at 50Hz.',
            'External CTA video block contains reserved VIC0 entries.',
            'EDID mode declarations and input limits are advertised capabilities; the physical C36 TMDS stream has not been decoded.',
        ],
        '1080p60_scan_15fps_content_budget': {
            'content_fps': 15, 'scan_hz': 60, 'scan_repeats_per_content_frame': 4,
            'pixel_clock_mhz': 148.5, 'ddr_serializer_clock_mhz': 742.5,
            'tmds_lane_bit_rate_mbps': 1485,
            'yuv420_visible_scan_reads_bytes_s': 1920*1080*1.5*60,
            'yuv420_padded_decode_writes_bytes_s': 1920*1088*1.5*15,
            'combined_yuv420_payload_bytes_s': 1920*1080*1.5*60 + 1920*1088*1.5*15,
            'scope': 'Payload and nominal clocks; controller overhead, clock realization, board electrical behavior and hardware tests remain to be verified.',
        },
    }
    (OUTPUT/'analysis.json').write_text(json.dumps(result, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
