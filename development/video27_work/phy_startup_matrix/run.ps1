$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
$taskSource=Join-Path $taskRoot 'development/player_video27_command_boundary/src/user_source/hdl_source'
# This PHY-only experiment uses the existing, read-only vendor EG4 library.
$taskModelsim='E:/ModelsimSE/win64'
$taskMap=Join-Path $taskRoot 'development/system_verification_20261016/hdmi/modelsim.ini'
$env:MGLS_LICENSE_FILE=[Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')
Push-Location -LiteralPath $PSScriptRoot
try {
    Copy-Item -LiteralPath $taskMap -Destination modelsim.ini
    if (!(Test-Path -LiteralPath work)) { & "$taskModelsim/vlib.exe" work *> vlib.log }
    & "$taskModelsim/vlog.exe" -sv -work work -L EG4 `
        'C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_phy_glbl.v' `
        "$taskSource/lane_lvds_10_1.v" "$taskSource/hdmi_phy_warpper.v" `
        "$taskRoot/development/system_verification_20261016/hdmi/hdmi_serial_receiver.v" `
        tb_phy_startup_matrix.sv *> compile.log
    if ($LASTEXITCODE -ne 0) { throw 'vlog failed; see compile.log' }
    & "$taskModelsim/vsim.exe" -c -novopt -L EG4 work.tb_phy_startup_matrix work.glbl `
        -l run.log -do 'onerror {quit -code 2 -f}; run -all; quit -f' *> console.log
    if ($LASTEXITCODE -ne 0) { throw 'vsim failed; see run.log' }
    if (!(Select-String -LiteralPath run.log -SimpleMatch `
        'PASS: 64 phase/reset pairs x3 sessions; 3 serial bit-flip negative controls detected' -Quiet)) {
        throw 'Matrix PASS marker missing'
    }
    Get-Content -LiteralPath run.log -Tail 4
} finally { Pop-Location }
