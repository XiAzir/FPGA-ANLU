param([switch]$RouteOnly)
$ErrorActionPreference='Stop'
$candidateRoot=(Resolve-Path (Join-Path $PSScriptRoot '../player_spectrum_ctrl18')).Path
$manualRoot=Join-Path $candidateRoot 'build/manual'
$auditRoot=Join-Path $candidateRoot 'build/audit'
$gateRoot=Join-Path $candidateRoot 'build/gate_verify'
$syn=(Get-Content -Raw (Join-Path $manualRoot 'stage_evidence/latest_synthesis.json')|ConvertFrom-Json)
$phy=(Get-Content -Raw (Join-Path $manualRoot 'stage_evidence/latest_physical.json')|ConvertFrom-Json)
if($syn.status -ne 'success' -or $phy.status -ne 'success'){throw 'Final implementation stages must succeed before audits'}
if(!$RouteOnly){
$fftManifestPath=Join-Path $gateRoot 'input_manifest.json'
$fftReady=$false
if(Test-Path -LiteralPath $fftManifestPath){
 $fftManifest=Get-Content -Raw -LiteralPath $fftManifestPath|ConvertFrom-Json
 $fftReady=($fftManifest.status -eq 'PASS' -and $fftManifest.synthesis_run_id -eq $syn.runId -and $fftManifest.gate_netlist_sha256 -eq (Get-FileHash (Join-Path $manualRoot 'AC201_tf_hdmi_gate.v')).Hash.ToLower())
}
if(!$fftReady){
 & pwsh -NoProfile -File (Join-Path $gateRoot 'run_fft_gate_verify.ps1') -RunId $syn.runId
 if($LASTEXITCODE -ne 0){throw 'Current gate FFT failed'}
}
& python (Join-Path $auditRoot 'audit_rom_controls.py') --run-id $syn.runId --kind gate --netlist (Join-Path $manualRoot 'AC201_tf_hdmi_gate.v') --output (Join-Path $auditRoot 'gate_rom_control.json')
if($LASTEXITCODE -ne 0){throw 'Strict gate audit report could not be produced'}
& python (Join-Path $gateRoot 'audit_current_gate_rom_init.py') --run-id $syn.runId
if($LASTEXITCODE -ne 0){throw 'Current gate ROM initialization failed'}
& pwsh -NoProfile -File (Join-Path $gateRoot 'prove_current_gate_rom_polarity.ps1') -RunId $syn.runId
if($LASTEXITCODE -ne 0){throw 'Gate effective control proof failed'}
& python (Join-Path $gateRoot 'adapt_current_normalized_control_proof.py') --run-id $syn.runId
if($LASTEXITCODE -ne 0){throw 'Normalized gate proof binding failed'}
}
$boundGate=Get-Content -Raw (Join-Path $gateRoot 'normalized_control_proof.json')|ConvertFrom-Json
if($boundGate.status -ne 'PASS' -or $boundGate.synthesis_run_id -ne $syn.runId -or $boundGate.gate_netlist_sha256 -ne (Get-FileHash (Join-Path $manualRoot 'AC201_tf_hdmi_gate.v')).Hash.ToLower()){throw 'Current successful gate binding required before route audit'}
$exportScript=(Join-Path $auditRoot 'export_routed_rom.tcl').Replace('\','/')
& 'C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/bin/td_commands_prompt.exe' $exportScript *> (Join-Path $auditRoot 'export_console.log')
if($LASTEXITCODE -ne 0 -or !(Select-String -LiteralPath (Join-Path $auditRoot 'export_console.log') -SimpleMatch 'ROUTE_ROM_EXPORT_COMPLETE_READ_ONLY' -Quiet)){throw 'Read-only routed export failed'}
& pwsh -NoProfile -File (Join-Path $gateRoot 'run_c11317_routed_audit.ps1') -RunId $syn.runId -PhysicalRunId $phy.runId -TimingPath (Join-Path $manualRoot 'AC201_tf_hdmi_pr.timing')
if($LASTEXITCODE -ne 0){throw 'Routed ROM/clock checks failed'}
Write-Output 'FINAL_GATE_ROUTE_AUDITS PASS'
