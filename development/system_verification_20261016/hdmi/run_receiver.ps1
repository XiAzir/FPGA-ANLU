$ErrorActionPreference = 'Stop'
$toolBin = 'E:\ModelsimSE\win64'
$sourceRoot = 'E:\VSCODE-project\FPGA-ANLU\development\player_spectrum_fft_recover\src\user_source\hdl_source'
$legacySim = 'E:\VSCODE-project\FPGA-ANLU\development\player_spectrum_fft_recover\build\board_feedback_no_signal_20261014\modelsim'
$env:MGLS_LICENSE_FILE = [Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE', 'User')
Set-Location -LiteralPath $PSScriptRoot

# Use a local copy of the established library map; never write into its source.
if (-not (Test-Path -LiteralPath '.\modelsim.ini')) {
    Copy-Item -LiteralPath "$legacySim\modelsim.ini" -Destination '.\modelsim.ini'
}

if (-not (Test-Path -LiteralPath '.\work')) { & "$toolBin\vlib.exe" work }
& "$toolBin\vlog.exe" -work work -L EG4 `
    'C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\sim_release\eg4\eg_phy_glbl.v' `
    "$sourceRoot\lane_lvds_10_1.v" `
    "$sourceRoot\hdmi_phy_warpper.v" `
    "$sourceRoot\hdmi_packet_monitor.v" `
    '.\hdmi_serial_receiver.v' '.\hdmi_serial_packet_monitor.v' '.\tb_hdmi_serial_receiver.v'
if ($LASTEXITCODE -ne 0) { throw "vlog failed: $LASTEXITCODE" }

$phaseLogs = @()
foreach ($phase in @(0, 1000, 2000)) {
    $phaseLog = Join-Path $PSScriptRoot "receiver_phase_${phase}ps.log"
    $phaseLogs += $phaseLog
    Remove-Item -LiteralPath $phaseLog -ErrorAction SilentlyContinue
    & "$toolBin\vsim.exe" -c -novopt -L EG4 work.tb_hdmi_serial_receiver `
        work.glbl "+phase_ps=$phase" -l $phaseLog -do 'run -all; quit -f'
    if ($LASTEXITCODE -ne 0) { throw "vsim failed phase $phase`: $LASTEXITCODE" }
}
$negativeLog = Join-Path $PSScriptRoot 'receiver_negative_bitflip.log'
$phaseLogs += $negativeLog
Remove-Item -LiteralPath $negativeLog -ErrorAction SilentlyContinue
& "$toolBin\vsim.exe" -c -novopt -L EG4 work.tb_hdmi_serial_receiver `
    work.glbl '+phase_ps=1000' '+corrupt' -l $negativeLog -do 'run -all; quit -f'
if ($LASTEXITCODE -ne 0) { throw "negative control simulation failed: $LASTEXITCODE" }
foreach ($phaseLog in $phaseLogs) {
    if (Select-String -LiteralPath $phaseLog -Pattern 'FAILED|Fatal:' -Quiet) { throw "receiver test log contains failures: $phaseLog" }
    if (-not (Select-String -LiteralPath $phaseLog -Pattern 'PASS: receiver reconstructed|PASS: injected physical serial bit flip detected' -Quiet)) { throw "receiver PASS marker missing: $phaseLog" }
}
Write-Output "Simulation passed for 3 serial/pixel phase offsets and the serial bit-flip negative control. Logs: $($phaseLogs -join ', ')"
