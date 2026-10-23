$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
$taskSource=Join-Path $taskRoot 'development/player_video28_hdmi_observe/src/user_source/hdl_source'
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
        "$taskSource/player_hdmi_runtime_probe.v" `
        tb_phy_probe_matrix.sv *> compile.log
    if ($LASTEXITCODE -ne 0) { throw 'vlog failed; see compile.log' }
    $clockCases=@(
        @{ tag='3e0'; value=992 },
        @{ tag='01f'; value=31 }
    )
    foreach ($clockCase in $clockCases) {
        $runLog="run_$($clockCase.tag).log"
        $consoleLog="console_$($clockCase.tag).log"
        & "$taskModelsim/vsim.exe" -c -novopt -L EG4 `
            "-g/tb_phy_probe_matrix/CLOCK_WORD=$($clockCase.value)" `
            work.tb_phy_probe_matrix work.glbl -l $runLog `
            -do 'onerror {quit -code 2 -f}; run -all; quit -f' *> $consoleLog
        if ($LASTEXITCODE -ne 0) { throw "vsim failed; see $runLog" }
        $marker="PASS: CLOCK_WORD=$($clockCase.tag); 64 phase/reset pairs x3 sessions; ODDR input probe delta 254..258; 3 serial pin bit-flip negative controls detected"
        if (!(Select-String -LiteralPath $runLog -SimpleMatch $marker -Quiet)) {
            throw "Matrix PASS marker missing in $runLog"
        }
        Get-Content -LiteralPath $runLog -Tail 4
    }
} finally { Pop-Location }
