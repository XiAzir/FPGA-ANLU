param(
    [string]$TargetPath = (Join-Path $PSScriptRoot '..\..\..\player_spectrum_resource_80\src\user_source\hdl_source\tf_wav_file_player.v')
)
$ErrorActionPreference = 'Stop'
$sourcePath = Join-Path $PSScriptRoot 'tf_wav_file_player_v2.v'
$expectedBase = 'EF77371DBC8928AE6CDD3708B4FC555F253F0E6C727333AFFF9527416DADE082'
$expectedCandidate = '6BAA637832CD6CE4722803B6C8A0C0D2ABD9706A192A2F15F7107D201993CBF9'
$target = (Resolve-Path -LiteralPath $TargetPath).Path
$baseHash = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToUpperInvariant()
$sourceHash = (Get-FileHash -LiteralPath $sourcePath -Algorithm SHA256).Hash.ToUpperInvariant()
if ($baseHash -ne $expectedBase) { throw "Target baseline hash changed: $baseHash" }
if ($sourceHash -ne $expectedCandidate) { throw "Frozen v2 hash changed: $sourceHash" }
Copy-Item -LiteralPath $sourcePath -Destination $target -Force
$resultHash = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToUpperInvariant()
if ($resultHash -ne $expectedCandidate) { throw "Applied file hash mismatch: $resultHash" }
Write-Output "Applied WAV v2. SHA256=$resultHash"
