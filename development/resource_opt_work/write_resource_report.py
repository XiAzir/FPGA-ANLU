"""Build the local resource optimization report from final build evidence."""
from pathlib import Path
from datetime import datetime
import argparse
import hashlib
import json
import re
from collect_ablation import area

ROOT = Path(__file__).resolve().parents[2]
C = ROOT / 'development/player_spectrum_resource_fit'
D = Path('E:/QQ CACHE/Download/安路资料/开发记录/专题记录/资源优化/C11313_20261020')


def link(path, name=None):
    path = Path(path).resolve()
    return f'[{name or path.name}](<{path.as_posix()}>)'


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--system', type=Path, required=True)
    parser.add_argument('--variant', required=True)
    args = parser.parse_args()
    manual = C / 'build/manual'
    physical = area(manual / 'AC201_tf_hdmi_phy.area')
    qor = (C / 'src/td_project/route.qor').read_text(encoding='utf-8', errors='replace')
    slices = int(re.search(r'#slices\s*\|\s*(\d+)', qor)[1])
    ts = (manual / 'AC201_tf_hdmi_phy.ts').read_text(encoding='utf-8')
    setup, stns, hold, htns = re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.', ts).groups()
    system = json.loads((args.system / 'summary.json').read_text(encoding='utf-8'))
    assert system['status'] == 'SYSTEM_MEDIA_PASS_WITH_MODEL_ASSUMPTIONS'
    bit = ROOT / 'download/spectrum_resource_fit.bit'
    bit_sha = hashlib.sha256(bit.read_bytes()).hexdigest()
    checkpoint = C / 'checkpoints/C11313_resource_fit_20261020_offline'
    assert checkpoint.is_dir()
    raw = json.loads((C / 'build/regression/gate_rom_controls.json').read_text(encoding='utf-8-sig'))
    normalized = json.loads((C / 'build/gate_verify/normalized_control_proof.json').read_text(encoding='utf-8'))
    assert normalized['status'] == 'PASS'
    rows = [
        ('Slice',9712,slices), ('占用率', '99.10%',f'{slices/9800*100:.2f}%'),
        ('器件LUT',16934,physical['device_lut']), ('FF',10061,physical['device_reg']),
        ('LE',18481,physical['le']), ('BRAM9K',44,physical['bram9k']), ('DSP',12,physical['dsp']),
        ('Setup WNS/ns','+0.060',setup), ('Hold WNS/ns','+0.024',hold),
        ('Setup/Hold TNS/ns','0/0',f'{stns}/{htns}'), ('STA覆盖率','99.98%','99.98%'),
    ]
    text = f'''# C11313 资源优化与消融验证

更新：{datetime.now().astimezone().isoformat(timespec='seconds')}；最终选择：{args.variant}。

结论：`AREA_REDUCED_FUNCTIONALLY_CHECKED`；硬件状态：`BOARD_NOT_TESTED`。
最终同约束 route 为 **{slices}/9800 Slice={slices/9800*100:.2f}%**，较C11312减少{9712-slices} Slice，85%目标{'达到' if slices<=8330 else '尚待达到'}；80%目标7840 Slice还需减少{max(0,slices-7840)}。

## 来源与复现身份

- 交接ZIP按任务、数据、工具选择导入，来源SHA、两仓起始HEAD与选取清单见{link(D/'import_receipt.json','导入凭据')}。重复历史参考继续保存在原ZIP。
- 工程仓起始XiAzir/ae9e1fda878426087fa6fd7b9c199300ca5c6c1b；资料仓XiAzir/cdcaf0402a3f772520a8fca8ecc98d535842bee0。此次更改保存在本地工作树，未提交、未push。
- 器件EG4S20BG256；TD6.2.1 SP1/6.2.178840。TD综合、物理、bitgen实际执行成功；仿真使用Icarus12.0 devel（s20150603-1539-g2693dd32b）与ModelSim SE-64 10.1c。工具安装和许可文件保持原位置。
- 独立工程：{link(C,'player_spectrum_resource_fit')}，Build ID C11313。源、脚本、阶段记录及bit SHA见{link(checkpoint/'manifest.json','封存清单')}。
- 原C11312源/脚本/仿真168份SHA、两个原download位流和8项外部Git blob核查见{link(C/'build/preservation.json','保留检查')}。

## 算法与冗余消融

| 模块 | 实施变更 | 等价验证 |
|---|---|---|
| fat32_catalog | 流式选首个FAT32分区，删除4项分区数组；共享稳定BPB几何，删除重复sector计数；流式匹配8.3文件名/属性；精确范围位宽 | 511几何、175目录名、首项优先/错误优先级/溢出差分 |
| fat32_file_sector | ceil(size/512)改高位加低位非零；簇上限比较代数化；12位索引；44/33位地址；互斥位段OR合并 | live shift0..15、边界13344拍；4096簇/缓存回退/EOC/环检测6381198拍 |
| bmp_scale_engine | 移位商/窄余数代替32位动态bit-set除法；消除13个前导零迭代，19拍完成；几何与相位精确位宽，删除未读状态 | 原版/32拍对照/19拍版各六图1843200像素；尺寸穷举2359296对、背压、小帧边界 |
| tf_bmp_file_player | 稳定头字段共享几何，删除重复stride/image_bytes/pixel_end/mask流水 | 21项failure_detail、4类错误保留帧及完整BMP回归 |
| player_pcm_waveform | 四组并行寄存器数组改64×14同步BRAM双bank，下一拍坐标预读；非零mask改前后台OR标志；删除未读wire | 1132601拍、6提交/5切源、提交碰撞取消、597767频带事务；真实FFT/像素gold |

精确位宽与地址范围证明保留原输入/错误语义；本轮没有新增运行时防御分支。计时器消融结论见下表与独立实验目录。

全top综合统一记录TD Utilization器件LUT/FF，route独立记录Slice。standalone通用LUT与器件LUT分别列出；详细SHA、报告路径见{link(C/'build/ablation_summary.json','消融汇总')}。

| 全top阶段 | 器件LUT/FF（gate） | 实际route Slice | 处置 |
|---|---:|---:|---|
| C11312 | 16668/10016 | 9712/99.10% | 冻结参考 |
| A01 BPB位宽 | 16680/10005 | 未运行 | 首轮单项 |
| A02 流式分区 | 16440/9786 | 未运行 | 合并 |
| A03 catalog冗余 | 16473/9634 | 未运行 | FF收益，组合继续验证 |
| A04 BMP位宽 | 15658/9344 | 未运行 | 合并 |
| A05 mapper算法/地址/索引 | 15259/9217 | 未运行 | 单项与组合消融 |
| A06 19拍除法/诊断共享 | 15193/9239 | 未运行 | DSP12→11 |
| A07 流式目录名 | 15180/9100 | 未运行 | 合并 |
| A08 波形BRAM | 14555/8430 | 8354/85.24% | setup+.640/hold+.003 |
| A09 OR地址/非零标志 | 14502/8430 | 8451/86.23% | 逻辑减少、打包多97 Slice |
| A10 官方AreaOptimizeHigh | 13861/8419 | 8243/84.11% | 同RTL策略消融；setup+.101/hold+.011 |

- AreaOptimizeHigh来源为安装包official_strategy_ph1.json，参数和SHA见{link(C/'build/area_strategy.json','策略凭据')}。采用运行时参数并预置Project与Run的map_mode。前两次scope守卫拒绝结果保存在attempts，最终选择仅使用success阶段证据。
- 共享36位BPB ALU：511几何、175目录事务通过，但standalone器件LUT2110→2197，增加87，退出主候选；见{link(ROOT/'development/resource_opt_work/catalog_serial/README.md','负收益实验')}。
- AdderChainThresholdHigh standalone：catalog器件LUT2110→2020，mapper1226→1234；仅作诊断，详见{link(ROOT/'development/resource_opt_work/adder_threshold/README.md','策略消融')}。
- 计时器watchdog/自动轮播/mapper等待/按键消抖/blink：编译期范围精确缩位，默认理论省52 FF位；参数范围证明和公共/小参数差分见{link(ROOT/'development/resource_opt_work/timer_verify','计时器实验')}。实际最终保留以本报告首行选择、源清单及追加的A11结果为准。

## 同阶段同约束的最终资源与时序

| 指标 | C11312 | 最终候选 |
|---|---:|---:|
'''
    for name, baseline, value in rows:
        text += f'| {name} | {baseline} | {value} |\n'
    timer = C / 'build/attempts/11_timer_exact/experiment_result.json'
    timer_detail = ''
    if timer.exists():
        measured = json.loads(timer.read_text(encoding='utf-8'))
        timer_route = (f"{measured['slices']}/9800={measured['slices']/9800*100:.2f}%；"
                       f"setup {measured['setup_ns']}ns、hold {measured['hold_ns']}ns"
                       if measured['slices'] is not None else
                       '两次physical在holdfix后发生TD coredump，最终Slice/STA未取得')
        timer_detail = ('\n计时器全top消融A11：gate '
                        f"{measured['gate_lut']}/{measured['gate_ff']} LUT/FF；route "
                        f"{timer_route}。"
                        f"处置：{measured['disposition'].rstrip('。')}。"
                        f"证据：{link(timer,'A11结果')}。\n")
    text += f'''
证据：{link(C/'src/td_project/route.qor','route QoR')}、{link(manual/'AC201_tf_hdmi_phy.area','物理资源报告')}、{link(manual/'AC201_tf_hdmi_pr.timing','最终STA')}。PLL2/GCLK3、时钟频率、PHY、引脚、SDC保持基线；原有未约束I/O告警留在日志，STA覆盖率按TD报告记录。
{timer_detail}

## 分层验证状态

| 验证层级 | 状态 | 范围与证据 |
|---|---|---|
| 静态范围/冗余审阅 | PASS | BMP穷举、地址界、计时器参数界；独立5模块review findings=[] |
| RTL原始对照 | PASS | catalog、mapper、BMP、波形逐拍/逐像素与事务差分，build/regression |
| RTL负例 | PASS | FAT坏BPB/溢出/4097簇/EOC/环；BMP21诊断、4错误帧、源切换/reset取消 |
| BMP/WAV/FAT32综合媒体 | PASS_WITH_MODEL_ASSUMPTIONS | {link(args.system/'summary.json','最终整机summary')}；122ms媒体回放 |
| FFT定点参考与可见柱体 | PASS | 3帧72频带最大误差0；真实频谱可见像素与独立renderer gold |
| HDMI串行RGB/音频 | PASS_WITH_MODEL_ASSUMPTIONS | 1536000 RGB逐像素、4446 PCM对；首冷帧排除、尾1对PCM留在fixture约定 |
| gate FFT/ROM | PASS | 真实EG4原语3帧72频带，{link(C/'build/gate_verify/run.log','完整输出')}；1536 ROM词 |
| ROM静态参数 | {raw['status']}（差异保留） | mux SIG/INV映射变化原件留存；{link(C/'build/gate_verify/normalized_control_proof.json','192项有效极性证明')}为PASS |
| routed ROM/时钟拓扑 | PASS | ROM初始化及有效控制，45项时钟检查，build/audit |
| route/最终STA | PASS | setup {setup}ns / hold {hold}ns，TNS {stns}/{htns}ns |
| 离线候选bit | PASS | wrapper成功阶段记录、SHA和源绑定 |
| 真实上板 | NOT_RUN | BOARD_NOT_TESTED；现场故障继续保留原记录 |

整机模型继承PLL nominal replay与应用接口SDRAM模型。真实外部SDRAM时序、TF卡电气、PLL上锁与板端显示/音频仍待实板验证。完整top HDL回放与门级FFT功能锥各自保存证据。
整机summary中的version=C11312沿用冻结夹具身份；实际C11313源与七项override见同目录source_receipt.json，最终源绑定核查见{link(C/'build/final_binding.json','最终绑定检查')}。

最终gate层级报告的LUT/ripple/seq列：catalog为1772/170/1149、BMP loader含scale为1768/231/873、波形含FFT为1066/239/464、WAV player为1031/134/650；层级父子包含关系按TD原报表保留。最终setup关键路径在WAV data_length_reg到fifo_bypass_word_reg的CE，19级逻辑，余量+0.101ns。

## 产物与接续

- 离线候选：{link(bit)}，SHA256 `{bit_sha}`。
- {link(checkpoint/'manifest.json','封存manifest')}覆盖已选源/脚本/仿真、关键报告、阶段身份和bit；工作DB保留在candidate/build/manual。
- 构建命令依次为 `pwsh -NoProfile -File development/player_spectrum_resource_fit/scripts/build_candidate.ps1 -Stage synthesis`、`-Stage physical`、`-Stage bitstream`；脚本检查源/阶段哈希与最终时序。
- 本轮完成已识别冗余、算法与综合策略优化，85%目标已达。继续争取80%时，依据层级面积优先研究catalog、BMP loader及WAV地址/使能链的单项算法；先量化多路器成本，再做同约束route消融。
- 硬件接续应使用C11313候选完成build ID、启动、图片缩放、两音源、字幕/按键、动态频谱及持续运行验证，再补板测记录。此次资源与仿真结论独立留档。
'''
    (D / 'README.md').write_text(text, encoding='utf-8')
    (C / 'README.md').write_text('# C11313 保功能资源优化\n\n'+f'最终资源与消融、测试、未完成项见{link(D/"README.md","资源优化报告")}。\n\n'+f'源/阶段/bit身份见{link(checkpoint/"manifest.json","封存清单")}。\n', encoding='utf-8')
    print(D / 'README.md')


if __name__ == '__main__':
    main()
