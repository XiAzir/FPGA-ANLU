$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$iverilog = 'E:\VSCODE-project\FPGA-ANLU\bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp = 'E:\VSCODE-project\FPGA-ANLU\bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
$rtl = @(
    (Join-Path $root 'tmds_channel.v'),
    (Join-Path $root 'auxiliary_video_information_info_frame.v'),
    (Join-Path $root 'packet_assembler_compat.v'),
    (Join-Path $root 'video_only_tmds_tx.v')
)

$compileOutput = & $iverilog -g2005 -s video_only_tmds_tx -o (Join-Path $PSScriptRoot 'g2005.vvp') @rtl 2>&1
$compileExit = $LASTEXITCODE
$compileOutput | Out-File -LiteralPath (Join-Path $PSScriptRoot 'iverilog_g2005.log') -Encoding utf8
if ($compileExit -ne 0) { throw 'Verilog-2005 RTL compile failed; see iverilog_g2005.log.' }
Remove-Item -LiteralPath (Join-Path $PSScriptRoot 'g2005.vvp') -ErrorAction SilentlyContinue

foreach ($scenario in @('short_v', 'c35_full', 'c36_full')) {
    $image = Join-Path $PSScriptRoot ($scenario + '.vvp')
    $tb = Join-Path $PSScriptRoot ('tb_' + $scenario + '.sv')
    $compileLog = Join-Path $PSScriptRoot ($scenario + '_compile.log')
    $simLog = Join-Path $PSScriptRoot ($scenario + '_sim.log')
    $compileOutput = & $iverilog -g2012 -s tb_video_only_tmds_tx -o $image @rtl $tb 2>&1
    $compileExit = $LASTEXITCODE
    $compileOutput | Out-File -LiteralPath $compileLog -Encoding utf8
    if ($compileExit -ne 0) { throw "$scenario compile failed; see $compileLog." }
    try {
        $simOutput = & $vvp $image 2>&1
        $simExit = $LASTEXITCODE
        $simOutput | Out-File -LiteralPath $simLog -Encoding utf8
        if ($simExit -ne 0) { throw "$scenario simulation failed; see $simLog." }
        $pass = Select-String -LiteralPath $simLog -Pattern '^PASS:' -Quiet
        if (-not $pass) { throw "$scenario did not report PASS; see $simLog." }
        Select-String -LiteralPath $simLog -Pattern '^PASS:' | ForEach-Object { $_.Line }
    } finally {
        Remove-Item -LiteralPath $image -ErrorAction SilentlyContinue
    }
}
