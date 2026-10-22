$ErrorActionPreference = 'Stop'
$repoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../../../..'))
. (Join-Path $repoRoot 'scripts/anlu_tools.ps1')
$iverilog = Resolve-AnluTool -Name 'iverilog'
$vvp = Resolve-AnluTool -Name 'vvp'
$jpegRoot = Join-Path $PSScriptRoot '../candidate/src/user_source/hdl_source/jpeg'
$hexPath = Join-Path $PSScriptRoot 'frame_000.hex'
$jpgPath = Join-Path $PSScriptRoot 'frame_000.jpg'
$jpgBytes = [IO.File]::ReadAllBytes($jpgPath)
$markerIndex = 2
$frameInfo = $null
while ($markerIndex + 8 -lt $jpgBytes.Length) {
    while ($markerIndex -lt $jpgBytes.Length -and $jpgBytes[$markerIndex] -eq 0xff) { $markerIndex++ }
    if ($markerIndex -ge $jpgBytes.Length) { break }
    $marker = $jpgBytes[$markerIndex]
    $markerIndex++
    if ($marker -eq 0xd8 -or $marker -eq 0xd9 -or ($marker -ge 0xd0 -and $marker -le 0xd7)) { continue }
    $segmentLength = ($jpgBytes[$markerIndex] -shl 8) -bor $jpgBytes[$markerIndex + 1]
    if ($marker -eq 0xc0) {
        $height = ([int]$jpgBytes[$markerIndex + 3] -shl 8) -bor [int]$jpgBytes[$markerIndex + 4]
        $width = ([int]$jpgBytes[$markerIndex + 5] -shl 8) -bor [int]$jpgBytes[$markerIndex + 6]
        $components = $jpgBytes[$markerIndex + 7]
        $ySampling = $jpgBytes[$markerIndex + 9]
        $frameInfo = [pscustomobject]@{ Width=$width; Height=$height; Components=$components; YSampling=$ySampling }
        break
    }
    $markerIndex += $segmentLength
}
if (!$frameInfo -or $frameInfo.Width -ne 640 -or $frameInfo.Height -ne 480 -or $frameInfo.Components -ne 3 -or $frameInfo.YSampling -ne 0x22) {
    throw "Fixture is not the required 640x480 baseline 4:2:0 JPEG: $frameInfo"
}
$hexLines = foreach ($value in $jpgBytes) { '{0:x2}' -f $value }
[IO.File]::WriteAllLines($hexPath, $hexLines)
$tbPath = Join-Path $PSScriptRoot 'tb_jpeg_profile_diff.v'
$outputPath = Join-Path $PSScriptRoot 'tb_jpeg_profile_diff.vvp'
$sources = @(Get-ChildItem -LiteralPath $jpegRoot -Filter '*.v' -File | Sort-Object Name | ForEach-Object FullName)
Push-Location $PSScriptRoot
try {
    & $iverilog -g2012 -s tb_jpeg_profile_diff -o $outputPath @sources $tbPath
    if ($LASTEXITCODE -ne 0) { throw "iverilog failed with exit code $LASTEXITCODE" }
    & $vvp $outputPath
    if ($LASTEXITCODE -ne 0) { throw "vvp failed with exit code $LASTEXITCODE" }
} finally {
    Pop-Location
}
