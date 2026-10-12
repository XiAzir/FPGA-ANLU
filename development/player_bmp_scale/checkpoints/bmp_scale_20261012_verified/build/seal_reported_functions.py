"""Seal reported C11206 acceptance without rebuilding or changing the candidate."""
from pathlib import Path
import datetime
import hashlib
import json
import re
import shutil

ROOT = Path('E:/VSCODE-project/FPGA-ANLU')
PROJECT = ROOT / 'development/player_bmp_scale'
DOCS = Path('E:/QQ CACHE/Download/安路资料/开发记录')
TOPIC = DOCS / '专题记录/图片缩放/多尺寸最近邻首版_20261012'
CANDIDATE = PROJECT / 'checkpoints/bmp_scale_20261012_candidate'
VERIFIED = PROJECT / 'checkpoints/bmp_scale_20261012_verified'
FEEDBACK_DIR = PROJECT / 'build/board_feedback_20261012'
NOW = datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
BIT_SHA = 'C60464C0D4396D316DB7622E4CB0B70B5DE12C25148AFE234AC7C795C818625D'
STATUS = 'PASS_REPORTED_SCALE_AND_INTEGRATED_FUNCTIONS_WITH_KNOWN_WAVEFORM_ISSUES'
QUOTE = '看起来没什么问题，功能也验过了没问题'


def sha(path):
    digest = hashlib.sha256()
    with Path(path).open('rb') as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b''):
            digest.update(block)
    return digest.hexdigest().upper()


def load(path):
    return json.loads(Path(path).read_text(encoding='utf-8-sig'))


def save(path, value):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def copy(source, target):
    target = Path(target)
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, target)
    assert sha(source) == sha(target)


assert not VERIFIED.exists(), 'Verified snapshot already exists; do not overwrite it.'
receipt = load(PROJECT / 'build/delivery_verified.json')
assert receipt['bitSha256'] == BIT_SHA
assert sha(CANDIDATE / 'manifest.json') == receipt['manifestSha256'] == '6082AB5E2A40CE8DD6FD73265CF59CECB35B35B883DD6466BB839CE68A1B1A9D'
manifest = load(CANDIDATE / 'manifest.json')
assert len(manifest) == receipt['checkpointFiles'] == 260
for entry in manifest:
    file = CANDIDATE / entry['path']
    assert file.stat().st_size == entry['bytes'] and sha(file) == entry['sha256']
archive = Path(receipt['zip'])
assert sha(archive) == receipt['zipSha256'] == '9371A293616AAF37FD72E2DFD9466616FADD7BCB583E06FC84357146B2D380D5'
assert archive.stat().st_size == receipt['zipBytes']
for file in [ROOT / 'download/bmp_scale.bit', PROJECT / 'build/manual/AC201_player_bmp_scale.bit']:
    assert sha(file) == BIT_SHA and file.stat().st_size == 629624
for sub in ['src/user_source', 'scripts', 'src/td_project/al_ip']:
    for file in (PROJECT / sub).rglob('*'):
        if file.is_file():
            assert sha(file) == sha(CANDIDATE / file.relative_to(PROJECT))
assert sha(PROJECT / 'src/td_project/AC201_tf_hdmi.al') == sha(CANDIDATE / 'src/td_project/AC201_tf_hdmi.al')

photo_specs = [
    ('codex-clipboard-8789c60b-e787-40dd-b640-afe894fe5164.jpg', 'scale4_512x128.jpg', 'SCALE4.BMP', 4, [512, 128], [640, 160], '上下黑边，宽图居中；彩块和对角线方向符合预期。'),
    ('codex-clipboard-5c1b7eee-32ff-47e1-99bd-3d34f78ba233.jpg', 'scale1_320x240.jpg', 'SCALE1.BMP', 1, [320, 240], [640, 480], '小图放大铺满，彩块与角标方向符合预期。'),
    ('codex-clipboard-79846dbb-8bfa-4706-836c-90c453caaf83.jpg', 'scale2_800x600.jpg', 'SCALE2.BMP', 2, [800, 600], [640, 480], '大图缩小铺满，彩块和对角线方向符合预期。'),
    ('codex-clipboard-39372667-7152-423f-ab4a-6bc7cceed487.jpg', 'scale3_191x321_topdown.jpg', 'SCALE3.BMP', 3, [191, 321], [285, 480], '竖图左右黑边并居中，top-down素材方向符合预期。'),
]
temp = Path('C:/Users/PENGYU~1/AppData/Local/Temp')
for original, *_ in photo_specs:
    assert (temp / original).is_file()

photos = []
for original, name, bmp, number, size, output, observation in photo_specs:
    source = temp / original
    project_copy = FEEDBACK_DIR / 'photos' / name
    docs_copy = TOPIC / '实板照片' / name
    copy(source, project_copy)
    copy(source, docs_copy)
    photos.append({
        'source': str(source), 'projectCopy': str(project_copy), 'docsCopy': str(docs_copy),
        'sha256': sha(source), 'bytes': source.stat().st_size, 'testAsset': bmp,
        'displayedImageIndex': number, 'sourceDimensions': size,
        'expectedOutputDimensionsFromSpecification': output, 'visualObservation': observation,
    })

feedback = {
    'recordedBeijing': NOW, 'version': 'C11206', 'bitSha256': BIT_SHA,
    'versionAssociation': 'Associated with the C11206 package by conversation context; photos do not show build ID or independently verify the downloaded bit hash.',
    'userQuote': QUOTE, 'boardStatus': STATUS,
    'testRequestContext': '四尺寸BMP方向/颜色/黑边；KEY0与AUTO上下擦除；WAV和内部音阶；字幕、亮度/对比度、默认恢复、波形冻结/恢复。',
    'reportedFunctions': '用户笼统确认本轮功能验过且无问题，按上一轮操作卡所要求范围记通过（用户反馈）；未逐项复述操作次数/时长，不补造测试过程。',
    'photos': photos,
    'photoEvidenceLimits': '照片支持四种尺寸的宏观布局、方向与叠加显示。透视、反光及摩尔纹限制逐像素判断；静态照片不能证明音质、AUTO、转场或具体按键过程。RUN数值不作为计时长稳起止证据。输出尺寸取自规格，不是照片像素测量。',
    'knownIssues': [
        '动态波形可见双线，HOLD后消失；用户同意暂留，唯一成因未确认。',
        '波形显示分辨率与线条清晰度优化留到后续。',
    ],
    'notValidated': [
        '本版计时长稳、重复冷启动和下载矩阵',
        '实板最大1024×768尺寸及任意受支持图片/异常文件/换卡/碎片矩阵',
        'HDMI逐像素采集、实物音频仪器测量、转场或加载实测时长',
        'Flash固化与掉电持久启动',
        'T33正式五扩展逐项证据矩阵与最终提交验收',
    ],
    'scope': 'T29/T30四种素材最近邻缩放首版实板功能通过；当前同位流集成功能获用户总体正常反馈。不是全格式/全部边界或正式G4签核。',
    'agentHardwareActions': 'None. Board and AL-LINK are on the remote laboratory PC; no local JTAG, TF write or Flash operation.',
}
save(FEEDBACK_DIR / 'functions_feedback.json', feedback)
save(TOPIC / 'board_feedback.json', feedback)

info = load(PROJECT / 'build/manual/AC201_player_bmp_scale.info.json')
info.update({
    'boardStatus': STATUS,
    'previousSuccessfulBaseline': 'C11205 transition_wipe.bit (restore original 640x480 BMP assets before rollback)',
    'successfulBaseline': 'C11206 bmp_scale.bit; user-reported scale and integrated functions passed; known waveform display issues retained',
    'lastBoardFeedbackBeijing': NOW, 'lastBoardFeedback': str(FEEDBACK_DIR / 'functions_feedback.json'),
    'verifiedCheckpoint': str(VERIFIED), 'unverifiedAfterFeedback': feedback['notValidated'],
    'hardwareActions': feedback['agentHardwareActions'],
    'evidenceLimit': 'Original complete-loader gold, FIFO pressure model, source audit and TD timing unchanged. Four user photos support macro scale/orientation/layout; user reports requested functions passed. Context associates version; no direct bit readback, all-format hardware coverage, long-run or Flash claim. Candidate/ZIP retain original historical pending metadata.',
})
save(PROJECT / 'build/manual/AC201_player_bmp_scale.info.json', info)
save(ROOT / 'download/bmp_scale.info.json', info)

summary = f'''# C11206 多尺寸BMP缩放首版：实板功能反馈通过

记录：{NOW}（北京时间，留档时间，非测试起止时间）。

用户本轮原话：“{QUOTE}”。结合上一轮操作卡，将四尺寸缩放及所要求集成功能记为通过（用户反馈）。成功开发基线更新为C11206 [bmp_scale.bit](E:/VSCODE-project/FPGA-ANLU/download/bmp_scale.bit)。照片与版本的关联来自本轮上下文，未独立读取板上build ID或回读位流。

位流629624字节，SHA256：`{BIT_SHA}`。源码与位流不改、不重构建；原260文件candidate和ZIP维持交付时原字节，包括历史pending元数据。新verified增加本轮证据与更新后的live信息。

## 四图证据

| 照片/OSD | 原图 | 预期显示 | 实际照片宏观判断 |
| --- | --- | --- | --- |
| [IMG 1/4](实板照片/scale1_320x240.jpg) | 320×240 bottom-up | 640×480铺满 | 放大范围、角标与方向符合 |
| [IMG 2/4](实板照片/scale2_800x600.jpg) | 800×600 bottom-up | 640×480铺满 | 缩小范围、颜色布局与方向符合 |
| [IMG 3/4](实板照片/scale3_191x321_topdown.jpg) | 191×321 top-down，每行3字节padding | 285×480，左右黑边177/178 | 竖图居中、左右留黑、方向符合 |
| [IMG 4/4](实板照片/scale4_512x128.jpg) | 512×128 bottom-up | 640×160，上下黑边160 | 宽图居中、上下留黑、方向符合 |

预期尺寸与黑边数来自规格/黄金模型，不是照片测量。原始照片逐字节保存并记录SHA。照片中字幕、状态栏和波形是叠加层，会遮挡部分底图；四角色块与边框为测试素材内容。反光/透视/摩尔纹限制逐像素判断。RUN读数不能用作连续运行时长。

KEY0、AUTO及转场、WAV/内部音阶、字幕、亮度/对比度/恢复默认、波形冻结恢复的结论来自用户对上一轮操作卡范围的总体反馈，静态照片不单独证明这些操作或音质；不补造操作次数、循环数与具体测试时长。

## 保留与未完成

动态波形双线与低清晰度按已有约定继续保留；HOLD后双线消失已有用户对照，唯一成因尚未确认。照片仍可见动态双线，不作为此次缩放失败。

本版计时长稳/重复冷启动、实板最大尺寸及其他格式/异常文件/换卡/碎片矩阵、HDMI逐点采集、音频仪器测量、Flash固化尚未验证。代理未连接或操作实验室板卡，未写TF/Flash。

T29/T30四尺寸最近邻首版完成上述实板验收范围；T32同一位流的五类扩展已有实现与正常功能反馈，T33正式逐项证据矩阵仍待整理，不能将这次反馈写为正式G4全部完成。FFT/高清等S5可选增强仍默认不启用。

下一步（计划，尚未执行）：先整理同位流保留范围和五扩展证据矩阵，再安排波形清晰度优化及稳定性/异常回归，进入T36范围冻结和S6验收封版。无需重复本轮已确认的普通功能测试。Flash与提交材料按最终冻结版本推进。

回退C11205须先恢复电脑备份的原四张640×480 BMP，再回载transition_wipe.bit；旧版不支持本轮多尺寸素材。

证据：[board_feedback.json](board_feedback.json)、[verified_receipt.json](verified_receipt.json)、[已验证操作卡](已验证操作卡.md)。
'''
(TOPIC / '验收记录.md').write_text(summary, encoding='utf-8')
card = (PROJECT / 'build/delivery/README.md').read_text(encoding='utf-8-sig')
card = card.replace('# C11206 多尺寸BMP缩放候选：实板待验证', '# C11206 多尺寸BMP缩放：用户反馈功能通过', 1)
card = f'本版四尺寸及所要求功能已获用户总体正常反馈（{NOW}记录）；动态波形双线/低清晰度仍保留。下文保存准备、操作与回退方法，非重新要求执行完整测试。\n\n' + card
card += '\n位流SHA256：`' + BIT_SHA + '`。不将本轮通过扩展为长期、任意卡/文件、Flash或最终提交验收。\n'
(TOPIC / '已验证操作卡.md').write_text(card, encoding='utf-8')

VERIFIED.mkdir(parents=True)
for entry in manifest:
    copy(CANDIDATE / entry['path'], VERIFIED / entry['path'])
extras = [
    (PROJECT / 'build/manual/AC201_player_bmp_scale.info.json', 'build/manual/AC201_player_bmp_scale.info.json'),
    (FEEDBACK_DIR / 'functions_feedback.json', 'build/board_feedback_20261012/functions_feedback.json'),
    (TOPIC / '验收记录.md', 'build/acceptance/acceptance_summary.md'),
    (TOPIC / '已验证操作卡.md', 'build/acceptance/operation_card.md'),
    (Path(__file__), 'build/seal_reported_functions.py'),
]
for photo in photos:
    file = Path(photo['projectCopy'])
    extras.append((file, 'build/board_feedback_20261012/photos/' + file.name))
for source, relative in extras:
    copy(source, VERIFIED / relative)
for entry in manifest:
    if entry['path'] != 'build/manual/AC201_player_bmp_scale.info.json':
        assert sha(VERIFIED / entry['path']) == entry['sha256']
new_manifest = [
    {'path': file.relative_to(VERIFIED).as_posix(), 'bytes': file.stat().st_size, 'sha256': sha(file)}
    for file in sorted(VERIFIED.rglob('*')) if file.is_file() and file.name != 'manifest.json'
]
save(VERIFIED / 'manifest.json', new_manifest)
for entry in new_manifest:
    assert sha(VERIFIED / entry['path']) == entry['sha256']
assert sha(CANDIDATE / 'manifest.json') == receipt['manifestSha256']
for entry in manifest:
    assert sha(CANDIDATE / entry['path']) == entry['sha256']
assert sha(archive) == receipt['zipSha256']
verified_receipt = {
    'createdBeijing': NOW, 'version': 'C11206', 'bitSha256': BIT_SHA,
    'verifiedCheckpoint': str(VERIFIED), 'manifestFiles': len(new_manifest),
    'manifestSha256': sha(VERIFIED / 'manifest.json'),
    'parentCandidateManifestSha256': receipt['manifestSha256'],
    'originalZipSha256': receipt['zipSha256'], 'boardStatus': STATUS,
    'sourceAndBitUnchanged': True, 'originalCandidateAndZipUnchanged': True,
    'photoCount': len(photos), 'feedbackSha256': sha(FEEDBACK_DIR / 'functions_feedback.json'),
}
save(PROJECT / 'build/acceptance_verified.json', verified_receipt)
save(TOPIC / 'verified_receipt.json', verified_receipt)

readme = TOPIC / 'README.md'
text = readme.read_text(encoding='utf-8')
text = text.replace('当前为开发中，成功回退仍 C11205 transition_wipe；尚无缩放候选位流与板测。', '当前C11206缩放首版已获用户功能正常反馈并封存为新成功基线；C11205保留回退（须恢复原640×480素材）。', 1)
text = text.replace('完整BMP解析/逐像素黄金、资源映射/时序与板测仍待完成。', '完整BMP解析/逐像素黄金、资源映射/原约束时序已通过，四尺寸实板照片与用户功能反馈正常；本版长期/冷启动/异常媒体与Flash仍未验证。', 1)
text = text.replace('下一步按[操作卡](操作卡.md)备份旧BMP/复制四张原尺寸BMP并下载新候选；失败须恢复旧图片再回载C11205。', '交付时的准备步骤保存在[原操作卡](操作卡.md)；本轮结果见下方验收记录。回退仍须恢复旧图片再回载C11205。', 1)
text += f'\n## {NOW}｜用户反馈功能通过，C11206新成功基线\n\n四张原始照片已保存，宏观缩放/方向/留黑符合预期；用户回复“{QUOTE}”，按上一轮操作卡要求范围记录功能通过。已知动态波形双线/低清晰度保留。源码与bit不改，原candidate260与ZIP不变，新verified {len(new_manifest)}文件，manifest SHA `{verified_receipt["manifestSha256"]}`。本版长稳/冷启动/异常媒体/Flash与正式五扩展证据矩阵未完成。下一步整理集成验收范围/证据并进入显示优化和稳定性验证（计划，未执行）。详见[验收记录](验收记录.md)、[反馈](board_feedback.json)、[封存凭据](verified_receipt.json)。\n'
readme.write_text(text, encoding='utf-8')

state = DOCS / '当前状态.md'
text = state.read_text(encoding='utf-8')
old_stage = text.split('## 当前阶段\n', 1)[1].split('\n## 本次失败的keepaudio位流', 1)[0]
(TOPIC / '封存前阶段记录.md').write_text('# 封存前当前阶段历史快照\n\n以下为本次更新前状态段落的原文，供核对历史；最新现状以当前状态与验收记录为准。\n\n' + old_stage, encoding='utf-8')
text = re.sub(r'^更新：.*$', f'更新：{NOW}（北京时间；XiAzir；C11206四尺寸/集成功能用户反馈通过，verified封存）。', text, count=1, flags=re.M)
stage = f'''## 当前阶段

- 成功开发基线 **C11206 `download/bmp_scale.bit`**，SHA256 `{BIT_SHA}`。源/bit不改、新verified {len(new_manifest)}文件，manifest `{verified_receipt["manifestSha256"]}`；原candidate260与ZIP哈希不变。[验收与照片](专题记录/图片缩放/多尺寸最近邻首版_20261012/验收记录.md)、[封存凭据](专题记录/图片缩放/多尺寸最近邻首版_20261012/verified_receipt.json)。
- 用户本轮回复“{QUOTE}”。四照片支持320×240放大、800×600缩小铺满、191×321 top-down竖图左右黑边、512×128宽图上下黑边的宏观范围和方向；所要求按键/转场/两音源/字幕/B/C/默认恢复/冻结恢复按总体用户反馈记通过，未补造次数/时长。版本关联来自上下文，照片未独立读出build ID。
- 当前固定640×480、紧凑RGB888；五类扩展已实现并获正常功能反馈。T29/T30首版四尺寸板测收尾；T32/T33正式同位流逐项证据矩阵和T36范围冻结待整理。S5 FFT/高清默认不启用。
- 已知动态波形双线（HOLD消失）及低清晰度保留，唯一成因未确认。下一步先整理五扩展保留范围/验收证据，再做波形清晰度优化与稳定性/异常回归，按最终版本封版/固化/材料提交；这些尚未执行。本轮无需重复普通功能测试。
- 本版计时长稳、冷启动/反复下载、最大尺寸/异常文件/换卡/碎片实物矩阵、Flash未验证，父版本短稳不继承。板卡与AL-LINK在远控实验室电脑，代理未本机JTAG/TF/Flash操作。
- C11205 `download/transition_wipe.bit`保留回退，SHA256 `748E0AF0F9BF0656410C09735E371F655BEDD330C259E43858B614B1D95AE8F9`；必须先恢复原四张640×480 BMP，不能用新多尺寸素材评判旧版。
- 本地依据不变：真实loader六帧1843200像素gold、错误/背压模型通过；正式原约束SWNS+0.628ns/HWNS+0.004ns/TNS0/coverage99.97%，15031LUT/8803reg/28BRAM9K/8DSP。模型范围与局限见专题。功能约80%、全流程60%–65%为上一轮主观估算，本轮未重估。
- 历史阶段细节见[2026-10-12日志](工作日志/2026-10-12.md)及[封存前阶段快照](专题记录/图片缩放/多尺寸最近邻首版_20261012/封存前阶段记录.md)，不再在现状逐条堆叠。

'''
text = re.sub(r'## 当前阶段\n.*?(?=## 本次失败的keepaudio位流)', stage, text, count=1, flags=re.S)
text = text.replace('| player_image_adjust/build/manual/AC201_player_image_adjust.bit | 当前成功开发基线C11201，', '| player_image_adjust/build/manual/AC201_player_image_adjust.bit | 前序成功基线C11201，', 1)
text = text.replace('| 版本 | 当前证据 |\n| --- | --- |', '| 版本 | 当前证据 |\n| --- | --- |\n| player_bmp_scale/build/manual/AC201_player_bmp_scale.bit | 当前成功开发基线C11206；四尺寸缩放照片符合预期，所要求集成功能用户总体反馈正常；详见本页当前阶段。 |', 1)
text = text.replace('- 素材：四张640×480底向上24位BI_RGB BMP；', '- 当前素材：四张缩放测试BMP（320×240、800×600、191×321 top-down、512×128），原四张640×480底向上24位BI_RGB BMP备份供旧版回退；', 1)
next_section = '''## 下一步

1. 整理T32/T33同一C11206设计的五类扩展验收证据与保留范围；本轮普通功能已有用户确认，不重复索要同一测试。
2. 单独推进波形分辨率/线条清晰度优化，动态双线按用户选择暂保留；优化版必须保留当前verified回退，独立模型、正式构建及相关回归。
3. 最终候选安排计时长稳、重复冷启动、异常媒体/文件与碎片实物回归，完成T36范围冻结后推进Flash与复现、报告/视频/提交。父版本短稳不继承。
4. 高清、FFT、ES8388等不作为当前默认开发任务；接续以本页现状及专题最新验收为准。

'''
text = re.sub(r'## 下一步\n.*?(?=## 新增PCM参考审计)', next_section, text, count=1, flags=re.S)
text = text.replace('## 新增PCM参考审计（2026-10-08）', '## 历史PCM参考审计（2026-10-08）', 1)
text = text.replace('## 后续开发入口（2026-10-09）', '## 历史开发入口（2026-10-09，非当前步骤）', 1)
state.write_text(text, encoding='utf-8')

log = DOCS / '工作日志/2026-10-12.md'
entry = f'''\n### {NOW}｜C11206多尺寸缩放｜实板功能反馈通过、verified封存完成

- 动作/产物：保存用户四张原始照片及SHA，建立反馈/验收/已验证操作卡；live info更新成功基线C11206；新verified {len(new_manifest)}文件，manifest `{verified_receipt['manifestSha256']}`。源/bit不改、不重构建，原candidate260/ZIP逐项哈希保持。位流SHA `{BIT_SHA}`。
- 证据/结论：用户原话“{QUOTE}”；照片宏观放大/缩小/宽图上下黑边/竖图左右黑边与方向符合预期。所要求功能按用户总体反馈记通过，不伪造逐项次数、时长或音频实测；上下文关联C11206，照片未读build ID。动态波形双线/低清晰度仍保留。
- 未完成/影响：本版长稳/冷启动/最大尺寸/异常媒体/换卡碎片/Flash未验证；T33正式逐项矩阵/最终提交验收未完成。代理未操作实验室板卡、JTAG/TF/Flash；不是无缺陷或任意文件支持证明。
- 下一步：整理同位流五扩展证据与保留范围，进入波形清晰度优化、稳定性/异常回归，再T36范围冻结与S6验收封版（计划，未执行）。S5 FFT/高清默认停用。回退C11205须先恢复原640×480图片。
- 留档：更新当前状态并收拢重复阶段段落，原阶段文本保存[历史快照](../专题记录/图片缩放/多尺寸最近邻首版_20261012/封存前阶段记录.md)。[本轮验收](../专题记录/图片缩放/多尺寸最近邻首版_20261012/验收记录.md)、[反馈](../专题记录/图片缩放/多尺寸最近邻首版_20261012/board_feedback.json)、[封存凭据](../专题记录/图片缩放/多尺寸最近邻首版_20261012/verified_receipt.json)。
'''
log.write_text(log.read_text(encoding='utf-8') + entry, encoding='utf-8')
print(json.dumps(verified_receipt, ensure_ascii=True, indent=2))
