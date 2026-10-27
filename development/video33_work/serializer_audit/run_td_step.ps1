param(
    [Parameter(Mandatory=$true)][string]$CandidateDir,
    [Parameter(Mandatory=$true)][string]$TclScript,
    [int]$TimeoutMinutes = 60
)
$ErrorActionPreference = 'Stop'
$tdExe = 'C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\bin\td_commands_prompt.exe'
$candidatePath = (Resolve-Path -LiteralPath $CandidateDir).Path
$scriptPath = (Resolve-Path -LiteralPath (Join-Path $candidatePath "scripts\$TclScript")).Path
$manualDir = Join-Path $candidatePath 'build\manual'
New-Item -ItemType Directory -Force -Path $manualDir | Out-Null
$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$logPath = Join-Path $manualDir ("td_{0}_{1}.log" -f [IO.Path]::GetFileName($candidatePath),$stamp)
$info = [Diagnostics.ProcessStartInfo]::new()
$info.FileName = $tdExe
$info.WorkingDirectory = $candidatePath
$info.UseShellExecute = $false
$info.CreateNoWindow = $true
$info.RedirectStandardInput = $true
$info.RedirectStandardOutput = $true
$info.RedirectStandardError = $true
$proc = [Diagnostics.Process]::new()
$proc.StartInfo = $info
$timer = [Diagnostics.Stopwatch]::StartNew()
$null = $proc.Start()
$outTask = $proc.StandardOutput.ReadToEndAsync()
$errTask = $proc.StandardError.ReadToEndAsync()
$proc.StandardInput.WriteLine("source {$scriptPath}")
$proc.StandardInput.WriteLine('exit')
$proc.StandardInput.Close()
$peakWorkingSet = 0L
$peakPrivate = 0L
$timeout = [TimeSpan]::FromMinutes($TimeoutMinutes)
$timedOut = $false
while (-not $proc.WaitForExit(1000)) {
    $proc.Refresh()
    if ($proc.WorkingSet64 -gt $peakWorkingSet) { $peakWorkingSet = $proc.WorkingSet64 }
    if ($proc.PrivateMemorySize64 -gt $peakPrivate) { $peakPrivate = $proc.PrivateMemorySize64 }
    if ($timer.Elapsed -gt $timeout) {
        $timedOut = $true
        $proc.Kill()
        break
    }
}
$proc.WaitForExit()
$proc.Refresh()
if ($proc.WorkingSet64 -gt $peakWorkingSet) { $peakWorkingSet = $proc.WorkingSet64 }
if ($proc.PrivateMemorySize64 -gt $peakPrivate) { $peakPrivate = $proc.PrivateMemorySize64 }
$timer.Stop()
$logText = $outTask.Result + $errTask.Result
[IO.File]::WriteAllText($logPath,$logText,[Text.UTF8Encoding]::new($false))
[pscustomobject]@{
    Candidate = [IO.Path]::GetFileName($candidatePath)
    TclScript = $TclScript
    ExitCode = $proc.ExitCode
    TimedOut = $timedOut
    DurationSeconds = [Math]::Round($timer.Elapsed.TotalSeconds,1)
    PeakWorkingSetMiB = [Math]::Round($peakWorkingSet / 1MB,1)
    PeakPrivateMiB = [Math]::Round($peakPrivate / 1MB,1)
    ProcessId = $proc.Id
    ProcessExited = $proc.HasExited
    Log = $logPath
} | ConvertTo-Json -Compress
