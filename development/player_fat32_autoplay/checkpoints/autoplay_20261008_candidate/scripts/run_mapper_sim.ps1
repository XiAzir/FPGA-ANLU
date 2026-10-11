$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$iverilog = 'E:/VSCODE-project/FPGA-ANLU/bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$vvp = 'E:/VSCODE-project/FPGA-ANLU/bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
$out = Join-Path $root 'build/fat_sim/mapper.vvp'
$log = Join-Path $root 'build/fat_sim/mapper_compile.log'
& $iverilog -g2001 -Wall -s tb_fat32_file_sector -o $out (Join-Path $root 'src/user_source/hdl_source/fat32_file_sector.v') (Join-Path $root 'sim/tb_fat32_file_sector.v') 2>&1 | Tee-Object -FilePath $log
if ($LASTEXITCODE -ne 0) { throw "iverilog failed: $LASTEXITCODE" }
& $vvp $out 2>&1 | Tee-Object -FilePath (Join-Path $root 'build/fat_sim/mapper_sim.log')
if ($LASTEXITCODE -ne 0) { throw "vvp failed: $LASTEXITCODE" }
