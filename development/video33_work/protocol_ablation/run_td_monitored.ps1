param([Parameter(Mandatory=$true)][ValidateSet('A','B')][string]$Variant,[int]$TimeoutMinutes=60)
$ErrorActionPreference='Stop'
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$case=Join-Path $root $Variant
$script=Join-Path $case 'scripts/build_synth_map.tcl'
$td='C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/bin/td_commands_prompt.exe'
$log=Join-Path $case "build/manual/td_${Variant}_synth_map.log"
$memoryLog=Join-Path $case "build/manual/td_${Variant}_memory.csv"
$psi=[Diagnostics.ProcessStartInfo]::new()
$psi.FileName=$td; $psi.WorkingDirectory=$case; $psi.UseShellExecute=$false; $psi.CreateNoWindow=$true
$psi.RedirectStandardInput=$true; $psi.RedirectStandardOutput=$true; $psi.RedirectStandardError=$true
$p=[Diagnostics.Process]::new(); $p.StartInfo=$psi; $sw=[Diagnostics.Stopwatch]::StartNew(); $null=$p.Start()
$outTask=$p.StandardOutput.ReadToEndAsync(); $errTask=$p.StandardError.ReadToEndAsync()
$p.StandardInput.WriteLine("source {$script}"); $p.StandardInput.WriteLine('exit'); $p.StandardInput.Close()
$peakWS=0L; $peakPrivate=0L; $overLimit=$false; $timedOut=$false
[IO.File]::WriteAllText($memoryLog,"utc,working_set_mib,private_mib`n",[Text.Encoding]::ASCII)
while(-not $p.WaitForExit(1000)) {
  $p.Refresh(); if($p.WorkingSet64 -gt $peakWS){$peakWS=$p.WorkingSet64}; if($p.PrivateMemorySize64 -gt $peakPrivate){$peakPrivate=$p.PrivateMemorySize64}
  [IO.File]::AppendAllText($memoryLog,"$([DateTime]::UtcNow.ToString('o')),$([Math]::Round($p.WorkingSet64/1MB,1)),$([Math]::Round($p.PrivateMemorySize64/1MB,1))`n")
  if($p.WorkingSet64 -gt 1GB -or $p.PrivateMemorySize64 -gt 1GB){$overLimit=$true; break}
  if($sw.Elapsed -gt [TimeSpan]::FromMinutes($TimeoutMinutes)){$timedOut=$true; break}
}
if($overLimit -or $timedOut){ try{$p.Kill()}catch{} }
$p.WaitForExit(); $p.Refresh(); if($p.WorkingSet64 -gt $peakWS){$peakWS=$p.WorkingSet64}; if($p.PrivateMemorySize64 -gt $peakPrivate){$peakPrivate=$p.PrivateMemorySize64}
$sw.Stop(); $result=$outTask.Result+$errTask.Result; [IO.File]::WriteAllText($log,$result,[Text.UTF8Encoding]::new($false))
[pscustomobject]@{Variant=$Variant;ExitCode=$p.ExitCode;TimedOut=$timedOut;Over1GiB=$overLimit;DurationSeconds=[Math]::Round($sw.Elapsed.TotalSeconds,1);PeakWorkingSetMiB=[Math]::Round($peakWS/1MB,1);PeakPrivateMiB=[Math]::Round($peakPrivate/1MB,1);Pid=$p.Id;Log=$log;MemorySamples=$memoryLog}|ConvertTo-Json -Compress
if($overLimit){throw 'TD process exceeded 1 GiB memory limit'}
if($timedOut){throw 'TD synthesis/mapping timeout'}
if($p.ExitCode -ne 0){throw "TD process exited $($p.ExitCode)"}
if($result -notmatch 'SYN_MAP_COMPLETE'){throw 'Synthesis/mapping completion marker missing'}