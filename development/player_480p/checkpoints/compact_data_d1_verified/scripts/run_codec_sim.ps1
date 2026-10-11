$ErrorActionPreference = 'Stop'

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$iverilog = 'E:\VSCODE-project\FPGA-ANLU\bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp = 'E:\VSCODE-project\FPGA-ANLU\bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
$source = Join-Path $projectRoot 'src\user_source\hdl_source\rgb888_word_codec.v'
$testbench = Join-Path $projectRoot 'sim\tb_rgb888_word_codec.v'
$simDir = Join-Path $projectRoot 'build\sim'
$output = Join-Path $simDir 'tb_rgb888_word_codec.vvp'
$log = Join-Path $simDir 'codec.log'

New-Item -ItemType Directory -Path $simDir -Force | Out-Null
Set-Content -LiteralPath $log -Value 'RGB888 codec simulation'

foreach ($tool in @($iverilog, $vvp)) {
    if (-not (Test-Path -LiteralPath $tool -PathType Leaf)) {
        throw "Required local simulator executable not found: $tool"
    }
}

Add-Content -LiteralPath $log -Value "Compile: $iverilog -g2012 -Wall -s tb_rgb888_word_codec -o $output $source $testbench"
& $iverilog -g2012 -Wall -s tb_rgb888_word_codec -o $output $source $testbench 2>&1 |
    Tee-Object -FilePath $log -Append
if ($LASTEXITCODE -ne 0) {
    Add-Content -LiteralPath $log -Value "FAIL: iverilog exit code $LASTEXITCODE"
    throw "iverilog failed with exit code $LASTEXITCODE"
}

Add-Content -LiteralPath $log -Value "Run: $vvp $output"
& $vvp $output 2>&1 | Tee-Object -FilePath $log -Append
if ($LASTEXITCODE -ne 0) {
    Add-Content -LiteralPath $log -Value "FAIL: vvp exit code $LASTEXITCODE"
    throw "vvp failed with exit code $LASTEXITCODE"
}
