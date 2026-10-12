# 本地仿真工具准备

`iverilog/`、`innoextract/`、Icarus 安装程序和 innoextract 压缩包是本机工具文件，Git 会忽略这些二进制。版本、下载 URL 和 SHA256 记录在本目录的 `provenance.json`；innoextract 发布校验值也见 `innoextract_sha256.txt`。

在项目根目录用 PowerShell 7 执行：

```powershell
pwsh -NoProfile -File scripts/setup_iverilog.ps1
```

脚本下载并校验 Icarus 12 安装程序和 innoextract 1.9 压缩包，再调用 innoextract 将 Icarus 文件解包到本目录。下载先使用 TLS 1.2；失败时最多由 `curl.exe` 重试两次，之后仍须通过 provenance 中的 SHA256，校验失败会停止。它不会运行安装程序、修改 PATH/注册表或读取许可证。若 `tools/iverilog` 已有正确版本，脚本会检查并复用；已有目录内容不匹配时会停止并保留目录，供人工检查。

脚本末尾会打印 `ANLU_IVERILOG_BIN` 建议值，例如：

```powershell
$env:ANLU_IVERILOG_BIN = 'E:\path\to\FPGA-ANLU\bringup\tf_wav_hdmi\tools\iverilog\app\bin'
```

这只设置当前 PowerShell 会话。项目仿真脚本默认从工程内 `tools/iverilog/app/bin` 查找 `iverilog.exe` 和 `vvp.exe`，也支持使用 `ANLU_IVERILOG_BIN` 指向另一个工具目录。

环境与接续资料检查：

```powershell
python scripts/check_development_environment.py --docs-root '..\FPGA-ANLU-docs'
```

若使用个人资料仓路径，给 `--docs-root` 传入该目录。`--files-only` 跳过工具检查；`--all-checkpoints` 对全部历史检查点执行清单哈希校验；`--json <路径>` 可另存不含环境变量值或许可证正文的摘要报告。该检查只读工程文件和版本信息，不运行 TD 构建或硬件操作。它会逐项校验当前 C11206 verified manifest、验收凭据、C11205 父版本 manifest、四张 BMP 和按 `real_music_20261008.package_audit.json` 记录的 `TEST.WAV` 哈希，并指出检查点清单未包含的 `.db`/`.vvp` 文件。

TD、BitWriter 与所需许可仍须在目标机器按厂商流程安装和配置。检查器通过 `td_commands_prompt.exe` 确认命令行入口：`ANLU_TD_BIN` 只能设为该文件所在的绝对 `bin` 目录；未设置时检查 PATH，最后回退到旧目录 `C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/bin`。它只确认 wrapper 存在，不启动 TD，也不判断许可证是否有效。
