# Dot-source this file from a path derived from $PSScriptRoot.
$AnluRepositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$AnluDocsRoot = [IO.Path]::GetFullPath((Join-Path $AnluRepositoryRoot '../FPGA-ANLU-docs'))

function Resolve-AnluTool {
    [CmdletBinding()]
    param([Parameter(Mandatory)][ValidateSet('iverilog', 'vvp', 'td_commands_prompt')][string]$Name)
    $variable = if ($Name -eq 'td_commands_prompt') { 'ANLU_TD_BIN' } else { 'ANLU_IVERILOG_BIN' }
    $configured = [Environment]::GetEnvironmentVariable($variable)
    $names = @("$Name.exe", $Name)
    if ($configured) {
        if (-not [IO.Path]::IsPathRooted($configured)) { throw "$variable must be an absolute bin directory: $configured" }
        foreach ($file in $names) {
            $candidate = Join-Path $configured $file
            if (Test-Path -LiteralPath $candidate -PathType Leaf) { return [IO.Path]::GetFullPath($candidate) }
        }
        throw "$Name was not found in $variable=$configured. Set $variable to the installed tool's bin directory."
    }
    foreach ($file in $names) {
        $command = Get-Command $file -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($command) { return $command.Source }
    }
    $fallback = if ($Name -eq 'td_commands_prompt') {
        'C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/bin'
    } else {
        Join-Path $AnluRepositoryRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin'
    }
    foreach ($file in $names) {
        $candidate = Join-Path $fallback $file
        if (Test-Path -LiteralPath $candidate -PathType Leaf) { return [IO.Path]::GetFullPath($candidate) }
    }
    throw "Required tool '$Name' is missing. Install it and set $variable to its absolute bin directory, or add it to PATH. Tool installations are not included in Git."
}

function Assert-AnluInputFile {
    param([Parameter(Mandatory)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Required input is missing: $Path. Generated .db files are excluded from Git. Rebuild the corresponding project or restore the exact original artifact required by its manifest; integrity checks cannot be skipped."
    }
}

function Get-AnluProjectLocation {
    param([Parameter(Mandatory)][string]$Path)
    Assert-AnluInputFile $Path
    # Byte-preserving read: only the XML root Path attribute is allowed to change.
    $text = [Text.Encoding]::Latin1.GetString([IO.File]::ReadAllBytes($Path))
    $match = [regex]::Match($text, '(<Project\b[^>]*\bPath=")([^"]*)(")')
    if (-not $match.Success) { throw "No Project Path attribute found in $Path" }
    return $match.Groups[2].Value
}

function Restore-AnluProjectLocation {
    param([Parameter(Mandatory)][string]$Path, [Parameter(Mandatory)][string]$OriginalAttribute)
    $text = [Text.Encoding]::Latin1.GetString([IO.File]::ReadAllBytes($Path))
    $pattern = [regex]::new('(<Project\b[^>]*\bPath=")([^"]*)(")')
    $match = $pattern.Match($text)
    if (-not $match.Success) { throw "TD removed the Project Path attribute from $Path" }
    $value = $match.Groups[2]
    if ($value.Value -ne $OriginalAttribute) {
        $restored = $text.Substring(0, $value.Index) + $OriginalAttribute + $text.Substring($value.Index + $value.Length)
        [IO.File]::WriteAllBytes($Path, [Text.Encoding]::Latin1.GetBytes($restored))
    }
}
