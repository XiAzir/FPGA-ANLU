# 本机离线整机验证入口（2026-10-16）

本轮无需连接 FPGA、下载器、读卡器或 TF 卡。已建立冻结版本的完整媒体功能仿真、真实 HDMI 串行输出内容检查，以及独立生产 SDRAM 控制器引脚模型测试。**现场 C11309 频谱空、C11310 无信号仍未复现，没有已确认根因或修复位流。**

- [结果与证据边界](RESULTS_20261016.md)
- [首轮12项nominal矩阵](nominal_matrix.json)
- [新增整机引脚/真实控制器矩阵](extended_matrix.json)（以状态与各项summary为准）
- [覆盖门槛](readiness.json)：局部或nominal通过不能使完整验证自动变绿。
- [存储模型及控制器范围](memory/README.md)、[HDMI严格内容接收](hdmi/README.md)

## 已建立的检查

1. 三版冻结源码逐manifest SHA读取，原百万周期启动等待不缩短；启动控制另有未锁、锁定先后、失锁及复位单元场景。原厂PLL缺初值问题以隔离模型适配明示，nominal回放经过20us逐边沿/锁定校准，固定50MHz参考/reset0。
2. 从TF引脚供应FAT32测试镜像，通过真实SD/CRC/挂载/BMP/WAV/PCM桥/帧缓存backend和FIFO；PCM、图像写入及读出逐项对照独立gold，输入为16×16 BMP和原歌曲4096样本窗口。
3. 从四路HDMI输出恢复TMDS字和视频/音频包，连续严格比对输入像素与实际串行像素，及真实WAV立体声顺序。冷启动首个完整视频帧明确排除，不搜索跳过差异。两频谱版另核真实FFT输入、3帧72频段及可见柱体像素。
4. 未修改生产源的SDRAM wrapper/controller独立TD综合，绕开旧ModelSim对protected RTL语法的编译限制；保留原厂PAD，接APUG011官方IS42s32200引脚模型。实际初始化约2.624ms，固定数据领先valid一拍；四bank、字节掩码、刷新后读回与实际写入翻位负例。
5. 存储bit/视频像素/音频样本翻位、FFT空轨迹/X/缺样本等负例均须实际检出。解释失败时先查模型与测试台，保留原失败证据。

## 复跑

```powershell
$env:MGLS_LICENSE_FILE=[Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')
$env:PYTHONIOENCODING='utf-8'
python development/system_verification_20261016/integration/run_system.py --version C11310 --clock-model replay --serial-scoreboard
python development/system_verification_20261016/memory/run_controller_gate.py --matrix
python development/system_verification_20261016/memory/run_controller_gate.py --matrix --corrupt-data
python development/system_verification_20261016/readiness.py
```

`run_verification.ps1` 可用 `-Stage media-pins -Version C11310` 或 `-Stage controller`。步骤完成后还会运行覆盖门槛；未覆盖项存在时最终exit2是预期结果，不能把它误解为刚完成的子测试失败。

默认 `-novopt`；不用全局kill或向共享控制台发Ctrl-C，只管理本次明确PID。每次新建时间戳目录，输入、模型适配diff和输出SHA留档；collect脚本凭据明确为事后收集，不冒充起跑前凭据。生产/冻结源、旧bit/ZIP不改，本轮独立综合不生成新bit。

## 仍缺的范围

完整top当前仍用应用接口SDRAM模型；真实controller引脚资格是独立测试，不能合并声称实际整个实现已通过。两处9位FIFO计数到10位输入在隔离副本中显式补0，旧ModelSim原连接会留下Z，所有差异保留。

整机真实长按KEY1、非nominal复位/时钟/卡延迟组合、完整SDF与实际SiP电气、全部原卡文件和长期运行仍缺。后续优先消除这些模型/场景差距，将实际故障做成“稳定版通过、失败版失败”的可复现回归；不以换seed或继续发布猜测性bit替代定位。
