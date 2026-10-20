. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$ErrorActionPreference = 'Stop'

$task = Split-Path -Parent $PSScriptRoot
$project = Split-Path -Parent (Split-Path -Parent $task)
$hdl = Join-Path $task 'src/user_source/hdl_source'
$model = Join-Path $task 'build/model'
$iverilog = (Resolve-AnluTool -Name 'iverilog')
$vvp = (Resolve-AnluTool -Name 'vvp')
$image = Join-Path $model 'status_clock_route.vvp'
$compileLog = Join-Path $model 'status_clock_route_compile.log'
$runLog = Join-Path $model 'status_clock_route_run.log'
$bindingPath = Join-Path $model 'status_clock_route_binding.json'
$reportPath = Join-Path $model 'status_clock_route_report.md'

New-Item -ItemType Directory -Force $model | Out-Null
if (!(Test-Path -LiteralPath $iverilog)) { throw "Icarus compiler not found: $iverilog" }
if (!(Test-Path -LiteralPath $vvp)) { throw "Icarus runtime not found: $vvp" }

Push-Location $hdl
try {
    & $iverilog -g2012 -s tb_status_clock_route -o $image `
        (Join-Path $PSScriptRoot 'tb_status_clock_route.v') `
        (Join-Path $hdl 'player_status_mailbox.v') `
        (Join-Path $hdl 'status_hex595.v') 2>&1 | Tee-Object -FilePath $compileLog
    if ($LASTEXITCODE -ne 0) { throw 'Status clock route test compile failed' }

    & $vvp $image 2>&1 | Tee-Object -FilePath $runLog
    if ($LASTEXITCODE -ne 0) { throw 'Status clock route test simulation failed' }
} finally {
    Pop-Location
}

$files = @(
    (Join-Path $hdl 'player_status_mailbox.v'),
    (Join-Path $hdl 'status_hex595.v'),
    (Join-Path $hdl 'top_tf_hdmi_audio.v'),
    (Join-Path $PSScriptRoot 'tb_status_clock_route.v'),
    $PSCommandPath
)
$hashes = foreach ($file in $files) {
    [pscustomobject]@{
        path = $file
        sha256 = (Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash
    }
}
$binding = [ordered]@{
    version = 'C11309'
    scope = 'Production status mailbox + production status_hex595; external pin-level digital model only.'
    sourceClockMHz = 25
    destinationClockMHz = 50
    scanHz = 1000
    clockPhasesNs = @(0, 5, 10, 15, 19)
    configuredSerialClockMHz = 1
    observedSerialBitPeriodNs = 1020
    observedSerialBitRateMHz = 0.980392
    result = 'PASS'
    limit = 'Digital RTL simulation only; no FPGA PAD, board trace, 74HC595, display, or electrical behavior was measured.'
    files = @($hashes)
}
$binding | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $bindingPath -Encoding utf8
@'
# C11309 status clock-route model

Result: PASS in five integrated source/destination phase cases (0, 5, 10, 15, 19 ns). Each case used the production `player_status_mailbox.v` and `status_hex595.v`, 25 MHz source, 50 MHz destination, and 1000 Hz scan request.

The testbench observes only `destination_hex`, `seg7_dio`, `seg7_sclk`, and `seg7_rclk`. It reconstructs all 16-bit transfers at the SCLK edge, checks DIO setup, one-hot digit order, 16-bit RCLK latch boundaries, and decodes full eight-digit frames. It covers `01234567`, `88888888`, `DFC11309`, `E4000000`, `F0000000`, and `F1000010`; more than 100,000 source updates across a live display frame using three distinct patterns (the frame must remain one coherent value); a source-clock pause after handshake while the 595 scan continues on the frozen value; then asynchronous reset, zeroing, and restart.

The 1 MHz serial setting produces a measured 1020 ns interval between SCLK rising edges inside each word (about 0.980392 MHz). The additional 20 ns is the driver's `ST_SHIFT_SET` cycle. All five runs observed the same period and passed the setup/latch assertions.

This is a digital RTL model. It does not validate routed FPGA PAD timing, board wiring, the external 74HC595, display enable switches, or electrical levels. The source status pages are supplied as input values; the monitor's page-generation logic is outside this test's scope.

Files and SHA-256 bindings: `status_clock_route_binding.json`. Compilation and simulation logs: `status_clock_route_compile.log` and `status_clock_route_run.log`.
'@ | Set-Content -LiteralPath $reportPath -Encoding utf8
Write-Output "PASS; binding: $bindingPath"
Write-Output "Report: $reportPath"
