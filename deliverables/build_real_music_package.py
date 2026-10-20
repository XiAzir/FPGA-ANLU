"""Finish and verify the ordinary-file music package. Never access a card drive."""
from pathlib import Path
from datetime import datetime, timezone, timedelta
import argparse
import hashlib
import json
import struct
import subprocess
import zipfile

ROOT = Path(__file__).resolve().parent
PACKAGE = ROOT / 'real_music_20261008'
parser = argparse.ArgumentParser(description='Reproduce the historical music package from its exact original source; existing packages are never overwritten.')
parser.add_argument('--source', type=Path, required=True,
                    help='Path to the original music file (the recorded SHA256 must match).')
args = parser.parse_args()
SOURCE = args.source.expanduser().resolve()
if not SOURCE.is_file():
    parser.error(f'Original music file is missing: {SOURCE}. Supply it with --source; private media is not included in Git.')
ARCHIVE = ROOT / 'real_music_20261008.zip'
AUDIT = ROOT / 'real_music_20261008.package_audit.json'
SOURCE_SHA = 'C240F7169542B09304EC9B3711671F4A9C934F26A7FFA4ED8F7339DD2D497B77'
WAV_SHA = 'D5244FD3935052A743379D9331EE78109C8A913241ED60DE472CB9E34A17FECF'
BIT_SHA = 'C2B3DEAFB78355C124CE8958015EED31CEBA38CD4B0B41D9179A7190E4200818'
NOW = datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest().upper()


assert not ARCHIVE.exists() and not AUDIT.exists(), 'Preserve existing package and audit'
assert digest(SOURCE) == SOURCE_SHA
wav = PACKAGE / 'card/TEST.WAV'
bit = PACKAGE / 'firmware/packet_diag.bit'
assert digest(wav) == WAV_SHA and digest(bit) == BIT_SHA
data = wav.read_bytes()
assert len(data) == 5760044 and data[:4] == b'RIFF' and data[8:12] == b'WAVE'
assert struct.unpack_from('<I', data, 4)[0] + 8 == len(data)
assert data[12:16] == b'fmt ' and struct.unpack_from('<I', data, 16)[0] == 16
assert struct.unpack_from('<HHIIHH', data, 20) == (1, 1, 48000, 96000, 2, 16)
assert data[36:40] == b'data' and struct.unpack_from('<I', data, 40)[0] == 5760000
probe = json.loads(subprocess.check_output([
    'ffprobe', '-v', 'error', '-show_entries',
    'format=duration,size:stream=codec_name,sample_fmt,sample_rate,channels,bits_per_sample',
    '-of', 'json', str(wav)], encoding='utf-8'))
assert float(probe['format']['duration']) == 60.0
readme_path = PACKAGE / 'README.md'
readme = readme_path.read_text(encoding='utf-8-sig')
old = '当前包准备状态：待音乐文件，尚未生成可发送的完整ZIP。firmware/packet_diag.bit 已备好；card/TEST.WAV 需在收到音乐后转换、校验并加入。本说明中的装卡/上板操作尚未执行。'
assert old in readme
readme = readme.replace(old, f'文件准备状态：音乐已转换/校验，成功位流已备好。本包用于同学在原卡上正常复制文件后进行首轮真实音乐测试；音乐上板尚未验证。打包日期：{NOW}（北京时间）。')
old = '生成后音乐将是标准RIFF/WAVE、48kHz、16-bit PCM、单声道。源音乐未提供，因此TEST.WAV文件大小/hash及素材信息目前未生成，不要用本准备目录冒充完整测试包。'
assert old in readme
readme = readme.replace(old, f'''音乐：用户提供的“天ノ弱 piano off vocal.m4a”前60秒；已转为标准RIFF/WAVE、48kHz、16-bit PCM、单声道，首20ms淡入/末50ms淡出。文件大小5,760,044字节，2,880,000个样本；SHA256 {WAV_SHA}。

RIFF/格式/数据边界、时长、非零样本和峰值均已核对；峰值约-3.01dBFS，没有满刻度点。数值通过不代替板上音质、切图并发或长期验证。原用户音乐文件未修改，压缩包不包含整首原文件。

解压后共有README.md、README.txt、package_status.json、CHECKSUMS.sha256、card/TEST.WAV、firmware/packet_diag.bit。校验清单包含除清单自身以外的五个文件SHA256；新音乐只复制card/TEST.WAV。''')
readme_path.write_text(readme, encoding='utf-8')
(PACKAGE / 'README.txt').write_text(readme, encoding='utf-8')
status = {
    'prepared_beijing': NOW, 'status': 'file package ready; real music hardware test pending',
    'music': {'source_name': SOURCE.name, 'source_sha256': SOURCE_SHA, 'clip_start_seconds': 0,
              'duration_seconds': 60, 'sample_rate': 48000, 'channels': 1, 'sample_bits': 16,
              'codec': 'PCM signed 16-bit little endian, RIFF/WAVE', 'samples': 2880000,
              'data_offset': 44, 'data_bytes': 5760000, 'file_bytes': 5760044, 'sha256': WAV_SHA,
              'fade_in_seconds': .02, 'fade_out_start_seconds': 59.95, 'fade_out_seconds': .05},
    'firmware': {'path': 'firmware/packet_diag.bit', 'bytes': 629624, 'sha256': BIT_SHA,
                 'board': 'AC601 + AC201, EG4S20BG256', 'download_mode': 'PROGRAM_SRAM'},
    'card_action': 'Back up old TEST.WAV to computer; replace root TEST.WAV by ordinary copy; preserve four BMP and other files',
    'card_access_by_assistant': 'none', 'card_or_flash_writes_by_assistant': 'none',
    'recipient': 'User forwards ZIP to teammate; assistant sends no message',
    'limits': ['Real music has not been played on the board', 'Previous noise root cause remains unresolved',
               'Keep existing FAT32 card; file-chain limit 4096 clusters, prior 32KiB clusters imply about176 for this WAV']
}
(PACKAGE / 'package_status.json').write_text(json.dumps(status, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
expected_names = {'README.md', 'README.txt', 'package_status.json', 'card/TEST.WAV', 'firmware/packet_diag.bit'}
files = {str(p.relative_to(PACKAGE)).replace('\\', '/'): p for p in PACKAGE.rglob('*') if p.is_file()}
assert set(files) == expected_names, files
manifest = {name: digest(path) for name, path in sorted(files.items())}
(PACKAGE / 'CHECKSUMS.sha256').write_text(''.join(f'{sha}  {name}\n' for name, sha in manifest.items()), encoding='ascii')
files['CHECKSUMS.sha256'] = PACKAGE / 'CHECKSUMS.sha256'
with zipfile.ZipFile(ARCHIVE, 'x', compression=zipfile.ZIP_DEFLATED, compresslevel=9) as z:
    for name, path in sorted(files.items()):
        z.write(path, arcname=PACKAGE.name + '/' + name)
with zipfile.ZipFile(ARCHIVE, 'r') as z:
    assert z.testzip() is None, 'ZIP CRC error'
    assert set(z.namelist()) == {PACKAGE.name + '/' + n for n in files}, 'Unexpected ZIP entries'
    for name, path in files.items():
        assert hashlib.sha256(z.read(PACKAGE.name + '/' + name)).hexdigest().upper() == digest(path), name
assert digest(SOURCE) == SOURCE_SHA and digest(bit) == BIT_SHA
audit = {'created_beijing': NOW, 'archive': str(ARCHIVE), 'bytes': ARCHIVE.stat().st_size,
         'sha256': digest(ARCHIVE), 'file_count': len(files), 'manifest': manifest,
         'zip_crc_test': 'PASS', 'all_archived_file_sha256_comparisons': 'PASS', 'audio_ffprobe': probe,
         'source_path': str(SOURCE), 'source_sha256_before_and_after': SOURCE_SHA,
         'source_unchanged': True, 'hardware_music_validation': 'pending',
         'independent_wav_check': 'second reader parsed RIFF and validated format, boundaries, sample count, peak/nonzero samples',
         'conversion': {'program': 'ffmpeg 8.1.2', 'arguments': ['-hide_banner', '-nostdin', '-n', '-i', str(SOURCE),
                        '-map', '0:a:0', '-t', '60', '-af', 'afade=t=in:st=0:d=0.02,afade=t=out:st=59.95:d=0.05',
                        '-ac', '1', '-ar', '48000', '-c:a', 'pcm_s16le', '-map_metadata', '-1',
                        '-fflags', '+bitexact', '-flags:a', '+bitexact', str(wav)]},
         'hardware_or_card_operations_by_assistant': 'none'}
AUDIT.write_text(json.dumps(audit, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps({'archive': str(ARCHIVE), 'bytes': audit['bytes'], 'sha256': audit['sha256'],
                  'file_count': len(files), 'zip_test': 'PASS', 'audio_test': 'PASS', 'hardware_music_test': 'pending'}))
