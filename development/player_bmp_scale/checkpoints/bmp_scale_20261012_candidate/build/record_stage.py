from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo

docs = Path('E:/QQ CACHE/Download/安路资料/开发记录')
topic = docs / '专题记录/图片缩放/多尺寸最近邻首版_20261012'
topic.mkdir(parents=True, exist_ok=True)
stamp = datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M:%S')
summary = f'''**{stamp} C11206多尺寸BMP/FPGA最近邻缩放开发中（T29/T30，S4转场与缩放）。从C11205 verified169逐项核验隔离复制src/scripts，无旧DB。支持规格24位BI_RGB、宽1..1024/高绝对值1..768、正负高度/行padding、等比居中黑边，FPGA加载时输出固定640×480，原音频/PHY/读侧转场保持。新增写FIFO真实ready：wrusedw<=480/非full/clear/两拍释放；实际pack/backend/IP拥塞模型PASS4096像素/3072word/max_used481/stalled5908，未含实际缩放engine或加密SDRAM。完整解析缩放黄金模型及RTL收尾中，未生成新bit/未板测。成功基线仍C11205；动态波形双线与清晰度优化保留。全流程进度粗估60%–65%、功能开发约80%，为剩余工作量主观估算，非官方评分或任务数量；缩放/集成回归/长稳异常/Flash/报告视频提交仍未完成。板与下载器在远控实验室电脑，未操作本机JTAG/TF/Flash。下一步完整像素黄金核验、静态审查、综合/原约束时序与资源审查，再封存候选供板测。 [缩放专题](专题记录/图片缩放/多尺寸最近邻首版_20261012/README.md)。**'''
state = docs / '当前状态.md'
text = state.read_text(encoding='utf-8-sig')
start = text.index('更新：')
end = text.index('\n', start)
text = text[:start] + f'更新：{stamp}（北京时间；XiAzir；C11206缩放开发中，成功基线C11205）。' + text[end:]
text = text.replace('## 当前阶段\n', '## 当前阶段\n\n' + summary + '\n', 1)
state.write_text(text, encoding='utf-8')
with (docs / '工作日志/2026-10-12.md').open('a', encoding='utf-8') as f:
    f.write(f'\n### {stamp[11:]}｜C11206多尺寸BMP缩放｜进行中\n\n' + summary + '\n')
(topic / 'README.md').write_text('''# C11206 多尺寸 BMP / 最近邻首版

开发工程：[player_bmp_scale](E:/VSCODE-project/FPGA-ANLU/development/player_bmp_scale/)。当前为开发中，成功回退仍 C11205 transition_wipe；尚无缩放候选位流与板测。

规格见[scaler_spec.md](E:/VSCODE-project/FPGA-ANLU/development/player_bmp_scale/build/scaler_spec.md)。显示固定640×480，在FPGA加载时对原尺寸24位BI_RGB做等比居中最近邻，黑边补零；宽1..1024，高绝对值1..768，支持bottom-up/top-down和奇数宽padding。不是在PC预缩放后冒充板内缩放。

新增真实写FIFO反压。压力模型使用实际pack/framebackend/FIFOIP，通过4096像素、3072word、max_used481、5908次暂停、phase mask d（观察到ready落沿时pack相位0/2/3），未覆盖加密SDRAM或真实缩放引擎。以强制App_rd_busy模拟长时间读占用；Sdr_busy输入在原writer中未用。两份初期失败日志是TB错误（SHOW_AHEAD抽样时机、busy信号假设），修正TB后通过，没有以此修改RTL。

完整BMP解析/逐像素黄金、资源映射/时序与板测仍待完成。动态波形双线和低清晰度按用户选择留到优化阶段。

全流程现处S4转场与缩放：功能开发粗估80%，全流程粗估60%–65%。这是基于剩余工作量的判断，非官方评分。仍需缩放及集成回归、显示优化、长稳/异常卡和文件验证、Flash固化、报告/视频及提交。
''', encoding='utf-8')
print(stamp, 'C11206 stage recorded')
