param(
    [Parameter(Mandatory=$true)][ValidateSet(37,38)][int]$Version,
    [Parameter(Mandatory=$true)][ValidateSet('synthesis','physical','hold','bitstream')][string]$Stage
)
$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '../..')).Path
$candidate = Join-Path $repo "development/player_video${Version}_open_tx"
$manual = Join-Path $candidate 'build/manual'
$project = "AC201_video${Version}_open_tx"
$specs = @{
    synthesis = @('build_manual_syn.tcl', "C113${Version}_SYNTHESIS_COMPLETE", "${project}_gate.db")
    physical = @('build_manual_phy.tcl', "C113${Version}_PHYSICAL_COMPLETE", "${project}_pr.db")
    hold = @('fix_hold.tcl', "C113${Version}_HOLD_FIX_COMPLETE", "${project}_pr.db")
    bitstream = @('generate_bit.tcl', "C113${Version}_BITSTREAM_GENERATED", "${project}.bit")
}
$spec = $specs[$Stage]
$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$log = Join-Path $manual "${Stage}_${stamp}.log"
$sourceFiles = @(Get-ChildItem -LiteralPath (Join-Path $candidate 'src/user_source') -Recurse -File |
    Where-Object { $_.Extension -in '.v','.sv','.adc','.sdc','.ipc' }) +
    @(Get-Item -LiteralPath (Join-Path $candidate "src/td_project/${project}.al")) +
    @(Get-Item -LiteralPath (Join-Path $candidate "scripts/$($spec[0])"))
$sourceBinding = [ordered]@{}
foreach ($file in ($sourceFiles | Sort-Object FullName)) {
    $sourceBinding[$file.FullName.Substring($candidate.Length+1).Replace('\','/')] = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
}
$inputBinding = [ordered]@{}
if ($Stage -ne 'synthesis') {
    $inputName = if ($Stage -eq 'physical') { "${project}_gate.db" } else { "${project}_pr.db" }
    $inputPath = Join-Path $manual $inputName
    $inputBinding.path = $inputPath
    $inputBinding.sha256 = (Get-FileHash -LiteralPath $inputPath -Algorithm SHA256).Hash
}
$info = [Diagnostics.ProcessStartInfo]::new()
$info.FileName = 'C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/bin/td_commands_prompt.exe'
$info.WorkingDirectory = $candidate
$info.UseShellExecute = $false
$info.CreateNoWindow = $true
$info.RedirectStandardInput = $true
$info.RedirectStandardOutput = $true
$info.RedirectStandardError = $true
$proc = [Diagnostics.Process]::new()
$proc.StartInfo = $info
$timer = [Diagnostics.Stopwatch]::StartNew()
$null = $proc.Start()
$stdout = $proc.StandardOutput.ReadToEndAsync()
$stderr = $proc.StandardError.ReadToEndAsync()
$tcl = (Join-Path $candidate "scripts/$($spec[0])").Replace('\','/')
$proc.StandardInput.WriteLine("source {$tcl}")
$proc.StandardInput.WriteLine('exit')
$proc.StandardInput.Close()
$peakWs = 0L
$peakPrivate = 0L
while (-not $proc.WaitForExit(500)) {
    $proc.Refresh()
    $peakWs = [Math]::Max($peakWs, $proc.WorkingSet64)
    $peakPrivate = [Math]::Max($peakPrivate, $proc.PrivateMemorySize64)
}
$proc.WaitForExit()
$timer.Stop()
$output = $stdout.Result + $stderr.Result
[IO.File]::WriteAllText($log, $output, [Text.UTF8Encoding]::new($false))
$complete = $output.Contains($spec[1])
$artifact = Join-Path $manual $spec[2]
$result = [ordered]@{
    version = $Version
    stage = $Stage
    exit_code = $proc.ExitCode
    completion_token_found = $complete
    duration_seconds = [Math]::Round($timer.Elapsed.TotalSeconds, 3)
    peak_working_set_mib = [Math]::Round($peakWs / 1MB, 1)
    peak_private_mib = [Math]::Round($peakPrivate / 1MB, 1)
    process_id = $proc.Id
    process_exited = $proc.HasExited
    source_binding = $sourceBinding
    input_database = $inputBinding
    log = $log
    artifact = $artifact
}
if ($complete) {
    $result.artifact_sha256 = (Get-FileHash -LiteralPath $artifact -Algorithm SHA256).Hash
}
$result | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $manual "${Stage}_${stamp}.json") -Encoding utf8
[pscustomobject]$result | Select-Object version,stage,exit_code,completion_token_found,duration_seconds,peak_working_set_mib,process_exited,log | ConvertTo-Json -Compress
if ($proc.ExitCode -ne 0 -or -not $complete) { throw "C$Version $Stage failed; inspect $log" }
