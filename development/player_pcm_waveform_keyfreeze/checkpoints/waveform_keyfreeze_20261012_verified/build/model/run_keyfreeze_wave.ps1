$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$workspaceRoot = (Resolve-Path (Join-Path $projectRoot '../..')).Path
$iverilog = Join-Path $workspaceRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$vvp = Join-Path $workspaceRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
$rtl = Join-Path $projectRoot 'src/user_source/hdl_source/player_pcm_waveform.v'
$testbench = Join-Path $PSScriptRoot 'tb_keyfreeze_wave.v'
$log = Join-Path $PSScriptRoot 'keyfreeze_wave.log'
$image = Join-Path $env:TEMP ('keyfreeze_wave_' + [guid]::NewGuid().ToString('N') + '.vvp')

if (!(Test-Path -LiteralPath $iverilog)) { throw "iverilog not found: $iverilog" }
if (!(Test-Path -LiteralPath $vvp)) { throw "vvp not found: $vvp" }
if (!(Test-Path -LiteralPath $rtl)) { throw "RTL not found: $rtl" }
if (!(Test-Path -LiteralPath $testbench)) { throw "Testbench not found: $testbench" }

try {
    & $iverilog -g2012 -Wall -s tb_keyfreeze_wave -o $image $rtl $testbench
    if ($LASTEXITCODE -ne 0) { throw "iverilog failed with exit code $LASTEXITCODE" }

    $output = & $vvp $image 2>&1
    $vvpExitCode = $LASTEXITCODE
    $output | Tee-Object -FilePath $log
    if ($vvpExitCode -ne 0) { throw "vvp failed with exit code $vvpExitCode" }
    if (!(Select-String -LiteralPath $log -Pattern '^KEYFREEZE PASS ' -Quiet)) {
        throw "Simulation did not report KEYFREEZE PASS. See $log"
    }
}
finally {
    if (Test-Path -LiteralPath $image) { Remove-Item -LiteralPath $image -Force }
}
