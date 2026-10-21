param(
    [string]$Iverilog = 'E:/VSCODE-project/FPGA-ANLU/bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe',
    [string]$Vvp = 'E:/VSCODE-project/FPGA-ANLU/bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
)
$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$testbench = Join-Path $root 'tb_full_six.v'
$baseline = Join-Path $root 'bmp_scale_engine_base_pair.v'
$candidate = Join-Path $root 'bmp_scale_engine_candidate_pair.v'
$baseLoader = Join-Path $root 'tf_bmp_file_player_base_pair.v'
$candLoader = Join-Path $root 'tf_bmp_file_player_candidate_pair.v'
$keyDebounce = 'E:/VSCODE-project/FPGA-ANLU/development/arch17_work/scaler_lifetime/key_press_debounce.v'
$image = Join-Path $root 'full_six.vvp'
$compileLog = Join-Path $root 'full_six_compile.log'
$runLog = Join-Path $root 'full_six_run.log'
$errLog = Join-Path $root 'full_six_run.err'
& $Iverilog -g2001 -s tb_scaler_full_loader -o $image $baseline $candidate $baseLoader $candLoader $keyDebounce $testbench *> $compileLog
if ($LASTEXITCODE -ne 0) { throw "compile failed with exit $LASTEXITCODE; see $compileLog" }
Write-Output "COMPILE_COMPLETE image=$image testbench_sha=$((Get-FileHash -LiteralPath $testbench -Algorithm SHA256).Hash)"
Write-Output "SIMULATION_STARTED utc=$([DateTime]::UtcNow.ToString('yyyy-MM-dd HH:mm:ss'))"
& $Vvp $image 1> $runLog 2> $errLog
$simExit = $LASTEXITCODE
if ($simExit -ne 0) { throw "simulation failed with exit $simExit; see $runLog and $errLog" }
$pass = Select-String -LiteralPath $runLog -Pattern 'SCALER_INTEGRATION PASS images=6 pairs=C11316/CANDIDATE_HEADER_VALIDATED1 pixels=1843200 cycle_outputs=matched' | Select-Object -Last 1
if (-not $pass) { throw "final paired PASS record missing; see $runLog" }
Get-Content -LiteralPath $runLog -Tail 15
Write-Output "SIMULATION_COMPLETE exit=$simExit result=PASS"
