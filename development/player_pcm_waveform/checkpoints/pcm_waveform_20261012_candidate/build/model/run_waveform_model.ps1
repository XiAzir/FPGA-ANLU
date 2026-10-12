param(
    [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
)

$ErrorActionPreference = 'Stop'
$workspaceRoot = (Resolve-Path (Join-Path $ProjectRoot '../..')).Path
$modelDir = Join-Path $ProjectRoot 'build/model'
$iverilog = Join-Path $workspaceRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$vvp = Join-Path $workspaceRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
$rtl = Join-Path $ProjectRoot 'src/user_source/hdl_source/player_pcm_waveform.v'
$tb = Join-Path $modelDir 'tb_player_pcm_waveform.v'
$image = Join-Path $modelDir 'tb_player_pcm_waveform.vvp'
$log = Join-Path $modelDir 'player_pcm_waveform_model.log'

if (!(Test-Path -LiteralPath $iverilog)) { throw "iverilog not found: $iverilog" }
if (!(Test-Path -LiteralPath $vvp)) { throw "vvp not found: $vvp" }
& $iverilog -g2012 -Wall -s tb_player_pcm_waveform -o $image $rtl $tb
if ($LASTEXITCODE -ne 0) { throw "iverilog failed with exit code $LASTEXITCODE" }
& $vvp $image 2>&1 | Tee-Object -FilePath $log
if ($LASTEXITCODE -ne 0) { throw "vvp failed with exit code $LASTEXITCODE" }
if (!(Select-String -LiteralPath $log -Pattern '^MODEL PASS ' -Quiet)) {
    throw "Simulation did not report MODEL PASS. See $log"
}
