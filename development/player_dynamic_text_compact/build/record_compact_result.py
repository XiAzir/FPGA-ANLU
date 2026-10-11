from datetime import datetime, timezone, timedelta
from pathlib import Path

records = Path('E:/QQ CACHE/Download/安路资料/开发记录')
now = datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
item = f'''
### {now[11:]}｜共享字模资源对照不通过｜未完成（物理实现失败）

- 动作：独立 `development/player_dynamic_text_compact`，75源仅字模模块不同，其余74源/PLL/约束/引脚一致；原成功/失败冻结产物不改。
- 本地模型通过：原OSD1843200像素、state838断言、新共享字模1843200像素、timer12000周期。复制后仿真脚本和输出路径已修正到独立副本。
- 综合显示字模实例LUT134→133，但全设计Total_luts8991→9078、gate LUT16743→16830，未达到减少资源目标。布局报 PHY-9009：MSlice4906超过4900，停在place，没有route/最终STA/pr.db/新bit，未交付。
- 结论：该实验不适合作为上板候选，也不证明此前实板失败根因。已保留日志和preparation.json；没有靠改约束隐藏失败。
- 下一步：独立验证FAT mapper循环检测计数器宽度，在现有4096簇硬上限内做原版/优化版逐周期等价及长链/缓存/EOF/EOC/cycle边界模型；通过后准备原动态字模加单一mapper优化的新独立候选，不把优化当EOC已证修复。
'''
with (records / '工作日志/2026-10-09.md').open('a', encoding='utf-8') as log:
    log.write(item)
topic = records / '专题记录/OSD状态显示/动态字幕首版失败_20261009/排查进展.md'
with topic.open('a', encoding='utf-8') as out:
    out.write('\n## 共享字模对照结果\n' + item.split('\n\n', 1)[1])
state = records / '当前状态.md'
text = state.read_text(encoding='utf-8-sig').replace('精简同功能字幕独立模型已通过，独立工程编译准备中。', '共享字模模型通过但布局MSlice超限(PHY-9009)，无新bit；下一单项资源实验为4096簇上限内FAT mapper计数器缩宽，等价/边界模型进行中。', 1)
state.write_text(text, encoding='utf-8')
print('Compact failure and next bounded experiment recorded.')
