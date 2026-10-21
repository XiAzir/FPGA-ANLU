param(
    [Parameter(Mandatory)][string]$RunId,
    [Parameter(Mandatory)][string]$TimingPath
)
$ErrorActionPreference='Stop'
$projectRoot=(Resolve-Path (Join-Path $PSScriptRoot '../../../..')).Path
$project=Join-Path $projectRoot 'development/player_spectrum_resource_80'
$audit=Join-Path $project 'build/audit'
$routed=Join-Path $audit 'routed_implementation.v'
if(!(Test-Path -LiteralPath $routed)){ throw "Missing parent-exported routed netlist: $routed" }
& python (Join-Path $audit 'audit_rom_controls.py') --run-id $RunId --kind routed --netlist $routed --output (Join-Path $audit 'routed_rom_control.json')
if($LASTEXITCODE -ne 0){ throw 'Strict routed ROM control audit failed to produce a bound report.' }
& python (Join-Path $PSScriptRoot 'audit_current_gate_rom_init.py') --run-id $RunId
if($LASTEXITCODE -ne 0){ throw 'Current run gate ROM INIT audit failed.' }
& python (Join-Path $audit 'audit_clock_route.py') --run-id $RunId --netlist $routed --timing $TimingPath --output (Join-Path $audit 'routed_clock_audit.md')
if($LASTEXITCODE -ne 0){ throw 'C11314 routed clock/pad audit failed.' }
Write-Output "C11314_ROUTED_AUDIT PASS runId=$RunId"
