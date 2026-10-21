$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$iverilog = Resolve-AnluTool -Name 'iverilog'
$vvp = Resolve-AnluTool -Name 'vvp'
$out = Join-Path $PSScriptRoot 'build'
$null = New-Item -ItemType Directory -Force -Path $out
$image = Join-Path $out 'wav_candidate.vvp'
$log = Join-Path $out 'candidate_sim.log'
& $iverilog -g2005 -Wall -s tb_wav_file_player -o $image `
    (Join-Path $PSScriptRoot 'tb_wav_file_player.v') `
    (Join-Path $PSScriptRoot 'tf_wav_file_player.v') `
    (Join-Path $PSScriptRoot 'tf_wav_file_player_reference.v') 2>&1 |
    Tee-Object -FilePath (Join-Path $out 'iverilog.log')
if ($LASTEXITCODE -ne 0) { throw "iverilog failed: $LASTEXITCODE" }
& $vvp $image 2>&1 | Tee-Object -FilePath $log
if ($LASTEXITCODE -ne 0) { throw "vvp failed: $LASTEXITCODE" }
if (!(Select-String -LiteralPath $log -SimpleMatch 'PASS: all WAV file player self-checks passed' -Quiet)) {
    throw "WAV simulation did not report PASS; see $log"
}
if (Select-String -LiteralPath $log -SimpleMatch 'DIFFERENTIAL' -Quiet) {
    throw "Candidate/reference differential mismatch; see $log"
}
