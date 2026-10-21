param([Parameter(Mandatory)][string]$RunId)
$ErrorActionPreference='Stop'
$gateVerify=$PSScriptRoot
$projectRoot=(Resolve-Path (Join-Path $PSScriptRoot '../../../..')).Path
$project=Join-Path $projectRoot 'development/player_spectrum_arch17'
$audit=Join-Path $project 'build/audit'
$gate=Join-Path $project 'build/manual/AC201_tf_hdmi_gate.v'

& pwsh -NoProfile -File (Join-Path $gateVerify 'run_fft_gate_verify.ps1') -RunId $RunId
if($LASTEXITCODE -ne 0){ throw 'Current gate FFT regression failed.' }
& python (Join-Path $audit 'audit_rom_controls.py') --run-id $RunId --kind gate --netlist $gate --output (Join-Path $audit 'gate_rom_control.json')
if($LASTEXITCODE -ne 0){ throw 'Strict gate ROM control audit failed to produce a bound report.' }
& python (Join-Path $gateVerify 'audit_current_gate_rom_init.py') --run-id $RunId
if($LASTEXITCODE -ne 0){ throw 'Current gate ROM INIT audit failed.' }
& pwsh -NoProfile -File (Join-Path $gateVerify 'prove_current_gate_rom_polarity.ps1') -RunId $RunId
if($LASTEXITCODE -ne 0){ throw 'Exhaustive 32-state gate control polarity proof failed.' }
& python (Join-Path $gateVerify 'adapt_current_normalized_control_proof.py') --run-id $RunId
if($LASTEXITCODE -ne 0){ throw 'Normalized C11317 gate evidence binding failed.' }
Write-Output "C11317_GATE_AUDIT PASS runId=$RunId"
