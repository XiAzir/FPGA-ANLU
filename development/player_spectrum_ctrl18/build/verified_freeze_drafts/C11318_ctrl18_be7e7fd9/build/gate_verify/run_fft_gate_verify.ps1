param([Parameter(Mandatory)][string]$RunId)
$ErrorActionPreference = 'Stop'
$project = (Resolve-Path (Join-Path $PSScriptRoot '../../../..')).Path
$manual = Join-Path $project 'development/player_spectrum_ctrl18/build/manual'
$evidenceDir = Join-Path $manual 'stage_evidence'
$out = $PSScriptRoot
$markerPath = Join-Path $evidenceDir 'latest_synthesis.json'
$gate = Join-Path $manual 'AC201_tf_hdmi_gate.v'
$tbSource = Join-Path $out 'tb_fft_cone.v'
$vectors = Join-Path $project 'development/player_spectrum_ctrl18/sim/vectors'
$extractor = Join-Path $project 'development/regression_failed_releases_20261016/fft_netlist/attempt_4_boundary_outputs/extract_fft_used.py'
$vendorWork = Join-Path $project 'development/player_spectrum_fft_recover/build/board_feedback_no_signal_20261014/modelsim/work'
$modelsim = 'E:/ModelsimSE/win64'

if (!(Test-Path -LiteralPath $markerPath)) { throw "No synthesis marker: $markerPath" }
$latest = Get-Content -LiteralPath $markerPath -Raw | ConvertFrom-Json
if ($latest.stage -ne 'synthesis' -or $latest.status -ne 'success') {
    throw "Latest synthesis is not successful (stage=$($latest.stage), status=$($latest.status), runId=$($latest.runId))"
}
if ($latest.runId -ne $RunId) { throw "Requested synthesis runId $RunId differs from latest success $($latest.runId)" }
$recordPath = Join-Path $evidenceDir $latest.record
if (!(Test-Path -LiteralPath $recordPath)) { throw "Missing synthesis record: $recordPath" }
$record = Get-Content -LiteralPath $recordPath -Raw | ConvertFrom-Json
if ($record.stage -ne 'synthesis' -or $record.status -ne 'success' -or $record.runId -ne $latest.runId) {
    throw "Latest synthesis record does not match successful marker: $recordPath"
}
foreach ($path in @($gate,$tbSource,$vectors,$extractor,$vendorWork,"$modelsim/vlib.exe","$modelsim/vlog.exe","$modelsim/vsim.exe")) {
    if (!(Test-Path -LiteralPath $path)) { throw "Missing gate verification input: $path" }
}
$gateItem = Get-Item -LiteralPath $gate
if ($gateItem.Length -le 0) { throw "Latest gate netlist is empty: $gate" }
$started = [DateTime]::Parse($record.startedUtc).ToUniversalTime()
if ($gateItem.LastWriteTimeUtc -lt $started) { throw 'Gate netlist predates the latest successful synthesis run' }
$gateHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $gate).Hash.ToLower()
$markerHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $markerPath).Hash.ToLower()
$recordHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $recordPath).Hash.ToLower()
$synthesisLog = Join-Path $manual 'synthesis_console.log'
if (!(Test-Path -LiteralPath $synthesisLog)) { throw "Missing current synthesis log: $synthesisLog" }
$synthesisLogText = Get-Content -LiteralPath $synthesisLog -Raw
if ($synthesisLogText -notmatch 'SYNTHESIS_COMPLETE_WITH_GATE_DATABASE') { throw 'Current synthesis log lacks gate-database completion marker' }
$gateDb = Join-Path $manual 'AC201_tf_hdmi_gate.db'
if (!(Test-Path -LiteralPath $gateDb)) { throw "Missing gate database: $gateDb" }
$gateDbHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $gateDb).Hash.ToLower()
if ($gateDbHash -ne $record.gateDbHash) { throw 'Gate database hash differs from the successful synthesis record' }
$tbHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $tbSource).Hash.ToLower()
$extractorHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $extractor).Hash.ToLower()
$samplesHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $vectors 'all_samples.mem')).Hash.ToLower()
$expectedHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $vectors 'all_expected.mem')).Hash.ToLower()
$pythonHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $PSCommandPath).Hash.ToLower()
$manifest = [ordered]@{
    status='prepared'; scope='Actual current synthesis gate cone for u_pcm_waveform/u_spectrum; original EG4 primitive library; 3 PCM frames, 72 fixed-point-gold bands; no SDF; no whole-system startup/HDMI PHY.'
    synthesis_run_id=$latest.runId; synthesis_record=$recordPath; synthesis_record_sha256=$recordHash; latest_marker_sha256=$markerHash
    synthesis_script_hash=$record.scriptHash; synthesis_scope_hash=$record.scopeHash; synthesis_scripts=$record.scripts
    synthesis_log=$synthesisLog; synthesis_log_sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath $synthesisLog).Hash.ToLower()
    gate_database=$gateDb; gate_database_sha256=$gateDbHash
    gate_netlist=$gate; gate_netlist_sha256=$gateHash; gate_netlist_bytes=$gateItem.Length
    extractor=$extractor; extractor_sha256=$extractorHash; testbench_source=$tbSource; testbench_sha256=$tbHash
    runner=$PSCommandPath; runner_sha256=$pythonHash; samples_sha256=$samplesHash; expected_sha256=$expectedHash
    source_vector_directory=$vectors; requested_run_id=$RunId
}
$manifest | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $out 'input_manifest.json') -Encoding utf8

$extractOutput = & python $extractor --source $gate --out $out 2>&1
$extractOutput | Tee-Object -FilePath (Join-Path $out 'extract.log')
if ($LASTEXITCODE -ne 0) { throw 'Gate cone extraction failed; inspect extract.log' }
$coneManifest = Get-Content -LiteralPath (Join-Path $out 'cone_manifest.json') -Raw | ConvertFrom-Json
if ($coneManifest.unresolved.Count -ne 0) { throw 'Gate cone has unresolved nets' }
if ($coneManifest.primitive_counts.EG_PHY_BRAM -lt 1 -or $coneManifest.primitive_counts.EG_PHY_MULT18 -lt 1) {
    throw 'Gate cone is missing original BRAM or DSP primitives'
}
if (($coneManifest.instances -join "`n") -notmatch 'u_pcm_waveform/u_spectrum') { throw 'Extracted cone lacks u_pcm_waveform/u_spectrum instances' }

$ini = @"
[Library]
work = cone_work
c11310 = $($vendorWork.Replace('\','/'))
others = E:/ModelsimSE/modelsim.ini
"@
Set-Content -LiteralPath (Join-Path $out 'cone.ini') -Value $ini -Encoding ascii
$doText = @'
onerror {quit -code 2 -f}
onbreak {quit -code 3 -f}
run -all
quit -code 0 -f
'@
Set-Content -LiteralPath (Join-Path $out 'cone.do') -Value $doText -Encoding ascii
Push-Location $out
try {
    if (!(Test-Path -LiteralPath 'cone_work')) {
        & "$modelsim/vlib.exe" cone_work *> 'vlib.log'
        if ($LASTEXITCODE -ne 0) { throw 'ModelSim work library creation failed; inspect vlib.log' }
    }
    & "$modelsim/vlog.exe" -modelsimini cone.ini -work work fft_cone.v tb_fft_cone.v *> 'compile.log'
    if ($LASTEXITCODE -ne 0) { throw 'ModelSim compile failed; inspect compile.log' }
    $runOutput = & "$modelsim/vsim.exe" -modelsimini cone.ini -c -lic_noqueue -novopt -suppress 3017,3722 -L c11310 work.tb_fft_cone c11310.glbl "+VEC=$($vectors.Replace('\','/'))/all_samples.mem" "+EXP=$($vectors.Replace('\','/'))/all_expected.mem" -do cone.do -l run.log 2>&1
    $runOutput | Tee-Object -FilePath 'console.log'
    if ($LASTEXITCODE -ne 0) { throw 'ModelSim simulation failed; inspect console.log and run.log' }
    $runText = Get-Content -LiteralPath 'console.log' -Raw
    if ($runText -notmatch 'PASS fft_cone cases=3 bands=72 max_fixedpoint_error=0' -or $runText -match '# FAIL') {
        throw 'Gate FFT golden regression failed or did not reach PASS'
    }
} finally { Pop-Location }
$afterHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $gate).Hash.ToLower()
if ($afterHash -ne $gateHash) { throw 'Gate netlist changed during simulation; evidence is invalid' }
$manifest.status = 'PASS'
$manifest.cone_netlist_sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $out 'fft_cone.v')).Hash.ToLower()
$manifest.cone_primitive_counts = $coneManifest.primitive_counts
$manifest.gate_netlist_sha256_after = $afterHash
$manifest | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $out 'input_manifest.json') -Encoding utf8
Select-String -Path (Join-Path $out 'console.log') -Pattern 'BOUNDARY|CASE_RESULT|PASS fft_cone'
