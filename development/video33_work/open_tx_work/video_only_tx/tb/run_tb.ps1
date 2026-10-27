$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$iverilog = 'E:\VSCODE-project\FPGA-ANLU\bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp = 'E:\VSCODE-project\FPGA-ANLU\bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
$image = Join-Path $PSScriptRoot 'video_only.vvp'
$compileLog = Join-Path $PSScriptRoot 'iverilog_compile.log'
$simLog = Join-Path $PSScriptRoot 'iverilog_sim.log'

$sources = @(
    (Join-Path $root 'upstream\src\tmds_channel.sv'),
    (Join-Path $root 'upstream\src\auxiliary_video_information_info_frame.sv'),
    (Join-Path $root 'rtl\packet_assembler_compat.sv'),
    (Join-Path $root 'rtl\video_only_tmds_tx.sv'),
    (Join-Path $PSScriptRoot 'tb_video_only_tmds_tx.sv')
)

$compileOutput = & $iverilog -g2012 -s tb_video_only_tmds_tx -o $image @sources 2>&1
$compileExit = $LASTEXITCODE
$compileOutput | Out-File -LiteralPath $compileLog -Encoding utf8
if ($compileExit -ne 0) {
    throw "Icarus compile failed with exit code $compileExit. See $compileLog"
}

try {
    $simOutput = & $vvp $image 2>&1
    $simExit = $LASTEXITCODE
    $simOutput | Out-File -LiteralPath $simLog -Encoding utf8
    if ($simExit -ne 0) {
        throw "Icarus simulation failed with exit code $simExit. See $simLog"
    }
    if (-not (Select-String -LiteralPath $simLog -Pattern '^PASS:' -Quiet)) {
        throw "Simulation did not report PASS. See $simLog"
    }
    Select-String -LiteralPath $simLog -Pattern '^PASS:' | ForEach-Object { $_.Line }
} finally {
    if (Test-Path -LiteralPath $image) {
        Remove-Item -LiteralPath $image
    }
}
