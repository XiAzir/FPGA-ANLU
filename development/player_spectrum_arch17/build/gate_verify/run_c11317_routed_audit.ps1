param(
    [Parameter(Mandatory)][string]$RunId,
    [Parameter(Mandatory)][string]$PhysicalRunId,
    [Parameter(Mandatory)][string]$TimingPath
)
$ErrorActionPreference='Stop'
$projectRoot=(Resolve-Path (Join-Path $PSScriptRoot '../../../..')).Path
$project=Join-Path $projectRoot 'development/player_spectrum_arch17'
$audit=Join-Path $project 'build/audit'
$manual=Join-Path $project 'build/manual'
$evidence=Join-Path $manual 'stage_evidence'
$physicalPointer=Get-Content -LiteralPath (Join-Path $evidence 'latest_physical.json') -Raw | ConvertFrom-Json
if($physicalPointer.stage -ne 'physical' -or $physicalPointer.status -ne 'success' -or $physicalPointer.runId -ne $PhysicalRunId){ throw 'Latest successful physical pointer does not match requested PhysicalRunId.' }
$synthesisPointer=Get-Content -LiteralPath (Join-Path $evidence 'latest_synthesis.json') -Raw | ConvertFrom-Json
if($synthesisPointer.stage -ne 'synthesis' -or $synthesisPointer.status -ne 'success' -or $synthesisPointer.runId -ne $RunId){ throw 'Latest successful synthesis pointer does not match requested RunId.' }
$physicalRecord=Get-Content -LiteralPath (Join-Path $evidence $physicalPointer.record) -Raw | ConvertFrom-Json
if($physicalRecord.synthesisRunId -ne $RunId){ throw 'Selected physical record is not linked to requested synthesis RunId.' }
$routed=Join-Path $audit 'routed_implementation.v'
if(!(Test-Path -LiteralPath $routed)){ throw "Missing parent-exported routed netlist: $routed" }
& python (Join-Path $audit 'audit_rom_controls.py') --run-id $RunId --kind routed --netlist $routed --output (Join-Path $audit 'routed_rom_control.json')
if($LASTEXITCODE -ne 0){ throw 'Strict routed ROM control audit did not produce a bound report.' }
& python (Join-Path $PSScriptRoot 'audit_current_routed_rom_init.py') --run-id $RunId --physical-run-id $PhysicalRunId --netlist $routed --output (Join-Path $audit 'routed_rom_init.json')
if($LASTEXITCODE -ne 0){ throw 'Selected-run routed ROM INIT audit failed.' }
& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'prove_current_routed_rom_polarity.ps1') -RunId $RunId -PhysicalRunId $PhysicalRunId
if($LASTEXITCODE -ne 0){ throw 'Exhaustive routed ROM control proof failed.' }
& python (Join-Path $audit 'audit_clock_route.py') --run-id $RunId --netlist $routed --timing $TimingPath --output (Join-Path $audit 'routed_clock_audit.md')
if($LASTEXITCODE -ne 0){ throw 'C11317 routed clock/pad audit failed.' }
$clock=Get-Content -LiteralPath (Join-Path $audit 'routed_clock_audit.json') -Raw | ConvertFrom-Json
if($clock.status -ne 'PASS'){ throw 'Routed clock/pad audit report is not PASS.' }
$clockPasses=@($clock.checks | Where-Object { $_[0] -eq 'PASS' }).Count
$clockWarnings=@($clock.checks | Where-Object { $_[0] -eq 'WARN' }).Count
$clockFailures=@($clock.checks | Where-Object { $_[0] -eq 'FAIL' }).Count
if($clockPasses -ne 45 -or $clockWarnings -ne 0 -or $clockFailures -ne 0){ throw "Clock/pad audit: $clockPasses PASS, $clockWarnings WARN, $clockFailures FAIL." }
$rom=Get-Content -LiteralPath (Join-Path $audit 'routed_rom_init.json') -Raw | ConvertFrom-Json
if($rom.status -ne 'PASS' -or $rom.logical_rom_words -ne 1536 -or $rom.lane_entries -ne 3072){ throw 'Routed ROM initialization report failed or has unexpected logical/lane entry counts.' }
$proof=Get-Content -LiteralPath (Join-Path $audit 'routed_rom_control_proof.json') -Raw | ConvertFrom-Json
if($proof.status -ne 'PASS'){ throw 'Routed ROM control proof report is not PASS.' }
$rows=0
foreach($bank in $proof.netlists.routed.banks.PSObject.Properties){ foreach($port in $bank.Value.port_proofs){ $rows += $port.truth_table.Count; if($port.truth_table.Count -ne 32 -or !$port.passes){ throw "Routed control proof failed for $($bank.Name).$($port.port)." } } }
if($rows -ne 192){ throw "Expected 192 routed truth rows, found $rows." }
Write-Output "C11317_ROUTED_AUDIT PASS runId=$RunId physicalRunId=$PhysicalRunId controls=$rows clockChecks=45"
