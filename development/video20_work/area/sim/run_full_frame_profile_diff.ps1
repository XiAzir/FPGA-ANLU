$ErrorActionPreference = 'Stop'
$repoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../../../..'))
. (Join-Path $repoRoot 'scripts/anlu_tools.ps1')
$iverilog = Resolve-AnluTool -Name 'iverilog'
$vvp = Resolve-AnluTool -Name 'vvp'
$jpegRoot = Join-Path $PSScriptRoot '../candidate/src/user_source/hdl_source/jpeg'
$tbPath = Join-Path $PSScriptRoot 'tb_jpeg_core_profile.sv'
$jpegPath = Join-Path $PSScriptRoot 'input_frame_0.jpg'
$sources = @(Get-ChildItem -LiteralPath $jpegRoot -Filter '*.v' -File | Sort-Object Name | ForEach-Object FullName)
$runs = @(
    @{ Name='baseline'; Define=@() },
    @{ Name='fixed_profile'; Define=@('-DPROFILE_FIXED') }
)
Push-Location $PSScriptRoot
try {
    foreach ($run in $runs) {
        $binary = Join-Path $PSScriptRoot ("jpeg_core_" + $run.Name + '.vvp')
        $pixels = Join-Path $PSScriptRoot ("pixels_" + $run.Name + '.bin')
        $log = Join-Path $PSScriptRoot ("run_" + $run.Name + '.log')
        & $iverilog -g2012 @($run.Define) -s tb_jpeg_core -o $binary @sources $tbPath
        if ($LASTEXITCODE -ne 0) { throw "iverilog failed for $($run.Name): $LASTEXITCODE" }
        & $vvp $binary "+JPEG=$jpegPath" "+OUT=$pixels" "+LOG=$log" '+MODE=0' '+GAP=0' '+SEED=324508639' '+FRAMES=1' '+WIDTH=640' '+HEIGHT=480'
        if ($LASTEXITCODE -ne 0) { throw "vvp failed for $($run.Name): $LASTEXITCODE" }
        $runResult = Get-Content -Raw -LiteralPath $log
        if ($runResult -notmatch 'pixels=307200 .*duplicate_coords=0 bad_coords=0 width=640 height=480 idle=1') {
            throw "Full-frame completion gate failed for $($run.Name): $runResult"
        }
    }
    $basePath = Join-Path $PSScriptRoot 'pixels_baseline.bin'
    $fixedPath = Join-Path $PSScriptRoot 'pixels_fixed_profile.bin'
    $baseInfo = Get-Item -LiteralPath $basePath
    $fixedInfo = Get-Item -LiteralPath $fixedPath
    $baseHash = (Get-FileHash -LiteralPath $basePath -Algorithm SHA256).Hash
    $fixedHash = (Get-FileHash -LiteralPath $fixedPath -Algorithm SHA256).Hash
    if ($baseInfo.Length -ne $fixedInfo.Length -or $baseHash -ne $fixedHash) {
        throw "Full-frame pixel stream differs: baseline bytes/hash $($baseInfo.Length)/$baseHash, fixed bytes/hash $($fixedInfo.Length)/$fixedHash"
    }
    Write-Output "PASS: baseline/profile each emitted 307200 unique in-bounds pixels and reached idle=1; pixel stream SHA256=$baseHash"
} finally {
    Pop-Location
}
