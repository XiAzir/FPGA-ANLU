param(
    [Parameter(Mandatory=$true)][string]$CodeRoot,
    [Parameter(Mandatory=$true)][string]$DocsRoot
)
# Read-only preflight. No clone, checkout, reset, write, hardware command, network calls.
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
if (!(Test-Path -LiteralPath $CodeRoot -PathType Container)) { throw "CodeRoot missing: $CodeRoot" }
if (!(Test-Path -LiteralPath $DocsRoot -PathType Container)) { throw "DocsRoot missing: $DocsRoot" }
$code = (Resolve-Path -LiteralPath $CodeRoot).Path
$docs = (Resolve-Path -LiteralPath $DocsRoot).Path
foreach ($pair in @(@('engineering', $code), @('documentation', $docs))) {
    $label = $pair[0]; $root = $pair[1]
    Write-Output "`n[$label] $root"
    if (!(Test-Path -LiteralPath (Join-Path $root 'AGENTS.md'))) { throw "Missing $label AGENTS.md" }
    $rootFromGit = (& git -C $root rev-parse --show-toplevel 2>&1)
    if ($LASTEXITCODE -ne 0) { throw "Not a Git repository: $root" }
    Write-Output "git root: $rootFromGit"
    Write-Output "branch: $(& git -C $root branch --show-current)"
    Write-Output "commit: $(& git -C $root rev-parse HEAD)"
    Write-Output 'git status --short:'
    & git -C $root status --short
}
Write-Output "`n[engineering historic artifacts]"
foreach($file in @(
    'development/player_bmp_scale/build/manual/AC201_tf_hdmi_phy.area',
    'development/player_spectrum_trace/build/manual/AC201_tf_hdmi_phy.area',
    'development/player_spectrum_trace/build/manual/AC201_tf_hdmi_phy.ts',
    'development/player_spectrum_trace/scripts/build_candidate.ps1',
    'development/player_spectrum_trace/src/user_source/hdl_source/fat32_catalog.v',
    'development/player_spectrum_trace/src/user_source/hdl_source/player_spectrum_analyzer.v'
)) {
    $found = Test-Path -LiteralPath (Join-Path $code $file) -PathType Leaf
    $status = if($found) { 'FOUND' } else { 'MISSING' }
    Write-Output "$status $file"
}
Write-Output "`n[executables]"
foreach($command in @('git','pwsh','python','py','iverilog','vvp','vsim','td_commands_prompt')) {
    $found = Get-Command $command -ErrorAction SilentlyContinue
    if($null -ne $found) { Write-Output ("FOUND $command : " + $found.Source) }
    else { Write-Output "NOT_IN_PATH $command (may be installed elsewhere)" }
}
Write-Output "`n[configured environment]"
foreach($key in @('ANLU_TD_BIN','ANLU_IVERILOG_BIN')) {
    $value=[Environment]::GetEnvironmentVariable($key)
    if([string]::IsNullOrWhiteSpace($value)) { Write-Output "$key : not set" }
    else { Write-Output "$key : $value" }
}
Write-Output "`nPreflight is read-only. Inspect both AGENTS.md before writing."
