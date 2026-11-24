# FPGA-ANLU

2026 年全国大学生嵌入式芯片与系统设计竞赛（安路科技 FPGA 创新设计赛道，**国家级三等奖**）作品——**基于安路 EG4S20BG256 的离线多媒体展示终端**主工程代码与构建工作区。

> 如果你只想快速查看最终演示说明、硬件收敛指标与位流交付物，请优先访问最终展示仓：**[XiAzir/FPGA-multimedia-player](https://github.com/XiAzir/FPGA-multimedia-player)**。

## 三仓协作与职责边界

| 仓库 | 定位 | 说明 |
| --- | --- | --- |
| **[FPGA-ANLU](https://github.com/XiAzir/FPGA-ANLU)**（本仓） | 主工程工作区 | RTL 开发、板端 bring-up、构建脚本、阶段规划与产物输出 |
| **[FPGA-ANLU-docs](https://github.com/XiAzir/FPGA-ANLU-docs)** | 硬件资料与状态仓 | 板卡引脚与硬件资料、开发约定、开发排障记录、`当前状态.md` |
| **[FPGA-multimedia-player](https://github.com/XiAzir/FPGA-multimedia-player)** | 最终交付展示仓 | 面向评测与复现整理的文档说明及最终位流 `c14116_seed2.bit` |

## 仓库目录结构

```text
FPGA-ANLU/
├── AGENTS.md        # 薄入口规范与任务按需读取路由表
├── bringup/         # 板端外设点亮与基础验证工程
├── build/           # 综合、布局布线与位流构建输出目录
├── deliverables/    # 阶段交付产物归档
├── development/     # 主工程开发源码与模块集成
├── planning/        # 任务拆解与迭代计划
└── scripts/         # 自动化构建、时序检查与辅助脚本
```

## 双仓解耦与上下文治理机制

1. **薄 `AGENTS.md` + 任务按需读取路由**：根目录 `AGENTS.md` 保持精简，仅定义硬边界与路由表；面对具体子任务时按需读取 `FPGA-ANLU-docs` 中对应文档，防止上下文膨胀。
2. **代码与资料仓解耦**：将板卡引脚资料、开发约定和阶段排障记录统一托管至 [FPGA-ANLU-docs](https://github.com/XiAzir/FPGA-ANLU-docs)，保持工程仓干净聚焦。
3. **状态快照与可追溯留档**：每次关键改动和实板测试按「动作 — 证据 — 影响 — 下一步」留档并维护 `当前状态.md`，保障跨会话稳定接续与快速回退。

## 最终板端交付指标（EG4S20BG256）

- **最终交付位流**：`c14116_seed2.bit`（完整说明见 [FPGA-multimedia-player](https://github.com/XiAzir/FPGA-multimedia-player)）
- **资源占用**：LUT `17,561 / 19,600`（89.6%）｜BRAM `62 / 64`｜DSP `26 / 29`
- **时序收敛**：Setup `+0.804 ns`｜Hold `+0.027 ns`｜`TNS = 0`
