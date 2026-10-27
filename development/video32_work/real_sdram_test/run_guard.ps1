$ErrorActionPreference = 'Stop'
$testDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$modelsimBin = 'E:\ModelsimSE\win64'
$modelsimIni = Join-Path $testDir 'modelsim.ini'
$runDo = Join-Path $testDir 'run.do'
$runLog = Join-Path $testDir 'run.log'
$reportPath = Join-Path $testDir 'resource_trace.jsonl'
$vsimExe = Join-Path $modelsimBin 'vsim.exe'

Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
[StructLayout(LayoutKind.Sequential, CharSet=CharSet.Auto)]
public class MEMORYSTATUSEX {
  public uint dwLength = (uint)Marshal.SizeOf(typeof(MEMORYSTATUSEX));
  public uint dwMemoryLoad;
  public ulong ullTotalPhys, ullAvailPhys, ullTotalPageFile, ullAvailPageFile;
  public ulong ullTotalVirtual, ullAvailVirtual, ullAvailExtendedVirtual;
}
public static class HostMemory {
  [DllImport("kernel32.dll", CharSet=CharSet.Auto, SetLastError=true)]
  public static extern bool GlobalMemoryStatusEx([In,Out] MEMORYSTATUSEX buffer);
  public static double AvailableGiB() {
    var m = new MEMORYSTATUSEX();
    if (!GlobalMemoryStatusEx(m)) throw new System.ComponentModel.Win32Exception();
    return m.ullAvailPhys / 1073741824.0;
  }
  public static uint LoadPercent() {
    var m = new MEMORYSTATUSEX();
    if (!GlobalMemoryStatusEx(m)) throw new System.ComponentModel.Win32Exception();
    return m.dwMemoryLoad;
  }
}
'@

$before = [HostMemory]::AvailableGiB()
$load = [HostMemory]::LoadPercent()
"$(Get-Date -Format o) PRE_RUN available_GiB=$([math]::Round($before,3)) load_percent=$load" | Add-Content -LiteralPath $reportPath
if ($before -lt 2.0) { throw "Pre-run gate: available memory $([math]::Round($before,3)) GiB is below 2 GiB." }

$args = @('-c','-modelsimini',$modelsimIni,'-L','eg4','-do',$runDo,'-l',$runLog,'work.tb_real_sdram_frame_buffer')
$sim = Start-Process -FilePath $vsimExe -ArgumentList $args -WorkingDirectory $testDir -WindowStyle Hidden -PassThru
$stoppedByGuard = $false
while ($true) {
    Start-Sleep -Seconds 2
    $sim.Refresh()
    $available = [HostMemory]::AvailableGiB()
    $load = [HostMemory]::LoadPercent()
    $simProcesses = @(Get-Process -Name vsim,vsimk -ErrorAction SilentlyContinue)
    $maxRss = 0.0
    foreach ($proc in $simProcesses) {
        $rss = $proc.WorkingSet64 / 1GB
        if ($rss -gt $maxRss) { $maxRss = $rss }
    }
    "$(Get-Date -Format o) RUN available_GiB=$([math]::Round($available,3)) load_percent=$load max_sim_rss_GiB=$([math]::Round($maxRss,3)) sim_pids=$($simProcesses.Id -join ',')" | Add-Content -LiteralPath $reportPath
    if ($available -lt 1.5 -or $maxRss -gt 1.0) {
        $stoppedByGuard = $true
        foreach ($proc in $simProcesses) { Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue }
        break
    }
    if ($sim.HasExited) { break }
}
$sim.Refresh()
if ($stoppedByGuard) {
    "$(Get-Date -Format o) STOPPED_BY_GUARD exit=$($sim.ExitCode)" | Add-Content -LiteralPath $reportPath
    exit 124
}
"$(Get-Date -Format o) FINISHED exit=$($sim.ExitCode)" | Add-Content -LiteralPath $reportPath
exit $sim.ExitCode
