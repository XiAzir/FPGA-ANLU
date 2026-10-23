[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..\..'))
. (Join-Path $root 'scripts\anlu_tools.ps1')
$iverilog = Resolve-AnluTool -Name iverilog
$vvp = Resolve-AnluTool -Name vvp
$tb = Join-Path $PSScriptRoot 'tb_photo_regression.v'
$outDir = $PSScriptRoot
$cases = @(
    @{ Name='photo16'; Width=16; Height=16 },
    @{ Name='photo640x480'; Width=640; Height=480 }
)
$variants = @(
    @{ Name='C27'; Source=(Join-Path $root 'development\player_video27_command_boundary\src\user_source\hdl_source') },
    @{ Name='C28'; Source=(Join-Path $root 'development\player_video28_hdmi_observe\src\user_source\hdl_source') }
)
$results = @()

foreach ($case in $cases) {
    foreach ($variant in $variants) {
        $tag = "$($variant.Name)-$($case.Name)"
        $image = Join-Path $outDir "$tag.vvp"
        $log = Join-Path $outDir "$tag.log"
        $args = @('-g2012','-s','tb_photo_regression',"-Ptb_photo_regression.SRC_WIDTH=$($case.Width)","-Ptb_photo_regression.SRC_HEIGHT=$($case.Height)")
        if ($variant.Name -eq 'C28') { $args += '-DCANDIDATE' }
        $args += @('-o',$image,$tb,(Join-Path $variant.Source 'tf_bmp_file_player.v'),(Join-Path $variant.Source 'bmp_scale_engine.v'))
        & $iverilog @args
        if ($LASTEXITCODE -ne 0) { throw "Icarus compile failed for $tag (exit $LASTEXITCODE)" }
        & $vvp $image 2>&1 | Tee-Object -FilePath $log
        if ($LASTEXITCODE -ne 0) { throw "Icarus simulation failed for $tag (exit $LASTEXITCODE)" }
        $line = Get-Content -LiteralPath $log | Where-Object { $_ -match '^RESULT ' } | Select-Object -Last 1
        if (-not $line) { throw "Missing RESULT line for $tag" }
        $record = [ordered]@{ variant=$variant.Name; case=$case.Name; log=$log }
        foreach ($pair in [regex]::Matches($line,'(\w+)=([0-9a-fA-F]+)')) {
            $value = $pair.Groups[2].Value
            $key = $pair.Groups[1].Value
            if ($key -match 'crc|debug') { $record[$key]=$value.ToLowerInvariant() }
            else { $record[$key]=[int64]$value }
        }
        $results += [pscustomobject]$record
    }
}

$comparisons = @()
foreach ($case in $cases) {
    $base = $results | Where-Object { $_.variant -eq 'C27' -and $_.case -eq $case.Name }
    $cand = $results | Where-Object { $_.variant -eq 'C28' -and $_.case -eq $case.Name }
    foreach ($field in @('width','height','file_size','writes','cycles','reads','ready_stalls','pixel_crc','cycle_crc')) {
        if ($base.$field -ne $cand.$field) { throw "$($case.Name) mismatch on ${field}: C27=$($base.$field), C28=$($cand.$field)" }
    }
    $comparisons += [pscustomobject]@{ case=$case.Name; match=$true; compared_fields=@('width','height','file_size','writes','cycles','reads','ready_stalls','pixel_crc','cycle_crc') }
}

$summary = [ordered]@{
    schema='photo_regression.v1'
    generated_utc=[DateTime]::UtcNow.ToString('o')
    method='Icarus Verilog；C27 与 C28 分开运行并使用相同确定性刺激；未生成波形'
    stimulus=[ordered]@{ write_ready_bubble='每 67 周期插入 9 周期有界停顿'; card_valid_bubble='字节 valid 间插入确定性空隙'; source_pattern='按源图行列生成的非均匀 BGR24' }
    source=[ordered]@{
        c27=[ordered]@{ tf_sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $variants[0].Source 'tf_bmp_file_player.v')).Hash.ToLowerInvariant(); scaler_sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $variants[0].Source 'bmp_scale_engine.v')).Hash.ToLowerInvariant() }
        c28=[ordered]@{ tf_sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $variants[1].Source 'tf_bmp_file_player.v')).Hash.ToLowerInvariant(); scaler_sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $variants[1].Source 'bmp_scale_engine.v')).Hash.ToLowerInvariant() }
    }
    cases=$results
    comparisons=$comparisons
    payload_expectation=[ordered]@{ file_size=921654; payload_bytes=921600; payload_sectors=1801; total_sector_reads_including_header=1802 }
    scope='仅完成 Icarus 功能仿真，覆盖 16×16 与 640×480 交付图几何；未做 TD、ModelSim 或整机验证。现场 TF 首图几何仍未核验。'
}
$deliveryBmp = Join-Path $root 'development\player_bmp_scale\build\delivery\TF_ROOT\SCALE1.BMP'
if (Test-Path -LiteralPath $deliveryBmp -PathType Leaf) {
    $bmpBytes = [IO.File]::ReadAllBytes($deliveryBmp)
    $summary['delivery_image_header'] = [ordered]@{
        path=$deliveryBmp
        bytes=$bmpBytes.Length
        declared_size=[BitConverter]::ToUInt32($bmpBytes,2)
        pixel_offset=[BitConverter]::ToUInt32($bmpBytes,10)
        width=[BitConverter]::ToInt32($bmpBytes,18)
        height=[BitConverter]::ToInt32($bmpBytes,22)
        bits_per_pixel=[BitConverter]::ToUInt16($bmpBytes,28)
        compression=[BitConverter]::ToUInt32($bmpBytes,30)
        sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath $deliveryBmp).Hash.ToLowerInvariant()
        note='仅为交付备用 BMP 元数据；不代表当前 TF 卡首图。'
    }
}
$summaryPath = Join-Path $outDir 'summary.json'
$summary | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $summaryPath -Encoding utf8
Write-Output "PHOTO_REGRESSION_PASS summary=$summaryPath"
