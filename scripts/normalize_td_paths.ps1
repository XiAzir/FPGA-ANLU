# Run after direct TD GUI/Tcl saves, before committing the portable main branch.
[CmdletBinding(SupportsShouldProcess)]
param()
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'anlu_tools.ps1')
$changed = 0
foreach ($directory in @('bringup', 'development')) {
    $source = Join-Path $AnluRepositoryRoot $directory
    foreach ($projectFile in Get-ChildItem -LiteralPath $source -Recurse -File -Filter '*.al') {
        $relative = [IO.Path]::GetRelativePath($AnluRepositoryRoot, $projectFile.FullName)
        # Timestamped system-verification projects are archived synthesis inputs.
        if ($relative -match '^development[\\/]system_verification_[^\\/]+[\\/]') { continue }
        if ($relative -match '(^|[\\/])(build|checkpoints|tools|tmp|[^\\/]*_Runs)([\\/]|$)') { continue }
        if ((Get-AnluProjectLocation $projectFile.FullName) -eq '.') { continue }
        if ($PSCmdlet.ShouldProcess($relative, 'Restore only the root Project Path attribute to .')) {
            Restore-AnluProjectLocation $projectFile.FullName '.'
            $changed++
        }
    }
}
Write-Output "Normalized $changed live TD project location(s)."
